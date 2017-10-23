function plot_cp(x, cp, str)
  % make a Cp plot
  % param: x  -> normalized x
  % param: y  -> y points of airfoil
  % param: cp -> cp value at each x-location
  figure; hold on; grid on;

  cp(end+1) = cp(end); % pad for same size
  plot(x, cp)

  % plot(x(1:end-1), cp); % invert cp and make it comme back to the same point
  title(sprintf('C_p vs x/c, %s', str))
  xlabel('x/c');
  ylabel('C_p (axis flipped)');
  set(gca, 'Ydir', 'reverse'); % flip y axis
end
