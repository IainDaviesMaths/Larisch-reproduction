%RateCodeSim
w=zeros(10,10);
for repeats=1:100
    w=w+RateCode;
end

w=w/100;

for I=1:10
    w(I,I)=nan;
end

maxima=max(max(w));
thresh=0.3;
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

image(colours)
ylabel('Pre Neuron')
xlabel('Post Neuron')
title('Rate Code Experiment')

saveas(gcf,'RateCode.png')