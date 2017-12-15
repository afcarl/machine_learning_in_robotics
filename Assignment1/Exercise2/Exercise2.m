%function Exercise2(d_max)
d_max = 60;
images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');
images_test = loadMNISTImages('t10k-images.idx3-ubyte');
labels_test = loadMNISTLabels('t10k-labels.idx1-ubyte');

% Init variables:
error_ges = zeros(d_max,1);
im_mean = cell(1);
im_covariance = cell(1);
confusion_mat = cell(d_max,1);
n_test = size(images_test,2);

%% PCA basis
% Make the Images zero 
meanAllImages = mean(images,2); % 2: Mean every Pixel not every image
images = images - meanAllImages;
images_test = images_test - meanAllImages;

% calc Transformation matrix W
C = cov(images');   % Covariance Matrix
[V,~] =  eig(C);    % Eigenvector Matrix
V = fliplr(V);      % sort from biggest to smallest Eigenvalue

%% PCA and Maximum Likelihood Classifier
for d=1:d_max
    % Take d principal components of W for PCA
    W = V(:,1:d); 
    
    % Init likelihood vector
    likelihood = zeros(10,n_test);
    % For each novel test input:
     for i=1:10
        % Project the images of the current digit class (PCA)
        projectedImages = W'*images(:,labels==(i-1)); % [0,...,9]
        % Make the ProjectedImages zero mean and calc the covariance 
        im_mean{i} = mean(projectedImages,2);
        temp = projectedImages - im_mean{i};
        im_covariance{i} = cov(temp');
        % Project the test images for likelihood calculation
        projectedImagesTest = W'*images_test;
        % Calc the likelihood for the projected test data for each class
        likelihood(i,:) = mvnpdf(projectedImagesTest',im_mean{i}',im_covariance{i});
     end

    % Assosiate the input to the class yielding highest likelihood value
    [~, predicted_number] = max(likelihood);
    predicted_number = (predicted_number-1)';
    % Calc number of missclassifications
    error = sum(labels_test~=predicted_number);
    % Calc confusion matrix for each d
    confusion_mat{d} = confusionmat(labels_test,predicted_number);
    % Calc error for each d in percent
    error_ges(d) = (100*error)/n_test;
    %disp(['Current Error for d = ', num2str(d), ' is: ', num2str(error_ges(d)), ' %']);
end


%% calc optimal parameters and plot the Error-curve
[error_d, optimal_d] = min(error_ges);
disp('---------------------------------------');
disp('Result:');
disp(['Minimal error: ', num2str(error_d), ' %']);
disp(['with optimal parameter d = ', num2str(optimal_d)]);
disp('with ConfusionMatrix for optimal d:');
confusion_d = confusion_mat{optimal_d};
helperDisplayConfusionMatrix(confusion_d);

h = figure;
plot(error_ges);
ylabel('Error in %') % x-axis label
xlabel('d value') % y-axis label

%% safe Error Plot as pdf-file
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
print(h,'plotError','-dpdf','-r0');
%end