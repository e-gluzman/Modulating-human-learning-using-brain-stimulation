function [theta_ML, NeglogLik_ML] = model_fit(cues,outcomes,choices,R);

% This function fits parameters to the RL model using fmincon. 

NeglogLik_ML_all = nan(R,1);
theta_ML_all= nan(R,5); % [alpha1, beta, C_ab, C_ac, C_bc]

% Set up upper/ lower bounds for each parameter

LB = [0,0]; % Lower bound for alpha1, beta
UB = [1,8]; % Upper bound for alpha1 beta
% X0 = [.2,1]; % initial point for alpha, beta
X0 = [LB(1) + (UB(1)-LB(1)).*rand(R,1),LB(2) + (UB(2)-LB(2)).*rand(R,1)];

LB = [LB, -1]; % lower bound for C_ab
UB = [UB, 1]; % lower bound for C_ab
X0 = [X0, LB(3) + (UB(3)-LB(3)).*rand(R,1)]; %  initial point for C_ab

LB = [LB, -1];
UB = [UB, 1];
X0 = [X0, LB(4) + (UB(4)-LB(4)).*rand(R,1)]; %  initial point for C_ac

LB = [LB, -1];
UB = [UB, 1];

X0 = [X0, LB(5) + (UB(5)-LB(5)).*rand(R,1)]; %  initial point for C_bc


% fit data to model
energy = @log_likelihood;
OPTIM_options = optimset('Display', 'off') ;

for i = 1:R
[theta_ML_all(i,:), NeglogLik_ML_all(i)] = fmincon(@(theta) energy(theta,cues,outcomes,choices),X0(i,:)',[],[],[],[],LB', UB',[],OPTIM_options);
end

[NeglogLik_ML,I] = max(NeglogLik_ML_all);
theta_ML = theta_ML_all(I,:);


end