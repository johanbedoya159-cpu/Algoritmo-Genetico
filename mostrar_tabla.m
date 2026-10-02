function mostrar_tabla(titulo, escenarios, resultados, problema)
% MOSTRAR_TABLA  Imprime en la Command Window una tabla de resultados.
%
%   mostrar_tabla(titulo, escenarios, resultados, problema)
%
%   escenarios: cell con el nombre de cada fila (ej. {'elitismo', 'torneo'})
%   resultados: cell con lo que devolvió correr_escenario en cada fila
%   problema:   para saber si se muestra la columna de RMSE (solo Ackley)
%
%   El mejor individuo de cada fila no se muestra aquí porque puede ser
%   muy largo; ese queda completo en el archivo de Excel.

es_ackley = strcmpi(problema, 'ackley');

fprintf("\n%s\n", titulo)
fprintf("%-28s %10s %14s %14s %14s", "Escenario", "Tiempo(s)", "Mejor f(X)", "Promedio", "Desv. est.")
if es_ackley
    fprintf(" %14s", "RMSE")
end
fprintf("\n")

for i = 1:numel(resultados)
    r = resultados{i};
    fprintf("%-28s %10.3f %14.6g %14.6g %14.6g", escenarios{i}, r.tiempo, r.mejor_f, r.promedio, r.desv)
    if es_ackley
        fprintf(" %14.6g", r.rmse)
    end
    fprintf("\n")
end
end
