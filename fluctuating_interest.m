%% Show an example of dynamic PageRank with fluctuating interest
% This is the example from the paper

A = [ 0     0     1     0
      0     0     1     0
      0     1     0     1
      1     1     0     0];

P = (diag(1./sum(A,2))*A)';
n = size(P,1);
alpha = 0.85;
V = eye(n);

phase = (2*pi/n*(0:n-1))';

f = @(t,y) (1-alpha)*1/n*V*(cos(t+phase)+1) - y + alpha*P*y;

x0 = f(0,zeros(n,1))/(1-alpha);

[times,X] = ode23s(f, [0,20], x0);
plot(times,X,'LineWidth',1.5)

xbar = (eye(n)-alpha*P)\((1-alpha)*mean(V,2));
hold on;
plot(times,repmat(xbar,1,length(times)),'--','LineWidth',1);

xlabel('time');
ylabel('Dynamic PageRank');
legend('Page 1', 'Page 2', 'Page 3', 'Page 4','Location','EastOutside');
legend boxoff;
box off;

hold off;

pp = get(gcf,'PaperPosition');
pp([3,4]) = [5,2];
set(gcf,'PaperPosition', pp);
print('web/cos_ff.eps','-depsc2');


%%
% Our solution is:
ind = 1;
z = ((1+1i)*eye(n)-alpha*P)\((1-alpha)*1/n*V*exp(1i*phase));
% then x(t) = real(z(t)*exp(i*t))
T = repmat(times,1,size(P,1));
Z = real(exp(1i*T)*diag(z))+repmat(xbar',length(times),1);
plot(times,X(:,ind),'.-',times,Z(:,ind),'+-');

%%
abs(z)