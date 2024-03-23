clc; clear all; close all;
yalmip('clear');
warning off;

%%
global data model;

%% read data
filename = 'output_old'; 
func_readdata(filename); % 1-updata, 0-remain
filename = 'Network_parameters'; 
pipe_para = xlsread(filename,1,'A2:BB10000');
pi = 3.1416;
Len = pipe_para(:,5);
D = pipe_para(:,4);
A = pi*D.^2/4;
num_sample = size(data.var.Min,1);
num_pipeline = size(data.var.Min,2);% 50个管道

data.Parameters.lamta = 0.02525;
data.Parameters.c = 340;

%%
model.cons = [];
model.var = [];



%% define vars
model.var.Min = data.var.Mout;
model.var.Pout = sdpvar(num_sample, num_pipeline, 'full');


for i = 1 : num_pipeline

    model.cons = model.cons + (( ...
        (model.var.Pout(:,i) - data.var.Pin(:,i))/Len(i,1) + ...
        data.Parameters.lamta*data.Parameters.c^2/2/D(i,1)/A(i,1)^2 * ...
        data.var.Mout(:,i).^2./data.var.Pin(:,i) == ...
        0): 'Min = Mout');

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
error_Min = (model.var.Min - data.var.Min)./data.var.Min*100;

%% draw

h_fig = figure();          % gcf: get current figure
h_axis = gca;              % gca: get current axis

% % set position & color
% position, color,
left = 10; bottom = 10; width = 10; height = 6;
% units:inches|centimeters|normalized|points|{pixels}|characters
set(h_fig, 'Units','centimeters', 'position', [left, bottom, width, height], 'color', 'w');

% % Remove the blank edge
set(gca,'LooseInset',get(gca,'TightInset'));

% % Setting color
cmap = brewermap(8,'Set3');
h_fig.Colormap = cmap;
h_axis.Colormap = cmap;
colororder(cmap)

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
h_fig = figure();          % gcf: get current figure
h_axis = gca;              % gca: get current axis

% % set position & color
% position, color,
left = 10; bottom = 10; width = 10; height = 6;
% units:inches|centimeters|normalized|points|{pixels}|characters
set(h_fig, 'Units','centimeters', 'position', [left, bottom, width, height], 'color', 'w');

% % Remove the blank edge
set(gca,'LooseInset',get(gca,'TightInset'));

% % Setting color
cmap = brewermap(8,'Set3');
h_fig.Colormap = cmap;
h_axis.Colormap = cmap;
colororder(cmap)

for k = 1:num_pipeline
    plot(x,error_Min(:,k));
    hold on
end
grid

set(gca,'FontName','Times New Roman','FontSize',12);
xlabel('NO.','fontname','Times New Roman','fontsize',13);
ylabel('Relative error (%)','fontname','Times New Roman','fontsize',13);
hold off;