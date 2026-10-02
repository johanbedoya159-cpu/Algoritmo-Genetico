function mutados = mutacion_viajero(hijos, Pm)


if nargin < 2
    Pm = 0.1;
end

mutados = hijos;
[n, n_ciudades] = size(hijos);

for i = 1:n
    if rand < Pm                             
        pos = randperm(n_ciudades, 2);        
        mutados(i, pos) = mutados(i, fliplr(pos));   
    end
end
end
