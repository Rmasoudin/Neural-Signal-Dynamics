face = squeeze(face_psth(5, :, :));
body = squeeze(body_psth(5, :, :)); 
natural = squeeze(natural_psth(5, :, :));
artificial = squeeze(artificial_psth(5, :, :));

X = [face; body; natural; artificial];
labels = [zeros(200,1); ones(120,1); 2*ones(70,1); 3*ones(110,1)];


mi = zeros(1, 101);

for t = 1:101
    spike_counts = X(:, t);
    mi(t) = compute_mutual_information(spike_counts, labels);
end


n_perm = 1000;
mi_null = zeros(n_perm, 101);
for i = 1:n_perm
    shuffled_labels = labels(randperm(length(labels)));
    for t = 1:101
        spike_counts = X(:, t);
        mi_null(i, t) = compute_mutual_information(spike_counts, shuffled_labels);
    end
end

p_values = mean(mi_null >= mi, 1);
significant = p_values < 0.05;


time = linspace(0, 550, 101);
figure;
plot(time, mi, 'LineWidth', 2); hold on;
ymax = max(mi);
area(time, significant * ymax, 'FaceAlpha', 0.3, 'FaceColor', 'red', 'EdgeColor', 'none');
xlabel('Time (ms)');
ylabel('Mutual Information (bits)');
title(['Mutual Information vs Time (Neuron ', num2str(5), ')']);
legend('MI', 'Significant', 'Location', 'NorthWest');
xline(100, '--r', 'Onset', 'LabelHorizontalAlignment', 'left');
grid on;