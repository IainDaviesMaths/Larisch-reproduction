%Voltage Clamp Experiment

%Visual Cortex

%Synapse parameters
A_LTP=8*10^-5;
A_LTD=14*10^-5;
theta_plus=-45.3;
theta_minus=-70.6;
w_max=2.5;
w_min=0;
u_ref_square=60;
parameters=[A_LTP A_LTD theta_plus theta_minus w_max w_min u_ref_square];

%Neuron Parameter
tau_x=15;

%Initialise spike train and simulation parameters. 25 pulses at 50Hz
Hz=50;
pulses=25;
duration=1000*pulses/Hz;
spike_train=zeros(1,duration);
weights=zeros(1,81);
volts=linspace(-80,0,81);

for I=0:pulses-1
    spike_train((1000/Hz)*I+1)=1;
end
%Simulate
count=1;
for u_clamp=volts
    w=1;
    x_bar=0;

    for time=1:duration
        w = synapse(w, u_clamp, u_clamp, u_clamp, 60, x_bar, spike_train(time),parameters);
        x_bar=x_bar+(1/tau_x)*(spike_train(time)-x_bar);
    end
    
    weights(count)=w;
    count=count+1;
end
clf
hold on
plot(volts,weights,'b--')
    
xlabel('Postsynaptic Membrane Voltage')
ylabel('Final Weight of Synapse')

%Hippocampal

%Synapse parameters
A_LTP=2*10^-5;
A_LTD=38*10^-5;
theta_plus=-38;
theta_minus=-41;
w_max=2.5;
w_min=0;
u_ref_square=60;
parameters=[A_LTP A_LTD theta_plus theta_minus w_max w_min u_ref_square];

%Neuron Parameter
tau_x=16;

%Initialise spike train and simulation parameters. 25 pulses at 50Hz
Hz=50;
pulses=100;
duration=1000*pulses/Hz;
spike_train=zeros(1,duration);
weights=zeros(1,81);
volts=linspace(-80,0,81);

for I=0:pulses-1
    spike_train((1000/Hz)*I+1)=1;
end
%Simulate
count=1;
for u_clamp=volts
    w=1;
    x_bar=0;

    for time=1:duration
        w = synapse(w, u_clamp, u_clamp, u_clamp, 60, x_bar, spike_train(time), parameters);
        x_bar=x_bar+(1/tau_x)*(spike_train(time)-x_bar);
    end
    
    weights(count)=w;
    count=count+1;
end
hold on
plot(volts,weights,'r')
title('Voltage Clamp Experiment')

saveas(gcf,'VoltageClamp.png')