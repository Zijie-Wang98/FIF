%%% calculate the FIF in big picture

clc,clear all;

run('../Network_setup/Setup/Network_setup.m');
close all;
run('../parameter_settings.m');

target = target_list(1,:);

Tx_index1 = 1;
Tx_index2 = 7;

x = linspace(Txlist(Tx_index1).location(1)-5,Txlist(Tx_index2).location(1)+5,100);
y = linspace(Txlist(Tx_index1).location(2)-5,Txlist(Tx_index2).location(2)+5,100);
cd ../CRB_calculation_direct_path/
for i=Tx_index1
    for j=Tx_index2
        for xx = 1:length(x)
            xx
            for yy=1:length(y)
                [FIM,~,~] = FIM_calculation(length(Txlist),i,Txlist(i),Rxlist(j),[x(xx) y(yy)]);
                iJ = inv(FIM);
                FIF(yy,xx) = 1/trace(iJ(1:2,1:2));     
            end
        end
    end
end
FIF(FIF<=0) = 1e-15;
cd ../FIF_theoretical(direct_path)/
save('FIF_pair.mat');
contourf(x,y,10*log(FIF),20)
