face_counts = sum(group_face(:, 150:250), 2);
body_counts = sum(group_body(:, 150:250), 2);
natural_counts = sum(group_natural(:, 150:250), 2);
artifical_counts = sum(group_artifical(:, 150:250), 2);
categories.Face = face_counts;
categories.Body = body_counts;
categories.Natural = natural_counts;
categories.Artificial = artifical_counts;


pairs = {
    'Face', 'Body';
    'Face', 'Natural';
    'Face', 'Artificial';
    'Artificial', 'Body';
    'Artificial', 'Natural'
};

dvals = zeros(size(pairs, 1), 1);
labels = cell(size(pairs, 1), 1);

for k = 1:size(pairs, 1)
    cat1 = pairs{k, 1};
    cat2 = pairs{k, 2};
    data1 = categories.(cat1);
    data2 = categories.(cat2);
    
    mu1 = mean(data1);
    mu2 = mean(data2);
    sigma1 = std(data1);
    sigma2 = std(data2);
    
    d = (mu1 - mu2) / sqrt(0.5 * (sigma1^2 + sigma2^2));
    dvals(k) = d;
    labels{k} = [cat1 ' vs ' cat2];
end

figure;
bar(dvals);
set(gca, 'XTickLabel', labels, 'XTick', 1:length(labels));
xtickangle(45);
ylabel('d-prime');
title('Selected Category Discriminability (d-prime)');