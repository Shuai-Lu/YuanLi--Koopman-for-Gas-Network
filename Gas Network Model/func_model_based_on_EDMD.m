function func_model_based_on_EDMD()
% train and test the model
% by Shuai Lu
% Southeast University
% shuai.lu.seu@outlook.com
% 2023-02-03

%%
fprintf('%-40s\t\t\n', '- Train and test the model ...');
t0 = clock;

%%
global data model;
num_trainingsample = data.settings.num_trainingsample;% 300
num_testsample = data.settings.num_testsample;%200
model_order = data.settings.model_order;%2，
model_order_u = data.settings.model_order_u;%2，
num_pipeline = size(data.var.Min,2);

%% 
%% select observables and reformulate
fprintf('%s\n', '------------------- Start ----------------------');
fprintf('%s\n', '----------------- Select observables -------------------');
for k_pipeline = 1 : num_pipeline
    model.data.pipeline(k_pipeline,1).x_P = [];
    model.data.pipeline(k_pipeline,1).x_M = [];

    %% select observables
    k_sample = 1 : num_trainingsample + num_testsample;
    % % x Choose one

    x_P = model.data.pipeline(k_pipeline,1).Pout_normalized(k_sample, 1);
    x_M = model.data.pipeline(k_pipeline,1).Mout_normalized(k_sample, 1);

    model.data.pipeline(k_pipeline,1).x_P(k_sample,1) = func_observable_generator(x_P, 'linear');
    model.data.pipeline(k_pipeline,1).x_M(k_sample,1) = func_observable_generator(x_M, 'linear');
    % model.data.pipeline(k_pipeline,1).x_P(k_sample,end+1) = func_observable_generator(x_P, 'quadratic');
    % model.data.pipeline(k_pipeline,1).x_M(k_sample,end+1) = func_observable_generator(x_M, 'quadratic');
        % model.data.pipeline(k_pipeline,1).x_P(k_sample,end+1) = func_observable_generator(x_P, 'cubic');
        % model.data.pipeline(k_pipeline,1).x_M(k_sample,end+1) = func_observable_generator(x_M, 'cubic');
    % model.data.pipeline(k_pipeline,1).x_P(k_sample,end+1) = func_observable_generator(x_P, 'inverse');
    % model.data.pipeline(k_pipeline,1).x_M(k_sample,end+1) = func_observable_generator(x_M, 'inverse');
        % model.data.pipeline(k_pipeline,1).x_P(k_sample,end+1) = func_observable_generator(x_P, 'exp');
    model.data.pipeline(k_pipeline,1).x_P(k_sample,end+1) = func_observable_generator(-x_P, 'exp');
    model.data.pipeline(k_pipeline,1).x_M(k_sample,end+1) = func_observable_generator(-x_M, 'exp');
        % model.data.pipeline(k_pipeline,1).x_M(k_sample,end+1) = func_observable_generator(x_M, 'xexp');
%     model.data.pipeline(k_pipeline,1).x_P(k_sample,end+1) = func_observable_generator(x_P, 'log');
%     model.data.pipeline(k_pipeline,1).x_M(k_sample,end+1) = func_observable_generator(x_M, 'log');
    %     model.data.pipeline(k_pipeline,1).x_P(k_sample,end+1) = func_observable_generator(x_P.^2, 'exp');
        % model.data.pipeline(k_pipeline,1).x_P(k_sample,end+1) = func_observable_generator(-x_P.^2, 'exp');
    %     model.data.pipeline(k_pipeline,1).x_P(k_sample,end+1) = func_observable_generator(2*x_P, 'exp');
%         model.data.pipeline(k_pipeline,1).x_P(k_sample,end+1) = func_observable_generator(-2*x_P, 'exp');
        model.data.pipeline(k_pipeline,1).x_P(k_sample,end+1) = func_observable_generator(x_P, 'sin');
        model.data.pipeline(k_pipeline,1).x_M(k_sample,end+1) = func_observable_generator(x_M, 'sin');
        model.data.pipeline(k_pipeline,1).x_P(k_sample,end+1) = func_observable_generator(x_P, 'xsin');
        model.data.pipeline(k_pipeline,1).x_M(k_sample,end+1) = func_observable_generator(x_M, 'xsin');
%         model.data.pipeline(k_pipeline,1).x_P(k_sample,end+1) = func_observable_generator(x_P, 'cos');
%         model.data.pipeline(k_pipeline,1).x_P(k_sample,end+1) = func_observable_generator(-x_P, 'expsin');
%         model.data.pipeline(k_pipeline,1).x_M(k_sample,end+1) = func_observable_generator(-x_M, 'expcos');
%         model.data.pipeline(k_pipeline,1).x_P(k_sample,end+1) = func_observable_generator(x_P, 'xsin');
        % model.data.pipeline(k_pipeline,1).x_P(k_sample,end+1) = func_observable_generator(x_P, 'xcos');
        % model.data.pipeline(k_pipeline,1).x_M(k_sample,end+1) = func_observable_generator(x_M, 'xcos');
%         model.data.pipeline(k_pipeline,1).x_M(k_sample,end+1) = func_observable_generator(x_M, 'inverse*e^x_P');
%         model.data.pipeline(k_pipeline,1).x_P(k_sample,end+1) = func_observable_generator(x_P, 'radialbasis1');
%         model.data.pipeline(k_pipeline,1).x_P(k_sample,end+1) = func_observable_generator(x_P, 'radialbasis2');

    model.data.pipeline(k_pipeline,1).x(k_sample,:) = ...
        [model.data.pipeline(k_pipeline,1).x_M(k_sample,:) ...
        model.data.pipeline(k_pipeline,1).x_P(k_sample,:)];
    %% u
    % 状态量为Min时，可不可以取输入model.data.pipeline(k_pipeline,1).Pout_normalized(k_sample, :)
    model.data.pipeline(k_pipeline,1).u(k_sample, :) = [ ...
        model.data.pipeline(k_pipeline,1).Min_normalized(k_sample, :) ...
        model.data.pipeline(k_pipeline,1).Pin_normalized(k_sample, :)...
        ];
end

%% EMDM
k_training = 1 : num_trainingsample;
k_sample = 1 : num_trainingsample + num_testsample;
for k_pipeline =  1 : num_pipeline
    fprintf('%s%d%s\n', '--------------------- Pipeline: ', k_pipeline, ' ----------------------');
    model.EDMD(k_pipeline,1) =...
        func_multi_order_EDMD_benchmark(...
        model.data.pipeline(k_pipeline,1).x(k_training,:), ...        
        model.data.pipeline(k_pipeline,1).u(k_training,:), ...
        [], ...
        model_order, model_order_u);

    % %
    model.verify(k_pipeline,1) = ...
        func_EDMD_verify_benchmark(...
        model.data.pipeline(k_pipeline,1).x(k_sample,:), ...
        model.data.pipeline(k_pipeline,1).u(k_sample,:), ...
        [], ...
        model_order, model_order_u, ...
        model.EDMD(k_pipeline,1), ...
        num_trainingsample);

    
    %% plot - error_y
%     
%     cmap = brewermap(size(model.verify(1,1).x_P,2), 'set1');
%     num_fig_row = size(model.verify(1,1).x_P,2);
%     num_fig_col = 1;
%     num_subfig = 0;
%     h_fig = figure(1);
%     h_axis = gca;
%     h_fig.Colormap = cmap;
%     h_axis.Colormap = cmap;
%     colororder(cmap);
% 
%     %         num_subfig = num_subfig+1;
%     %         subplot(num_fig_row,num_fig_col,num_subfig);
%     plot(model.verify(k_pipeline,1).error_x_relative(:, 1));
% %     plot(model.verify(k_pipeline,1).error_y_relative(:, 1));
%     hold on;
%     grid on;


end
%     set(gca,'FontName','Times New Roman','FontSize',12);
%     xlabel('NO.','fontname','Times New Roman','fontsize',13);
%     ylabel('Relative error (%)','fontname','Times New Roman','fontsize',13);
%     hold off;
%%
t1 = clock;
fprintf('%10.2f%s\n', etime(t1,t0), 's');
end
