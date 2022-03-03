%input 1      : each iteration display option (yes = 1)
%input 2      : convergence change point option (yes = 1)

%output 1     : rounded root arrays (accuracy default = 1E-6)
%output 2     : color arrays corresponding the roots
%output 3     : The number of roots (r1, r2, r3) arrays and the number of divergence
%               divergence means iteration reaches maximum iteration value

% This function is created to show 'basin of attraction'
% To see the illustration, call this function.
% Two Display options are needed (0 or 1): 
% If you want to see the iteration table,input 1 == 1
% if you want to see the convergence change point, input 2 == 1
% if you don't want, input == 0

% Example of Calling function : 
% [root, color, num_roots] = basin_Newton(0,0)

% Course Name  : MATH 2342
%                Gwang Sik Kim


%Created Date : Feb 20, 2021

function [ roundedRoot, color, Num_roots ] = basin_Newton (disOpt, disOpt2)

% range of x and y
xmin = -6;
xmax = 6;
ymin = -300;
ymax = 100;

%function declaration
f = @(x) x.^3 - 2 * x.^2 - 11 * x + 12; 
df = @(x) 3 * x.^2 - 4 * x - 11; 

% creating arrays
size_x = 1000;
x_domain = linspace(xmin, xmax, size_x)';
roundedRoot = zeros(size(x_domain)); % same size of arrays
color = zeros(size(x_domain)); % same size of arrays

% roots
r1 = 4;
r2 = 1;
r3 = -3;

%initialization and constants

iterMax = 10;
acc = 1E-6;

Num_r1 = 0;
Num_r2 = 0;
Num_r3 = 0;
Num_diverge = 0;

for i=1:size_x
    
    iter = 1;
    x_pre = x_domain(i);
    
    if disOpt == 1
        fprintf('\nThe present x = %f\n\n',x_pre)
    end
    
    while (iter<iterMax)
        
        y_pre = f(x_pre);
        dy_pre = df(x_pre);
        xnew = x_pre - ( y_pre / dy_pre);
        err = abs(y_pre);
        
        if disOpt==1
            
            disp('iteration             xold             xnew              err')
            fprintf('       %d        %.9f       %.9f       %.9f\n  ', iter, x_pre, xnew, err)
        end
        
        x_pre = xnew;
        iter = iter + 1;
        
        if err < acc
            break
        end
    end
    %root = xnew;
    %truncation
    roundedRoot(i) = round(xnew * (1/acc)) / (1/acc) ;
    
    %color outputs
    %r1 = 4 : green
    %r2 = 1 : blue
    %r3 = -3 : red
    %divergence : black
    
    if abs(roundedRoot(i) - r1) < acc
        color(i) = 'g'; 
        Num_r1 = Num_r1 + 1;
    elseif abs(roundedRoot(i) - r2) < acc
        color(i) = 'b'; 
        Num_r2 = Num_r2 + 1;
    elseif abs(roundedRoot(i) - r3) < acc
        color(i) = 'r'; 
        Num_r3 = Num_r3 + 1;
    else
        color(i) = 'k'; 
        Num_diverge = Num_diverge + 1;
    end
    
    if disOpt==1
        fprintf('\n******   The answer is %f   ******\n\n', roundedRoot(i));
    end
    

end

Num_roots = [Num_r1 ; Num_r2 ; Num_r3 ; Num_diverge]; 

if disOpt2 ==1
    for j=2: size_x
        
        if roundedRoot(j) ~= roundedRoot(j-1)
            disp('The convergence changes at :');
            fprintf('%f\n',x_domain(j))
        end
        
    end
end

%%%%%%%%   plotting   %%%%%%%% 
% basin of attraction

% row vector creation - size of the row is the number of each root
% initial elements are zeros
root1_col = zeros(1, Num_r1); 
y1_col = zeros(1,Num_r1);
root2_col = zeros(1, Num_r2);
y2_col = zeros(1,Num_r2);
root3_col = zeros(1, Num_r3);
y3_col = zeros(1,Num_r3);
div_col = zeros(1, Num_diverge);
ydiv_col = zeros(1,Num_diverge);

idx_r1 = 1;
idx_r2 = 1;
idx_r3 = 1;
idx_div = 1;
for k= 1: size_x

    if color(k) == 103 % 'g' = 103
        root1_col(idx_r1) = x_domain(k);
        idx_r1 = idx_r1 + 1;
    elseif color(k) == 98 % 'b' = 98
        root2_col(idx_r2) = x_domain(k);
        idx_r2 = idx_r2 + 1;
    elseif color(k) == 114 % 'r' = 114
        root3_col(idx_r3) = x_domain(k);
        idx_r3 = idx_r3 + 1;
    else
        div_col(idx_div) = x_domain(k); % 'k'
        idx_div = idx_div + 1;
    end
end 


% plot  
figure(1)

%axis range
axis([xmin, xmax, ymin, ymax]);

% graph of the function 
y_value = f(x_domain); 
plot(x_domain, y_value, 'color', 'm')
hold on
% color code for newton-method. 
plot(root1_col,y1_col, '.', 'color', 'g')
plot(root2_col,y2_col, '.', 'color', 'b')
plot(root3_col,y3_col, '.', 'color', 'r')
plot(div_col,ydiv_col, '.', 'color', 'k')
hold off

% title and labels
title('Basin of Attraction of Newton-Raphson Method')
xlabel('x')
ylabel('y')

legend('f(x)','converge towards x=4','converge towards x=1','converge towards x=-3', 'diverge','Location','southeast')

