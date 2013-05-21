function d = sym_setdiff(A, B)
d = setdiff(union(A, B), intersect(A, B));
