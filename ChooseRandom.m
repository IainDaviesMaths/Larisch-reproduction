function [ output ] = ChooseRandom( nom, tot_nom )
%CHOOSERANDOM randomly chooses nom numbers from 1,2,3,...,tot_num. 
output=zeros(1,tot_nom);

for I=1:nom
    choice=randi(tot_nom);
    while output(choice)==1
        choice=randi(tot_nom);
    end
    output(choice)=1;
end
end

