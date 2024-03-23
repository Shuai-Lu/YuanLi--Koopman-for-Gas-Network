clc; clear all; close all;
yalmip('clear');
warning off;

%%
global data model;

%% read data
filename = 'output'; 
func_readdata(filename); % 1-updata, 0-remain
filename = '5nodes'; 
pipe_para = xlsread(filename,1,'A2:BB10000');
pi = 3.1416;
Len = pipe_para(:,5)*1000;
D = pipe_para(:,4);
A = pi*D.^2/4;
rho_w = 0.75;     % kg/m^3;
delta_t = 1;
num_sample = size(data.var.Min,1);
num_pipeline = size(data.var.Min,2);% 50个管道

data.Parameters.lamta = 0.02525;
data.Parameters.c = 340;

%%
model.cons = [];
model.var = [];

%% define vars
% data.var.Min , data.var.Pin 1000*6
model.var.Mout = sdpvar(num_sample, num_pipeline, 'full');
model.var.Pout = sdpvar(num_sample, num_pipeline, 'full');
v1 = data.var.Min/rho_w./(A*ones(1,1000))'; % 1000*6
v2 = model.var.Mout/rho_w./(A*ones(1,1000))';
average_v = 10;
% model.cons = model.cons + (( ...
%     average_v *(v1+v2)  ...
%     == 2*(v2.^2+v1.*v2+v1.^2)/3): 'Min = Mout');
model.var.Mout(1,:) = data.var.Mout(1,:);
model.var.Pout(1,:) = data.var.Pout(1,:);

for i = 1 : num_pipeline
    for t = 2 : num_sample
        model.cons = model.cons + (( ...
            (model.var.Pout(t,i) - data.var.Pin(t,i))/Len(i,1) + ...
            (model.var.Mout(t,i) - model.var.Mout(t-1,i))/A(i,1)/delta_t + ...
            data.Parameters.lamta*average_v/2/D(i,1)/A(i,1) * model.var.Mout(t,i) ...
            == 0): 'Min = Mout');
        model.cons = model.cons + (( ...
            (model.var.Pout(t,i) - model.var.Pout(t-1,i))/delta_t/data.Parameters.c^2 + ...
            (model.var.Mout(t,i) - data.var.Min(t,i))/A(i,1)/Len(i,1)  ...
            == 0): 'Min = Mout');
    end
end

model.obj = 0;
%%
model.ops = sdpsettings('solver', 'ipopt', 'verbose', 2, 'usex0', 1);
model.ops.ipopt.max_iter = 100000;
model.ops.ipopt.max_cpu_time = 500000;
model.sol = optimize(model.cons, model.obj, model.ops);


if ~ model.sol.problem
    model = myFun_GetValue(model);
    fprintf('%s%.4f\n','Object: ', model.obj);
    fprintf('%s%.4f%s\n','solvertime: ', model.sol.solvertime,' s');

else
    fprintf('%s\n', model.sol.info);
end

error_Pout = (model.var.Pout - data.var.Pout)./data.var.Pout*100;
error_Mout = (model.var.Mout - data.var.Mout)./data.var.Mout*100;

%% draw

x = 1:1000;
for k = 1:num_pipeline
    plot(x,error_Pout(:,k));
    hold on
end
grid
set(gca,'FontName','Times New Roman','FontSize',12);
xlabel('NO.','fontname','Times New Roman','fontsize',13);
ylabel('Relative error (%)','fontname','Times New Roman','fontsize',13);
hold off;

% %
figure();          % gcf: get current figure
for k = 1:num_pipeline
    plot(x,error_Mout(:,k));
    hold on
end
grid
set(gca,'FontName','Times New Roman','FontSize',12);
xlabel('NO.','fontname','Times New Roman','fontsize',13);
ylabel('Relative error (%)','fontname','Times New Roman','fontsize',13);
hold off;