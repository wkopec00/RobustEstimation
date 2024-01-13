clc, clear

k = 2.5;

% Definiowanie zakresu x
x1 = linspace(-10, -k, 100);  % Zakres dla x < -k
x2 = linspace(-k, k, 100);    % Zakres dla -k < x < k
x3 = linspace(k, 10, 100);    % Zakres dla x > k

% Definiowanie funkcji y w poszczególnych zakresach
y1 = exp(-abs(x1)/k);
y2 = ones(size(x2));
y3 = exp(-abs(x3)/k);

% Rysowanie wykresu
figure;
plot(x1, y1, 'b', 'LineWidth', 2);  % x < -k
hold on;
plot(x2, y2, 'b', 'LineWidth', 2);  % -k < x < k
plot(x3, y3, 'b', 'LineWidth', 2);  % x > k

% Dodanie oznaczeń
xlabel('Współczynnik k');
ylabel('v');
title('Wykres funkcji zdefiniowanej przez warunki');

% Dodanie linii pionowej w miejscu x = -k i x = k

plot([-k, -k], [0, 1], 'k--');
plot([k, k], [0, 1], 'k--');

% Legenda
%legend('y = 0 dla x < -k i x > k', 'y = 1 dla -k < x < k', 'Location', 'Best');

% Ustawienie osi
axis([-4, 4, -0.1, 1.1]);
%axis equal;

% Wyłączenie podwójnych oznaczeń na osi Y
box off;

grid on;
% Wyłączenie trybu "hold"
hold off;