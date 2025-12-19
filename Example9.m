% EXAMPLE 9
% This is a reformulation of a three-point BVP for BVP4C.
% The original problem is on [0, lambda] with conditions at 0, 1, and lambda.
% It is reformulated as a 4-component system on the single interval [0, 1].
% y(1)=v on [0,1], y(2)=C on [0,1].
% y(3)=v on [1,lambda], y(4)=C on [1,lambda] (in transformed tau variable).

% Equation: v'= (C-1)/n
%          C'= (vC-min(x,1))/eta
% Boundary conditions: v(0)=0, C(lambda)=1

% n and eta are dimentionless known parameters and lambda is greater than
% one, here we use lambda=2

%It is solved by continuation: the solution of one value of kappa is used
%as a guess for the next one

function bvp_funcs = Example9()

bvp_funcs.ode = @ex9ode;
bvp_funcs.bc = @ex9bc;
bvp_funcs.n_param = 5e-2;
bvp_funcs.lambda_param = 2;
bvp_funcs.kappa_init = 2; % Initial kappa

%% LOCAL FUNCTIONS (SUBFUNCTIONS)

%EX9ODE
function dydx = ex9ode(x,y,n,lambda,eta)
dydx = [ (y(2) - 1)/n
         (y(1)*y(2) - x)/eta 
         (lambda - 1)*(y(4) - 1)/n       
         (lambda - 1)*(y(3)*y(4) - 1)/eta ]; 
end

%EX9BC
function res = ex9bc(ya,yb,n,lambda,eta)
res = [ ya(1)         
        yb(4) - 1     
        yb(1) - ya(3) 
        yb(2) - ya(4)];
end


end