clear; clc;

% example: NACA 4412 -> m = 0.04, p = 0.4, t = 0.12
m = 0.04;
p = 0.4;
t = 0.12;
c = 1;
N = 1000;

[x, y] = NACA_Airfoil(m, p, t, c, N);

xu = x(:, 1);
xl = x(:, 2);

yu = y(:, 1);
yl = y(:, 2);

figure; hold on;
plot(xu, yu);
plot(xl, yl);
axis([0 c -c c]);
