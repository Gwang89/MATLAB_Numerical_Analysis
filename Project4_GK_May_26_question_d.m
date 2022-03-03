%%
%              	MATH 2342
%               Project 4 : mobile robot (cont'd)
%               question d
%   created by...
%               Gwang Sik Kim

%   Created Date : May 26, 2021
%   Revised      : May 26, 2021

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

Mx(t) = v * cos(angle)
My(t) = v * sin(angle) 
% x(t) = x_zero + int(Mx,t,a,b) <== cannot do it analytically. 



%%
% Error in MacLaurin Series
% En = max ( diff(f,z,n+1) * x^n+1  /  (n+1)!  )
% for x, considering n = 3, since we deal with 4 non-zero terms before... 
% for y, considering n = 4, since we deal with 4 non-zero terms before 
% (a0 for y is zero.... )

Err_Mx4(z,t) = diff(Mx(z),4) * power(t,4) / factorial(4) ;
Err_My5(z,t) = diff(My(z),5) * power(t,5) / factorial(5) ;
time = linspace(0,3, 3000);

%%
% Error of Mx(t)
valx = zeros(3, size(time, 2)); % evaluation value

Err_max_x = zeros(1,3);
index_x = zeros(1,3);

for h = 1 : 3
    for i=1 : 1000 * h
        valx(h, i) = Err_Mx4(time(i), h);
    end
    Err_max_x(h) = max(abs(valx(h,:)));

end

%%
% similarly... Error of My(t)
valy = zeros(3, size(time, 2)); % evaluation value

Err_max_y = zeros(1,3);
index_y = zeros(1,3);

for h = 1 : 3
    for i=1 : 1000 * h
        valy(h, i) = Err_My5(time(i), h);
    end
    Err_max_y(h) = max(abs(valy(h,:)));
end

% To see the results... 
Err_max_x
Err_max_y

%%
% graphing to check ... 
disp = 0;
if disp == 1

    figure(1)
    plot(time, valx(1,:), 'r')
    axis([0, 1, -1, 1])

    xlabel('time (second)');
    ylabel('Error of Mx(t) in MacLaurin Series for n = 4');
    title('Error of Mx(t) in MacLaurin Series for 4 non-zero terms when t = 1');


    figure(2)
    plot(time, valx(2,:), 'r')
    axis([0, 2, -15, 15])

    xlabel('time (second)');
    ylabel('Error of Mx(t) in MacLaurin Series for n = 4');
    title('Error of Mx(t) in MacLaurin Series for 4 non-zero terms when t = 2');


    figure(3)
    plot(time, valx(3,:), 'r')
    axis([0, 3, -70, 70])

    xlabel('time (second)');
    ylabel('Error of Mx(t) in MacLaurin Series for n = 4');
    title('Error of Mx(t) in MacLaurin Series for 4 non-zero terms when t = 3');

    figure(4)
    plot(time, valy(1,:), 'g')
    axis([0, 1, -1, 0])

    xlabel('time (second)');
    ylabel('Error of My(t) in MacLaurin Series for n = 5');
    title('Error of My(t) in MacLaurin Series for 4 non-zero terms when t = 1');

    figure(5)
    plot(time, valy(2,:), 'g')
    axis([0, 2, -20, 5])
    xlabel('time (second)');
    ylabel('Error of My(t) in MacLaurin Series for n = 5');
    title('Error of My(t) in MacLaurin Series for 4 non-zero terms when t = 2');

    figure(6)
    plot(time, valy(3,:), 'g')
    axis([0, 3, -150, 40])

    xlabel('time (second)');
    ylabel('Error of My(t) in MacLaurin Series for n = 5');
    title('Error of My(t) in MacLaurin Series for 4 non-zero terms when t = 3');

end

