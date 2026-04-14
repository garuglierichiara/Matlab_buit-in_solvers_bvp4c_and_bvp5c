 classdef bvp_app < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure             matlab.ui.Figure
        StatusTextArea       matlab.ui.control.TextArea
        StatusTextAreaLabel  matlab.ui.control.Label
        SolutionPanel        matlab.ui.container.Panel
        UITable              matlab.ui.control.Table
        UIAxes               matlab.ui.control.UIAxes
        BVPtosolvePanel      matlab.ui.container.Panel
        ProblemLabel         matlab.ui.control.Label
        SolverDropDown       matlab.ui.control.DropDown
        SolverLabel          matlab.ui.control.Label
        ExampleDropDown      matlab.ui.control.DropDown
        ExampleLabel         matlab.ui.control.Label
        SolveButton          matlab.ui.control.Button
    end

    % Properties to store BVP parameters: 
    properties (Access = private)
        % Define and initilize these parameters to read them also in the
        % following blocks
        a = 0; % Domain start
        b = 1; % Domain end
        isEigenvalueProblem = false % Flag for the presence of unknown parameters in the problem
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: ExampleDropDown
        function ExampleDropDownValueChanged(app, event)
            % Read the example selected by the user
            exampleName = app.ExampleDropDown.Value;
            
            % Control the value of 'example' to decide which BVP to load
            % and then solve
            switch exampleName
                
                case 'Ex1: System of 5 first order ODEs'
                    app.a = 0; 
                    app.b = 1; 
                    app.ProblemLabel.Text = {
                        '\textbf{BVP}: System of 5 first order ODEs';
                        ['$$\left\{ \begin{array}{l} ' ...
                         'u^{\prime} = 0.5 u (w-u)/v \\ ' ...
                          'v^{\prime} = -0.5 ( w-u) \\' ...
                          'w^{\prime} = (0.9 - 1000(w-y)-0.5w(w-u))/z \\' ...
                          'z^{\prime} = 0.5(w-u) \\' ...
                          'y^{\prime} = -100(y-w) \end{array} $$'];
                        ' \textit{Domain}: \ $[0, \ 1]$';
                        ' \textit{BCs}: \ $u(0) = v(0) = w(0) = 1$, \ $z(0) = -10$ and $y(1) = w(1).'
                    };

                    app.isEigenvalueProblem = false;
                    

                case 'Exercise: Bratu'
                    app.a = 0; 
                    app.b = 1; 
                    app.ProblemLabel.Text = {
                        '\textbf{BVP}: \ Bratu';
                        '$$ y^{\prime\prime} = -e^y $$';
                        ' \textit{Domain}: \ $[0, \ 1]';
                        '\textit{BCs}: $y(0)=0$, $y(1)=0$.';
                        '\textbf{Note}: It requires two initial guesses to find both the solutions.';
                    };

                    app.isEigenvalueProblem = false;


                case 'Ex2: Standard test problem'
                    app.a = -0.1; 
                    app.b = 0.1;
          
                    app.ProblemLabel.Text = {
                        '\textbf{BVP}:';
                        '$$ y^{\prime\prime}  = - 3py / (p + t^2)^2} $$';
                        '$p = 1e-5 $';
                        '\textit{Domain}: \ $[ -0.1, \ 0.1]$';
                        '\textit{Boundary conditions}: $y(-0.1)=-0.1/\sqrt{p+0.01}$, $y(0.1)=0.1/\sqrt{p+0.01}$';
                    };

                    app.isEigenvalueProblem = false;
                

                case 'Ex3: Mathieu''s equation'
                    app.a = 0;
                    app.b = pi;

                    app.ProblemLabel.Text = {
                        '\textbf{BVP}: \ Mathieu''s equation';
                        '$$ y^{\prime\prime} + (\lambda - 2q \cos(2x))y = 0$$';
                        '\textit{Parameter}: $q = 5$';
                        '\textit{Domain}: $[0, \ \pi]$';
                        '\textit{BCs}: $y^{\prime}(0)=0$, \quad $y^{\prime}(\pi)=0$, \quad $y(0)=1$';
                    };
                    app.isEigenvalueProblem = true;  


                case 'Exercise: Tubular Reactor with Axial Dispersion'
                    app.a = 0;
                    app.b = 1;

                    app.ProblemLabel.Text = {
                        '\textbf{BVP}: \ Tubular Reactor with Axial Dispersion';
                        '$$ y^{\prime\prime}  = Pe(y^{\prime}  - R y^n) $$';
                        '\textit{Parameters}: $Pe = 1$, $R = 2$, $n = 2$';
                        '\textit{Domain}: $[0, \ 1]$';
                        '\textit{BCs}: $y^{\prime}(0) = Pe(y(0) - 1)$, \quad $y^{\prime}(1) = 0$';
                    };
                    app.isEigenvalueProblem = false;            
                  
   
                case 'Ex4: BVP with periodic solution'       % Example of FREE BOUNDARY  problem
                    app.a = 0;          % Scaled interval in tau = t/T
                    app.b = 1; 

                    app.ProblemLabel.Text = {'\textbf{BVP}: \ Periodic solution with period $T$ unknown';
                                                ['$$\left\{ \begin{array}{l} ' ...
                                                'y_1^{\prime} = 3(y_1 + y_2 - \frac{1}{3} y_1^3 - 1.3) \\ ' ...
                                                'y_2^{\prime} = -\frac{1}{3}(y_1 - 0.7 + 0.8y_2) \end{array} $$'];
                                                '\textit{Domain}: \ $[ 0, \ T]$ \quad (solved on $[0, \ 1]$)'
                                                '\textit{BCs}: \ $y_1(0)=y_1(T)$, \quad  $y_2(0)=y_2(T)$';
                                                '\textbf{Note}: Additional BC to eliminate $y^{\prime}(0) \equiv 0$ and $T=0$:  \qquad $\frac{dy_{2}}{d\tau}(0) = 1 \quad ( \text{with} \ \tau = t/T)$ ';
                                                '\textbf{Note}: For \texttt{bvp5c}, the solution from \texttt{bvp4c}\ is used as the initial guess to ensure convergence.'
                                            };

                    app.isEigenvalueProblem = true;     % Unknown parameter T

                case 'Ex5: Falkner-Skan Flow'
                    app.a = 0;
                    app.b = 6;

                    app.ProblemLabel.Text = {'\textbf{BVP}: \ Falkner-Skan Equation';
                                             '$$ f^{\prime \prime \prime} + ff^{\prime \prime}+ \beta(1 - (f^{\prime})^2) = 0$$';
                                             '\textit{Parameter}: $\beta = 0.5$';
                                             '\textit{Domain}: $[0, \infty]$ \quad ($\eta \rightarrow \infty$ is approximated by $\eta=6$)';
                                             '\textit{BCs}: $f(0) = 0$, \quad $f^{\prime}(0) = 0$, \quad $f^{\prime}(6) = 1$';
                                             };
                    app.isEigenvalueProblem = false;

                case 'Exercise: Unsteady Gas Flow' 
                    bvp_funcs = ExerciseGas();
                    app.a = 0; 
                    app.b = bvp_funcs.infinity_param;
  
                    app.ProblemLabel.Text = {
                                            '\textbf{BVP}: \ Unsteady Gas Flow in Porous Medium';
                                            '$$ w^{\prime\prime} = -w^{\prime} \frac{2z}{\sqrt{1 - \alpha w}} $$';
                                            ['\textit{Parameter}: $\alpha = ' num2str(bvp_funcs.alpha_param) '$']; 
                                            ['\textit{Domain}: \ $[0, \ \infty]$ (solved on $[0, \ ' num2str(bvp_funcs.infinity_param) ']$)'];   
                                            '\textit{BCs}: $w(0)=1$, \ $w(\infty)=0$';
                                            };
                    app.isEigenvalueProblem = false;

                case 'Ex6: Porous Spherical Catalyst'
                    app.a = 0;
                    app.b = 1;
  
                    app.ProblemLabel.Text = {
                                            '\textbf{BVP}: \ Porous Spherical Catalyst (Singular)';
                                            '$$ y^{\prime \prime} + \frac{2}{x} y^{\prime} = \phi^2 y \exp \left( \frac{\gamma \beta(1 - y)}{1 + \beta(1 - y)} \right) $$';
                                            '\textit{Parameters}: $\phi=0.6$, \ $\gamma=40$, \ $\beta=0.2$'; 
                                            '\textit{Domain}: [0, 1]';
                                            '\textit{BCs}: $y^{\prime}(0) = 0$, \quad $y(1) = 1$';
                                            };

                    app.isEigenvalueProblem = false;
                                                           

                case 'Ex7: BVP with singular behavior at the origin'  
                    d = 0.1;
                    app.a = d; % Domain where to solve the Pb: [0.1, 16]
                    app.b = 16; 
 

                    app.ProblemLabel.Text = {'\textbf{BVP}: Solution with a singularity at the origin';
                                              '$ y^{\prime \prime} = \frac{y^3 - y^{\prime}}{2x}$';
                                                '\textit{Domain}: \ $[ 0, \ 16]$ \quad (solved on $[d, \ 16], \ d = 0.1$)'
                                                ['\textit{BCs}: $$  \begin{array}{l} y(d) &= 0.1 + \frac{p\sqrt{d}}{10} + \frac{d}{100}, \\ ' ...
                                                'y(16) &= \frac{1}{6}, \\ ' ...
                                                'y^{\prime}(d) &=  \frac{p}{20 \sqrt d} + \frac{1}{100} \end{array} $$'];
                                                '\textit{Unknown parameter}: $p = y(0)$.'
                                            };
                    app.isEigenvalueProblem = true;    % Unknown parameter p = y'(0)


                case 'Exercise: Michaelis - Menten' 
                    d = 0.001;
                    app.a = d;      % Domain where to solve the pb: [0.001, 1]
                    app.b = 1; 

                    app.ProblemLabel.Text = {'\textbf{BVP}: Michaelis-Menten (Singularity at the origin)';
                                            ['$$ y^{\prime \prime} + \frac{2}{x}y^{\prime} = \frac{y}{\epsilon(y+k)}$$'];
                                            ['\textit{Domain}: $[ 0, 1]$ \quad (solved on $[d, \ 1], \ d=0.001$)'];
                                            ['\textit{BCs}: $$  \begin{array}{l} y(d) &= p + \frac{1}{2}\frac{p}{3\epsilon(p + k)}d^2, \\ ' ...
                                             'y(1) &= 1, \\ ' ...
                                             'y^{\prime}(d) &=  \frac{p}{3\epsilon(p + k)}d \end{array} $$'];
                                            '\textit{Unknown parameter}: $p = y(0)$';
                                            '\textbf{Note}: Solved for $\epsilon = 0.1, \quad k=0.1$';
                                            };
                    app.isEigenvalueProblem = true;    % Unknown parameter p = y(0)

                case 'Ex8: Fluid Injection' 
                    app.a = 0;
                    app.b = 1;

                    app.ProblemLabel.Text = {'\textbf{BVP}: \ Fluid Injection Problem';
                                             '$ f^{\prime \prime \prime} - R[(f^{\prime})^2 - f f^{\prime \prime}] + R A = 0$';
                                             '$ h^{\prime \prime} + R f h^{\prime} + 1 = 0$';
                                             '$ \theta^{\prime \prime} + P f \theta^{\prime} = 0$';
                                             '\textit{Domain}: \ $[ 0, \ 1]$';
                                             '\textit{BCs}: \ 8 conditions total.';
                                             '\textit{Unknown parameter}: $A$.';
                                             '\textbf{Note}: Solved for $R=100$.';
                                            };
                    app.isEigenvalueProblem = true; % Unknown parameter A

                case 'Ex9: Three-Point BVP' 
                    app.a = 0;
                    app.b = 1;

                    app.ProblemLabel.Text = {'\textbf{BVP}: \ Three-Point Problem (Reformulated)';
                                             '$ v^{\prime} = (C-1)/n \quad \text{on } [0,1]$';
                                             '$ C^{\prime} = (vC - \min(x,1))/\eta \quad \text{on } [0,1]$';
                                             '\textit{Domain}: \ $[ 0, \ \lambda]$';
                                             '\textit{BCs}: \ $v(0)=0, C(\lambda)=1$.';
                                             '\textbf{Note}: Solved by continuation for $\kappa=2 \dots 5$.';
                                            };
                    app.isEigenvalueProblem = false; 

                otherwise
                    app.a = 0; 
                    app.b = 1; 
    
                    app.ProblemLabel.Text = 'BVP: Not specified';
            end
        end

        % Button pushed function: SolveButton
        function SolveButtonPushed(app, event)
            % Read and save the parameters of the problem:
            current_a = app.a;
            current_b = app.b;

            % Read the example and the solver to use:
            exampleName = app.ExampleDropDown.Value;
            solverChoice = app.SolverDropDown.Value;
            
            % Set default options for the solver:
            options = bvpset('stats','on','RelTol',1e-6,'AbsTol',1e-8);  % Create a structure with the tolerance for the solver, 'stats' 'on' includes all statistical data           

            % Choose solver function depending on user's choice
            solverFcn = @bvp4c;     % Set bvp4c as default solver
            if strcmp(solverChoice,'bvp5c')     % If the user chooses bvp5c, it changes the solver
                solverFcn = @bvp5c; 
            end

            % Plot of the solution (depending on the example)
            cla(app.UIAxes);                % Clear the plot

            % Reset the limit of the axis
            app.UIAxes.XLimMode = 'auto';
            app.UIAxes.YLimMode = 'auto';
            % Reset the title and the label at the axis:
            app.UIAxes.Title.String = '';  % Set the title as an empty string 
            app.UIAxes.XLabel.String = ''; % Set Xlabel as an empty string
            app.UIAxes.YLabel.String = ''; % Set Ylabel as an empty string
            legend(app.UIAxes,'off');      % Set off the legend

            hold(app.UIAxes, 'on');
            
            % Select the problem and impose the ODE, BC and domain 
            switch exampleName
                                   
                case 'Ex1: System of 5 first order ODEs'
                    % NEEDED EXTERNAL FILE: Example1()
                    bvp_funcs = Example1();         % bvp_funcs = structure data which contains the subfunctions of the BVP
                    problFunc = bvp_funcs.ode;      % Extract the ode function handle
                    bcFunc = bvp_funcs.bc;          % Extract the BCs function handle
                    initFunc  = bvp_funcs.init;     % Extract the function handle for the initial guess of the solution
                    

                    solinit = bvpinit(linspace(current_a, current_b, 5), initFunc);  
                    options = bvpset('stats','on','RelTol',1e-5);           % Sets solver options: enables statistics output and increases relative error tolerance to 1e-5 (from 1e-3).

                    % Create the structure for the initial guesses:
                    % It costructs an initial mesh with 5 points uniforml distributed and the initial guess for the solutio using ex1init in this mesh
                    try 
                        tstart = tic;               % Start timer
                        sol = solverFcn(problFunc, bcFunc, solinit, options);     % Solve the problem with the chosen solver
                        elapsed = toc(tstart);      % Stop the timer
                    catch ME
                        app.StatusTextArea.Value = ['Solver error: ' ME.message];
                        return;
                    end
                    
                    xx = sol.x;        % Take the solver mesh for plotting
                    yyNum = sol.y;     % Approximated solution at xx
                    
                    % Plot all the 5 components
                    componentNames = {'u', 'v', 'w', 'z (shifted)', 'y'};        % Define the names for the legend
                    
                    % Number of points that the solver has generated
                    meshPts = numel(sol.x);                 

                    % Residual (Maximum between the 5 components):
                    maxRes = app.ComputeMaxResidual(problFunc,sol);
                    yyNum(4,:) = yyNum(4,:) + 10;
                    plot(app.UIAxes, xx, yyNum,'LineWidth', 1.5);                            
                
                    legend(app.UIAxes,componentNames,'Location','best')                
                    title(app.UIAxes, ['Solution Components (System) — ' solverChoice]);
                    grid(app.UIAxes,'on')

                    % Update title columns
                    app.UITable.ColumnName = {'Quantity', 'Value'};

                    % Update table 
                    data = {'Mesh points', char(sprintf("%.0f", meshPts));'Max residual', char(sprintf("%.4e", maxRes));'Time (s)', char(sprintf("%.4f", elapsed))};
                    app.UITable.Data = data;
                    
                    % Update status label
                    app.StatusTextArea.Value = sprintf('Problem solved with %s:\nmesh points = %d \ntime = %.4g s',solverChoice, meshPts, elapsed);
                    
                    return; % <--- to skip the standard procedure

                case 'Exercise: Bratu'
                    % NEEDED EXTERNAL FILE: ExerciseBratu()
                    % SPECIAL CASE: 2 SOLUTIONS
                    bvp_funcs = ExerciseBratu(); 
                    problFunc = bvp_funcs.ode;
                    bcFunc = bvp_funcs.bc;
                    
                    % Solution A (Superior)
                    solinit_A = bvpinit(linspace(current_a, current_b, 5), bvp_funcs.init); 
                    % Solution B (Inferior)
                    solinit_B = bvpinit(linspace(current_a, current_b, 5), [3 0]);   

                    try
                        tstart_A = tic;                                         % Start timer for solution A
                        sol_A = solverFcn(problFunc, bcFunc, solinit_A, options);   % Apply solver 
                        elapsed_A = toc(tstart_A);                              % Stop the timer 
                    catch ME
                        app.StatusTextArea.Value = ['Solver error: ' ME.message];
                        return;
                    end
                    
                    try
                        tstart_B = tic;
                        sol_B = solverFcn(problFunc, bcFunc, solinit_B, options);
                        elapsed_B = toc(tstart_B);
                    catch ME
                        app.StatusTextArea.Value = ['Solver error: ' ME.message];
                        return;
                    end
                    
                    % PLOT AND STATISTICS FOR BRATU
                    elapsed = elapsed_A + elapsed_B;            % Compute the total time to construct both solutions
                    meshPts = numel(sol_A.x) + numel(sol_B.x);  % Compute total number of points in the mesh
                    
                    % Residual
                    maxRes_A = app.ComputeMaxResidual(problFunc, sol_A);
                    maxRes_B = app.ComputeMaxResidual(problFunc, sol_B);

                    xxA = sol_A.x;    % Solver mesh
                    xxB = sol_B.x;
                    yyNum_A = sol_A.y;  % Approximated solution A
                    yyNum_B = sol_B.y;  % Approximated solution B
                    
                    % Clear the plot area
                    cla(app.UIAxes);    
                    % Plot solution A
                    plot(app.UIAxes, xxA, yyNum_A(1,:), 'LineWidth', 1.8, 'DisplayName', 'Superior solution');
                    hold(app.UIAxes, 'on');
                    % Plot solution B
                    plot(app.UIAxes, xxB, yyNum_B(1,:), '--', 'LineWidth', 1.2, 'DisplayName', 'Inferior solution');
                    hold(app.UIAxes, 'off');
                   
                    legend(app.UIAxes, 'show', 'Location', 'best');
                    title(app.UIAxes, ['Solutions for Bratu''s Equation — ' solverChoice])
                    grid(app.UIAxes,'on');
                    
                    % Update title columns
                    app.UITable.ColumnName = {'Quantity', 'Value'};

                    % Update the table 
                    data = {'Total mesh points', char(sprintf("%.0f", meshPts)); 'Max residual sol A',char(sprintf("%.4e", maxRes_A)); 'Max residual sol B',char(sprintf("%.4e", maxRes_B));'Time (s)', char(sprintf("%.4f", elapsed))};

                    % Print the table
                    app.UITable.Data = data;
                    
                    % Update status label
                    app.StatusTextArea.Value = sprintf('Solved with %s:\nmesh points = %d \ntime = %.4g s',solverChoice, meshPts, elapsed);            
                     
                    return;      
                    

                case 'Ex2: Standard test problem'
                    % NEEDED EXTERNAL FILE: Example2()
                    bvp_funcs = Example2();
                    problFunc = bvp_funcs.ode;
                    bcFunc = bvp_funcs.bc;
                    exactSol = bvp_funcs.exact;   
                                       
                    % Define tolerance levels for continuation
                    RelTol_values = [1e-3, 1e-4]; 
                    
                    solinit = bvpinit(linspace(current_a, current_b, 10), [0; 10]); 
                    
                    tstart_total = tic; % Start total timer
                    totalMeshPts = 0;
                    resultsTable = table('Size', [0 5], 'VariableTypes', {'string','double','double','double','double'}, 'VariableNames', {'RelTol', 'Mesh Points', 'Max Error', 'Max Residual', 'Time (s)'});
                    
                    % Clear the plot area
                    cla(app.UIAxes);
                    hold(app.UIAxes, 'on');
                    colors = {'b', 'r'}; % Colors for plotting the two solutions
                    
               
                    % Continuation loop
                    for k = 1:length(RelTol_values)
                        current_RelTol = RelTol_values(k);
                        
                        % Update solver options, setting AbsTol to default 1e-8
                        options_step = bvpset('RelTol', current_RelTol);
                        
                        try
                            step_tstart = tic;
                            sol = solverFcn(problFunc, bcFunc, solinit, options_step); 
                            elapsed_step = toc(step_tstart);
                        catch ME
                            app.StatusTextArea.Value = ['Solver error: ' ME.message];
                            return;
                        end
                            
                        % Save the current solution as the initial guess for the next iteration 
                        solinit = sol; 
                            
                        % Statistics calculation
                        meshPts = numel(sol.x);
                        totalMeshPts = totalMeshPts + meshPts;
                            
                        % Evaluate error against the exact solution
                        xx = sol.x; 
                        yyNum = sol.y; 
                        yNum_y = yyNum(1,:); % First component y(t)
                        yExact = exactSol(xx);
                        maxErr = max(abs(yNum_y - yExact)); 
                            
                        % Residual
                        maxRes = app.ComputeMaxResidual(problFunc, sol);

                        % Plot the solution y(t) 
                        plot(app.UIAxes, xx, yNum_y, 'Color', colors{k}, 'LineWidth', 1.5,'DisplayName', ['Rel Tol = ' num2str(current_RelTol)]);                                                                              
                                                
                        % Update the table
                        resultsTable(end+1,:) = {['RelTol = ' num2str(current_RelTol)], meshPts, maxErr, maxRes, elapsed_step};
                    end
                    
                    totalElapsed = toc(tstart_total); 
                    
                    % Plot Exact Solution for Reference
                    plot(app.UIAxes, xx, yExact, 'Color', 'k', 'LineStyle', ':', 'LineWidth', 1.0, 'DisplayName', 'Exact Solution');                    
                    hold(app.UIAxes, 'off');
                    
                    % Final Visualization Setup
                    legend(app.UIAxes, 'show', 'Location', 'best');
                    title(app.UIAxes, ['Boundary Layer Problem: Continuation on RelTol — ' solverChoice]);
                    xlabel(app.UIAxes, 't');
                    ylabel(app.UIAxes, 'y(t)');
                    grid(app.UIAxes,'on');
                    
                    tableData = table2cell(resultsTable);
                    
                    % Loop through the first column (RelTol) and convert explicitly to char array
                    % This is necessary because the UI component might not accept modern 'string' type.
                    for i = 1:size(tableData, 1)
                        tableData{i, 1} = char(tableData{i, 1});              % Rel Tol
                        tableData{i, 2} = sprintf('%.0f', tableData{i, 2});   % Mesh Points  
                        tableData{i, 3} = sprintf('%.4e', tableData{i, 3});   % Max Error
                        tableData{i, 4} = sprintf('%.4e', tableData{i, 4});   % Max Res
                        tableData{i, 5} = sprintf('%.4f', tableData{i, 5});   % Time                  
                    
                    end
                    
                    % Update title columns
                    app.UITable.ColumnName = resultsTable.Properties.VariableNames;

                    % Update title columns
                    app.UITable.Data = tableData;
                    
                    % Update status label
                    app.StatusTextArea.Value = sprintf('Problem solved with %s:\ntotal mesh points: %d \ntotal time: %.4g s', solverChoice, totalMeshPts, totalElapsed); 

                    return; 

                case 'Ex3: Mathieu''s equation'
                    % NEEDED EXTERNAL FILE: Example3()
                    bvp_funcs = Example3();
                    problFunc= bvp_funcs.ode; 
                    bcFunc = bvp_funcs.bc; 
                    
                    % Unknown parameter
                    lambda_guess = 15;          % initial guess for the parameter lambda

                    solinit = bvpinit(linspace(current_a, current_b, 10), bvp_funcs.init, lambda_guess);


                case 'Exercise: Tubular Reactor with Axial Dispersion'
                    % NEEDED EXTERNAL FILE: Exercise_trbvp()
                    bvp_funcs = Exercise_trbvp();
                    problFunc = bvp_funcs.ode; 
                    bcFunc = bvp_funcs.bc; 

                    solinit = bvpinit(linspace(current_a,current_b, 5), [0.5 0]);


                case 'Ex4: BVP with periodic solution'
                    % NEEDED EXTERNAL FILE: Example4()
                    bvp_funcs = Example4();         
                    problFunc = bvp_funcs.ode; 
                    bcFunc = bvp_funcs.bc; 
                    
                    % Parameter T
                    T_guess = 2*pi;

                    solinit = bvpinit(linspace(current_a, current_b, 5), bvp_funcs.init, T_guess);
                    

                    try 
                        % Special case when we solve Example 4 with bvp5c (to converge):
                        if strcmp(solverChoice,'bvp5c')   
                            tstart = tic;
                            % 1 step: We solve the problem with bvp4c to get a good initial guess:                   
                            sol_4c = bvp4c(problFunc, bcFunc, solinit, options);
                            % Save the initial guess function as a function handle to use it in bvpinit
                            y_sol4c = @(x) deval(sol_4c, x);
                            % Create a new solinit structure which uses the new initial guess                         % sol_4c only on the 5 points of mesh_initial
                            solinit = bvpinit(linspace(current_a, current_b, 5), y_sol4c, sol_4c.parameters);
                            % 2 step: Solve bvp5c with sol4 as initial guess  
                            sol = bvp5c(problFunc, bcFunc, solinit, options);
                            elapsed = toc(tstart); 
                        else    % Classical solver (bvp4c)
                            tstart = tic;       % Start timer
                            sol = solverFcn(problFunc, bcFunc, solinit, options);     % Solve the problem with the chosen solver
                            elapsed = toc(tstart);      % Stop the times
                        end
                    catch ME
                        app.StatusTextArea.Value = ['Solver error: ' ME.message];
                        return;
                    end
                
                    % Prepare plotting
                    xx = sol.x;
                    yyNum = sol.y;         
                    
                    yNum = yyNum(1,:);      % Plot the 1st component 
                    
                    T = sol.parameters;
                    if isempty(T) || T<= 0
                        % If the period is not valid
                        app.StatusTextArea.Value = 'Error: The solver doesn''t find a valid period T > 0.';
                        return;
                    end

                    % Compute metrics
                    meshPts = numel(sol.x);                
                    
                    % Residual
                    maxRes = app.ComputeMaxResidual(problFunc, sol);

                    % Clear the plot
                    cla(app.UIAxes);        
                    plot(app.UIAxes,T*xx,yNum,'LineWidth',1.5);                   
                
                    plot(app.UIAxes,T*solinit.x,solinit.y(1,:),'o');                         % Plot the initial guess
                    xlim(app.UIAxes, [0 T]);   % To plot the solution in a period
                    hold(app.UIAxes,'off') 

                    title(app.UIAxes,['Solution y(t) — ' solverChoice])
                    legend(app.UIAxes,{solverChoice, 'Initial guess'}); 
                    xlabel(app.UIAxes, 't');
                    ylabel(app.UIAxes, 'y(t)')
                    grid(app.UIAxes,'on')

                    % Update title columns
                    app.UITable.ColumnName = {'Quantity', 'Value'};

                    % Update details table
                    data = {'Mesh points', char(sprintf("%.0f", meshPts)); 'Max residual', char(sprintf("%.4e",maxRes));'Time (s)', char(sprintf("%.4f", elapsed))};
                    app.UITable.Data = data;

                    % Update status
                    app.StatusTextArea.Value = sprintf('Problem solved with %s:\nmesh points = %d \ntime = %.4g s \nperiod T = %.2f',solverChoice, meshPts, elapsed,T);
                     
                    return;

                case 'Ex5: Falkner-Skan Flow'
                    % NEEDED EXTERNAL FILE: Example5()
                    bvp_funcs = Example5();
                    problFunc = bvp_funcs.ode;
                    bcFunc = bvp_funcs.bc;
                    
                    % I want to solve the ODE in different intervals
                    infinity = 3;
                    maxinfinity = 6;
                    solinit = bvpinit(linspace(current_a,infinity,5),[0; 0; 1]);
                    
                    % Solution in the interval [0,3]
                    tstart = tic;
                    sol = solverFcn(problFunc,bcFunc,solinit, options);
                    elapsed = toc(tstart);
                    meshPts = numel(sol.x);  % Compute total number of points in the mesh
                    maxRes = app.ComputeMaxResidual(problFunc, sol);
                    
                    % Plot the solution in [0,3]
                    xx = sol.x;
                    yy = sol.y;
                    cla(app.UIAxes);
                    plot(app.UIAxes, xx, yy(2,:), 'LineWidth', 1.8, 'DisplayName', 'Solution in [0,3]');
                    hold(app.UIAxes, 'on');                    

                    % Create an empty table
                    resultsTable = table('Size', [0 4],'VariableTypes', {'string','double','double','double'},'VariableNames', {'Interval','Mesh pts','Max Residual','Time (s)'});
                    resultsTable(end+1,:) = {'[0, 3]',meshPts, maxRes, elapsed};

                    statusText = sprintf('Solution with %s:\n', solverChoice); 
                    statusText = sprintf('%s Interval [0, 3]: mesh points = %d \ntime = %.4g s \n', statusText, meshPts, elapsed);

         
                    % We solve the problem on progressively larger intervals
                    for b_new = infinity+1 : maxinfinity

                        solinit = bvpinit(sol,[current_a, b_new]); % Extend solution to new interval
                        
                        try
                            tstart = tic; 
                            sol = solverFcn(problFunc,bcFunc,solinit, options);
                            elapsed = toc(tstart);
                        catch ME
                            app.StatusTextArea.Value = ['Solver error: ' ME.message];
                            return;
                        end

                        meshPts = numel(sol.x);  % Compute total number of points in the mesh

                        % Residual
                        maxRes = app.ComputeMaxResidual(problFunc, sol);

                        %Status label
                        statusText = sprintf('%s Interval [0, %d]: mesh points = %d \ntime = %.4g s \n', statusText, b_new, meshPts, elapsed);

                        xx = sol.x;
                        yy = sol.y;                 

                        % Updated plot
                        plot(app.UIAxes, xx, yy(2,:), 'LineWidth', 1.4, 'DisplayName', sprintf('Solution in [0,%g]', b_new));
                        drawnow;

                        % Update details table
                        resultsTable(end+1,:) = {sprintf('[0, %d]', b_new), meshPts, maxRes, elapsed};
                        fprintf('Solution extended to [0, %g]: f''''(0) = %.5f\n', b_new, yy(3,1));
                    end
                    
                    fprintf('\n');
                    fprintf('Cebeci & Keller report f''''(0) = 0.92768.\n')
                    legend(app.UIAxes, 'show', 'Location', 'best');
                    title(app.UIAxes, ['Falkner–Skan Equation (β = 0.5) —' solverChoice])
                    grid(app.UIAxes, 'on');
                    
                    % Update details table
                    app.UITable.ColumnName = resultsTable.Properties.VariableNames; 
                    app.UITable.Data = resultsTable; 

                    % Update status
                    app.StatusTextArea.Value = splitlines(statusText);

                    return;
      
                case 'Exercise: Unsteady Gas Flow' 
                    bvp_funcs = ExerciseGas();
                    problFunc = bvp_funcs.ode; 
                    bcFunc = bvp_funcs.bc;

                    % Initial guess setup (using params from Example8.m)
                    mesh_initial = linspace(current_a, current_b, bvp_funcs.n_init);
                    solinit = bvpinit(mesh_initial, bvp_funcs.y_init);
                    

                case 'Ex6: Porous Spherical Catalyst'
                    % NEEDED EXTERNAL FILE: Example6()
                    bvp_funcs = Example6();
                    problFunc = bvp_funcs.ode; 
                    bcFunc = bvp_funcs.bc; 
                    guess  = [1; 0.5; 0];
                    others = [0.9070; 0.3639; 0.0001];      % Values reported by Kubicek et alia                    
                    
                    statusText = sprintf('Solved with %s (3 solutions):\n', solverChoice);

                    % Create an empty table
                    resultsTable = table('Size', [0 3],'VariableTypes', {'double','double','double'},'VariableNames', {'Mesh points','Max residual','Time (s)'});
                    
                    % Clear the plot
                    cla(app.UIAxes);
                    hold(app.UIAxes,'on');
                    fprintf('I compare the solutions: \n')

                    for index = 1:3

                        solinit = bvpinit(linspace(current_a, current_b,5), [guess(index) 0]);  %initial guess for the solution
                        
                        try
                            tstart = tic;     
                            sol = solverFcn(problFunc,bcFunc,solinit,options);   
                            elapsed = toc(tstart);
                        catch ME
                            app.StatusTextArea.Value = ['Solver error: ' ME.message];
                            return;
                        end

                        meshPts = numel(sol.x); 
                        xx = sol.x;

                        % Residual
                        maxRes = app.ComputeMaxResidual(problFunc, sol);

                        %Status label
                        statusText = sprintf('% s sol %d: mesh points = %d \ntime = %.4g s \n', statusText, index, meshPts, elapsed);

                        % Evaluate in xx the solution
                        yyNum = sol.y;                 
                        
                        % Plot the solution 
                        plot(app.UIAxes, xx, yyNum(1,:),'LineWidth', 1.8, 'DisplayName',sprintf('Solution %d',index));

                        % Update the table
                        resultsTable(end+1,:) = {meshPts, maxRes, elapsed};                     
                                       
                        fprintf('      %6.4f       %6.4f\n',sol.y(1,1),others(index))
                    end

                    legend(app.UIAxes, 'show', 'Location', 'best');
                    title(app.UIAxes, ['Solutions for Porous Spherical Catalyst''s Equation — ' solverChoice])
                    grid(app.UIAxes,'on');
                    
                    % Update details table
                    app.UITable.ColumnName = resultsTable.Properties.VariableNames; 
                    app.UITable.Data = resultsTable; 

                    % Update status
                    app.StatusTextArea.Value = splitlines(statusText);

                return;
                   
                case 'Ex7: BVP with singular behavior at the origin'
                    bvp_funcs = Example7();  
                    problFunc= bvp_funcs.ode; 
                    bcFunc = bvp_funcs.bc; 

                    p_guess = 0.2; % Initial guess for the unknown parameter p = y'(0)   
                    solinit = bvpinit(linspace(current_a, current_b, 5), [1; 1], p_guess);
                    
                    try 
                        tstart = tic;       
                        sol = solverFcn(problFunc, bcFunc, solinit, options);     
                        elapsed = toc(tstart);     
                    catch ME
                        app.StatusTextArea.Value = ['Solver error: ' ME.message];
                        return;
                    end
                                           
                    % Augment the solution array with the values y(0) = 0.1, y'(0) = p to get a solution on [0, 16].
                    % In this case we use the mesh for plotting the solution and adjust the singular behavior:
                    xx = [0 sol.x];
                    yyNum = [[0.1; sol.parameters] sol.y]; 
                    yNum1 = yyNum(1,:);      % Plot the 1st component 
                    yNum2 = yyNum(2,:);      % Plot the 2nd component = 2nd derivative
                    
                    % Compute metrics
                    meshPts = numel(sol.x);                                 
                                           
                    % Residual
                    maxRes = app.ComputeMaxResidual(problFunc, sol);

                    % Clear the plot
                    cla(app.UIAxes);        
                    plot(app.UIAxes,xx,yNum1,'LineWidth',1.5);
                    hold(app.UIAxes,'on') 
                    plot(app.UIAxes,xx,yNum2,'r','LineWidth',1.5);                                       
                   
                    legend(app.UIAxes,{[solverChoice, ' - y']; [solverChoice, ' - dy/dx']},'Location','best');
                    xlabel(app.UIAxes, 'x');
                    axis(app.UIAxes,[-1 16 0 0.18])
                    
                    hold(app.UIAxes,'off') 
                    title(app.UIAxes,['Solution y(x) — ' solverChoice])
                    grid(app.UIAxes,'on')

                    % Update title columns
                    app.UITable.ColumnName = {'Quantity', 'Value'};

                    % Update details table
                    data = {'Mesh points', char(sprintf("%.0f", meshPts)); 'Max residual', char(sprintf("%.4e", maxRes));'Time (s)', char(sprintf("%.4f", elapsed))};
                    app.UITable.Data = data;

                    % Update status
                    app.StatusTextArea.Value= sprintf('Problem solved with %s :\nmesh points = %d \ntime = %.4g s \np = %.4g',solverChoice, meshPts, elapsed, sol.parameters);
                
                    return;

                case 'Exercise: Michaelis - Menten'
                    bvp_funcs = ExerciseMichaelisMenten();                    
                    problFunc = bvp_funcs.ode; 
                    bcFunc = bvp_funcs.bc;

                    p_guess = 0.01; % Initial guess for the unknown parameter p = y'(0)                    
                    d = 0.001;
                    solinit = bvpinit(linspace(current_a, current_b, 5), [d 0], p_guess);
   
                    try 
                        tstart = tic;      
                        sol = solverFcn(problFunc, bcFunc, solinit, options);     
                        elapsed = toc(tstart);      
                    catch ME
                        app.StatusTextArea.Value = ['Solver error: ' ME.message];
                        return;
                    end
                                        
                    % Augment the solution array with the values y(0) = p, y'(0) = 0
                    p = sol.parameters; 
                    xx = [0 sol.x];
                    yyNum = [[p; 0] sol.y];
                
                    yNum = yyNum(1,:);      % Plot the 1st componen                
                    
                    % Compute metrics
                    meshPts = numel(sol.x);                

                    % Residual
                    maxRes = app.ComputeMaxResidual(problFunc, sol);
                    
                    % Clear th plot
                    cla(app.UIAxes);        
                    plot(app.UIAxes,xx,yNum,'LineWidth',1.5);                  
                    
                    hold(app.UIAxes,'off') 
                    title(app.UIAxes,['Solution y(x) — ' solverChoice])
                    legend(app.UIAxes,{solverChoice},'Location','best');
                    grid(app.UIAxes,'on')

                    % Update title columns
                    app.UITable.ColumnName = {'Quantity', 'Value'};

                    % Update details table
                    data = {'Mesh points', char(sprintf("%.0f", meshPts));'Max residual', char(sprintf("%.4e",maxRes)); 'Time (s)', char(sprintf("%.4f", elapsed))};
                    app.UITable.Data = data;

                    % Update status
                    app.StatusTextArea.Value= sprintf('Problem solved with %s :\nmesh points = %d \ntime = %.4g s \np = %.4g',solverChoice, meshPts, elapsed, p);
                
                    return;

                case 'Ex8: Fluid Injection' 
                    bvp_funcs = Example8(); 
                    ode_original = bvp_funcs.ode; 
                    bc_original = bvp_funcs.bc;
                    
                    R_values = [100, 1000, 10000]; % Values of R for the continuation procedure
                    A_guess_init = 1; 
                    
                    solinit = bvpinit(linspace(current_a, current_b, 10), ones(7,1), A_guess_init);
                    
                    % Initialization
                    tstart = tic; 
                    totalMeshPts = 0;
                    results = table('Size', [0 5], 'VariableTypes', {'double','double','double','double','double'}, 'VariableNames', {'R', 'Parameter A', 'Mesh Points', 'Max residual','Time (s)'});
                    
                    % Clear the plot
                    cla(app.UIAxes);
                    hold(app.UIAxes, 'on');
                    colors = lines(length(R_values)); 
                    
                    % Continuation loop on R
                    for k = 1:length(R_values)
                        R_current = R_values(k);
                        
                        % Function handles for the different values of R
                        problFunc = @(x,y,A) ode_original(x,y,A,R_current);
                        bcFunc = @(ya,yb,A) bc_original(ya,yb,A,R_current);
                        
                        try
                            step_tstart = tic;
                            % Solves the problem with R_current, using the previous solution as initial guess
                            sol = solverFcn(problFunc, bcFunc, solinit, options); 
                            elapsed_step = toc(step_tstart);
                        catch ME
                            app.StatusTextArea.Value = ['Solver error: ' ME.message];
                            return;
                        end    
                            
                        % Updates the guess for the next R
                        solinit = sol; 
                        solinit.parameters = sol.parameters; % Uses the parameter A found
                            
                        % Collect data and statistics
                        parameter_A = sol.parameters;
                        meshPts = numel(sol.x);
                        totalMeshPts = totalMeshPts + meshPts;
                            
                        % Residual
                        maxRes = app.ComputeMaxResidual(problFunc, sol);

                        % Updates the table
                        results(end+1,:) = {R_current, parameter_A, meshPts, maxRes, elapsed_step};
                                                        
                        % Plot of f'(x)
                        xx = sol.x;
                        yyNum = sol.y;
                        yNum_fp = yyNum(2,:); % f'(x) is the second component (y(2))
                            
                        plot(app.UIAxes, xx, yNum_fp, 'Color', colors(k,:), 'LineWidth', 1.5,'DisplayName', ['R = ' num2str(R_current) ' (A = ' num2str(parameter_A, '%.4f') ')']);
                           
                    end
                    
                    totalElapsed = toc(tstart); % Total time
                    hold(app.UIAxes, 'off');
                    
                    % Final visualization
                    legend(app.UIAxes, 'show', 'Location', 'best');
                    title(app.UIAxes, ['Solution f''(x) via Continuation on R — ' solverChoice]);
                    xlabel(app.UIAxes, 'x');
                    ylabel(app.UIAxes, 'f'' (x)');
                    grid(app.UIAxes,'on');
                    
                    app.UITable.ColumnName = results.Properties.VariableNames;

                    tableData = table2cell(results);

                    % Loop through the first column (RelTol) and convert explicitly to char array
                    % This is necessary because the UI component might not accept modern 'string' type.
                    for i = 1:size(tableData, 1)
                        tableData{i, 1} = sprintf('%.0f', tableData{i, 1});    % R
                        tableData{i, 2} = sprintf('%.4f', tableData{i, 2});    % A
                        tableData{i, 3} = sprintf('%.0f', tableData{i, 3});   % Mesh Points  
                        tableData{i, 4} = sprintf('%.4e', tableData{i, 4});   % Max residual
                        tableData{i, 5} = sprintf('%.4f', tableData{i, 5});   % Time
                    
                    
                    end

                    % % Updates UITable
                    % app.UITable.ColumnName = results.Properties.VariableNames;
                    app.UITable.Data = tableData;
                    
                    % Update status
                    statusText = sprintf('Problem solved with %s:\ntotal mesh points: %d \ntotal time: %.4g s', solverChoice, totalMeshPts,totalElapsed);
                    app.StatusTextArea.Value = statusText;
                    
                    return;


                case 'Ex9: Three-Point BVP'
                    bvp_funcs = Example9(); 
                    
                    % Extract the parameters from the structure
                    n = bvp_funcs.n_param;
                    lambda = bvp_funcs.lambda_param;                    
                    
                    % Initial guess for the first kappa (k=2)
                    solinit = bvpinit(linspace(current_a, current_b, 5),[1 1 1 1]); 
                    
                    tstart = tic; % Start timer
                    totalMeshPts = 0;
                    all_x = {};
                    all_y_v = {};
                    all_y_c = {};

                    maxResall = 0;
                                        
                    % Continuation loop for kappa = 2, 3, 4, 5
                    for kappa = 2:5 
                        eta = lambda^2/(n*kappa^2);
                       
                        problFunc = @(x,y) bvp_funcs.ode(x,y,n,lambda,eta);
                        bcFunc = @(ya,yb) bvp_funcs.bc(ya,yb,n,lambda,eta);

                        try
                            sol = solverFcn(problFunc, bcFunc, solinit, options); 
                        catch ME
                            app.StatusTextArea.Value = ['Solver error: ' ME.message];
                            return;
                        end  

                        % Update guess for the next iteration
                        solinit = sol; 
                        totalMeshPts = totalMeshPts + numel(sol.x);

                        maxRes_k = app.ComputeMaxResidual(problFunc, sol);
                        maxResall = max(maxResall, maxRes_k);
                        
                        % Compute and store results for plotting
                        x_plot = [sol.x sol.x*(lambda-1)+1]; % Undo the change of variable for the second interval
                        y_v = [sol.y(1,:) sol.y(3,:)]; % v(x) = y1 on [0,1], y3 on [1,lambda]
                        y_c = [sol.y(2,:) sol.y(4,:)]; % C(x) = y2 on [0,1], y4 on [1,lambda]
                        
                        all_x{kappa-1} = x_plot;
                        all_y_v{kappa-1} = y_v;
                        all_y_c{kappa-1} = y_c;
                        
                        % Print metrics 
                        K2 = lambda*sinh(kappa/lambda)/(kappa*cosh(kappa));
                        approx_os = 1/(1 - K2);
                        computed_os = 1/sol.y(3,end); % Os = 1/v(lambda) = 1/y3(1)
                        fprintf('  %2i    %10.3f    %10.3f \n',kappa,computed_os,approx_os);
                    end
                    
                    elapsed = toc(tstart); % Stop timer
                    
                    % Clear the plot
                    cla(app.UIAxes);                        
                    colors = {'k', 'r', 'b', 'g'};
                    
                    % Plot V(x) and C(x) for all kappa
                    for k_idx = 1:4
                        kappa_val = k_idx + 1;
                        
                        % Plot V(x) (linea solida: y1 e y3)
                        plot(app.UIAxes, all_x{k_idx}, all_y_v{k_idx}, 'Color', colors{k_idx}, 'LineStyle', '-', 'LineWidth', 1.2, 'DisplayName', ['v(x), \kappa=' num2str(kappa_val)]);
                        hold(app.UIAxes, 'on');
                        
                        % Plot C(x) (linea tratteggiata: y2 e y4)
                        plot(app.UIAxes, all_x{k_idx}, all_y_c{k_idx}, 'Color', colors{k_idx}, 'LineStyle', '--', 'LineWidth', 1.2, 'DisplayName', ['C(x), \kappa=' num2str(kappa_val)]);
                    end
                    
                    hold(app.UIAxes, 'off');
                    
                    legend(app.UIAxes, 'show', 'Location', 'best');
                    title(app.UIAxes, ['v(x) and C(x) Solutions for Three-Point BVP — ' solverChoice])
                    xlabel(app.UIAxes, 'x')
                    ylabel(app.UIAxes, 'v(x) and C(x)') 
                    grid(app.UIAxes,'on');
                    
                    % Update title columns
                    app.UITable.ColumnName = {'Quantity', 'Value'};

                    % Update the table with cumulative data
                    data = {'Mesh points', char(sprintf("%.0f", totalMeshPts));'Max residual', char(sprintf("%.4e",maxResall));'Time (s)', char(sprintf("%.4f", elapsed))};
                    app.UITable.Data = data;

                    % Update status
                    app.StatusTextArea.Value = sprintf('Example 9 solved via continuation (k=2 to 5) with %s:\nTotal mesh points = %d \ntime = %.4g s',solverChoice, totalMeshPts, elapsed);
                    
                    return; 

                otherwise
                    uialert(app.UIFigure,'Example unrecognized','Error');
                    return;
                  
            end
                
%% SOLVER
            % Run solver and time

            try 
                tstart = tic;       % Start timer
                sol = solverFcn(problFunc, bcFunc, solinit, options);     % Solve the problem with the chosen solver
                elapsed = toc(tstart);      % Stop the times
            catch ME
                app.StatusTextArea.Value = ['Solver error: ' ME.message];
                return;
            end


            
            % Prepare plotting
            xx = sol.x;         % Selecting the mesh
            yyNum = sol.y;      % Selecting the approximate solution
            
            yNum = yyNum(1,:);      % Selecting the 1st component

            % Compute metrics
            meshPts = numel(sol.x);                 % Number of points that the solver has generated

            % Residual
            maxRes = app.ComputeMaxResidual(problFunc, sol); 

            % Clear the plot
            cla(app.UIAxes);        
            plot(app.UIAxes,xx,yNum,'LineWidth',1.5);                   % Plot the numerical solution
            
            hold(app.UIAxes,'off') 
            title(app.UIAxes,['Solution y(x) — ' solverChoice])
            legend(app.UIAxes,{solverChoice},'Location','best');
            grid(app.UIAxes,'on')

            % Update title columns
            app.UITable.ColumnName = {'Quantity', 'Value'};

            % Update details table
            data = {'Mesh points', char(sprintf("%.0f", meshPts));'Max residual', char(sprintf("%.4e",maxRes)); 'Time (s)', char(sprintf("%.4f", elapsed))};
            app.UITable.Data = data;

            % Update status
            if isfield(sol,'parameters')
                par=sol.parameters;
                app.StatusTextArea.Value = sprintf('Problem solved with %s :\nmesh points = %d \ntime = %.4g s \nparameter = %.4g',solverChoice, meshPts, elapsed,par); 
            else
                app.StatusTextArea.Value= sprintf('Problem solved with %s :\nmesh points = %d \ntime = %.4g s',solverChoice, meshPts, elapsed);       
            end

        end       
        

        
        % We create a function to compute the residual

        function [maxRes] = ComputeMaxResidual(app, problFunc, sol)
            % Function that computes the infinity norm of the residual 
            % r = S' - f(x,S,param) on the mesh points of the solver

            x_mesh = sol.x;             % Mesh nodes
            [y, yp] = deval(sol,x_mesh);     % y(xi) and y'(xi)
                                        % y and yp are matrices
            
            % Pre allocate the residual matrix
            res = zeros(size(y));

            hasParam = isfield(sol,'parameters');   % Flag variable = if we have unknown parameters
            narg = nargin(problFunc);               % Number of arguments in input to the function of the ODE
            
            for k = 1:length(x_mesh)
                if hasParam && narg>=3    
                    p = sol.parameters;
                    fk = problFunc(x_mesh(k), y(:,k),p);
                    res(:,k) = yp(:,k) - fk;
              
                else
                
                    fk = problFunc(x_mesh(k), y(:,k));
                end

                res(:,k) = yp(:,k) - fk;
                
            end

        % Infinity norm of the residual
        maxRes = max(abs(res), [], 'all');      % Take the maximum between all the elements of the matrix

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 845 514];
            app.UIFigure.Name = 'MATLAB App';

            % Create BVPtosolvePanel
            app.BVPtosolvePanel = uipanel(app.UIFigure);
            app.BVPtosolvePanel.TitlePosition = 'centertop';
            app.BVPtosolvePanel.Title = 'BVP to solve';
            app.BVPtosolvePanel.FontWeight = 'bold';
            app.BVPtosolvePanel.FontSize = 14;
            app.BVPtosolvePanel.Position = [8 89 369 415];

            % Create SolveButton
            app.SolveButton = uibutton(app.BVPtosolvePanel, 'push');
            app.SolveButton.ButtonPushedFcn = createCallbackFcn(app, @SolveButtonPushed, true);
            app.SolveButton.BackgroundColor = [0.96078431372549 0.96078431372549 0.96078431372549];
            app.SolveButton.FontSize = 16;
            app.SolveButton.FontWeight = 'bold';
            app.SolveButton.FontColor = [0.129411764705882 0.129411764705882 0.129411764705882];
            app.SolveButton.Position = [122 7 126 32];
            app.SolveButton.Text = 'Solve';

            % Create ExampleLabel
            app.ExampleLabel = uilabel(app.BVPtosolvePanel);
            app.ExampleLabel.HorizontalAlignment = 'right';
            app.ExampleLabel.FontSize = 13;
            app.ExampleLabel.FontColor = [0.129411764705882 0.129411764705882 0.129411764705882];
            app.ExampleLabel.Position = [7 349 59 22];
            app.ExampleLabel.Text = 'Example:';

            % Create ExampleDropDown
            app.ExampleDropDown = uidropdown(app.BVPtosolvePanel);
            app.ExampleDropDown.Items = {'Choose an example to solve', 'Ex1: System of 5 first order ODEs', 'Exercise: Bratu', 'Ex2: Standard test problem', 'Ex3: Mathieu''s equation', 'Exercise: Tubular Reactor with Axial Dispersion', 'Ex4: BVP with periodic solution', 'Ex5: Falkner-Skan Flow', 'Exercise: Unsteady Gas Flow', 'Ex6: Porous Spherical Catalyst', 'Ex7: BVP with singular behavior at the origin', 'Exercise: Michaelis - Menten', 'Ex8: Fluid Injection', 'Ex9: Three-Point BVP'};
            app.ExampleDropDown.ValueChangedFcn = createCallbackFcn(app, @ExampleDropDownValueChanged, true);
            app.ExampleDropDown.FontSize = 13;
            app.ExampleDropDown.FontColor = [0.129411764705882 0.129411764705882 0.129411764705882];
            app.ExampleDropDown.BackgroundColor = [0.96078431372549 0.96078431372549 0.96078431372549];
            app.ExampleDropDown.Position = [81 349 256 22];
            app.ExampleDropDown.Value = 'Choose an example to solve';

            % Create SolverLabel
            app.SolverLabel = uilabel(app.BVPtosolvePanel);
            app.SolverLabel.HorizontalAlignment = 'right';
            app.SolverLabel.FontSize = 13;
            app.SolverLabel.FontColor = [0.129411764705882 0.129411764705882 0.129411764705882];
            app.SolverLabel.Position = [9 305 45 22];
            app.SolverLabel.Text = 'Solver:';

            % Create SolverDropDown
            app.SolverDropDown = uidropdown(app.BVPtosolvePanel);
            app.SolverDropDown.Items = {'bvp4c', 'bvp5c'};
            app.SolverDropDown.FontSize = 13;
            app.SolverDropDown.FontColor = [0.129411764705882 0.129411764705882 0.129411764705882];
            app.SolverDropDown.BackgroundColor = [0.96078431372549 0.96078431372549 0.96078431372549];
            app.SolverDropDown.Position = [81 305 138 22];
            app.SolverDropDown.Value = 'bvp4c';

            % Create ProblemLabel
            app.ProblemLabel = uilabel(app.BVPtosolvePanel);
            app.ProblemLabel.VerticalAlignment = 'top';
            app.ProblemLabel.WordWrap = 'on';
            app.ProblemLabel.FontColor = [0.129411764705882 0.129411764705882 0.129411764705882];
            app.ProblemLabel.Interpreter = 'latex';
            app.ProblemLabel.Position = [9 51 348 238];
            app.ProblemLabel.Text = 'Problem Label';

            % Create SolutionPanel
            app.SolutionPanel = uipanel(app.UIFigure);
            app.SolutionPanel.TitlePosition = 'centertop';
            app.SolutionPanel.Title = 'Solution';
            app.SolutionPanel.FontWeight = 'bold';
            app.SolutionPanel.FontSize = 14;
            app.SolutionPanel.Position = [388 25 446 479];

            % Create UIAxes
            app.UIAxes = uiaxes(app.SolutionPanel);
            title(app.UIAxes, 'Solution y(x)')
            xlabel(app.UIAxes, 'x')
            ylabel(app.UIAxes, 'y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [12 174 419 276];

            % Create UITable
            app.UITable = uitable(app.SolutionPanel);
            app.UITable.ColumnName = {'Quantity'; 'Value'};
            app.UITable.ColumnRearrangeable = 'on';
            app.UITable.ColumnEditable = true;
            app.UITable.Position = [9 9 426 153];

            % Create StatusTextAreaLabel
            app.StatusTextAreaLabel = uilabel(app.UIFigure);
            app.StatusTextAreaLabel.HorizontalAlignment = 'center';
            app.StatusTextAreaLabel.FontColor = [0.129411764705882 0.129411764705882 0.129411764705882];
            app.StatusTextAreaLabel.Position = [9 34 87 22];
            app.StatusTextAreaLabel.Text = 'StatusTextArea';

            % Create StatusTextArea
            app.StatusTextArea = uitextarea(app.UIFigure);
            app.StatusTextArea.FontColor = [0.129411764705882 0.129411764705882 0.129411764705882];
            app.StatusTextArea.Position = [107 9 258 73];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = bvp_app

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
 end
   