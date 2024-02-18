function findBAF(v,sI,sF,q)
a=diff(v);                                              % finding the time series of the acceleration

for i=1:length(sI)-1                                    % loop through all elements
    aux=abs(a(sI(i)))/max(abs(a(sI(i):sF(i))));         % determining the BAF at the beginning of the element
    fprintf(q,'%.15f\n',aux);                           % writing this BAF in the file
    if sI(i+1)~=sF(i)                                   % checking whether the end element of the element is equivalent to the beginning of the next element
        aux=abs(a(sF(i)))/max(abs(a(sI(i):sF(i))));     % determining the BAF at the end of the element
        fprintf(q,'%.15f\n',aux);                       % writing this BAF in the file
    end
end

