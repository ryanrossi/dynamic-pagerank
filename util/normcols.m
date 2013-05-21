function [ v ] = normcols( v )
n_time = size(v,2);
for t=1:n_time,
    v(:,t) = v(:,t) / csum(v(:,t));
end


