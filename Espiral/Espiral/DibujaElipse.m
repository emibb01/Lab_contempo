function [] = DibujaElipse(S)

psi = (1/2)*atan2(S(3),S(2));
a = 0.5;
xi = (1/2)*asin(S(4)/S(1));
b = a*tan(xi);

t = linspace(0,2*pi,300);
X = a * cos(t);
Y = b * sin(t);

x = X*cos(psi) - Y*sin(psi);
y = X*sin(psi) + Y*cos(psi);

figure();
if S(4)<0
    plot(x,y,'b-', 'LineWidth', 2);
else
    plot(x,y,'r-', 'LineWidth', 2);
end
title(['\psi = ' num2str(psi*180/pi) ', \chi = ' num2str(xi*180/pi)]);
grid on;
axis equal
axis([-a a -a a]);
xticks(-a:0.1:a);
yticks(-a:0.1:a);