function mi = compute_mutual_information(spikes, labels)
    edges = linspace(min(spikes), max(spikes), 6);
    spike_bins = discretize(spikes, edges);
    
    joint = accumarray([spike_bins, labels + 1], 1);
    joint_prob = joint / sum(joint(:));
    px = sum(joint_prob, 2);
    py = sum(joint_prob, 1);

    mi = 0;
    for i = 1:length(px)
        for j = 1:length(py)
            if joint_prob(i,j) > 0
                mi = mi + joint_prob(i,j) * log2(joint_prob(i,j) / (px(i)*py(j)));
            end
        end
    end
end