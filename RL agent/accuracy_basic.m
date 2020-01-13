% Calculates accuracy as proportion of choices made by participant which
% are the same as those made by an RL agent. In this version the
% cross-terms are set to [0 0 0], alpha = 1, beta = 8. Choosing these
% parameters can have an impact on analysis!

function [acc_basic] = accuracy_basic(filename);

import = importdata(filename);

data = import.data;

% determine % of optimal choices

choices = data(:,6);

% In my code 1 = A, 0 = B, 2 = C. Need to recode. 
cues = data(:,2);

cues(cues == 2) = 3;
cues(cues == 0) = 2;

rewards = data(:,7);

% rewards represents whether the participants were actually rewarded for
% their choices. Howevever the model tracks outcomes - whether the correct
% choice "was Red" or "was Blue". Need to recode reward rewards to
% outcomes. 1 = Red, 0 = Blue. 

for i = 1:length(rewards);
    
    if choices(i) == 1;
        outcomes(i,1) = rewards(i);
    elseif choices(i) == 2;
        if rewards(i) == 1;
        outcomes(i,1) = 0 ;
        elseif rewards(i) == 0;
            outcomes(i,1) = 1;
        end  
    elseif choices(i) == 0;
        outcomes(i,1) = rewards(i);
    end
end


theta = [1 8 0 0 0];

[~,VVred,PPred] = log_likelihood(theta,cues,outcomes,choices);

% check another measure of accuracy

acc_choice = nan(length(PPred),1);

simchoicerand = rand(length(PPred),1);

simchoices = nan(length(PPred),1);


for i = 1:length(PPred)
    
    if simchoicerand(i) <= PPred(i)
        
       simchoices(i) = 1;
       
    elseif simchoicerand(i) > PPred(i)
        
       simchoices(i) = 2;
       
    end
    
end

for i = 1:length(PPred)
    
    if simchoices(i) == choices(i)
        
       acc_choice(i) = 1;
       
    elseif simchoices(i) ~= choices(i)
        
       acc_choice(i) = 0;
       
    end
    
end

acc_basic = sum(acc_choice)/length(acc_choice);

end