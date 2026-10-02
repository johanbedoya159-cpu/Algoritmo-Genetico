%% EXPERIMENTOS: los 4 estudios de la sección 3.5 de la guía
% Este script corre todos los estudios, muestra las tablas en la Command
% Window y las guarda en el archivo "resultados_experimentos.xlsx"
% (una hoja por tabla), listo para copiar al informe.
%
% IMPORTANTE: cierre el archivo de Excel antes de correr el script,
% si no, MATLAB no lo puede sobrescribir.
%
% Se demora unos minutos (inventarios es el más lento).
% Cada estudio usa lo que salió mejor en el anterior, como pide la guía.

clear
clc
close all
rng(1)   % semilla fija: si se vuelve a correr, salen los mismos resultados

n_pruebas = 5;                          % repeticiones por escenario (guía: mínimo 5)
archivo = "resultados_experimentos.xlsx";
if exist(archivo, 'file') == 2
    delete(archivo);
end

problemas = {'viajero', 'ackley', 'inventario'};
metodos   = {'elitismo', 'torneo', 'ruleta'};
config_base = struct('d', 3);           % Ackley con 3 dimensiones en los estudios 1 a 3

tiempo_total = tic;

%% ESTUDIO 1: mejor método de selección (100 iteraciones)
disp("################ ESTUDIO 1: MÉTODO DE SELECCIÓN ################")
mejor_seleccion = struct();

for p = 1:3
    prob = problemas{p};
    res = cell(1, 3);
    for m = 1:3
        fprintf("Corriendo %s con %s...\n", prob, metodos{m})
        res{m} = correr_escenario(prob, metodos{m}, 100, config_base, n_pruebas);
    end
    mostrar_tabla(['Estudio 1 - ' prob ' (100 iteraciones)'], metodos, res, prob)
    writetable(armar_tabla(metodos, res, prob), archivo, 'Sheet', ['E1_' prob]);

    % Se escoge el método con MENOR PROMEDIO (más confiable que el mejor
    % valor de una sola prueba, porque tiene en cuenta las 5 repeticiones)
    [~, im] = min(cellfun(@(r) r.promedio, res));
    mejor_seleccion.(prob) = metodos{im};
    fprintf("-> Mejor selección para %s: %s (menor promedio)\n\n", prob, metodos{im})
end

%% ESTUDIO 2: número de iteraciones (con la mejor selección del estudio 1)
disp("################ ESTUDIO 2: NÚMERO DE ITERACIONES ################")
lista_iter = [10 20 30 50 100 150 200];
nombres_iter = arrayfun(@(k) sprintf('%d iteraciones', k), lista_iter, 'UniformOutput', false);
mejores_iter = struct();

for p = 1:3
    prob = problemas{p};
    sel = mejor_seleccion.(prob);
    res = cell(1, numel(lista_iter));
    for k = 1:numel(lista_iter)
        fprintf("Corriendo %s con %d iteraciones...\n", prob, lista_iter(k))
        res{k} = correr_escenario(prob, sel, lista_iter(k), config_base, n_pruebas);
    end
    mostrar_tabla(['Estudio 2 - ' prob ' (selección: ' sel ')'], nombres_iter, res, prob)
    writetable(armar_tabla(nombres_iter, res, prob), archivo, 'Sheet', ['E2_' prob]);

    % Cantidad "más apropiada": la MENOR cantidad de iteraciones cuyo
    % promedio queda a menos del 1% del mejor promedio. Más iteraciones
    % gastan más tiempo sin mejorar casi nada.
    promedios = cellfun(@(r) r.promedio, res);
    k_elegido = find(promedios <= min(promedios) * 1.01, 1);
    mejores_iter.(prob) = lista_iter(k_elegido);
    fprintf("-> Iteraciones escogidas para %s: %d\n\n", prob, lista_iter(k_elegido))
end

%% ESTUDIO 3: estrategia de mutación (Pm y tamaño de la mutación)
disp("################ ESTUDIO 3: MUTACIÓN ################")
lista_Pm = [0.05 0.1 0.3 0.5];
% Tamaño de la mutación: sigma en Ackley y fracción del rango en inventarios.
% El viajero no tiene tamaño (siempre intercambia 2 posiciones), solo Pm.
magnitudes.viajero    = NaN;
magnitudes.ackley     = [0.1 1 3];
magnitudes.inventario = [0.01 0.1 0.3];
mejor_mutacion = struct();

for p = 1:3
    prob = problemas{p};
    sel  = mejor_seleccion.(prob);
    iter = mejores_iter.(prob);
    mags = magnitudes.(prob);

    if strcmp(prob, 'viajero')
        lista_Pm_prob = [lista_Pm 1.0];
    else
        lista_Pm_prob = lista_Pm;
    end

    nombres = {};
    configs = {};
    for a = 1:numel(lista_Pm_prob)
        for b = 1:numel(mags)
            c = config_base;
            c.Pm = lista_Pm_prob(a);
            if isnan(mags(b))
                nombres{end+1} = sprintf('Pm = %.2f', c.Pm);
            else
                c.magnitud = mags(b);
                if strcmp(prob, 'ackley')
                    nombres{end+1} = sprintf('Pm = %.2f, sigma = %g', c.Pm, mags(b));
                else
                    nombres{end+1} = sprintf('Pm = %.2f, escala = %g%%', c.Pm, 100*mags(b));
                end
            end
            configs{end+1} = c;
        end
    end

    res = cell(1, numel(configs));
    for k = 1:numel(configs)
        fprintf("Corriendo %s con %s...\n", prob, nombres{k})
        res{k} = correr_escenario(prob, sel, iter, configs{k}, n_pruebas);
    end
    mostrar_tabla(['Estudio 3 - ' prob ' (selección: ' sel ', ' num2str(iter) ' iteraciones)'], nombres, res, prob)
    writetable(armar_tabla(nombres, res, prob), archivo, 'Sheet', ['E3_' prob]);

    [~, k_mejor] = min(cellfun(@(r) r.promedio, res));
    mejor_mutacion.(prob) = configs{k_mejor};
    fprintf("-> Mejor mutación para %s: %s (menor promedio)\n\n", prob, nombres{k_mejor})
end

%% ESTUDIO 4: número de dimensiones (solo Ackley)
disp("################ ESTUDIO 4: DIMENSIONES (ACKLEY) ################")
lista_d = [2 3 10 20 50 100];
nombres_d = arrayfun(@(k) sprintf('%d dimensiones', k), lista_d, 'UniformOutput', false);
sel  = mejor_seleccion.ackley;
iter = mejores_iter.ackley;

res = cell(1, numel(lista_d));
for k = 1:numel(lista_d)
    c = mejor_mutacion.ackley;
    c.d = lista_d(k);
    fprintf("Corriendo Ackley con %d dimensiones...\n", lista_d(k))
    res{k} = correr_escenario('ackley', sel, iter, c, n_pruebas);
end
mostrar_tabla(['Estudio 4 - Ackley (selección: ' sel ', ' num2str(iter) ' iteraciones)'], nombres_d, res, 'ackley')
writetable(armar_tabla(nombres_d, res, 'ackley'), archivo, 'Sheet', 'E4_ackley');

%% Resumen
fprintf("\n################ RESUMEN ################\n")
for p = 1:3
    prob = problemas{p};
    fprintf("%-11s selección: %-9s iteraciones: %4d   Pm: %.2f\n", prob, ...
        mejor_seleccion.(prob), mejores_iter.(prob), mejor_mutacion.(prob).Pm)
end
fprintf("\nTiempo total: %.1f minutos\n", toc(tiempo_total) / 60)
fprintf("Tablas guardadas en: %s\n", archivo)

save("resultados_experimentos.mat", "mejor_seleccion", "mejores_iter", "mejor_mutacion")
