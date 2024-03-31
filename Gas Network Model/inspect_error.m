%% plot error
close all;
for idx_pipeline = 1 : size(model.verify,1)
        fprintf('%s%f\n', ['rho ' num2str(idx_pipeline) ' = '], ...
            max(abs(eig(model.EDMD(idx).var.sys_matrix))));
end

for num_observable = 1 : size(model.verify(1).error_x, 2)
    figure(num_observable);
    for num_pipeline = 1 : size(model.verify,1)
        subplot(3,1,1);
        plot(model.verify(num_pipeline).x(:,num_observable));
        hold on;

        subplot(3,1,2);
        plot(model.verify(num_pipeline).error_x(:,num_observable));
        hold on;

        subplot(3,1,3);
        plot(model.verify(num_pipeline).error_x_relative(:,num_observable));
        hold on;
    end
    pause(1);
end

%%
for idx_pipeline = 1 : size(model.verify,1)

    z(idx_pipeline, :) = model.EDMD(idx_pipeline).var.z';

end
figure();
z_sum = sum(z, 1);
bar(z_sum);