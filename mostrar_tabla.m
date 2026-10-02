function mostrar_tabla(titulo, escenarios, resultados, problema)


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
