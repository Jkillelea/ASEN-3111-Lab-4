function plot_airfoil_with_gamma(x, y, gamma)
  assert(length(x) == length(y));
  assert(length(x) == length(gamma));

  N = length(x); % number of points

  gx = zeros(N, 1);
  gy = zeros(N, 1);

  for i = 1:N-1
    theta = atan((y(i+1)-y(i))/(x(i+1)-x(i)));
    theta = theta + pi/2; % rotate to point to the normal

    gx(i) = x(i) + gamma(i)*cos(theta);
    gy(i) = y(i) + gamma(i)*sin(theta);
  end

  % Kutta condition
  gx(end) = gx(1);
  gy(end) = -gy(1);

  figure
  hold on
  grid on
  axis equal
  plot(x, y)
  plot(gx, gy)

  for i = 1:N
    plot([x(i), gx(i)], [y(i), gy(i)])
  end

end
