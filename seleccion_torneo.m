function ganadores = seleccion_torneo(fitness, tam_grupo, ganan_por_grupo)

if nargin < 2
    tam_grupo = 4;
end
if nargin < 3
    ganan_por_grupo = 2;
end

n = length(fitness);
n_seleccionados = floor(n/2);

disponibles = 1:n;   
ganadores = [];

while length(ganadores) < n_seleccionados
    
    if length(disponibles) < tam_grupo
        disponibles = setdiff(1:n, ganadores);
    end
    tam = min(tam_grupo, length(disponibles));

    
    posiciones = randperm(length(disponibles), tam);
    grupo = disponibles(posiciones);

    
    [~, orden] = sort(fitness(grupo), 'ascend');
    ganadores = [ganadores, grupo(orden(1:min(ganan_por_grupo, tam)))];

    
    disponibles(posiciones) = [];
end

ganadores = ganadores(1:n_seleccionados);
end
