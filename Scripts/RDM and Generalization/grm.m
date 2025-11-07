% % Load pretrained SqueezeNet
% net = squeezenet;
% 
% % Set image path
% imageFolder = 'Data\Stimuli\Stimuli';
% imgFiles = dir(fullfile(imageFolder, '*.tif'));  % Use .tif as specified
% nImages = length(imgFiles);
% 
% % pool10 outputs 1x1x1000 → use 1000-dimensional feature vectors
% features = zeros(nImages, 1000);
% 
% % Loop through images
% for i = 1:nImages
%     % Read and resize image
%     img = imread(fullfile(imageFolder, imgFiles(i).name));
%     img = imresize(img, net.Layers(1).InputSize(1:2));
% 
%     % Convert grayscale to RGB
%     if size(img, 3) == 1
%         img = repmat(img, [1, 1, 3]);
%     end
% 
%     % Extract features from 'pool10' layer
%     imgFeatures = activations(net, img, 'pool10', 'OutputAs', 'rows');
%     features(i,:) = imgFeatures;
% end
% 
% % Compute Euclidean pairwise distances
% visualRDM = squareform(pdist(features, 'euclidean'));

% gtVec = squareform(gtRDM);          % Ground truth RDM
% visualVec = squareform(visualRDM);  % Visual RDM (constant over time)
% nTimes = size(rdm, 3);              % FIXED
% rSquared = zeros(1, nTimes);        % Allocate full-length R² vector
% 
% for t = 1:nTimes
%     currRDM = rdm(:,:,t);                              % Extract neural RDM at time t
%     currRDM(1:size(currRDM,1)+1:end) = 0;              % Set diagonal to 0
%     neuralVec = squareform(currRDM);                   % Vectorize
% 
%     X = [visualVec', neuralVec'];                      % Design matrix
%     X = zscore(X);                                     % Normalize
% 
%     mdl = fitglm(X, gtVec', 'linear');                 % Fit GLM
%     rSquared(t) = mdl.Rsquared.Ordinary;               % Store R²
% end
% 
% figure;
% plot(1:nTimes, rSquared, 'LineWidth', 2);
% xlabel('Time (ms)');
% ylabel('Explained Variance (R^2)');
% title('GLM: Neural + Visual Predictors for Ground Truth RDM');
% grid on;

uniqueNeural = zeros(1, nTimes);
for t = 1:nTimes
    currRDM = rdm(:,:,t);                              % Extract neural RDM at time t
    currRDM(1:size(currRDM,1)+1:end) = 0;              % Set diagonal to 0
    neuralVec = squareform(currRDM); 
    X_full = [visualVec', neuralVec'];
    X_vis = visualVec';
    
    X_full = zscore(X_full);
    X_vis = zscore(X_vis);
    
    mdl_full = fitglm(X_full, gtVec', 'linear');
    mdl_vis = fitglm(X_vis, gtVec', 'linear');
    
    uniqueNeural(t) = mdl_full.Rsquared.Ordinary - mdl_vis.Rsquared.Ordinary;
end

% Plot unique contribution of neural RDM
figure;
plot(1:nTimes, uniqueNeural, 'LineWidth', 2);
xlabel('Time (ms)');
ylabel('Unique R^2 from Neural RDM');
title('Unique Variance Explained by Neural Representation');
grid on;