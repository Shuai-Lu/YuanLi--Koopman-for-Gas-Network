function EDMD = func_multi_order_EDMD_benchmark(x, u, y, model_order_x, model_order_u)
%%
% x(k+1) = sum(A(i)*x(k-i)) + sum(B(i)*u(k-i))
% y(k+1) = sum(C(i)*x(k-i)) + sum(D(i)*u(k-i)) + sum(E(i)*y(k-i))
% x: num_T * num_observable
% y: num_T * num_output
% u: num_T * num_control

num_sample = size(x,1);
num_x = size(x,2);
num_y = size(y,2);
num_u = size(u,2);

%% ------------------------------------------------------------------------
fprintf('%s\n', '------------------- Start EDMD ----------------------');

%% ------------------------------------------------------------------------
%% x(k+1) = sum(A(i)*x(k-i)) + sum(B(i)*u(k-i))
if  ~ isempty(x)
    %% initialize
    yalmip('clear');
    EDMD.cons = [];
    EDMD.var = [];
    %% define vars
    EDMD.var.A = sdpvar(num_x, num_x, model_order_x + 1, 'full');
    EDMD.var.B = sdpvar(num_x, num_u, model_order_u + 1, 'full');
    EDMD.var.A_x = sdpvar(num_sample - model_order_x, num_x, model_order_x + 1, 'full');
    EDMD.var.B_u = sdpvar(num_sample - model_order_x, num_x, model_order_u + 1, 'full');
    EDMD.var.norm_A = sdpvar(model_order_x + 1, 1,'full');
    EDMD.var.error_x = sdpvar(num_sample - model_order_x, num_x, 'full');
    EDMD.var.A (:, :, 1) = zeros(num_x, num_x);

    %% define cons
    % x(k+1) = sum(A(i)*x(k-i)) + sum(B(i)*u(k-i))
    k_interval = 1 : num_sample - model_order_x;
    for k_order = 1 : model_order_x + 1
        EDMD.cons = EDMD.cons + (( ...
            EDMD.var.A_x(k_interval, :, k_order)' ==  ...
            EDMD.var.A(:, :, k_order) * ...
            x(k_interval + model_order_x - k_order + 1, :)' ...
            ): 'A_x(k) = A(k) * x(t-k)');
    end

    for k_order = 1 : model_order_u + 1
        EDMD.cons = EDMD.cons + (( ...
            EDMD.var.B_u(:, :, k_order)' ==  ...
            EDMD.var.B(:, :, k_order) * ...
            u(k_interval + model_order_x - k_order + 1, :)' ...
            ): 'B_u(k) = B(k) * u(t-k)');
    end

    EDMD.cons = EDMD.cons + (( ...
        EDMD.var.error_x(k_interval, :) == ...
        x(k_interval + model_order_x, :) - ( ...
        sum(EDMD.var.A_x, 3) + ...
        sum(EDMD.var.B_u, 3) ...
        )): 'error_x(t) = x(t+model_order) - sum(A(k) * x(t-k)) ');

    % % stability cons
    for k_order = 2 : model_order_x + 1
        EDMD.cons = EDMD.cons + (...
            norm(EDMD.var.A(:,:,k_order), 2) <= 1);
        EDMD.var.norm_A(k_order,1) = norm(EDMD.var.A(:,:,k_order), 2);
    end

    EDMD.cons = EDMD.cons + ((sum(EDMD.var.norm_A) <= 1));

    %% define obj
    EDMD.var.obj_x = sum(reshape(EDMD.var.error_x, 1, []) .^2);

    %% solve
    EDMD.ops = sdpsettings('solver', 'mosek', 'verbose', 0);
    EDMD.sol.x = optimize(EDMD.cons, EDMD.var.obj_x, EDMD.ops);
    if ~ EDMD.sol.x.problem
        fprintf('%s\n', EDMD.sol.x.info);
    else
        error(EDMD.sol.x.info);
    end
    fprintf('%s%.4f%s\n\n', 'Solver time: ', EDMD.sol.x.solvertime, 's');
    EDMD.var = myFun_GetValue(EDMD.var, 'DisplayTime', 0);
end


%% ------------------------------------------------------------------------
%% y(k+1) = sum(C(i)*x(k-i)) + sum(D(i)*u(k-i)) + sum(E(i)*y(k-i))
if ~ isempty(y)
    %% initialize
    yalmip('clear');
    EDMD.cons = [];
    EDMD.var = [];

    %% define cons
    EDMD.var.C = sdpvar(num_y, num_x, model_order_x + 1, 'full');
    EDMD.var.E = sdpvar(num_y, num_y, model_order_x + 1, 'full');
    EDMD.var.D = sdpvar(num_y, num_u, model_order_u + 1, 'full');
    EDMD.var.C_x = sdpvar(num_sample - model_order_x, num_y, model_order_x + 1, 'full');
    EDMD.var.E_y = sdpvar(num_sample - model_order_x, num_y, model_order_x + 1, 'full');
    EDMD.var.D_u = sdpvar(num_sample - model_order_x, num_y, model_order_u + 1, 'full');
    EDMD.var.norm_E = sdpvar(model_order_x + 1, 1, 'full');
    EDMD.var.error_y = sdpvar(num_sample - model_order_x + 1, num_y, 'full');
    EDMD.var.E (:, :, 1) = zeros(num_y, num_y);

    %% define cons
    % y(k+1) = sum(C(i)*x(k-i)) + sum(E(i)*y(k-i)) + sum(D(i)*u(k-i))
    k_interval = 1 : num_sample - model_order_x;
    for k_order = 1 : model_order_x + 1
        EDMD.cons = EDMD.cons + (( ...
            EDMD.var.C_x(k_interval, :, k_order)' ==  ...
            EDMD.var.C(:, :, k_order) * ...
            x(k_interval + model_order_x - k_order + 1, :)' ...
            ): 'C_x(k) = C(k) * x(t-k)');
        EDMD.cons = EDMD.cons + (( ...
            EDMD.var.E_y(k_interval, :, k_order)' ==  ...
            EDMD.var.E(:, :, k_order) * ...
            y(k_interval + model_order_x - k_order + 1, :)' ...
            ): 'E_y(k) = E(k) * y(t-k)');
    end
    for k_order = 1 : model_order_u + 1
        EDMD.cons = EDMD.cons + (( ...
            EDMD.var.D_u(k_interval, :, k_order)' ==  ...
            EDMD.var.D(:, :, k_order) * ...
            u(k_interval + model_order_x - k_order + 1, :)' ...
            ): 'D_u(k) = D(k) * u(t-k)');
    end

    EDMD.cons = EDMD.cons + (( ...
        EDMD.var.error_y(k_interval, :) == ...
        y(k_interval + model_order_x, :) - ( ...
        sum(EDMD.var.C_x(k_interval,:,:), 3) + ...
        sum(EDMD.var.E_y(k_interval,:,:), 3) + ...
        sum(EDMD.var.D_u(k_interval,:,:), 3) ...
        )): 'error_y(t) = y(t+model_order) - sum(C(k) * x(t-k)) ');

    % % stability cons
    for k_order = 1 : model_order_x
        EDMD.cons = EDMD.cons + (norm(EDMD.var.E(:,:,k_order), 2) <= 1);
        EDMD.var.norm_E(k_order,1) = norm(EDMD.var.E(:,:,k_order), 2);
    end
    EDMD.cons = EDMD.cons + ((sum(EDMD.var.norm_E) <= 1));

    %% define obj
    EDMD.var.obj_y = norm(reshape(EDMD.var.error_y, 1, []), 2)^2;

    %% solve
    EDMD.ops = sdpsettings('solver', 'mosek', 'verbose', 0);
    EDMD.ops.gurobi.NumericFocus = 1;
    EDMD.sol.y = optimize(EDMD.cons, EDMD.var.obj_y, EDMD.ops);
    if ~ EDMD.sol.y.problem
        fprintf('%s\n', EDMD.sol.y.info);
    else
        error(EDMD.sol.y.info);
    end
    fprintf('%s%.4f%s\n\n', 'Solver time: ', EDMD.sol.y.solvertime, 's');
    EDMD.var = myFun_GetValue(EDMD.var, 'DisplayTime', 0);
end
end
