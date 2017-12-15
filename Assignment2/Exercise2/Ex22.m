% Load Data from Text files
Data = load('Test.txt');    % Segmentation of Sequences clustered with kMeans
A = load('A.txt');          % Transition Prob Matrix
B = load('B.txt');          % Observation Prob Matrix
prior = load('pi.txt');     % Init State Prob Vector

% Init data
num_Reps = size(Data,2);    % Number of repetitions 
len_Seq = size(Data,1);     % Length of Sequences
num_States = size(A,1);     % Number of States
loglikelihood=zeros(len_Seq,1);

% Forward Procedure
for n=1:len_Seq %len_Seq
    alpha=zeros(num_States, 1);
    alpha_prev=alpha;
    for t=1:num_Reps %num_Reps
        for s=1:num_States
            if(t==1)
                % Initialization
                alpha(s)=prior(s)*B(Data(n,t),s);
            else
                % Induction
                alpha(s)=sum(alpha_prev.*A(:,s))*B(Data(n,t),s); %A(:,s) oder A(s,:)' ?
            end
        end
        alpha_prev=alpha;
    end
    % Termination
    loglikelihood(n)=log(sum(alpha));
end

% Classification
Results = repmat('gesture2',len_Seq,1);
Results(loglikelihood>-120,:) = repmat('gesture1',sum(loglikelihood>-120),1);