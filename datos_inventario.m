function datos = datos_inventario()
% DATOS_INVENTARIO  Parámetros de la Tabla II (valores en miles de COP).
%
%   datos = datos_inventario()
%
%   Se guardan en una sola función para no copiarlos en cada archivo
%   (función objetivo, población inicial y mutación los usan).

datos.D     = [12000  80000 150000 50000 100000];  % ventas anuales
datos.m     = [   20    220    900   120    180];  % valor promedio por pedido
datos.mu    = [  300   4000   7000  2000   3500];  % media de la demanda
datos.sigma = [  100   1200   2500   700   1100];  % desviación de la demanda

datos.S_max = [  200   1200   2500   800   1500];  % límite superior de S (c1)
datos.K_max = [  500   2000   5000  1500   3000];  % límite superior de K (c2)

datos.I = 8000;   % inversión promedio en inventario (Ecuación 9)

% Límite superior de Q (la Tabla II dice "infinito"):
% Por la Ecuación 9, sum(Q/2 + S) = I, y como todo es positivo,
% cada Q_i/2 <= I  ->  Q_i <= 2*I = 16000.
% Ningún Q puede ser mayor que eso sin violar la restricción.
datos.Q_max = 2 * datos.I * ones(1, 5);

datos.n_items = 5;
end
