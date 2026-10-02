function hijos = cruce_viajero(poblacion, ganadores)
% CRUCE_VIAJERO  Cruce por orden (OX, "Order Crossover") para el viajero.
%
%   hijos = cruce_viajero(poblacion, ganadores)
%
%   poblacion: matriz n x 13 (cada fila es una ruta).
%   ganadores: índices que devuelve la función de selección.
%   hijos:     una fila por cada ganador (los ganadores se cruzan de a 2:
%              el 1 con el 2, el 3 con el 4, ... y cada pareja deja 2 hijos).
%
%   ¿Por qué no sirve el cruce de un punto del LiveScript de la mochila?
%   Porque al pegar un pedazo de una ruta con un pedazo de otra, casi
%   siempre se repiten municipios y otros quedan por fuera.
%
%   Cómo funciona el OX (Davis, 1985):
%   1. Se escogen 2 puntos de corte al azar.
%   2. El hijo copia del padre el tramo que queda entre los 2 cortes,
%      en las mismas posiciones.
%   3. Los huecos se llenan con los municipios que faltan, en el orden en
%      que aparecen en la madre, empezando después del segundo corte y
%      dando la vuelta al final.
%
%   Ejemplo (cortes en las posiciones 4 y 7):
%     padre = [1 2 3 | 4 5 6 7 | 8 9]
%     madre = [9 3 7 | 8 2 6 5 | 1 4]
%     hijo  = [3 8 2 | 4 5 6 7 | 1 9]
%   Ningún municipio se repite, así que el hijo siempre es una ruta válida.

n_ganadores = length(ganadores);
n_ciudades = size(poblacion, 2);
hijos = zeros(n_ganadores, n_ciudades);

for k = 1:2:n_ganadores
    padre = poblacion(ganadores(k), :);
    if k + 1 <= n_ganadores
        madre = poblacion(ganadores(k+1), :);
    else
        madre = poblacion(ganadores(1), :);   % si queda uno sin pareja, se cruza con el primero
    end

    % 2 puntos de corte al azar (distintos) y ordenados
    cortes = sort(randperm(n_ciudades, 2));
    a = cortes(1);
    b = cortes(2);

    hijos(k, :) = orden_ox(padre, madre, a, b);
    if k + 1 <= n_ganadores
        hijos(k+1, :) = orden_ox(madre, padre, a, b);
    end
end
end


function hijo = orden_ox(p1, p2, a, b)
% Arma UN hijo con el tramo a:b de p1 y el resto en el orden de p2.
n = length(p1);
hijo = zeros(1, n);

% Paso 2: copiar el tramo del primer papá
hijo(a:b) = p1(a:b);

% Paso 3: recorrer p2 empezando después del corte b (dando la vuelta)
orden_p2 = p2([b+1:n, 1:b]);
faltantes = orden_p2(~ismember(orden_p2, p1(a:b)));   % quitar los que ya están

% Llenar los huecos, también empezando después del corte b
huecos = [b+1:n, 1:a-1];
hijo(huecos) = faltantes;
end
