function Xadj = timediff(X)

avg_x = sum(X)/size(X,1);
Xadj = abs(X - repmat(avg_x,size(X,1),1));
