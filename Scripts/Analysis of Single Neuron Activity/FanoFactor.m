time_window = 200:400;
window_size = 100;
step_size = 10;
num_timepoints = 550; 
num_neurons = length(data);
time_windows = 1:step_size:(num_timepoints - window_size + 1);
num_windows = length(time_windows);

FF_face = zeros(num_neurons, num_windows);
FF_body = zeros(num_neurons, num_windows);
FF_natural = zeros(num_neurons, num_windows);
FF_artifical = zeros(num_neurons, num_windows); 
ff_face_fix = [];
ff_body_fix = [];
ff_natural_fix = [];
ff_artifical_fix = [];

for n = 1:num_neurons
    
    
    
    raster = data(n).data;
    cm_n = data(n).cm;
    picNum = [cm_n.index];
    group_face = raster(picNum >= 1 & picNum <= 200, :);
    group_body = raster(picNum >= 201 & picNum <= 320, :);
    group_natural = raster(picNum >= 321 & picNum <= 390, :);
    group_artifical = raster(picNum >= 391 & picNum <= 500, :);
    counts_face = sum(group_face(:, time_window), 2);
    counts_body = sum(group_body(:, time_window), 2);
    counts_natural = sum(group_natural(:, time_window), 2);
    counts_artifical = sum(group_artifical(:, time_window), 2);
    
    ff_face = var(counts_face) / mean(counts_face);
    ff_face_fix = [ff_face_fix, ff_face];

    ff_body = var(counts_body) / mean(counts_body);
    ff_body_fix = [ff_body_fix, ff_body];

    ff_natural = var(counts_natural) / mean(counts_natural);
    ff_natural_fix = [ff_natural_fix, ff_natural];

    ff_artifical = var(counts_artifical) / mean(counts_artifical);
    ff_artifical_fix = [ff_artifical_fix, ff_artifical];

    for w = 1:num_windows
        idx = time_windows(w):(time_windows(w) + window_size - 1);


        counts = sum(group_face(:, idx), 2);
        FF_face(n, w) = var(counts) / mean(counts);

        counts = sum(group_body(:, idx), 2);
        FF_body(n, w) = var(counts) / mean(counts);

        counts = sum(group_natural(:, idx), 2);
        FF_natural(n, w) = var(counts) / mean(counts);

        counts = sum(group_artifical(:, idx), 2);
        FF_artifical(n, w) = var(counts) / mean(counts);
    end
end

mean_FF_face = mean(FF_face, 1);
mean_FF_body = mean(FF_body, 1);
mean_FF_natural = mean(FF_natural, 1);
mean_FF_artifical = mean(FF_artifical, 1);

fprintf('Fano Factor Average Accross All 92 Neurons for Fixed Window for Face: %.3f\n', mean(ff_face_fix));
fprintf('Fano Factor Average Accross All 92 Neurons for Fixed Window for Body: %.3f\n', mean(ff_body_fix));
fprintf('Fano Factor Average Accross All 92 Neurons for Fixed Window for Natural: %.3f\n', mean(ff_natural_fix));
fprintf('Fano Factor Average Accross All 92 Neurons for Fixed Window for Artificial: %.3f\n', mean(ff_artifical_fix));

time_axis = time_windows + window_size / 2;
figure;
plot(time_axis, mean_FF_face, 'r', 'LineWidth', 2); hold on;
plot(time_axis, mean_FF_body, 'g', 'LineWidth', 2);
plot(time_axis, mean_FF_artifical, 'b', 'LineWidth', 2);
plot(time_axis, mean_FF_natural, 'k', 'LineWidth', 2);
xlabel('Time (ms)');
ylabel('Fano Factor');
xline(100, '--r', 'Onset', 'LabelHorizontalAlignment', 'left');
title('Sliding Winow Fano Factor plot for All Categories');
legend('Face', 'Body', 'Artificial', 'Natural');
grid on;