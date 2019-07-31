% %Generate Data
[w_input_rec_small,w_ex_rec_small]=RateExcitatory(14*10^-6,8*10^-6);
[w_input_rec_norm,w_ex_rec_norm]=RateExcitatory(8*10^-5,14*10^-5);

%Small Amplitudes
winpSmall = PlotInput1Connections(w_input_rec_small);
wexSmall=PlotEx1Connections(w_ex_rec_small);
coloursSmall = PlotExExConnections(w_ex_rec_small);
wSmall = PlotInputExConnections(w_input_rec_small);

subplot(2,2,1); imagesc(winpSmall); ylabel('Input Neuron'); 
xlabel('Time(s)'); title('Feedforward Connections to Neuron 1')
subplot(2,2,2); imagesc(wexSmall); ylabel('Excitatory Neuron'); 
xlabel('Time(s)'); title('Excitatory Connections to Neuron 1')
subplot(2,2,3); imagesc(wSmall); ylabel('Input Neuron'); 
xlabel('Excitatory Neuron'); title('Feedforward Connections')
subplot(2,2,4); image(coloursSmall); ylabel('Pre Neuron'); 
xlabel('Post Neuron'); title('Excitatory Connections')
sgtitle('Rate Coding - Small Amplitudes')
saveas(gcf,'RateCodingNetworkSmall.png')

%Normal Amplitudes
winpNorm = PlotInput1Connections(w_input_rec_norm);
wexNorm=PlotEx1Connections(w_ex_rec_norm);
coloursNorm = PlotExExConnections(w_ex_rec_norm);
wNorm = PlotInputExConnections(w_input_rec_norm);

figure()
subplot(2,2,1); imagesc(winpNorm); ylabel('Input Neuron'); 
xlabel('Time(s)'); title('Feedforward Connections to Neuron 1')
subplot(2,2,2); imagesc(wexNorm); ylabel('Excitatory Neuron'); 
xlabel('Time(s)'); title('Excitatory Connections to Neuron 1')
subplot(2,2,3); imagesc(wNorm); ylabel('Input Neuron'); 
xlabel('Excitatory Neuron'); title('Feedforward Connections')
subplot(2,2,4); image(coloursNorm); ylabel('Pre Neuron'); 
xlabel('Post Neuron'); title('Excitatory Connections')
sgtitle('Rate Coding - Normal Amplitudes')
saveas(gcf,'RateCodingNetworkNorm.png')
