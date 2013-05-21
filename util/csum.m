function s=csum(x)
% CSUM Sum of elements using a compensated summation algorithm
%
% For large vectors, the native sum command in Matlab does not appear to
% use a compensated summation algorithm which can cause significant round
% off errors.
%
% This code implements a variant of Kahan's compensated summation algorithm
% which often takes about twice as long, but produces more accurate sums 
% when the number of elements is large.
%
% See also SUM
%
% Example:
%   v=rand(1e7,1);
%   sum1 = sum(v);
%   sum2 = csum(v);
%   fprintf('sum1 = %18.16e\nsum2 = %18.16e\n', sum1, sum2);

% David Gleich
% Copyright, Stanford University, 2008-2009

% 2008-05-01: Initial version based on other codes.
% 2009-06-03: Integrated version to work on big and small problems efficiently

s=0; e=0; temp=0; y=0; i=1; numelx= numel(x);
if numelx<2^31
    % for loops are a bit faster, when they work
    for i=1:numel(x)
        temp=s; y=x(i)+e; s=temp+y; e=(temp-s)+y;
    end
else    
    while i<=numelx
        temp=s; y=x(i)+e; s=temp+y; e=(temp-s)+y;
        i=i+1;
    end
end
