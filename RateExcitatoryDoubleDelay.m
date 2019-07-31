function [w_input_rec, w_ex_rec] = RateExcitatoryDoubleDelay(A_LTP,A_LTD)
%Rate Excitatory
%10 excitatory neurons connected all-to-all. 8 inhibitory neurons driven by
%8 excitatory neurons (chosen randomly) and projecting onto 6 excitatory
%neurons (chosen randomly). Feedforward inputs from 500 presynaptic neurons
%given shifting gaussian input.
tic;

%Visual Cortex parameters
theta_plus=-45.3;
theta_minus=-70.6;
w_max=3;
w_min=0;
u_ref_square=60;
syn_par_inp=[A_LTP A_LTD theta_plus theta_minus w_max w_min u_ref_square];
syn_par_ex=[A_LTP A_LTD theta_plus theta_minus 0.75 w_min u_ref_square];

%Neuron parameters
tau_plus=7;
tau_minus=10;
tau_x=15;
neu_par=[tau_plus tau_minus tau_x];

%Initialise synapse weights
w_ex_ex=0.25*ones(10,10); %Hard bounds of 0 and 0.75 DEAL WITH
w_input_ex=0.5+1.5*rand(500,10); %Hard bounds of 0 and 3 DEAL WITH

w_ex_in=ones(10,3); %Fixed
w_in_ex=ones(3,10);%Fixed

w_input_in=0.5*rand(500,3); %Fixed

%Choose random connections
connect_ex_in=zeros(10,3);
connect_in_ex=zeros(3,10);
for in_neu=1:3
    connect_ex_in(:,in_neu)=ChooseRandom(8,10);
    connect_in_ex(in_neu,:)=ChooseRandom(6,10);
end

%Initialize spike train to input neurons. This needs to be reset every
%100ms
spike_train=gaussian_output2;

%Initialise excitatory neuron variables
u_ex=-70.6*ones(1,10); wad_ex=0*ones(1,10); z_ex=0*ones(1,10);
counter_ex=0*ones(1,10); V_T_ex=-50.4*ones(1,10);
umean_plus_ex=-70*ones(1,10); umean_minus_ex=-70*ones(1,10);
umean_plus_ex_d=-70*ones(1,10); umean_minus_ex_d=-70*ones(1,10);
umean_plus_ex_dd=-70*ones(1,10); umean_minus_ex_dd=-70*ones(1,10);
u_bar_bar_ex=0*ones(1,10); u_bar_bar_ex_d=0*ones(1,10);
u_bar_bar_ex_dd=0*ones(1,10);
x_bar_ex=0*ones(1,10); X_ex=0*ones(1,10);
I_ex=zeros(1,10);

%Initialise inhibitory neuron variables
u_in=-70.6*ones(1,3); wad_in=0*ones(1,3); z_in=0*ones(1,3);
counter_in=0*ones(1,3); V_T_in=-50.4*ones(1,3); X_in=zeros(1,3);
I_in=zeros(1,3);

%Initialise input synapse variables
x_bar_inp=zeros(1,500);
tau_x=15;

%Initialise arrays to record weights
w_input_rec=zeros(1000,500,10);
w_ex_rec=zeros(1000,10,10);

for time=1:10000*100
    
    %Update excitatory neurons
    for ex_neu=1:10
        I_ex(ex_neu)=I_ex(ex_neu)+4*sum(w_input_ex(:,ex_neu).*spike_train(:,mod(time-1,100)+1));
        [u_ex(ex_neu),wad_ex(ex_neu),z_ex(ex_neu),counter_ex(ex_neu),V_T_ex(ex_neu),umean_plus_ex(ex_neu), umean_minus_ex(ex_neu), u_bar_bar_ex(ex_neu), x_bar_ex(ex_neu),X_ex(ex_neu)] = aEIFnet(u_ex(ex_neu),wad_ex(ex_neu),z_ex(ex_neu),I_ex(ex_neu),counter_ex(ex_neu),V_T_ex(ex_neu),umean_plus_ex(ex_neu), umean_minus_ex(ex_neu), u_bar_bar_ex(ex_neu), x_bar_ex(ex_neu), neu_par);
        I_ex(ex_neu)=0;
    end
    
    %Update inhibitory neurons
    for in_neu=1:3
        I_in(in_neu)=I_in(in_neu)+4*sum(w_input_in(:,in_neu).*spike_train(:,mod(time-1,100)+1));
        [u_in(in_neu),wad_in(in_neu),z_in(in_neu),counter_in(in_neu),V_T_in(in_neu),~,~,~,~,X_in(in_neu)] = aEIFnet(u_ex(ex_neu),wad_ex(ex_neu),z_ex(ex_neu),I_ex(ex_neu),counter_ex(ex_neu),V_T_ex(ex_neu),umean_plus_ex(ex_neu), umean_minus_ex(ex_neu), u_bar_bar_ex(ex_neu), x_bar_ex(ex_neu), neu_par);
        I_in(in_neu)=0;
    end
    
    %Update input synapses
    for pre=1:500
        x_bar_inp(pre)=x_bar_inp(pre)+(1/tau_x)*(spike_train(pre,mod(time-1,100)+1)-x_bar_inp(pre));
        %Input to ex connections
        for ex_neu=1:10
            [ w_input_ex(pre,ex_neu) ] = synapse(w_input_ex(pre,ex_neu), u_ex(ex_neu), umean_plus_ex_dd(ex_neu), umean_minus_ex_dd(ex_neu), u_bar_bar_ex_dd(ex_neu), x_bar_inp(pre), spike_train(pre,mod(time-1,100)+1), syn_par_inp );
        end
    end
    
    %Update ex to ex synapses
    for pre_ex=1:10
        for post_ex=1:10
            if pre_ex~=post_ex
                I_ex(post_ex)=I_ex(post_ex)+4*w_ex_ex(pre_ex,post_ex)*X_ex(pre_ex);
                [ w_ex_ex(pre_ex,post_ex) ] = synapse(w_ex_ex(pre_ex,post_ex), u_ex(post_ex), umean_plus_ex_dd(post_ex), umean_minus_ex_dd(post_ex), u_bar_bar_ex_dd(post_ex), x_bar_ex(pre_ex), X_ex(pre_ex), syn_par_ex );
            end
        end
    end
    
    %Deal with spikes to/from inhibitory neurons
    for ex_neu=1:10
        for in_neu=1:3
            %Ex to in connections
            if connect_ex_in(ex_neu,in_neu)==1
                I_in(in_neu)=I_in(in_neu)+4*w_ex_in(ex_neu,in_neu)*X_ex(ex_neu);
            end
            %In to ex connections
            if connect_in_ex(in_neu,ex_neu)==1
                I_ex(ex_neu)=I_ex(ex_neu)-4*w_in_ex(in_neu,ex_neu)*X_in(in_neu);
            end
        end
    end
    
    %Update delayed potentials
    umean_plus_ex_dd=umean_plus_ex_d;
    umean_minus_ex_dd=umean_minus_ex_d;
    u_bar_bar_ex_dd=u_bar_bar_ex_d;
    umean_plus_ex_d=umean_plus_ex;
    umean_minus_ex_d=umean_minus_ex;
    u_bar_bar_ex_d=u_bar_bar_ex;
    
    %If it's a new 100ms then create new spike train.
    if mod(time,100)==0
        spike_train=gaussian_output2;
    end
    
    if mod(time,1000)==0
        w_input_rec(time/1000,:,:)=w_input_ex(:,:);
        w_ex_rec(time/1000,:,:)=w_ex_ex(:,:);
    end
end
% weights=weights';
% image([0 1000],[1 500],weights,'CDataMapping','scaled')
% xlabel('Epoch')
% ylabel('Neuron')
toc;

end