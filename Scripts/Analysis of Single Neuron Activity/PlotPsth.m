neuron = neurons(5);
raster = neuron.data;
cm = neuron.cm;

group_face = [];
group_body = [];
group_natural = [];
group_artifical = [];
for i = 1:length(cm)
    picNum = cm(i).index;

    if picNum >= 1 && picNum <= 200
        group_face(end+1, :) = raster(i, :);
    elseif picNum >= 201 && picNum <= 320
        group_body(end+1, :) = raster(i, :);
    elseif picNum >= 321 && picNum <= 390
        group_natural(end+1, :) = raster(i, :);
    elseif picNum >= 391 && picNum <= 500
        group_artifical(end+1, :) = raster(i, :);
    end
end

time = 0:1:549;
SmoothingWidth = 61;
% TrialSum_smooth_vect = smooth(TrialSum_vect,SmoothingWidth);
psth_face = smooth(sum(group_face(:,:)), SmoothingWidth);
psth_body = smooth(sum(group_body(:,:)), SmoothingWidth);
psth_natural = smooth(sum(group_natural(:,:)), SmoothingWidth);
psth_artifical = smooth(sum(group_artifical(:,:)), SmoothingWidth);
num_trials = 5000;
conv_to_hz = 1000;
%% all categories in one plot
figure(1);
plot(time, conv_to_hz * psth_face/ (num_trials), 'r', 'DisplayName', 'Face');
hold on;
plot(time, conv_to_hz * psth_body/ (num_trials), 'b', 'DisplayName', 'Body');
plot(time, conv_to_hz * psth_natural/ (num_trials), 'm', 'DisplayName', 'Natural');
plot(time, conv_to_hz * psth_artifical/ (num_trials), 'g', 'DisplayName', 'Artifical');
hold off
xlabel('Time (ms)');
ylabel('Average firing rate (Hz)');
title('PSTH for different categories')
xline(100, '--r', 'Onset', 'LabelHorizontalAlignment', 'left');
legend;
grid on;

%% Different Categories in different plots

figure(1);
plot(time, conv_to_hz * psth_face/ (num_trials), 'r', 'DisplayName', 'Face');
xlabel('Time (ms)');
ylabel('Firing rate (Hz or AU)');
title('PSTH for Face');

legend;
grid on;


figure(2);
plot(time, conv_to_hz * psth_body/ (num_trials), 'b', 'DisplayName', 'Body');
xlabel('Time (ms)');
ylabel('Average firing rate (Hz)');
title('PSTH for Body');
legend;
grid on;


figure(3);
plot(time, conv_to_hz * psth_natural/ (num_trials), 'm', 'DisplayName', 'Natural');
xlabel('Time (ms)');
ylabel('Average firing rate (Hz)');
title('PSTH for Natural');
legend;
grid on;


figure(4);
plot(time, conv_to_hz * psth_artifical/ (num_trials), 'g', 'DisplayName', 'Artifical');
xlabel('Time (ms)');
ylabel('Average firing rate (Hz)');
title('PSTH for Category Artifical');
legend;
grid on;