function [colours] = PlotExExConnections(w_ex_rec)
%Create colour map for neuron to neuron connections.
w=zeros(10,10);
for I=1000
    for J=1:10
        for K=1:10
            w(J,K)=w(J,K)+w_ex_rec(I,J,K);
        end
    end
end

w=w/1;

for I=1:10
    w(I,I)=nan;
end

maxima=max(max(w));
thresh=2/3*maxima;
colours=zeros(10,10,3);

%Fill in colour map.
for I=1:10
    for J=1:10
        if w(I,J)>thresh
            %Yellow
            colours(I,J,:)=[1 1 0];
            if w(J,I)>thresh
                %Red
                colours(I,J,:)=[1 0 0];
            end
        elseif isnan(w(I,J))
            %White
            colours(I,J,:)=[1 1 1];
        else
            %Blue
            colours(I,J,:)=[0 0 1];
        end
    end
end


end