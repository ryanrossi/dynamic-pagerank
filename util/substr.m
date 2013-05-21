function outstr= substr(str, offset, len)

error(nargchk(2, 3, nargin));
n= length(str);
if offset<0, lb=max(offset + n + 1,1); 
elseif offset==0, lb=1;
else lb=offset; end

if nargin == 2, ub= n;
else                 
   if len >= 0, ub = lb + len - 1;
   else, ub = n + len; end
   ub= min(ub, n);
end
outstr= str(lb : ub);
