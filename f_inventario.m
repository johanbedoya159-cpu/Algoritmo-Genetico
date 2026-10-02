function Z = f_inventario(Q, S, K)


if nargin == 1
    X = Q;
    Q = X(1:5);
    S = X(6:10);
    K = X(11:15);
elseif nargin ~= 3
    error("Use f_inventario(Q, S, K) o f_inventario([Q S K])");
end

datos = datos_inventario();
penalizacion = 1e7;


if any(Q <= 0)
    Z = 2 * penalizacion;
    return
end

Z = 0;
for i = 1:datos.n_items
    R  = S(i) + K(i);              
    mu = datos.mu(i);
    sg = datos.sigma(i);
    mi = datos.m(i);

    
    integrando = @(x) (x - R) ./ (mi * sqrt(2*pi) * sg) .* exp(-0.5 * ((x - mu) / sg).^2);

    Z = Z + datos.D(i) / Q(i) * integral(integrando, R, Inf);
end


cumple_limites = all(Q <= datos.Q_max) && ...
                 all(S >= 0) && all(S <= datos.S_max) && ...
                 all(K >= 0) && all(K <= datos.K_max);

cumple_ec9 = abs(sum(Q/2 + S) - datos.I) <= 1e-6 * datos.I;

if ~cumple_limites || ~cumple_ec9
    Z = Z + penalizacion;
end
end
