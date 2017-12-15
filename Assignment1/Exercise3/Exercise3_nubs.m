%function Exercise3_nubs(Data1, Data2, Data3, k)
function[center1,center2,center3,labels1,labels2,labels3] = Exercise3_nubs(Data1, Data2, Data3, k)
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

function [centers,labels] = nu_bsplit(Data,vi,K)
% init first round
Data = reshape(Data, [600 3]);
N = size(Data,1);
centers = zeros(K,3);
centers(1,:) = mean(Data);
labels = ones(N,1); % at first all belong to class 1
for k=1:K-1
    % calc distortion
    distortion = zeros(k,1);
    for k_act = 1:k
        for n=1:N
            if labels(n)~=k_act
             continue;
            end
            distortion(k_act) = distortion(k_act) + euk_dist(Data(n,:),centers(k_act,:));
        end       
    end
    % update labels
    [~, max_center] = max(distortion);
    for n=1:size(Data,1)
        if labels(n)~=max_center
            continue;
        end
        if euk_dist(Data(n,:),centers(max_center,:)+vi) > euk_dist(Data(n,:),centers(max_center,:)-vi)
            labels(n) = max_center;
        else
            labels(n) = k + 1;
        end
    end  
    % calc new centers
    centers(max_center,:) = mean(Data(labels==max_center,:));
    centers(k+1,:) = mean(Data(labels==k+1,:));
end
end