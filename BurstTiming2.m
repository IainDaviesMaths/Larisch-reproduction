%Burst Timing Experiment 2
duration=600000;
beforeweights=zeros(1,41);
afterweights=zeros(1,41);
initw=0.4;

%Visual Cortex parameters
A_LTP=14*10^-5;
A_LTD=8*10^-5;
theta_plus=-45.3;
theta_minus=-70.6;
w_max=1;
w_min=0;
u_ref_square=60;
syn_par=[A_LTP A_LTD theta_plus theta_minus w_max w_min u_ref_square];

%Neuron parameters
tau_plus=7;
tau_minus=10;
tau_x=15;
neu_par=[tau_plus tau_minus tau_x];

%Before case
for ms=10:50
    
    pre_spike_train=zeros(1,duration);
    post_spike_train=zeros(1,duration);
    for I=0:59
        pre_spike_train(10000*I+110)=1;
        post_spike_train(10000*I+120)=1000000;
        post_spike_train(10000*I+120+ms)=1000000;
        post_spike_train(10000*I+120+2*ms)=1000000;
    end

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
        w(J) = synapse(w(J-1), u(J), umean_plus(J-3), umean_minus(J-3), u_bar_bar, x_bar(J), pre_spike_train(J), syn_par );
        x_bar(J+1)=x_bar(J)+(1/tau_x)*(pre_spike_train(J)-x_bar(J));
    end

    beforeweights(ms-9)=w(duration)*100/initw;
end

%After case
for ms=10:50
    pre_spike_train=zeros(1,duration);
    post_spike_train=zeros(1,duration);
    for I=0:59
        pre_spike_train(10000*I+120)=1;
        post_spike_train(10000*I+110)=1000000;
        post_spike_train(10000*I+110-ms)=1000000;
        post_spike_train(10000*I+110-2*ms)=1000000;
    end

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
        w(J) = synapse(w(J-1), u(J), umean_plus(J-3), umean_minus(J-3), u_bar_bar, x_bar(J), pre_spike_train(J), syn_par );
        x_bar(J+1)=x_bar(J)+(1/tau_x)*(pre_spike_train(J)-x_bar(J));
    end

    afterweights(ms-9)=w(duration)*100/initw;
end

Hz=1000./(10:50);
plot(Hz,beforeweights, Hz, afterweights)
xlabel('Frequency (Hz)')
ylabel('Normalized Weight (%)')
axis([20 100 25 275])
yticks(50:50:250)
title('Burst Timing Experiment 2')
saveas(gcf,'BurstTiming2.png')