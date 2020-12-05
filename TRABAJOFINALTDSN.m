% Trabajo final de laboratorio TDSÑ 2018-2019
% Integrantes del grupo:
% LUCIA LARRAONA SÁNCHEZ
% ÁLVARO HERNÁNDEZ MONTES 


%Señal distorsionadora 
[Z, P, K] = room ( 'l.larraona@alumnos.upm.es' , 'alvaro.h.montes@alumnos.upm.es');
[B,A] = zp2tf (Z,P,K);

% Numero de muestras 
M = 2000; 
[H,w] = freqz (B,A,M); %devuelve modulo y vector de frecuencias del filtro digital
MH = abs(H);
MHdB = 20 * log10 (MH); %calculamos valor en dB para posterior representacion

% Frecuencia de muestreo = Fs  (debe ser 48kHZ) 
Fs = 48000;

%calculo y representacion del diagrama pz de la sala y de su
%correspondiente filtro compensador perfecto (fase minima + paso todo)

%polos y ceros del filtro paso todo: 

Zfpasotodo= Z(5);     %Unico cero que sale del circulo unidad 
Pfpasotodo= (1/Z(5)); %el polo para formar el paso todo será el valor recíproco del cero que queda fuera

%polos y ceros del filtro fase minima
Zfasemin= Z(1:4); %todos los ceros que quedan dentro del circulo unidad
Pr= 1/Z(5);       %polo recíproco al cero que queda fuera del circulo unidad 
Pfasemin=[P;Pr];  %todos los polos que quedan dentro del circulo unidad 
                  %mas el polo añadido al compensar.
                  
%gráficas del desglose de la funcion de la sala en fase minima + paso todo
figure(1)

subplot(2,2,[1,2]);
H = zplane (Z,P);
title ('H(z)');

subplot(2,2,3);
Zmin = [Z(1:4);(1/Z(5))]; %hay que añadir el cero reflejado que queda dentro de la ccfa unidad y que es del
                           % mismo valor que el polo reflejado.
Hmin = zplane(Zmin,P);
title ('Filtro Fase Mínima');

subplot(2,2,4);
Hpasotodo = zplane(Z(5), Pfpasotodo); 
title ('Filtro Paso Todo');

%SISTEMA COMPENSADOR IDEAL (TEÓRICO)  
figure(2)

subplot(2,2,1);
plot(w,MHdB);
title('Módulo Sala(distorsión)');

[Hideal,w] = freqz(Zfasemin,Pfasemin,M); %calculo modulo filtro compensador ideal para representarlo
MHideal = abs(Hideal);
MHidealdB = 20*log(MHideal);

subplot (2,2,2); 
plot(w,MHidealdB);
title ('Módulo Compensador Ideal');

subplot(2,2,3);
zplane(Z,P);
title('Diagrama de polos y ceros SALA');

subplot(2,2,4);
zplane(Pfasemin,Zfasemin); % invertimos los polos y los ceros para conseguir sistema compensador ideal (1/Hfaseminima)
title('Diagrama polos y ceros del COMPENSADOR IDEAL')


% ---------------------------- ECUALIZADOR -------------------

% Definimos distintos parámetros para ajustar cada filtro de la cadena 
% f0 - frecuencia de muestreo o central en filtros peak 
% Q/BW - ancho de banda 


% filtro LOWSHELF
f0l = 6300;     %frecuencia de corte
dBGainLS= 10;   %ganancia
QLS=0.6;        %ancho de banda
[LShelf,w,hnuml, hdenl, ml, mldB] = LowShelf(f0l, dBGainLS, QLS, Fs, M);


% filtro HIGHSHELF 
f0h= 20000;
dBGainHS = -4;
QHS = 0.5;
[HShelf,w,hnumh,hdenh,mh,mhdB] = HighShelf(f0h,dBGainHS,QHS,Fs,M);


% filtro tipo PEAK (1) 
f0P1 =8000 ;
dBgainP1 = 4.5;
QP1 = 0.5; 
[p,w,hnump,hdenp,mp,mpdB] = peak(f0P1,dBgainP1,QP1,Fs,M);


% filtro tipo PEAK (2) 
f0P2 = 10000;
dBgainP2 = -3;
QP2 = 0.5;
[p2,w,hnump2,hdenp2,mp2,mpdB2] = peak(f0P2,dBgainP2,QP2,Fs,M);

% filtro tipo PEAK (3)
f0P3 = 16000;
dBgainP3 = -7.5;
QP3= 0.3;
[p3,w,hnump3,hdenp3,mp3,mpdB3] = peak(f0P3,dBgainP3,QP3,Fs,M);


%-------------------- SEÑAL DE PRUEBA -----------------------

%para escuchar la señal de prueba 
%(lo dejamos comentado puesto que escucharemos más adelante la señal
%filtrada)

[x,fs] = audioread('test_44.wav'); 
%p1 = audioplayer(x,fs);
%p1.play


% LA SEÑAL DE AUDIO DE PRUEBA ESTÁ A 44kHZ por tanto
fsenal= 44; %parámetro necesario para remuestrear la señal

% Remuestreo de la señal 
[n,d]=rat (fsenal/48); % la utilizamos para calcular los parametros p y q de la funcion resample
p=d;
q=n;
%el parametro n nos dicen que debe ser 10 
%hemos escogido beta(10) tal que el filtro tiene una atenuacion entre [96,100]
%dB 
y = resample(x,p,q,10,10); %señal de prueba convertida a la frec de muestreo del ecualizador 



%-------------------------- GRAFICAS - DIBUJOS ----------------- 

%graficas de los filtros
figure(3) 
graficasfiltros(w,mhdB, mldB,mpdB,mpdB2,mpdB3)

% graficas de la sala, ecualizador y sistema completo (sala+ecualizador)
figure(4)
graficasSISTEMA(w,mhdB, mldB,mpdB,mpdB2,mpdB3,MHdB)


%-------CONEXION EN CASCADA de los filtros del ecualizador------


Y = filter(B,A,y);                  % a traves de la sala (distorsion)

Y1 = filter(hnumh,hdenh,Y);         %a traves del filtro paso alto

Y2 = filter(hnuml,hdenl,Y1);        %a traves del paso bajo

Y3 = filter(hnump,hdenp,Y2);        %a traves del 1 filtro peak

Y4 = filter(hnump2,hdenp2,Y3);      %a traves del 2 filtro peak

Y5 = filter(hnump3,hdenp3,Y4);      %a traves del 3 filtro peak


% ESPECTROGRAMAS de la señal de prueba, en los tres puntos críticos
figure (5) 

subplot(3,1,1)
specgram(y(:,1),512,Fs);            %espectrograma de la señal remuestreada (entrada)
title ('Señal Remuestreada');

subplot(3,1,2)                      %espectrograma de la señal a la salida de la sala
specgram(Y(:,1),512,Fs);
title ('Señal Distorsionada');

subplot(3,1,3)                      %espectrograma de la señal filtrada (salida)
specgram(Y5(:,1),512,Fs);
title('Señal Filtrada');

% finalmente, escuchamos la señal filtrada 

p2 = audioplayer(Y5,Fs);
p2.play

%(por curiosidad, también escuchamos la señal distorsionada, lo dejamos comentado)
%p3= audioplayer(Y,Fs);
%p3.play
