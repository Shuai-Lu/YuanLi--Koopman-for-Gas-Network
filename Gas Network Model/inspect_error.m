%% plot error
for num_observable = 1 : size(model.verify(1).error_x, 2)
    figure(num_observable);
    for num_pipeline = 1 : size(model.verify,1)
        plot(model.verify(num_pipeline).error_x_relative(:,num_observable));
        hold on;
    end
    pause(1);
end