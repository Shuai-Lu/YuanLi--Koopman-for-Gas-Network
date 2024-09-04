%% plot error
global model

single_pipe = 0; %  0-网络仿真结果； 1-单根管道的仿真结果
delta_verify= 900;

Min_dispatch = model.oef.var.ngs.Min_interpolated(2:end,:);
Pout_dispatch = model.oef.var.ngs.Pout_interpolated(2:end,:);
% Min_network_verify = zeros(96,19);
% Pout_network_verify = zeros(96,19);

if single_pipe == 0

%     network_verify_d = xlsread('to_excel_d_v1.xlsx', 'A2:BY400');
    network_verify_k = xlsread('to_excel_d_v1.xlsx', 'A2:BY400');
    data_verify = network_verify_k;
    for k = 1 : 19
        Min_network_verify(:,k) = data_verify(:,4*k-1);
        Pout_network_verify(:,k) = data_verify(:,4*k-2);

        Pin_network_verify(:,k) = data_verify(:,4*k-3);
        Mout_network_verify(:,k) = data_verify(:,4*k);
    end
end
if delta_verify == 300
    for i = 1:3:288
    % 对每三行进行求和和平均
    Min_network_verify((i+2)/3, :) = mean(Min_network_verify1(i:i+2, :), 1);
    Pout_network_verify((i+2)/3, :) = mean(Pout_network_verify1(i:i+2, :), 1);
    Pin_network_verify((i+2)/3, :) = mean(Pin_network_verify1(i:i+2, :), 1);
    Mout_network_verify((i+2)/3, :) = mean(Mout_network_verify1(i:i+2, :), 1);
    end
end

if single_pipe == 1

    network_verify_d = 'single_verify_d_v1.xlsx';
%     network_verify_k = 'single_verify_k.xlsx';
    filename = network_verify_d;
    Min_network_verify = xlsread(filename, 2, 'A2:BY100');
    Pout_network_verify = xlsread(filename, 1, 'A2:BY100');
end

model.Min_verify = zeros(24, 19);
model.Pout_verify = zeros(24, 19);
model.Min_dis = zeros(24, 19);
model.Pout_dis = zeros(24, 19);
for i = 1:24
    row_indices = (4*(i-1) + 1) : (4*i);

    average_Min = mean(Min_network_verify(row_indices, :), 1);
    model.Min_verify(i, :) = average_Min;
    average_Min_dis = mean(Min_dispatch(row_indices, :), 1);
    model.Min_dis(i, :) = average_Min_dis;

    average_Pout = mean(Pout_network_verify(row_indices, :), 1);
    model.Pout_verify(i, :) = average_Pout;
    average_Pout_dis = mean(Pout_dispatch(row_indices, :), 1);
    model.Pout_dis(i, :) = average_Pout_dis;
end

% 初始化误差累计变量
sumSquaredErrorPout = 0;
sumSquaredErrorQin = 0;
sumAbsolutePercentageErrorPout = 0;
sumAbsolutePercentageErrorQin = 0;
totalPout = 0;
totalQin = 0;
% 循环读取每个表格
for k = 1:19

    % 提取pout和qin列
    fzPout = model.Pout_verify(:,k);
    dispatchPout = model.Pout_dis(:,k);
    fzQin = model.Min_verify(:,k);
    dispatchQin = model.Min_dis(:,k);

    % fzPout = Pout_network_verify(:,k);
    % dispatchPout = Pout_dispatch(:,k);
    % fzQin = Min_network_verify(:,k);
    % dispatchQin = Min_dispatch(:,k);
    
    % 计算每根管道的平方误差
    squaredErrorsPout = (fzPout - dispatchPout).^2;
    squaredErrorsQin = (fzQin - dispatchQin).^2;
    absolutePercentageErrorsPout = abs((fzPout - dispatchPout) ./ fzPout) * 100;
    absolutePercentageErrorsQin = abs((fzQin - dispatchQin) ./ fzQin) * 100;
    
    % 累加误差
    sumSquaredErrorPout = sumSquaredErrorPout + sum(squaredErrorsPout);
    sumSquaredErrorQin = sumSquaredErrorQin + sum(squaredErrorsQin);
    sumAbsolutePercentageErrorPout = sumAbsolutePercentageErrorPout + sum(absolutePercentageErrorsPout);
    sumAbsolutePercentageErrorQin = sumAbsolutePercentageErrorQin + sum(absolutePercentageErrorsQin);

    totalPout = totalPout + length(squaredErrorsPout);
    totalQin = totalQin + length(squaredErrorsQin);
end

% 计算均方根误差
rmsePout = sqrt(sumSquaredErrorPout / totalPout);
rmseQin = sqrt(sumSquaredErrorQin / totalQin);

% 计算MAPE
mapePout = sumAbsolutePercentageErrorPout / totalPout;
mapeQin = sumAbsolutePercentageErrorQin / totalQin;

% 显示结果
fprintf('The RMSE for Pout is: %.3f\n', rmsePout);
fprintf('The RMSE for Qin is: %.3f\n', rmseQin);

% 显示结果
fprintf('The MAPE for Pout is: %.2f%%\n', mapePout);
fprintf('The MAPE for Qin is: %.2f%%\n', mapeQin);