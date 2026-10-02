function mutados = mutacion_viajero(hijos, Pm)
% MUTACION_VIAJERO  Mutación por intercambio para el viajero (sección 3.4.1).
%
%   mutados = mutacion_viajero(hijos)
%   mutados = mutacion_viajero(hijos, Pm)
%
%   hijos: matriz con las rutas que salieron del cruce (una por fila).
%   Pm:    probabilidad de que cada ruta mute (por defecto 0.1 = 10%).
%
%   A cada ruta que mute se le escogen 2 posiciones al azar y se
%   intercambian sus municipios. Ejemplo (posiciones 2 y 5):
%       [1 2 3 4 5 6]  ->  [1 5 3 4 2 6]
%   Así la ruta cambia pero sigue pasando por todos los municipios una vez.

if nargin < 2
    Pm = 0.1;
end

mutados = hijos;
[n, n_ciudades] = size(hijos);

for i = 1:n
    if rand < Pm                              % ¿esta ruta muta?
        pos = randperm(n_ciudades, 2);        % 2 posiciones distintas
        mutados(i, pos) = mutados(i, fliplr(pos));   % intercambiarlas
    end
end
end
