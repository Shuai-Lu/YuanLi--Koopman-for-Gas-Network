function EDMD = func_multi_order_EDMD(x, u, y, model_order, model_order_u)
%%
% dx/dt = [A11 A12][x] + [B11 B12][  u  ]
% dy/dt = [A21 A22][y] + [B21 B22][du/dt]
% A12 = 0, B12 = 0

% x(k+1) = sum(A11(i)*x(k-i)) + sum(B11(i)*u(k-i))
% y(k+1) = sum(A21(i)*x(k-i)) + sum(A22(i)*y(k-i)) + 
%          sum(B21(i)*u(k-i)) + sum(B22(i)*(u(k-i)-u(k-i-1)))

% x: num_T * num_observable
% y: num_T * num_output
% u: num_T * num_control
global data model;
num_sample = size(x,1);
num_x = size(x,2);
num_y = size(y,2);
num_u = size(u,2);

%% ------------------------------------------------------------------------
fprintf('%s\n', '------------------- Start EDMD ----------------------');

%% ------------------------------------------------------------------------
%% initialize
yalmip('clear');
EDMD.cons = [];
EDMD.var = [];

%% define vars
EDMD.var.A11 = sdpvar(num_x, num_x, model_order, 'full');
EDMD.var.A11 (:, :, 1) = zeros(num_x, num_x);
EDMD.var.A11_x = sdpvar(num_sample - model_order, num_x, model_order, 'full');
EDMD.var.A12 = sdpvar(num_x, num_y, model_order, 'full');
EDMD.var.A12_y = sdpvar(num_sample - model_order, num_x, model_order, 'full');
EDMD.var.B11 = sdpvar(num_x, num_u, model_order_u, 'full');
EDMD.var.B11_u = sdpvar(num_sample - model_order, num_x, model_order_u, 'full');

EDMD.var.error_x = sdpvar(num_sample - model_order, num_x, 'full');

%% define cons
% x(k+1) = sum(A11(i)*x(k-i)) + sum(B11(i)*u(k-i))
k_interval = 1 : num_sample - model_order;
for k_order = 1 : model_order
    EDMD.cons = EDMD.cons + (( ...
        EDMD.var.A11_x(k_interval, :, k_order)' ==  ...
        EDMD.var.A11(:, :, k_order) * ...
        x(k_interval + model_order - k_order + 1, :)' ...
        ): 'A_x(k) = A(k) * x(t-k)');

    EDMD.cons = EDMD.cons + (( ...
        EDMD.var.A12_y(k_interval, :, k_order)' ==  ...
        EDMD.var.A12(:, :, k_order) * ...
        y(k_interval + model_order - k_order + 1, :)' ...
        ): 'A22_y(k) = A22(k) * y(t-k)');
end
for k_order = 1 : model_order_u
    EDMD.cons = EDMD.cons + (( ...
        EDMD.var.B11_u(:, :, k_order)' ==  ...
        EDMD.var.B11(:, :, k_order) * ...
        u(k_interval + model_order - k_order + 1, :)' ...
        ): 'B_u(k) = B(k) * u(t-k)');
end
EDMD.cons = EDMD.cons + (( ...
    EDMD.var.error_x(k_interval, :) == ...
    x(k_interval + model_order, :) - ( ...
    sum(EDMD.var.A11_x, 3) + ...
    sum(EDMD.var.B11_u, 3) + ...
    sum(EDMD.var.A12_y, 3) ...
    )): 'error_x(t) = x(t+model_order) - sum(A(k) * x(t-k)) ');


% % stability cons，要求A11的每个模态的谱半径不超过1
for k_order = 2 : model_order
    EDMD.cons = EDMD.cons + (( ...
        norm(EDMD.var.A11(:,:,k_order), 2) <= 1 ...
        ) : 'stable cons x');
    EDMD.var.norm_A11 = norm(EDMD.var.A11(:,:,k_order), 2);
end

EDMD.cons = EDMD.cons + (( ...
    sum(EDMD.var.norm_A11) <= 1 ...
    ));

%% define obj
EDMD.var.obj_x = sum(reshape(EDMD.var.error_x, 1, []) .^2);

%% solve
EDMD.ops = sdpsettings('solver', 'mosek', 'verbose', 0);
EDMD.sol.x = optimize(EDMD.cons, EDMD.var.obj_x, EDMD.ops);
fprintf('%s\n', EDMD.sol.x.info);
if EDMD.sol.x.problem
    return;
end
fprintf('%s%.4f%s\n\n', 'Solver time: ', EDMD.sol.x.solvertime, 's');
EDMD.var = myFun_GetValue(EDMD.var, 'DisplayTime', 0);
% temp = EDMD.var;

%% ------------------------------------------------------------------------
%% initialize
% yalmip('clear');
% EDMD.cons = [];
% EDMD.var = [];

%% define cons
EDMD.var.A21 = sdpvar(num_y, num_x, model_order, 'full');
EDMD.var.A21_x = sdpvar(num_sample - model_order, num_y, model_order, 'full');
EDMD.var.A22 = sdpvar(num_y, num_y, model_order, 'full');
EDMD.var.A22 (:, :, 1) = zeros(num_y, num_y);
EDMD.var.A22_y = sdpvar(num_sample - model_order, num_y, model_order, 'full');
EDMD.var.B21 = sdpvar(num_y, num_u, model_order_u, 'full');
EDMD.var.B21_u = sdpvar(num_sample - model_order, num_y, model_order_u, 'full');

EDMD.var.error_y = sdpvar(num_sample - model_order + 1, num_y, 'full');

%% define cons
% y(k+1) = sum(A21(i)*x(k-i)) + sum(A22(i)*y(k-i)) + 
%          sum(B21(i)*u(k-i)) + sum(B22(i)*(u(k-i)-u(k-i-1)))
k_interval = 1 : num_sample - model_order;
for k_order = 1 : model_order
    EDMD.cons = EDMD.cons + (( ...
        EDMD.var.A21_x(k_interval, :, k_order)' ==  ...
        EDMD.var.A21(:, :, k_order) * ...
        x(k_interval + model_order - k_order + 1 , :)' ...
        ): 'A21_x(k) = A21(k) * x(t-k)');

    EDMD.cons = EDMD.cons + (( ...
        EDMD.var.A22_y(k_interval, :, k_order)' ==  ...
        EDMD.var.A22(:, :, k_order) * ...
        y(k_interval + model_order - k_order + 1, :)' ...
        ): 'A22_y(k) = A22(k) * y(t-k)');
end
for k_order = 1 : model_order_u
    EDMD.cons = EDMD.cons + (( ...
        EDMD.var.B21_u(k_interval, :, k_order)' ==  ...
        EDMD.var.B21(:, :, k_order) * ...
        u(k_interval + model_order - k_order + 1, :)' ...
        ): 'B21_u(k) = B21(k) * u(t-k)');
end
EDMD.cons = EDMD.cons + (( ...
    EDMD.var.error_y(k_interval, :) == ...
    y(k_interval + model_order, :) - ( ...
    sum(EDMD.var.A21_x(k_interval,:,:), 3) + ...
    sum(EDMD.var.A22_y(k_interval,:,:), 3) + ...
    sum(EDMD.var.B21_u(k_interval,:,:), 3) ...
    )): 'error_y(t) = y(t+model_order) - sum(C(k) * x(t-k)) ');

% % stability cons
for k_order = 2 : model_order
    EDMD.cons = EDMD.cons + (( ...
        norm(EDMD.var.A22(:,:,k_order), 2) <= 1 ...
        ) : 'stable cons y');
    EDMD.var.norm_A22 = norm(EDMD.var.A22(:,:,k_order), 2);
end

EDMD.cons = EDMD.cons + ((sum(EDMD.var.norm_A22) <= 1));

%% define obj
EDMD.var.obj_y = norm(reshape(EDMD.var.error_y, 1, []), 2)^2;

%% solve
EDMD.ops = sdpsettings('solver', 'mosek', 'verbose', 0);
EDMD.ops.gurobi.NumericFocus = 1;
EDMD.sol.y = optimize(EDMD.cons, EDMD.var.obj_y, EDMD.ops);
fprintf('%s\n', EDMD.sol.y.info);
if EDMD.sol.y.problem
    EDMD.ops = sdpsettings('solver', 'gurobi', 'verbose', 0);
    EDMD.sol.y = optimize(EDMD.cons, EDMD.var.obj_y, EDMD.ops);
    if EDMD.sol.y.problem
        return;
    end
end
fprintf('%s%.4f%s\n\n', 'Solver time: ', EDMD.sol.y.solvertime, 's');
EDMD.var = myFun_GetValue(EDMD.var, 'DisplayTime', 0);

%% ------------------------------------------------------------------------
% EDMD.var.A11 = temp.A11;
% EDMD.var.A12 = temp.A12;
% EDMD.var.B11 = temp.B11;
% 
% EDMD.var.A11_x =temp.A11_x;
% EDMD.var.A12_y =temp.A12_y;
% EDMD.var.B11_u = temp.B11_u;
% 
% EDMD.var.error_x = temp.error_x;
% EDMD.var.obj_x = temp.obj_x;

end
