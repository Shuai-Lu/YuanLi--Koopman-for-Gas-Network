% clc;clear

% X = rand(10, 300);    % input
% Y = rand(1, 300);     % output
X(:,1) = X(:,1)/5e6;
X(:,2) = X(:,2)/30;
X=X';
Y = (Y/5e6)';

% initialize
inputSize = 2;      % input layer
hiddenSize = 7;      % hidden layer
outputSize = 1;      % output layer
learningRate = 0.01; % study rate

% random initialze w and b
W1 = rand(hiddenSize, inputSize) * 0.01;
b1 = zeros(hiddenSize, 1);
W2 = rand(outputSize, hiddenSize) * 0.01;
b2 = zeros(outputSize, 1);

% RMSprop para initial
epsilon = 1e-8;  % 
sW1 = zeros(size(W1));
sW2 = zeros(size(W2));
sb1 = zeros(size(b1));
sb2 = zeros(size(b2));
decay_rate = 0.9;  % RMSprop attenuation rate

% 
n_iter = 4000;
loss = zeros(n_iter,1);
for k = 1:n_iter
    % forward
    Z1 = W1 * X + b1;
    A1 = relu(Z1);
    Z2 = W2 * A1 + b2;
    A2 = Z2; % linear activation

    % loss function (均方误差)
    loss(k,1) = mean((A2 - Y)./Y*100);

    % backward propagation
    dZ2 = A2 - Y;
    dW2 = (dZ2 * A1') / size(X, 2);
    db2 = sum(dZ2, 2) / size(X, 2);
    dZ1 = (W2' * dZ2) .* reluDerivative(Z1);
    dW1 = (dZ1 * X') / size(X, 2);
    db1 = sum(dZ1, 2) / size(X, 2);

    % RMSprop update
    sW1 = decay_rate * sW1 + (1 - decay_rate) * dW1.^2;
    sW2 = decay_rate * sW2 + (1 - decay_rate) * dW2.^2;
    sb1 = decay_rate * sb1 + (1 - decay_rate) * db1.^2;
    sb2 = decay_rate * sb2 + (1 - decay_rate) * db2.^2;

    W1 = W1 - learningRate * dW1 ./ (sqrt(sW1) + epsilon);
    b1 = b1 - learningRate * db1 ./ (sqrt(sb1) + epsilon);
    W2 = W2 - learningRate * dW2 ./ (sqrt(sW2) + epsilon);
    b2 = b2 - learningRate * db2 ./ (sqrt(sb2) + epsilon);

    % 
    if mod(k, 100) == 0
        fprintf('Epoch %d, Loss: %.4f\n', k, loss(k,1));
    end
end

% ReLU
function output = relu(x)
    output = max(0, x);
end

% derivative of relu
function d = reluDerivative(x)
    d = x > 0;
end
