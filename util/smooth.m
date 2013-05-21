function v_s = smooth(v, lag)

if nargin < 2,
   lag = 5; 
end

v_s = smoothts(v, 'e', lag); %default is theta = 0.3333 and window = 5
v_s = normcols(v_s);

