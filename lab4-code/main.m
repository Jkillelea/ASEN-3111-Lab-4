clear
clc

c     = 1; % meters
v_inf = 50; % m/s
alpha = 5 * pi/180;
rho   = 1;
q     = 0.5 * rho * v_inf^2;

% NACA 0012 at various alpha
N = 100;
fprintf('NACA 0012\n');
for alpha = [-5, 0, 5, 10]
  % get x and y points (we get 2N-1 points returned)
  [x, y] = NACA_Airfoil(0, 0, 12, c, N);

  % trim it down to N+1 points, keep two points on the trailing edge and one on the leading edge
  x = [x(1:2:N-1); x(N); x(N+1:2:(2*N - 1))];
  y = [y(1:2:N-1); y(N); y(N+1:2:(2*N - 1))];

  % calculate things
  [gamma, cp] = Vortex_Panel(x, y, v_inf, deg2rad(alpha), N);

  % plot an save
  str = sprintf('alpha = %d', alpha);
  plot_airfoil_with_gamma(x, y, gamma, str);
  print(sprintf('graphs/gamma_alpha%d.png', alpha), '-dpng')
  plot_cp(x/c, cp, str);
  print(sprintf('graphs/cp_x_alpha%d.png', alpha), '-dpng')

  % integrate along the surface of the airfoil for total circulation
  ds = zeros(1, N+1);
  for i = 1:N-1
    ds(i) = sqrt((x(i) - x(i+1)).^2 + (y(i) - y(i+1)).^2);
  end
  Gamma = sum(2 * pi * v_inf * (gamma .* ds));
  L     = rho * v_inf * Gamma;
  cl    = L/(q*c);
  fprintf('Alpha = %d, CL = %f\n', alpha, cl);
end
close all

% various airfoils at various angles of attack
figure; hold on; grid on;
for airfoil_num = [0012, 2212, 4412, 2430]
  fprintf('NACA %s\n', naca_to_str(airfoil_num));
  [m, p, t]   = NACA_from_4_digit(airfoil_num);
  alpha_range = -3:10;
  cl_vals     = zeros(1, length(alpha_range));

  for i = 1:length(alpha_range)
    alpha  = alpha_range(i);
    [x, y] = NACA_Airfoil(m, p, t, c, N);
    x      = [x(1:2:N-1); x(N); x(N+1:2:(2*N - 1))];
    y      = [y(1:2:N-1); y(N); y(N+1:2:(2*N - 1))];

    [gamma, cp] = Vortex_Panel(x, y, v_inf, deg2rad(alpha), N);

    % integrate along the surface of the airfoil for total circulation
    ds = zeros(1, N+1);
    for j = 1:N-1
      ds(j) = sqrt((x(j) - x(j+1)).^2 + (y(j) - y(j+1)).^2);
    end
    Gamma      = sum(2 * pi * v_inf * (gamma .* ds));
    L          = rho * v_inf * Gamma;
    cl         = L/(q*c);
    cl_vals(i) = cl;
    fprintf('Alpha = %d, CL = %f\n', alpha, cl);
  end

  plot(alpha_range, cl_vals, 'DisplayName', ['NACA ', naca_to_str(airfoil_num)])
end

title('Various NACA airfoils: C_l vs \alpha')
xlabel('\alpha, Angle of Attack (degrees)');
ylabel('C_l');
legend('show', 'location', 'southeast');
print('graphs/lift_slope.png', '-dpng')
