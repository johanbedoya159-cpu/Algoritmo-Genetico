function fitness = f_ackley(X, a, b, c)


if nargin == 1
    a = 20;
    b = 0.2;
    c = 2*pi;
elseif nargin ~= 4
    warning("El número de entradas parece no ser correcto");
end

d = size(X, 2);   

termino1 = -a * exp(-b * sqrt(sum(X.^2, 2) / d));
termino2 = -exp(sum(cos(c * X), 2) / d);

fitness = termino1 + termino2 + a + 3;
end
