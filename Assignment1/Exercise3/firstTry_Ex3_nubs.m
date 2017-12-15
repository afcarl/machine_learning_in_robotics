%function Exercise3_nubs(Data1, Data2, Data3, k)
function[center1,center2,center3,labels1,labels2,labels3] = firstTry_Ex3_nubs(Data1, Data2, Data3, k)
%% Non-Uniform Binary Split Algo
splitvector = [0.08, 0.05, 0.02];

[center1,labels1] = nu_bsplit(Data1,splitvector,k);
[center2,labels2] = nu_bsplit(Data2,splitvector,k);
[center3,labels3] = nu_bsplit(Data3,splitvector,k);

%% plot clusters
plot_clusters(Data1,labels1,'nu_bsplit_l');
plot_clusters(Data2,labels2,'nu_bsplit_o');
plot_clusters(Data3,labels3,'nu_bsplit_x');
end

function [center,labels] = nu_bsplit(Data,splitvector,K)
% init variables
%Data = gesture_l;
Data = reshape(Data, [600 3]);
n = size(Data,1);
split_vec = splitvector;
k = 1;
center = zeros(K,3);
center(1,:) = mean(Data);

while (true)
    % distance of each datapoint to each current available cluster
    dist_min = zeros(n,1);
    labels = zeros(n,1);

    % for each datapoint
    for in=1:n
        % calc distance to each current available cluster
        dist = zeros(k,1);
        for ik=1:k
            dist(ik) = euk_dist(Data(in,:),center(ik,:));
        end
        % get min distance and related cluster for each data point
        [dist_min(in), labels(in)] = min(dist);
    end
    
    % Quit Algo if the Clustering for K clusters is done
    %plot_clusters(Data,labels,'test_nu_bsplit');
    if k == K
        break;
    end
    
    % calc distortion for each current available cluster
    J = zeros(k,1);
    for ik=1:k
        J(ik) = sum(dist_min(labels==ik,:));
    end
    % get current cluster with biggest distortion
    [J_max, cluster_max] = max(J);
    
    % update code vector
    %split_vec = rand(3,1)'; % uncomment this for testing with random vector
    code_vec = [center(cluster_max,:) + split_vec; center(cluster_max,:) - split_vec];
    
    % split biggest cluster in two and calc mean as new centers
    Max_cluster = Data(labels==cluster_max,:);
    n_c = size(Max_cluster,1);
    count1 = 1;
    count2 = 1;
    for in=1:n_c
        dist1 = euk_dist(Max_cluster(in,:),code_vec(1,:));
        dist2 = euk_dist(Max_cluster(in,:),code_vec(2,:));
        if dist1 >= dist2
            split1(count1,:) = Max_cluster(in,:);
            count1 = count1+1;
        else
            split2(count2,:) = Max_cluster(in,:);
            count2 = count2+1;
        end
    end
    center_split1 = mean(split1);
    center_split2 = mean(split2);
    
    % update the two new split centers at the end of the cluster center list
    center(cluster_max,:) = center_split1;
    center(k+1,:) = center_split2;
    
    % increase cluster count
    k = k+1;
end
end