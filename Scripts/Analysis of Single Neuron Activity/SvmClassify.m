face_idx = 1:200;
body_idx = 201:320;
natural_idx = 321:390;
artificial_idx = 391:500;

num_neurons = numel(neurons);

bin_width = 50;
bin_starts = 0:5:(550 - bin_width);
num_bins = length(bin_starts);

face_psth = zeros(num_neurons, numel(face_idx), num_bins);
body_psth = zeros(num_neurons, numel(body_idx), num_bins);
natural_psth = zeros(num_neurons, numel(natural_idx), num_bins);
artificial_psth = zeros(num_neurons, numel(artificial_idx), num_bins);

for n = 1:num_neurons
    data = neurons(n).data;  % 5000 x 550
    cm = neurons(n).cm; 
    stim_indices = [cm.index];  % 5000 x 1

    for stim = 1:500
        trial_ids = find(stim_indices == stim);  % should be 10 trials
        stim_data = data(trial_ids, :);  % 10 x 550

        psth = zeros(1, num_bins);
        for b = 1:num_bins
            window = bin_starts(b)+1 : bin_starts(b)+bin_width;
            psth(b) = 1000 * mean(stim_data(:, window), 'all');  % mean firing rate over time and trials
        end

        if ismember(stim, face_idx)
            face_psth(n, find(face_idx == stim), :) = psth;
        elseif ismember(stim, body_idx)
            body_psth(n, find(body_idx == stim), :) = psth;
        elseif ismember(stim, natural_idx)
            natural_psth(n, find(natural_idx == stim), :) = psth;
        elseif ismember(stim, artificial_idx)
            artificial_psth(n, find(artificial_idx == stim), :) = psth;
        end
    end
end


region = 'all_neurons';
selected_neurons = 1:92;


common_n = 70;
artificial_data = artificial_psth(:, 1:common_n, :);
body_data       = body_psth(:, 1:common_n, :);
natural_data    = natural_psth(:, 1:common_n, :);
face_data       = face_psth(:, 1:common_n, :);

[accuracy_w, recall_manmade, recall_body, featuresMat, labels, models] = ...
    svm_classifier_psth(artificial_data, body_data, natural_data, face_data, num_bins, region);