% EXAMPLE 1: System of 5 first order ODEs
%
% This example shows how to use bvp4c for solving a generic non linear  
% system of first order ODEs.
%
% The problem is
%   
%      u' =  0.5*u*(w - u)/v
%      v' = -0.5*(w - u)
%      w' = (0.9 - 1000*(w - y) - 0.5*w*(w - u))/z
%      z' =  0.5*(w - u)
%      y' = -100*(y - w)
%   
% The interval is [0 1] and the boundary conditions are
%   
%      u(0) = v(0) = w(0) = 1,  z(0) = -10,  w(1) = y(1)

function bvp_funcs = Example1()

% Save the functions as fields of the structure
bvp_funcs.ode = @ex1ode;
bvp_funcs.init = @ex1init;
bvp_funcs.bc = @ex1bc;


%% SUBFUNCTIONS

% EX1ODE:
function dydx = ex1ode(x,y)

dydx =  [ 0.5*y(1)*(y(3) - y(1))/y(2)
         -0.5*(y(3) - y(1))
         (0.9 - 1000*(y(3) - y(5)) - 0.5*y(3)*(y(3) - y(1)))/y(4)
          0.5*(y(3) - y(1))
          100*(y(3) - y(5)) ];
end

%-------------------------------------------------------------------------

% EX1INIT
function v = ex1init(x)

v = [        1 
             1
     -4.5*x^2+8.91*x+1
            -10
     -4.5*x^2+9*x+0.91 ];
end

%-------------------------------------------------------------------------

% EX1BC:
function res = ex1bc(ya,yb)

res = [ ya(1) - 1
        ya(2) - 1
        ya(3) - 1
        ya(4) + 10
        yb(3) - yb(5)];
end

end