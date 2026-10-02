function mutados = mutacion_inventario(hijos, Pm, escala)


if nargin < 2
    Pm = 0.1;
end
if nargin < 3
    escala = 0.1;
end

datos = datos_inventario();
limite_inf = [zeros(1,5), zeros(1,5), zeros(1,5)];
limite_sup = [datos.Q_max, datos.S_max, datos.K_max];
rango = limite_sup - limite_inf;

independientes = [1:4, 6:15];   
max_intentos = 20;

mutados = hijos;
n = size(hijos, 1);

for i = 1:n
    if rand < Pm
        for intento = 1:max_intentos
            nuevo = mutados(i, :);

           
            j = independientes(randi(length(independientes)));
            nuevo(j) = nuevo(j) + escala * rango(j) * randn;

            
            Q = nuevo(1:5);
            S = nuevo(6:10);
            nuevo(5) = 2 * (datos.I - sum(S) - sum(Q(1:4))/2);

           
            Q_ok = all(nuevo(1:5) > 0) && all(nuevo(1:5) <= datos.Q_max);
            SK_ok = all(nuevo(6:15) >= limite_inf(6:15)) && all(nuevo(6:15) <= limite_sup(6:15));
            if Q_ok && SK_ok
                mutados(i, :) = nuevo;
                break
            end
        end
    end
end
end
