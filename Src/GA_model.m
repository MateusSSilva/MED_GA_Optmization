function GA_model()
rng(1,'twister')                                                            % for reproducibility

nvars = 7;                                                                  % number of variables
D=1;                                                                        % define the displacement of the element
tf=1;                                                                       % define the duration of the element

rootdir=strcat(cd,filesep,'GA',filesep,'repGA_model',filesep);              % folder where the output files will be saved
mkdir(rootdir);

nRep=1e3;                                                                   % number of repetitions that will be performed

parfor i=1:nRep
    p=fopen(strcat(rootdir,string(i),'.csv'),'wt');                         % creating i-file

    ObjectiveFunction = @(x)simple_fitness_model(x,D,tf);                   % calling the cost function
    
    options = optimoptions(@ga,'PopulationSize',nvars*1e5,...               % determining ga settings
        'UseVectorized',true,'MutationFcn',@mutationgaussian);
    
    [x,fval] = ga(ObjectiveFunction,nvars,[],[],[],[],[],[],[],options);    % starting ga
    
    % determining the coefficients bound by the boundary conditions
    x8=-((-10*D + 8*tf^2*x(1) + 7*tf^3*x(2) + 6*tf^4*x(3) + 5*tf^5*x(4) + 4*tf^6*x(5) + 3*tf^7*x(6) + 2*tf^8*x(7))/tf^9);
    x9=-((9*D - 7*tf^2*x(1) - 6*tf^3*x(2) - 5*tf^4*x(3) - 4*tf^5*x(4) - 3*tf^6*x(5) - 2*tf^7*x(6) - tf^8*x(7))/tf^10);
    out=[i,1,x,x8,x9,fval];
    
    % writing the i-file    
    fprintf(p,'%u,%u,%.15f,%.15f,%.15f,%.15f,%.15f,%.15f,%.15f,%.15f,%.15f,%.15f\n',out);
    fclose(p); 
    fprintf('%i\n', i)
end

d=dir(fullfile(rootdir,'*.csv'));                                           % retrieve the i-files
fido=fopen(strcat(cd,filesep,'GA',filesep,'outGA_model.csv'),'w');          % open output file to write

l='Iteracao,x1,x2,x3,x4,x5,x6,x7,x8,x9,Integral';                       % writing header of the output file
fprintf(fido,'%s\n',l);

for i=1:length(d)
    fidi=fopen(fullfile(rootdir,d(i).name));                                % open input i-file
    fwrite(fido,fread(fidi,'*char'));                                       % copy to output file
    fclose(fidi);                                                           % close that input i-file
end
fclose(fido); clear fid*                                                    % close output file, remove temporaries
end
