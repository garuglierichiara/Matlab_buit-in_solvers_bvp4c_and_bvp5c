% EXAMPLE 2:
%This example shows how to change devault values for bvp4c, standard test
%problem for BVP codes

%Equation: y''+3py/(p+t^2)^2=0
%Boundary conditions;

function bvp_funcs=Example2()

bvp_funcs.ode = @ex2ode;
bvp_funcs.bc = @ex2bc;
bvp_funcs.exact = @ex2exact; 

%% LOCAL FUNCTIONS (SUBFUNCTIONS)

% EX2ODE 
function dydt = ex2ode(t,y)
p = 1e-5;
dydt = [ y(2)
        -3*p*y(1)/(p+t^2)^2];
end


%EX2BC: the solution should agree with the values of the analytical solution at both a and b.
function res = ex2bc(ya,yb) 
p = 1e-5;
yatb = 0.1/sqrt(p + 0.01);
yata = - yatb;
res = [ ya(1) - yata
        yb(1) - yatb ];
end

%ANALYTICAL SOLUTION:
function y_out = ex2exact(t)
    p = 1e-5;
    y_out = t ./ sqrt(p + t .^2); 
end

end