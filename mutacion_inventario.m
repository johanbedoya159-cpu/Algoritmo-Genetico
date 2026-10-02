function mutados = mutacion_inventario(hijos, Pm, escala)
% MUTACION_INVENTARIO  Mutación gaussiana para inventarios (sección 3.4.3).
%
%   mutados = mutacion_inventario(hijos)
%   mutados = mutacion_inventario(hijos, Pm, escala)
%
%   hijos:  matriz n x 15, cada fila es [Q1..Q5 S1..S5 K1..K5].
%   Pm:     probabilidad de que cada individuo mute (por defecto 0.1).
%   escala: tamaño de la mutación como fracción del rango de cada variable
%           (por defecto 0.1 = 10% del rango). Se usa una fracción del rango
%           porque las variables tienen escalas muy distintas: por ejemplo,
%           S1 va de 0 a 200 y Q va de 0 a 16000.
%
%   A cada individuo que mute:
%   1. Se escoge al azar una de las 14 variables independientes
%      (Q1 a Q4, S1 a S5 o K1 a K5; Q5 no, porque se calcula).
%   2. Se le suma un número de una distribución normal:
%         x_nuevo = x + escala * (rango de x) * randn
%   3. Se recalcula Q5 con la Ecuación 9 para que se siga cumpliendo.
%   4. Si la variable o Q5 quedan fuera de los límites de la Tabla II,
%      se intenta otra vez (máximo 20 intentos). Si no se logra, el
%      individuo se queda como estaba.

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

independientes = [1:4, 6:15];   % todas menos Q5 (posición 5)
max_intentos = 20;

mutados = hijos;
n = size(hijos, 1);

for i = 1:n
    if rand < Pm
        for intento = 1:max_intentos
            nuevo = mutados(i, :);

            % 1 y 2: escoger una variable y sumarle ruido normal
            j = independientes(randi(length(independientes)));
            nuevo(j) = nuevo(j) + escala * rango(j) * randn;

            % 3: recalcular Q5 con la Ecuación 9
            Q = nuevo(1:5);
            S = nuevo(6:10);
            nuevo(5) = 2 * (datos.I - sum(S) - sum(Q(1:4))/2);

            % 4: comprobar límites (Q debe ser mayor que 0)
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
