% %
% mm = model.oef.var.ngs.Mout_interpolated(2:end,:)';
% pp = model.oef.var.ngs.Pin_interpolated(2:end,:)'/1000;
%%
sum_error_diff = sum(abs(aaa(:,1) - aaa(:,2))*60*60+abs(aaa(:,6) - aaa(:,7))*60*60)/1000;
sum_error_koopman = sum(abs(aaa(:,3) - aaa(:,4))*60*60+abs(aaa(:,8) - aaa(:,9))*60*60)/1000;

sum_extract_diff = sum( aaa(:,1)*60*60+ aaa(:,6)*60*60)/1000;
sum_extract_koopman = sum( aaa(:,3)*60*60+ aaa(:,8)*60*60)/1000;

percent_diff = sum_error_diff/sum_extract_diff*100;
percent_koopman = sum_error_koopman/sum_extract_koopman*100;

relative_error_Min1_diff = (aaa(:,1) - aaa(:,2))./10;
Min1_diff_max = max(abs(relative_error_Min1_diff));

relative_error_Min8_diff = (aaa(:,6) - aaa(:,7))./10;
Min8_diff_max = max(abs(relative_error_Min8_diff));

relative_error_Min1_koopman = (aaa(:,3) - aaa(:,4))./10;
Min1_koopman_max = max(abs(relative_error_Min1_koopman));

relative_error_Min8_koopman = (aaa(:,8) - aaa(:,9))./10;
Min8_koopman_max = max(abs(relative_error_Min8_koopman));

%% 图10，气源两种方法的对比
h_fig = figure(); % gcf: get current figure
h_axis = gca; % gca: get current axis
% % set position & color
% position, color,
left = 10; bottom = 10; width = 16; height = 4.5;
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
plot(aaa(:,4), 'LineWidth', 1.1, 'Color', 'red', 'Marker', '.', 'MarkerSize', 7.7, LineStyle='-');hold on;
plot(aaa(:,3), 'LineWidth', 1.1, 'Color', 'blue', 'Marker', '.', 'MarkerSize', 7.7,LineStyle='--');hold on;
grid
xlim([1, 24]);
ylim([30, 34]);
xticks(0:4:24);
set (gca,'XTickLabel', {'0','4','8','12'...
,'16','20','24'})
set(gca,'FontName','Times New Roman','FontSize',10);
xlabel('Time (hour)', 'fontname','Times New Roman','fontsize',10.5);
ylabel('MFR (kg/s)','fontname','Times New Roman','fontsize',10.5);

subplot(1,2,2)
plot(aaa(:,2), 'LineWidth', 1.1, 'Color', 'red', 'Marker', '.', 'MarkerSize', 7.7, LineStyle='-');hold on;
plot(aaa(:,1), 'LineWidth', 1.1, 'Color', 'blue', 'Marker', '.', 'MarkerSize', 7.7, LineStyle='--');hold on;
grid
xlim([1, 24]);
ylim([29.5, 34]);
xticks(0:4:24);
set (gca,'XTickLabel', {'0','4','8','12'...
,'16','20','24'})
set(gca,'FontName','Times New Roman','FontSize',10);
xlabel('Time (hour)', 'fontname','Times New Roman','fontsize',11);
ylabel('MFR (kg/s)','fontname','Times New Roman','fontsize',11);
% 添加图例
legend({['dispatch result'], ...
    ['simulation result']},...
'NumColumns', 2,'FontName', 'Times New Roman', 'FontSize', 11, 'Interpreter', 'latex', ...
'Orientation', 'horizontal', 'Box', 'off');


% source 2
h_fig = figure(); % gcf: get current figure
h_axis = gca; % gca: get current axis
% % set position & color
% position, color,
left = 10; bottom = 10; width = 16; height = 4.1;
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
plot(aaa(:,9), 'LineWidth', 1.1, 'Color', 'red', 'Marker', '.', 'MarkerSize', 7.7, LineStyle='-');hold on;
plot(aaa(:,8), 'LineWidth', 1.1, 'Color', 'blue', 'Marker', '.', 'MarkerSize', 7.7,LineStyle='--');hold on;
grid
xlim([1, 24]);
ylim([25, 35]);
xticks(0:4:24);
set (gca,'XTickLabel', {'0','4','8','12'...
,'16','20','24'})
set(gca,'FontName','Times New Roman','FontSize',10);
xlabel('Time (hour)', 'fontname','Times New Roman','fontsize',10.5);
ylabel('MFR (kg/s)','fontname','Times New Roman','fontsize',10.5);

subplot(1,2,2)
plot(aaa(:,7), 'LineWidth', 1.1, 'Color', 'red', 'Marker', '.', 'MarkerSize', 7.7, LineStyle='-');hold on;
plot(aaa(:,6), 'LineWidth', 1.1, 'Color', 'blue', 'Marker', '.', 'MarkerSize', 7.7, LineStyle='--');hold on;
grid
xlim([1, 24]);
ylim([25, 35]);
xticks(0:4:24);
set (gca,'XTickLabel', {'0','4','8','12'...
,'16','20','24'})
set(gca,'FontName','Times New Roman','FontSize',10);
xlabel('Time (hour)', 'fontname','Times New Roman','fontsize',11);
ylabel('MFR (kg/s)','fontname','Times New Roman','fontsize',11);


%% 附录图

h_fig = figure();          % gcf: get current figure
h_axis = gca;              % gca: get current axis

% % set position & color
% position, color,
left = 5; bottom = 0; width = 35.5; height = 15;
% units:inches|centimeters|normalized|points|{pixels}|characters
set(h_fig, 'Units','centimeters', 'position', [left, bottom, width, height], 'color', 'w');

% % Remove the blank edge
set(gca,'LooseInset',get(gca,'TightInset'));

% % Setting color
cmap = brewermap(10,'Set1');
h_fig.Colormap = cmap;
h_axis.Colormap = cmap;
colororder(cmap)
labels = 'abcdefghijklmnopqrstuvwxyz';
for k = 1:19
    
    subplot(4,5,k);
    plot(model.Pout_dis(:,k)/1e6, 'LineWidth', 0.5, 'Marker', '.', 'MarkerSize', 7, 'Color', [0, 0, 1]); hold on;
    plot(model.Pout_verify(:,k)/1e6,'LineWidth', 0.5, 'Marker', 'o', 'MarkerSize', 3.5, 'Color', [1, 0, 0],'LineStyle','-.'); 
    grid
    set(gca,'FontName','Times New Roman','FontSize',10);
    % xlabel('Time (hour)', 'fontname','Times New Roman','fontsize',10);
    ylabel('MPa','fontname','Times New Roman','fontsize',12);
    xlabel(sprintf('(%c) pipeline %d', labels(k), k),'FontWeight','bold');
    % 设置横坐标刻度位置
    xticks([0 8 16 24]);

    % 设置横坐标刻度标签
    xticklabels({'00:00', '08:00', '16:00', '24:00'});
    
end
% 添加总标题
sgtitle('Outlet Pressure of Pipelines: Globally Linearized Model', 'FontWeight', 'bold', 'FontSize', 12, 'FontName', 'Times New Roman');
% sgtitle('Outlet Pressure of Pipelines: Locally Linearized Model', 'FontWeight', 'bold', 'FontSize', 12, 'FontName', 'Times New Roman');
legend({['dispatch result'], ['simulation result']}, ...
        'NumColumns', 1,'FontName', 'Times New Roman', 'FontSize', 11, 'Interpreter', 'latex', ...
       'Orientation', 'horizontal', 'Box', 'off','NumColumns', 1,'Location','northeast');
%% Inlet MFR of Pipelines
h_fig = figure();          % gcf: get current figure
h_axis = gca;              % gca: get current axis

% % set position & color
% position, color,
left = 5; bottom = 0; width = 35.5; height = 15;
% units:inches|centimeters|normalized|points|{pixels}|characters
set(h_fig, 'Units','centimeters', 'position', [left, bottom, width, height], 'color', 'w');

% % Remove the blank edge
set(gca,'LooseInset',get(gca,'TightInset'));

% % Setting color
cmap = brewermap(10,'Set1');
h_fig.Colormap = cmap;
h_axis.Colormap = cmap;
colororder(cmap)
labels = 'abcdefghijklmnopqrstuvwxyz';
for k = 1:19
    
    subplot(4,5,k);
    plot(model.Min_dis(:,k), 'LineWidth', 0.5, 'Marker', '.', 'MarkerSize', 7, 'Color', [0, 0, 1]); hold on;
    plot(model.Min_verify(:,k),'LineWidth', 0.5, 'Marker', 'o', 'MarkerSize', 3.5, 'Color', [1, 0, 0],'LineStyle','-.'); 
    grid
    set(gca,'FontName','Times New Roman','FontSize',10);
    % xlabel('Time (hour)', 'fontname','Times New Roman','fontsize',10);
    ylabel('kg/s','fontname','Times New Roman','fontsize',12);
    xlabel(sprintf('(%c) pipeline %d', labels(k), k),'FontWeight','bold');
    % 设置横坐标刻度位置
    xticks([0 8 16 24]);

    % 设置横坐标刻度标签
    xticklabels({'00:00', '08:00', '16:00', '24:00'});

end
% 添加总标题
sgtitle('Inlet MFR of Pipelines: Globally Linearized Model', 'FontWeight', 'bold', 'FontSize', 12, 'FontName', 'Times New Roman');
% sgtitle('Inlet MFR of Pipelines: Locally Linearized Model', 'FontWeight', 'bold', 'FontSize', 12, 'FontName', 'Times New Roman');

legend({['dispatch result'], ['simulation result']}, ...
        'NumColumns', 1,'FontName', 'Times New Roman', 'FontSize', 11, 'Interpreter', 'latex', ...
       'Orientation', 'horizontal', 'Box', 'off','NumColumns', 1,'Location','northeast');
%% 

h_fig = figure();          % gcf: get current figure
h_axis = gca;              % gca: get current axis

% % set position & color
% position, color,
left = 10; bottom = 10; width = 25; height = 11;
% units:inches|centimeters|normalized|points|{pixels}|characters
set(h_fig, 'Units','centimeters', 'position', [left, bottom, width, height], 'color', 'w');

% % Remove the blank edge
set(gca,'LooseInset',get(gca,'TightInset'));

% % Setting color
cmap = brewermap(10,'Set1');
h_fig.Colormap = cmap;
h_axis.Colormap = cmap;
colororder(cmap)
for k = 1:19
    
    subplot(4,5,k);
    plot(model.Min_dis(:,k), 'LineWidth', 1, 'Marker', 'o', 'MarkerSize', 2, 'Color', [0, 0, 1]); hold on;
    plot(model.Min_verify(:,k), 'LineWidth', 1, 'Marker', '^', 'MarkerSize', 2, 'Color', [1, 0, 0]); 
    grid
    set(gca,'FontName','Times New Roman','FontSize',10);
    % xlabel('Time (hour)', 'fontname','Times New Roman','fontsize',11);
    ylabel('kg/s','fontname','Times New Roman','fontsize',11);
    title(sprintf('pipe %d',k));
end
legend({['Dispatch results'], ['Simulation results']}, ...
        'NumColumns', 1,'FontName', 'Times New Roman', 'FontSize', 12, 'Interpreter', 'latex', ...
       'Orientation', 'horizontal', 'Box', 'off','NumColumns', 2);

%%
vvp = model.oef.var.ngs.Pin_interpolated(2:end,:)'/1000;
vvm = model.oef.var.ngs.Mout_interpolated(2:end,:)';

a(:,1) = model.oef.var.ngs.Min(1,:)';
a(:,2) = model.oef.var.ngs.Mout(1,:)';
a(:,3) = model.oef.var.ngs.Pin(1,:)'/1000;
a(:,4) = model.oef.var.ngs.Pout(1,:)'/1000;

for k = 1:19
    plot(1:24,model.oef.var.ngs.Pin(11:end,k)); hold on;
    plot(1:24,model.oef.var.ngs.Pout(11:end,k));hold off;
end

for k =1:19
    plot(1:6501,aaa(:,k));
end

filename = 'd60_verify.xlsx';

time_interval_ngs = data.settings.time_interval_ngs_second/3600;
num_initialtime = data.settings.num_initialtime_ngs/time_interval_ngs;
num_period_ngs = data.settings.num_period*1/time_interval_ngs;
num_start = num_initialtime + 1;
num_end = num_initialtime + num_period_ngs;

for k = 1:19

    if time_interval_ngs == 1
        fz_k1 = xlsread(filename,k,'A6:D98');
        fz_k = fz_k1(1:4:size(fz_k1, 1) , :);
    end

    if time_interval_ngs == 0.25
        fz_k = xlsread(filename,k,'A3:D98');
    end

    A(:,1) = model.oef.var.ngs.Pin(num_start:num_end,k);
    A(:,2) = model.oef.var.ngs.Pout(num_start:num_end,k);
    A(:,3) = model.oef.var.ngs.Min(num_start:num_end,k);
    A(:,4) = model.oef.var.ngs.Mout(num_start:num_end,k);
    B = fz_k;
  
    sheetNameA = num2str(k);  % 直接使用数字作为工作表名
    sheetNameB = num2str(k);  % 直接使用数字作为工作表名

    % 写入文件
    writematrix(A, 'dispatch_d_60.xlsx', 'Sheet', sheetNameA);
    writematrix(B, 'fz_d_60.xlsx', 'Sheet', sheetNameB);
    %%

%     h_fig = figure();          % gcf: get current figure
%     h_axis = gca;              % gca: get current axis
% 
%     % % set position & color
%     % position, color,
%     left = 10; bottom = 10; width = 10; height = 6;
%     % units:inches|centimeters|normalized|points|{pixels}|characters
%     set(h_fig, 'Units','centimeters', 'position', [left, bottom, width, height], 'color', 'w');
% 
%     % % Remove the blank edge
%     set(gca,'LooseInset',get(gca,'TightInset'));
% 
%     % % Setting color
%     cmap = brewermap(6,'Set3');
%     h_fig.Colormap = cmap;
%     h_axis.Colormap = cmap;
%     colororder(cmap)
% 
%     x = 1:size(A,1);
%     subplot(1,2,1)
%     plot(x,A(:,2),Color='r');
%     hold on
%     plot(x,B(:,2),Color='b');
%     grid
%     set(gca,'FontName','Times New Roman','FontSize',12);
%     xlabel('NO.','fontname','Times New Roman','fontsize',13);
%     ylabel('pout','fontname','Times New Roman','fontsize',13);
%     % title('dispatch diff')
%     subplot(1,2,2)
%     plot(x,A(:, 3),Color='r');
%     hold on
%     plot(x,B(:,3),Color='b');
%     grid
%     set(gca,'FontName','Times New Roman','FontSize',12);
%     xlabel('NO.','fontname','Times New Roman','fontsize',13);
%     ylabel('qin','fontname','Times New Roman','fontsize',13);
% 
%     I=1;
% 
%     delta_p(:,k) = (A(:,2)-B(:,2))./A(:,2)*100;
%     delta_q(:,k) = (A(:,3)-B(:,3))./A(:,3)*100;

end

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

    plot(x,delta_p,Color='r');
    hold on
    plot(x,delta_q,Color='b');
    grid
    set(gca,'FontName','Times New Roman','FontSize',12);
    xlabel('NO.','fontname','Times New Roman','fontsize',13);
    ylabel('error (%)','fontname','Times New Roman','fontsize',13);
%% 
% a=a*1000000;
% 

% 
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
% x = 1:24;
% subplot(1,2,1)
% plot(x,A(:,2),Color='r');
% hold on
% plot(x,B(:,2),Color='b');
% grid
% set(gca,'FontName','Times New Roman','FontSize',12);
% xlabel('NO.','fontname','Times New Roman','fontsize',13);
% ylabel('pout','fontname','Times New Roman','fontsize',13);
% % title('dispatch diff')
% subplot(1,2,2)
% plot(x,A(:, 3),Color='r');
% hold on
% plot(x,B(:,3),Color='b');
% grid
% set(gca,'FontName','Times New Roman','FontSize',12);
% xlabel('NO.','fontname','Times New Roman','fontsize',13);
% ylabel('qin','fontname','Times New Roman','fontsize',13);
% 
% I=1;

