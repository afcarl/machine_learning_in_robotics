function [gmm_mean,gmm_pi,gmm_cov] = Exercise1()

% Ex1 a) Initialize the GMM parameters with the k-means algorithm 
load('dataGMM.mat');
n = size(Data,2);
K = 4;

[centroids_indizes, gmm_mean] = kmeans(Data',K);
gmm_cov = cell(0);
gmm_pi = zeros(1,K);
for j=1:K
    current_data = Data(:,centroids_indizes==j)';
    gmm_cov{j} = cov(current_data);
    gmm_pi(j) = sum(centroids_indizes==j)/n;
end

% Ex2 b) Implement Expectation?Maximization estimation of GMM parameters
gmm_loglike(1) = 0;
for counter = 2:100 % MaxSteps
    
    % 2. E-step: Evaluate the responsibilities using the current parameters
    responsibility = zeros(n,K);
    for j=1:size(Data,2)
        [responsibility(j,:), centroids_indizes(j)] = EStep(K,Data(:,j)',gmm_pi,gmm_mean,gmm_cov);
    end

    % Save OLD data for converge detection:
    gmm_mean_old = gmm_mean;
    gmm_cov_old = gmm_cov;
    gmm_pi_old = gmm_pi;
    
    % 3. M-step: Re-estimate the parameters using the current responsibilities
    for j=1:K
        nk = sum(responsibility(:,j));
        gmm_mean(j,:) = 1/nk * responsibility(:,j)'*Data';
        gmm_cov{j} = 1/nk *(repmat(responsibility(:,j),1,2).*(Data' - repmat(gmm_mean(j,:)',1,n)'))'*(Data' - repmat(gmm_mean(j,:)',1,n)');
        gmm_pi(j) = nk/n;
    end

    % 4. Evaluate the log-likelihood and...
    loglike = 0;
    loglike2 = 0;
    for j=1:n
        for k = 1: K
            loglike2 = loglike2 + gmm_pi(k) * gaussOne(Data(:,j)', gmm_mean(k,:), gmm_cov{k});
        end
        loglike = loglike + log(loglike2);
    end
    gmm_loglike(counter) = loglike;
    
    % ...check for convergence 
    if isConverged(loglike,gmm_loglike(counter-1)) || isConverged(gmm_mean_old,gmm_mean) || isConverged(gmm_cov_old,gmm_cov) || isConverged(gmm_pi_old,gmm_pi)
        break
    end
end
end

%% Helper Functions

function [responsibility, cluster] = EStep(K,x,pi,mu,sigma)
    %[X1,X2] = meshgrid(x1,x2);
    denominator = 0;
    responsibility = zeros(K,1);
    for j=1:K
        denominator = denominator + pi(j)*gaussOne(x,mu(j,:),sigma{j}); 
    end
    for j=1:K
        responsibility(j) = pi(j)*gaussMany(x, mu(j,:), sigma{j}) ./ denominator;
    end
    [~, cluster] = max(responsibility);
end

function res = isConverged(a,b)
    res=true;
    tol = 10e-7;
    if(iscell(a))
        for k = 1:size(a,2)
           res = res && (norm((a{k}-b{k}),2))<tol;
        end
    else
        res = res && (norm((a-b),2))<tol;
    end

end

function pdf = gaussOne(x,mu,sigma)
    pdf = 1 / sqrt((2*pi)^(size(x,2)/2)*det(sigma)) * exp(-0.5*(x-mu)*inv(sigma)*(x-mu)');
end

function pdf = gaussMany(x,mu,sigma)
    % Fast calculation of muliple input data
    % First calc exponent:
    A = -0.5*(x-repmat(mu,size(x,1),1))*inv(sigma);
    B = (x-repmat(mu,size(x,1),1));
    % Linewise multiplication:
    exponent = sum(bsxfun(@times,A,B),2);
    % Calculate PDF:
    pdf = 1 / sqrt((2*pi)^(size(x,2)/2)*det(sigma))*exp(exponent);
end

