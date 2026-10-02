function [poblacion, fitness] = poblacion_viajero(n)
% POBLACION_VIAJERO  Población inicial del problema del viajero (sección 3.2.1).
%
%   [poblacion, fitness] = poblacion_viajero(n)
%
%   n: número de individuos (rutas) a generar.
%   poblacion: matriz n x 13, cada fila es una permutación de 1 a 13
%              (ningún municipio se repite dentro de una misma ruta).
%   fitness:   vector columna n x 1 con el tiempo de cada ruta.

n_ciudades = 13;

poblacion = zeros(n, n_ciudades);
fitness   = zeros(n, 1);

for i = 1:n
    poblacion(i,:) = randperm(n_ciudades);   % orden aleatorio sin repetir
    fitness(i,1)   = f_viajero(poblacion(i,:));
end
end
