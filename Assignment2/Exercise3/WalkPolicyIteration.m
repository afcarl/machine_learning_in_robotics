function [policy, iteration] = WalkPolicyIteration(startState)

gamma = 0.94;

% Delta(s, a)
delta = [2,4,5,13;
    1,3,6,14;
    4,2,7,15;
    3,1,8,16;
    6,8,1,9 ;
    5,7,2,10;
    8,6,3,11;
    7,5,4,12;
    10,12,13,5;
    9,11,14,6;
    12,10,15,7;
    11,9,16,8;
    14,16,9,1;
    13,15,10,2;
    16,14,11,3;
    15,13,12,4];

% Reward Matrix
rew = [ 0, 0, 0, 0;
    0, 1, -1, 0;
    0, -1, -1, -1;
    0, 0, 0, 0;
    -1,-1, 0, 1;
    0, 0, 0, 0;
    0, 0, 0, 0;
    -1, 1, 0, 0;
    -1, -1, 0, -1;
    0, 0, 0, 0;
    0, 0, 0, 0;
    -1, 0, 0, 0;
    0, 0, 0, 0;
    0, 0, -1, 1;
    0, -1, -1, 1;
    0, 0, 0, 0];

policy = ceil(rand(16,1)*4);
policyOld = policy;

% Repeat until convergence
iteration = 0;
while(1)
    iteration = iteration + 1;
    
    b = zeros(16,1);
    A = eye(16);
    % Bellman equation:
    for state = 1:16
        % Part 1
        b(state) = rew(state, policy(state));
        % Part 2
        A(state,delta(state,policy(state))) = -gamma;
    end
    Vpi = A\b;
    
    % Update policy with argmax
    for state = 1:16
        maxValue = -inf;
        for j = 1:4
            temp = rew(state,j) + gamma * Vpi(delta(state,j));
            
            if(temp > maxValue)
                policy(state) = j;
                maxValue = temp;
            end
        end
    end
    
    % Abbort condition
    if(all(policyOld == policy))
        break;
    end
    policyOld = policy;
end

% Create state sequence
states = zeros(16,1);
states(1) = startState;
for i = 2:16
    states(i) = delta(states(i-1),policy(states(i-1)));
end
figure
walkshow(states.');
title(strcat("WalkPolicyIteration with Starting State ", num2str(startState)));
end