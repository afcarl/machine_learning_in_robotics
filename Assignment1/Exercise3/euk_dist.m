function d = euk_dist(X,Y)
d = sqrt(sum((X-Y).^2));
%d = sqrt((X(1)-Y(1))^2 + (X(2)-Y(2))^2 + (X(3)-Y(3))^2);
end