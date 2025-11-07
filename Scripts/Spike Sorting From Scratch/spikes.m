data = load('Sorting_data/singleIT.mat');
data = data.data_IT;

sample_rate = 30000;
time_axis = (0 : length(data) - 1) / sample_rate;

% figure;
% plot(time_axis, data)
% xlabel("Time")
% ylabel("Voltage Amplitude")
% title("Voltage Amplitude against Time")
% grid on;

% iqr_data = iqr(data
% len = length(data);

% bin_width = 2 * iqr_data / (len^(1/3));
% edges = min(data):bin_width:max(data);
% figure;
% histogram(data, edges);
% xlabel('Voltage Amplitude');
% ylabel('Frequency');
% title('Histogram of Voltage Amplitude');


order = 7;
limit = 300;

normalized_limit = limit / (sample_rate / 2);
[b, a] = butter(order, normalized_limit, 'high');

data_filtered = filtfilt(b, a, data);


% plot(time_axis, data_filtered, 'r');
% title('Filtered Data');
% xlabel('Time');
% ylabel('Voltage Amplitude');
% grid on;

sigma = median(abs(data_filtered)) / 0.6745;
threshold = 5 * sigma;
% threshold = 0.9 * max(abs(data_filtered));
der = diff(data_filtered);
signs = diff(sign(der));

min_indices = find(signs == -2) + 1;
max_indices = find(signs == 2) + 1;


peaks_down = min_indices(data_filtered(min_indices) <= -threshold);
peaks_up = max_indices(data_filtered(max_indices) >= +threshold);

% window = round(0.002 * sample_rate);
% series = -window : window;
% % 
% all_spikes = sort([peaks_down(:); peaks_up(:)]);
% 
% valid_spikes = all_spikes(all_spikes - window >= 1 & all_spikes + window <= length(data_filtered));

waveforms = zeros(length(valid_spikes), length(series));

for i = 1:length(valid_spikes)
    waveforms(i, :) = data_filtered(valid_spikes(i) + series);
end


samples_per_ms = sample_rate / 1000;
time_axis_ms = series / samples_per_ms;

figure;
plot(time_axis_ms, waveforms', 'Color', [0.7 0.7 0.7]); 
hold on;

mean_waveform = mean(waveforms, 1);
plot(time_axis_ms, mean_waveform, 'r-', 'LineWidth', 2);

xlabel('Time (ms)');
ylabel('Voltage Amplitude');
title('All Detected Spike Waveforms');
grid on;
hold off;

% 
% 
% % 
% waveforms_norm = waveforms - mean(waveforms, 2);
% [coeff, score, latent] = pca(waveforms_norm);
% variance = latent / sum(latent);
% disp(sum(variance(1:3)));
pc_s = score(:, 1:3);% waveforms_norm = waveforms - mean(waveforms, 2);
% tsne_features = tsne(waveforms_norm, 'NumDimensions', 3, 'Perplexity', 30);
% 
% k = 6;
% [idx, centroids] = kmeans(pc_s, k);
% figure;
% % 
% subplot(1,3,1);
% scatter(pc_s(:,1), pc_s(:,2), 10, idx, 'filled');
% xlabel('PC1'); ylabel('PC2');
% title('PC1 vs PC2');
% grid on;
% subplot(1,3,2);
% scatter(pc_s(:,1), pc_s(:,3), 10, idx, 'filled');
% xlabel('PC1'); ylabel('PC3');
% title('PC1 vs PC3');
% grid on;
% subplot(1,3,3);
% scatter(pc_s(:,2), pc_s(:,3), 10, idx, 'filled');
% xlabel('PC2'); ylabel('PC3');
% title('PC2 vs PC3');
% grid on;

sgtitle('Spike Clustering using PCA Features');

max_k = 6;
silhouette_avgs = zeros(max_k-1, 1);

for k = 2:max_k
    idx = kmeans(pc_s, k); 
    % idx = kmeans(tsne_features, k); 
    % s = silhouette(tsne_features, idx);
    s = silhouette(pc_s, idx);
    silhouette_avgs(k-1) = mean(s);

    fprintf('K = %d, Avg. Silhouette = %.4f\n', k, silhouette_avgs(k-1));
end
figure;
plot(2:max_k, silhouette_avgs, '-o');
xlabel('Number of Clusters (K)');
ylabel('Average Silhouette Score');
title('Silhouette Analysis for Optimal K');
% grid on;

% real_spikes = load('Spikes.mat').ind_spikes_it;

% real_spikes = downsample(real_spikes, 30);

% tolerance = 3;  % in samples
% 
% TP = 0;
% matched_truth = false(size(real_spikes));  % flag to avoid double matching
% 
% for i = 1:length(valid_spikes)
%     diffs = abs(real_spikes - valid_spikes(i));
%     [min_diff, idx] = min(diffs);
%     if min_diff <= tolerance && ~matched_truth(idx)
%         TP = TP + 1;
%         matched_truth(idx) = true;
%     end
% end
% 
% FP = length(valid_spikes) - TP;
% FN = length(real_spikes) - TP;
% 
% precision = TP / (TP + FP);
% recall = TP / (TP + FN);
% f1_score = 2 * (precision * recall) / (precision + recall);
% 
% fprintf('TP: %d, FP: %d, FN: %d\n', TP, FP, FN);
% fprintf('Precision: %.4f\n', precision);
% fprintf('Recall: %.4f\n', recall);
% fprintf('F1 Score: %.4f\n', f1_score);