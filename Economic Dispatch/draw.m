
global model

%% 图1. 电力平衡绘图
% 
% h_fig = figure();          % gcf: get current figure
% h_axis = gca;              % gca: get current axis
% 
% % % set position & color
% % position, color,
% left = 10; bottom = 10; width = 11; height = 4;
% % units:inches|centimeters|normalized|points|{pixels}|characters
% set(h_fig, 'Units','centimeters', 'position', [left, bottom, width, height], 'color', 'w');
% 
% % % Remove the blank edge
% set(gca,'LooseInset',get(gca,'TightInset'));
% 
% % % Setting color
% cmap = brewermap(6,'Set1');
% h_fig.Colormap = cmap;
% h_axis.Colormap = cmap;
% colororder(cmap)
% 
% coal_fired = model.oef.var.eps.P_gen(:,1) + model.oef.var.eps.P_gen(:,2) + model.oef.var.eps.P_gen(:,5);
% wind_fired = model.oef.var.eps.P_gen(:,3) + model.oef.var.eps.P_gen(:,4);
% GT_fired = model.oef.var.eps.P_gt;
% P2G_load = -model.oef.var.eps.P_p2g;
% stacked_data_e = [coal_fired, wind_fired, GT_fired, P2G_load];
% Pload = sum(data.profile.P_load, 2);
% 
% % 画柱状图
% b = bar(stacked_data_e, 'stacked','EdgeColor', 'none','LineWidth',0.5,'BarWidth',0.5);hold on;
% set (b,'edgecolor','none');
% plot(Pload, 'LineWidth', 1.5, 'Color', 'blue');
% 
% grid
% xlim([0.2, 24.8]);
% ylim([-200, 800]);
% xticks(2:2:24);
% set(gca,'FontName','Times New Roman','FontSize',9);
% xlabel('Time (hours)', 'fontname','Times New Roman','fontsize',9.5);
% ylabel('Power (MW)','fontname','Times New Roman','fontsize',9.5);
% 
% % 添加图例
% legend({['Coal-fired'], ['Wind turbine'], ['GT'], ['P2G'], ['Electrical load']}, ...
%         'NumColumns', 3,'FontName', 'Times New Roman', 'FontSize', 9, 'Interpreter', 'latex', ...
%        'Orientation', 'horizontal', 'Box', 'off');
% 
% 
% %% 图2.（a)  气网，2个源的气流
% % 因为气网中并没有平衡的关系
% 
% h_fig = figure();          % gcf: get current figure
% h_axis = gca;              % gca: get current axis
% 
% % % set position & color
% % position, color,
% left = 10; bottom = 10; width = 11; height = 4;
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
% % subplot(2,1,1)
% plot(model.oef.var.ngs.Min(41:end,1), 'LineWidth', 1.1, 'Color', 'red', 'Marker', 'o', 'MarkerSize', 1);hold on;
% plot(model.oef.var.ngs.Min(41:end,8), 'LineWidth', 1.1, 'Color', 'blue', 'Marker', '^', 'MarkerSize', 1);hold on;
% % plot(model.oef.var.eps.M_p2g(:,1), 'LineWidth', 1.5, 'Color', 'blue');
% grid
% xlim([1, 96]);
% ylim([20, 40]);
% xticks(0:8:96);
% set (gca,'XTickLabel', {'0','2','4','6','8','10','12'...
%     ,'14','16','18','20','22','24'})
% 
% set(gca,'FontName','Times New Roman','FontSize',9);
% xlabel('Time (hour)', 'fontname','Times New Roman','fontsize',9.5);
% ylabel('MFR (kg/s)','fontname','Times New Roman','fontsize',9.5);
% 
% % 添加图例
% legend({['Source1-N1'], ['Source2-N8']}, ...
%         'NumColumns', 2,'FontName', 'Times New Roman', 'FontSize', 9, 'Interpreter', 'latex', ...
%        'Orientation', 'horizontal', 'Box', 'off');
% 
% %%  图2.（b) gas load, gt, p2g
% 
% h_fig = figure();          % gcf: get current figure
% h_axis = gca;              % gca: get current axis
% 
% % % set position & color
% % position, color,
% left = 10; bottom = 10; width = 11; height = 4;
% % units:inches|centimeters|normalized|points|{pixels}|characters
% set(h_fig, 'Units','centimeters', 'position', [left, bottom, width, height], 'color', 'w');
% 
% % % Remove the blank edge
% set(gca,'LooseInset',get(gca,'TightInset'));
% 
% % % Setting color
% cmap = brewermap(6,'Set1');
% h_fig.Colormap = cmap;
% h_axis.Colormap = cmap;
% colororder(cmap)
% 
% % subplot(2,1,2)
% 
% M_GT1 = model.oef.var.eps.M_gt;
% M_GT_reshaped = reshape(M_GT1, 4, []); % 将向量变为4行
% M_GT_summed = sum(M_GT_reshaped); % 对每列求和
% M_GT = M_GT_summed(:); % 将结果转换为列向量
% 
% Mload = sum(data.profile.M_load, 2);
% Mp2g1 = -model.oef.var.eps.M_p2g;
% M_p2g_reshaped = reshape(Mp2g1, 4, []); % 将向量变为4行
% M_p2g_summed = sum(M_p2g_reshaped); % 对每列求和
% Mp2g = M_p2g_summed(:); % 将结果转换为列向量
% 
% stacked_data_h = [Mload, M_GT, Mp2g];
% 
% % 画柱状图
% h = bar(stacked_data_h, 'stacked','EdgeColor', 'none','LineWidth',0.5,'BarWidth',0.5);hold on;
% 
% grid
% xlim([0.2, 24.8]);
% ylim([-50, 170]);
% xticks(0:2:24);
% set(gca,'FontName','Times New Roman','FontSize',9);
% xlabel('Time (hour)', 'fontname','Times New Roman','fontsize',9.5);
% ylabel('MFR (kg/s)','fontname','Times New Roman','fontsize',9.5);
% 
% % 添加图例
% legend({['Gas load'], ['GT'], ['P2G']}, ...
%         'NumColumns', 3,'FontName', 'Times New Roman', 'FontSize', 9, 'Interpreter', 'latex', ...
%        'Orientation', 'horizontal', 'Box', 'off');


%% 图3. 平均管存

% h_fig = figure();          % gcf: get current figure
% h_axis = gca;              % gca: get current axis
% 
% % % set position & color
% % position, color,
% left = 10; bottom = 10; width = 15; height = 4.5;
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
% average_Lp = sum(model.oef.var.ngs.Lp, 2)/19/1000;
% subplot(1,2,1)
% plot(average_Lp, 'LineWidth', 1.3, 'Color', 'r', 'Marker', 'o', 'MarkerSize', 2);grid
% set(gca,'FontName','Times New Roman','FontSize',10);
% xlabel('Time (hour)', 'fontname','Times New Roman','fontsize',11);
% ylabel('Linepack (ton)','fontname','Times New Roman','fontsize',11);
% xlim([1, 24]);
% xticks(0:6:24);
% ylim([550, 620]);
% hold on;
% subplot(1,2,2)
% plot(model.oef.var.ngs.Lp(:,18)/1000,  'LineWidth', 1.3, 'Color', 'b', 'Marker', 'o', 'MarkerSize', 2)
% grid
% set(gca,'FontName','Times New Roman','FontSize',10);
% xlabel('Time (hour)', 'fontname','Times New Roman','fontsize',11);
% ylabel('Linepack (ton)','fontname','Times New Roman','fontsize',11);
% xlim([1, 24]);
% ylim([790, 1000]);
% xticks(0:6:24);

%% 图4（a） pipe 18首末端气流

% h_fig = figure();          % gcf: get current figure
% h_axis = gca;              % gca: get current axis
% 
% % set position & color
% position, color,
% left = 10; bottom = 10; width = 11.5; height = 4;
% units:inches|centimeters|normalized|points|{pixels}|characters
% set(h_fig, 'Units','centimeters', 'position', [left, bottom, width, height], 'color', 'w');
% 
% % Remove the blank edge
% set(gca,'LooseInset',get(gca,'TightInset'));
% 
% % Setting color
% cmap = brewermap(6,'Set3');
% h_fig.Colormap = cmap;
% h_axis.Colormap = cmap;
% colororder(cmap)
% 
% x = 1:96;
% subplot(1,2,1)
% plot(x,model.oef.var.ngs.Min(41:end,18),'Color','r', 'LineWidth', 1, 'Marker', 'o', 'MarkerSize', 2);
% hold on
% plot(x,model.oef.var.ngs.Mout(41:end,18),'Color','b', 'LineWidth', 1, 'Marker', '^', 'MarkerSize', 2);
% 
% grid
% set(gca,'FontName','Times New Roman','FontSize',10);
% xlabel('Time (hour)','fontname','Times New Roman','fontsize',11);
% ylabel('MFR (kg/s)','fontname','Times New Roman','fontsize',11);
% ylim([8,25])
% xlim([1, 24]);
% xticks(0:6:24);
% title('dispatch diff')
% legend({['Initial flow'], ['Terminal flow']}, ...
%         'NumColumns', 1,'FontName', 'Times New Roman', 'FontSize', 9.5, 'Interpreter', 'latex', ...
%        'Orientation', 'horizontal', 'Box', 'off');

%% pipe 12 图4（b） 首末端气压

% h_fig = figure();          % gcf: get current figure
% h_axis = gca;              % gca: get current axis
% 
% % % set position & color
% % position, color,
% left = 10; bottom = 10; width = 11.5; height = 4;
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
% x = 1:24;
% % subplot(1,2,1)
% plot(x,model.oef.var.ngs.Pin(11:34,18)/1e6,'Color','r', 'LineWidth', 1, 'Marker', 'o', 'MarkerSize', 2);
% hold on
% plot(x,model.oef.var.ngs.Pout(11:34,18)/1e6,'Color','b', 'LineWidth', 1, 'Marker', '^', 'MarkerSize', 2);
% 
% grid
% set(gca,'FontName','Times New Roman','FontSize',10);
% xlabel('Time (hour)','fontname','Times New Roman','fontsize',11);
% ylabel('Pressure (Mpa)','fontname','Times New Roman','fontsize',11);
% ylim([5.7,7.05])
% xlim([1, 24]);
% % xticks(0:6:24);
% % title('dispatch diff')
% legend({['Initial pressure'], ['Terminal pressure']}, ...
%         'NumColumns', 1,'FontName', 'Times New Roman', 'FontSize', 9.5, 'Interpreter', 'latex', ...
%        'Orientation', 'horizontal', 'Box', 'off');
%% 画误差小图， 源处的Min， 和负荷处的Pout； 差分法：
relative_error_Min = (model.Min_dis - model.Min_verify)/10;
relative_error_Pout = (model.Pout_dis - model.Pout_verify)/5e6;

h_fig = figure();          % gcf: get current figure
h_axis = gca;              % gca: get current axis

% % set position & color
% position, color,
left = 10; bottom = 10; width = 17; height = 6.1;
% units:inches|centimeters|normalized|points|{pixels}|characters
set(h_fig, 'Units','centimeters', 'position', [left, bottom, width, height], 'color', 'w');

% % Remove the blank edge
set(gca,'LooseInset',get(gca,'TightInset'));

% % Setting color
cmap = brewermap(10,'Set1');
h_fig.Colormap = cmap;
h_axis.Colormap = cmap;
colororder(cmap)
% 创建 axes

b=subplot(1,2,1);
set(b,...
    'Position',[0.13 0.184411286668547 0.334659090909091 0.520190703381204]);

plot(relative_error_Pout(:,18), 'LineWidth', 2, 'Color', [1 0 0],'LineStyle','-');hold on;
plot(relative_error_Pout(:,19), 'LineWidth', 2, 'Color', [0 0 1],'LineStyle','-.');hold on;
for k = 1:17
    plot(relative_error_Pout(:,k), 'LineWidth', 0.5,'Color',[0.65,0.65,0.65],'LineStyle','--');hold on;
end

grid
set(gca,'FontName','Times New Roman','FontSize',11);
xlabel('Time (hour)', 'fontname','Times New Roman','fontsize',12);
ylabel('Normalized error (p.u.)','fontname','Times New Roman','fontsize',12);
xlim([1, 24]);
xticks(0:6:24);


c=subplot(1,2,2);
set(c,...
    'Position',[0.570340909090909 0.184411286776 0.334659090909091 0.522678265462806]);
plot(relative_error_Min(:,18), 'LineWidth', 2, 'Color', [1 0 0],'LineStyle','-');hold on;
plot(relative_error_Min(:,19), 'LineWidth', 2, 'Color', [0 0 1],'LineStyle','-.');hold on;
for k = 1:17
    plot(relative_error_Min(:,k), 'LineWidth', 0.5,'Color',[0.65,0.65,0.65],'LineStyle','--');hold on;
end

grid
set(gca,'FontName','Times New Roman','FontSize',11);
xlabel('Time (hour)', 'fontname','Times New Roman','fontsize',12);
ylabel('Normalized error (p.u.)','fontname','Times New Roman','fontsize',12);
xlim([1, 24]);
xticks(0:6:24);


legend({ 'pipeline 18','pipeline 19', 'other pipelines'}, ...
    'FontName', 'Times New Roman', 'FontSize', 11, 'Interpreter', 'latex', 'Orientation', 'horizontal', 'Box', 'off','NumColumns', 7,...
    'Position',[0.131496305755588 0.757118544523824 0.777643060414705 0.25161692467495],...
    'Orientation','horizontal');

%% 画误差小图， 源处的Min， 和负荷处的Pout； 差分法：
relative_error_Min = (model.Min_dis - model.Min_verify)./10;
relative_error_Pout = (model.Pout_dis - model.Pout_verify)./5e6;

h_fig = figure();          % gcf: get current figure
h_axis = gca;              % gca: get current axis

% % set position & color
% position, color,
left = 10; bottom = 10; width = 17; height = 5.8;
% units:inches|centimeters|normalized|points|{pixels}|characters
set(h_fig, 'Units','centimeters', 'position', [left, bottom, width, height], 'color', 'w');

% % Remove the blank edge
set(gca,'LooseInset',get(gca,'TightInset'));

% % Setting color
cmap = brewermap(10,'Set1');
h_fig.Colormap = cmap;
h_axis.Colormap = cmap;
colororder(cmap)

c= subplot(1,2,1);
set(c,...
    'Position',[0.570340909090909 0.184411286776 0.334659090909091 0.522678265462806]);
plot(relative_error_Min(:,1), 'LineWidth', 1, 'Marker', 'o', 'MarkerSize', 2, 'Color', [0, 0, 1]);hold on;
plot(relative_error_Min(:,8), 'LineWidth', 1, 'Marker', '^', 'MarkerSize', 2, 'Color', [1, 0, 0]);
grid
set(gca,'FontName','Times New Roman','FontSize',11);
xlabel('Time (hour)', 'fontname','Times New Roman','fontsize',12);
ylabel('Normalized error (p.u.)','fontname','Times New Roman','fontsize',12);
xlim([1, 24]);
ylim([-0.3, 0.3]);

xticks(0:6:24);
% ylim([550, 620]);
legend({['Source1-N1'], ['Source2-N8']}, ...
        'NumColumns', 1,'FontName', 'Times New Roman', 'FontSize', 8, 'Interpreter', 'latex', ...
       'Orientation', 'horizontal', 'Box', 'off');

%% koopman 和非线性的结果对比图

% filename = 'to_excel_d_v1.xlsx';
% k_network = xlsread(filename);
% k_network = k_network(2:end, :);
% indices = 4:4:size(k_network, 1);
% k_24h_data = k_network(indices, :);
% data_plot = k_24h_data;
% 
% h_fig = figure();          % gcf: get current figure
% h_axis = gca;              % gca: get current axis
% 
% % % set position & color
% % position, color,
% left = 10; bottom = 10; width = 17; height = 4.5;
% % units:inches|centimeters|normalized|points|{pixels}|characters
% set(h_fig, 'Units','centimeters', 'position', [left, bottom, width, height], 'color', 'w');
% 
% % % Remove the blank edge
% set(gca,'LooseInset',get(gca,'TightInset'));
% 
% % % Setting color
% cmap = brewermap(10,'Set3');
% h_fig.Colormap = cmap;
% h_axis.Colormap = cmap;
% colororder(cmap)
% 
% x = 1 : 24;
% subplot(1,2,1)
% plot(x,data_plot(:,53)/1e6, 'LineWidth', 1, 'LineStyle', '-', 'MarkerSize', 2, Color='r');
% hold on
% plot(x,model.oef.var.ngs.Pin(num_start:num_end,14)/1e6, 'LineWidth', 1,  'LineStyle', '-', 'MarkerSize', 2, Color='b'); 
% hold on
% plot(x,data_plot(:,54)/1e6, 'LineWidth', 1,  'LineStyle', '--', 'MarkerSize', 2,Color='r');
% hold on
% plot(x,model.oef.var.ngs.Pout(num_start:num_end,14)/1e6, 'LineWidth', 1,  'LineStyle', '--', 'MarkerSize', 2,Color='b');
% grid
% set(gca,'FontName','Times New Roman','FontSize',12);
% xlabel('Time (hour).','fontname','Times New Roman','fontsize',13);
% ylabel('Pressure (Mpa)','fontname','Times New Roman','fontsize',13);
% xlim([1, 24]);
% xticks(0:6:24);
% % ylim([5.79, 7.1]);
% legend({['$p_{in}^{comp}$'], ['$p_{in}$'], ['$p_{out}^{comp}$'], ['$p_{out}$']}, ...
%         'NumColumns', 1,'FontName', 'Times New Roman', 'FontSize', 11, 'Interpreter', 'latex', ...
%        'Orientation', 'horizontal', 'Box', 'off');
% 
% subplot(1,2,2)
% plot(x,data_plot(:,55), 'LineWidth', 1, 'LineStyle', '-', 'MarkerSize', 2, Color='r');
% hold on
% plot(x,model.oef.var.ngs.Min(num_start:num_end,14), 'LineWidth', 1,  'LineStyle', '-', 'MarkerSize', 2, Color='b'); 
% hold on
% plot(x,data_plot(:,56), 'LineWidth', 1,  'LineStyle', '--', 'MarkerSize', 2,Color='r');
% hold on
% plot(x,model.oef.var.ngs.Mout(num_start:num_end,14), 'LineWidth', 0.5,  'LineStyle', '--', 'MarkerSize', 2,Color='b');
% grid
% set(gca,'FontName','Times New Roman','FontSize',12);
% xlabel('Time (hour).','fontname','Times New Roman','fontsize',13);
% ylabel('MFR (kg/s)','fontname','Times New Roman','fontsize',13);
% xlim([1, 24]);
% xticks(0:6:24);
% % ylim([9,28]);
% legend({['$M_{in}^{comp}$'], ['$M_{in}$'], ['$M_{out}^{comp}$'], ['$M_{out}$']}, ...
%         'NumColumns', 1,'FontName', 'Times New Roman', 'FontSize', 11, 'Interpreter', 'latex', ...
%        'Orientation', 'horizontal', 'Box', 'off');


%% 






















