function Exercise3_kmeans( Data1, Data2, Data3, init1, init2, init3, k)
%% K-Means Algo

[steps1,labels1] = k_means(Data1,init1,k);
[steps2,labels2] = k_means(Data2,init2,k);
[steps3,labels3] = k_means(Data3,init3,k);

%% Plot clusters produced by K-means
plot_clusters(Data1,labels1,'k-means-l')
plot_clusters(Data2,labels2,'k-means-o')
plot_clusters(Data3,labels3,'k-means-x')
end

function [steps,labels] = k_means(Data,Init,k)
% init variables
Data = reshape(Data,[600 3]);
mu_cluster = Init;
n = size(Data,1);
J_old = inf;
decrement_goal = 10e-6;
decrement = inf;
steps = 0;

while (decrement > decrement_goal)
    % init min distances and class labels in each step
    dist_min = zeros(n,1);
    labels = zeros(n,1);

    % E-Step: find the closest class and label them
    for i=1:n
        %distance of each data point to each class
        dist = zeros(k,1);
        
        % calc euklid distance of each data point to every class
        for j=1:k
            dist(j) = euk_dist(Data(i,:),mu_cluster(j,:));
        end
        % get min distance and related cluster for each data point
        [dist_min(i), labels(i)] = min(dist);
    end
    
    % M-step: update new mean of each cluster
    for j=1:k
        mu_cluster(j,:) = mean(Data(labels==j,:));
    end
 
    % Calculate the total distortion, the sum of the distance 
    % between each datapoint and its closest cluster mean.
    J = sum(dist_min);

    % calc decrement of distortion
    decrement = J_old - J;
    J_old = J;
    steps = steps +1;
    %plot_clusters(Data,cluster,'test_k_means')
end
end