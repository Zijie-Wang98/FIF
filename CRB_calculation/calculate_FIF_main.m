clc,clear all;

run('../Network_setup/Setup/Network_setup.m');
close all;
run('../parameter_settings.m');

pairwise_FIF = cell(length(Txlist),length(Rxlist));

target = [10 20];

x = linspace(10-5,10+5,50);
y = linspace(20-5,20+5,50);

for i=1:length(Txlist)
    for j=1:length(Rxlist)
        j
        %if ~isnan(pairwise_location_est{i,j})
        if vecnorm(Txlist(i).location-target)+vecnorm(Rxlist(j).location-target)<distance_threshold
            for xx = 1:length(x)
                for yy=1:length(y)
                    FIM = FIM_calculation(length(Txlist),Txlist(i),Rxlist(j),[x(xx) y(yy)]);
                    iJ = inv(FIM);
                    pairwise_FIF{i,j}(yy,xx) = 1/trace(iJ(1:2,1:2));     
                end
            end
        else
            pairwise_FIF{i,j} = nan;
        end
    end
end

save('pairwise_FIF.mat');
