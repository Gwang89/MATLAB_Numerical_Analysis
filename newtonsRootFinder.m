%Course Name: MATH 2342 			    Due Date: Friday Feb. 26, 2021 at 11:59pm
%Team member (Alphabetical order): 
%Ashleen Bains
%Gwang Sik Kim
%Joshua Selikem
%Noel Steves 

%Global Variables and Function Initiation
function [y]= newtonsRootFinder(funct,dfunct,initialguess,accuracy)
NewtonIterations = 0;
NewtonRoot = 0;
store = 0;
format short;

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
end