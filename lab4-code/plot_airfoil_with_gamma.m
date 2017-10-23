function plot_airfoil_with_gamma(x, y, gamma, str)
  % plot the vortex panels around an airfoil
  % param: x     -> x location points of the airfoil
  % param: y     -> y location points of the airfoil
  % param: gamma -> gamma value at each (x, y) pair

  assert(length(x) == length(y)); % make sure everything is the same length
  assert(length(x) == length(gamma));

  N = length(x); % number of points

  gx = zeros(N, 1);
  gy = zeros(N, 1);

  % find where to place each point for the vortex panel
  for i = 1:N-1
    % find the tangent direction
    theta = atan((y(i+1)-y(i))/(x(i+1)-x(i)));
    theta = theta + pi/2; % rotate to point to the normal

    % move out gamma in the normal direction
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
  title(sprintf('Visualization of vortex panels, %s', str))
  xlabel('x location (m)');
  ylabel('y location (m)');

  for i = 1:N
    plot([x(i), gx(i)], [y(i), gy(i)])
  end
end % function plot_airfoil_with_gamma
