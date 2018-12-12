function cx = cxcorr(a,b)
%%cxcorr
% Circular Cross-Correlation
% input should be row vectors

len_a = length(a);
len_b = length(b);
len_cx = max(length(a), length(b));
a = [a, zeros(1, len_cx - len_a)];
b = [b, zeros(1, len_cx - len_b)];
cx = zeros(1, len_cx);
for k = 1:len_cx
    cx(k)=a*b.';
    b=[b(end), b(1:end-1)];	%circular shift
end
end