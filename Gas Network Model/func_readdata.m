function func_readdata(filename)
%%
fprintf('%-40s\n', '- Reading data ...');
t0 = clock;

%%
global data;

%% District heating network
% filename = 'testdata_DHS.xlsx';
[sheet_Pin, sheet_Pout, sheet_Min, sheet_Mout] = ...
    deal(1,2,3,4);

%%
Min = xlsread(filename,sheet_Min,'B10:BB50502');
Pin = xlsread(filename,sheet_Pin,'B10:BB50502');
Mout = xlsread(filename,sheet_Mout,'B10:BB50502');
Pout = xlsread(filename,sheet_Pout,'B10:BB50502');


%%
data.var.Min = Min;
data.var.Pin = Pin;
data.var.Mout = Mout;
data.var.Pout = Pout;

% x = 1:1000;
% plot(x,Min);
% hold on
% plot(x,Mout);
% 
% figure
% plot(x,Pin);
% figure
% plot(x,Pout);

%% draw
% % %
% global model data
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
% cmap = brewermap(8,'Set3');
% h_fig.Colormap = cmap;
% h_axis.Colormap = cmap;
% colororder(cmap)
% x = 1:size(data.var.Min,1);
% subplot(1,2,1);
% for i = 1:size(data.var.Min,2)
%     plot(Pin(x,i));
%     hold on;
% end
% grid
% set(gca,'FontName','Times New Roman','FontSize',12);
% xlabel('No.','fontname','Times New Roman','fontsize',13);
% ylabel('Pin (kPa)','fontname','Times New Roman','fontsize',13);
% hold off;
% subplot(1,2,2);
% for i = 1:size(data.var.Min,2)
%     plot(Mout(x,i));
%     hold on;
% end
% grid
% set(gca,'FontName','Times New Roman','FontSize',12);
% xlabel('Time (h)','fontname','Times New Roman','fontsize',13);
% ylabel('Mout (kg/s)','fontname','Times New Roman','fontsize',13);
% hold off;


%%
end