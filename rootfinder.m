%Global Variables and Function Initiation
%Course Name: MATH 2342 			    Due Date: Friday Feb. 26, 2021 at 11:59pm

%Gwang Sik Kim


function [y]= rootfinder(funct,dfunct, leftpoint,rightpoint,initialguess,accuracy)
BisectionIterations = 0;
BisectionRoot = 0;
NewtonIterations = 0;
NewtonRoot = 0;
store = 0;
format short;

%Bisection Method
if funct(leftpoint)*funct(rightpoint)> 0
    disp('Incorrect input')
    return
else 
    xleft = leftpoint;
    xright = rightpoint;
    xmiddle = ((xleft+xright)/2);
end

%Bisection Initiation
tic;%Timer start
xmiddlenew = xmiddle;
while (abs(funct(xmiddlenew)) > accuracy)
      if funct(xleft)*funct(xmiddle)<0
         %xleft = xleft;
         xright = xmiddle;
      elseif funct(xleft)*funct(xmiddle)>0
         xleft = xmiddle;
         %xrght = xright;
      elseif funct(xleft)*funct(xmiddle)==0
         %Jump out of loop to display result
         break
      end
       
       xmiddle = ((xleft+xright)/2);
       xmiddlenew = xmiddle;
       BisectionIterations = BisectionIterations + 1;
end
    BisectionRoot = round(xmiddlenew,4) %Displays the result with specified accuracy
    display(BisectionIterations) %Display number of Iterations
    time = toc %Display the Time it took to calculate Bisection Method

    
    
%Newton's Method
tic; %start timer
xnew = initialguess;
err = 1;
while(err > accuracy)
      store = xnew;
      xnew = store - funct(xnew)/dfunct(xnew);
      NewtonIterations = NewtonIterations + 1;
      err = abs(funct(xnew));
end

    NewtonRoot = round(xnew, 4) %Displays the result with specified accuracy
    display(NewtonIterations)%Display number of Iterations
    time2 = toc %Display the Time it took to calculate Bisection Method 
end
