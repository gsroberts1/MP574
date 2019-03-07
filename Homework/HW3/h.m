function h_out = h(alpha)
    v = k_in - alpha*df;
    h_out = f1(v,m,b);
end 

