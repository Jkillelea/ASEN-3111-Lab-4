clear
clc

c     = 2; % meters
v_inf = 100;
alpha = 8 * pi/180;
rho   = 1;
q     = 0.5 * rho * v_inf^2;
N     = 12; % points

[x, y] = NACA_Airfoil(4, 4, 12, 1, N);
x = [x(1:2:N-1); x(N); x(N+1:2:(2*N - 1))];
y = [y(1:2:N-1); y(N); y(N+1:2:(2*N - 1))];

% x = [1, .933, .75, .5, .25, .067, .0, .067, .25, .5, .75, .933, 1];
% y = [0, -0.005, -0.017, -0.033, -0.042, -0.033, 0, .045, .076, .072, .044, .013, 0];

gamma = Vortex_Panel(x, y, v_inf, alpha, N);

ds = zeros(1, N+1);
for i = 1:N-1
  ds(i) = sqrt((x(i) - x(i+1)).^2 + (y(i) - y(i+1)).^2);
end

Gamma = sum(gamma .* ds);

L = rho * v_inf * Gamma;

cl = L/(q*c)
