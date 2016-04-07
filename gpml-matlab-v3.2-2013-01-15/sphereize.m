function [mat] = sphereize (raw)

%Sphereizes all columns of a given matrix and returns the result

mat = raw*0;

for i = 1:length(raw(1,:))
    av = mean(raw(:,i));
    dev = std(raw(:,i));
    if av>=0
        mat(:,i) = (raw(:,i)-av)./dev;
    else
        mat(:,i) = (raw(:,i)+av)./dev;       
    end
end