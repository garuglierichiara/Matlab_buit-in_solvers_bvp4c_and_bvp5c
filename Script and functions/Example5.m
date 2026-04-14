% EXAMPLE 5:
%
%This example illustrates the straightforward solution of a problem set on an infinite interval. Cebeci and Keller use shooting methods to solve the Falkner-
%Skan problem that arises from a similarity solution of viscous, incompressible, laminar flow over a flat plate. 

% The differential equation is f''' + f f'' + β(1 − (f')^2) = 0 
%The boundary conditions are f (0) = 0, f ′(0) = 0, and f ′(η) → 1 as η → ∞ and replace the boundary condition at infinity with one at a finite point.

function bvp_funcs=Example5()

% BVPSYSTEMFUNCTIONS - Contiene le definizioni di ODE, BCs e Initial Guess
% 
% Non è destinata ad essere chiamata direttamente.
% Le funzioni ex3ode, ex3bc e ex3init sono le subfunctions
% utilizzate da runBVPApp.m.
bvp_funcs.ode = @ex5ode;
bvp_funcs.bc = @ex5bc;

%We first write equation as a system of three first order equations with variables f , u = f', and v = f''.
%A relatively difficult case, β = 0.5, is solved with the boundary
%condition f'(6) = 1. It is found that f''(0) = 0.92768, in agreement with the value 0.92768 reported by Cebeci and Keller.

%%LOCAL FUNCTIONS (SUBFUNCTIONS)

% EX5ODE 
function dxdy = ex5ode(x,y)
b = 0.5;
dxdy = [ y(2);
          y(3);
          -y(1)*y(3) - b*(1 - y(2)^2) ];
end


% EX5BC 
function res = ex5bc(ya,yb)
res = [ ya(1)
        ya(2)
        yb(2) - 1];
end


end
