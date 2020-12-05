% Trabajo final de laboratorio TDSÑ 2018-2019
% Integrantes del grupo:
% LUCIA LARRAONA SÁNCHEZ
% ÁLVARO HERNÁNDEZ MONTES 

%Función que representa una misma figura la grafica de la sala, grafica del
%ecualizador y la grafica del sistema completo

function graficasSISTEMA(w,mhdB, mldB,mpdB,mpdB2,mpdB3,MHdB)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

MHECUALIZADORdB=mhdB+mldB+mpdB+mpdB2+mpdB3; % conexion en cascada de los filtros (suma en decibelios)

MHsistemadB = MHdB + MHECUALIZADORdB; %Sala + ecualizador

%Bode de la sala
subplot( 3,1,1); 
plot(w,MHdB,'g-');
title('Sala','FontSize',12)
legend ('sala');
ylabel('dB');

%Bode del ecualizador
subplot ( 3,1,2);
plot( w, MHECUALIZADORdB,'r-');
title('Ecualizador','FontSize',12);
legend ('ecualizador');
ylabel('dB');

%Grafica del sistema completo
subplot(3,1,3);
plot(w,MHsistemadB,'k-');
title('Sistema(SALA+ECUALIZADOR)','FontSize',12);
legend ('SISTEMA COMPLETO)');
ylabel('dB');
axis([0 3.3 -10 10])


end

