# Makefile for Clopath et al reproductions

all: VoltageClamp.png STDPWindow.png STDPFrequency.png BurstTiming1.png BurstTiming2.png BurstTiming3.png RateCode.png TemporalCode.png StableWeights.png

VoltageClamp.png: VoltageClamp.m synapse.m
	matlab -batch VoltageClamp
	
STDPWindow.png: STDPWindow.m synapse.m aEIFnet.m
	matlab -batch STDPWindow

STDPFrequency.png: STDPFrequency.m synapse.m aEIFnet.m
	matlab -batch STDPFrequency

BurstTiming1.png: BurstTiming1Graph.m BurstTiming1Func.m synapse.m aEIFnet.m
	matlab -batch BurstTiming1Graph

BurstTiming2.png: BurstTiming2.m synapse.m aEIFnet.m
	matlab -batch BurstTiming2

BurstTiming3.png: BurstTiming3.m synapse.m aEIFnet.m
	matlab -batch BurstTiming3

RateCode.png: RateCode.m RateCodeSim.m synapse.m aEIFnet.m
	matlab -batch RateCodeSim

TemporalCode.png: TemporalCode.m TemporalCodeSim.m synapse.m aEIFnet.m
	matlab -batch TemporalCodeSim
	
StableWeights.png: StableWeights.m gaussian_output.m aEIFnet.m synapse.m
	matlab -batch StableWeights

RateCodingNetworkSmall.png: RateSequencing.m RateExcitatory.m ChooseRandom.m gaussian_output2.m aEIFnet.m synapse.m PlotInput1Connections.m PlotEx1Connections.m PlotExExConnections.m PlotInputExConnections.m
	matlab -batch RateSequencing
	
RateCodingNetworkNorm.png: RateSequencing.m RateExcitatory.m ChooseRandom.m gaussian_output2.m aEIFnet.m synapse.m PlotInput1Connections.m PlotEx1Connections.m PlotExExConnections.m PlotInputExConnections.m
	matlab -batch RateSequencing
	
TemporalCodingNetworkSmall.png: TemporalSequencing.m TemporalExcitatory.m ChooseRandom.m aEIFnet.m synapse.m PlotInput1Connections.m PlotEx1Connections.m PlotExExConnections.m PlotInputExConnections.m
	matlab -batch TemporalSequencing
	
TemporalCodingNetworkNorm.png: TemporalSequencing.m TemporalExcitatory.m ChooseRandom.m aEIFnet.m synapse.m PlotInput1Connections.m PlotEx1Connections.m PlotExExConnections.m PlotInputExConnections.m
	matlab -batch TemporalSequencing
