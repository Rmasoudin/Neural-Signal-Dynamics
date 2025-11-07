accuracy_matrix = zeros(101, 101);
for i = 1:101
    model = models{i};
    for j = 1:101
        data = squeeze(featuresMat(:, :, j));
        predicted = predict(model, data);
        accuracy_matrix(i, j) = mean(predicted == labels);
    end
end

numPerms = 500;
numTimes = 101;
numTrials = 280;
pMatrix = zeros(numTimes, numTimes);
permutedAccuracies = zeros(numPerms, numTimes, numTimes);

Precompute test slices
X_test_all = cell(numTimes, 1);
for t = 1:numTimes
    X_test_all{t} = squeeze(featuresMat(:, :, t));
end

Start timer
tic;

parfor perm = 1:numPerms
    disp(perm)
    shuffledLabels = labels(randperm(numTrials));
    % Local result for this permutation
    localAccMatrix = zeros(numTimes, numTimes);

    for trainTime = 1:numTimes
        model = models{trainTime};

        for testTime = 1:numTimes
            X_test = X_test_all{testTime};
            Y_test = shuffledLabels;

            preds = predict(model, X_test);
            acc = mean(preds == Y_test);

            localAccMatrix(trainTime, testTime) = acc;
        end
    end

    % Store the local matrix into the correct slice
    permutedAccuracies(perm, :, :) = localAccMatrix;
end

toc;

for i = 1:numTimes
    for j = 1:numTimes
        realAcc = accuracy_matrix(i, j);
        nullDist = squeeze(permutedAccuracies(:, i, j));
        pMatrix(i, j) = mean(nullDist >= realAcc);
    end
end

significanceMask = pMatrix < 0.05;

figure;
imagesc(accuracy_matrix);
axis xy;
colorbar;
title('Time-Time Decoding with Significant Areas (p < 0.05)');
xlabel('Test Time');
ylabel('Train Time');
hold on;
contour(significanceMask, 1, 'LineColor', 'k');
