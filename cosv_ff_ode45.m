function [ times, X, x_avg_pr ] = cosv_ff_ode45( P, A )


n = size(P,1);
alpha = 0.1;
period = 1;
tspan = [0 200/period];

e = ones(n,1)/n;
%x = rand(n,1); x = x/sum(x);
x = e;

[times,X] = ode23s(@(t,x) func_cos_bound(t,x,P,alpha,n,period), tspan, x);


% x_avg_pr = pagerank(A);
x_avg_pr = (speye(n) - alpha*P')\e;
x_avg_pr = x_avg_pr/sum(x_avg_pr);

end


function [ y ] = func_cos_bound( t,x,P,alpha,n,period )

v = (1/n) * cos(period*t + (1:n)*((2*pi)/n))' + (1/n);

y = (1-alpha)*v - (eye(n) - alpha*P')*x;

end