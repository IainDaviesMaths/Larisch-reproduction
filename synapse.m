function [ w ] = synapse(w, u, umean_plus, umean_minus, u_bar_bar, x_bar, X, parameters )
%SYNAPSE calculates the change over 1ms of the weight of a synapse
% Inputs:
% w           Weight
% u           Postsynaptic neuron membrane potential
% umean_plus  Filtered mean potential, high pass
% umean_minus Filtered mean potential, low pass
% u_bar_bar   Non-linear filtered potential
% x_bar       Presynaptic slike trace
% X           Presynaptic spike train
% parameters  Synaptic parameters

%Parameters
A_LTP=parameters(1);
A_LTD=parameters(2);
theta_plus=parameters(3);
theta_minus=parameters(4);
w_max=parameters(5);
w_min=parameters(6);
u_ref_square=parameters(7);

%Potentiation term.
LTP=A_LTP*x_bar*(u-theta_plus>0)*(u-theta_plus)*(umean_plus-theta_minus>0)*(umean_plus-theta_minus);

%Depression term.
LTD=A_LTD*(u_bar_bar/u_ref_square)*X*(umean_minus-theta_minus>0)*(umean_minus-theta_minus);

%Change weight.
w=w+LTP-LTD;

%Instate hard bounds for the weight. 
w=min(w,w_max);
w=max(w,w_min);

end

