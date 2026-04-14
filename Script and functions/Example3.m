%EXAMPLE 3:
%
% How to use bvp4c solver to find an eigenvalue (λ) and corresponding eigenfunction y(x)
% for a boundary value problem (BVP) that depends on an unknown parameter.
%
% Problem: we have Mathieu's equation: y''+(λ−2qcos⁡(2x))y=0 on the interval [0,π], where q=5.
% The boundary conditions are: y'(0)=0, y'(π)=0 and the normalization condition: y(0)=1.

function bvp_funcs=Example3()

bvp_funcs.ode = @ex3ode;
bvp_funcs.init = @ex3init;
bvp_funcs.bc = @ex3bc;

%%LOCAL FUNCTIONS (SUBFUNCTIONS)

% EX3ODE 
% When you have unknown parameters we add an input argument lambda
function dydx = ex3ode(x,y,lambda)
q = 5;
dydx = [y(2);
    -(lambda - 2*q*cos(2*x))*y(1)];
end

% EX3INIT 
% The function cos(4x) satisfies the boundary conditions and has the correct number of sign changes. 
% It and its derivative are provided as a guess for the vector solution.

function v = ex3init(x)
v = [ cos(4*x)
    -4*sin(4*x)];
end

% EX3BC 
% lambda must be an argument in ex3bc because bvp4c always passes it, even if your boundary conditions don't use it.
function res = ex3bc(ya,yb,lambda)
res = [ ya(2)
        yb(2)
        ya(1) - 1];
end

end





