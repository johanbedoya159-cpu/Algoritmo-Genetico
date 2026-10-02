function hijos = cruce_inventario(poblacion, ganadores)
% CRUCE_INVENTARIO  Cruce aritmético para el problema de inventarios.
%
%   hijos = cruce_inventario(poblacion, ganadores)
%
%   poblacion: matriz n x 15, cada fila es [Q1..Q5 S1..S5 K1..K5].
%   ganadores: índices que devuelve la función de selección.
%   hijos:     una fila por cada ganador (parejas 1-2, 3-4, ...).
%
%   Cómo funciona (Michalewicz, 1996):
%   Se escoge un número al azar "lambda" entre 0 y 1, y los hijos son
%   una mezcla (promedio ponderado) de los papás:
%       hijo1 = lambda*padre + (1-lambda)*madre
%       hijo2 = (1-lambda)*padre + lambda*madre
%   Por ejemplo, con lambda = 0.3 el hijo1 es 30% padre y 70% madre.
%
%   ¿Por qué este cruce para inventarios?
%   Se usa el MISMO lambda para las 15 variables. Así, si los dos papás
%   cumplen la Ecuación 9 (sum(Q/2 + S) = 8000), los hijos también la cumplen:
%       sum(Q_hijo/2 + S_hijo) = lambda*8000 + (1-lambda)*8000 = 8000
%   Y como cada valor del hijo queda entre los valores de los papás, tampoco
%   se sale de los límites de la Tabla II. Los hijos siempre son válidos.

n_ganadores = length(ganadores);
n_variables = size(poblacion, 2);
hijos = zeros(n_ganadores, n_variables);

for k = 1:2:n_ganadores
    padre = poblacion(ganadores(k), :);
    if k + 1 <= n_ganadores
        madre = poblacion(ganadores(k+1), :);
    else
        madre = poblacion(ganadores(1), :);   % si queda uno sin pareja, se cruza con el primero
    end

    lambda = rand;   % un solo número para las 15 variables

    hijos(k, :) = lambda * padre + (1 - lambda) * madre;
    if k + 1 <= n_ganadores
        hijos(k+1, :) = (1 - lambda) * padre + lambda * madre;
    end
end
end
