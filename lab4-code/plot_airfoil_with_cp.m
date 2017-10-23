function plot_airfoil_with_cp(x, y, cp, str)
  assert(length(x) == length(y));
  if nargin < 4
    str = ''
  end

  N = length(x);
  cx = zeros(N, 1);
  cy = zeros(N, 1);

  % find where to place each point for the vortex panel
  for i = 1:N-1
    % find the tangential direction
    theta = atan((y(i+1)-y(i))/(x(i+1)-x(i)));
    theta = theta + pi/2; % rotate to point to the normal

    % move out cp in the normal direction
    cx(i) = x(i) - 0.1*cp(i)*cos(theta);
    cy(i) = y(i) - 0.1*cp(i)*sin(theta);
  end

  cx(end) = cx(1);

  figure
  hold on
  grid on
  axis equal
  plot(x, y)
  plot(cx, cy)
  title(sprintf('Visualization of C_p %s', str))
  xlabel('x location (m)');
  ylabel('y location (m)');
  
  for i = 1:N
    plot([x(i), cx(i)], [y(i), cy(i)])
  end
end
