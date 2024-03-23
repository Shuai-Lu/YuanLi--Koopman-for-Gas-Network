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

% 
% plot(1:1600,model.verify(10).M1_v(:,1));
% hold on;
% plot(1:1600,model.verify(10).M2(:,1));


subplot(1,2,1)
x = 1:1600;
for k = 1:19
    plot(x,model.verify(k,1).error_x(:, 1));   
    hold on
end
grid
set(gca,'FontName','Times New Roman','FontSize',12);
xlabel('NO.','fontname','Times New Roman','fontsize',13);
ylabel('error Pout (%)','fontname','Times New Roman','fontsize',13);

subplot(1,2,2)
x = 1:1600;
for k = 1:19
    plot(x,model.verify(k,1).error_y(:, 1));
    hold on;
end
grid
set(gca,'FontName','Times New Roman','FontSize',12);
xlabel('NO.','fontname','Times New Roman','fontsize',13);
ylabel('error Mout (%)','fontname','Times New Roman','fontsize',13);

% hold off
% 
% %%
% 
% x = 1:1000;
% for k = 1:1    
%     plot(x,model.verify(k_pipeline,1).error_y_relative(:, 1));   
%     hold on
%     plot(x,model.verify(k_pipeline,1).error_x_relative(:, 1),'color', [1 0.63 0.54]);
% 
% 
% end
% grid
% set(gca,'FontName','Times New Roman','FontSize',12);
% xlabel('NO.','fontname','Times New Roman','fontsize',13);
% ylabel('Relative error (%)','fontname','Times New Roman','fontsize',13);
% 
% h=legend('Mout','Pout',...
%     'Location','NorthWest','fontname','Times New Roman','fontsize',12);
% h.NumColumns=2;
% set(h,'Orientation','horizon');
% set (h,'box','off');
% hold off

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
subplot(1,4,1);
for k = 13:13
    plot(data.var.Pin(:,k));
end
grid
subplot(1,4,2);
for k = 13:13
    plot(data.var.Pout(:,k));
end
grid
subplot(1,4,3);
for k =13:13
    plot(data.var.Min(:,k));
end
grid
subplot(1,4,4);
for k = 13:13
    plot(data.var.Mout(:,k));
end
grid