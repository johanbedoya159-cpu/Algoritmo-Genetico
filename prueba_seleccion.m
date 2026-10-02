clear
clc


disp("===== EJEMPLO CON 8 INDIVIDUOS =====")
fitness = [5 1 8 3 9 2 7 4]';   
fprintf("Fitness de cada individuo: %s\n\n", mat2str(fitness'))

g = seleccion_elitismo(fitness);
fprintf("Elitismo -> ganadores: %s  | su fitness: %s\n", mat2str(g), mat2str(fitness(g)'))
fprintf("   (siempre deben ser los individuos 2, 6, 4 y 8, en cualquier orden)\n\n")

g = seleccion_torneo(fitness);
fprintf("Torneo   -> ganadores: %s  | su fitness: %s\n", mat2str(g), mat2str(fitness(g)'))
fprintf("   (cambia cada vez porque los grupos se arman al azar)\n\n")

g = seleccion_ruleta(fitness);
fprintf("Ruleta   -> ganadores: %s  | su fitness: %s\n", mat2str(g), mat2str(fitness(g)'))
fprintf("   (cambia cada vez; los de menor fitness salen más seguido)\n\n")


disp("===== VECES QUE SALE ESCOGIDO CADA INDIVIDUO (de 5000) =====")
repeticiones = 5000;
conteo = zeros(3, length(fitness));
for k = 1:repeticiones
    g = seleccion_elitismo(fitness);  conteo(1, g) = conteo(1, g) + 1;
    g = seleccion_torneo(fitness);    conteo(2, g) = conteo(2, g) + 1;
    g = seleccion_ruleta(fitness);    conteo(3, g) = conteo(3, g) + 1;
end
fprintf("Individuo:  "); fprintf("%6d", 1:8);        fprintf("\n")
fprintf("Fitness:    "); fprintf("%6d", fitness);    fprintf("\n")
fprintf("Elitismo:   "); fprintf("%6d", conteo(1,:)); fprintf("\n")
fprintf("Torneo:     "); fprintf("%6d", conteo(2,:)); fprintf("\n")
fprintf("Ruleta:     "); fprintf("%6d", conteo(3,:)); fprintf("\n\n")


disp("===== FITNESS PROMEDIO: POBLACIÓN COMPLETA vs SELECCIONADOS =====")
n = 40;
[~, fit_v] = poblacion_viajero(n);
[~, fit_a] = poblacion_ackley(n, 3, [-10 10]);
[~, fit_i] = poblacion_inventario(n);

problemas = {"Viajero", "Ackley", "Inventario"};
fits = {fit_v, fit_a, fit_i};
repeticiones = 200;   
fprintf("%-11s %12s %12s %12s %12s\n", "Problema", "Población", "Elitismo", "Torneo", "Ruleta")
for p = 1:3
    f = fits{p};
    prom = zeros(repeticiones, 3);
    for k = 1:repeticiones
        prom(k,1) = mean(f(seleccion_elitismo(f)));
        prom(k,2) = mean(f(seleccion_torneo(f)));
        prom(k,3) = mean(f(seleccion_ruleta(f)));
    end
    fprintf("%-11s %12.2f %12.2f %12.2f %12.2f\n", problemas{p}, mean(f), mean(prom))
end
disp("(como se minimiza, el promedio de los seleccionados debe ser menor que el de la población)")
