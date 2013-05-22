function [X dpr_info dpr_sol] = dynamic_pagerank(A,v,optionsu)
% Computes the Dynamic PageRank for a directed graph and
% a sequence of teleportation vectors.
%
% Input:
%   A:  n x n   adjacency matrix
%   v:  n x t   column normalized matrix where t is the number of timesteps
%
% Output:
%   X:  n x t   Time-series of Dynamic PageRanks
%               Each column corresponds to the solution at time t
%
%
% options struct specifies optional parameters:
% -----------------------------------------------------------------
%   options.alpha: the teleportation coefficient [double | {0.85}]
%   options.scale: the timescale for each v(t)
%   options.verbose: extra output information [{0} | 1]
%
%   options.alg: force the algorithm type
%     ['rk45' | 'rk45-smooth' | 'rk23' | 'rk23-smooth' | 'adams' | ...
%      'adams-smooth' | 'power-euler']
%
%   options.theta: smoothing parameter
%       -1 indicates no smoothing (default)
%       theta usually ranges from [0,1]
%
%   options.h: stepsize, currently only used for forward_Euler, since other
%              methods are adaptive
%
%   options.initial_value: input start set this field to use
%
%   v is currently assumed to be normalized
%   todo: add code to normalize, csum
%
%
% Examples:
%   opts = struct('alg', 'rk45-smooth');
%   [X dpr_info dpr_sol] = dynamic_pagerank(A,normcols(v),opts);
%
%   v = normcols(v);
%   X = dynamic_pagerank(A,v);
%
%
%
% Implementation of Dynamic PageRank, if used please cite the paper:
%    Ryan Rossi and David Gleich: Dynamic PageRank using
%    Evolving Teleportation, WAW2012, LNCS, Springer, 2012.
% 
%
% Ryan Rossi, David Gleich
% Copyright 2012, Purdue University
%


[m n] = size(A);
if (m ~= n)
    error('pagerank:invalidParameter', 'the matrix A must be square');
end;

options = struct('alg', 'rk45', 'alpha', 0.85, 'theta', 0.5, 'scale',4, 'sample', 4, 'h', .01, 'verbose', 0);

if (nargin > 2)
    options = merge_structs(optionsu, options);
end;

if options.sample == 0, %default returns ONE solution per change in v
   options.sample = options.scale; 
end


if (size(v) ~= size(A,1))
    error('pagerank:invalidParameter', ...
        'the vector v must have the same size as A');
end;


if (~issparse(A))
    A = sparse(A);
end;


if (isfield(options, 'x0'))
    if (isa(options.x0,'char') == 1),
        if strcmp(options.x0,'pr'),
            fprintf('setting x(0) to the solution of static pagerank using v(0) \n');
            x = set_initial_value(A,v);
            x(1:10)
            options.x0 = x;
        end
    end
else
    fprintf('x(0) not set, using v(0) as initial value \n');
    options.x0 = v(:,1); 
end

% fix dangling vertices
out_deg = A*ones(size(A,1));
d_verts = find(out_deg == 0);
if (isempty(d_verts)) 
    A = A + dangling(d)*ones(1,n)/n;
end

assert(isempty( find( A*ones(size(A,1)) == 0 ) ));

% normalize the matrix
P = normout(A);

switch (options.alg)
    case 'rk45'
        [X dpr_info dpr_sol] = dpr_RungeKutta(P, v, options);
    case 'rk23'
        [X dpr_info dpr_sol] = dpr_RungeKutta(P, v, options);
    case 'adams'
        [X dpr_info dpr_sol] = dpr_RungeKutta(P, v, options);
    case 'rk45-smooth'
        [X dpr_info dpr_sol] = dpr_RK_smoothed(P, v, options);
    case 'rk23-smooth'
        [X dpr_info dpr_sol] = dpr_RK_smoothed(P, v, options);
    case 'adams-smooth'
        [X dpr_info dpr_sol] = dpr_RK_smoothed(P, v, options);
    case 'euler'
        [X dpr_info dpr_sol] = dpr_forward_Euler(P, v, options);
    case 'power-euler'
        [X dpr_info] = dpr_power(P, v, options);
    otherwise
        error('pagerank:invalidParameter', ...
            'invalid computation mode specified.');
end;





% ========================================
% Dynamic PageRank Runge-Kutta Methods
% ========================================
function [X dpr_info dpr_sol] = dpr_RungeKutta(P, v, options)
fprintf('computing dynamic pagerank with %s...\n',options.alg);

dpr_info = struct();
dpr_info.method = options.alg;

alpha = options.alpha;
dpr_info.alpha = alpha;

theta = options.theta
dpr_info.theta = theta;

x = options.x0;

n = size(v,1);
dpr_info.verts = n;

dv = options.scale;                  %relationship between dy_sys time and app time
sample = options.sample;             %solutions to return
t_app = size(v,2);                   %application timescale: num times v changes
tmax = dv * t_app;                   %max ode time, for all changes in v
tspan = eps(1) : sample : tmax;      %interval indicating when solutions will be saved

dpr_info.dv = dv;
dpr_info.sample = sample;
dpr_info.tv_max = t_app;
dpr_info.tmax = tmax;
dpr_info.tspan = tspan;
dpr_info

sec = tic;
%dprfun = @(t,y) (1-alpha)*deval(sol, t) + alpha*(P'*y)-sum((1-alpha)*deval(sol, t)+ alpha*(P'*y))*y;
dpr_ode = @(t,y) dpr_fun(t,y,P,alpha,v,dv);
if strcmp('rk45',options.alg)
    dpr_sol = ode45(dpr_ode, tspan, x);
elseif strcmp('rk23',options.alg),
    dpr_sol = ode23(dpr_ode, tspan, x);
elseif strcmp('adams',options.alg),
    dpr_sol = ode113(dpr_ode, tspan, x);
end
dpr_info.runtime = toc(sec);

X = deval(dpr_sol,tspan);
%fprintf('X has %d verts, %d points in time \n',size(X,1),size(X,2));


% ===================================
% PageRank dynamical system
% ===================================
function dy = dpr_fun(t,y,P,alpha,v,dv)
i = ceil((t+eps)/dv);
z =  (1-alpha)*v(:,i) + alpha*(P'*y);
dy = z - sum(z)*y;



% if strcmp('rk45',options.alg)
%     dpr_sol = ode45(@(t,y) dpr_fun(t,y,P,alpha,v,dv), tspan, x);
% elseif strcmp('rk23',options.alg),
%     dpr_sol = ode23(@(t,y) dpr_fun(t,y,P,alpha,v,dv), tspan, x);
% end

%i = ceil((t+eps)/dv);
%dy = (1-alpha)*v(:,i) - x + alpha*(P'*x) + (sum(v(:,i))-sum(x))*x;
% if options.verbose == 1,
%     fprintf('ode_time=%2.6f, app_time=%d, in %2.6f sec \n',t,i,toc);
% end;

%(1-alpha)*deval(v_sol, t) - y + alpha*(P'*y) + (sum(deval(v_sol, t))-sum(y))*y;
%y = (1-alpha)*v(:,i) - (speye(n) - alpha*P')*x;








% ===============================================
% Dynamic PageRank Smoothed Runge-Kutta Methods
% ===============================================
function [X dpr_info dpr_sol] = dpr_RK_smoothed(P, v, options)
fprintf('computing dynamic pagerank with %s...\n',options.alg);

dpr_info = struct();
dpr_info.method = options.alg;

alpha = options.alpha;
dpr_info.alpha = alpha;

theta = options.theta;
dpr_info.theta = theta;

x = options.x0;

n = size(v,1);
dpr_info.verts = n;


dv = options.scale;          %relationship between dy_sys time and app time
sample = options.sample;          %solutions to return
t_app = size(v,2);                %application timescale: num times v changes
tmax = dv * t_app;                %max ode time, for all changes in v
tspan = eps(1) : sample : tmax;   %interval indicating when solutions will be saved


dpr_info.dv = dv;
dpr_info.sample = sample;
dpr_info.tv_max = t_app;
dpr_info.tmax = tmax;
dpr_info.tspan = tspan;
dpr_info


ode_smoother = @(t,y) theta*(v(:,ceil((t+eps)/dv))-y); %exp smoothing operator
vsol = ode45(ode_smoother, [eps(1),tmax], v(:,1));


sec = tic;
dpr_ode = @(t,y) dpr_fun_smoothing(t,y,P,alpha,vsol);
if strcmp('rk45-smooth',options.alg)
    dpr_sol = ode45(dpr_ode, tspan, x);
elseif strcmp('rk23-smooth',options.alg),
    dpr_sol = ode23(dpr_ode, tspan, x);
elseif strcmp('adams-smooth',options.alg),
    dpr_sol = ode113(dpr_ode, tspan, x);
end
dpr_info.runtime = toc(sec);

X = deval(dpr_sol,tspan);
%fprintf('X has %d verts, %d points in time \n',size(X,1),size(X,2));



function dy = dpr_fun_smoothing(t,y,P,alpha,vsol)
z =  (1-alpha)*deval(vsol, t) + alpha*(P'*y);
dy = z - sum(z)*y;


%dpr_ode = @(t,y) (1-alpha)*deval(v_sol, t) - y + alpha*(P'*y) + (sum(deval(v_sol,t))-sum(y))*y;

% ======================================
% PageRank dynamical system (smoothed)
% ======================================
% function [ y ] = dpr_sys_smoothing( t,x,P,v,alpha,n,dv )
% tic
% i = ceil((t+eps)/dv);
% y = (1-alpha)*v(:,i) - x + alpha*(P'*x);
% %y = (1-alpha)*v(:,i) - (speye(n) - alpha*P')*x;
% fprintf('ode_time=%2.6f, app_time=%d, in %2.6f sec \n',t,i,toc);










% ===============================================
% Dynamic PageRank Forward Euler
% todo: fixup code
% ===============================================
function [X dpr_info dpr_sol] = dpr_forward_Euler(P, v, options)
fprintf('computing dynamic pagerank with %s...\n',options.alg);

dpr_info = struct();
dpr_info.method = options.alg;

h = options.h;
dpr_info.h = h;

alpha = options.alpha;
dpr_info.alpha = alpha;

theta = options.theta;
dpr_info.theta = theta;

x = options.x0;

n = size(v,1);
dpr_info.verts = n;

if options.verbose == 1,
    mkdir('data');
end

dv = options.scale;         %relationship between dy sys time and app time
sample = options.sample;         %solutions to return
t_app = size(v,2);               %application timescale: num times v changes
tmax = dv * t_app;               %max ode time, for all changes in v
tspan = eps(1) : sample : tmax;  %interval indicating when solutions will be saved

dpr_info.dv = dv;
dpr_info.sample = sample;
dpr_info.tv_max = t_app;
dpr_info.tmax = tmax;
dpr_info.tspan = tspan;
dpr_info

dpr_sol = struct();
dpr_sol.tmax = tmax;
dpr_sol.h = h;
dpr_sol.dv = dv;
dpr_sol.tv_max = t_app;

sec = tic;
t = tspan(1); %eps(1)
while t < tmax,
    i = ceil((t+eps)/dv);
    y = h*((1-alpha)*v(:,i) + alpha*(P'*x)) + x;
    dy = y - sum(y)*x;
    x = dy;
    t = t + h;
    
    if i == 1,
        X(:,i) = dy;
        T(i,:) = i;
    end
    
    if ceil(((t+h)+eps)/dv) > i, %save prev solution, since v changes
        X(:,i+1) = dy;
        T(i+1,:) = i+1;
    end
    
end
dpr_info.runtime = toc(sec);

dpr_sol.y = X; %to be consistent
dpr_sol.x = T;



% =======================================
% dynamic pagerank power/forward_euler
% =======================================
function [X dpr_info] = dpr_power(P, v, options)
fprintf('power iteration computation...\n');

alpha = options.alpha;

n_timesteps = size(v,2);

x = options.x0;

n_scale = 5;
if (isfield(options, 'scale'))
    n_scale = options.scale;
end

if options.verbose == 1,
    mkdir('data');
end

dt = 0;
t_ode = 1;
s = 1;
for t=1:n_timesteps
    for i=1:n_scale
        tic;
        
        y = alpha*P'*x;
        w = 1 - norm(y,1);
        y = y + w*v(:,t);
        
        delta = norm(x - y,1);
        hist(i,t) = delta;
        
        x = y;
        
        dt = dt + toc;
        
        if (options.verbose > 0)
            fprintf('time=%d; iteration=%d; delta=%f; dt=%f\n', t,i,delta,dt);
        end
        
        if t == 1 && i == 1,
            X(:,s) = x;
            s = s + 1;
        end
        if mod(t_ode,options.sample) == 0,
            X(:,s) = x;
            s = s + 1;
        end
        t_ode = t_ode + 1;
    end
    if options.verbose == 1,
        dlmwrite(strcat('data/X',int2str(t)), x);
    end
end;

hist = hist(:);

dpr_info = struct();
dpr_info.delta = hist;
dpr_info.tmax = t_ode;
dpr_info.runtime = dt;





function x = set_initial_value(A,v)
% sets the initial value of x(0) to be the solutin 
% of the PageRank system for v(0)
opts = struct('v',v(:,1));
x = pagerank(A,opts);



% warning: expensive in terms of memory/space requirements
function dpr_info = update_info(dpr_info,dpr_sol)
dpr_info.solver = dpr_sol.solver;
dpr_info.extdata = dpr_sol.extdata;
dpr_info.x = dpr_sol.x;
dpr_info.stats = dpr_sol.stats;




function S = merge_structs(A, B)
% MERGE_STRUCTS Merge two structures.
%
% S = merge_structs(A, B) makes the structure S have all the fields from A
% and B.  Conflicts are resolved by using the value in A.

S = A;

fn = fieldnames(B);

for ii = 1:length(fn)
    if (~isfield(A, fn{ii}))
        S.(fn{ii}) = B.(fn{ii});
    end;
end;


function P = normout(A)
% NORMOUT Normalize the outdegrees of the matrix A.
%
%   P has the same non-zero structure as A, but is normalized such that the
%   sum of each row is 1, assuming that A has non-negative entries.

% compute the row-sums/degrees
d = full(sum(A,2));

% invert the non-zeros in the data
id = invzero(d);

% scale the rows of the matrix
P = diag(sparse(id))*A;

function v = invzero(v)
% sparse input are easy to handle
if (issparse(v))
    [m n] = size(v);
    [i j val] = find(v);
    val = 1./val;
    v = sparse(i,j,val,m,n);
    return;
end;

% compute the 0 mask
zm = abs(v) > eps(1);

% invert all non-zeros
v(zm) = 1./v(zm);

function dmask = dangling(A)
d = full(sum(A,2));
dmask = d == 0;

function [k,sizes]=components(A)
% based on components.m from (MESHPART Toolkit)
% which had
% John Gilbert, Xerox PARC, 8 June 1992.
% Copyright (alpha) 1990-1996 by Xerox Corporation.  All rights reserved.
% HELP COPYRIGHT for complete copyright and licensing notice

[p,p,r,r] = dmperm(A|speye(size(A)));
sizes = diff(r);
k = length(sizes);
