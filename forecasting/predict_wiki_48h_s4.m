% nohup /p/matlab/bin/matlab < run_wiki_preds_48h_s4.m >& log_wiki_preds_48h_s4.txt  &


setup_paths

data = 'wiki_preds_48h_s4';
compute_preds(data);



