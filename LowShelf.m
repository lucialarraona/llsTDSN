% Trabajo final de laboratorio TDSÑ 2018-2019
% Integrantes del grupo:
% LUCIA LARRAONA SÁNCHEZ
% ÁLVARO HERNÁNDEZ MONTES 

% Función que define el filtro LowShelf, basado en el calculo de coeficientes
% propuesto en AudioEQCookBook 


function [LShelf,w,hnuml, hdenl, ml, mldB] = LowShelf(f0l, dBGainLS, QLS, Fs, M)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

% definimos parámetros previos 
w0l= (2*pi*f0l)/Fs; 
Al = sqrt (10^(dBGainLS/20));
alphal = sin(w0l)/(2*QLS);

% coeficientes 

b01 = Al*((Al+1) - (Al-1) * cos(w0l) + 2*sqrt(Al)*alphal);
bl1= 2 *Al *((Al-1) - (Al+1) * cos(w0l));
b2l = Al * ( (Al+1)-(Al-1)*cos(w0l) - 2*sqrt(Al)* alphal); 

a01 = (Al +1) + (Al-1)* cos(w0l) + 2*sqrt(Al)*alphal;
a1l = -2*((Al-1) + (Al+1) * cos(w0l));
a21 = (Al+1) + (Al-1)*cos(w0l) - 2*sqrt(Al)*alphal;

hnuml = [b01,bl1,b2l];
hdenl= [a01,a1l,a21];

[LShelf,w] = freqz(hnuml,hdenl,M);

ml = abs(LShelf);
mldB = 20*log10(ml);
end

