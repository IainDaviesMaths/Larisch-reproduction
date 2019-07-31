%STDP Frequency Experiment. 
frequency=[0.1 10 20 40 50];
weights=zeros(1,5);
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

%Generate spike train for the pre-synaptic neuron with a buffer of 11ms at
%the start in order to incorporate a post-synaptic spike before the
%pre-spike.
Dt=10;
count=1;
for Hz=frequency
    % Protocol of Sjoestroem et al. Neuron 2001: pre and post spike trains
    n = 5;                       % number of pairing 
    f = 1000/Hz;                % time between two pairs [ms]
    l = n*f+abs(Dt)+1;           % length of the spike trains
    pre_spike_train = zeros(1,l);              % presyn spike train
    pre_spike_train(abs(Dt)+1:f:end-1) = 1;
    post_spike_train = zeros(1,l);              % postsyn spike train
    post_spike_train(abs(Dt)+1+Dt:f:end) = 1000000;

    %Protocol: repetition at 0.1Hz
    rho_low = 0.1;
    n_rep = 15;
    if Hz == 0.1
        n_rep = 10;
    end
    pre_spike_train = repmat([pre_spike_train,zeros(1,1000/rho_low-length(pre_spike_train))],1,n_rep);
    post_spike_train = repmat([post_spike_train,zeros(1,1000/rho_low-length(post_spike_train))],1,n_rep);
    
    duration=length(pre_spike_train);
    
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
        w(J) = synapse(w(J-1), u(J), umean_plus(J-3), umean_minus(J-3), 60, x_bar(J), pre_spike_train(J), syn_par );
        x_bar(J+1)=x_bar(J)+(1/tau_x)*(pre_spike_train(J)-x_bar(J));
    end
    
    weights(count)=w(duration);
    count=count+1;
end

clf
plot(frequency,weights*100/initw)
hold on    
xlabel('Frequency (Hz)')
ylabel('Final Weight of Synapse (%)')

%Generate spike train for the pre-synaptic neuron with a buffer of 11ms at
%the start in order to incorporate a post-synaptic spike after the
%pre-spike.
Dt=-10;
count=1;
for Hz=frequency
    % Protocol of Sjoestroem et al. Neuron 2001: pre and post spike trains
    n = 5;                       % number of pairing 
    f = 1000/Hz;                % time between two pairs [ms]
    l = n*f+abs(Dt)+1;           % length of the spike trains
    pre_spike_train = zeros(1,l);              % presyn spike train
    pre_spike_train(abs(Dt)+1:f:end-1) = 1;
    post_spike_train = zeros(1,l);              % postsyn spike train
    post_spike_train(abs(Dt)+1+Dt:f:end) = 1000000;

    %Protocol: repetition at 0.1Hz
    rho_low = 0.1;
    n_rep = 15;
    if Hz == 0.1
        n_rep = 10;
    end
    pre_spike_train = repmat([pre_spike_train,zeros(1,1000/rho_low-length(pre_spike_train))],1,n_rep);
    post_spike_train = repmat([post_spike_train,zeros(1,1000/rho_low-length(post_spike_train))],1,n_rep);
    
    duration=length(pre_spike_train);
    
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
        w(J) = synapse(w(J-1), u(J), umean_plus(J-3), umean_minus(J-3), 60, x_bar(J), pre_spike_train(J), syn_par );
        x_bar(J+1)=x_bar(J)+(1/tau_x)*(pre_spike_train(J)-x_bar(J));
    end
    
    weights(count)=w(duration);
    count=count+1;
end

plot(frequency,weights*100/initw)
title('STDP Frequency Experiment')
saveas(gcf,'STDPFrequency.png')
    