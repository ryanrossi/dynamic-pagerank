function [Tx Tv] = map_time_domain( X, v )
% maps Tx to the application time domain

tv_max = size(v,2);
tx_max = size(X,2);

s = tv_max / tx_max;
Tx = s : s : tv_max;

Tv = 1 : 1 : tv_max;




