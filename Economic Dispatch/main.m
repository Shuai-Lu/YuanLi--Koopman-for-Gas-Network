clc; clear all; close all;
yalmip('clear');
global data model;

%% read dat

read_data('testdata_30bus.xlsx','20nodes.xlsx', 1); % 1: filename; 2: flag_clear

%% opf
OEF();
fprintf('\n');
myFun_GetValue(model.oef.var);
