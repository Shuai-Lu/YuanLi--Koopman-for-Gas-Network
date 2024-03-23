% 假定 predictions 是你模型的预测值，observations 是实际观测值
% 他们都是 1000x1 的向量

% a = sum(abs(model.verify(5).error_y_relative(:, 1)))/1000;
rmse = 0;
mape = 0;
r_squared = 0;

for i = 1:6
    predictions = [];
    observations = [];
    predictions = model.verify(i).x(:,1); % 你的预测值向量
    observations = model.data.pipeline(i).Pout_normalized(:,1); % 你的观测值向量

    % 确保 predictions 和 observations 是列向量
    predictions = predictions(:);
    observations = observations(:);

    % 计算 RMSE
    rmse = rmse + sqrt(mean((predictions - observations).^2));

    % 计算 MAPE
    mape = mape + mean(abs((predictions - observations) ./ observations)) * 100;

    % 计算 R²
    SStot = sum((observations - mean(observations)).^2);
    SSres = sum((predictions - observations).^2);
    r_squared = r_squared + (1 - (SSres / SStot));

    % 显示结果
    fprintf('RMSE: %f\n', rmse);
    fprintf('MAPE: %f%%\n', mape);
    fprintf('R²: %f\n', r_squared);
end