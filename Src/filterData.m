function [r,vr,t]=filterData(data,axis)

data=table2array(data);                             % converting table to array

frqSmp=1/diff(data(1:2,1));                         % determining the sample frequency

data=data(:,axis+1);                                % selecting the 3D axis

[b,a] = butter(4, 10 / (frqSmp/2));                 % filtering the data
r=filtfilt(b,a,data);

vr=diff(r)*frqSmp;                                  % deriving the position to determine the velocity

sz=length(vr);
r=r(1:sz);                                          % cutting the r-array to match the vr array size
t=1:sz;                                             % frames
t=t'/frqSmp;                                        % time in seconds
end