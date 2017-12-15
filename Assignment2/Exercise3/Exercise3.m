%function Exercise3()
% Script/Function for Testing the wanted Starting States
iteration = zeros(16,1);
for i=1:16
[~, iteration(i)] = WalkPolicyIteration(i);
WalkQLearning(i)
end
%end
