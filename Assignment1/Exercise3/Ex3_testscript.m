% testscript Exercise3
load('gesture_dataset.mat');
k = 7;
%Exercise3_kmeans(gesture_l,gesture_o,gesture_x,init_cluster_l,init_cluster_o,init_cluster_x,k);
[center_l,center_o,center_x,labels_l,labels_o,labels_x] = Exercise3_nubs(gesture_l, gesture_o, gesture_x, k);

%DEBUG
for i=1:k
    if isempty(find(labels_l==i))
        disp('l hat keine klasse')
        disp(i)
    end
    if isempty(find(labels_o==i))
        disp('o hat keine klasse')
        disp(i)
    end
    if isempty(find(labels_x==i))
        disp('x hat keine klasse')
        disp(i)
    end
end