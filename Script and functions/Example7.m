% EXAMPLE 7: BVP with singular behavior at the origin
%
% This example shows how to handle with a solution having a singular
% behavior at the origin.
% 
% The problem is 
%      y'' = (y^3 - y')/(2x), 
% 
% The boundary conditions are
%      y(0) = 0.1,      y(16) = 1/6.  
% 
% The singularity at the origin is handled by using a series to represent 
% the solution and its derivative at a "small" distance d > 0, namely
%   
%      y(d)  = 0.1 + y'(0)*sqrt(d)/10 + d/100 
%      y'(d) = y'(0)/(20*sqrt(d)) + 1/100
%   
% The value y'(0) is treated as an unknown parameter p. The problem is
% solved numerically on [d, 16].  Two boundary conditions are that the
% computed solution and its first derivative agree with the values from
% the series at d.  The remaining boundary condition is y(16) = 1/6.



function bvp_funcs = Example7()

    % Fixed parameters
    d = 0.1;


    % Local functions
    bvp_funcs.ode = @(x,y,p) ex7ode(x,y,p,d);
    bvp_funcs.bc = @(ya,yb,p) ex7bc(ya,yb,p,d);
    

end


% EX7ODE:
function dydx = ex7ode(x,y,p,d)
dydx = [ y(2)
        (y(1)^3 - y(2))/(2*x) ];
end

% --------------------------------------------------------------------------
% EX7BC:
function res = ex7bc(ya,yb,p,d)

yatd =  0.1 + p*sqrt(d)/10 + d/100;
ypatd = p/(20*sqrt(d)) + 1/100;
res = [ ya(1) - yatd
        ya(2) - ypatd
        yb(1) - 1/6 ];
end
