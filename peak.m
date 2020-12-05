% Trabajo final de laboratorio TDSÑ 2018-2019
% Integrantes del grupo:
% LUCIA LARRAONA SÁNCHEZ
% ÁLVARO HERNÁNDEZ MONTES 

% Función que define el filtro tipo peak, basado en el calculo de coeficientes
% propuesto en AudioEQCookBook 

function [p,w,hnump,hdenp,mp,mpdB] = peak(f0P1,dBgainP1,QP1,Fs,M)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

%parametros previos
w0P1 = (2*pi*f0P1)/Fs;
Ap1 = sqrt(10^(dBgainP1/20));
alphap1 = sin(w0P1)/(2*QP1);

% coeficientes 
b0p1 = 1 + alphap1*Ap1;
b1p1 = -2*cos(w0P1);
b2p1 = 1 - alphap1*Ap1;

a0p1 = 1 + alphap1/Ap1;
a1p1 = -2*cos(w0P1);
a2p1 = 1 - alphap1/Ap1;

hnump = [b0p1 b1p1 b2p1];
hdenp = [a0p1 a1p1 a2p1];

[p,w] = freqz (hnump,hdenp,M);
mp = abs(p);
mpdB = 20* log10(mp);

end

