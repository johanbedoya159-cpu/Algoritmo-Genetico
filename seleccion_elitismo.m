function ganadores = seleccion_elitismo(fitness)


n = length(fitness);
n_seleccionados = floor(n/2);


[~, orden] = sort(fitness, 'ascend');


ganadores = orden(1:n_seleccionados);


ganadores = ganadores(randperm(n_seleccionados));
ganadores = ganadores(:)';   
end
