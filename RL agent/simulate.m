% Function for simulating choices.

function [model_choices, PP, VV] = simulate(cues,outcomes,alpha,beta,corr_params);


N = length(cues);
model_choices = nan(N,1);
v0 = 0; % initial value

vred = nan(3,1);
vred(:)=v0;

PP = nan(N,1); % track prob of choice through time
VV = nan(N,1);

for t=1:N
    
    c = cues(t);
    % The selector rule, outputs probability of choosing red based on
    % calculated values
    pred  = 1/(1+exp(- beta*(2*vred(c)-1)));
    
    % makes choices based on probabilities associated with values
    model_choices(t) = rand < pred; 
    PP(t) = pred;
    VV(t) = vred(c);
    
     % Calls the Rescorla-Wagner rule function for calculation values of
    % different choice options. Also includes cross-terms.
    vred = calculate_values(vred,outcomes(t),cues(t),alpha,corr_params);
     
end