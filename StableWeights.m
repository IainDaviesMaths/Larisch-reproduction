%Stable Weights

%Visual Cortex parameters
A_LTP=8*10^-4;
A_LTD=14*10^-4;
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

spike_train=gaussian_output;


%Initialise neuron variables
u=-70.6; wad=0; z=0;
counter=0; V_T=-50.4;

%Initialise weights variables
w=rand(1,500)*1.5+0.5; umean_plus=-70.6;
umean_minus=-70.6; u_bar_bar=0; x_bar_red=0;
umean_plus_d=umean_plus;
umean_minus_d=umean_minus;
u_bar_bar_d=u_bar_bar;
X_red=0; I=0;
x_bar=zeros(1,500);
tau_x=15;

weights=zeros(1001,500);
weights(1,:)=w;
for time=1:1000*100
    %Update neuronsTime
    [u, wad,z,counter,V_T,umean_plus, umean_minus, u_bar_bar, x_bar_red,X_red] = aEIFnet(u,wad,z,I,counter,V_T,umean_plus, umean_minus, u_bar_bar, x_bar_red, neu_par);
    I=0;
    %Update synapses
    for pre=1:500
        x_bar(pre)=x_bar(pre)+(1/tau_x)*(spike_train(pre,time)-x_bar(pre));
        [ w(pre) ] = synapse(w(pre), u, umean_plus_d, umean_minus_d, u_bar_bar_d, x_bar(pre), spike_train(pre,time), syn_par );
        I=I+4*w(pre)*spike_train(pre,time);
    end
    if mod(time,100)==0
        weights(1+time/100,:)=w;
    end
    
    umean_plus_d=umean_plus;
    umean_minus_d=umean_minus;
    u_bar_bar_d=u_bar_bar;
end
weights=weights';
% image([0 1000],[1 500],weights,'CDataMapping','scaled')
% set(gcf,'PaperUnits','centimeter ')
% xlabel('Epoch')
% ylabel('Neuron')
imagesc(weights)
set(gcf,'PaperUnits','centimeter ')
set(gca,'FontSize',16,'FontName','Helvetica','linewidth',2)
ylabel('Neuron Index')
xlabel('Epoch')
caxis([0 3])

saveas(gcf,'StableWeights.png')