% 
% plot(aaa(:,3));hold on
% plot(aaa(:,4));
%% ------------------------------------------------------------------------
fprintf('%s\n', '------------------- Generate data ----------------------');

%% ------------------------------------------------------------------------
T_start = 1;
T_end = 50000;
%
magnitude_p = 1e6;
offset_p = 5.85e6;
y0_p = offset_p + 0.5*magnitude_p;

%
magnitude_M = 13;
offset_M = 2;
y0_M = offset_M + 0.5*magnitude_M;

n = 2000;



% 生成随机y坐标，范围在 offset 到 offset + magnitude
yr_p = magnitude_p * rand(1, n) + offset_p;
yr_p(1) = y0_p; % 设置第一个y值为 y0
%
yr_M = magnitude_M * rand(1, n) + offset_M;
yr_M(1) = y0_M; % 设置第一个y值为 y0


% 生成等间距的x坐标
x_ = linspace(T_start, T_end, n);

% 生成平滑曲线的x坐标
xs = linspace(min(x_), max(x_), 50000);

% 使用三次样条插值
pp_p = spline(x_, yr_p); % 使用三次样条插值，得到样条插值的分段多项式形式
ys_p = ppval(pp_p, xs);  % 计算样条曲线在平滑x坐标处的值
pp_M = spline(x_, yr_M); % 使用三次样条插值，得到样条插值的分段多项式形式
ys_M = ppval(pp_M, xs);  % 计算样条曲线在平滑x坐标处的值

% 将ys的值限制在 offset 到 offset + magnitude 之间
ys_p = max(min(ys_p, offset_p + magnitude_p), offset_p);
ys_M = max(min(ys_M, offset_M + magnitude_M), offset_M);

% 绘制生成的曲线
figure
plot(xs, ys_p);
xlabel('X');
ylabel('Y');
title('Generated Random Curve');
grid on;

figure
plot(xs, ys_M);
xlabel('X');
ylabel('Y');
title('Generated Random Curve');
grid on;

train_data = [ys_p/1000;ys_M]';
