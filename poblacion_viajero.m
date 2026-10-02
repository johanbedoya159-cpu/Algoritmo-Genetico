function [poblacion, fitness] = poblacion_viajero(n)

n_ciudades = 13;

poblacion = zeros(n, n_ciudades);
fitness   = zeros(n, 1);

for i = 1:n
    poblacion(i,:) = randperm(n_ciudades);   
    fitness(i,1)   = f_viajero(poblacion(i,:));
end
end
