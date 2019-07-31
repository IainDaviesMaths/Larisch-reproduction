function [w] =  PlotEx1Connections(w_ex_rec)
%Feedforward weights onto the first excitatory neuron.
w=zeros(9,1000);
for I=1:9
    for J=1:1000
        w(I,J)=w(I,J)+w_ex_rec(J,I+1,1);
    end
end

end