function hijos = cruce_ackley(poblacion, ganadores, alfa, limites)
% CRUCE_ACKLEY  Cruce BLX-alfa ("Blend Crossover") para la función Ackley.
%
%   hijos = cruce_ackley(poblacion, ganadores)
%   hijos = cruce_ackley(poblacion, ganadores, alfa, limites)
%
%   poblacion: matriz n x d (cada fila es un punto).
%   ganadores: índices que devuelve la función de selección.
%   alfa:      qué tanto se pueden salir los hijos del rango de los papás
%              (por defecto 0.5, el valor más usado en la literatura).
%   limites:   [minimo maximo] del dominio (por defecto [-10 10]).
%   hijos:     una fila por cada ganador (parejas 1-2, 3-4, ...).
%
%   Cómo funciona (Eshelman y Schaffer, 1993), para cada posición i:
%     - Se miran los dos valores de los papás: el menor (cmin) y el mayor (cmax).
%     - I = cmax - cmin es la distancia entre ellos.
%     - El hijo toma un valor al azar entre (cmin - alfa*I) y (cmax + alfa*I).
%   O sea, el hijo cae cerca de los papás, pero se puede salir un poquito
%   del intervalo entre ellos. Eso le permite explorar zonas nuevas.
%   Si el valor se sale del dominio, se recorta al límite.

if nargin < 3
    alfa = 0.5;
end
if nargin < 4
    limites = [-10 10];
end
li = min(limites);
ls = max(limites);

n_ganadores = length(ganadores);
d = size(poblacion, 2);
hijos = zeros(n_ganadores, d);

for k = 1:2:n_ganadores
    padre = poblacion(ganadores(k), :);
    if k + 1 <= n_ganadores
        madre = poblacion(ganadores(k+1), :);
    else
        madre = poblacion(ganadores(1), :);   % si queda uno sin pareja, se cruza con el primero
    end

    cmin = min(padre, madre);
    cmax = max(padre, madre);
    I = cmax - cmin;

    inferior = cmin - alfa * I;
    superior = cmax + alfa * I;

    % Cada hijo es un punto al azar dentro de ese rango (posición por posición)
    hijo1 = inferior + (superior - inferior) .* rand(1, d);
    hijo2 = inferior + (superior - inferior) .* rand(1, d);

    % Recortar para no salirse del dominio [-10, 10]
    hijos(k, :) = min(max(hijo1, li), ls);
    if k + 1 <= n_ganadores
        hijos(k+1, :) = min(max(hijo2, li), ls);
    end
end
end
