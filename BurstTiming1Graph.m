%BurstTiming1Graph
weights =zeros(1,6);

for spike_number=[1 2 3]
    weights(spike_number*2-1)=BurstTiming1Func(spike_number,1);
    weights(spike_number*2)=BurstTiming1Func(spike_number,-1);
end

num=[1 1 2 2 3 3];

scatter(num,weights,'Marker','x')
axis([0.8 3.2 25 275])
xlabel('Postsynaptic spike number')
yticks(50:50:250)
ylabel('Normalized Weight (%)')
title('Burst Timing Experiment 1')

saveas(gcf,'BurstTiming1.png')