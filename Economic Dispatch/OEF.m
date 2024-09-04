function OEF()

fprintf('%-40s\t\t', '- Optimal power flow');
t0 = clock;
global data model;


%%
data.settings.num_period = 24;
data.settings.time_interval = 1;
data.settings.time_interval_ngs = 1;
data.settings.time_interval_ngs_second = 900;
data.settings.num_initialtime_ngs = 10;
data.settings.big_M = 1e4;
data.settings.baseMVA = 100;
data.settings.T_source_set = 90;
num_period = data.settings.num_period;
num_bus = size(data.eps.bus, 1); % 118


%% 
% %
model.oef.obj = 0;
model.oef.obj_e = 0;
model.oef.obj_g = 0;
model.oef.var = [];
model.oef.cons = [];

%%
model_eps();

%% choose
% model_gas_Koopman_linear( ); %
% model_gas_Koopman( ); %
model_gas_Diff( ); %

model_couple( );

%% obj
model.oef.obj_e = ((sum(model.oef.var.eps.cost_gen(:))));

model.oef.obj_g = sum(model.oef.var.ngs.cost_source(:));

model.oef.obj = model.oef.obj_e + model.oef.obj_g;

%% solve
model.oef.ops = sdpsettings('solver', 'cplex', 'verbose', 2, 'usex0', 1);
model.oef.sol = optimize(model.oef.cons, model.oef.obj, model.oef.ops);


if ~ model.oef.sol.problem
    model.oef = myFun_GetValue(model.oef);

    fprintf('%s%.4f\n','Object: ', model.oef.obj);
    fprintf('%s%.4f%s\n','solvertime: ', model.oef.sol.solvertime,' s');


else
    fprintf('%s\n', model.oef.sol.info);
end



%%
t1 = clock;
fprintf('%10.2f%s\n', etime(t1,t0), 's');
end
