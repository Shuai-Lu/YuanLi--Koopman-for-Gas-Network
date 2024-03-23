function verify = func_EDMD_verify(x, u, y, model_order, EDMD, num_training_sample,model_order_u)
%%
% dx/dt = [A11 A12][x] + [B11 B12][  u  ]
% dy/dt = [A21 A22][y] + [B21 B22][du/dt]
% x: num_T * num_observable
% y: num_T * num_output
% u: num_T * num_control

global data model;
% %
num_sample = size(x,1);

%% training data
k_interval = 1 : model_order;
verify.x(k_interval, :) = x(k_interval, :);
verify.y(k_interval, :) = y(k_interval, :);

% % x
for k_interval = 1 : num_training_sample - model_order
    for k_order = 1 : model_order
        verify.A11_x(k_interval, :, k_order) =  ...
            (EDMD.var.A11(:, :, k_order) * ...
            x(k_interval + model_order - k_order +1, :)')';

        verify.A12_y(k_interval, :, k_order) =  ...
            (EDMD.var.A12(:, :, k_order) * ...
            y(k_interval + model_order - k_order +1, :)')';
    end
    for k_order = 1 : model_order_u
        verify.B11_u(k_interval, :, k_order) =  ...
            (EDMD.var.B11(:, :, k_order) * ...
            u(k_interval + model_order - k_order + 1, :)')';
    end
    verify.x(k_interval + model_order,:) = ...
        sum(verify.A11_x(k_interval,:,:), 3) + ...
        sum(verify.B11_u(k_interval,:,:), 3) + ...
        sum(verify.A12_y(k_interval,:,:), 3);
end
% % y
for k_interval = 1 : num_training_sample - model_order
    for k_order = 1 : model_order
        verify.A21_x(k_interval, :, k_order) =  ...
            (EDMD.var.A21(:, :, k_order) * ...
            x(k_interval + model_order - k_order +1 , :)')';
        verify.A22_y(k_interval, :, k_order) =  ...
            (EDMD.var.A22(:, :, k_order) * ...
            y(k_interval + model_order - k_order +1, :)')';
    end
    for k_order = 1 : model_order_u
        verify.B21_u(k_interval, :, k_order) =  ...
            (EDMD.var.B21(:, :, k_order) * ...
            u(k_interval + model_order - k_order + 1, :)')';
    end
    verify.y(k_interval + model_order,:) = ...
        sum(verify.A21_x(k_interval,:,:), 3) + ...
        sum(verify.A22_y(k_interval,:,:), 3) + ...
        sum(verify.B21_u(k_interval,:,:), 3);
end

%% test data
k_interval = 1 : model_order;
verify.x(num_training_sample+k_interval, :) = x(num_training_sample+k_interval, :);
verify.y(num_training_sample+k_interval, :) = y(num_training_sample+k_interval, :);
% % x
for k_interval = num_training_sample + 1 : num_sample - model_order
    for k_order = 1 : model_order
        verify.A11_x(k_interval, :, k_order) =  ...
            (EDMD.var.A11(:, :, k_order) * ...
            x(k_interval + model_order - k_order +1, :)')';
        verify.A12_y(k_interval, :, k_order) =  ...
            (EDMD.var.A12(:, :, k_order) * ...
            y(k_interval + model_order - k_order +1, :)')';
    end
    for k_order = 1 : model_order_u
        verify.B11_u(k_interval, :, k_order) =  ...
            (EDMD.var.B11(:, :, k_order) * ...
            u(k_interval + model_order - k_order + 1, :)')';
    end
    verify.x(k_interval + model_order,:) = ...
        sum(verify.A11_x(k_interval,:,:), 3) + ...
        sum(verify.B11_u(k_interval,:,:), 3) + ...
        sum(verify.A12_y(k_interval,:,:), 3);
end
% % y
for k_interval = num_training_sample + 1 : num_sample - model_order
    for k_order = 1 : model_order
        verify.A21_x(k_interval, :, k_order) =  ...
            (EDMD.var.A21(:, :, k_order) * ...
            x(k_interval + model_order - k_order  +1, :)')';
        verify.A22_y(k_interval, :, k_order) =  ...
            (EDMD.var.A22(:, :, k_order) * ...
            y(k_interval + model_order - k_order +1, :)')';
    end
    for k_order = 1 : model_order_u
        verify.B21_u(k_interval, :, k_order) =  ...
            (EDMD.var.B21(:, :, k_order) * ...
            u(k_interval + model_order - k_order + 1, :)')';
    end
    verify.y(k_interval + model_order,:) = ...
        sum(verify.A21_x(k_interval,:,:), 3) + ...
        sum(verify.A22_y(k_interval,:,:), 3) + ...
        sum(verify.B21_u(k_interval,:,:), 3);
end

%% error
verify.error_x = verify.x - x;
verify.error_y = verify.y - y;

% verify.error_x_relative = (verify.x*model.data.basevalue_P - x*model.data.basevalue_P)./ abs(x*model.data.basevalue_P)*100;
% verify.error_y_relative = (verify.y*model.data.basevalue_M - y*model.data.basevalue_M)./ abs(y*model.data.basevalue_M)*100;
verify.P = verify.x*model.data.basevalue_P;
verify.P_real = x*model.data.basevalue_P;
verify.M1_v = verify.y*model.data.basevalue_M;
verify.M2 = y*model.data.basevalue_M;

verify.error_x_relative = (verify.x - x)./ myabs(x)*100;
verify.error_y_relative = (verify.y - y)./ myabs(y)*100;

verify.p_real = verify.x*model.data.basevalue_P;
verify.M_real = verify.y*model.data.basevalue_M;
    function y = myabs(x)
        [num_row, num_col] = size(x);
        x = reshape(x, 1, []);
        y = [abs(x); 0.1*ones(1, num_row*num_col)];
        y = max(y);
        y = reshape(y, num_row, num_col, []);
    end
end

