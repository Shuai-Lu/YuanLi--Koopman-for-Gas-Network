function verify = func_EDMD_verify_benchmark(x, u, y, model_order_x, model_order_u, EDMD, num_training_sample)
%%
% x(k+1) = sum(A(i)*x(k-i)) + sum(B(i)*u(k-i))
% y(k+1) = sum(C(i)*x(k-i)) + sum(D(i)*u(k-i)) + sum(E(i)*y(k-i))
% x: num_T * num_observable
% y: num_T * num_output
% u: num_T * num_control

%%
num_sample = size(x,1);

%% training data
k_interval = 1 : model_order_x;
% % x
if ~isempty(x)
    verify.x(k_interval, :) = x(k_interval, :);
    for k_interval = 1 : num_training_sample - model_order_x
        for k_order = 1 : model_order_x + 1
            verify.A_x(k_interval, :, k_order) =  ...
                (EDMD.var.A(:, :, k_order) * ...
                x(k_interval + model_order_x - k_order + 1, :)')';
        end
        for k_order = 1 : model_order_u + 1
            verify.B_u(k_interval, :, k_order) =  ...
                (EDMD.var.B(:, :, k_order) * ...
                u(k_interval + model_order_x - k_order + 1, :)')';
        end
        verify.x(k_interval + model_order_x,:) = ...
            sum(verify.A_x(k_interval,:,:), 3) + ...
            sum(verify.B_u(k_interval,:,:), 3);
    end
end

% % y
if ~isempty(y)
    verify.y(k_interval, :) = y(k_interval, :);
    for k_interval = 1 : num_training_sample - model_order_x
        for k_order = 1 : model_order_x + 1
            verify.C_x(k_interval, :, k_order) =  ...
                (EDMD.var.C(:, :, k_order) * ...
                x(k_interval + model_order_x - k_order + 1, :)')';
        end
        for k_order = 1 : model_order_u + 1
            verify.D_u(k_interval, :, k_order) =  ...
                (EDMD.var.D(:, :, k_order) * ...
                u(k_interval + model_order_x - k_order + 1, :)')';
        end
        verify.y(k_interval + model_order_x,:) = ...
            sum(verify.C_x(k_interval,:,:), 3) + ...
            sum(verify.D_u(k_interval,:,:), 3);
    end
end

%% test data
k_interval = 1 : model_order_x;
% % x
if ~isempty(x)
    verify.x(num_training_sample+k_interval, :) = x(num_training_sample+k_interval, :);
    for k_interval = num_training_sample + 1 : num_sample - model_order_x
        for k_order = 1 : model_order_x + 1
            verify.A_x(k_interval, :, k_order) =  ...
                (EDMD.var.A(:, :, k_order) * ...
                x(k_interval + model_order_x - k_order + 1, :)')';
        end
        for k_order = 1 : model_order_u + 1
            verify.B_u(k_interval, :, k_order) =  ...
                (EDMD.var.B(:, :, k_order) * ...
                u(k_interval + model_order_x - k_order + 1, :)')';
        end
        verify.x(k_interval + model_order_x,:) = ...
            sum(verify.A_x(k_interval,:,:), 3) + sum(verify.B_u(k_interval,:,:), 3);
    end
end
% % y
if ~isempty(y)
    verify.y(num_training_sample+k_interval, :) = y(num_training_sample+k_interval, :);
    for k_interval = num_training_sample + 1 : num_sample - model_order_x + 1
        for k_order = 1 : model_order_x + 1
            verify.C_x(k_interval, :, k_order) =  ...
                (EDMD.var.C(:, :, k_order) * ...
                x(k_interval + model_order_x - k_order + 1, :)')';
        end
        for k_order = 1 : model_order_u + 1
            verify.D_u(k_interval, :, k_order) =  ...
                (EDMD.var.D(:, :, k_order) * ...
                u(k_interval + model_order_x - k_order + 1, :)')';
        end
        verify.y(k_interval + model_order_x,:) = ...
            sum(verify.C_x(k_interval,:,:), 3) + ...
            sum(verify.D_u(k_interval,:,:), 3);
    end
end

%% error
if ~isempty(x)
    verify.error_x = verify.x - x;
    verify.error_x_relative = (verify.x - x)./ myabs(x);
end

if ~isempty(y)
    verify.error_y = verify.y - y;
    verify.error_y_relative = (verify.y - y)./ myabs(y);
end

%%
    function y = myabs(x)
        [num_row, num_col] = size(x);
        y = abs(x);
        % x = reshape(x, 1, []);
        % y = [abs(x); ones(1, num_row*num_col)];
        % y = max(y);
        % y = reshape(y, num_row, num_col, []);
    end
end

