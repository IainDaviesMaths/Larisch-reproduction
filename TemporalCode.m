function [w] = TemporalCode()
%Ten neurons all connected to each other. Each has an input spike
%train which makes it fire with Poisson distribution at different
%frequencies.
%Average Frequency is 2 * its position
initw=0.25;
%Visual Cortex parameters
A_LTP=8*10^-5;
A_LTD=14*10^-5;
theta_plus=-45.3;
theta_minus=-70.6;
w_max=3;
w_min=0;
u_ref_square=60;
syn_par=[A_LTP A_LTD theta_plus theta_minus w_max w_min u_ref_square];

%Neuron parameters
tau_plus=7;
tau_minus=10;
tau_x=15;
neu_par=[tau_plus tau_minus tau_x];

%Input spike train
spike_train=zeros(10,200000);
for I=0:999
    for J=1:10
        spike_train(J,I*200+20*(J-1)+1)=1000000;
    end
end

%Initialise neuron variables
u=-70.6*ones(1,10); wad=zeros(1,10); z=zeros(1,10);
counter=zeros(1,10); V_T=-50.4*ones(1,10); 
x_bar=zeros(1,10); x_bar_d=zeros(1,10); 
X=zeros(1,10);

%Initialise weights variables

w=initw*ones(10,10); 
umean_plus=-70.6*ones(1,10); umean_plus_d=-70.6*ones(1,10); 
umean_plus_dd=-70.6*ones(1,10); umean_plus_ddd=-70.6*ones(1,10);
umean_minus=-70.6*ones(1,10); umean_minus_d=-70.6*ones(1,10); 
umean_minus_dd=-70.6*ones(1,10); umean_minus_ddd=-70.6*ones(1,10);
u_bar_bar=zeros(1,10); u_bar_bar_d=zeros(1,10); 
u_bar_bar_dd=zeros(1,10); u_bar_bar_ddd=zeros(1,10);

for time=1:200000
    %Update neurons
    for neuron=1:10
        [u(neuron), wad(neuron),z(neuron),counter(neuron),V_T(neuron),umean_plus(neuron), umean_minus(neuron), u_bar_bar(neuron), x_bar(neuron),X(neuron)] = aEIFnet(u(neuron),wad(neuron),z(neuron),spike_train(neuron,time),counter(neuron),V_T(neuron),umean_plus(neuron), umean_minus(neuron), u_bar_bar(neuron), x_bar(neuron), neu_par);
    end
    
    %Update synapses
    for pre_neuron=1:10
        for post_neuron=1:10
            w(pre_neuron,post_neuron)=synapse(w(pre_neuron,post_neuron), u(post_neuron), umean_plus_ddd(post_neuron), umean_minus_ddd(post_neuron), u_bar_bar_ddd(post_neuron), x_bar_d(pre_neuron), X(pre_neuron), syn_par );
        end
    end
    
    %Update delayed potentials
    x_bar_d=x_bar;
    umean_minus_ddd=umean_minus_dd;
    umean_plus_ddd=umean_plus_dd;
    u_bar_bar_ddd=u_bar_bar_dd;
    umean_minus_dd=umean_minus_d;
    umean_plus_dd=umean_plus_d;
    u_bar_bar_dd=u_bar_bar_d;
    umean_minus_d=umean_minus;
    umean_plus_d=umean_plus;
    u_bar_bar_d=u_bar_bar;
end

end
