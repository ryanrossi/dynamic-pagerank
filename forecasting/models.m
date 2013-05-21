%simple forecasting models...
function avg_smape = models(X, v, n, Y)

tmax = size(X,2);

%only use a subset of nodes
Xt = X(1:n,:);
Vt = v(1:n,:);
Yt = Y(1:n,:);
warning off

for t=2:tmax-1,

    %============================================================
    % Dynamic PageRank model
    % (incorporates graph and pageviews)
    %============================================================
 
    Xs = Xt(:,1:t-1);
    Vs = Vt(:,1:t-1);
    Xs = [Vs Xs];
    Ys = Vt(:,t);
    %y = Vt(:,t+1);
    
    b = glmfit(Xs,Ys);
    yhat_dpr(:,t+1) = glmval(b, [Vt(:,2:t) Xt(:,2:t)],'identity');
    
    clear Ys y b Xs

   
    %============================================================
    % Base model (use only pageviews to predict future pageviews)
    %============================================================
    Xs = Vt(:,1:t-1);
    Ys = Vt(:,t);
    %y = Vt(:,t+1);
    
    b = glmfit(Xs,Ys);
    yhat_baseline_window(:,t+1) = glmval(b, Vt(:,2:t),'identity');
        
    clear Ys y b Xs
    
end

if nargin > 3, y = Yt(:,3:tmax);
else y = Vt(:,3:tmax);
end

%evaluate predictions
avg_dpr = smape(y,yhat_dpr(:,3:tmax));
avg_baseline_window = smape(y,yhat_baseline_window(:,3:tmax));

avg_smape = [avg_dpr avg_baseline_window];

warning on