% Modified Secant Method
% Secant method is a modified Newton-Raphson Method
% when the implicit function or transcendental function is there, 
% we can use approximated slope for the tangent line

% Course Name  : MATH 2342
%                Gwang Sik Kim


% Created Date : Feb 20, 2021


%% Define Function 
syms x;
f= @(x) nthroot(x-4,5)-0.25;

%% Define x0, es 
x=4; %the X domain of the function is x>=4. So, we start at x=4. 
es=2e-10; %es is a scarborough number
    
%% Modified Secant Method 
iter=0; %Setting iteration Max
dx=0.0001;

while(1)
    x_old=x;
    iter=iter+1;
    x=x-dx*f(x)/(f(x+dx)-f(x));
    ea=abs((x_old-x)/x)*100;
   
if ea<es
    if iter~=1
    break
    end
end
    x_old=x;

end

Root=x; %Root = x (desired Numerical answer for the function)


%% DIsplay
disp([' Root : ' sprintf('%i',Root)]) % the numerical answer
disp([' Rounded Root (accuracy : 1E-4) : ' sprintf('%.4f',Root)]) % rounded answer
