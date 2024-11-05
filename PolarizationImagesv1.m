% Lee las imágenes h_pol.pgm, l_pol.pgm, m_pol.pgm, p_pol.pgm, r_pol.pgm y
% v_pol.pgm, estas son las intensidades obtenidas con el polarímetro de Stokes.

clear;
close all;
clc;

lambda = 632.8e-9;
clims = [0 255];
ri = 229;          
rf = 1327;         
ci = 125;
cf = 1892;

imext = 'Bmp';

im1 = ['m_pol.' imext];
im2 = imread(im1);
m_pol = im2;
m_pol = double(m_pol);

figure();imagesc(m_pol(ri:rf,ci:cf),clims);colormap gray;axis image;title(im1,'Interpreter','none');

figure();
subplot(3,2,2);imagesc(m_pol(ri:rf,ci:cf),clims);colormap gray;axis image;title(im1,'Interpreter','none');

im1 = ['p_pol.' imext];
im2 = imread(im1);
p_pol = im2;
p_pol = double(p_pol);

subplot(3,2,1);imagesc(p_pol(ri:rf,ci:cf),clims);colormap gray;axis image;title(im1,'Interpreter','none');

im1 = ['r_pol.' imext];
im2 = imread(im1);
r_pol = im2;
r_pol = double(r_pol);

subplot(3,2,3);imagesc(r_pol(ri:rf,ci:cf),clims);colormap gray;axis image;title(im1,'Interpreter','none');

im1 = ['l_pol.' imext];
im2 = imread(im1);
l_pol = im2;
l_pol = double(l_pol);

subplot(3,2,4);imagesc(l_pol(ri:rf,ci:cf),clims);colormap gray;axis image;title(im1,'Interpreter','none');

im1 = ['v_pol.' imext];
im2 = imread(im1);
v_pol = im2;
v_pol = double(v_pol);

subplot(3,2,5);imagesc(v_pol(ri:rf,ci:cf),clims);colormap gray;axis image;title(im1,'Interpreter','none');

im1 = ['h_pol.' imext];
im2 = imread(im1);
h_pol = im2;
h_pol = double(h_pol);

subplot(3,2,6);imagesc(h_pol(ri:rf,ci:cf),clims);colormap gray;axis image;title(im1,'Interpreter','none');

figure();imagesc(p_pol(ri:rf,ci:cf),clims);colormap gray;axis image;title('p_pol.Bmp','Interpreter','none');
dcm = datacursormode;
dcm.Enable = 'on';
dcm.DisplayStyle = 'window';
%%
% Calcula los coeficientes del vector de Stokes del estado de polarización
% de la luz medida.

s0 = v_pol + h_pol;
s1 = h_pol - v_pol;
s2 = p_pol - m_pol;
s3 = l_pol - r_pol;     

sp2 = s1.*s1 + s2.*s2 + s3.*s3;
Sp = sqrt(sp2);                         % S0 de la parte polarizada
su = s0 - Sp;                           % S0 de la parte no polarizada

S0 = Sp ./ (Sp+eps);                    % Componentes del vector de Stokes normalizados con respecto a S0 de la parte polarizada.
S1 = s1 ./ (Sp+eps);
S2 = s2 ./ (Sp+eps);
S3 = s3 ./ (Sp+eps);
Su = su ./ (Sp+eps);

DoP = Sp ./ (s0+eps);                   % Grado de polarización

clims = [-1 1];
figure();imagesc(S1(ri:rf,ci:cf),clims);colormap parula;axis image;title('S1');colorbar;
figure();imagesc(S2(ri:rf,ci:cf),clims);colormap parula;axis image;title('S2');colorbar;
figure();imagesc(S3(ri:rf,ci:cf),clims);colormap parula;axis image;title('S3');colorbar;

clims = [0 1];
figure();imagesc(S0(ri:rf,ci:cf),clims);colormap parula;axis image;title('S0');colorbar;
figure();imagesc(Su(ri:rf,ci:cf),clims);colormap parula;axis image;title('Su');colorbar;
figure();imagesc(DoP(ri:rf,ci:cf),clims);colormap parula;axis image;title('DoP');colorbar;

fase = atan2(S3,S2);                            % Diferencia de fase entre las componentes Ex y Ey del frente de onda.
fasedes = unwrap(fase(ri:rf,ci:cf),[],2);       % Fase desenvuelta
DCO = lambda*fasedes/(2*pi);                    % Diferencia de camino óptico entre las componetes Ex y Ey.
DCOmin = -pi*lambda/(2*pi);
DCOmax = 2*pi*lambda/(2*pi);
[X,Y] = meshgrid(ci:cf,ri:rf);

figure();imagesc(fasedes);colormap gray; axis image;title('Fase');colorbar;

figure();
s = mesh(X,Y,DCO);
s.EdgeColor = 'interp';
s.FaceColor = 'none';
s.LineStyle = ':';
colormap hsv;
view(45,60);
axis([ci cf ri rf DCOmin DCOmax]);
% daspect([1,1,1])
pbaspect([1024,768,512])
colorbar;
%%
% Crea una figura donde se puede puede seleccionar un pixel de la imagen y
% se muestra la información del vector de Stokes correspondiente.

S(:,:,1) = S0;
S(:,:,2) = S1;
S(:,:,3) = S2;
S(:,:,4) = S3;
S(:,:,5) = DoP;
S(:,:,6) = 0.5*asin(S3./S0)*180/pi;
S(:,:,7) = 0.5*atan2(S2,S1)*180/pi;

figure();imagesc(p_pol,[0 255]);colormap gray;axis image;axis([ci cf ri rf]);
dcm = datacursormode;
dcm.Enable = 'on';

set(dcm,'UpdateFcn',{@displayStokes,S});
%%
% Vector de Stokes del pixel (r,c)

r = 392;
c = 731;
StokesPixel(1) = S(r,c,1);
StokesPixel(2) = S(r,c,2);
StokesPixel(3) = S(r,c,3);
StokesPixel(4) = S(r,c,4);
StokesPixel
DibujaElipse(StokesPixel);
%%
% Crea una figura donde se muestran las elipses de polarización de varios
% puntos del frente de onda.

Stokes = S(:,:,1:4);
DibujaElipses(Stokes,100,100,25,p_pol,ri,rf,ci,cf);