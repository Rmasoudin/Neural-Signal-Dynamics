all_psth = zeros(92, 500, 101);
all_psth(:, 1:200, :) = face_psth;
all_psth(:, 201:320, :) = body_psth;
all_psth(:, 321:390, :) = natural_psth;
all_psth(:, 391:500, :) = artificial_psth;

region = 'IT';       % example region name
dataType = 'all';    % example data type

rdm = RDM_maker(all_psth, region, dataType);


categoryLabels = zeros(1, 500);
categoryLabels(1:200) = 1;
categoryLabels(201:320) = 2;
categoryLabels(321:390) = 3;
categoryLabels(391:500) = 4;

gtRDM = groundTruthRDM(categoryLabels);
imagesc(gtRDM);
colorbar;
title('Ground Truth RDM');


nTimes = size(rdm, 3);
kendallTau = zeros(1, nTimes);

gtVec = squareform(gtRDM); % vectorize the upper triangle of ground truth RDM

for t = 1:nTimes
    currRDM = rdm(:,:,t);
    currRDM(1:size(currRDM,1)+1:end) = 0;
    neuralVec = squareform(currRDM); % vectorize upper triangle of neural RDM at time t
    tau = corr(neuralVec', gtVec', 'Type', 'Kendall');
    kendallTau(t) = tau;
end
timePoints = 0:5:500;

plot(timePoints, kendallTau)
xlabel('Time (ms)')
ylabel('Kendall''s tau correlation')
title('Neural RDM vs Ground Truth RDM over Time (Shifted -100ms)')
xline(100, '--r', 'Onset', 'LabelHorizontalAlignment', 'left');