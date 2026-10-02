clear
clc


disp("===== PROBLEMA DEL VIAJERO =====")

t1 = f_viajero(1:13);           
t2 = f_viajero(1:13, true);    
t3 = f_viajero([1 1 3:13]);    
fprintf("Ruta 1..13:               %g min (esperado 641)\n", t1)
fprintf("Ruta 1..13 con regreso:   %g min (esperado 730)\n", t2)
fprintf("Ruta inválida:            %g (penalizada, > 10000)\n\n", t3)

n = 20;
[pob_viajero, fit_viajero] = poblacion_viajero(n);
[mejor, idx] = min(fit_viajero);
fprintf("Población de %d rutas. Mejor tiempo: %g min\n", n, mejor)
fprintf("Mejor ruta: %s\n", mat2str(pob_viajero(idx,:)))
fprintf("¿Todas son permutaciones válidas? %d\n\n", ...
    all(arrayfun(@(i) isequal(sort(pob_viajero(i,:)), 1:13), 1:n)))


disp("===== FUNCIÓN ACKLEY =====")

fprintf("f_ackley([0 0 0]) = %.6f   (3 - e = %.6f)\n", f_ackley([0 0 0]), 3 - exp(1))
fprintf("f_ackley([1 1 1]) = %.6f\n\n", f_ackley([1 1 1]))

n = 20;  d = 3;
[pob_ackley, fit_ackley] = poblacion_ackley(n, d, [-10 10]);
[mejor, idx] = min(fit_ackley);
fprintf("Población de %d x %d. Mejor fitness: %.4f\n", n, d, mejor)
fprintf("Mejor individuo: %s\n", mat2str(pob_ackley(idx,:), 4))
fprintf("Rango de valores generados: [%.2f, %.2f]\n\n", min(pob_ackley(:)), max(pob_ackley(:)))


disp("===== PROBLEMA DE INVENTARIOS =====")

n = 20;
tic
[pob_inv, fit_inv] = poblacion_inventario(n);
fprintf("Población de %d individuos generada en %.2f s\n", n, toc)


Q = pob_inv(:, 1:5);
S = pob_inv(:, 6:10);
restriccion = sum(Q/2 + S, 2);   
fprintf("Ecuación 9 -> mínimo: %.4f, máximo: %.4f (debe ser 8000)\n", min(restriccion), max(restriccion))

[mejor, idx] = min(fit_inv);
fprintf("Mejor Z: %.2f\n", mejor)
fprintf("Mejor Q: %s\n", mat2str(pob_inv(idx, 1:5), 5))
fprintf("Mejor S: %s\n", mat2str(pob_inv(idx, 6:10), 5))
fprintf("Mejor K: %s\n", mat2str(pob_inv(idx, 11:15), 5))
