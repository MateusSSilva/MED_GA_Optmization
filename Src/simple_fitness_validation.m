function y=simple_fitness_validation(p,D,tf)

%creating the time array
t=linspace(0,tf,1e3);
t=t';

%creating the output matrix
y=zeros(size(p,1),1);

%setting the time terms of the jerk equation
c=[6*t.^0,24*t,60*t.^2,120*t.^3,210*t.^4,336*t.^5,504*t.^6,720*t.^7];

%time loop to go through all the individuals in the population
for j = 1:size(p,1)
    
    %selecting the free coefficients of the i-th individual
    x = p(j,:);
    
    %determining the coefficients bound by the boundary conditions
    x6=-((-45*D + 21*tf^3*x(1) + 15*tf^4*x(2) + 10*tf^5*x(3) + 6*tf^6*x(4) + 3*tf^7*x(5))/tf^8);
    x7=-((80*D - 35*tf^3*x(1) - 24*tf^4*x(2) - 15*tf^5*x(3) - 8*tf^6*x(4) - 3*tf^7*x(5))/tf^9);
    x8=-((-36*D + 15*tf^3*x(1) + 10*tf^4*x(2) + 6*tf^5*x(3) + 3*tf^6*x(4) + tf^7*x(5))/tf^10);
    
    %calculating the jerk of the i-th individual
    jerk=c(:,1).*x(1)+c(:,2).*x(2)+c(:,3).*x(3)+c(:,4).*x(4)+c(:,5).*x(5)+c(:,6).*x6+c(:,7).*x7+c(:,8).*x8;
    
    %calculating the cost of the i-th individual
    y(j)=sum(jerk.^2);
end