generateTimeVector = @(start, endValue, numPoints) linspace(start, endValue, numPoints);
t = generateTimeVector(0, 40, 101);
num_samples = 101;
ensemble_Z = zeros(num_samples, length(t));

for i = 1:num_samples
    theta = rand * pi;
    Z_t = cos(4 * pi * t + theta);
    ensemble_Z(i, :) = Z_t;
end

ensemble_W = zeros(num_samples, length(t));

for i = 1:num_samples
    A = -5 + 5 * randn;
    W_t = A * cos(4 * pi * t);
    ensemble_W(i, :) = W_t;
end


X = ensemble_Z;
save('ensemble_Z.mat', 'X', 't');
X = ensemble_W;
save('ensemble_W.mat', 'X', 't');

