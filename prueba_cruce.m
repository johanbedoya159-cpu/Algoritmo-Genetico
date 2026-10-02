clear
clc
n = 40;   


disp("===== CRUCE VIAJERO (OX) =====")
[pob, fit] = poblacion_viajero(n);
ganadores = seleccion_torneo(fit);
hijos = cruce_viajero(pob, ganadores);

fprintf("Padre:  %s\n", mat2str(pob(ganadores(1), :)))
fprintf("Madre:  %s\n", mat2str(pob(ganadores(2), :)))
fprintf("Hijo 1: %s\n", mat2str(hijos(1, :)))
fprintf("Hijo 2: %s\n", mat2str(hijos(2, :)))


invalidos = 0;
for rep = 1:500
    hijos = cruce_viajero(pob, seleccion_torneo(fit));
    for i = 1:size(hijos, 1)
        if ~isequal(sort(hijos(i,:)), 1:13)
            invalidos = invalidos + 1;
        end
    end
end
fprintf("Hijos inválidos en 500 cruces de toda la población: %d (debe ser 0)\n\n", invalidos)


disp("===== CRUCE ACKLEY (BLX-alfa, alfa = 0.5) =====")
[pob, fit] = poblacion_ackley(n, 3, [-10 10]);
ganadores = seleccion_torneo(fit);
hijos = cruce_ackley(pob, ganadores);

fprintf("Padre:  %s\n", mat2str(pob(ganadores(1), :), 4))
fprintf("Madre:  %s\n", mat2str(pob(ganadores(2), :), 4))
fprintf("Hijo 1: %s\n", mat2str(hijos(1, :), 4))
fprintf("Hijo 2: %s\n", mat2str(hijos(2, :), 4))
fprintf("Rango de todos los hijos: [%.2f, %.2f] (debe estar dentro de [-10, 10])\n\n", ...
    min(hijos(:)), max(hijos(:)))


disp("===== CRUCE INVENTARIOS (aritmético) =====")
[pob, fit] = poblacion_inventario(n);
ganadores = seleccion_torneo(fit);
hijos = cruce_inventario(pob, ganadores);

fprintf("Q del padre:  %s\n", mat2str(pob(ganadores(1), 1:5), 5))
fprintf("Q de la madre: %s\n", mat2str(pob(ganadores(2), 1:5), 5))
fprintf("Q del hijo 1: %s\n", mat2str(hijos(1, 1:5), 5))

restriccion = sum(hijos(:,1:5)/2 + hijos(:,6:10), 2);
fprintf("Ecuación 9 en los hijos -> mínimo: %.4f, máximo: %.4f (debe ser 8000)\n", ...
    min(restriccion), max(restriccion))

fit_hijos = zeros(size(hijos, 1), 1);
for i = 1:size(hijos, 1)
    fit_hijos(i) = f_inventario(hijos(i, :));
end
fprintf("Hijos penalizados (Z >= 10^7): %d (debe ser 0)\n\n", sum(fit_hijos >= 1e7))


disp("===== UNA GENERACIÓN: FITNESS PROMEDIO ANTES Y DESPUÉS =====")

[pob, fit] = poblacion_viajero(n);
g = seleccion_torneo(fit);
nueva = [pob(g,:); cruce_viajero(pob, g)];
fit_nueva = zeros(n,1);
for i = 1:n, fit_nueva(i) = f_viajero(nueva(i,:)); end
fprintf("Viajero:    antes %9.2f  ->  después %9.2f\n", mean(fit), mean(fit_nueva))

[pob, fit] = poblacion_ackley(n, 3, [-10 10]);
g = seleccion_torneo(fit);
nueva = [pob(g,:); cruce_ackley(pob, g)];
fit_nueva = f_ackley(nueva);
fprintf("Ackley:     antes %9.2f  ->  después %9.2f\n", mean(fit), mean(fit_nueva))

[pob, fit] = poblacion_inventario(n);
g = seleccion_torneo(fit);
nueva = [pob(g,:); cruce_inventario(pob, g)];
fit_nueva = zeros(n,1);
for i = 1:n, fit_nueva(i) = f_inventario(nueva(i,:)); end
fprintf("Inventario: antes %9.2f  ->  después %9.2f\n", mean(fit), mean(fit_nueva))
disp("(en general el promedio debe bajar de una generación a la siguiente)")
