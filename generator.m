t = linspace(0, 2, 101);
num_samples = 101;

% Ensemble Z(t)
ensemble_Z = zeros(num_samples, length(t));

for i = 1:num_samples
    theta = rand * pi;
    Z_t = cos(4 * pi * t + theta);
    ensemble_Z(i, :) = Z_t;
end

save('ensemble_Z.mat', 'ensemble_Z');

% Ensemble W(t)
ensemble_W = zeros(num_samples, length(t));

for i = 1:num_samples
    A = -5 + 5 * randn;  % Generating normally distributed random amplitude
    W_t = A * cos(4 * pi * t);
    ensemble_W(i, :) = W_t;
end

save('ensemble_W.mat', 'ensemble_W');
