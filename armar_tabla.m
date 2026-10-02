function T = armar_tabla(escenarios, resultados, problema)
% ARMAR_TABLA  Convierte los resultados en una tabla de MATLAB para
% guardarla en Excel con writetable.
%
%   T = armar_tabla(escenarios, resultados, problema)
%
%   Columnas: Escenario, Tiempo_s, Mejor_f, Promedio_f, Desv_estandar,
%             RMSE (solo Ackley) y Mejor_individuo.

n = numel(resultados);

Escenario     = escenarios(:);
Tiempo_s      = zeros(n, 1);
Mejor_f       = zeros(n, 1);
Promedio_f    = zeros(n, 1);
Desv_estandar = zeros(n, 1);
RMSE          = zeros(n, 1);
Mejor_individuo = cell(n, 1);

for i = 1:n
    r = resultados{i};
    Tiempo_s(i)      = r.tiempo;
    Mejor_f(i)       = r.mejor_f;
    Promedio_f(i)    = r.promedio;
    Desv_estandar(i) = r.desv;
    RMSE(i)          = r.rmse;
    Mejor_individuo{i} = mat2str(r.mejor_x, 5);
end

if strcmpi(problema, 'ackley')
    T = table(Escenario, Tiempo_s, Mejor_f, Promedio_f, Desv_estandar, RMSE, Mejor_individuo);
else
    T = table(Escenario, Tiempo_s, Mejor_f, Promedio_f, Desv_estandar, Mejor_individuo);
end
end
