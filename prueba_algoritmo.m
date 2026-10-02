%% PRUEBA PARTE 5: algoritmo genético completo
% Ejecute este script con todos los archivos .m en la misma carpeta.
% Corre el algoritmo una vez en cada problema (torneo, 100 iteraciones)
% y muestra cómo va mejorando.
clear
clc
close all

municipios = {'UCO', 'Rionegro', 'La Ceja', 'El Carmen', 'Marinilla', 'Guarne', ...
              'El Retiro', 'Santuario', 'La Unión', 'San Vicente', 'Cocorná', ...
              'El Peñol', 'Guatapé'};

%% 1. Viajero
disp("===== VIAJERO (torneo, 100 iteraciones) =====")
rv = algoritmo_genetico("viajero", "torneo", 100);
fprintf("Mejor tiempo: %g min   (la ruta 1..13 de la guía da 641)\n", rv.mejor_f)
fprintf("Mejor ruta:   %s\n", mat2str(rv.mejor_x))
fprintf("Recorrido:    %s\n", strjoin(municipios(rv.mejor_x), ' -> '))
fprintf("Tiempo de ejecución: %.2f s\n\n", rv.tiempo)

%% 2. Ackley
disp("===== ACKLEY, 3 dimensiones (torneo, 100 iteraciones) =====")
ra = algoritmo_genetico("ackley", "torneo", 100);
fprintf("Mejor fitness: %.6f   (el óptimo es 3 - e = %.6f)\n", ra.mejor_f, 3 - exp(1))
fprintf("Mejor punto:   %s   (el óptimo es [0 0 0])\n", mat2str(ra.mejor_x, 4))
fprintf("Tiempo de ejecución: %.2f s\n\n", ra.tiempo)

%% 3. Inventarios
disp("===== INVENTARIOS (torneo, 100 iteraciones) =====")
ri = algoritmo_genetico("inventario", "torneo", 100);
fprintf("Mejor Z: %.4f\n", ri.mejor_f)
fprintf("Q: %s\n", mat2str(ri.mejor_x(1:5), 5))
fprintf("S: %s\n", mat2str(ri.mejor_x(6:10), 5))
fprintf("K: %s\n", mat2str(ri.mejor_x(11:15), 5))
fprintf("Ecuación 9: %.4f (debe ser 8000)\n", sum(ri.mejor_x(1:5)/2 + ri.mejor_x(6:10)))
fprintf("Tiempo de ejecución: %.2f s\n\n", ri.tiempo)

%% 4. Gráficas de convergencia
% Muestran el mejor fitness encontrado en cada generación.
% Deben bajar (rápido al principio y más lento al final).
figure
subplot(1, 3, 1)
plot(rv.convergencia, 'LineWidth', 1.5)
title("Viajero"), xlabel("Iteración"), ylabel("Mejor tiempo (min)"), grid on

subplot(1, 3, 2)
plot(ra.convergencia, 'LineWidth', 1.5)
title("Ackley (d = 3)"), xlabel("Iteración"), ylabel("Mejor fitness"), grid on

subplot(1, 3, 3)
plot(ri.convergencia, 'LineWidth', 1.5)
title("Inventarios"), xlabel("Iteración"), ylabel("Mejor Z"), grid on
