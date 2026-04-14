% EXAMPLE 6:
%
% The differential equation is y'' + 2/x y' = (φ^2)y exp( (γβ(1 − y))/(1 +β(1 − y))).
% One boundary condition is y(1) = 1.
%
% It arises in a study of heat and mass transfer in a porous spherical catalyst with a first order reaction.
% The differential equation is singular at x = 0, but the singular coefficient arises from the coordinate system and we
% expect a smooth solution for which symmetry implies that y′(0) = 0. 

function bvp_funcs=Example6()

        % Fixed parameters
        f = 0.6;
        g = 40;
        b = 0.2;

        % Local functions
        bvp_funcs.ode = @(x,y) ex6ode(x,y,f,g,b);
        bvp_funcs.bc = @(ya,yb) ex6bc(ya,yb,f,g,b);

%%SUBFUNCTIONS

% EX6ODE 
% I call the variables φ,γ and β as f, g and b.
% We must deal with the singularity in the coefficient at x = 0 because bvp4c always evaluates the ODEs at the end points.
%
% We take the limit as x→0. We know y'(x)/x → y''(0).
% So the equation becomes: y''(0)+2y′′(0) = (ϕ^2)y(0)exp⁡ ⁣(γβ(1−y(0))/(1+β(1−y(0))))
% That gives: 3y''(0) = (ϕ^2)y(0)exp⁡ ⁣(γβ(1−y(0))/(1+β(1−y(0))))
% y''(0) = 1/3(ϕ^2)y(0)exp⁡ ⁣(γβ(1−y(0))/(1+β(1−y(0))))​

function dydx = ex6ode(x,y,f,g,b)
dydx = [y(2); 0];
temp = f^2 * y(1) * exp(g*b*(1-y(1))/(1+b*(1-y(1))));
if x == 0
    dydx(2) = (1/3)*temp;
else
    dydx(2) = -2*(y(2)/x) + temp;
end
end

% EX6BC 
function res = ex6bc(ya,yb,f,g,b)
res = [ ya(2)
        yb(1) - 1];
end

end
