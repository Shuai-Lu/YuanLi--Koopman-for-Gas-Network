clc; clear all; close all;
yalmip('clear');
warning off;

%%
global data model;

%% read data
filename = 'testdata_t15'; 
func_readdata(filename); % 1-updata, 0-remain
num_pipeline = size(data.var.Min,2);% 50个管道

set_num_trainingsample = 8/10 * [49800/4 49800/2 49800];
set_num_testsample = 2/10 * [49800/4 49800/2 49800];
set_model_order_x = [3 3 3];
set_model_order_u = [2 2 2];
if strcmp(filename(end-1:end), '60')
    idx = 1;
elseif strcmp(filename(end-1:end), '30')
    idx = 2;
elseif strcmp(filename(end-1:end), '15')
    idx = 3;
end

num_trainingsample = set_num_trainingsample(idx);
num_testsample = set_num_testsample(idx);
model_order_x = set_model_order_x(idx);
model_order_u = set_model_order_u(idx);

%%
data.settings.num_trainingsample = num_trainingsample;
data.settings.num_testsample = num_testsample;
data.settings.model_order_x = model_order_x;
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
% 5e6 & 10 is Ok.
model.data.basevalue_P = 5e6;
model.data.basevalue_M = 10;


for k_pipeline = 1 : num_pipeline
    model.data.pipeline(k_pipeline,1).Min_normalized = ...
        model.data.pipeline(k_pipeline,1).Min/model.data.basevalue_M;
    model.data.pipeline(k_pipeline,1).Mout_normalized = ...
        model.data.pipeline(k_pipeline,1).Mout/model.data.basevalue_M;
    model.data.pipeline(k_pipeline,1).Pin_normalized = ...
        model.data.pipeline(k_pipeline,1).Pin/model.data.basevalue_P;
    model.data.pipeline(k_pipeline,1).Pout_normalized = ...
        model.data.pipeline(k_pipeline,1).Pout/model.data.basevalue_P;

end

%% --------------------------------------------
%% EDMD
func_model_based_on_EDMD();

%% ---------------- Save Matrix --------------------------
% 
% model1.data = [];
% model1.verify = [];
% for i = 1:19
%     model1.EDMD(i).cons = [];
%     model1.EDMD(i).var.A = model.EDMD(i).var.A;
%     model1.EDMD(i).var.B = model.EDMD(i).var.B;
% end
% save('Koopman_Matrix_t15_wrong.mat', 'model1');
