function hijos = cruce_ackley(poblacion, ganadores, alfa, limites)

if nargin < 3
    alfa = 0.5;
end
if nargin < 4
    limites = [-10 10];
end
li = min(limites);
ls = max(limites);

n_ganadores = length(ganadores);
d = size(poblacion, 2);
hijos = zeros(n_ganadores, d);

for k = 1:2:n_ganadores
    padre = poblacion(ganadores(k), :);
    if k + 1 <= n_ganadores
        madre = poblacion(ganadores(k+1), :);
    else
        madre = poblacion(ganadores(1), :);   
    end

    cmin = min(padre, madre);
    cmax = max(padre, madre);
    I = cmax - cmin;

    inferior = cmin - alfa * I;
    superior = cmax + alfa * I;

    
    hijo1 = inferior + (superior - inferior) .* rand(1, d);
    hijo2 = inferior + (superior - inferior) .* rand(1, d);

   
    hijos(k, :) = min(max(hijo1, li), ls);
    if k + 1 <= n_ganadores
        hijos(k+1, :) = min(max(hijo2, li), ls);
    end
end
end
