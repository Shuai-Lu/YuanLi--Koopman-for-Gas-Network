% clc;clear
function interpolated( )

global data model

time_interval_ngs = data.settings.time_interval_ngs_second/3600;
num_initialtime = data.settings.num_initialtime_ngs/time_interval_ngs;
num_period_ngs = data.settings.num_period*1/time_interval_ngs;
num_start = num_initialtime + 1;
num_end = num_initialtime + num_period_ngs;

if time_interval_ngs == 1

    qout_data = model.oef.var.ngs.Mout(num_start-1:num_end,:)';
    pin_data = model.oef.var.ngs.Pin(num_start-1:num_end,:)';
    qin_data = model.oef.var.ngs.Min(num_start-1:num_end,:)';
    pout_data = model.oef.var.ngs.Pout(num_start-1:num_end,:)';
   
    for i = 1:19
        for t = 1:24
            model.oef.var.ngs.Mout_interpolated(4*t-2:4*t+1,i) = qout_data(i,t+1)*ones(4,1);
            model.oef.var.ngs.Pin_interpolated(4*t-2:4*t+1,i) = pin_data(i,t+1)*ones(4,1);
            model.oef.var.ngs.Min_interpolated(4*t-2:4*t+1,i) = qin_data(i,t+1)*ones(4,1);
            model.oef.var.ngs.Pout_interpolated(4*t-2:4*t+1,i) = pout_data(i,t+1)*ones(4,1);
        end
    end
    model.oef.var.ngs.Mout_interpolated(1,:) = qout_data(:,1)';
    model.oef.var.ngs.Pin_interpolated(1,:) = pin_data(:,1)';
    model.oef.var.ngs.Min_interpolated(1,:) = qin_data(:,1)';
    model.oef.var.ngs.Pout_interpolated(1,:) = pout_data(:,1)';

end

if time_interval_ngs == 0.5

    qout_data = model.oef.var.ngs.Mout(num_start-1:num_end,:)';
    pin_data = model.oef.var.ngs.Pin(num_start-1:num_end,:)';
    qin_data = model.oef.var.ngs.Min(num_start-1:num_end,:)';
    pout_data = model.oef.var.ngs.Pout(num_start-1:num_end,:)';
   
    for i = 1:19
        for t = 1:48
            model.oef.var.ngs.Mout_interpolated(2*t:2*t+1,i) = qout_data(i,t+1)*ones(2,1);
            model.oef.var.ngs.Pin_interpolated(2*t:2*t+1,i) = pin_data(i,t+1)*ones(2,1);
            model.oef.var.ngs.Min_interpolated(2*t:2*t+1,i) = qin_data(i,t+1)*ones(2,1);
            model.oef.var.ngs.Pout_interpolated(2*t:2*t+1,i) = pout_data(i,t+1)*ones(2,1);
        end
    end
    model.oef.var.ngs.Mout_interpolated(1,:) = qout_data(:,1)';
    model.oef.var.ngs.Pin_interpolated(1,:) = pin_data(:,1)';
    model.oef.var.ngs.Min_interpolated(1,:) = qin_data(:,1)';
    model.oef.var.ngs.Pout_interpolated(1,:) = pout_data(:,1)';

end

if time_interval_ngs == 0.25

    qout_data = model.oef.var.ngs.Mout(num_start-1:num_end,:)';
    pin_data = model.oef.var.ngs.Pin(num_start-1:num_end,:)';
    qin_data = model.oef.var.ngs.Min(num_start-1:num_end,:)';
    pout_data = model.oef.var.ngs.Pout(num_start-1:num_end,:)';
    hours = 0:0.25:24;
    new_time_points = 0 : 0.25 : 24;

    for i = 1:19
        model.oef.var.ngs.Mout_interpolated(:,i) = (interp1(hours, qout_data(i,:), new_time_points, 'linear'))';
        model.oef.var.ngs.Pin_interpolated(:,i) = (interp1(hours, pin_data(i,:), new_time_points, 'linear'))';
        model.oef.var.ngs.Min_interpolated(:,i) = (interp1(hours, qin_data(i,:), new_time_points, 'linear'))';
        model.oef.var.ngs.Pout_interpolated(:,i) = (interp1(hours, pout_data(i,:), new_time_points, 'linear'))';

    end
end

first_row_mout = model.oef.var.ngs.Mout_interpolated(1, :);
new_mout = [first_row_mout; model.oef.var.ngs.Mout_interpolated];
first_row_pin = model.oef.var.ngs.Pin_interpolated(1, :);
new_pin = [first_row_pin; model.oef.var.ngs.Pin_interpolated];

% filename = 'boundary_k_60.xlsx';
% writematrix(new_pin, filename, 'Sheet', 'Pin_interpolated');
% writematrix(new_mout, filename, 'Sheet', 'Mout_interpolated');


% % load
model.q3 = -(model.oef.var.ngs.Min_interpolated(2:end,3)-model.oef.var.ngs.Mout_interpolated(2:end,2))';
model.q5 = -(-model.oef.var.ngs.Mout_interpolated(2:end,4))';
model.q7 = (model.oef.var.ngs.Mout_interpolated(2:end,6) - model.oef.var.ngs.Min_interpolated(2:end,5))';
model.q10 = (model.oef.var.ngs.Mout_interpolated(2:end,9) - model.oef.var.ngs.Min_interpolated(2:end,10))';
model.q14 = (model.oef.var.ngs.Mout_interpolated(2:end,7) + model.oef.var.ngs.Mout_interpolated(2:end,13) ...
    - model.oef.var.ngs.Min_interpolated(2:end,14))';
model.q16 = (model.oef.var.ngs.Mout_interpolated(2:end,15))';
model.q17 = (model.oef.var.ngs.Mout_interpolated(2:end,16) - model.oef.var.ngs.Min_interpolated(2:end,17))';
model.p2g = -(model.oef.var.ngs.Min_interpolated(2:end,18) - model.oef.var.ngs.Mout_interpolated(2:end,17))';
model.q19 = (model.oef.var.ngs.Mout_interpolated(2:end,18) - model.oef.var.ngs.Min_interpolated(2:end,19))';
model.q20 = (model.oef.var.ngs.Mout_interpolated(2:end,19) - 0)';

model.NGS_load = [model.q3; model.q5; model.q7; model.q10; model.q14; model.q16; model.q17; model.p2g; model.q19; model.q20];

% % source
model.ps1 = (model.oef.var.ngs.Pin_interpolated(2:end,1)/1000)';
model.ps11 = (model.oef.var.ngs.Pin_interpolated(2:end,16)/1000)';
model.ps8 = (model.oef.var.ngs.Pin_interpolated(2:end,8)/1000)';

model.NGS_source = [model.ps1; model.ps8];

% % compressor
model.k7  = (model.oef.var.ngs.Pin_interpolated(2:end,5)./model.oef.var.ngs.Pout_interpolated(2:end,6))';
model.k12 = (model.oef.var.ngs.Pin_interpolated(2:end,12)./model.oef.var.ngs.Pout_interpolated(2:end,11))';
model.k15 = (model.oef.var.ngs.Pin_interpolated(2:end,15)./model.oef.var.ngs.Pout_interpolated(2:end,14))';
model.k18 = (model.oef.var.ngs.Pin_interpolated(2:end,18)./model.oef.var.ngs.Pout_interpolated(2:end,17))';

model.NGS_compressor = [model.k7; model.k12; model.k15; model.k18];