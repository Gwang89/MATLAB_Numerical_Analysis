%%
%              	MATH 2342
%               Project 3 : mobile robot 
%               question c (for check) and d
%   created by...
%               Gwang Sik Kim


%   Created Date : April 27, 2021
%   Revised      : May 1, 2021

%%
% checking the algorthm in part c... 
% re-doing with given equations 
format shortG

L = 0.5;         % length between two wheels
x_zero = 0;
y_zero = 0;

%%
syms t; 
time_min_a = 0;
%time_max_a = 3; % 0 to 3 seconds... in part c.
time_max_a = 4; % part d.

% right wheel velocity
%v_right_a = 2; % part c
v_right_a = @(t) 2 - 0.5 * t; % part d

% left wheel velocity     
v_left_a = 1;   % part c and d

% robot's angular velocity by two wheels

%v_robot_a = @(t) 3/2; % part c
%w_robot_a = ( v_right_a - v_left_a ) / L;   % part c
v_robot_a = @(t) 3/2 - 1/4 .* t; % part d
w_robot_a = @(t) 2 - t;  % part d

% usually angular velocity is rad/s, so assuming it is radian.   
%angle_robot_a = @(t)  2 * t   % part c
angle_robot_a = @(t) 2 .* t - 1/2 .* t.^2;  % part d

%%
% interval
min_x_a = 0;
max_x_a = time_max_a; % 3 seconds... 
n_x_a = 4000; 
dt_x_a = (max_x_a-min_x_a) / n_x_a; 
%% Calculation for the 'ERROR' in Trapezoid Rule.
% added on April 29, 2021

% function settings... 
cos_angle = @(t) cos(angle_robot_a(t)); 
sin_angle = @(t) sin(angle_robot_a(t)); 

func_x = @(t) v_robot_a(t) .* cos_angle(t); 
func_y = @(t) v_robot_a(t) .* sin_angle(t); 

% error in trapezoid rule
% if f'' is continuous, and abs(f'') < K2 for the interval, [a,b], then 
% error <= K2 * (b-a)^3 / (12 * n^2) ... 

% second order derivative...
% df_x_1 = @(t) diff(func_x(t),t); 
% MATLAB result shows... 
df_x_1 = @(t) - cos(- t.^2/2 + 2.*t)/4 - sin(- t.^2./2 + 2.*t).*(t./4 - 3/2).*(t - 2);
% df_x_2 = @(t) diff(df_x_1(t),t);
df_x_2 = @(t) cos(- t.^2/2 + 2.*t).*(t/4 - 3/2).*(t - 2).^2 - sin(- t.^2/2 + 2.*t).*(t/4 - 3/2) - (sin(- t.^2/2 + 2.*t).*(t - 2))/2;

% similarly... 
df_y_1 = @(t) cos(- t.^2/2 + 2.*t).*(t/4 - 3/2).*(t - 2) - sin(- t.^2/2 + 2.*t)/4;
df_y_2 = @(t) cos(- t.^2/2 + 2.*t).*(t/4 - 3/2) + (cos(- t.^2/2 + 2.*t).*(t - 2))/2 + sin(- t.^2/2 + 2.*t).*(t/4 - 3/2).*(t - 2).^2;

time_vector = linspace(time_min_a, time_max_a, 1000); 
dy2 = df_y_2(time_vector); 
dx2 = df_x_2(time_vector); 

% find maximum value, K2. 
k2_x = max(dx2); 
k2_y = max(dy2); 

%% 
% error calculation and minimum n value...
accuracy = 0.000001; 
fprintf('Accuracy is %f', accuracy)

n_min_x = nthroot(( k2_x * (max_x_a - min_x_a)^3 / (accuracy) / 12 ), 2)
n_min_y = nthroot(( k2_y * (max_x_a - min_x_a)^3 / (accuracy) / 12 ), 2)
fprintf('chosen n value : %d\n', n_x_a)
if n_min_x < n_x_a && n_min_y < n_x_a
    disp('n value is bigger than minimum value based on the error calculation by K2') 
else
        disp('n value is smaller than minimum value based on the error calculation by K2. need to increase.') 
end

err_x = k2_x * (max_x_a - min_x_a)^3 / (12 * n_x_a^2)
err_y = k2_y * (max_x_a - min_x_a)^3 / (12 * n_x_a^2)

%% Find x(t)



% time vector >> n+1 elements.. 
%time_a = linspace(time_min_a, time_max_a, n_x_a);
time_a = zeros(n_x_a + 1,1); 
for k=1:n_x_a + 1
   time_a(k) = min_x_a + (k - 1) * dt_x_a; 
end

arr_angle_robot_a = angle_robot_a(time_a); 

% vectors
arr_cos_angle_robot_a = cos(arr_angle_robot_a); 
arr_v_robot_a = v_robot_a(time_a);
arr_func_x = arr_v_robot_a .* arr_cos_angle_robot_a;

% Trapezoid Rule
Si_x_a= zeros(n_x_a,1);
x_a = size(Si_x_a,1); 
S = 0;
for i=1:n_x_a
    Si_x_a(i) = ( arr_func_x(i) + arr_func_x(i+1) ) * (0.5) * dt_x_a;
    %S = S + Si_x_a(i); 
    %x_a(i) = S;
end
%x_a = Si_x_a 
x_a(1) = Si_x_a(1); 
for i=2:n_x_a
   x_a(i) = x_a(i-1) + Si_x_a(i) ;
end

%% Find y(t)
%vectors
arr_sin_angle_robot_a = sin(arr_angle_robot_a); 
arr_v_robot_a = v_robot_a(time_a);
arr_func_y = arr_v_robot_a .* arr_sin_angle_robot_a;

% Trapezoid Rule
Si_y_a= zeros(n_x_a,1);
y_a = size(Si_y_a,1); 
Sy = 0;
for i=1:n_x_a
    Si_y_a(i) = ( arr_func_y(i) + arr_func_y(i+1) ) * (0.5) * dt_x_a;
    %S = S + Si_x_a(i); 
    %x_a(i) = S;
end
%x_a = Si_x_a 
y_a(1) = Si_y_a(1); 
for i=2:n_x_a
   y_a(i) = y_a(i-1) + Si_y_a(i) ;
end


%% graph by Trapezoid Rule
% plot trajectory... settings. 


%%
figure(1)
time_plot=linspace(time_min_a,time_max_a,size(x_a,2)); 

plot(time_plot,x_a, 'r')
xlabel('time (second)');
ylabel('x (m)');
title('d-1: Mobile Robot''s Trajectory x position by time with vr = 2 - 0.5t, vl = 1m/s');
hold on;

% because of the difference of the size of two arrays... 
% x_a(1001) does not exist... 
time_plot_1sec = [0, 1, 2, 3, time_a(4000)];
x_a_1sec = [x_a(1), x_a(1001), x_a(2001), x_a(3001),x_a(4000)]; 
plot(time_plot_1sec, x_a_1sec, 'ro')

grid on
legend('Trajectory for 4 seconds', 'Position per 1 second','Location', 'southeast'); 
hold off;

%%
figure(2)

time_plot=linspace(time_min_a,time_max_a,size(y_a,2)); 

plot(time_plot,y_a, 'r')
xlabel('time (second)');
ylabel('y (m)');
title('d-2: Mobile Robot''s Trajectory y position by time with vr = 2 - 0.5t, vl = 1m/s');
hold on

y_a_1sec = [y_a(1), y_a(1001), y_a(2001), y_a(3001),y_a(4000)]; 
plot(time_plot_1sec, y_a_1sec, 'ro')

grid on
legend('Trajectory for 4 seconds', 'Position per 1 second' ,'Location',  'southeast'); 
hold off;

%%
figure(3)
plot(x_a,y_a, 'r')
xlabel('x (meter)')
ylabel('y (meter)')

title('d-3: Mobile Robot''s Trajectory in x-y plane with vr = 2 - 0.5t, vl = 1m/s');
hold on

plot(x_a_1sec,y_a_1sec,'ro')
grid on
legend('Trajectory for 4 seconds', 'Position per 1 second', 'Location', 'northwest'); 
hold off

%%
figure(4)

time_plot_4 = [time_min_a : 0.1: time_max_a - 0.1]; % 0.1 increment... 
plot_x_a = zeros(size((time_plot_4),2),1);
for k = 1:40
    plot_x_a(k) = x_a((k - 1) * 100 + 1);
end
% x_a(1001) does not exist... 
plot_y_a = zeros(size((time_plot_4),2),1);
for k = 1:40
    plot_y_a(k) = y_a((k - 1) * 100 + 1);
end
% y_a(1001) does not exist... 
plot(plot_x_a,plot_y_a, 'r-*')
xlabel('x (meter)')
ylabel('y (meter)')

title('d-4: Mobile Robot''s Trajectory in x-y plane with vr = 2 - 0.5t, vl = 1m/s');
hold on

grid on
legend('Trajectory per 0.1 second', 'Location', 'northwest'); 
hold off


%% final result
fprintf('x(4) = %f (m) \n', x_a(size(x_a, 2)))
fprintf('y(4) = %f (m) \n', y_a(size(y_a, 2)))
