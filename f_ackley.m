function fitness = f_ackley(X, a, b, c)
% F_ACKLEY  Función objetivo Ackley modificada (sección 3.1.2, Ecuación 6).
%
%   fitness = f_ackley(X)
%   fitness = f_ackley(X, a, b, c)
%
%   X: vector fila de d dimensiones (un individuo).
%      También acepta una matriz n x d (cada fila un individuo) y devuelve
%      un vector columna con el fitness de cada fila.
%
%   Se usa "+ a + 3" en vez de "+ a + e", por lo que el óptimo NO es 0:
%   el mínimo está en X = 0 y vale 3 - e (aprox. 0.2817).
%   Así ningún fitness es 0 y la selección por ruleta (1/f) nunca divide por 0.
%
%   Ejemplo: f_ackley([0 0 0]) = 3 - exp(1)

if nargin == 1
    a = 20;
    b = 0.2;
    c = 2*pi;
elseif nargin ~= 4
    warning("El número de entradas parece no ser correcto");
end

d = size(X, 2);   % número de dimensiones (columnas)

termino1 = -a * exp(-b * sqrt(sum(X.^2, 2) / d));
termino2 = -exp(sum(cos(c * X), 2) / d);

fitness = termino1 + termino2 + a + 3;
end
