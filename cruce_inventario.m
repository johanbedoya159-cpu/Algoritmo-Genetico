function hijos = cruce_inventario(poblacion, ganadores)


n_ganadores = length(ganadores);
n_variables = size(poblacion, 2);
hijos = zeros(n_ganadores, n_variables);

for k = 1:2:n_ganadores
    padre = poblacion(ganadores(k), :);
    if k + 1 <= n_ganadores
        madre = poblacion(ganadores(k+1), :);
    else
        madre = poblacion(ganadores(1), :);   
    end

    lambda = rand;  

    hijos(k, :) = lambda * padre + (1 - lambda) * madre;
    if k + 1 <= n_ganadores
        hijos(k+1, :) = (1 - lambda) * padre + lambda * madre;
    end
end
end
