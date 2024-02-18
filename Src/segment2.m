function [segI,segF,v]=segment2(t,r,v,limD,limT,Ev)

%selecting the critical speed points that will be used to determine the segmentation points of the elements
[~,pkM]=findpeaks(v);                                       % determining the frame of the peaks of velocity time-series
[~,pkm]=findpeaks(-v);                                      % determining the frame of the valleys of velocity time-series

pk(:,1)=sort([pkm;pkM]);                                    % merging and sorting the index of peaks and valleys (PC)

pk(:,2)=nan(length(pk),1);                                  % crating a second column in the PC array, to determine whether the PCs are above, below, or between the minimum speed

pk(v(pk(:,1))>Ev,2)=1;                                      % determining whether the CPs are above, below, or between the minimum speed
pk(v(pk(:,1))<-Ev,2)=-1;                                  
pk(and(v(pk(:,1))<Ev,v(pk(:,1))>-Ev),2)=0;                 

endpk=length(pk);
i=1;

% loop to include artificial CPs at the points of velocities closest to 0 between two CPs that do not have a CP 0 between them
while 1
    if i==endpk
        break;
    end
    
    if pk(i,2)-pk(i+1,2)==-2||pk(i,2)-pk(i+1,2)==2
        [~,ind]=min(abs(v(pk(i):pk(i+1,1),1)));
        ind=ind+pk(i,1)-1;
        pk=[pk(1:i,:);[ind,0];pk(i+1:end,:)];
        endpk=endpk+1;
    end
    i=i+1;
end

% determining the beginning and end of the elements from the moments at which CP 0 becomes 1, or 1 becomes 0
pk(:,2)=abs(pk(:,2));

[~,segI]=findpeaks(pk(:,2));
[~,segF]=findpeaks(flip(pk(:,2)));
segF=sort(length(pk)-segF+1);

segI=segI-1;
segF=segF+1;

segI=pk(segI,1);
segF=pk(segF,1);

% selecting only those elements that pass the minimum displacement and duration filters
auxI=nan(size(segI));
auxF=auxI;
j=1;
for i=1:length(segI)-1
    disp=r(segF(i))-r(segI(i));
    dura=t(segF(i))-t(segI(i));
    if abs(disp)>=limD && abs(dura)>=limT
        auxI(j)=segI(i);
        auxF(j)=segF(i);
        j=j+1;
    end
end
segI=(auxI(~isnan(auxI)));
segF=(auxF(~isnan(auxF)));
end

