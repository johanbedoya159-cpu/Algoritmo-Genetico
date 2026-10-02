function res = correr_escenario(problema, seleccion, iteraciones, config, n_pruebas)
% CORRER_ESCENARIO  Corre el algoritmo genético varias veces con la misma
% configuración y calcula los indicadores que pide la guía (sección 3.5).
%
%   res = correr_escenario(problema, seleccion, iteraciones, config, n_pruebas)
%
%   n_pruebas: cuántas veces se repite (la guía pide mínimo 5).
%
%   res.mejor_f   mejor valor encontrado entre todas las pruebas
%   res.mejor_x   individuo que obtuvo ese mejor valor
%   res.promedio  promedio de los resultados de las pruebas
%   res.desv      desviación estándar de los resultados (precisión)
%   res.rmse      RMSE contra 3 - e, Ecuación 15 (solo Ackley; NaN en los demás)
%   res.tiempo    tiempo de ejecución promedio por prueba (s)
%   res.valores   resultado de cada prueba

if nargin < 4
    config = struct();
end
if nargin < 5
    n_pruebas = 5;
end

valores = zeros(n_pruebas, 1);
tiempos = zeros(n_pruebas, 1);
individuos = cell(n_pruebas, 1);

for k = 1:n_pruebas
    r = algoritmo_genetico(problema, seleccion, iteraciones, config);
    valores(k) = r.mejor_f;
    tiempos(k) = r.tiempo;
    individuos{k} = r.mejor_x;
end

[res.mejor_f, idx] = min(valores);
res.mejor_x  = individuos{idx};
res.promedio = mean(valores);
res.desv     = std(valores);

% RMSE (Ecuación 15): solo tiene sentido en Ackley, donde se conoce el óptimo
if strcmpi(problema, 'ackley')
    optimo = 3 - exp(1);
    res.rmse = sqrt(mean((valores - optimo).^2));
else
    res.rmse = NaN;
end

res.tiempo  = mean(tiempos);
res.valores = valores;
end
