%%
%              	MATH 2342
%               Project 4 : mobile robot (cont'd)
%               question g
%   created by...
%               Abraham San Jose III
%               Ashleen Bains
%               Eugene Bodnarchuk     
%               Gwang Sik Kim
%               Joshua Selikem
%               Noel Steves 
%               Thutazaw

%   Created Date : May 28, 2021
%   Revised      : May 28, 2021

%%
L = 0.5;         % length between two wheels
x_zero =  0;
y_zero = 0;
theta_zero = 0;
a = 0;

syms t z;
b = t;

v_right = @(t) 2 - 0.5 .* t; % part d
v_left = 1;   % part c and d

v = @(t) (v_right(t) + v_left) / 2; 
w = @(t) ( v_right(t) - v_left ) / L; 

angle = theta_zero + int(w,t);

Mx(t) = v * cos(angle) % function inside of integral...
My(t) = v * sin(angle) % function inside of integral... 
% x(t) = x_zero + int(Mx,t,a,b) <== cannot do it analytically. 


%%
% Error in MacLaurin Series
% t=3, accuracy = 0.01, what number should be for least n? 

%%%%%%%%%%%%%%
% !!!!caution!!!! 
% the calculation is very inefficient and it takes more than 10 minutes.
%%%%%%%%%%%%%%
time = linspace(0,3, 1000);
Err_max_x = zeros(size(time));

acc = 0.01; 
n=1;

while(1)

    Err_xn(z) = diff(Mx(z),n) * power(3,n) / factorial(n); 

    valx = zeros(1,size(time,2));
    for i=1:size(time,2)
        valx(i) = Err_xn(time(i));
    end

    Err_max_x(n) = max(abs(valx));
    fprintf("Max Error in Mx is %f when n = %d\n", Err_max_x(n), n) 
    
    if Err_max_x(n) > acc
        n= n+1;
    else
        break;
    end
end

% the result shows that the least n = 43


%%
% similarly... Error of My(t)
Err_max_y = zeros(size(time));

%%%%%%%%%%%%%%
% !!!!caution!!!! 
% the calculation is very inefficient and it takes more than 10 minutes.
%%%%%%%%%%%%%%

n = 1;
while(1)
    Err_yn(z) = diff(My(z),n) * power(3,n) / factorial(n); 

    valy = zeros(1,size(time,2));
    for i=1:size(time,2)
        valy(i) = Err_yn(time(i));
    end

    Err_max_y(n) = max(abs(valy));
    fprintf("Max Error in My is %f when n = %d\n", Err_max_y(n), n) 
    
    if Err_max_y(n) > acc
        n= n+1;
    else
        break;
    end
end


% the result shows that the least n = 42

% so, Mx and My need to be more than 43, 42 terms of MacLaurin Series 
% to be smaller than 0.01 accuracy. 

%%
% graphing to check ... 
disp = 1;
if disp == 1

    figure(1)
    n_axis_x = linspace(1,43, 43); 
    Err_max_x_plot = zeros(1, 43);
    for i = 1:43
       Err_max_x_plot(i) = Err_max_x(i); 
    end
    plot1 = plot(n_axis_x, Err_max_x_plot, 'r')
    xlim([0, 43])

    datatip(plot1, 43, Err_max_x_plot(43))
    grid on;
    xlabel('n');
    ylabel('Maximum Error of Mx according to n');
    title('Maximum Error of Mx of MacLaurin Series for n non-zero terms when t = 3');
    
    figure(2)


    n_axis_y = linspace(1,42, 42); 
    Err_max_y_plot = zeros(1, 42);
    for i = 1:42
       Err_max_y_plot(i) = Err_max_y(i); 
    end
    plot2 = plot(n_axis_y, Err_max_y_plot, 'r')
    xlim([0, 42])

    datatip(plot2, 42, Err_max_y_plot(42))
    grid on;
    xlabel('n');
    ylabel('Maximum Error of My according to n');
    title('Maximum Error of My of MacLaurin Series for n non-zero terms when t = 3');

end

