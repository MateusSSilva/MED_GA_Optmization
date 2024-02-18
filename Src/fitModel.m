function [wHoff,wJerk,rHoff,rJerk,nPeaks,dt,D,Vm]=fitModel(t,r,dr,GA)

if isempty(t)
    wHoff=[];wJerk=[];rHoff=[];rJerk=[];nPeaks=[];dt=[];D=[];Vm=[];
    return
end

to=t(1);                                                                    % initial time
dt=t(end)-to;                                                               % duration
Vm=abs(mean(dr));                                                           % mean velocity
D=abs(r(end)-r(1));                                                         % displacement

dr=abs(dr);                                                                 % normalization of movement element
dr=dr-min(dr);

nPeaks=findpeaks(dr);                                                       % number of peaks of this movement element
nPeaks=length(nPeaks);

% creating the model velocity profiles corresponding to the displacement and duration of the i-th movement element
siz=length(t);                                                              
analytical=zeros(siz,1);
Jerk=analytical;
for i=1:siz
    x=(t(i)-to)/dt;
    analytical(i)=D/dt*30*((x^4) -2*(x^3) + (x^2));                         % analytical model
    Jerk(i)=2*GA(1)*x +3*GA(2)*x.^2 +4*GA(3)*x^3 +5*GA(4)*x^4 ...
        +6*GA(5)*x^5 +7*GA(6)*x^6 +8*GA(7)*x^7 +9*GA(8)*x^8 +10*GA(9)*x^9;  % GA model
end
Jerk=Jerk*sum(analytical)/sum(Jerk);

% calculation of W
dvHoff=analytical-dr;
dvJerk=Jerk-dr;

wHoff=std(dvHoff)/abs(mean(dr));
wJerk=std(dvJerk)/abs(mean(dr));

% calculation of R-square
rHoff=corrcoef(analytical,dr);
rHoff=rHoff(1,2).^2;

rJerk=corrcoef(Jerk,dr);
rJerk=rJerk(1,2).^2;

end
