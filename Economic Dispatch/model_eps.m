function model_eps()

global data model;

num_period = data.settings.num_period; % 24
time_interval_elec = data.settings.time_interval; % 1
time_interval_ngs = data.settings.time_interval_ngs_second/3600;
num_period_ngs = num_period*time_interval_elec/time_interval_ngs;
num_bus = size(data.eps.bus, 1); % 30
num_branch = size(data.eps.branch, 1); % 41
num_gen = size(data.eps.gen, 1); % 6
indexset_load = data.profile.bus_elecload; % 21，负荷所在节点编号
indexset_gen = data.eps.gen(:,1) ; % 6，机组所在节点编号
indexset_res = find(data.eps.gen(:,24) == 2); % 3,4 ， 在6个机组中的位置
indexset_nonres = find(data.eps.gen(:,24) ~= 2); % 44，非风机节点，用于机组出力限值约束时的区分
[indexset_load_gen,IA,IB] = intersect(indexset_load, indexset_gen); % 37*1

indexset_only_gen = setdiff(indexset_gen, indexset_load_gen); % 17
loc_only_gen = zeros(size(indexset_only_gen,1),1);
for i = 1:size(indexset_only_gen)
    l = find(indexset_gen == indexset_only_gen(i,1));
    loc_only_gen(i,1) = l;
end

indexset_only_load = setdiff(indexset_load, indexset_load_gen); % 54
loc_only_load = zeros(size(indexset_only_load,1),1);
for i = 1:size(indexset_only_load)
    l = find(indexset_load == indexset_only_load(i,1));
    loc_only_load(i,1) = l;
end

loc_mixed_gen = reshape(setdiff(1:num_gen,loc_only_gen),[],1);
loc_mixed_load = reshape(setdiff(1:size(indexset_load),loc_only_load),[],1);
%%
model.oef.var.eps.P = sdpvar(num_period, num_bus, 'full'); % 24*118
model.oef.var.eps.theta = sdpvar(num_period, num_bus, 'full'); % 24*118
model.oef.var.eps.P_branch = sdpvar(num_period, num_branch, 'full');%支路潮流矩阵
model.oef.var.eps.P_gen = sdpvar(num_period, num_gen, 'full'); % 24*54model.oef.var.eps.P_device
model.oef.var.eps.cost_gen = sdpvar(num_period, num_gen, 'full'); % 24*54

% % coupled units
index_gt = find(data.eps.device(:,2) == 3);
index_p2g = find(data.eps.device(:,2) == 4);
num_gt = size(index_gt,1);
num_p2g = size(index_p2g,1);
bus_gt = data.eps.device(index_gt, 3);
bus_p2g = data.eps.device(index_p2g, 3);

model.oef.var.eps.Mtemp_gt = sdpvar(num_period, num_gt, 'full');
model.oef.var.eps.M_gt = sdpvar(num_period_ngs, num_gt, 'full');
model.oef.var.eps.P_gt = sdpvar(num_period , num_gt, 'full');
model.oef.var.eps.cost_gt = sdpvar(num_period , num_gt, 'full');

model.oef.var.eps.M_p2g = sdpvar(num_period_ngs , num_p2g, 'full');
model.oef.var.eps.P_p2g = sdpvar(num_period , num_p2g, 'full');
model.oef.var.eps.cost_p2g = sdpvar(num_period , num_p2g, 'full');

%%
A = zeros(num_bus);%节点导纳矩阵
for i = 1:num_branch
    p = data.eps.branch(i,1);
    q = data.eps.branch(i,2);
    A(p,q) = -1/data.eps.branch(i,4);
    A(q,p) = A(p,q);
end
for i = 1:num_bus
    A(i,i) = -sum(A(i,:));
end
snackbus = find(data.eps.bus(:,2)==1);
A(snackbus,:) = [];
A(:,snackbus) = [];

%% Network
% % power flow
index = (1:num_bus)';
index(snackbus) = [];

model.oef.cons = model.oef.cons + (( ...
    (model.oef.var.eps.theta(:,index))' == ...
    A\(model.oef.var.eps.P(:,index))') ...
    : 'model.oef.var.eps.theta = A\P;');

model.oef.var.eps.theta(:, snackbus) = 0;


for i = 1:num_branch
    p = data.eps.branch(i,1);
    q = data.eps.branch(i,2);

    model.oef.cons = model.oef.cons + (( ...
        model.oef.var.eps.P_branch(:,i) == ...
        (model.oef.var.eps.theta(:,p)-model.oef.var.eps.theta(:,q))/data.eps.branch(i,4)) ...
        : 'P_branch = delta_theta/x');

end

%% 
%% 54 only load bus
model.oef.cons = model.oef.cons + (( ...
    model.oef.var.eps.P(:, indexset_only_load) == ...
    - data.profile.P_load(1:num_period, loc_only_load)) ...
    : 'P at load bus');

% % 17 only gen bus
model.oef.cons = model.oef.cons + (( ...
    model.oef.var.eps.P(:, indexset_only_gen)  == ...
    model.oef.var.eps.P_gen(:, loc_only_gen)): 'P at gen bus');

% % 37 mixed gen load bus
model.oef.cons = model.oef.cons + (( ...
    model.oef.var.eps.P(:, indexset_load_gen)  == ...
    model.oef.var.eps.P_gen(:, loc_mixed_gen) - ...
    data.profile.P_load(1:num_period, loc_mixed_load)) ...
    : 'P at gen bus');

% GT as source, no load
model.oef.cons = model.oef.cons + (( ...
    model.oef.var.eps.P(:, bus_gt)  == ...
    model.oef.var.eps.P_gt) ...
    : 'P at gen bus');

% P2G as load, no source
model.oef.cons = model.oef.cons + (( ...
    model.oef.var.eps.P(:, bus_p2g)  == ...
    - model.oef.var.eps.P_p2g) ...
    : 'P at gen bus');
%%
% % P_branch limits
model.oef.cons = model.oef.cons + (( ...
    -400 <= model.oef.var.eps.P_branch <= 400) : 'min < P_branch < max');


%% Generator
model.oef.cons = model.oef.cons + (( ...
    ones(num_period, 1) * data.eps.gen(indexset_nonres,10)' <= ...
    model.oef.var.eps.P_gen(:,indexset_nonres) <= ...
    ones(num_period, 1) * data.eps.gen(indexset_nonres,9)') : 'P of gen');
model.oef.cons = model.oef.cons + (( ...
    0 <= ...
    model.oef.var.eps.P_gen(:,indexset_res) <= ...
    data.profile.Pwt(1:num_period,:)) : 'P of wt');

%% balance 
model.oef.cons = model.oef.cons + (( ...
    sum(model.oef.var.eps.P_gen,2) + sum(model.oef.var.eps.P_gt,2) ...
    == sum(data.profile.P_load(1:num_period, :),2) + sum(model.oef.var.eps.P_p2g,2)) : 'power balance');

%% Obj
model.oef.var.eps.cost_gen(:, :) = ...
    ones(num_period, 1) * data.eps.gencost(:, 5)' .* ...
    (model.oef.var.eps.P_gen(:, :) * time_interval_elec) .^2 + ...
    ones(num_period, 1) * data.eps.gencost(:, 6)' .* ...
    (model.oef.var.eps.P_gen(:, :) * time_interval_elec) + ...
    ones(num_period, 1) * data.eps.gencost(:, 7)';

end
