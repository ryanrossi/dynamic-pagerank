function [c avg] = cumulative(X)
c = sum(X')';

tmax = size(X,2);
avg = c/tmax;
