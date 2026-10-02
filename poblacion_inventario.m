function [poblacion, fitness] = poblacion_inventario(n)


datos = datos_inventario();

poblacion = zeros(n, 15);
fitness   = zeros(n, 1);

for i = 1:n
    Q5 = -1;
    while Q5 <= 0 || Q5 > datos.Q_max(5)
        Q14 = rand(1, 4) .* datos.Q_max(1:4);   
        S   = rand(1, 5) .* datos.S_max;         
        K   = rand(1, 5) .* datos.K_max;         
        Q5 = 2 * (datos.I - sum(S) - sum(Q14)/2);  
    end
    Q = [Q14, Q5];

    poblacion(i,:) = [Q, S, K];
    fitness(i,1)   = f_inventario(Q, S, K);
end
end
