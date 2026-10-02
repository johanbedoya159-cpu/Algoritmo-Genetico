function tiempo = f_viajero(ruta, regresar)
% F_VIAJERO  Función objetivo del problema del viajero (sección 3.1.1).
%
%   tiempo = f_viajero(ruta)            -> tiempo total del recorrido (min)
%   tiempo = f_viajero(ruta, true)      -> incluye el regreso a la ciudad inicial
%
%   ruta: vector con una permutación de los números 1 a 13.
%   Numeración (mismo orden de la Tabla I):
%     1 UCO        2 Rionegro   3 La Ceja     4 El Carmen   5 Marinilla
%     6 Guarne     7 El Retiro  8 Santuario   9 La Unión   10 San Vicente
%    11 Cocorná   12 El Peñol  13 Guatapé
%
%   Si la ruta NO es una permutación válida, se penaliza sumando 10000
%   (la suma de todos los tiempos de la tabla es 9534, así que ninguna
%   ruta válida puede llegar a ese valor).
%
%   Ejemplo: f_viajero(1:13) = 641,  f_viajero(1:13, true) = 730

if nargin == 1
    regresar = false;
end

% Tabla I: T(i,j) = minutos para ir DESDE el municipio i HASTA el municipio j
% (ojo: no es simétrica, T(1,2) = 10 pero T(2,1) = 6)
T = [  0  10  35  29  16  30  40  27  56  44  67  54  81;   % UCO
       6   0  32  31  16  32  34  28  52  44  63  56  83;   % Rionegro
      34  32   0  29  45  58  35  57  26  73  91  83 110;   % La Ceja
      29  29  28   0  32  47  57  31  49  61  67  70  99;   % El Carmen
      18  18  46  33   0  23  52  19  68  39  54  41  69;   % Marinilla
      30  30  58  46  25   0  46  36  79  39  71  62  90;   % Guarne
      40  37  36  59  52  54   0  64  61  80 104  89 117;   % El Retiro
      32  32  57  32  18  36  65   0  82  50  41  51  82;   % Santuario
      55  52  23  48  67  80  56  73   0  95 116 101 130;   % La Unión
      47  47  76  62  42  37  73  53  97   0 102  81 111;   % San Vicente
      79  79 106  80  66  87 110  59 148 101   0  97 100;   % Cocorná
      59  59  86  74  44  65  90  55 107  80  93   0  29;   % El Peñol
      89  89 116 104  74  96 119  86 137 110 103  33   0];  % Guatapé

n_ciudades = size(T, 1);
penalizacion = 10000;

ruta = ruta(:)';   % asegurar que sea vector fila

% Si hay valores que no son ciudades (ej. 0, 14 o 2.5) no se puede
% calcular el recorrido, así que se devuelve directamente un valor muy malo.
if length(ruta) ~= n_ciudades || any(ruta < 1) || any(ruta > n_ciudades) || any(ruta ~= round(ruta))
    tiempo = 2 * penalizacion;
    return
end

% Sumar el tiempo de cada tramo: ruta(1)->ruta(2), ruta(2)->ruta(3), ...
tiempo = 0;
for i = 1:(n_ciudades - 1)
    tiempo = tiempo + T(ruta(i), ruta(i+1));
end

if regresar
    tiempo = tiempo + T(ruta(end), ruta(1));
end

% Si hay ciudades repetidas (no es permutación), se penaliza
if ~isequal(sort(ruta), 1:n_ciudades)
    tiempo = tiempo + penalizacion;
end
end
