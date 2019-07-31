%TemporalCodeSim

w=TemporalCode;

for I=1:10
    w(I,I)=nan;
end

maxima=max(max(w));
thresh=0.15;
colours=ones(10,10,3);

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

image(colours)
xlabel('Post Neuron')
ylabel('Pre Neuron')
title('Temporal Code Experiment')

saveas(gcf,'TemporalCode.png')