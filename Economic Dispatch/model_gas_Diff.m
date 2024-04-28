%% model of natural gas network
function model_gas_Diff( )
global data model;
% %
loc = data.loc.ngs;

% % - Data
pi = 3.1416;
num_period = data.settings.num_period;
num_initialtime_ngs = data.settings.num_initialtime_ngs;
time_interval_elec = data.settings.time_interval;
time_interval_ngs = data.settings.time_interval_ngs_second/3600;
num_initialtime = data.settings.num_initialtime_ngs/time_interval_ngs;
num_period_ngs = data.settings.num_period*time_interval_elec/time_interval_ngs;
num_start = num_initialtime + 1;
num_end = num_initialtime + num_period_ngs;
mul = 1/time_interval_ngs;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 50 DHN with same structure
num_pipe = size(data.ngs.pipe,1); % 50
num_node = size(data.ngs.node,1); % 51
indexset_source = data.ngs.source(:, loc.source.nodeID); % 1
num_source = size(indexset_source,1); % 26
ID_source = data.ngs.node(indexset_source, loc.node.ID);
indexset_nonsource = setdiff(1:num_node, indexset_source); % 2:51
indexset_load = data.profile.bus_gasload; % 26*1 loads
ID_load = data.ngs.node(indexset_load, loc.node.ID);
indexset_nonload = setdiff(1:num_node, indexset_load); % 25
num_load = size(indexset_load,1); % 26

index_gt = find(data.eps.device(:,2) == 3);
index_p2g = find(data.eps.device(:,2) == 4);
num_gt = size(index_gt,1);
num_p2g = size(index_p2g,1);
nodeID_gt = data.eps.device(index_gt, 1);
nodeID_p2g = data.eps.device(index_p2g, 1);

%% Calculate basic parameters
D = data.ngs.pipe(:, loc.pipe.diameter);
A  = data.ngs.pipe(:, loc.pipe.diameter).^2*pi/4; % 5*1
Len = data.ngs.pipe(:, loc.pipe.length);
c = 340;
lamta = data.ngs.pipe(:, loc.pipe.lamta);
%% define vars
model.oef.var.ngs.Msource = sdpvar(num_period_ngs + num_initialtime, num_source, 'full'); % 34*50
model.oef.var.ngs.Mload = sdpvar(num_period_ngs , num_load, 'full'); % 34*50

model.oef.var.ngs.Pnode = sdpvar(num_period_ngs + num_initialtime, num_node, 'full'); % 34*50

model.oef.var.ngs.Min = sdpvar(num_period_ngs + num_initialtime, num_pipe, 'full'); % 34*50
model.oef.var.ngs.Mout = sdpvar(num_period_ngs + num_initialtime, num_pipe, 'full');
model.oef.var.ngs.Pin = sdpvar(num_period_ngs + num_initialtime, num_pipe, 'full');
model.oef.var.ngs.Pout = sdpvar(num_period_ngs + num_initialtime, num_pipe, 'full'); % loss
model.oef.var.ngs.Lp = sdpvar(num_period_ngs, num_pipe, 'full'); % loss

model.oef.var.ngs.cost_source = sdpvar(num_period_ngs,  1, 'full'); % 24*54

%% Initialize variable
filename = 'steady state'; 
Min = xlsread(filename,1,'A2:BB10000');data.his.Min = Min;
Pin = xlsread(filename,2,'A2:BB10000');data.his.Pin = Pin*1e6;
Mout = xlsread(filename,3,'A2:BB10000');data.his.Mout = Mout;
Pout = xlsread(filename,4,'A2:BB10000');data.his.Pout = Pout*1e6;

for i = 1:num_pipe
    for j = 1:num_initialtime_ngs

        model.oef.var.ngs.Min(mul*(j-1)+1 : mul*j , i) = ...
            data.his.Min(j,i);
        model.oef.var.ngs.Mout(mul*(j-1)+1 : mul*j , i) = ...
            data.his.Mout(j,i);
        model.oef.var.ngs.Pin(mul*(j-1)+1 : mul*j , i) = ...
            data.his.Pin(j,i);
        model.oef.var.ngs.Pout(mul*(j-1)+1 : mul*j , i) = ...
            data.his.Pout(j,i);

    end
end

model.oef.var.ngs.Msource(1:num_initialtime,:) = 0;
model.oef.var.ngs.Pnode(1:num_initialtime,:) = 0;
%% 
%% Temperature quasi-dynamic
% % --------------------------------------- Diff-Begin -----------------------------------------------------------
dx = 2000;
Nx = ceil(Len/dx);

% filename = 'testdata_t15'; 
% V_Min = xlsread(filename,3,'B12:T12');   V_Pin = xlsread(filename,1,'B12:T12');
% V_Mout = xlsread(filename,4,'B12:T12');  V_Pout = xlsread(filename,2,'B12:T12');
% average_v = 2*D.*A./lamta./(1/2*(V_Min+V_Mout)').*abs(V_Pout-V_Pin)'./Len;
average_v = 1*ones(19,1);

dt = time_interval_ngs * 3600;
for k = 1 : num_pipe
    model.temp_M{1,k} = sdpvar(num_period_ngs + 1 , Nx(k,1)+1, 'full');
    model.temp_P{1,k} = sdpvar(num_period_ngs + 1 ,  Nx(k,1)+1, 'full');
end

% Numerical Conditions
for k = 1:num_pipe
    model.oef.cons = model.oef.cons + (( ...
         model.temp_M{1,k}(:,1) == model.oef.var.ngs.Min(num_initialtime:num_end,k)));
    model.oef.cons = model.oef.cons + (( ...
        model.temp_M{1,k}(1, 2:end) == model.oef.var.ngs.Mout(num_initialtime,k)));
    model.oef.cons = model.oef.cons + (( ...
        model.temp_P{1,k}(:,1) == model.oef.var.ngs.Pin(num_initialtime:num_end,k)));
    model.oef.cons = model.oef.cons + (( ...
        model.temp_P{1,k}(1, 2:end) == model.oef.var.ngs.Pout(num_initialtime,k)));

end

% 差分
for k = 1 : num_pipe
    for i = 2 :  Nx(k,1) + 1
        for t = 2 : num_period_ngs + 1

            % % Wendroff
            % model.oef.cons = model.oef.cons + (( ...
            %     (model.temp_P{1,k}(t+1,i+1) + model.temp_P{1,k}(t+1,i) -  model.temp_P{1,k}(t,i+1) - model.temp_P{1,k}(t,i))/(c^2) + ...
            %     dt/Len(k,1)/A(k,1)*( model.temp_M{1,k}(t+1,i+1) - model.temp_M{1,k}(t+1,i) + model.temp_M{1,k}(t,i+1) - model.temp_M{1,k}(t,i)) ...
            %     == 0));
            % model.oef.cons = model.oef.cons + (( ...
            %     ( model.temp_M{1,k}(t+1,i+1) + model.temp_M{1,k}(t+1,i) - model.temp_M{1,k}(t,i+1) - model.temp_M{1,k}(t,i))/A(k,1) + ...
            %     dt/Len(k,1)*(model.temp_P{1,k}(t+1,i+1) - model.temp_P{1,k}(t+1,i) +  model.temp_P{1,k}(t,i+1) - model.temp_P{1,k}(t,i)) + ...
            %     (lamta(k,1)*average_v*dt) / (4*D(k,1)*A(k,1)) *(model.temp_M{1,k}(t+1,i+1) + model.temp_M{1,k}(t+1,i) + model.temp_M{1,k}(t,i+1) + model.temp_M{1,k}(t,i)) ...
            %     == 0));

%             % % Euler
%             % % Continuity equations
%             model.oef.cons = model.oef.cons + (( ...
%                 (model.temp_P{1,k}(t+1,i) - model.temp_P{1,k}(t,i))/dt + ...
%                 c^2/dx/A(k,1)*( model.temp_M{1,k}(t+1,i+1) - model.temp_M{1,k}(t+1,i)) == 0));
%             % % Momentum equations
%             model.oef.cons = model.oef.cons + (( ...
%                 1/A(k,1)*(model.temp_M{1,k}(t+1,i) - model.temp_M{1,k}(t,i))/dt + ...
%                 (model.temp_P{1,k}(t+1,i+1) - model.temp_P{1,k}(t+1,i))/dx + ...
%                 lamta(k,1)*average_v(k,1)/(2*D(k,1)*A(k,1))*(model.temp_M{1,k}(t+1,i+1) + model.temp_M{1,k}(t+1,i) + model.temp_M{1,k}(t,i+1) + model.temp_M{1,k}(t,i))/4 ...
%                 == 0));

            % % Backward Euler
            % % Continuity equations
            model.oef.cons = model.oef.cons + (( ...
                (model.temp_P{1,k}(t,i) - model.temp_P{1,k}(t-1,i))/dt + ...
                c^2/dx/A(k,1)*( model.temp_M{1,k}(t,i) - model.temp_M{1,k}(t,i-1)) == 0));

            % % Momentum equations
            model.oef.cons = model.oef.cons + (( ...
                1/A(k,1)*(model.temp_M{1,k}(t,i) - model.temp_M{1,k}(t-1,i))/dt + ...
                (model.temp_P{1,k}(t,i) - model.temp_P{1,k}(t,i-1))/dx + ...
                lamta(k,1)*average_v(k,1)/(2*D(k,1)*A(k,1))*(model.temp_M{1,k}(t,i))/1 ...
                == 0));
        end
    end
end

% % cons
 for k = 1:num_pipe
     model.oef.cons = model.oef.cons + ( ...
         (model.oef.var.ngs.Mout(num_start:num_end,k) == ...
         model.temp_M{1,k}(2:end,end)) : ...
         'T_pipe_s_out = test_temp_s ');
     model.oef.cons = model.oef.cons + ( ...
         (model.oef.var.ngs.Pout(num_start:num_end,k) == ...
         model.temp_P{1,k}(2:end,end)) : ...
         'T_pipe_r_out = test_temp_r ');
 end
%%----------------------------------------- End -----------------------------------------------


%% ========================================================================
% % power at each node
node_compressor = data.ngs.compressor(:,data.loc.ngs.compressor.nodeID);
t = num_start : num_end;
ratio = ones(num_node,1);
ratio(node_compressor,1) = data.ngs.compressor(:,loc.compressor.ratio);
% ratio = 1.2*ones(19,1);
for n = 1 : num_node
    n_source = find(ID_source == n);
    n_load = find(ID_load == n);
    up_pipe = find(data.ngs.pipe(:,loc.pipe.tnode) ==n);
    down_pipe = find(data.ngs.pipe(:,loc.pipe.fnode) ==n);
    id_gt = find(nodeID_gt == n);
    id_p2g = find(nodeID_p2g == n);
    
    if ~isempty(n_source)
        model.temp_Msour = model.oef.var.ngs.Msource(t,n_source);
    else
        model.temp_Msour = zeros(num_period_ngs,1);
    end
    if ~isempty(n_load)
        model.temp_Mload = model.oef.var.ngs.Mload(:,n_load);
    else
        model.temp_Mload = zeros(num_period_ngs,1);
    end
    if ~isempty(up_pipe)
        model.temp_Mup = sum(model.oef.var.ngs.Mout(t,up_pipe),2);
    else
        model.temp_Mup = zeros(num_period_ngs,1);
    end
    if ~isempty(down_pipe)
        model.temp_Mdown = sum(model.oef.var.ngs.Min(t,down_pipe),2);
    else
        model.temp_Mdown = zeros(num_period_ngs,1);
    end
    if ~isempty(id_p2g)
        model.temp_Mp2g = model.oef.var.eps.M_p2g(:,id_p2g);
    else
        model.temp_Mp2g = zeros(num_period_ngs,1);
    end
    if ~isempty(id_gt)
        model.temp_Mgt = model.oef.var.eps.M_gt(:,id_gt);
    else
        model.temp_Mgt = zeros(num_period_ngs,1);
    end
    % 注意这里数据的形式，
    model.oef.cons = model.oef.cons + ( ...
        (  model.temp_Msour + model.temp_Mup + model.temp_Mp2g == model.temp_Mload + model.temp_Mdown + model.temp_Mgt ) );

    num_down = size(down_pipe,1);
    num_up = size(up_pipe,1);
    for k = 1:num_up
        model.oef.cons = model.oef.cons + ( ...
            ( model.oef.var.ngs.Pnode(t,n) == model.oef.var.ngs.Pout(t,up_pipe(k,1)) ) : ...
            'Pn = Pout(:,up_pipe)');
    end
% 
    for k = 1:num_down
        model.oef.cons = model.oef.cons + ( ...
            ( model.oef.var.ngs.Pnode(t,n) <= model.oef.var.ngs.Pin(t,down_pipe(k,1))) : ...
            'Pn = Pin(:,down_pipe)');
        model.oef.cons = model.oef.cons + ( ...
            ( model.oef.var.ngs.Pin(t,down_pipe(k,1)) <= model.oef.var.ngs.Pnode(t,n) * ratio(n,1)) : ...
            'Pn = Pin(:,down_pipe)');
    end
end
%% linepack model.oef.var.ngs.Pnode
e = 0.05;
average_P0 = (2/3*(model.oef.var.ngs.Pin(num_initialtime,:) + ...
    model.oef.var.ngs.Pout(num_initialtime,:) - ...
    model.oef.var.ngs.Pin(num_initialtime,:).*model.oef.var.ngs.Pout(num_initialtime,:)./(model.oef.var.ngs.Pin(num_initialtime,:)+model.oef.var.ngs.Pout(num_initialtime,:))))';
E0 = (A.*Len/(c^2).*average_P0)';
for t = 1 : num_period_ngs
    if t == 1
        model.oef.cons = model.oef.cons + ( ...
            (model.oef.var.ngs.Lp(t,:) == ...
            E0 + ...
            (model.oef.var.ngs.Min(num_initialtime + t,:) - model.oef.var.ngs.Mout(num_initialtime + t,:))*data.settings.time_interval_ngs_second));
    else
        model.oef.cons = model.oef.cons + ( ...
            (model.oef.var.ngs.Lp(t,:) == ...
            model.oef.var.ngs.Lp(t-1,:) + ...
            (model.oef.var.ngs.Min(num_initialtime + t,:) - model.oef.var.ngs.Mout(num_initialtime + t,:))*data.settings.time_interval_ngs_second));
    end
end
model.oef.cons = model.oef.cons + ( ...
    (sum(E0,2)*(1-e) <=...
    sum(model.oef.var.ngs.Lp(end,:) ,2)) : 'T_node_s >= Tsmin');
model.oef.cons = model.oef.cons + ( ...
    (sum(model.oef.var.ngs.Lp(end,:) ,2) <= ...
    sum(E0,2)*(1+e)) : 'T_node_s >= Tsmin');

%% Pnode_source = Psource = Pin(pipe)
% 
t = num_start : num_end;
Psource = data.ngs.source(:,loc.source.Pressure);
P_p2g = data.eps.device(index_p2g,13);
P_gt = data.eps.device(index_gt,13);
model.oef.cons = model.oef.cons + ( ...
    ( 0.95*ones(num_period_ngs,1)*Psource' <= model.oef.var.ngs.Pnode(t, ID_source) <= ...
    1.05*ones(num_period_ngs,1)*Psource' ) : ...
    'Psource');
model.oef.cons = model.oef.cons + ( ...
    ( 0.95*ones(num_period_ngs,1)*P_p2g' <= model.oef.var.ngs.Pnode(t, nodeID_p2g) <= ...
    1.05*ones(num_period_ngs,1)*P_p2g' ) : ...
    'Psource');   
model.oef.cons = model.oef.cons + ( ...
    ( 0.95*ones(num_period_ngs,1)*P_gt' <= model.oef.var.ngs.Pnode(t, nodeID_gt) <= ...
    1.05*ones(num_period_ngs,1)*P_gt' ) : ...
    'Psource');  

% source and p2g, gt 处的输入Min,Pin在1h内是固定不变的
for t = 1 : num_period
    for k = 2 : mul
        model.oef.cons = model.oef.cons + ( ...
            ( model.oef.var.ngs.Msource(mul*(t + num_initialtime_ngs - 1)+1,:) == ...
            model.oef.var.ngs.Msource(mul*(t + num_initialtime_ngs - 1) + k ,:) ) : ...
            '4 Msource stay the same');
        % model.oef.cons = model.oef.cons + ( ...
        %     ( model.oef.var.ngs.Pnode(mul*(t + num_initialtime_ngs - 1)+1,ID_source) == ...
        %     model.oef.var.ngs.Pnode(mul*(t + num_initialtime_ngs - 1) + k ,ID_source) ) : ...
        %     '4 Psource stay the same');

        model.oef.cons = model.oef.cons + ( ...
            ( model.oef.var.eps.M_p2g(mul*(t - 1)+1,:) == ...
            model.oef.var.eps.M_p2g(mul*(t - 1) + k ,:) ) : ...
            '4 Mp2g stay the same');   
        model.oef.cons = model.oef.cons + ( ...
            ( model.oef.var.ngs.Pnode(mul*(t + num_initialtime_ngs - 1)+1,nodeID_p2g) == ...
            model.oef.var.ngs.Pnode(mul*(t + num_initialtime_ngs - 1) + k ,nodeID_p2g) ) : ...
            '4 P_p2g stay the same');

        model.oef.cons = model.oef.cons + ( ...
            ( model.oef.var.eps.M_gt(mul*(t - 1)+1,:) == ...
            model.oef.var.eps.M_gt(mul*(t - 1) + k ,:) ) : ...
            '4 Mp2g stay the same');
        model.oef.cons = model.oef.cons + ( ...
            ( model.oef.var.ngs.Pnode(mul*(t + num_initialtime_ngs - 1)+1,nodeID_gt) == ...
            model.oef.var.ngs.Pnode(mul*(t + num_initialtime_ngs - 1) + k ,nodeID_gt) ) : ...
            '4 P_p2g stay the same');
    end
end

% % model of the M_GT
% M0=0;
% for t = 1 : num_period
%     if t==1
%         model.oef.cons = model.oef.cons + ( ...
%             ( model.oef.var.eps.Mtemp_gt(t,:) == ...
%             1/2/mul*(M0 + sum(model.oef.var.eps.M_gt(mul*(t-1)+1 : mul*t,:),1) + ...
%             sum(model.oef.var.eps.M_gt(mul*(t-1)+1:mul*t-1,:) ,1))) : ...
%             '4 M_gt = 1Mtemp_gt, same area,t = 1');
%     else
%         model.oef.cons = model.oef.cons + ( ...
%             (model.oef.var.eps.Mtemp_gt(t,:) == ...
%             1/2/mul*(sum(model.oef.var.eps.M_gt(mul*(t-1):mul*t,:),1) + ...
%             sum(model.oef.var.eps.M_gt(mul*(t-1)+1:mul*t-1,:) ,1)) ) : ...
%             '4 M_gt = 1Mtemp_gt, same area, t>1');
%     end
% end


% Δt小于1h时，load处应该有一个等式约束
for j = 1 : num_period
    model.oef.cons = model.oef.cons + ( ...
        ( sum(model.oef.var.ngs.Mload(mul*(j-1)+1 : mul*j , :)*time_interval_ngs,1) == ...
        data.profile.M_load(j,:)*time_interval_elec) : ...
        'sum(M_load_96) = M_load_24');
end

model.oef.cons = model.oef.cons + ( ...
    (model.oef.var.ngs.Mload >= 0) : 'T_node_s >= Tsmin');

%% Node temperature limit
for t = 1 : num_period
    model.oef.cons = model.oef.cons + ( ...
        sum(model.oef.var.ngs.Min(mul*(t + num_initialtime_ngs -1)+1 : mul*(t+num_initialtime_ngs) , :), 1) <= ...
        data.ngs.pipe(1,loc.pipe.Fmax)/time_interval_ngs);
    model.oef.cons = model.oef.cons + ( ...
        sum(model.oef.var.ngs.Mout(mul*(t + num_initialtime_ngs -1)+1 : mul*(t+num_initialtime_ngs) , :), 1) <= ...
        data.ngs.pipe(1,loc.pipe.Fmax)/time_interval_ngs);
end
t = num_start : num_end;
model.oef.cons = model.oef.cons + ( ...
    (model.oef.var.ngs.Min(t,:) <= ...
    data.ngs.pipe(1,loc.pipe.Fmax)) : 'T_node_s >= Tsmin');
model.oef.cons = model.oef.cons + ( ...
    (model.oef.var.ngs.Mout(t,:) <= ...
    data.ngs.pipe(1,loc.pipe.Fmax)) : 'T_node_s >= Tsmin');
model.oef.cons = model.oef.cons + ( ...
    (model.oef.var.ngs.Min(t,:) >= ...
    1) : 'T_node_s >= Tsmin');
model.oef.cons = model.oef.cons + ( ...
    (model.oef.var.ngs.Mout(t,:) >= ...
    1) : 'T_node_s >= Tsmin');

model.oef.cons = model.oef.cons + ( ...
    (model.oef.var.ngs.Pnode(t,:) <= ...
    data.ngs.node(1,loc.node.Pmax)) : 'T_node_s >= Tsmin');
model.oef.cons = model.oef.cons + ( ...
    (model.oef.var.ngs.Pnode(t,:) >= ...
    data.ngs.node(1,loc.node.Pmin)) : 'T_node_s >= Tsmin');

model.oef.cons = model.oef.cons + ( ...
    (model.oef.var.ngs.Pin(t,:) <= ...
    data.ngs.node(1,loc.node.Pmax)) : 'T_node_s >= Tsmin');
model.oef.cons = model.oef.cons + ( ...
    (model.oef.var.ngs.Pin(t,:) >= ...
    data.ngs.node(1,loc.node.Pmin)) : 'T_node_s >= Tsmin');

nn = 1:19;
model.oef.cons = model.oef.cons + ( ...
    (model.oef.var.ngs.Pin(t,nn) >= ...
    model.oef.var.ngs.Pout(t,nn)) : 'T_node_s >= Tsmin');

for t = 1 : num_period
    model.oef.cons = model.oef.cons + ( ...
        sum(model.oef.var.ngs.Msource(mul*(t + num_initialtime_ngs -1)+1 : mul*(t+num_initialtime_ngs) , :), 1) <= ...
        data.ngs.source(1,loc.source.Fmax)/time_interval_ngs);
    model.oef.cons = model.oef.cons + ( ...
        sum(model.oef.var.ngs.Msource(mul*(t + num_initialtime_ngs -1)+1 : mul*(t+num_initialtime_ngs) , :), 1) >= ...
        data.ngs.source(1,loc.source.Fmin)/time_interval_ngs);
end



%% Obj_ngs
c_gas = 2.5;

model.oef.var.ngs.cost_source = ...
    c_gas*(sum(model.oef.var.ngs.Mload,2) + model.oef.var.eps.M_gt - model.oef.var.eps.M_p2g)*dt/0.7174;

end
