clear;

BEGIN_ACADO;
    
    acadoSet('problemname', 'inverted_pendulum'); 

    DifferentialState x alpha xdot alphadot;
    DifferentialState D;
    Control F;
%     Parameter T;
    
    % Set default objects
    f = acado.DifferentialEquation(0.0, 10);
    
%     f = acado.DiscretizedDifferentialEquation(3/50);
    ocp = acado.OCP(0.0, 3, 50);
    algo = acado.OptimizationAlgorithm(ocp);   
       
    f.add(dot(x) == xdot);
    f.add(dot(alpha) == alphadot);
    f.add(dot(xdot) == ( F - 0.210*cos(alpha)*9.81*sin(alpha) + 0.210*0.305*alphadot*alphadot*sin(alpha) ) / (0.455 + 0.210*sin(alpha)*sin(alpha)));
    f.add(dot(alphadot) == (1.0/0.305)*(9.81*sin(alpha) - (( F - 0.210*cos(alpha)*9.81*sin(alpha) + 0.210*0.305*alphadot*alphadot*sin(alpha) ) / (0.455 + 0.210*sin(alpha)*sin(alpha)))*cos(alpha)));

    f.add(dot(D) == 1/2*F*F);
    
%     f.add(next(x) == x + 3/50*xdot);
%     f.add(next(alpha) == alpha + 3/50*alphadot);
%     f.add(next(xdot) == xdot + 3/50*( F - 0.210*cos(alpha)*9.81*sin(alpha) + 0.210*0.305*alphadot*alphadot*sin(alpha) ) / (0.455 + 0.210*sin(alpha)*sin(alpha)));
%     f.add(next(alphadot) == alphadot + 3/50*(1.0/0.305)*(9.81*sin(alpha) - (( F - 0.210*cos(alpha)*9.81*sin(alpha) + 0.210*0.305*alphadot*alphadot*sin(alpha) ) / (0.455 + 0.210*sin(alpha)*sin(alpha)))*cos(alpha)));
% 
%     f.add(next(D) == D + 3/50*1/2*F*F);
    
    ocp.minimizeMayerTerm(D);

    ocp.subjectTo( f );
    ocp.subjectTo( 'AT_START', x ==  0.0 );     
    ocp.subjectTo( 'AT_START', alpha ==  -pi);       % start with pendulum  in stable position (pointed to the ground)
    ocp.subjectTo( 'AT_START', xdot ==  0.0 );    
    ocp.subjectTo( 'AT_START', alphadot ==  0.0 ); 
    ocp.subjectTo( 'AT_START', D == 0.0 );
    
    %ocp.subjectTo( 'AT_END', x == 0.0 ); 
    ocp.subjectTo( 'AT_END', alpha == 0.0 );         % end when pendulum is standing up
    ocp.subjectTo( 'AT_END', xdot ==  0.0 );    
    ocp.subjectTo( 'AT_END', alphadot ==  0.0 ); 
    
    
    ocp.subjectTo( -100 <= F <=  100 );   
%     ocp.subjectTo( 1 <= T <= 15 );

    
   % algo.set('KKT_TOLERANCE', 1e-4);
    algo.initializeControls([0 -0.00001]);

    
    
END_ACADO;           % Always end with "END_ACADO".
                     % This will generate a file problemname_ACADO.m. 
                     % Run this file to get your results. You can
                     % run the file problemname_ACADO.m as many
                     % times as you want without having to compile again.


clear;

out = inverted_pendulum_RUN();
draw;
