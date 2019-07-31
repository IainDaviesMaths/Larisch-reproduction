function [ spike_train ] = gaussian_output2( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
freq_min=0.0001;
freq_max=0.030;
sigma=10;
no_pres=500;

indices=linspace(1,500,500);

gau_spread=freq_min+freq_max*exp((-(indices-no_pres/2).^2)/(2*sigma^2));
%Two copies of the gaussian spread
gau_spread=[gau_spread gau_spread];

%Generate randomly the start of the Gaussian spread.
image_no=(randi(10)-1)*50+1;

%Create list of Gaussian spreads
input_gau=zeros(100,no_pres);
for J=1:100
    input_gau(J,:)=gau_spread(image_no:image_no+499);
end

spike_train=rand(100,no_pres)<input_gau;

spike_train=spike_train';
end