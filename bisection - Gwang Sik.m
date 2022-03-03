function [sol, err] = bisection(f, xa, xb, acc, max_i)
% this function is to find x value to satisfy f(x) = 0 by bisection method
% this function is able to input 3 to 5 variables 
% f is function that want to solve, whose format should be f(x) = 0
% xa is the minimum interval 
% xb is the maximum interval
% acc and max_i are optional variables
% acc is accuracy. default set is 1E-6 
% max_i is the maximum iteration for bisection method
% this function returns three outputs
% sol_x is the final value of x with accuracy
% new_xa is the new minimum value of interval left after calculation
% new_xb is the new maximum value of interval left after calculation

% Made by Mechatronics and Robotics Students for MATH 1342 FALL 2020 
% Written by Gkim 
% The Latest Revision on Oct. 20. 2020.


func_eq = f;


% when input variables are three, accuracy is set as default 
if nargin == 3 || nargin ==4
        disp('You did not input maximum iteration. The default maximum iteration is 30.')
        max_i = 30;
    if nargin == 3
        disp('You did not input accuracy value. The default accuracy is 1E-6.')
        % acc=0.000001 as default
        acc=1E-6;
    end
end


% when input variables are too little
if nargin == 2 || nargin == 1
    disp('*** ERROR ***')
    disp('You did not input initial values properly. Please input two initial values for interval.')
    return
end

% when input varialbes are too many
if nargin > 6
    disp('*** ERROR ***')
    disp('You input too many varialbes. Please try it again.')
    return
end


% if user types xb < xa
% swap xa and xb 
% and keep calculating 
if xb < xa
    disp('your maximum value of interval is smaller than minimum.')
    temp1 = xa;
    temp2 = xb;
    xa = temp2;
    xb = temp1;
    disp('swapped two values.')
elseif xb == xa
    % if user types same numbers 
    % stop the program    
    err2='you typed same values for intervals. please try it again.';
    disp(err2)
    return
end


final_x = 0;



fprintf('iteration            xa                      xb                  xc                 yc\n')

for i = 1 : max_i
    xc = (xa+xb)/2;

    if xc == 0
        disp('*** ERROR ***')
        disp('The midpoint of the initial interval cannot be zero. Choose another interval, please.')
        return
    end
        
    ya = func_eq(xa);
    yb = func_eq(xb);
    yc = func_eq(xc);



    identifier =  ya * yb;
    identifier2 = ya * yc;
    fprintf('    %d             %f              %f             %f           %f\n', i, xa, xb, xc, yc)
    
    % bisection method
    if abs(yc) < acc
        final_x = xc;
        break;
    end
    if identifier > 0
        if identifier2 > 0
            % case 1: y(xa) * y(xb) > 0, y(xa) * y(xc) > 0
            % cannot find the solution by bisection
            % it does not mean there is no solution in the interval
            % need to try to set another interval
            fprintf('cannot find solutions between %4.5f and %4.5f\n', xa, xb)
            disp('try to set a different initial interval')
            break
            
        elseif identifier2 < 0
            % case 2: y(xa) * y(xb) > 0, y(xa) * y(xc) < 0
            % Between xa and xc, there is a root
            % new interval : [xa xc]
            % xb is assigned as the value of xc
            xb=xc;
        else
            % Possibly, if find the exact solution by any chance
            %     y(xa) * y(xc) = 0
            % <=> identifier2 = 0
            % xc is the exact solution
            final_x = xc; 
            fprintf('found the exact solution, x = %4.5f\n', final_x)
            break
        end
    elseif identifier < 0
        if identifier2 > 0
            % case 3: y(xa) * y(xb) < 0, y(xa) * y(xc) > 0
            % Between xc and xb, there is a root
            % new interval : [xc xb]
            % xa is assigned as the value of xc
            xa=xc;
        elseif identifier2 < 0
            % case 4: y(xa) * y(xb) < 0, y(xa) * y(xc) < 0
            % Between xa and xc, there is a root
            % new interval : [xa xc]
            % xb is assigned as the value of xc
            xb=xc;
        else
            % Possibly, if find the exact solution by any chance
            %     y(xa) * y(xc) = 0
            % <=> identifier2 = 0
            % xc is the exact solution 
            final_x = xc;
            fprintf('found the exact solution, x = %4.5f\n', final_x)
            break
            
        end
    else
        % identifier = 0
        % one of initial values is the exact solution
        if ya  == 0
            % ya = 0
            % xa is the exact solution 
            final_x = xa;
            fprintf('found the exact solution, x = %4.5f\n', final_x)
            break
        else
            % yb = 0
            % xb is the exact solution
            final_x = xb;
            fprintf('found the exact solution, x = %4.5f\n', final_x)
            break
        end
    end
    
end

if identifier > 0 && identifier >0
    return
else
    if i < max_i
        fix_final_x = fix(final_x * 10^abs(log10(acc))) / 10^abs(log10(acc));
        fprintf('Reached the desired accuracy. The answer is %f.\n',fix_final_x)
    else
        disp('iteration reached maximum, but cannot find the solution. set a better initial interval or increase the iteration setting.')
        if abs(ya) < abs(yb)
            final_x = xa;
        else
            final_x = xb;
        end
        fix_final_x = fix(final_x * 10^abs(log10(acc))) / 10^abs(log10(acc));
        fprintf('The best answer is %f (accuracy 1E-6).\n', fix_final_x)
    end
end
   
% returning final value x with the accuracy is the answer 
sol = final_x;
% returning the error, yc 
err = abs(yc); 


end

