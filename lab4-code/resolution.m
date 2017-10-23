clear
clc

c     = 1; % meters
v_inf = 50; % m/s
alpha = 5 * pi/180;
rho   = 1;
q     = 0.5 * rho * v_inf^2;
N_range = 10:10:200;
cls = zeros(1, length(N_range));

% NACA 0012 at various resolutions
for k = 1:length(N_range)
  N = N_range(k);

  % get x and y points (we get 2N-1 points returned)
  [x, y] = NACA_Airfoil(0, 0, 12, c, N);

  % trim it down to N+1 points, keep two points on the trailing edge and one on the leading edge
  x = [x(1:2:N-1); x(N); x(N+1:2:(2*N - 1))];
  y = [y(1:2:N-1); y(N); y(N+1:2:(2*N - 1))];

  [gamma, cp] = Vortex_Panel(x, y, v_inf, alpha, N);

  % integrate along the surface of the airfoil for total circulation
  ds = zeros(1, N+1);
  for i = 1:N-1
    ds(i) = sqrt((x(i) - x(i+1)).^2 + (y(i) - y(i+1)).^2);
  end

  Gamma = sum(2 * pi * v_inf * (gamma .* ds));
  L = rho * v_inf * Gamma;
  cl = L/(q*c);

  fprintf('N = %d, Cl = %.3f\n', N, cl);
  cls(k) = cl;
end

figure; hold on; grid on;
title('C_l estimate vs number of panels')
scatter(N_range, cls);
plot([0, max(N_range)], [cls(end), cls(end)])
xlabel('Number of panels, N');
ylabel('Estimated C_l');
print('graphs/resolution.png', '-dpng')
