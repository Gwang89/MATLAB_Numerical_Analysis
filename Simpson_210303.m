% Simpson 1/3 Rule
% numerical integration
% pearson exercise

% created by Gwang Sik Kim
% Date Mar 03, 2021

%%
% Question 4
%{

fx = @(x) 8 + x.^3;
a= 0;
b= 2;
n = 2;

dx = (b-a) /n ;

for i=  1: n + 1

    x(i) = a + dx*(i-1);
    
end

y = fx(x);
area = (1/3) * dx * ( (y(1) + 4 * y(2) + y(3)) )  

integration = integral(fx, 0, 2)
%}

%%
% Question 5
fx = @(x) sqrt(1+x.^3);
a=0;
b=1;
n=4; 
dx = (b-a) / n ;
for i=  1: n + 1

    x(i) = a + dx*(i-1);
    
end
y = fx(x);
y=round(y, 4);
Area = 0; 
for i = 1: (n/2)
    dArea = (1/3) * dx * ( (y(2*i - 1) + 4 * y(2*i) + y(2*i+1)) )  ;
    Area = Area + dArea;  
end
Area = round(Area, 4)
Area
integration = integral(fx, 0, 1) 

fprintf('rounded value to 3 decimal places is %.3f', Area)

