% Trabajo final de laboratorio TDSÑ 2018-2019
% Integrantes del grupo:
% LUCIA LARRAONA SÁNCHEZ
% ÁLVARO HERNÁNDEZ MONTES 

% Función que define el filtro High Shelf, basado en el calculo de coeficientes
% propuesto en AudioEQCookBook 


function [HShelf,w,hnumh,hdenh,mh,mhdB] = HighShelf(f0h,dBGainHS,QHS,Fs,M)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

% parametros previos: 
w0h= (2*pi*f0h)/Fs;
Ah= sqrt(10^(dBGainHS/20));
alphah = sin(w0h)/ (2*QHS);

%coeficientes 
b0h = Ah*( (Ah+1) + (Ah-1)*cos(w0h) + 2*sqrt(Ah)*alphah );
b1h = -2*Ah*( (Ah-1) + (Ah+1)*cos(w0h));
b2h =  Ah*( (Ah+1) + (Ah-1)*cos(w0h) - 2*sqrt(Ah)*alphah );

a0h= (Ah+1) - (Ah-1)*cos(w0h) + 2*sqrt(Ah)*alphah;
a1h = 2*( (Ah-1) - (Ah+1)*cos(w0h));
a2h=(Ah+1) - (Ah-1)*cos(w0h) - 2*sqrt(Ah)*alphah;

hnumh = [b0h,b1h,b2h];
hdenh = [a0h,a1h,a2h];

[HShelf, w] = freqz( hnumh,hdenh,M);
mh=abs(HShelf);
mhdB= 20* log10(mh);


end
