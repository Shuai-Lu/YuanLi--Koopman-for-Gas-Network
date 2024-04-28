%% model of coupling relationship
function model_couple( )
%% 
global data model;
% 
time_interval_elec = data.settings.time_interval;
time_interval_ngs = data.settings.time_interval_ngs_second/3600;
num_period = data.settings.num_period;
num_period_ngs = data.settings.num_period*time_interval_elec/time_interval_ngs;
mul = time_interval_elec/time_interval_ngs;
loc = data.loc;
num_initialtime = data.settings.num_initialtime_ngs/time_interval_ngs;
num_start = num_initialtime + 1;
num_end = num_initialtime + num_period_ngs;

index_gt = find(data.eps.device(:,2) == 3);
index_p2g = find(data.eps.device(:,2) == 4);
num_gt = size(index_gt,1);
num_p2g = size(index_p2g,1);
eta_gt = (data.eps.device(index_gt, 8))';
eta_p2g = data.eps.device(index_p2g, 8);

% gt

% model.oef.cons = model.oef.cons + ( ...
%     model.oef.var.eps.P_gt == ...
%     model.oef.var.eps.Mtemp_gt .* (ones(num_period,1)*eta_gt));

for n = 1:num_gt
    for t = 1 : num_period
        model.oef.cons = model.oef.cons + ( ...
            sum(model.oef.var.eps.M_gt(mul*(t-1)+1 : mul*t,n)*time_interval_ngs)/time_interval_elec* eta_gt(n,1) == ...
            model.oef.var.eps.P_gt(t,n)  );
    end
end

% p2g
for n = 1:num_p2g
    for t = 1 : num_period
        model.oef.cons = model.oef.cons + ( ...
            sum(model.oef.var.eps.M_p2g(mul*(t-1)+1 : mul*t,n)*time_interval_ngs)/time_interval_elec == ...
            model.oef.var.eps.P_p2g(t,n) * eta_p2g(n,1) );
    end
end
% device
model.oef.cons = model.oef.cons + (( ...
    (data.eps.device(index_gt , 4)*ones(1,num_period))' <= ...
    model.oef.var.eps.P_gt <= ...
    (data.eps.device(index_gt , 5)*ones(1,num_period))') : 'min < Pgt < max');

model.oef.cons = model.oef.cons + (( ...
    (data.eps.device(index_p2g , 4)*ones(1,num_period))' <= ...
    model.oef.var.eps.P_p2g <= ...
    (data.eps.device(index_p2g , 5)*ones(1,num_period))') : 'min < Pp2g < max');

end
