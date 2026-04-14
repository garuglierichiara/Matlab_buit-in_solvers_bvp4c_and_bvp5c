%EXERCISE of example 3:
%
% It arises when modelling a tubular reactor with axial dispersion. An isothermal situation with n-th order 
% irreversible reaction leads to the differential equation y'' = Pe(y'−Ry^n), 
% where Pe is the axial Peclet number and R is the reaction rate group.
% The boundary conditions are y'(0) = Pe(y(0) − 1), y'(1) = 0. 
% Using an orthogonal collocation method, we find that y(0) = 0.63678 and y(1) = 0.45759 when Pe = 1, R = 2, and n = 2.
% These values are consistent with those obtained by others using a finite difference method.

function bvp_funcs = Exercise_trbvp()

% Fixed parameters
Pe = 1;
R  = 2;
n  = 2;

% Local functions
bvp_funcs.ode  = @(x,y) trbvp_ode(x,y,Pe,R,n);
bvp_funcs.bc   = @(ya,yb) trbvp_bc(ya,yb,Pe);

% ODE function
function dydx = trbvp_ode(x,y,Pe,R,n)
    dydx = [y(2);
            Pe*(y(2) + R*y(1)^n)];
end

% Boundary conditions
function res = trbvp_bc(ya,yb,Pe)
    res = [ya(2) - Pe*(ya(1) - 1);
           yb(2)];
end
end