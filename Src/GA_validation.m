function GA_validation()
rng(1,'twister')                                                            % for reproducibility

nvars = 5;                                                                  % number of variables
D=1;                                                                        % define the displacement of the element
tf=1;                                                                       % define the duration of the element

rootdir=strcat(cd,filesep,'GA_validation',filesep,'repGA_validation',filesep); % folder where the output files will be saved
mkdir(rootdir);

nRep=1e2;                                                                   % number of repetitions that will be performed

parfor i=1:nRep
    p=fopen(strcat(rootdir,string(i),'.csv'),'wt');                         % creating i-file
    
    ObjectiveFunction = @(x)simple_fitness_validation(x,D,tf);              % calling the cost function
    
    options = optimoptions(@ga,'PopulationSize',nvars*1e5,...               % determining ga settings
        'UseVectorized',true,'MutationFcn',@mutationgaussian);
    
    [x,fval] = ga(ObjectiveFunction,nvars,[],[],[],[],[],[],[],options);    % starting ga
    
    % determining the coefficients bound by the boundary conditions
    x6=-((-45*D + 21*tf^3*x(1) + 15*tf^4*x(2) + 10*tf^5*x(3) + 6*tf^6*x(4) + 3*tf^7*x(5))/tf^8);
    x7=-((80*D - 35*tf^3*x(1) - 24*tf^4*x(2) - 15*tf^5*x(3) - 8*tf^6*x(4) - 3*tf^7*x(5))/tf^9);
    x8=-((-36*D + 15*tf^3*x(1) + 10*tf^4*x(2) + 6*tf^5*x(3) + 3*tf^6*x(4) + tf^7*x(5))/tf^10);
    out=[i,x,x6,x7,x8,fval];
    
    % writing the i-file
    fprintf(p,'%u,%.15f,%.15f,%.15f,%.15f,%.15f,%.15f,%.15f,%.15f,%.15f\n',out);
    fclose(p);
    fprintf('%i\n', i)
end

d=dir(fullfile(rootdir,'*.csv'));                                           % retrieve the i-files
fido=fopen(strcat(cd,filesep,'GA_validation',filesep,'outGA_validation.csv'),'w'); % open output file to write

l='Iteracao,x1,x2,x3,x4,x5,x6,x7,x8,Integral';                              % writing header of the output file
fprintf(fido,'%s\n',l);

for i=1:length(d)
  fidi=fopen(fullfile(rootdir,d(i).name));                                  % open input i-file
  fwrite(fido,fread(fidi,'*char'));                                         % copy to output file
  fclose(fidi);                                                             % close that input i-file
end
fclose(fido); clear fid*                                                    % close output file, remove temporaries
end
