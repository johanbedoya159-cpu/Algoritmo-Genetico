function resultado = algoritmo_genetico(problema, seleccion, iteraciones, config)
% ALGORITMO_GENETICO  Ejecuta el algoritmo genético completo (Figura 1 de la guía).
%
%   resultado = algoritmo_genetico(problema, seleccion, iteraciones)
%   resultado = algoritmo_genetico(problema, seleccion, iteraciones, config)
%
%   problema:    "viajero", "ackley" o "inventario"
%   seleccion:   "elitismo", "torneo" o "ruleta"
%   iteraciones: número de generaciones (ej. 100)
%   config:      (opcional) estructura con parámetros extra:
%       config.n        tamaño de la población          (por defecto 40)
%       config.Pm       probabilidad de mutación         (por defecto 0.1)
%       config.magnitud tamaño de la mutación            (por defecto 1 en Ackley
%                       y 0.1 en inventarios; el viajero no la usa)
%       config.d        dimensiones, solo para Ackley    (por defecto 3)
%
%   resultado: estructura con
%       resultado.mejor_x       mejor individuo encontrado
%       resultado.mejor_f       fitness de ese individuo
%       resultado.tiempo        tiempo de ejecución en segundos
%       resultado.convergencia  mejor fitness encontrado hasta cada generación
%
%   Ejemplos:
%       r = algoritmo_genetico("viajero", "torneo", 100);
%       r = algoritmo_genetico("ackley", "elitismo", 100, struct('d', 10));
%       r = algoritmo_genetico("inventario", "ruleta", 50, struct('Pm', 0.3));

%% Parámetros (si no se dan, se usan los valores por defecto)
if nargin < 4
    config = struct();
end
if ~isfield(config, 'n'),  config.n = 40;   end
if ~isfield(config, 'Pm'), config.Pm = 0.1; end
if ~isfield(config, 'd'),  config.d = 3;    end

problema = lower(char(problema));
seleccion = lower(char(seleccion));
n  = config.n;
Pm = config.Pm;

%% Escoger las funciones de cada problema
% El símbolo @ guarda una función dentro de una variable, para poder usar
% el mismo ciclo de abajo con los 3 problemas.
switch problema
    case "viajero"
        crear  = @() poblacion_viajero(n);
        f      = @(x) f_viajero(x);
        cruzar = @(pob, g) cruce_viajero(pob, g);
        mutar  = @(h) mutacion_viajero(h, Pm);

    case "ackley"
        if ~isfield(config, 'magnitud'), config.magnitud = 1; end
        d = config.d;
        crear  = @() poblacion_ackley(n, d, [-10 10]);
        f      = @(x) f_ackley(x);
        cruzar = @(pob, g) cruce_ackley(pob, g);
        mutar  = @(h) mutacion_ackley(h, Pm, config.magnitud);

    case "inventario"
        if ~isfield(config, 'magnitud'), config.magnitud = 0.1; end
        crear  = @() poblacion_inventario(n);
        f      = @(x) f_inventario(x);
        cruzar = @(pob, g) cruce_inventario(pob, g);
        mutar  = @(h) mutacion_inventario(h, Pm, config.magnitud);

    otherwise
        error("Problema no reconocido. Use ""viajero"", ""ackley"" o ""inventario"".");
end

switch seleccion
    case "elitismo", seleccionar = @seleccion_elitismo;
    case "torneo",   seleccionar = @seleccion_torneo;
    case "ruleta",   seleccionar = @seleccion_ruleta;
    otherwise
        error("Selección no reconocida. Use ""elitismo"", ""torneo"" o ""ruleta"".");
end

%% Algoritmo genético
tic

% 1. Población inicial (ya viene evaluada)
[pob, fit] = crear();
[mejor_f, idx] = min(fit);
mejor_x = pob(idx, :);

convergencia = zeros(iteraciones, 1);

% 2. Ciclo de generaciones (el criterio de parada es el número de iteraciones)
for iter = 1:iteraciones
    % Aparear: selección + cruce
    ganadores = seleccionar(fit);
    hijos = cruzar(pob, ganadores);

    % Mutar (solo a los hijos)
    hijos = mutar(hijos);

    % Evaluar solo a los hijos: los ganadores no cambiaron, así que su
    % fitness ya se conoce y no hay que volver a calcularlo
    fit_hijos = zeros(size(hijos, 1), 1);
    for i = 1:size(hijos, 1)
        fit_hijos(i) = f(hijos(i, :));
    end

    % Nueva población = ganadores + hijos (igual que en el LiveScript)
    pob = [pob(ganadores, :); hijos];
    fit = [fit(ganadores); fit_hijos];

    % Guardar el mejor encontrado hasta ahora
    [mejor_gen, idx] = min(fit);
    if mejor_gen < mejor_f
        mejor_f = mejor_gen;
        mejor_x = pob(idx, :);
    end
    convergencia(iter) = mejor_f;
end

tiempo = toc;

%% Resultado
resultado.mejor_x = mejor_x;
resultado.mejor_f = mejor_f;
resultado.tiempo = tiempo;
resultado.convergencia = convergencia;
resultado.config = config;
end
