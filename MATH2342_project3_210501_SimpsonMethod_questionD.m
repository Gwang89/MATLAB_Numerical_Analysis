%
%MATH 2342
%Project 3 : mobile robot 
%

%   Gwang Sik Kim

%
%   Created Date : April 24, 2021
%   Revised      : May 1, 2021
%   Part d
clc;
clear all;
syms t

%------------------------Initial conditions--------------------------------
v_right = 2 - (0.5*t);              % right wheel velocity
v_left = 1;                         % left wheel velocity
L = 0.5;                            % length between two wheels
angle_zero = 0;                     % Initial angle
x_inital = 0;                       % Initial x
y_inital = 0;                       % Initial y
a = 0;                              % Lower integral bound
b = t;                              % Upper integral bound
n = 1000;                            % Number of partitions
accuracy = 0.000001; % accuracy... 

v_robot = (v_right + v_left) / 2;   % robot's velocity by two wheels
w_robot = (v_right - v_left) / L;   % robot's angular velocity by two wheels
angle_robot = angle_zero + int(w_robot, a, b); % robot's angle

%-----------Simpsons Method for x(t)--------------------------
fx(t) = v_robot * cos(angle_robot)
sx= fx(a)+fx(b);
hx = (b-a)/n;
for i=1:2:n-1
   sx= sx+ 4*fx(a+i*hx);
end
for i=2:2:n-2
   sx= sx + 2*fx(a+i*hx);
end
simpMethSolutionx =  hx/3 *sx;
simp_x = simpMethSolutionx;

%----------------- used to check for the error bounds of fx----------------
zx(t) = diff(-cos((t*(t - 4))/2)*(t/4 - 3/2),4);  % evaluates to a continous function
kx = zx(4)  ;                                     % evalute the derivative at t = 4

nx = nthroot(double(kx) * (4-a)^5 / 180 / accuracy, 4)

errorOfSimpx = vpa((kx*(4-a)^5)/(180*n^4))      % Calculation of absolute Error
realsimpx = vpa(int(fx,[0 4]));
totalErrorX = vpa(realsimpx - errorOfSimpx)
if abs(errorOfSimpx) <= totalErrorX               % Check if its within bounds
    statex = "Within safe bounds"
else
    statex = "Not within safe bounds"
end



%-----------Simpsons Method for y(t)--------------------------
fy(t) =  v_robot * sin(angle_robot)
sy=  fy(a)+fy(b);
hy = (b-a)/n;
for i=1:2:n-1
   sy= sy + 4*fy(a+i*hy);
end
for i=2:2:n-2
   sy= sy + 2*fy(a+i*hy);
end
simpMethSolutiony =  hy/3 *sy;
simp_y = simpMethSolutiony;

%----------------- used to check for the error bounds of fy----------------
zy(t) = diff(sin((t*(t - 4))/2)*(t/4 - 3/2),4);  % evaluates to a continous function
ky = zy(4)  ;                                    % evalute the derivative at t = 4

ny = nthroot(double(ky) * (4-a)^5 / 180 / accuracy, 4)

errorOfSimpy = vpa((ky*(4-a)^5)/(180*n^4))
realsimpy = vpa(int(fy,[0 4]));
totalErrorY = vpa(realsimpy - errorOfSimpy)
if abs(errorOfSimpy) <= totalErrorY              % Check if its within bounds
    statey = "Within safe bounds"
else
    statey = "Not within safe bounds"
end

%------ Final x and y of Robot        
x_robot(t) = x_inital + simp_x;
y_robot(t) = y_inital + simp_y;

%----------------------------------plotting--------------------------------
time = linspace(0,4,40);
plot( x_robot(time), y_robot(time))
xlabel('x (meter)')
ylabel('y (meter)')
title(' Robot Path using Simpsons Method with vr = 2 - 0.5t, vl = 1m/s');
hold on
grid on
legend('Robot Path','Location','Northwest')
hold off
 
