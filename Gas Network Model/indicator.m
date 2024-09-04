% 假定 predictions 是你模型的预测值，observations 是实际观测值
% 他们都是 1000x1 的向量

% a = sum(abs(model.verify(5).error_y_relative(:, 1)))/1000;


% 初始化空向量用于存储所有预测值和观测值
all_predictions = [];
all_observations = [];

% 迭代将每组的预测值和观测值拼接成一个列向量
for i = 1:19
    predictions = model.verify(i).x(:,1);
    observations = model.data.pipeline(i).x(:,1);
    
    all_predictions = [all_predictions; predictions];
    all_observations = [all_observations; observations];
end

% 计算总体的RMSE
Pout_rmse = sqrt(mean((all_predictions*model.data.basevalue_P - all_observations*model.data.basevalue_P).^2));

% 计算总体的MAPE
Pout_mape = mean(abs((all_observations*model.data.basevalue_P - all_predictions*model.data.basevalue_P) ./ (all_observations*model.data.basevalue_P))) * 100;

% 输出结果
fprintf('Pout RMSE: %.4f\n', Pout_rmse);
fprintf('Pout MAPE: %.4f%%\n', Pout_mape);

%%

% 初始化空向量用于存储所有预测值和观测值
all_predictions = [];
all_observations = [];

% 迭代将每组的预测值和观测值拼接成一个列向量
for i = 1:19
    predictions = model.verify(i).x(:,2);
    observations = model.data.pipeline(i).x(:,2);
    
    all_predictions = [all_predictions; predictions];
    all_observations = [all_observations; observations];
end

% 计算总体的RMSE
Min_rmse = sqrt(mean((all_predictions*model.data.basevalue_M - all_observations*model.data.basevalue_M).^2));

% 计算总体的MAPE
Min_mape = mean(abs((all_observations*model.data.basevalue_M - all_predictions*model.data.basevalue_M) ./ (all_observations*model.data.basevalue_M))) * 100;

% 输出结果
fprintf('Min RMSE: %.4f\n', Min_rmse);
fprintf('Min MAPE: %.4f%%\n', Min_mape);
