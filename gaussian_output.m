function [ spike_train ] = gaussian_output( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
freq_min=0.0001;
freq_max=0.015;
sigma=10;
no_pres=500;

indices=linspace(1,500,500);

gau_spread=freq_min+freq_max*exp((-(indices-no_pres/2).^2)/(2*sigma^2));

gau_spread=[gau_spread gau_spread];

gau=zeros(10,no_pres);

for I=0:9
    gau(I+1,:)=gau_spread(50*I+1:50*I+no_pres);
end

image_nos=randi(10,1,1000);

input_gau=zeros(1000*100,no_pres);
for I=0:999
    for J=1:100
        input_gau(I*100+J,:)=gau(image_nos(I+1),:);
    end
end

spike_train=rand(100*1000,no_pres)<input_gau;

spike_train=spike_train';
end