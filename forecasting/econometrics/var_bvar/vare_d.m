% PURPOSE: An example of using vare, pgranger, prt_var,plt_var
%          to estimate a vector autoregressive model
%          report Granger-causality results, print and plot                                                 
%---------------------------------------------------
% USAGE: vare_d
%---------------------------------------------------

addpath('/Users/ryarossi/dynamic_pagerank/code/causality/econometrics')
addpath('/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/util')
addpath('/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/var_bvar')
addpath('/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/regress')
addpath('/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/diagn')
addpath('/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/distrib')
addpath('/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/gibbs')
addpath('/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/graphs')
addpath('/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/optimize')
addpath('/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/ts_aggregation')

savepath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/diagn'
savepath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/distrib'
savepath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/gibbs'
savepath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/graphs'
savepath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/optimize'
savepath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/ts_aggregation'
savepath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/util'
savepath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/var_bvar'
savepath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/regress'
savepath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/'

rmpath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/diagn'
rmpath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/distrib'
rmpath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/gibbs'
rmpath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/graphs'
rmpath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/optimize'
rmpath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/ts_aggregation'
rmpath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/util'
rmpath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/var_bvar'
rmpath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/regress'
rmpath '/Users/ryarossi/dynamic_pagerank/code/causality/econometrics/'

savepath '/Users/ryarossi/dynamic_pagerank/code/var/'
addpath('/Users/ryarossi/dynamic_pagerank/code/var/')

addpath('/Users/ryarossi/dynamic_pagerank/code/')
savepath '/Users/ryarossi/dynamic_pagerank/code/'



load test.dat; % a test data set containing
               % monthly mining employment for
               % il,in,ky,mi,oh,pa,tn,wv
% data covers 1982,1 to 1996,5
y = test;
     
nlag = 2;  % number of lags in var-model

% estimate the model
results = vare(y,nlag);

vnames =  ['illinois     ',
           'indiana      ',    
           'kentucky     ',    
           'michigan     ',    
           'ohio         ',    
           'pennsylvania ',    
           'tennessee    ',    
           'west virginia'];
     

prt(results,vnames);
cutoff = 0.01;
pgranger(results,vnames,cutoff);
plt(results,vnames);

