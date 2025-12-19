%EXERCISE UNSTEADY FLOW OF A GAS
%This exercise consider the unsteady flow of a gas through a semi-infinite
%porum medium initially filled with gas at uniform pressure

%   Equation: w'' = -w' * (2*z / sqrt(1 - alpha*w)) on [0, infinity] (we
%   use alpha=0.8)
%   Boundary conditions: w(0)=1, w(infinity)=0.
%   The problem is formulated for the computational domain [0, infinity_param]

function bvp_funcs = ExerciseGas()
alpha_param=0.8;
infinity_param=3;

bvp_funcs.ode = @(z,y) gasode(z,y, alpha_param, infinity_param);
bvp_funcs.bc = @(ya,yb) gasbc(ya,yb);

% Parameters 
bvp_funcs.alpha_param = alpha_param;
bvp_funcs.infinity_param = infinity_param;

% Initial guess setup for bvpinit
bvp_funcs.n_init = 5; 
bvp_funcs.y_init = [0.5 -0.5];
bvp_funcs.hasContinuation = false;

%% LOCAL FUNCTIONS (SUBFUNCTIONS)

%EXGASODE
function dydz = gasode(z, y, alpha_param, ~)
dydz = [  y(2)                                        
         -y(2) * 2 * z / sqrt(1 - alpha_param * y(1)) 
       ];

%EXGASBC
function res = gasbc(ya, yb)

res = [ ya(1) - 1    
        yb(1)        
      ];