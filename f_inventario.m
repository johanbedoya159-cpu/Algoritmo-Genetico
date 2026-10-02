function Z = f_inventario(Q, S, K)
% F_INVENTARIO  Función objetivo del problema de inventarios (sección 3.1.3).
%
%   Z = f_inventario(Q, S, K)   con Q, S y K vectores de 5 valores
%   Z = f_inventario(X)         con X = [Q S K] (vector de 15 valores)
%
%   Calcula el número anual esperado de pedidos no atendidos por falta
%   de inventario (Ecuación 8):
%
%     Z = sum_i  D_i/Q_i * integral desde (S_i+K_i) hasta inf de
%                (x - S_i - K_i) / (m_i*sqrt(2*pi)*sigma_i) * exp(-1/2*((x-mu_i)/sigma_i)^2) dx
%
%   Si el individuo no cumple los límites de la Tabla II o la restricción
%   de la Ecuación 9 (sum(Q/2 + S) = I), se penaliza sumando un valor muy alto.

if nargin == 1
    X = Q;
    Q = X(1:5);
    S = X(6:10);
    K = X(11:15);
elseif nargin ~= 3
    error("Use f_inventario(Q, S, K) o f_inventario([Q S K])");
end

datos = datos_inventario();
penalizacion = 1e7;

% Q <= 0 no tiene sentido (D/Q se vuelve infinito o negativo)
if any(Q <= 0)
    Z = 2 * penalizacion;
    return
end

Z = 0;
for i = 1:datos.n_items
    R  = S(i) + K(i);              % punto de reorden
    mu = datos.mu(i);
    sg = datos.sigma(i);
    mi = datos.m(i);

    % Integrando de la Ecuación 8 (con .* y ./ porque "integral" evalúa vectores)
    integrando = @(x) (x - R) ./ (mi * sqrt(2*pi) * sg) .* exp(-0.5 * ((x - mu) / sg).^2);

    Z = Z + datos.D(i) / Q(i) * integral(integrando, R, Inf);
end

% ---- Restricciones ----
cumple_limites = all(Q <= datos.Q_max) && ...
                 all(S >= 0) && all(S <= datos.S_max) && ...
                 all(K >= 0) && all(K <= datos.K_max);

cumple_ec9 = abs(sum(Q/2 + S) - datos.I) <= 1e-6 * datos.I;

if ~cumple_limites || ~cumple_ec9
    Z = Z + penalizacion;
end
end
