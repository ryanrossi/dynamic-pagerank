function isk=isim(x,y,ties,delta)
% ISIM Intersection similarity 
%
% isk = isim(x,y) returns the intersection similarity at k for each value
% of k between 1 and n assuming that vectors x and y give a numeric rating
% for n items where x(i) and y(i) are the numeric scores for item i.  
%
% The intersection similarity at k is the average of the normalized
% intersection size for 1 <= t <= k, mathematically,
%   isk(k) = mean(symdiff(A(t),B(t))/(2*t))
% where A(t) is the top-t set of items from A (likewise for B) and the
% normalization factor insures that symdiff(A(t),B(t))/(2*t) <= 1.
%
% Example:
% 
% isk = isim([1 2.5 3 4 5 6],[1 2.4 3 4 5.3 6]) % identical ratings
% isk = isim([1 2 3 4 5 6],[6 5 4 3 2 1]) % reversed ratings
% isk = isim([3 2 1 4 5 6],[1 2 3 4 5 6]) % rates top 3 the same.
% 

if ~exist('ties','var') || isempty(ties), ties=false; end
if ~exist('delta','var') || isempty(delta), delta=eps(1); end
if ~isvector(x)||~isvector(y), error('isim:input','x and y must be vectors'); end
if numel(x)~=numel(y), error('isim:size','arguments must have equal length'); end

n = numel(x); x=x(:); y=y(:);
[x pa] = sort(x,1,'descend');
[y pb] = sort(y,1,'descend');

if ~ties
    % the case without ties is simple
    isk = zeros(n,1); topk = false(n,1); symdiff=0; sumsymdiff=0;
    for i=1:n
        % assert(symdiff = sum(topk))
        tka = pa(i); tkb=pb(i);
        if topk(tka), symdiff=symdiff-1; else symdiff=symdiff+1; end
        topk(tka)=~topk(tka); 
        if topk(tkb), symdiff=symdiff-1; else symdiff=symdiff+1; end
        topk(tkb)=~topk(tkb); 
        sumsymdiff = sumsymdiff + symdiff/(2*i);
        isk(i) = sumsymdiff/i; 
    end
else
    % the case with ties is more complicated
    % TODO: Compute the minimum difference we'll accept for a tie
    isk = zeros(n,1); topk = false(n,1); symdiff=0; sumsymdiff=0; 
    k=1; % k is the current value of k for top k rankings, 
    ai=1; bi=1; % ai and bi are indices into the sets a and b.
    ti=0; % ti is the number of top k items added (the normalization factor)
    while ai<=n || bi<=n
        % add items from a until a ends or we get a difference more than delta
        if ai<=n
            tka = pa(ai); ti = ti+1;
            if topk(tka), symdiff=symdiff-1; else symdiff=symdiff+1; end
            topk(tka)=~topk(tka); 
        end
        if bi<=n
            tkb = pb(bi); ti = ti+1;
            if topk(tkb), symdiff=symdiff-1; else symdiff=symdiff+1; end
            topk(tkb)=~topk(tkb); 
        end
        while ai<n && x(ai)-x(ai+1) < delta, 
            ai = ai+1;
            tka = pa(ai); ti = ti+1;
            if topk(tka), symdiff=symdiff-1; else symdiff=symdiff+1; end
            topk(tka)=~topk(tka); 
        end
        while bi<n && y(bi)-y(bi+1) < delta,
            bi = bi+1;
            tkb = pb(bi); ti = ti+1;
            if topk(tkb), symdiff=symdiff-1; else symdiff=symdiff+1; end
            topk(tkb)=~topk(tkb); 
        end
        sumsymdiff = sumsymdiff + symdiff/ti;
        isk(k) = sumsymdiff/k; 
        k = k+1; ai = ai+1; bi = bi+1; % advance to the next elements
    end
    isk = isk(1:k-1);
end
