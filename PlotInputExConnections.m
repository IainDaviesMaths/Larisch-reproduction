function [w] =  PlotInputExConnections(w_input_rec)
%Mean feedforward weights onto the 10 excitatory neurons averaged over
%100s.
start=901;
w=zeros(500,10);
for I=1:500
    for J=1:10
        w(501-I,J)=w(501-I,J)+sum(w_input_rec(start:start+99,I,J))/100;
    end
end

end