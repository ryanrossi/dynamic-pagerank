% 1. input
% 2. output name
% 3. timescale s
% 4. samples
% 5. method to use, 
% 6. theta smoothing parameter

graphlist = {
    % timescale = 1
    'wiki-48hours','wiki-48h-i1-th01-rk45',1,0.5,'rk45-smooth',0.01,1000,10,'default','diff';
    'wiki-48hours','wiki-48h-i1-th5-rk45',1,0.5,'rk45-smooth',0.5,1000,10,'default','diff';
    'wiki-48hours','wiki-48h-i1-th10-rk45',1,0.5,'rk45-smooth',1,1000,10,'default','diff';
    % timescale = 2
    'wiki-48hours','wiki-48h-i2-th01-rk45',2,2,'rk45-smooth',0.01,1000,10,'default','diff';
    'wiki-48hours','wiki-48h-i2-th5-rk45',2,2,'rk45-smooth',0.5,1000,10,'default','diff';
    'wiki-48hours','wiki-48h-i2-th10-rk45',2,2,'rk45-smooth',1,1000,10,'default','diff';
    % timescale = 6
    'wiki-48hours','wiki-48h-i6-th01-rk45',6,3,'rk45-smooth',0.01,1000,10,'default','diff';
    'wiki-48hours','wiki-48h-i6-th5-rk45',6,3,'rk45-smooth',0.5,1000,10,'default','diff';
    'wiki-48hours','wiki-48h-i6-th10-rk45',6,3,'rk45-smooth',1,1000,10,'default','diff';
    };
