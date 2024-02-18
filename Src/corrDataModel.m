function corrDataModel()
addpath('Src');

limDinf=0.003;                                                              % minimun displacement limit (m)
limTinf=0.1;                                                                % minimun duration limit (s)
limVinf=0.01;                                                               % minimun velocity limit (m/s)

%%             GENETIC ALGORITHM MODEL

GA_model=readtable(strcat(cd,filesep,'GA',filesep,'outGA_model.csv'));      % reading output from GA_model

[~,ind]=min(GA_model.Integral);                                             % selecting the coefficients of the best GA repeat
GA_model=table2array(GA_model(ind,2:end-1));                                

%%                       DATA

dirName=strcat(cd,filesep,'Data',filesep);                                  
files=recursiveDir(dirName,'*.csv');                                        % determining all data files
data_Random=files(contains(files,'Randomness'));                            % determining random movement data files
data_Reaching=files(contains(files,'Planned'));                             % determining reaching movement data files

dirOut=strcat(cd,filesep,'Output',filesep);                                 % creating output folder
mkdir(dirOut);

tempOut=strcat(cd,filesep,'Temp',filesep);                                  % creating temporary folder
mkdir(tempOut);
%%                      RANDOM

BAF=fopen(strcat(dirOut,'BAF_Random.csv'),'wt');                            % creating Bondary Aceleration Factor random file

for f=1:length(data_Random)                                                 % starting loop to go through all the random movement files 
    disp(f);
    
    p=fopen(strcat(tempOut,string(f),'.csv'),'wt');                         % creating temporary correlation file
    
    data=readtable(string(data_Random(f)));                                 % reading the i-th random data file
    
    [x,vx,t]=filterData(data,1);                                            % filtering the movement
    [y,vy,~]=filterData(data,2);
    [z,vz,~]=filterData(data,3);
    
    [sIx,sFx,vx]=segment2(t,x,vx,limDinf,limTinf,limVinf);                  % decomposing the data into movement elements
    [sIy,sFy,vy]=segment2(t,y,vy,limDinf,limTinf,limVinf);
    [sIz,sFz,vz]=segment2(t,z,vz,limDinf,limTinf,limVinf);
    
    findBAF(vx,sIx,sFx,BAF);                                                % determining the BAF of this data
    findBAF(vy,sIy,sFy,BAF);
    findBAF(vz,sIz,sFz,BAF);
    
    for i=1:length(sIx)                                                     % determining the correlation between the motion element and the models
        [wHoff,wJerk,rHoff,rJerk,nPeaks,T,D,Vm]=fitModel(t(sIx(i):sFx(i)),x(sIx(i):sFx(i)),vx(sIx(i):sFx(i)),GA_model);
        fprintf(p,'%u,%.15f,%.15f,%.15f,%.15f,%u,%.15f,%.15f,%.15f\n',1,wHoff,wJerk,rHoff,rJerk,nPeaks,T,D,Vm);
    end
    for i=1:length(sIy)
        [wHoff,wJerk,rHoff,rJerk,nPeaks,T,D,Vm]=fitModel(t(sIy(i):sFy(i)),y(sIy(i):sFy(i)),vy(sIy(i):sFy(i)),GA_model);
        fprintf(p,'%u,%.15f,%.15f,%.15f,%.15f,%u,%.15f,%.15f,%.15f\n',2,wHoff,wJerk,rHoff,rJerk,nPeaks,T,D,Vm); 
    end
    for i=1:length(sIz)
        [wHoff,wJerk,rHoff,rJerk,nPeaks,T,D,Vm]=fitModel(t(sIz(i):sFz(i)),z(sIz(i):sFz(i)),vz(sIz(i):sFz(i)),GA_model);
        fprintf(p,'%u,%.15f,%.15f,%.15f,%.15f,%u,%.15f,%.15f,%.15f\n',3,wHoff,wJerk,rHoff,rJerk,nPeaks,T,D,Vm);
    end
    fclose(p);                                                              % close temporary correlation file
end
fclose(BAF);

delete(fullfile(dirOut,'corr_Model_Random.csv'));                           % deleting the old file if it exists
d=dir(fullfile(tempOut,'*.csv'));                                           % retrieve the files
fido=fopen(fullfile(dirOut,'corr_Model_Random.csv'),'w');                   % open output file to write

l='axis,wHoff,wJerk,rHoff,rJerk,nPeaks,T,D,Vm';                             % header of the output file
fprintf(fido,'%s\n',l);

for i=1:length(d)                                                           % loop through all temporary correlation files
  fidi=fopen(fullfile(tempOut,d(i).name));                                   % open temporary correlation file
  fwrite(fido,fread(fidi,'*char'));                                         % copy to output
  fclose(fidi);                                                             % close that temporary correlation file
  delete(fullfile(tempOut,d(i).name));                                       % delete that temporary correlation file
end
fclose(fido); clear fid*                                                    % close output file, remove temporaries

%%                      REACHING

BAF=fopen(strcat(dirOut,'BAF_Reaching.csv'),'wt');                          % creating Bondary Aceleration Factor random file

for f=1:length(data_Reaching)                                               % starting loop to go through all the random movement files 
    disp(f);

    p=fopen(strcat(tempOut,string(f),'.csv'),'wt');                         % creating temporary correlation file
    
    data=readtable(string(data_Reaching(f)));                               % reading the i-th random data file
    
    [y,vy,t]=filterData(data,1);                                            % filtering the movement
    
    [sIy,sFy,vy]=segment2(t,y,vy,limDinf,limTinf,limVinf);                  % decomposing the data into movement elements
    
    findBAF(vy,sIy,sFy,BAF);                                                % determining the BAF of this data
    
    for i=1:length(sIy)                                                     % determining the correlation between the motion element and the models
        [wHoff,wJerk,rHoff,rJerk,nPeaks,T,D,Vm]=fitModel(t(sIy(i):sFy(i)),y(sIy(i):sFy(i)),vy(sIy(i):sFy(i)),GA_model);
        fprintf(p,'%u,%.15f,%.15f,%.15f,%.15f,%u,%.15f,%.15f,%.15f\n',2,wHoff,wJerk,rHoff,rJerk,nPeaks,T,D,Vm); 
    end
    
    fclose(p);                                                              % close temporary correlation file
end
fclose(BAF);

delete(fullfile(dirOut,'corr_Model_Reaching.csv'));                         % deleting the old file if it exists
d=dir(fullfile(tempOut,'*.csv'));                                           % retrieve the files
fido=fopen(fullfile(dirOut,'corr_Model_Reaching.csv'),'w');                 % open output file to write

l='axis,wHoff,wJerk,rHoff,rJerk,nPeaks,T,D,Vm';                             % header of the output file
fprintf(fido,'%s\n',l);

for i=1:length(d)                                                           % loop through all temporary correlation files
  fidi=fopen(fullfile(tempOut,d(i).name));                                   % open temporary correlation file
  fwrite(fido,fread(fidi,'*char'));                                         % copy to output
  fclose(fidi);                                                             % close that temporary correlation file
  delete(fullfile(tempOut,d(i).name));                                       % delete that temporary correlation file
end
fclose(fido); clear fid*                                                    % close output file, remove temporaries

rmdir(tempOut);                                                             % delete temporary folder
end