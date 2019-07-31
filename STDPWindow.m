%STDP Window Experiment
%Initialise simulation variables
duration=3000;
pre_spike_train=zeros(1,duration);
weights=zeros(1,31);
initw=0.5;

%Visual Cortex parameters
A_LTP=8*10^-5;
A_LTD=14*10^-5;
theta_plus=-45.3;
theta_minus=-70.6;
w_max=2.5;
w_min=0;
u_ref_square=60;
syn_par=[A_LTP A_LTD theta_plus theta_minus w_max w_min u_ref_square];

%Neuron parameters
tau_plus=7;
tau_minus=10;
tau_x=15;
neu_par=[tau_plus tau_minus tau_x];

%Generate spike train for the pre-synaptic neuron with a buffer of 24ms at
%the start in order to incorporate a post-synaptic spike before the
%pre-spike.
delta=50;
pre_spike_train(25:delta:25+59*delta)=1;

%Repeat for the post-synaptic spike happening between 1 and 15 ms before
%and after pre-synaptic spike.
for delay=1:31
    %Generate post-synaptic spike train.
    post_spike_train=zeros(1,duration);
    
    post_spike_train(delay+9:delta:delay+9+59*delta)=1000000;
    
    %Initialise neuron variables
    u=-70.6*ones(1,duration); wad=0*ones(1,duration); z=0*ones(1,duration);
    counter=0; V_T=-50.4*ones(1,1001); x_bar_post=0; X=zeros(1,duration);
    u_bar_bar_red=0;
    
    %Initialise weights variables
    w=initw*ones(1,duration); umean_plus=-70.6*ones(1,duration);
    umean_minus=-70.6*ones(1,duration); u_bar_bar=60; x_bar=zeros(1,duration);
    
    %Simulate.
    for J=4:duration
        [u(J), wad(J),z(J),counter,V_T(J),umean_plus(J+1), umean_minus(J+1), u_bar_bar_red, x_bar_post,X(J)] = aEIFnet(u(J-1),wad(J-1),z(J-1),post_spike_train(J),counter,V_T(J-1),umean_plus(J), umean_minus(J), u_bar_bar_red, x_bar_post, neu_par);
        w(J) = synapse(w(J-1), u(J), umean_plus(J-1), umean_minus(J-1), 60, x_bar(J), pre_spike_train(J), syn_par );
        x_bar(J+1)=x_bar(J)+(1/tau_x)*(pre_spike_train(J)-x_bar(J));
    end
    
    weights(delay)=w(duration);
end

time_delay=linspace(-15,15,31);
clf
plot([-15 15], [100 100],'k')
hold on
plot([0 0], [50 140],'k')
plot(time_delay(1:13),weights(1:13)*100/initw)
plot(time_delay(18:31),weights(18:31)*100/initw)
plot([time_delay(13) time_delay(18)],[weights(13) weights(18)]*100/initw,'Color',[.3 .3 .3])

    
xlabel('Delay')
ylabel('Final Weight of Synapse (%)')
title('STDP Window Experiment')
saveas(gcf,'STDPWindow.png')
    