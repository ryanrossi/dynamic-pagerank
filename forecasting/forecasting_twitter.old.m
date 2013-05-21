
load data/twitter
Xdis = discretize(X,v);
d = difference_rank(Xdis);
[~,d_rank] = sort(d,'descend');

%experimental settings
m = 1000;
n_iter = 10;
theta = 0.3;
w = 5;
v_smoothed = smoothts(v, 'e', theta);
X_smoothed = smoothts(Xdis, 'e', theta);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%HIGHLY VOLATILE NODES (Non-stationary)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[xd_val xd_idx] = sort(x_dynamic,'descend');

clear avg_smape avg_mape smape
for iter=1:n_iter,
    if iter == 1,
        n_start = 1;
        n_forecasts = m;
    else
        n_start = n_start + m;
        n_forecasts = n_forecasts + m;
    end
    [avg_smape(iter,:)]  = forecasting_models( X_smoothed(d_rank(n_start:n_forecasts),:), ...
        v_smoothed(d_rank(n_start:n_forecasts),:), m )
end

%SMAPE
fprintf('avg_sMAPE = \n');
smape(1,:) = sum(avg_smape) / n_iter



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%STABLE NODES (relatively stationary)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear avg_smape avg_mape
for iter=1:n_iter,
    if iter == 1,
        n_start = 50000;
        n_forecasts = n_start + m;
    else
        n_start = n_start + m;
        n_forecasts = n_forecasts + m;
    end
    [avg_smape(iter,:)]  = forecasting_models( X_smoothed(d_rank(n_start:n_forecasts),:), ...
        v_smoothed(d_rank(n_start:n_forecasts),:), m )
end

%SMAPE
fprintf('avg_sMAPE = \n');
smape(2,:) = sum(avg_smape) / n_iter
