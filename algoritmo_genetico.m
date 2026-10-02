function resultado = algoritmo_genetico(problema, seleccion, iteraciones, config)

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


tic


[pob, fit] = crear();
[mejor_f, idx] = min(fit);
mejor_x = pob(idx, :);

convergencia = zeros(iteraciones, 1);


for iter = 1:iteraciones
    
    ganadores = seleccionar(fit);
    hijos = cruzar(pob, ganadores);

    
    hijos = mutar(hijos);

    
    fit_hijos = zeros(size(hijos, 1), 1);
    for i = 1:size(hijos, 1)
        fit_hijos(i) = f(hijos(i, :));
    end

    
    pob = [pob(ganadores, :); hijos];
    fit = [fit(ganadores); fit_hijos];

  
    [mejor_gen, idx] = min(fit);
    if mejor_gen < mejor_f
        mejor_f = mejor_gen;
        mejor_x = pob(idx, :);
    end
    convergencia(iter) = mejor_f;
end

tiempo = toc;


resultado.mejor_x = mejor_x;
resultado.mejor_f = mejor_f;
resultado.tiempo = tiempo;
resultado.convergencia = convergencia;
resultado.config = config;
end
