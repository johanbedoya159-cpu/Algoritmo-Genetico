function [poblacion, fitness] = poblacion_ackley(n, d, limites)
% POBLACION_ACKLEY  Población inicial para la función Ackley (sección 3.2.2).
%
%   [poblacion, fitness] = poblacion_ackley(n, d, limites)
%
%   n:       tamaño de la población (cuántos puntos se generan)
%   d:       número de dimensiones de cada individuo
%   limites: vector de 2 elementos [minimo maximo], ej. [-10 10]
%
%   poblacion: matriz n x d con valores aleatorios uniformes dentro de los límites
%   fitness:   vector columna n x 1 con el valor de Ackley de cada fila

if nargin < 3
    limites = [-10 10];
end

li = min(limites);
ls = max(limites);

% rand da valores entre 0 y 1; se escalan al intervalo [li, ls]
poblacion = li + (ls - li) * rand(n, d);

fitness = zeros(n, 1);
for i = 1:n
    fitness(i,1) = f_ackley(poblacion(i,:));
end
end
