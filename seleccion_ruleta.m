function ganadores = seleccion_ruleta(fitness)

fitness = fitness(:);

if any(fitness <= 0)
    error("La ruleta necesita que todos los fitness sean mayores que 0");
end

n = length(fitness);
n_seleccionados = floor(n/2);

inverso = 1 ./ fitness;       
disponibles = (1:n)';
ganadores = zeros(1, n_seleccionados);

for k = 1:n_seleccionados
    
    P = inverso(disponibles) / sum(inverso(disponibles));

    
    acumulada = cumsum(P);
    acumulada(end) = 1;           
    r = rand;
    pos = find(r <= acumulada, 1);

    ganadores(k) = disponibles(pos);
    disponibles(pos) = [];        
end
end
