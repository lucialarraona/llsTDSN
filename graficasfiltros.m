% Trabajo final de laboratorio TDSÑ 2018-2019
% Integrantes del grupo:
% LUCIA LARRAONA SÁNCHEZ
% ÁLVARO HERNÁNDEZ MONTES 

% Función que representa graficamente los filtros utilizados con sus
% correspondientes parámetros ajustados

function graficasfiltros(w,mhdB, mldB,mpdB,mpdB2,mpdB3)
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here

subplot (5,1,2);
plot(w,mldB);
legend('lowshelf');

subplot (5,1,1);
plot(w,mhdB);
legend('highshelf');

subplot ( 5,1,3);
plot(w,mpdB);
legend ('peak1');

subplot ( 5,1,4);
plot(w,mpdB2) ;
legend ('peak2');

subplot (5,1,5);
plot(w,mpdB3);
legend ('peak3');

end

