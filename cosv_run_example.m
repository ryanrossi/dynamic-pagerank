%%
%Example Graphs
clear all
close all
load('data/example_graph.mat')

[ times, X, x_avg_pr ] = cosv_ff_ode45(P, A);



str = 'cosv_ff_4node_graph';
siz = [1 1 700 300];

plot(times,repmat(x_avg_pr,1,length(times)),'--', 'LineWidth',1,'Color','black'); hold on;
plot(times,X(:,1),'g', 'LineWidth',2); hold on;
plot(times,X(:,2),'m', 'LineWidth',2); hold on;
plot(times,X(:,3),'Color','b', 'LineWidth',2); hold on;
plot(times,X(:,4),'r','LineWidth',2); hold on;

Y = repmat(x_avg_pr,1,length(times))' + cos(repmat(times,1,size(P,1)))*diag((P*x_avg_pr));
plot(times,Y,':');
legend({'Avg PageRank'},'Location','NE');

D = X - repmat(x_avg_pr,1,length(times))';
% wait until convergence
D = D(ceil(3*end/4):end,:);
max(abs(D))

axis on
box off
grid off

%title(['$$v(t)_i = \frac{1}{n} \cos(t + i \frac{2 \pi}{n}) + \frac{1}{n}$$'],'interpreter','latex')
ylabel('PageRank', 'FontSize', 16);
xlabel('time', 'FontSize', 16);

min_value = min(min([X; x_avg_pr']));
max_value = max(max([X; x_avg_pr']));
%ylim([min_value-eps-0.01,max_value+eps])

%%
ind = 4;
D = X - repmat(x_avg_pr,1,length(times))';
times1 = times(ceil(3*end/4):end);
D = D(ceil(3*end/4):end,:);
max(abs(D));
plot(D(:,ind),'+-'); hold all;

phase = (1:n)*((2*pi)/n);
E = alpha*(1-alpha)/n*cos(repmat(phase,length(times1),1)+repmat(times1,1,size(P,1)));
plot(E(:,ind),'.--'); 

hold off;

%%
% Our conjectured solution is:
ind = 3;
z = ((1+1i)*eye(4)-alpha*P')\(exp(-1i*phase)'*(1-alpha)/n);
% then x(t) = real(z(t)*exp(i*t))
T = repmat(times,1,size(P,1));
Z = real(exp(1i*T)*diag(z))+repmat(x_avg_pr',length(times),1);
plot(times,X(:,ind),'.-',times,Z(:,ind),'+-');
