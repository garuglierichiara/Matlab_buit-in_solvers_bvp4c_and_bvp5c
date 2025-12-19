% EXERCISE MICHAELIS - MENTEN (Example 7)
% 
% This ecercise illustrates how to solve BVP with a solution having a
% singular point in the origin.
%
% This is the Michaelis-Menten kinetics problem solved using parameters 
% epsilon = 0.1 and k = 0.1.
%
% The boundary conditions at x = d are that y and y' have values yatd and 
% ypatd obtained from series expansions. The unknown parameter p = y(0) 
% is used in the expansions. y''(d) also appears in the expansions.  
% It is evaluated as a limit in the differential equation.

function bvp_funcs = ExerciseMichaelisMenten()

    % Fixed parameters
    epsilon = 0.1;
    k = 0.1;
    d = 0.001;

    % Local functions
    bvp_funcs.ode  = @(x,y,p) mmode(x,y,p,epsilon,k,d);
    bvp_funcs.bc = @(ya,yb,p) mmbc(ya,yb,p,epsilon,k,d);

    % bvp_funcs.ode = @mmode;
    % bvp_funcs.bc = @mmbc;

end



% MMODE:
function dydx = mmode(x,y,p,epsilon,k,d)
dydx = [  y(2)
         -2*(y(2)/x) + y(1)/(epsilon*(y(1) + k)) ];
end

% --------------------------------------------------------------------------

% MMBC:
function res = mmbc(ya,yb,p,epsilon,k,d)
yp2atd = p /(3*epsilon*(p + k));
yatd = p + 0.5*yp2atd*d^2;
ypatd = yp2atd*d;
res = [ yb(1) - 1
        ya(1) - yatd
        ya(2) - ypatd ];
end


