function y=simple_fitness_model(p,D,tf)

%creating the time array
t=linspace(0,tf,1e2);
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
    x8=-((-10*D + 8*tf^2*x(1) + 7*tf^3*x(2) + 6*tf^4*x(3) + 5*tf^5*x(4) + 4*tf^6*x(5) + 3*tf^7*x(6) + 2*tf^8*x(7))/tf^9);
    x9=-((9*D - 7*tf^2*x(1) - 6*tf^3*x(2) - 5*tf^4*x(3) - 4*tf^5*x(4) - 3*tf^6*x(5) - 2*tf^7*x(6) - tf^8*x(7))/tf^10);
    
    %calculating the jerk of the i-th individual
    jerk=c(:,1).*x(2)+c(:,2).*x(3)+c(:,3).*x(4)+c(:,4).*x(5)+c(:,5).*x(6)+c(:,6).*x(7)+c(:,7).*x8+c(:,8).*x9;
    
    %calculating the cost of the i-th individual
    y(j)=sum(jerk.^2);
end