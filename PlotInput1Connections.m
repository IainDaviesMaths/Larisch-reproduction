function [w] =  PlotInput1Connections(w_input_rec)
%Feedforward weights onto the first excitatory neuron.
w=zeros(500,1000);
for I=1:500
    for J=1:1000
        w(501-I,J)=w(501-I,J)+w_input_rec(J,I,1);
    end
end

end