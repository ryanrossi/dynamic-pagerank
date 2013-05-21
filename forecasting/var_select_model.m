function smape = var_select_model(x,y,max_lag)
% find the best model among a set, minimize AIC
%   - selects appropriate lag (for dpr and base)
%   - used to ensure prev preds
%   - can also be used for granger causality
%
% User-Specified Inputs:
%   x -- column vector of data
%   y -- column vector of data
%   alpha -- the significance level specified by the user
%   max_lag -- the maximum number of lags to be considered
%
% x and y are assumed to be already transformed for stationarity/scaled.
%
% todo: fixup codes, esp. ftest
% Note: codes are research prototypes and may not work for you, no
% promises!
%
% Granger Causality:
% -----------------------------
%  F   -- value of the F-statistic
%  c_v -- critical value from the F-distribution
%
%  If F > c_v we reject the null hypothesis that y does not
%  Granger Cause x
%
%  The optimal lag length is computed for x and y using BIC, then
%  the F-statistic is computed to test for Granger Causality, along 
%  with the critical value.
%

% Ryan A. Rossi, Purdue University
% Copyright 2012
%

if (length(x) ~= length(y))
    error('x and y must be the same length');
end

[a,b] = size(x);
if (b>a)
    x = x';
end

[a,b] = size(y);
if (b>a)
    y = y';
end

if max_lag < 1
    error('max_lag must be greater than or equal to one');
end

Y = full([x,y]);
n_timeseries = size(Y,2);
dt = logical(eye(n_timeseries));
t_estimation = 10; t_presample = 5;
RSS_R = zeros(max_lag,1);

clear AIC_YX LLF_YX W_YX np_YX np_unrestr_YX MSE_YX
i = 1;
while i <= max_lag,
    clear VAR2diag EstSpec_YX EstStdErrors_YX
    
    VAR2diag = vgxset('ARsolve',repmat({dt},2,1),'asolve',true(n_timeseries,1));
    
    Ypre = Y(1:t_presample,:);
    Yest = Y(t_presample+1:t_estimation,:);
    Yactual = Y((t_estimation+1):end,:);
    TF = size(Yactual,1);
    
    [EstSpec_YX,EstStdErrors_YX,LLF_YX(i)] = vgxvarx(VAR2diag,Yest,[],Ypre);
    [np_YX(i),np_unrestr_YX(i)] = vgxcount(EstSpec_YX);
    AIC_YX(i) = aicbic(LLF_YX(i),np_unrestr_YX(i));
    Yhat = vgxpred(EstSpec_YX,TF,[],Yest);
    MSE_YX(i) = sum((Yactual(:,2) - Yhat(:,2)).^2) / length(Yactual(:,2));
    SMAPE_YX(i) = smape(Yactual(:,2), Yhat(:,2));
    
    fprintf('[xy] lag=%d, aic=%f \n', i, AIC_YX(i));
    i = i+1;
end
[yx_aic yx_lag] = min(AIC_YX);

Y = full([y]);
n_timeseries = size(Y,2);
dt = logical(eye(n_timeseries));
RSS_R = zeros(max_lag,1);
clear AIC_Y LLF_Y W_Y np_Y np_unrestr_Y MSE_Y
i = 1;
while i <= max_lag,
    clear VAT2diag EstSpec_Y EstStdErrors_Y
    
    VAR2diag = vgxset('ARsolve',repmat({dt},2,1),'asolve',true(n_timeseries,1));
    
    Ypre = Y(1:4,:);
    Yest = Y(5:T,:);
    Yactual = Y((T+1):end,:);
    TF = size(Yactual,1);
    
    [EstSpec_Y,EstStdErrors_Y,LLF_Y(i)] = vgxvarx(VAR2diag,Yest,[],Ypre);
    [np_Y(i),np_unrestr_Y(i)] = vgxcount(EstSpec_Y);
    AIC_Y(i) = aicbic(LLF_Y(i),np_unrestr_Y(i));
    Yhat = vgxpred(EstSpec_Y,TF,[],Yest);
    MSE_Y(i) = sum((Yactual - Yhat).^2) / length(Yactual); %bad estimator
    SMAPE_Y(i) = smape(Yactual, Yhat);
    
    fprintf('[y] lag=%d, aic=%f \n', i, AIC_Y(i));
    i = i+1;
end
[y_aic y_lag] = min(AIC_Y);

smape = [SMAPE_YX(yx_lag), SMAPE_Y(y_lag)];

%
% todo: fixup codes
%
% F_num = ((LLF_YX(yx_lag).^2 - LLF_Y(y_lag).^2)/y_lag);
% F_den = LLF_Y(y_lag).^2 ./ (T-(yx_lag+y_lag+1));
% F = F_num/F_den;
% c_v = finv(1-alpha,y_lag,(T-(yx_lag+y_lag+1)));
% 
% 
% F_num = ((RSS_YX(yx_lag) - RSS_Y(y_lag))/y_lag);
% F_den = RSS_Y(y_lag)/(T-(yx_lag+y_lag+1));
% F = F_num/F_den;
% c_v = finv(1-alpha,y_lag,(T-(yx_lag+y_lag+1)));