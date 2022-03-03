% trapezoidal rule
% numerical integration
% pearson exercise

% created by Gwang Sik Kim
% Date Mar 03, 2021

%%
%pearson hw11
% question 1


%{
f1 = @(x) sqrt((121-x.^2)); 
dx = 11/8; 
x = [0, dx, dx*2, dx*3, dx*4, dx*5, dx*6, dx*7, dx*8];
y= f1(x); 

% results
area = (sum(y)*2 - y(1) - y(9)) * 0.5 * dx;


% comparison
integration = integral(f1, 0, 11);
%}
%%

%{
% question 2
% f2 = @(x) 6*x.^2; 
dx2 = (4-0) / 4; 

x2 = [0, dx2, dx2*2, dx2*3, dx2*4]; 
y2 = f2(x2); 
area2 = (0.5) * (2*sum(y2) - y2(1) - y2(5)) * dx2;
integration2 = integral(f2, 0, 4);
   
%}

%%
%{
% question 3
fx = @(x) sqrt(8.7*1E-5*x.^2+1); 
n = 10; 
a= 0; 
b= 12; 
dx = (b-a) / n; 
for i=1 : n+1
    x(i) = (i-1)*dx;
end
y = fx(x); 
y= round(y, 6); 
Area = 0; 
for i=1:n
    dArea = (y(i) + y(i+1))*0.5*dx; 
    Area = Area+dArea; 
   
end
Area = round(Area, 6); 
Area

%Comparison
integration = integral(fx, a, b) 

L = 2*Area; 
fprintf('\n L is %.3f\n', L)
%} 



