% clc;clear
% function network_comp( )

global data model

aa = model.q3 + model.oef.var.ngs.Min_interpolated(2:end,3)';
a4 =  model.oef.var.ngs.Min_interpolated(2:end,6)';
a7 = model.oef.var.ngs.Min_interpolated(2:end,14)' +model.q3 - model.oef.var.ngs.Mout_interpolated(2:end,13)';

pppp=model.oef.var.ngs.Pnode(12,:)'/1000000;

time_interval_ngs = data.settings.time_interval_ngs_second/3600;
num_initialtime = data.settings.num_initialtime_ngs/time_interval_ngs;
num_period_ngs = data.settings.num_period*1/time_interval_ngs;
num_start = num_initialtime + 1;
num_end = num_initialtime + num_period_ngs;

% 
filename = 'to_excel_d_v1.xlsx';
diff_network = xlsread(filename);
diff_network = diff_network(2:94, :);
indices = 1:4:size(diff_network, 1);
d_24h_data = diff_network(indices, :);

filename = 'to_excel_k.xlsx';
k_network = xlsread(filename);
k_network = k_network(2:end, :);
indices = 4:4:size(k_network, 1);
k_24h_data = k_network(indices, :);
% k_24h_data = k_network;

data_plot = k_24h_data;

%%
% % 
% h_fig = figure();          % gcf: get current figure
% h_axis = gca;              % gca: get current axis
% 
% % % set position & color
% % position, color,
% left = 10; bottom = 10; width = 10; height = 6;
% % units:inches|centimeters|normalized|points|{pixels}|characters
% set(h_fig, 'Units','centimeters', 'position', [left, bottom, width, height], 'color', 'w');
% 
% % % Remove the blank edge
% set(gca,'LooseInset',get(gca,'TightInset'));
% 
% % % Setting color
% cmap = brewermap(6,'Set3');
% h_fig.Colormap = cmap;
% h_axis.Colormap = cmap;
% colororder(cmap)
% 
% x = 1:num_period_ngs;
% subplot(1,5,1)
% plot(x,data_plot(:,15),Color='r');
% hold on
% plot(x,model.oef.var.ngs.Min(num_start:num_end,7),Color='b');
% grid
% set(gca,'FontName','Times New Roman','FontSize',12);
% xlabel('Time (h).','fontname','Times New Roman','fontsize',13);
% ylabel('Min_7','fontname','Times New Roman','fontsize',13);
% % ylim([0,45]);
% 
% subplot(1,5,2)
% plot(x,data_plot(:,11),Color='r');
% hold on
% plot(x,model.oef.var.ngs.Min(num_start:num_end,3),Color='b');
% grid
% set(gca,'FontName','Times New Roman','FontSize',12);
% xlabel('Time (h).','fontname','Times New Roman','fontsize',13);
% ylabel('Min_3','fontname','Times New Roman','fontsize',13);
% % ylim([20,55]);
% 
% subplot(1,5,3)
% plot(x,data_plot(:,7),Color='r');
% hold on
% plot(x,model.oef.var.ngs.Min(num_start:num_end,2),Color='b');
% grid
% set(gca,'FontName','Times New Roman','FontSize',12);
% xlabel('Time (h).','fontname','Times New Roman','fontsize',13);
% ylabel('Min_2','fontname','Times New Roman','fontsize',13);
% % ylim([20,55]);
% 
% 
% subplot(1,5,4)
% plot(x,data_plot(:,3),Color='r');
% hold on
% plot(x,model.oef.var.ngs.Min(num_start:num_end,1),Color='b');
% grid
% set(gca,'FontName','Times New Roman','FontSize',12);
% xlabel('Time (h).','fontname','Times New Roman','fontsize',13);
% ylabel('Min_1','fontname','Times New Roman','fontsize',13);
% % ylim([20,55]);
% 
% 
% subplot(1,5,5)
% plot(x,data_plot(:,58),Color='r');
% hold on
% plot(x,model.oef.var.ngs.Pout(num_start:num_end,15),Color='b');
% grid
% set(gca,'FontName','Times New Roman','FontSize',12);
% xlabel('Time (h).','fontname','Times New Roman','fontsize',13);
% ylabel('Pout','fontname','Times New Roman','fontsize',13);
% % ylim([20,55]);
% 
% legend('network simulation results','k method',...
%     'FontName','Times New Roman','Box','off');

%% ---------------------------------------------------------------------------------------------------------------------------------------
%%
%%
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
cmap = brewermap(6,'Set3');
h_fig.Colormap = cmap;
h_axis.Colormap = cmap;
colororder(cmap)

x = 1:num_period_ngs;
subplot(1,5,1)
plot(x,data_plot(:,6),Color='r');
hold on
plot(x,model.oef.var.ngs.Pout(num_start:num_end,2),Color='b');
grid
set(gca,'FontName','Times New Roman','FontSize',12);
xlabel('Time (h).','fontname','Times New Roman','fontsize',13);
ylabel('Pout','fontname','Times New Roman','fontsize',13);
% ylim([0,45]);

subplot(1,5,2)
plot(x,data_plot(:,14),Color='r');
hold on
plot(x,model.oef.var.ngs.Pout(num_start:num_end,4),Color='b');
grid
set(gca,'FontName','Times New Roman','FontSize',12);
xlabel('Time (h).','fontname','Times New Roman','fontsize',13);
ylabel('Pout','fontname','Times New Roman','fontsize',13);
% ylim([20,55]);

subplot(1,5,3)
plot(x,data_plot(:,22),Color='r');
hold on
plot(x,model.oef.var.ngs.Pout(num_start:num_end,6),Color='b');
grid
set(gca,'FontName','Times New Roman','FontSize',12);
xlabel('Time (h).','fontname','Times New Roman','fontsize',13);
ylabel('Pout','fontname','Times New Roman','fontsize',13);
% ylim([20,55]);


subplot(1,5,4)
plot(x,data_plot(:,26),Color='r');
hold on
plot(x,model.oef.var.ngs.Pout(num_start:num_end,7),Color='b');
grid
set(gca,'FontName','Times New Roman','FontSize',12);
xlabel('Time (h).','fontname','Times New Roman','fontsize',13);
ylabel('Pout','fontname','Times New Roman','fontsize',13);
% ylim([20,55]);


subplot(1,5,5)
plot(x,data_plot(:,34),Color='r');
hold on
plot(x,model.oef.var.ngs.Pout(num_start:num_end,9),Color='b');
grid
set(gca,'FontName','Times New Roman','FontSize',12);
xlabel('Time (h).','fontname','Times New Roman','fontsize',13);
ylabel('Pout','fontname','Times New Roman','fontsize',13);
% ylim([20,55]);

legend('network simulation results','k method',...
    'FontName','Times New Roman','Box','off');

%%
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
cmap = brewermap(6,'Set3');
h_fig.Colormap = cmap;
h_axis.Colormap = cmap;
colororder(cmap)

x = 1:num_period_ngs;
subplot(1,5,1)
plot(x,data_plot(:,57),Color='r');
hold on
plot(x,model.oef.var.ngs.Pin(num_start:num_end,15),Color='b');
grid
set(gca,'FontName','Times New Roman','FontSize',12);
xlabel('Time (h).','fontname','Times New Roman','fontsize',13);
ylabel('Pout','fontname','Times New Roman','fontsize',13);
% ylim([0,45]);

subplot(1,5,2)
plot(x,data_plot(:,62),Color='r');
hold on
plot(x,model.oef.var.ngs.Pout(num_start:num_end,16),Color='b');
grid
set(gca,'FontName','Times New Roman','FontSize',12);
xlabel('Time (h).','fontname','Times New Roman','fontsize',13);
ylabel('Pout','fontname','Times New Roman','fontsize',13);
% ylim([20,55]);

subplot(1,5,3)
plot(x,data_plot(:,66),Color='r');
hold on
plot(x,model.oef.var.ngs.Pout(num_start:num_end,17),Color='b');
grid
set(gca,'FontName','Times New Roman','FontSize',12);
xlabel('Time (h).','fontname','Times New Roman','fontsize',13);
ylabel('Pout','fontname','Times New Roman','fontsize',13);
% ylim([20,55]);

subplot(1,5,4)
plot(x,data_plot(:,70),Color='r');
hold on
plot(x,model.oef.var.ngs.Pout(num_start:num_end,18),Color='b');
grid
set(gca,'FontName','Times New Roman','FontSize',12);
xlabel('Time (h).','fontname','Times New Roman','fontsize',13);
ylabel('Pout','fontname','Times New Roman','fontsize',13);
% ylim([20,55]);


subplot(1,5,5)
plot(x,data_plot(:,74),Color='r');
hold on
plot(x,model.oef.var.ngs.Pout(num_start:num_end,19),Color='b');
grid
set(gca,'FontName','Times New Roman','FontSize',12);
xlabel('Time (h).','fontname','Times New Roman','fontsize',13);
ylabel('Pout','fontname','Times New Roman','fontsize',13);
% ylim([20,55]);




%% 
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
cmap = brewermap(6,'Set3');
h_fig.Colormap = cmap;
h_axis.Colormap = cmap;
colororder(cmap)

subplot(1,2,1)
plot(x,data_plot(:,3),Color='r');
hold on
plot(x,model.oef.var.ngs.Min(num_start:num_end,1),Color='b');
grid
set(gca,'FontName','Times New Roman','FontSize',12);
xlabel('Time (h).','fontname','Times New Roman','fontsize',13);
ylabel('Min','fontname','Times New Roman','fontsize',13);
% ylim([0,45]);

subplot(1,2,2)
plot(x,data_plot(:,31),Color='r');
hold on
plot(x,model.oef.var.ngs.Min(num_start:num_end,8),Color='b');
grid
set(gca,'FontName','Times New Roman','FontSize',12);
xlabel('Time (h).','fontname','Times New Roman','fontsize',13);
ylabel('Min','fontname','Times New Roman','fontsize',13);
% ylim([20,55]);
delta1 = (data_plot(:,3) - model.oef.var.ngs.Min(num_start:num_end,1))./data_plot(:,3)*100;
delta2 = (data_plot(:,31) - model.oef.var.ngs.Min(num_start:num_end,8))./data_plot(:,31)*100;

