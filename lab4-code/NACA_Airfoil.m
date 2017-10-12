function [x, y] = NACA_Airfoil(m, p, t, c, N)
  % m -> maximum camber
  % p -> location of max camber
  % t -> thickness
  % c -> chord length
  % N -> number of panels to be used

  x = linspace(0, c, N);

  % coefficients
  c1 =  0.2969;
  c2 = -0.1260;
  c3 = -0.3516;
  c4 =  0.2843;
  c5 = -0.1036;

  % half thickness (from the mean camber line)
  yt = (t*c/0.2).* (c1.*sqrt(x./c) + c2.*(x./c)    ...
                  + c3.*(x./c).^2  + c4.*(x./c).^3 ...
                  + c5.*(x./c).^4);

  y_c = yc(x, p, c, m);

  zeta = atan(diff(y_c));
  zeta(end+1) = 0; % pad it so dimensions match

  % upper and lower surfaces
  xu = (x - yt.*sin(zeta))';
  xl = (x + yt.*sin(zeta))';

  yu = (y_c + yt.*cos(zeta))';
  yl = (y_c - yt.*cos(zeta))';

  % format and return
  x = [xu, xl];
  y = [yu, yl];
end

% mean camber line
function y_c = yc(x, p, c, m)
  if (0 <= x) & (x <= p*c)
    y_c = (m/p^2).*x.*(2*p - x./c);
  else
    y_c = (m/(1-p)^2).*(c - x).*(1 + x./c - 2*p);
  end
end
