function [W,B] = get_all(A,b,c,d)
% c:M
%GET_ALL Summary of this function goes here
%   Detailed explanation goes here

    n_a = size(A,1);
    n_c = size(c,1);
    n_w = n_a + n_c;

    W = zeros(n_w);
    B = zeros(n_w, 1);
    W(1:n_a, 1:n_a) = A;
    W(n_a+1:n_w, 1:n_a) = c;
    W(1:n_a, n_a+1:n_w) = c';
    W(n_a+1:n_w, n_a+1:n_w) = 0;
    B(1:n_a, 1) = b;
    B(n_a+1:n_w, 1) = d;

end

