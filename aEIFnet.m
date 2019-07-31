function [u, wad,z,counter,V_T,umean_plus, umean_minus, u_bar_bar, x_bar,X] = aEIFnet(u,wad,z,I,counter,V_T,umean_plus, umean_minus, u_bar_bar, x_bar,parameters)

% AEIFNET: Simulate adex model with spike after depolarization current and
% adaptive threshold, with addition of network variables
%
% Preconditions:
%  u            Membrane potential at time t
%  wad          Adaptation variable
%  z            Current for spike afterdepolarization
%  V_T          Adaptive threshold 
%  I            Input Current
% counter       Counter to force the spike to be clamped at the high value
%               for 2ms
% umean_plus      Filtered membrane potential, high pass
% umean_minus     Filtered membrane potential, low pass
% u_bar_bar       Filtered membrane potential for homeostatic mechanism
% x_bar           Spike trace from this neuron onto a synapse
% X               Flag for when the neuron spikes


% Model parameters
th = 20;        % [mV] spike threshold
C = 281;        % [pF] membrane capacitance
g_L = 30;       % [nS] membrane conductance
E_L = -70.6;    % [mV] resting voltage
VT_rest = -50.4;% [mV] resetting voltage
Delta_T = 2;    % [mV] exponential parameters
tau_wad = 144;    % [ms] time constant for adaptation variable w
a = 4;          % [nS] adaptation coupling constant
b = 0.085;       % [pA] spike triggered adaptation
w_jump = 400;   % spike after depolarisation
tau_z = 40; % [ms] time constant for spike after depolarisation
tau_VT = 50;    % [ms] time constant for VT
VT_jump = 20;   % adaptive threshold
%Synapse parameters
tau_plus=parameters(1);
tau_minus=parameters(2) ;
tau_x=parameters(3);
tau_u_bar=1200;

if counter ==2          % trick to force the spike to be 2ms long
    u = E_L+15+6.0984;  % resolution trick (simulation of the spike at a fine resolution - see below)
    wad = wad+b;
    z = w_jump;
    counter = 0;
    V_T = VT_jump+VT_rest;
end

% Updates of the variables for the aEIF
udot = 1/C*(-g_L*(u-E_L) + g_L*Delta_T*exp((u-V_T)/Delta_T) - wad +z)+ I;
wdot = 1/tau_wad*(a*(u-E_L) - wad);
u= u + udot;
wad = wad + wdot;
z = z-z/tau_z;
V_T = VT_rest/tau_VT+(1-1/tau_VT)*V_T;

if counter == 1
    counter = 2;
    u = 29.4+3.462; % resolution trick (simulation of the spike at a fine resolution - see below)
    wad = wad-wdot;
end

if (u>th && counter ==0) % threshold condition for the spike
    u = 29.4;
    counter = 1;
end

%Spike counter for synapses going out of this neuron.
if counter==1
    X=1;
else
    X=0;
end

%Update synapse variables
umean_plus=umean_plus+(1/tau_plus)*(u-umean_plus);
umean_minus=umean_minus+(1/tau_minus)*(u-umean_minus);
u_bar_bar=u_bar_bar+(1/tau_u_bar)*((u-E_L)^2-u_bar_bar);
x_bar=x_bar+(1/tau_x)*(X-x_bar);

    
end

% numerical trick for the aEIF model: I simulated, once and for all, the spike upswing and 
% integrated to know what is the integral of the spike, with high precision. Then I used this number in the simulation and 
% I clamped the spike for 2ms at the appropriated calculated value (this is to speed up the simulations 
% since network simulation is really time consuming). Since my time step in my simulation is 1ms, 
% I wait 3ms (the spike length (2ms) plus 1 time step (1ms)) before I read the filtered version of 
% the voltage (we want to read the value of the voltage trace before this spike). 


