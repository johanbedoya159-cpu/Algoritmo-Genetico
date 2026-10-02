clear
clc


disp("===== MUTACIÓN VIAJERO (intercambio) =====")
ruta = 1:13;
mutada = mutacion_viajero(ruta, 1);  
fprintf("Antes:   %s\n", mat2str(ruta))
fprintf("Después: %s\n", mat2str(mutada))
fprintf("Posiciones que cambiaron: %s (deben ser 2)\n", mat2str(find(ruta ~= mutada)))


[pob, ~] = poblacion_viajero(1000);
mutados = mutacion_viajero(pob, 0.1);
cambiaron = sum(any(pob ~= mutados, 2));
validas = all(arrayfun(@(i) isequal(sort(mutados(i,:)), 1:13), 1:1000));
fprintf("Con Pm = 0.1 mutaron %d de 1000 rutas (cerca de 100)\n", cambiaron)
fprintf("¿Todas siguen siendo rutas válidas? %d\n\n", validas)


disp("===== MUTACIÓN ACKLEY (normal, sigma = 1) =====")
x = [2 -3 5];
mutado = mutacion_ackley(x, 1, 1);
fprintf("Antes:   %s\n", mat2str(x, 4))
fprintf("Después: %s  (solo cambia una posición)\n", mat2str(mutado, 4))

[pob, ~] = poblacion_ackley(1000, 3, [-10 10]);
mutados = mutacion_ackley(pob, 1, 50);   
fprintf("Con sigma = 50, rango después de mutar: [%.2f, %.2f] (debe seguir en [-10, 10])\n\n", ...
    min(mutados(:)), max(mutados(:)))


disp("===== MUTACIÓN INVENTARIOS (normal, 10% del rango) =====")
[pob, ~] = poblacion_inventario(200);
mutados = mutacion_inventario(pob, 1);   

ind = 1;
fprintf("Antes:   %s\n", mat2str(pob(ind,:), 5))
fprintf("Después: %s\n", mat2str(mutados(ind,:), 5))
fprintf("Variables que cambiaron en ese individuo: %s\n", mat2str(find(abs(pob(ind,:) - mutados(ind,:)) > 1e-9)))
fprintf("  (una variable + Q5, que es la 5; si mutó una K, solo cambia esa)\n")

restriccion = sum(mutados(:,1:5)/2 + mutados(:,6:10), 2);
fprintf("Ecuación 9 después de mutar -> mínimo: %.4f, máximo: %.4f (debe ser 8000)\n", ...
    min(restriccion), max(restriccion))
fit_mut = zeros(200,1);
for i = 1:200, fit_mut(i) = f_inventario(mutados(i,:)); end
fprintf("Individuos penalizados después de mutar: %d (debe ser 0)\n", sum(fit_mut >= 1e7))
fprintf("Individuos que sí cambiaron: %d de 200\n", sum(any(abs(pob - mutados) > 1e-9, 2)))
