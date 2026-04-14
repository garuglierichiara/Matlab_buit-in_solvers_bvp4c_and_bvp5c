%EXERCISE: BRATU
%This equation arises in a model of spontaneous combustion and it's an
%example of bifurcation. Depending on the value of lambda there are two
%solutions, one or none.

% Bratu equation: y'' = -exp(y)    (lambda=1)
% Boundary Conditions: y(0)=0=y(1)


function bvp_funcs=ExerciseBratu()

bvp_funcs.ode = @bratuode;
bvp_funcs.init = @bratuinit;
bvp_funcs.bc = @bratubc;

%% LOCAL FUNCTIONS (SUBFUNCTIONS)

%EXBRATUODE
function dydx = bratuode(x,y)
dydx = [ y(2)         
         -exp(y(1)) ]; 
end

%EXBRATUINIT    
function v = bratuinit(x)
v = [0.1; 0];
end

%EXBRATUBC
function res = bratubc(ya,yb)
res = [ ya(1)  
        yb(1) ]; 
end

end