function res = correr_escenario(problema, seleccion, iteraciones, config, n_pruebas)

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


if strcmpi(problema, 'ackley')
    optimo = 3 - exp(1);
    res.rmse = sqrt(mean((valores - optimo).^2));
else
    res.rmse = NaN;
end

res.tiempo  = mean(tiempos);
res.valores = valores;
end
