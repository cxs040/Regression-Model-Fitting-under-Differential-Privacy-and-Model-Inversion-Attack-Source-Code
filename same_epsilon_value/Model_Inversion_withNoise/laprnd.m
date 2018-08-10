function y  = laprnd(m, n, mu, b)

u = rand(m, n) - 0.5;
y = mu - b * sign(u) .* log(1 - 2 * abs(u));
