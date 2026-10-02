function mutados = mutacion_ackley(hijos, Pm, sigma_m, limites)
% MUTACION_ACKLEY  Mutación gaussiana para la función Ackley (sección 3.4.2).
%
%   mutados = mutacion_ackley(hijos)
%   mutados = mutacion_ackley(hijos, Pm, sigma_m, limites)
%
%   hijos:   matriz con los puntos que salieron del cruce (uno por fila).
%   Pm:      probabilidad de que cada individuo mute (por defecto 0.1).
%   sigma_m: desviación estándar de la mutación, o sea, qué tan grande es
%            el cambio (por defecto 1).
%   limites: [minimo maximo] del dominio (por defecto [-10 10]).
%
%   A cada individuo que mute se le escoge UNA posición al azar y se le
%   suma un número aleatorio de una distribución normal (Ecuaciones 13 y 14):
%       x_nuevo = x + r,   con r = sigma_m * randn
%   Si el valor se sale del dominio, se recorta al límite.

if nargin < 2
    Pm = 0.1;
end
if nargin < 3
    sigma_m = 1;
end
if nargin < 4
    limites = [-10 10];
end
li = min(limites);
ls = max(limites);

mutados = hijos;
[n, d] = size(hijos);

for i = 1:n
    if rand < Pm
        j = randi(d);                                   % posición al azar
        nuevo = mutados(i, j) + sigma_m * randn;        % Ecuaciones 13 y 14
        mutados(i, j) = min(max(nuevo, li), ls);        % no salirse de [-10, 10]
    end
end
end
