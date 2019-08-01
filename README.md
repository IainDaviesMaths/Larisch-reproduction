# Larisch-reproduction
Reproduction of Larisch, R. 2019. [Re] Connectivity reflects coding: a model of voltage-based STDP with homeostasis. Under Review.


The code stored in this repository reproduces the majority of the results in the ReScience paper above, and attempts to reproduce the
extra results in the original paper by Clopath et al. The successful reproductions can be made by running "make all". These are
VoltageClamp.png, STDPWindow.png, STDPFrequency.png (Figure 1 Left, Middle and Right respectively in the ReScience paper),
BurstTiming1.png, BurstTiming2.png, BurstTiming3.png (Figure 2 Upper Left, Upper Right and Down respectively), RateCode.png,
TemporalCode.png (Figure 3 Left and Right respectively), and StableWeights.png (Figure 4 Left). 

The unsuccessful reproductions from the original paper are RateCodingNetworkNorm.png, RateCodingNetworkSmall.png (Figure 5 in original
paper), TemporalCodingNetworkNorm.png and TemporalCodingNetworkSmall.png (Figure 6 in original paper). Whilst the normal amplitude
simulations produce similar results to the original paper, the small amplitude simulations only produce random noise. The temporal coding
simulations also fail to reproduce the spatial dependence on the feedforward to excitatory connections. 
