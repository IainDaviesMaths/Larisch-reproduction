function [w_input_rec, w_ex_rec] = TemporalExcitatory(A_LTP, A_LTD)
%10 excitatory neurons connected all-to-all. 8 inhibitory neurons driven by
%8 excitatory neurons (chosen randomly) and projecting onto 6 excitatory
%neurons (chosen randomly). Feedforward inputs from 500 presynaptic neurons
%given regularly shifting gaussian input.
tic;

%Visual Cortex parameters
theta_plus=-45.3;
theta_minus=-70.6;
w_max=3;
w_min=0;
u_ref_square=80;
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

%Initialize spike train to input neurons. This needs to be moved every
%20ms
freq_min=0.0001;
freq_max=0.030;
sigma=10;
no_pres=500;
indices=linspace(1,500,500);
%Create a Gaussian spread which can be used to create the spike train every
%20ms
gau_spread=freq_min+freq_max*exp((-(indices-no_pres/2).^2)/(2*sigma^2));
%Two copies of the gaussian spread
gau_spread=[gau_spread gau_spread];
%Initialize spike train
spike_train=zeros(no_pres,20);
for t=1:20
    spike_train(:,t)=rand(1,no_pres)<gau_spread(201:700);
end

%Initialise excitatory neuron variables
u_ex=-70.6*ones(1,10); wad_ex=0*ones(1,10); z_ex=0*ones(1,10);
counter_ex=0*ones(1,10); V_T_ex=-50.4*ones(1,10);
umean_plus_ex=-70.6*ones(1,10); umean_minus_ex=-70.6*ones(1,10); 
u_bar_bar_ex=0*ones(1,10); x_bar_ex=0*ones(1,10); X_ex=0*ones(1,10);
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
        I_ex(ex_neu)=I_ex(ex_neu)+4*sum(w_input_ex(:,ex_neu).*spike_train(:,mod(time-1,20)+1));
        [u_ex(ex_neu),wad_ex(ex_neu),z_ex(ex_neu),counter_ex(ex_neu),V_T_ex(ex_neu),umean_plus_ex(ex_neu), umean_minus_ex(ex_neu), u_bar_bar_ex(ex_neu), x_bar_ex(ex_neu),X_ex(ex_neu)] = aEIFnet(u_ex(ex_neu),wad_ex(ex_neu),z_ex(ex_neu),I_ex(ex_neu),counter_ex(ex_neu),V_T_ex(ex_neu),umean_plus_ex(ex_neu), umean_minus_ex(ex_neu), u_bar_bar_ex(ex_neu), x_bar_ex(ex_neu), neu_par);
        I_ex(ex_neu)=0;
    end
    
    %Update inhibitory neurons
    for in_neu=1:3
        I_in(in_neu)=I_in(in_neu)+4*sum(w_input_in(:,in_neu).*spike_train(:,mod(time-1,20)+1));
        [u_in(in_neu),wad_in(in_neu),z_in(in_neu),counter_in(in_neu),V_T_in(in_neu),~,~,~,~,X_in(in_neu)] = aEIFnet(u_ex(ex_neu),wad_ex(ex_neu),z_ex(ex_neu),I_ex(ex_neu),counter_ex(ex_neu),V_T_ex(ex_neu),umean_plus_ex(ex_neu), umean_minus_ex(ex_neu), u_bar_bar_ex(ex_neu), x_bar_ex(ex_neu), neu_par);
        I_in(in_neu)=0;
    end
    
    %Update input synapses
    for pre=1:500
        x_bar_inp(pre)=x_bar_inp(pre)+(1/tau_x)*(spike_train(pre,mod(time-1,20)+1)-x_bar_inp(pre));
        %Input to ex connections
        for ex_neu=1:10
            [ w_input_ex(pre,ex_neu) ] = synapse(w_input_ex(pre,ex_neu), u_ex(ex_neu), umean_plus_ex(ex_neu), umean_minus_ex(ex_neu), u_bar_bar_ex(ex_neu), x_bar_inp(pre), spike_train(pre,mod(time-1,20)+1), syn_par_inp);
        end
    end
    
    %Update ex to ex synapses
    for pre_ex=1:10
        for post_ex=1:10
            if pre_ex~=post_ex
                I_ex(post_ex)=I_ex(post_ex)+4*w_ex_ex(pre_ex,post_ex)*X_ex(pre_ex);
                [ w_ex_ex(pre_ex,post_ex) ] = synapse(w_ex_ex(pre_ex,post_ex), u_ex(post_ex), umean_plus_ex(post_ex), umean_minus_ex(post_ex), u_bar_bar_ex(post_ex), x_bar_ex(pre_ex), X_ex(pre_ex), syn_par_ex );
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
            
    if mod(time,20)==0
        centre=(mod(time/20,10)+1)*50;
        start=mod(251-centre,500);
        for t=1:20
            spike_train(:,t)=rand(1,no_pres)<gau_spread(start:start+499);
        end
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