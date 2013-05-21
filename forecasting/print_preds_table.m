function pdata = print_preds_table(data,fn)
% prints the table of preds for various timescales and 
% thetas (smoothing parameter). Also see, compute_preds
%


setup_paths

if strcmp(data,'twitter_preds'),
   name = 'twitter';
   twitter_preds
elseif strcmp(data,'wiki_preds_48h'),
    name = 'wikipedia';
    wiki_preds_48h
elseif strcmp(data,'wiki_preds'),
    name = 'wikipedia';
    wiki_preds
end



dpath = fn;
load([dpath,'.mat']);

for graph=pdata.keys
    info = pdata(graph{1});
    info.th = num2str(info.theta);
    pdata(graph{1}) = info;
end

clear sgdata;
for graph=pdata.keys
    if ~exist('sgdata','var'), sgdata = pdata(graph{1});
    else, sgdata(end+1) = pdata(graph{1}); end
end

fid = fopen([dpath,'table.txt'], 'w+');

header = {
'\begin{table}';
'\caption{Average SMAPE over all nodes for the two models (lower is better).}';
'\label{table:pv-preds}';
'\centering\scriptsize';
'\begin{tabularx}{\linewidth}{ ll rXXXX}';
'\toprule';
'\textbf{{Dataset}} & \textbf{Type} & $\theta$ & \multicolumn{4}{l}{\textbf{Error Ratio}} \\';
' &  &  & $s$ (timescale)& & & \\';
' &  &  & \textbf{1} & \textbf{2} & \textbf{6} & $\mathbf{\infty}$ \\';
'\midrule';
};

for i=1:length(header),
    fprintf(fid,'%s\n',header{i});
    fprintf('%s\n',header{i});
end


thetas = unique({sgdata.th});
prev_ti = 1;
for ti=1:numel(thetas)
    th = thetas{ti};
    tgraphs = sgdata(strcmp({sgdata.th},th)); 
    [~,p] = sort([tgraphs.ode_time]); 
    for gi=1:numel(p)
        name = tgraphs(p(gi)).name;
        s = tgraphs(p(gi)).ode_time;
        theta = tgraphs(p(gi)).theta;
        smape_st = tgraphs(p(gi)).smape_st;
        if ti==1 && gi==1,
            fprintf('\\textsc{%s} & ',name);
            fprintf('stationary & \n');
        elseif ti ~= prev_ti,
            fprintf(' & & ');
            prev_ti = ti;
        end
        
        error_ratio = smape_st(1)/smape_st(2);
        
        if gi == 1,
            fprintf('\t\\textbf{%0.2f}  & %1.3f & ',theta,error_ratio);
        elseif gi == numel(p),
            fprintf('%1.3f \\\\ \n',error_ratio);
        else
            fprintf('%1.3f  &  ',error_ratio);
        end
        
    end
end
    fprintf('\\addlinespace \n');

str = '';
prev_ti = 1;
for ti=1:numel(thetas)
    th = thetas{ti};
    tgraphs = sgdata(strcmp({sgdata.th},th)); 
    [~,p] = sort([tgraphs.ode_time]); 
    for gi=1:numel(p)
        name = tgraphs(p(gi)).name;
        s = tgraphs(p(gi)).ode_time;
        theta = tgraphs(p(gi)).theta;
        smape_ns = tgraphs(p(gi)).smape_ns;
        if ti==1 && gi==1,
            fprintf(' & ');
            fprintf('non-stationary & \n');
        elseif ti ~= prev_ti,
            fprintf(' & & ');
            prev_ti = ti;
        end
        
        error_ratio = smape_ns(1)/smape_ns(2);
        if gi == 1,
            fprintf('\t \\textbf{%0.2f}  & %1.3f & ',theta,error_ratio);
        elseif gi == numel(p),
            fprintf('%1.3f \\\\ \n',error_ratio);
        else
            fprintf('%1.3f  &  ',error_ratio);
        end
        str = [str, num2str(s)];
    end
end


fprintf('\\bottomrule\n');
fprintf('\\end{tabularx} \n\\end{table} \n');