clc, clear all, close all
% run("../parameter_settings_example.m");
% run("../Show_hex.m");
% close all

run("../Plot_hex.m")
hold on
%% 

Tx1 = Tx(1,coords(23,:));
Tx2 = Tx(2,coords(17,:));
Tx3 = Tx(3,coords(9,:));
Tx4 = Tx(4,coords(14,:));
Tx5 = Tx(5,coords(30,:));
Tx6 = Tx(6,coords(40,:));
Tx7 = Tx(7,coords(33,:));
Txlist = [Tx1 Tx2 Tx3 Tx4 Tx5 Tx6 Tx7];
Rxlist = Txlist;

for t=1:length(Txlist)
    if Txlist(t).index == 12
        Tx_draw(Txlist(t));
    else
        Tx_draw_right(Txlist(t));
    end
end
