%%
%              	MATH 2342
%               Project 4 : mobile robot (cont'd)
%               question h and i
%   created by...

%               Gwang Sik Kim


%   Created Date : May 28, 2021
%   Revised      : May 28, 2021

%%

tic
L = 0.5;         % length between two wheels
x_zero =  0;
y_zero = 0;
theta_zero = 0;
a = 0;

syms t z;
format shortEng ;
b = t;

v_right = @(t) 2 - 0.5 .* t; % part d
v_left = 1;   % part c and d

v = @(t) (v_right(t) + v_left) / 2; 
w = @(t) ( v_right(t) - v_left ) / L; 

angle(t) = theta_zero + int(w,t);

Mx(t) = v * cos(angle) % function inside of integral...
My(t) = v * sin(angle) % function inside of integral... 
% x(t) = x_zero + int(Mx,t,a,b) <== cannot do it analytically. 


%%
% in question g, we get the number of non-zero terms to meet 0.01 accuracy
% n = 43 for Mx, n = 42 for My
nx = 43;
coeff_Mx = zeros(1,nx + 1); % including constant term, it is 44 terms. 


%derivatives for x(t)
for n = 0:nx
    coeff_Mx(n+1) = subs(diff(Mx(t),t,n), t, 0) / factorial(n);
end

coeff_Mx;

x(t) = 0 * t;
for i = 1:nx+1
    x(t) = x(t) + x_zero + coeff_Mx(i) * (1/i) * power(t,i);   
end

x(3)
toc

%%
% similarly...
ny = 42;
coeff_My = zeros(1,ny + 1); % including constant term, it is 43 terms. 

%derivatives for y(t)
for n = 0:ny
    coeff_My(n+1) = subs(diff(My(t),t,n), t, 0) / factorial(n);
end

coeff_My;

y(t) = 0 * t;
for i = 1:ny+1
    y(t) = y(t) + y_zero + coeff_My(i) * (1/i) * power(t,i);   
end


%%
% comparison between correct value (provided by instructor) and our answer
x_3sec_correct = 0.3438756633;
y_3sec_correct = 2.816517512;
fprintf('the correct answer provided of x(3) is %.10f\n', x_3sec_correct)
fprintf('our answer x(3) is %.10f\n', x(3))
fprintf('the correct answer provided y(3) is %.10f\n', y_3sec_correct)
fprintf('our answer of y(3) is %.10f\n', y(3))



%%
%%
% adopted midpoint method on question D from project 3... 
tic
time_min_a = 0;
%time_max_a = 3; % 0 to 3 seconds... in part c.
time_max_a = 3; % part d.

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
n_x_a = 4000; % midpoint requires n is bigger than 2128. set 4000.
dt_x_a = (max_x_a-min_x_a) / n_x_a; 


%% Calculation for the 'ERROR' in midpoint
% added on May 1, 2021

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
% error <= K2 * (b-a)^3 / (12 * n^2) ... in midpoint. 
accuracy = 0.000001; 
fprintf('Accuracy is %f', accuracy)

n_min_x = nthroot(( k2_x * (max_x_a - min_x_a)^3 / (accuracy) / 24 ), 2);
n_min_y = nthroot(( k2_y * (max_x_a - min_x_a)^3 / (accuracy) / 24 ), 2);

fprintf('chosen n value : %d\n', n_x_a)
if (n_min_x < n_x_a) && (n_min_y < n_x_a)
    disp('n value is bigger than minimum value based on the error calculation by K2') 
else 
    disp('n value is smaller than minimum value based on the error calculation by K2. need to increase.') 
    
end

err_x = k2_x * (max_x_a - min_x_a)^3 / (12 * n_x_a^2);
err_y = k2_y * (max_x_a - min_x_a)^3 / (12 * n_x_a^2);

%% Find x(t)

% time vector >> n+1 elements.. 
%time_a = linspace(time_min_a, time_max_a, n_x_a);
time_a = zeros(n_x_a + 1,1); 
time_a_midpoint = zeros(n_x_a,1); 
for k=1:n_x_a + 1
   time_a(k) = min_x_a + (k - 1) * dt_x_a; 
end
for k = 1: n_x_a
    time_a_midpoint(k) = ( time_a(k) + time_a(k+1) ) / 2; 
end


arr_angle_robot_a = angle_robot_a(time_a); 

% vectors
arr_cos_angle_robot_a = cos(arr_angle_robot_a); 
arr_v_robot_a = v_robot_a(time_a);
arr_func_x = arr_v_robot_a .* arr_cos_angle_robot_a;

arr_angle_robot_mid = angle_robot_a(time_a_midpoint); 
arr_cos_angle_robot_a_mid = cos(arr_angle_robot_mid); 
arr_v_robot_mid = v_robot_a(time_a_midpoint); 
arr_func_x_mid = arr_v_robot_mid .* arr_cos_angle_robot_a_mid; 


%% midpoint Rule for x

Si_x_a = zeros(n_x_a, 1);
x_a = size(Si_x_a, 1); 
S = 0;
for i = 1:n_x_a
    Si_x_a(i) =  ( arr_func_x_mid(i) * dt_x_a );  
end
x_a(1) = Si_x_a(1);
for i = 2 : n_x_a
   x_a(i) = x_a(i-1) + Si_x_a(i);  
end

x_a(3000)
toc

%{
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
%}

%% Find y(t)
%vectors
arr_sin_angle_robot_a = sin(arr_angle_robot_a); 
arr_v_robot_a = v_robot_a(time_a);
arr_func_y = arr_v_robot_a .* arr_sin_angle_robot_a;


% vectors
%arr_cos_angle_robot_a = cos(arr_angle_robot_a); 
%arr_v_robot_a = v_robot_a(time_a);
%arr_func_x = arr_v_robot_a .* arr_cos_angle_robot_a;

%arr_angle_robot_mid = angle_robot_a(time_a_midpoint); 
arr_sin_angle_robot_a_mid = sin(arr_angle_robot_mid); 
%arr_v_robot_mid = v_robot_a(time_a_midpoint); 
arr_func_y_mid = arr_v_robot_mid .* arr_sin_angle_robot_a_mid; 


%% midpoint Rule for y

Si_y_a = zeros(n_x_a, 1);
y_a = size(Si_y_a, 1); 
S = 0;
for i = 1:n_x_a
    Si_y_a(i) =  ( arr_func_y_mid(i) * dt_x_a );  
end
y_a(1) = Si_y_a(1);
for i = 2 : n_x_a
   y_a(i) = y_a(i-1) + Si_y_a(i);  
end

%{
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
%}

%%
% midpoint graph... 
figure(1)

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
plot(plot_x_a,plot_y_a, 'r-')
xlabel('x (meter)')
ylabel('y (meter)')

title('Mobile Robot''s Trajectory Comparison of Midpoint Rule and MacLaurin Approximation');
hold on

grid on



format longEng; 
%% final result
fprintf('x(4) = %f (m) \n', x_a(size(x_a, 2)))
fprintf('y(4) = %f (m) \n', y_a(size(y_a, 2)))


%%
%%
% graphing x,y using MacLaurin Series in the same plane. 
hold on
time = 0:0.1:3; 
x_plot = x(time);
y_plot = y(time);

plot2 = plot(x_plot,y_plot,'b-')
grid on;

legend('Midpoint Rule', 'MacLaurin Series Approximation'); 
hold off



