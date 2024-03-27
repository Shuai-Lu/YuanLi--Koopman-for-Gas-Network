%% plot error
close all;
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