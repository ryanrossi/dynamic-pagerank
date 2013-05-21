function avg_smape = var_model(y,nlag,nfor,begf,yactual)
% estimates a simple VAR model of order n 
% and produces f-step-ahead forecasts
%
% Ryan A. Rossi, Purdue University
% Copyright 2012
%

[a,b] = size(y);
if (b>a)
    y = y';
end

if nlag < 1
    error('nlag must be greater than or equal to one');
end

tmax = size(y,1);
series = size(y,2);
dt = logical(eye(series));
t_est = begf;

i = 1;
for t=t_est:tmax-1,
    t_pre = floor(t/2);
    VAR2diag = vgxset('ARsolve',repmat({dt},2,1),'asolve',true(series,1));
    
    ypre = y(1:t_pre,:); 
    yest = y(t_pre+1:t,:);
    yact = yactual((t+1):end,:); 

    model = vgxvarx(VAR2diag,yest,[],ypre); 
    yhat = vgxpred(model,nfor,[],yest); 
    
    SMAPE(i) = smape(yact(:), yhat(:,1)); i = i + 1;
end
avg_smape = mean(SMAPE);
