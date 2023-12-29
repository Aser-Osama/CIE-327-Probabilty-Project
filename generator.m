% Function to generate time vector
generateTimeVector = @(start, endValue, numPoints) linspace(start, endValue, numPoints);

% Generate time vector with more points and a larger time span
t = generateTimeVector(0, 40, 4001);  % 4000 points over 40 units of time

% Parameters
num_samples = 4001;  % 4000 samples

% Ensemble Z(t)
ensemble_Z = zeros(num_samples, length(t));

for i = 1:num_samples
    theta = rand * pi;
    Z_t = cos(4 * pi * t + theta);
    ensemble_Z(i, :) = Z_t;
end

% Save ensemble Z(t) to a MAT file
save('ensemble_Z.mat', 'ensemble_Z', 't');

% Ensemble W(t)
ensemble_W = zeros(num_samples, length(t));

for i = 1:num_samples
    A = -5 + 5 * randn;  % Generating normally distributed random amplitude
    W_t = A * cos(4 * pi * t);
    ensemble_W(i, :) = W_t;
end

% Save ensemble W(t) to a MAT file
save('ensemble_W.mat', 'ensemble_W', 't');

% Rename variables for X and t
X = ensemble_Z;
t = t;

% Save ensembles with X and t
save('ensemble_Z.mat', 'X', 't');
save('ensemble_W.mat', 'X', 't');
