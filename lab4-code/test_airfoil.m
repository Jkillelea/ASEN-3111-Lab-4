clear; clc;

% example: NACA 4412 -> m = 0.04, p = 0.4, t = 0.12
m = 4;
p = 4;
t = 12;
c = 1;
N = 12;

[x, y] = NACA_Airfoil(m, p, t, c, N);

figure; hold on;
plot(x, y);
axis([0 c -c c]);
