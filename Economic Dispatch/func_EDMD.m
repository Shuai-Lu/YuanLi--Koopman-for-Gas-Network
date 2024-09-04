function verify = func_EDMD(x, u, y,model_order_x, model_order_u, EDMD, num_training_sample)
%%
global model;
% %
num_sample = size(u,1);
num_xpre = size(x,1);
num_lift_x = size(model.data.pipeline(9).x, 2);

%% training data
k_interval = 1 : num_xpre;

verify.x = sdpvar(num_sample, num_lift_x, 'full');
verify.A_x = sdpvar(num_sample -  model_order_x, num_lift_x, model_order_x , 'full');
verify.B_u = sdpvar(num_sample -  model_order_x, num_lift_x, model_order_u , 'full');

verify.x(k_interval, :) = x(k_interval, :);

% % x
for k_interval = num_training_sample - model_order_x + 1 : num_sample - model_order_x % 6:29
    for k_order = 1 : model_order_x
         model.oef.cons = model.oef.cons + ( ...
             (verify.A_x(k_interval, :, k_order) ==  ...
             (EDMD.var.A(:, :, k_order) * ...
             verify.x(k_interval + model_order_x - k_order + 1, :)')') : ...
             '');

    end
    for k_order = 1 : model_order_u
        model.oef.cons = model.oef.cons + ( ...
            (verify.B_u(k_interval, :, k_order) ==  ...
            (EDMD.var.B(:, :, k_order) * ...
            u(k_interval + model_order_x - k_order + 1, :)')') : ...
            '');
    end
    model.oef.cons = model.oef.cons + ( ...
        (verify.x(k_interval + model_order_x,:) == ...
        sum(verify.A_x(k_interval,:,:), 3) + ...
        sum(verify.B_u(k_interval,:,:), 3)) : ...
        '');
end
