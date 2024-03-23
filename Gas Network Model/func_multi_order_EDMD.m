function EDMD = func_multi_order_EDMD(u, x1, x2, model_order, model_order_u)
%%
% dx1/dt = [A11 A12][x1] + [B1][ u ]
% dx2/dt = [A21 A22][x2] + [B2][ u ]

% x1(k+1) = sum(A11(i)*x1(k-i)) + sum(A12(i)*x1(k-i)) + sum(B1(i)*u(k-i))
% x2(k+1) = sum(A21(i)*x1(k-i)) + sum(A22(i)*x2(k-i)) + sum(B2(i)*u(k-i))

% x1: num_T * num_observable
% x2: num_T * num_observable
% u: num_T * num_control


global data model;
num_sample = size(x1,1);
num_x1 = size(x1,2);
num_x2 = size(x2,2);
num_u = size(u,2);

%% ------------------------------------------------------------------------
fprintf('%s\n', '------------------- Start EDMD ----------------------');

%% ------------------------------------------------------------------------
%% initialize
yalmip('clear');
EDMD.cons = [];
EDMD.var = [];

%% define vars
EDMD.var.A11 = sdpvar(num_x1, num_x1, model_order, 'full');
EDMD.var.A11 (:, :, 1) = zeros(num_x1, num_x1);
EDMD.var.A11_x = sdpvar(num_sample - model_order, num_x1, model_order, 'full');
EDMD.var.A12 = sdpvar(num_x1, num_x2, model_order, 'full');
EDMD.var.A12_x = sdpvar(num_sample - model_order, num_x1, model_order, 'full');
EDMD.var.B1 = sdpvar(num_x1, num_u, model_order_u, 'full');
EDMD.var.B1_u = sdpvar(num_sample - model_order, num_x1, model_order_u, 'full');
EDMD.var.norm_A11 = sdpvar(model_order,1,'full');

EDMD.var.error_x = sdpvar(num_sample - model_order, num_x1, 'full');

%% define cons
% x1(k+1) = sum(A11(i)*x1(k-i)) + sum(B1(i)*u(k-i))
k_interval = 1 : num_sample - model_order;
for k_order = 1 : model_order
    EDMD.cons = EDMD.cons + (( ...
        EDMD.var.A11_x(k_interval, :, k_order)' ==  ...
        EDMD.var.A11(:, :, k_order) * ...
        x1(k_interval + model_order - k_order + 1, :)' ...
        ): 'A11_x(k) = A11(k) * x1(t-k)');

    EDMD.cons = EDMD.cons + (( ...
        EDMD.var.A12_x(k_interval, :, k_order)' ==  ...
        EDMD.var.A12(:, :, k_order) * ...
        x2(k_interval + model_order - k_order + 1, :)' ...
        ): 'A12_x(k) = A12(k) * x2(t-k)');
end
for k_order = 1 : model_order_u
    EDMD.cons = EDMD.cons + (( ...
        EDMD.var.B1_u(:, :, k_order)' ==  ...
        EDMD.var.B1(:, :, k_order) * ...
        u(k_interval + model_order - k_order + 1, :)' ...
        ): 'B1_u(k) = B1(k) * u(t-k)');
end
EDMD.cons = EDMD.cons + (( ...
    EDMD.var.error_x(k_interval, :) == ...
    x1(k_interval + model_order, :) - ( ...
    sum(EDMD.var.A11_x, 3) + ...
    sum(EDMD.var.A12_x, 3) + ...
    sum(EDMD.var.B1_u, 3) ...
    )): 'error_x(t) = x1(t+model_order) - sum(A(k) * x1(t-k)) ');

% % stability cons，rho(A11)<1
for k_order = 1 : model_order
    EDMD.cons = EDMD.cons + (( ...
        norm(EDMD.var.A11(:,:,k_order), 2) <= 1 ...
        ) : 'stable cons for x1');
    EDMD.var.norm_A11(k_order,1) = norm(EDMD.var.A11(:,:,k_order), 2);
end

EDMD.cons = EDMD.cons + (( ...
    sum(EDMD.var.norm_A11) <= 1 ...
    ));

%% define obj
EDMD.var.obj_x = sum(reshape(EDMD.var.error_x, 1, []) .^2);

%% solve
EDMD.ops = sdpsettings('solver', 'mosek', 'verbose', 0);
EDMD.sol.x1 = optimize(EDMD.cons, EDMD.var.obj_x, EDMD.ops);
fprintf('%s\n', EDMD.sol.x1.info);
if EDMD.sol.x1.problem
    return;
end
fprintf('%s%.4f%s\n\n', 'Solver time: ', EDMD.sol.x1.solvertime, 's');
EDMD.var = myFun_GetValue(EDMD.var, 'DisplayTime', 0);
% temp = EDMD.var;

%% ------------------------------------------------------------------------
%% initialize
% yalmip('clear');
% EDMD.cons = [];
% EDMD.var = [];

%% define cons
EDMD.var.A21 = sdpvar(num_x2, num_x1, model_order, 'full');
EDMD.var.A21_x = sdpvar(num_sample - model_order, num_x2, model_order, 'full');
EDMD.var.A22 = sdpvar(num_x2, num_x2, model_order, 'full');
EDMD.var.A22 (:, :, 1) = zeros(num_x2, num_x2);
EDMD.var.A22_x = sdpvar(num_sample - model_order, num_x2, model_order, 'full');
EDMD.var.B2 = sdpvar(num_x2, num_u, model_order_u, 'full');
EDMD.var.B2_u = sdpvar(num_sample - model_order, num_x2, model_order_u, 'full');
EDMD.var.norm_A22 = sdpvar()

EDMD.var.error_y = sdpvar(num_sample - model_order + 1, num_x2, 'full');

%% define cons
% x2(k+1) = sum(A21(i)*x1(k-i)) + sum(A22(i)*x2(k-i)) + sum(B2(i)*u(k-i))
k_interval = 1 : num_sample - model_order;
for k_order = 1 : model_order
    EDMD.cons = EDMD.cons + (( ...
        EDMD.var.A21_x(k_interval, :, k_order)' ==  ...
        EDMD.var.A21(:, :, k_order) * ...
        x1(k_interval + model_order - k_order + 1 , :)' ...
        ): 'A21_x(k) = A21(k) * x1(t-k)');

    EDMD.cons = EDMD.cons + (( ...
        EDMD.var.A22_x(k_interval, :, k_order)' ==  ...
        EDMD.var.A22(:, :, k_order) * ...
        x2(k_interval + model_order - k_order + 1, :)' ...
        ): 'A22_x(k) = A22(k) * x2(t-k)');
end
for k_order = 1 : model_order_u
    EDMD.cons = EDMD.cons + (( ...
        EDMD.var.B2_u(k_interval, :, k_order)' ==  ...
        EDMD.var.B2(:, :, k_order) * ...
        u(k_interval + model_order - k_order + 1, :)' ...
        ): 'B21_u(k) = B21(k) * u(t-k)');
end
EDMD.cons = EDMD.cons + (( ...
    EDMD.var.error_y(k_interval, :) == ...
    x2(k_interval + model_order, :) - ( ...
    sum(EDMD.var.A21_x(k_interval,:,:), 3) + ...
    sum(EDMD.var.A22_x(k_interval,:,:), 3) + ...
    sum(EDMD.var.B2_u(k_interval,:,:), 3) ...
    )): 'error_y(t) = x2(t+model_order) - sum(C(k) * x1(t-k)) ');

% % stability cons
for k_order = 1 : model_order
    EDMD.cons = EDMD.cons + (( ...
        norm(EDMD.var.A22(:,:,k_order), 2) <= 1 ...
        ) : 'stable cons x2');
    EDMD.var.norm_A22(k_order, 1) = norm(EDMD.var.A22(:,:,k_order), 2);
end

EDMD.cons = EDMD.cons + ((sum(EDMD.var.norm_A22) <= 1));

%% define obj
EDMD.var.obj_y = norm(reshape(EDMD.var.error_y, 1, []), 2)^2;

%% solve
EDMD.ops = sdpsettings('solver', 'mosek', 'verbose', 0);
EDMD.ops.gurobi.NumericFocus = 1;
EDMD.sol.x2 = optimize(EDMD.cons, EDMD.var.obj_y, EDMD.ops);
fprintf('%s\n', EDMD.sol.x2.info);
if EDMD.sol.x2.problem
    EDMD.ops = sdpsettings('solver', 'gurobi', 'verbose', 0);
    EDMD.sol.x2 = optimize(EDMD.cons, EDMD.var.obj_y, EDMD.ops);
    if EDMD.sol.x2.problem
        return;
    end
end
fprintf('%s%.4f%s\n\n', 'Solver time: ', EDMD.sol.x2.solvertime, 's');
EDMD.var = myFun_GetValue(EDMD.var, 'DisplayTime', 0);

%% ------------------------------------------------------------------------
% EDMD.var.A11 = temp.A11;
% EDMD.var.A12 = temp.A12;
% EDMD.var.B1 = temp.B11;
% 
% EDMD.var.A11_x =temp.A11_x;
% EDMD.var.A12_x =temp.A12_y;
% EDMD.var.B1_u = temp.B11_u;
% 
% EDMD.var.error_x = temp.error_x;
% EDMD.var.obj_x = temp.obj_x;

end
