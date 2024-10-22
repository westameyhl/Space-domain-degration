function [c,d] = gererate_cd(m, dr, itg)
    % m th order poly

    n_dr = size(dr,1);
    n_itg = size(itg,1) - 1;

    c = zeros(n_dr+n_itg, m+1);
    d = zeros(n_dr+n_itg, 1);
    
    for i = 1:1:n_dr
        for j = 1:1:m+1
            if j ~= 1 
                c(i,j) = (j-1) * dr(i,1)^(j-2);
            else
                c(i,j) = 0;
            end
        end
        % get d
        d(i) = dr(i,2);
    end

    for i = n_dr+1:1:n_dr+n_itg
        for j = 1:1:m+1
            c(i,j) = itg(i-n_dr+1,1)^j / j;
        end
        % get d
        d(i) = itg(i-n_dr+1,2);
    end

end