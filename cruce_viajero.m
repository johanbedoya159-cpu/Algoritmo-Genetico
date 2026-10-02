function hijos = cruce_viajero(poblacion, ganadores)


n_ganadores = length(ganadores);
n_ciudades = size(poblacion, 2);
hijos = zeros(n_ganadores, n_ciudades);

for k = 1:2:n_ganadores
    padre = poblacion(ganadores(k), :);
    if k + 1 <= n_ganadores
        madre = poblacion(ganadores(k+1), :);
    else
        madre = poblacion(ganadores(1), :);   
    end

    
    cortes = sort(randperm(n_ciudades, 2));
    a = cortes(1);
    b = cortes(2);

    hijos(k, :) = orden_ox(padre, madre, a, b);
    if k + 1 <= n_ganadores
        hijos(k+1, :) = orden_ox(madre, padre, a, b);
    end
end
end


function hijo = orden_ox(p1, p2, a, b)

n = length(p1);
hijo = zeros(1, n);


hijo(a:b) = p1(a:b);


orden_p2 = p2([b+1:n, 1:b]);
faltantes = orden_p2(~ismember(orden_p2, p1(a:b)));   


huecos = [b+1:n, 1:a-1];
hijo(huecos) = faltantes;
end
