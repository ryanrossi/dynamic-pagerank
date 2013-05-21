function Xn = normrows(X)

if iscell(X),
	tmax = length(X);
	[n, m] = size(X{1});

	for t=1:tmax,
		Y = X{t} ./ repmat(sum(X{t}')',1,m);
		Y(isnan(Y)) = 0;
		Xn{t} = Y;
	end
else
	tmax = size(X,2);
	Y = X ./ repmat(sum(X')',1,tmax);
	Y(isnan(Y)) = 0;
	Xn = Y;
end



