clc
c     = 1; % meters
v_inf = 50; % m/s
alpha = 5 * pi/180;
rho   = 1;
q     = 0.5 * rho * v_inf^2;

% Cuethe and Chow test case (N = 12)
N = 12;
alpha = 8 * pi/180;
x = [1, .933, .75, .5, .25, .067, .0, .067, .25, .5, .75, .933, 1];
y = [0, -0.005, -0.017, -0.033, -0.042, -0.033, 0, .045, .076, .072, .044, .013, 0];

[gamma, cp] = Vortex_Panel(x, y, v_inf, alpha, N);

% plot_airfoil_with_gamma(x, y, gamma, str);
% plot_cp(x/c, cp, str);
% plot_airfoil_with_cp(x, y, cp, str);

str = 'Cuethe and Chow case';
plot_airfoil_with_gamma(x, y, gamma, str);
print('graphs/cuethe_and_chow_gamma.png', '-dpng')
plot_cp(x/c, cp, str);
print('graphs/cuethe_and_chow_cp.png', '-dpng')

% integrate along the surface of the airfoil for total circulation
ds = zeros(1, N+1);
for i = 1:N-1
  ds(i) = sqrt((x(i) - x(i+1)).^2 + (y(i) - y(i+1)).^2);
end

Gamma = sum(2 * pi * v_inf * (gamma .* ds));
L = rho * v_inf * Gamma;
cl = L/(q*c)
