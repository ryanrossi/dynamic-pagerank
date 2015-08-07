
A Dynamical System for PageRank with Time-Dependent Teleportation
==================================

In short, a library for computing dynamic pagerank. See [1] and [2] for further details.

[1]	Ryan Rossi and David Gleich: [Dynamic PageRank using Evolving Teleportation](http://www.ryanrossi.com/papers/rossi-gleich-dynamic-pagerank.pdf), 
	Algorithms and Models for the Web Graph, vol. 7323 of LNCS, pages 126-137. Springer, 2012.

[2]	David F. Gleich, Ryan A. Rossi, [A Dynamical System for PageRank with Time-Dependent Teleportation](http://ryanrossi.com/papers/dynamic-pagerank.pdf), 
	Internet Mathematics, 10:1-2, 188-217, 2014.

_These codes are research prototypes and may not work for you. No promises. But do email if you run into problems._


Download
--------
* [dynamic_pagerank.zip](https://www.cs.purdue.edu/homes/dgleich/codes/dynsyspr-im/dynamic_pagerank.zip) 

___Unzip data into dynamic_pagerank directory___
* [dynamic-pr-data.zip](http://ryanrossi.com/dynamic_pagerank/dynamic-pr-data.zip)
* [dynamic-pr-data.7z](http://ryanrossi.com/dynamic_pagerank/dynamic-pr-data.7z) 




Setup
-----

Start matlab in the directory where you unzipped the `dynamic_pagerank.zip` file

    $ matlab
    >> setup_paths
	>> load('data/wiki-24hours');

This should work on Mac OSX (Lion tested) and Ubuntu linux (10.10 tested) with 
Matlab R2011a.

    >> v = normcols(v);
    >> X = dynamic_pagerank(A,v);

See examples.m for additional examples

Please let us know if you run into any issues.
 
Overview
--------

The package is organized by directory

`/`
: All of the main matlab codes (dynamic_pagerank.m,...)

`ranking`
: dynamic ranking codes and figures

`forecasting`
: simple models for prediction using Dynamic PageRank

`clustering`
: experimental codes for identifying trends and similar vertices

`causality`
: codes for computing Granger causality between vertices

`data`
: graphs, precomputed data, and script files for extracting and parsing page views

`web`
: this information and all the figures

Figures
-----------
    
|Experiment|Description|Figure|
|:------------------|:------------------------------------|:------------------|
|`fluctuating_interest.m` | PageRank dynamical system analytical solution  | Fig. 2 |
|`plot_vertex_yxlims.m` | PageRank dynamical system analytical solution  | Fig. 3 |
|`ranking/compute_isim.m` | The intersection similarity plot | Fig. 5 |
|`dpr_timeseries.m` | Dynamic PageRank time-series plot | Fig. 6-7 |
|`forecasting/print_preds_table.m` | Performance of Dynamic PageRank for prediction | Tab. 3 |
|`clustering/dpr_clustering.m` | Cluster dynamic score trends, vertices w/ similar behavior | Fig. 8 |
|`causality/prt_causality.m` | Granger causality between vertices | Tab. 4 |
