function [states] = WalkQLearning( startState )

% Init Hyperparameters
epsilon = 0.3;      % Percentage of random actions 
iterations = 60000; % Number of iterations     
alpha = 0.8;        % Learning rate    
gamma = 0.95;       % Discount factor

% change Algorithm to 'pure greedy'
pure_greedy = false;
if(pure_greedy)
    epsilon = 0;
end

s_show = startState;
Q = zeros(16,4);
pi = zeros(16,1);

% Calculate policy
for j=1:iterations
    if rand()>1-epsilon
        % First random
        action = ceil(rand()*4);
        [snew, rew]=SimulateRobot(startState,action);
        Q(startState,action)=Q(startState,action)+alpha*(rew+gamma*max(Q(snew,:))-Q(startState,action));
    else
        % Use best policy
        rew=-inf;
        for act=1:4
            [snew, rewnew]=SimulateRobot(startState,act);
            if rewnew>rew
                action = act;
            end
        end
        Q(startState,action)=Q(startState,action)+alpha*(rewnew+gamma*max(Q(snew,:))-Q(startState,action));
    end
    startState = snew;
end
% Policy
for count=1:16
    [~,pi(count)]=max(Q(count,:));
end
pi'

% Create state sequence
states = zeros(16,1);
states(1) = s_show;
for count = 2:16
    states(count) = SimulateRobot(states(count-1),pi(states(count-1)));
end
figure
walkshow(states')
title(strcat("WalkQLearning with Starting State ",num2str(startState)));
end

