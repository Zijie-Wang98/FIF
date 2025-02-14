clc,clear all
run('../Network_setup/Setup/Network_setup.m');
close all;

iter = 100000;
target_mat = zeros(iter,2);
multi_static_points = cell(iter,1);
flag_map_cell = cell(iter,1);

for run = 1:iter
    run
    target = rand(1,2)*120-[60 60];
    target_mat(run,:) = target;
    [points_temp,flag_temp] = get_multistatic_estimation(Txlist,Rxlist,target);
    multi_static_points{run,1} = points_temp;
    flag_map_cell{run,1} = flag_temp;
end

save('points_data.mat');

time = zeros(1,5);
error = zeros(iter,5);

for run = 1:iter    
    [time_tmp,error(run,:)] = get_errors(Txlist,Rxlist,multi_static_points{run,1},flag_map_cell{run,1},target_mat(run,:));
    time = time+time_tmp;
end

time = time/iter;
save('error_time_data.mat');