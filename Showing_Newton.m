%
% script for showing newton method
% Illustration of Newton Method

% ****** To see the figure, simply run this script ******
% or, type 'Showing_Newton' in the command
% The figure will appear after the iteration tables
% Each line shows up with 1.5 seconds pause


% Course Name  : MATH 2342
% Team Members : Ashleen Bains
%                Gwang Sik Kim
%                Joshua Selikem
%                Noel Steves

% Created Date : Feb 20, 2021


% script starts

%system variable declaration
syms x;

%given condtions
% y= f(x) = (x-3)^2 - 2
% default accuracy is 1E-2
f = @(x) x.^2 - 6 * x + 7; % y = (x-3)^2 -2
df = @(x) 2*x - 6;
init = 6;
acc = 1E-2; 

%initialization
iter = 1; 
iterMax = 100;
x_pre = init;

% arrays for illustration
x_vector = zeros(1,iterMax); 
x_vector(1) = init;
y_vector = zeros(1,iterMax);
dy_vector = zeros(1,iterMax);

index = 1; 

%newton-raphson method
while (iter <= iterMax)
       
    y_pre = f(x_pre);
    dy_pre = df(x_pre);
    xnew = x_pre - ( y_pre / dy_pre);
    err = abs(y_pre);
  
    %display the iterations
    disp('iteration             xold             xnew              err        ')
    fprintf('       %d        %.9f       %.9f       %.9f          \n  ', iter, x_pre, xnew, err)
        
    x_vector(index+1) = xnew; 
    y_vector(index) = y_pre;
    dy_vector(index) = dy_pre;
    
    x_pre = xnew;
    iter = iter+1; 
    index = index +1;
    
    %break condtion - absolute accuracy
    if err < acc
        break
    end
end

%final value
root = round(xnew * (1/acc)) / (1/acc); 
fprintf('\n******   The answer is %f   ******\n', root); 


% plotting 
figure(1)

xmin = 4;
xmax = 6;
ymin = -1;
ymax = 7;
axis([xmin, xmax, ymin, ymax]);


% function f(x) graph
x_domain = linspace(xmin, xmax, 1000); 
y_value_graph = f(x_domain); 

% arrays for legend
h = zeros(size(iter)); 
h1 = plot(x_domain, y_value_graph,'color','m','LineWidth',2);
h(1) = h1; 
hold on

% title and label
title('Illustration of Newton''s Method')
xlabel('x')
ylabel('y')
ylim([ymin, ymax])

% y=0 line 
y_0_line = zeros(size(x_domain));
plot(x_domain,y_0_line,'color','k')
pause(1);

% predefined color
% automatically color change
Color = jet(8);

% tangent line and marker for the point
for k = 1: iter -1
    
    y_tangent = @(x) dy_vector(k) * (x - x_vector(k)) + y_vector(k);
    y_tangent_value = y_tangent(x_domain);
    h(k+1) = plot(x_domain, y_tangent_value,'--','color', Color(k,:));
    plot(x_vector(k), y_vector(k), 'o','MarkerSize',8, 'color', Color(k,:))
    pause(1.5);
    
end
hold off

%legend
legend(h, 'y=f(x)','1st tangent line','2nd tangent line','3rd tangent line','4th tangent line','Location','NorthWest')


% script ends

