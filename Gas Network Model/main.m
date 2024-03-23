clc; clear all; close all;
yalmip('clear');
warning off;

%%
global data model;

%% read data

filename = 'testdata_t60'; 
func_readdata(filename); % 1-updata, 0-remain

num_pipeline = size(data.var.Min,2);% 50个管道

num_trainingsample = 800;% delta_t = 30,换成1600；delta_t = 15,换成3200；

num_testsample = 800; % delta_t = 30,换成1600；delta_t = 15,换成3200；

nd_t15 = 4;nd_t30 = 3;nd_t60 = 2;

nd_u15 = 2;nd_u30 = 2;nd_u60 = 2;

nd = nd_t60; % 不同delta_t, 换
model_order_u = nd_u60;
model_order = nd + 1;

%%
data.settings.num_trainingsample = num_trainingsample;
data.settings.num_testsample = num_testsample;
data.settings.model_order = model_order;
data.settings.model_order_u = model_order_u;

%% data processing
for k_pipeline = 1 : num_pipeline
    model.data.pipeline(k_pipeline,1).Min = data.var.Min(:,k_pipeline);
    model.data.pipeline(k_pipeline,1).Mout = data.var.Mout(:,k_pipeline);
    model.data.pipeline(k_pipeline,1).Pin = data.var.Pin(:,k_pipeline);
    model.data.pipeline(k_pipeline,1).Pout = data.var.Pout(:,k_pipeline);

end

%% normalization
fprintf('%s\n', '------------------- Normalization ----------------------');
model.data.basevalue_M = 5;
model.data.basevalue_P = 5e6;

for k_pipeline = 1 : num_pipeline
    model.data.pipeline(k_pipeline,1).Min_normalized = ...
        model.data.pipeline(k_pipeline,1).Min/model.data.basevalue_M;
    model.data.pipeline(k_pipeline,1).Mout_normalized = ...
        model.data.pipeline(k_pipeline,1).Mout/model.data.basevalue_M;
    model.data.pipeline(k_pipeline,1).Pin_normalized = ...
        model.data.pipeline(k_pipeline,1).Pin/model.data.basevalue_P;
    model.data.pipeline(k_pipeline,1).Pout_normalized = ...
        model.data.pipeline(k_pipeline,1).Pout/model.data.basevalue_P;

    % model.data.pipeline(k_pipeline,1).Min_normalized = ...
    %     mapminmax(model.data.pipeline(k_pipeline,1).Min, 0, 1);
    % model.data.pipeline(k_pipeline,1).Mout_normalized = ...
    %     mapminmax(model.data.pipeline(k_pipeline,1).Mout, 0, 1);
    % model.data.pipeline(k_pipeline,1).Pin_normalized = ...
    %     mapminmax(model.data.pipeline(k_pipeline,1).Pin, 0, 1);
    % model.data.pipeline(k_pipeline,1).Pout_normalized = ...
    %     mapminmax(model.data.pipeline(k_pipeline,1).Pout, 0, 1);
end

%% --------------------------------------------
%% EDMD
func_model_based_on_EDMD();

%% ---------------- Save Matrix --------------------------
% save('Koopman_Matrix_t60.mat', 'model');
