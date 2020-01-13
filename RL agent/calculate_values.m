function [vred] = calculate_values(vred,outcome,cue,alpha,corr_params);


C_ab = corr_params(1);
C_ac = corr_params(2);
C_bc = corr_params(3);

c = cue;

   % prediction error
   dvred = outcome - vred(c);

   % Rescorla-Wagner rule
   vred(c) = vred(c) + alpha*dvred;
   
   % There was a problem. If the outcomes were coded as 1,0 the cross-term
   % rule (see later) didn't work as intended. If the outcomes were coded
   % as -1,0 the RW rule didnt work correctly. So I recoded outcomes after
   % RW rule made its calculations but before the cross-terms did.
   
   if outcome == 1;
   ctoutcome = 1;
   elseif outcome == 0;
   ctoutcome = -1;

   %% Cross term equations. 
        if c == 1;

            vred(2) = (1 - abs(C_ab)*alpha) * vred(2) + C_ab*alpha*ctoutcome;

            vred(3) = (1 - abs(C_ac)*alpha) * vred(3) + C_ac*alpha*ctoutcome;

        elseif c == 2;

            vred(1) = (1 - abs(C_ab)*alpha) * vred(1) + C_ab*alpha*ctoutcome;

            vred(3) = (1 - abs(C_bc)*alpha) * vred(3) + C_bc*alpha*ctoutcome;

        elseif c == 3;

            vred(1) = (1 - abs(C_ac)*alpha) * vred(1) + C_ac*alpha*ctoutcome;

            vred(2) = (1 - abs(C_bc)*alpha) * vred(2) + C_bc*alpha*ctoutcome;

        end
        
        % Make sure there are no negative values. I think negative values
        % may be a problem for this RL model, so I fixed values to vred >
        % 0.
        
        for ind = 1:3;
        if vred(ind) < 0;
           vred(ind) = 0;
        end
        end
        
end