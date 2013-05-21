function graphlist = get_graphlist(data)

% load the list of graphs
if (strcmp(data,'wiki_preds')),
    wiki_preds
elseif strcmp(data,'twitter_preds'),
    twitter_preds
elseif strcmp(data,'twitter_timescales'),
    twitter_timescales
elseif strcmp(data,'twitter_smoothing'),
    twitter_smoothing
elseif strcmp(data,'wiki_timescales_24h'),
    wiki_timescales_24h
elseif strcmp(data,'wiki_smoothing_24h'),
    wiki_smoothing_24h
elseif strcmp(data,'wiki_timescales_48h'),
    wiki_timescales_48h
elseif strcmp(data,'wiki_smoothing_48h'),
    wiki_smoothing_48h
elseif strcmp(data,'wiki_preds_48h'),
    wiki_preds_48h
elseif strcmp(data,'wiki_preds_48h_s4'),
    wiki_preds_48h_s4
elseif strcmp(data,'wiki_preds_48h_s6'),
    wiki_preds_48h_s6
elseif strcmp(data,'test_graph'),
    test_graph
else
    fprintf('testing dynamic pagerank...\n')
    graphlist = {'test_graph100k','test_graph100k_out',8,0,'rk45-smooth',.5};
end