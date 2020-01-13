function [NegLogLik,VVred,PPred] = log_likelihood(theta,cues,outcomes,choices);

alpha= theta(1); 
beta = theta(2);
C_ab = theta(3);
C_ac = theta(4);
C_bc = theta(5);

corr_params = [C_ab, C_ac, C_bc];

v0 = 0;
vred = nan(3,1);
vred(:)=v0;
N = length(cues);
PPred = nan(N,1); % This model tracks probability of choosing red
VVred = nan(N,3); % track value of choosing red

    for t = 1:N;

    c = cues(t);
    
    % The selector rule, outputs probability of choosing red based on
    % calculated values
    pred = 1/(1+exp(-beta*(2*vred(c)-1)));
    
    % Alternative versions of the rule for different inputs (1,-1 instead
    % of 1,0)
    
    %pred = 1/(1+exp(- beta*(vred(c)-0.5))); 
    %pred   = 1/(1+exp(- beta*(vred(c)))); 
    
    PPred(t,:) = pred;  
    
    % Calls the Rescorla-Wagner rule function for calculation values of
    % different choice options. Also includes cross-terms.
    [vred] = calculate_values(vred,outcomes(t),cues(t),alpha,corr_params);
    
    VVred(t,:) = vred;

    end

    % Log likelihood of choosing Red + likelihood of choosing Blue. This
    % parameter is minimised in order to fit model to choices.
    NegLogLik = sum(-log(PPred(choices==1))) + sum(-log(1-PPred(choices==2)));
    
    

    
