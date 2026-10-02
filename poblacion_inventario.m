function [poblacion, fitness] = poblacion_inventario(n)
% POBLACION_INVENTARIO  Población inicial del problema de inventarios (sección 3.2.3).
%
%   [poblacion, fitness] = poblacion_inventario(n)
%
%   Cada individuo tiene 15 variables organizadas así:
%       [Q1 Q2 Q3 Q4 Q5  S1 S2 S3 S4 S5  K1 K2 K3 K4 K5]
%
%   Se generan 14 al azar dentro de los límites de la Tabla II y la
%   variable faltante (Q5) se calcula con la Ecuación 9:
%       sum(Q/2 + S) = I   ->   Q5 = 2*(I - sum(S) - sum(Q1..Q4)/2)
%
%   Si Q5 queda por fuera de sus límites (negativo o muy grande), el
%   individuo se vuelve a generar, igual que en el LiveScript del profe
%   se regeneran las mochilas que se pasan del volumen.

datos = datos_inventario();

poblacion = zeros(n, 15);
fitness   = zeros(n, 1);

for i = 1:n
    Q5 = -1;
    while Q5 <= 0 || Q5 > datos.Q_max(5)
        Q14 = rand(1, 4) .* datos.Q_max(1:4);   % Q1 a Q4 en (0, Q_max)
        S   = rand(1, 5) .* datos.S_max;         % S en [0, S_max]
        K   = rand(1, 5) .* datos.K_max;         % K en [0, K_max]

        Q5 = 2 * (datos.I - sum(S) - sum(Q14)/2);  % Ecuación 9
    end
    Q = [Q14, Q5];

    poblacion(i,:) = [Q, S, K];
    fitness(i,1)   = f_inventario(Q, S, K);
end
end
