clear all
close all

x=[8 7 6 5];
y=[-40,-31,-29,-24];
figure
plot(x, y, '.-', 'markerSize', 18, 'lineWidth', 1);
title('THD');
xlabel('n_b');
ylabel('THD (dBc)');
xticks([5 6 7 8])
axis([4.5 8.5 -42 -23]);
grid on
