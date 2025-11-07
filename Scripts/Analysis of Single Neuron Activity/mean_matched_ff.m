number_of_neurons = length(data);
window_length = 50;
sliding_step = 10;
total_time = size(data(1).data, 2);
number_of_time_slices = floor((total_time - window_length) / sliding_step) + 1;


categories = struct('face', 1:200, ...
                    'body', 201:320, ...
                    'natural', 321:390, ...
                    'artificial', 391:500);

SpikeTrain_it_all = struct([]);
for i = 1:number_of_neurons
    SpikeTrain_it_all(i).data = data(i).data;

    cm_array = zeros(1, length(data(i).cm));
    for k = 1:length(data(i).cm)
        cm_array(k) = data(i).cm(k).index;
    end

    SpikeTrain_it_all(i).cm = cm_array;
end


time_points = zeros(1, number_of_time_slices);
for u = 1:number_of_time_slices
    time_points(u) = (sliding_step * (u - 1)) + window_length / 2;
end


category_names = fieldnames(categories);
colors = lines(length(category_names));

figure;
hold on;

for c = 1:length(category_names)
    cat_name = category_names{c};
    cat_range = categories.(cat_name);

    catagoryLabel = [];
    for i = 1:number_of_neurons
        cm_struct = data(i).cm;
        temp_indices = [cm_struct.index];
        cat_trials = temp_indices(temp_indices >= min(cat_range) & temp_indices <= max(cat_range));
        catagoryLabel = unique([catagoryLabel, cat_trials]);
    end

    mean_vec_cat = zeros(number_of_neurons, number_of_time_slices);
    var_vec_cat  = zeros(number_of_neurons, number_of_time_slices);

    [mean_vec_cat, var_vec_cat, ~] = ...
        catagoryBasedFano(SpikeTrain_it_all, cat_name, catagoryLabel, ...
                          mean_vec_cat, var_vec_cat, ...
                          number_of_neurons, sliding_step, ...
                          window_length, number_of_time_slices);
    fano_slopes = zeros(1, number_of_time_slices);
    for u = 1:number_of_time_slices
        mean_u = mean_vec_cat(:, u);
        var_u  = var_vec_cat(:, u);
        p = polyfit(mean_u, var_u, 1);
        fano_slopes(u) = p(1);
    end

    fano_smoothed = smooth(fano_slopes, 16);
    plot(time_points, fano_smoothed, 'LineWidth', 2, 'Color', colors(c, :));
end

xlabel('Time (ms)');
ylabel('Mean-Matched Fano Factor');
title('Fano Factor Time Window by Category');
xline(100, '--r', 'Onset', 'LabelHorizontalAlignment', 'left');
legend(category_names, 'Location', 'Best');
grid on;
hold off;