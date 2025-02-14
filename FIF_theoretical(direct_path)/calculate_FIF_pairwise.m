%%% calculate each pairwise FIF around the target 1

clc,clear all;

run('../Network_setup/Setup/Network_setup.m');
close all;
run('../parameter_settings.m');

pairwise_FIF = cell(length(Txlist),length(Rxlist));

target = target_list(1,:);

x = linspace(target(1)-5,target(1)+5,50);
y = linspace(target(2)-5,target(2)+5,50);
cd ../CRB_calculation_direct_path/
for i=1:length(Txlist)
    i
    for j=1:length(Rxlist)
        for xx = 1:length(x)
            for yy=1:length(y)
                FIM = FIM_calculation(length(Txlist),i,Txlist(i),Rxlist(j),[x(xx) y(yy)]);
                iJ = inv(FIM);
                pairwise_FIF{i,j}(yy,xx) = 1/trace(iJ(1:2,1:2));     
            end
        end
        pairwise_FIF{i,j}(pairwise_FIF{i,j}<=0) = 1e-15;
    end
end
cd ../FIF_theoretical(direct_path)/

save('pairwise_FIF.mat');
