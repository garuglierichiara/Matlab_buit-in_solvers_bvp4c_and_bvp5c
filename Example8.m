%EXAMPLE 8
%   These equations describe flow in a long vertical channel with fluid injection through one side

% Equations: f''' - R*[(f')^2 - f*f''] + R*A = 0
%              h'' + R*f*h' + 1 = 0
%              theta'' + P*f*theta' = 0
% Boundary conditions: f(0) = f'(0) = 0
%                     f(1) = 1
%                     f'(1) = 0
%                     h(0) = h(1) = 0
%                     theta(0) = 0
%                     theta(1) = 1

%   Here R and P are known constants, but A is determined by the boundary 
%   conditions.

%   For a Reynolds number R = 100, this problem can be solved with crude
%   guesses, but as R increases, it becomes much more difficult because of
%   a boundary layer at x = 0.


function bvp_funcs = Example8()
R=100;
bvp_funcs.ode = @ex8ode;
bvp_funcs.bc = @ex8bc;
bvp_funcs.R_init = R; % Initial Reynolds number for the app to use

%% SUBFUNCTIONS

%EX8ODE 
function dydx = ex8ode(x,y,A,R)
P = 0.7*R;
dydx = [ y(2)
         y(3)
         R*(y(2)^2 - y(1)*y(3) - A)
         y(5)
        -R*y(1)*y(5) - 1
         y(7)
        -P*y(1)*y(7) ];
end

%EX8BC
function res = ex8bc(ya,yb,A,R)
res = [ya(1)      
       ya(2)     
       yb(1) - 1  
       yb(2)      
       ya(4)      
       yb(4)      
       ya(6)      
       yb(6) - 1];
end


end