function gtRDM = groundTruthRDM(categoryLabels)
nStimuli = length(categoryLabels);
gtRDM = zeros(nStimuli, nStimuli);

for i = 1:nStimuli
    for j = 1:nStimuli
        if categoryLabels(i) == categoryLabels(j)
            gtRDM(i,j) = 0;
        else
            gtRDM(i,j) = 1;
        end
    end
end
end