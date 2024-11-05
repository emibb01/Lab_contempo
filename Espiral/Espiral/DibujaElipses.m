function [] = DibujaElipses(Stokes,Nx,Ny,radio,im,ri,rf,ci,cf)

S = Stokes(ri:rf,ci:cf,:);
psi = (1/2)*atan2(S(:,:,3),S(:,:,2));
a = radio;
xi = (1/2)*asin(S(:,:,4)./S(:,:,1));
b = a*tan(xi);

t = linspace(0,2*pi,2*a);
X = a * cos(t);
[r,c,~] = size(S(:,:,:));
figure()
imagesc(im(ri:rf,ci:cf));
colormap gray;
hold on
for i=Nx:Nx:c
    for j=Ny:Ny:r
        Y = b(j,i) * sin(t);
        x = X*cos(psi(j,i)) - Y*sin(psi(j,i));
        y = X*sin(psi(j,i)) + Y*cos(psi(j,i));
        if S(j,i,4)<0
            plot(-x+i,y+j,'b-', 'LineWidth', 2);
        else
            plot(-x+i,y+j,'r-', 'LineWidth', 2);
        end
    end
end 
hold off
% title(['\psi = ' num2str(psi*180/pi) ', \chi = ' num2str(xi*180/pi)]);
% grid on;
daspect([1,1,1])
pbaspect([1024,768,1])
% axis([ci cf ri rf]);
axis ij;
% xticks(0:200:c);
% yticks(0:200:r);