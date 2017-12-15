%function [Results, loglikelihood] = Exercise2()

% Load Data from Text files
ObservationSeqs = load('Test.txt'); % Segmentation of Sequences clustered with kMeans
TransitionMatrix = load('A.txt');   % Transition Prob Matrix
EmissionMatrix = load('B.txt');     % Observation Prob Matrix
InitStateVector = load('pi.txt');   % Init State Prob Vector

EmissionMatrix = EmissionMatrix';   % needs to be (NxM) with M = Number of Emissions
N = size(TransitionMatrix,1);       % Number of States
T = size(ObservationSeqs,1);        % Length of Observation = Tmax
R = size(ObservationSeqs,2);        % Number of Repetitions
loglikelihood = zeros(R,1);

% Forward Procedure Algorithm
for r = 1:R
    for i = 1:N             % Initialization
        alpha(1,i) = InitStateVector(i) * EmissionMatrix(i,ObservationSeqs(1,r));
    end
    for t = 1:(T-1)       
        for j=1:N           % Induction
            alpha(t+1,j) = sum(alpha(t,:)*TransitionMatrix(:,j)) * EmissionMatrix(j,ObservationSeqs(t+1,r));
        end
    end
    p = sum(alpha(T,:));    % Termination
    loglikelihood(r) = log(p);
end

% Classification
Results = repmat('gesture2',R,1);
Results(loglikelihood>-120,:) = repmat('gesture1',sum(loglikelihood>-120),1);

%end
