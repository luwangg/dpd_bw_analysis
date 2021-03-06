% Modeling Doherty 120W
clc
clear all
close all
addpath('Utils');

in = importdata('Data/Doherty_NXP_BLF8888B_120W_B1.txt');

txSignal=(in(1:end,1)+1i.*in(1:end,2));
txSignal=txSignal/max(abs(txSignal));
   
signal_feedback=(in(1:end,3)+1i.*in(1:end,4));
signal_feedback=signal_feedback/max(abs(signal_feedback));
clear in

%---------------------------------------------------------------------------
%Modeling PA
K=9;
Q=1;
coef=calc_DPD(txSignal,signal_feedback,K,Q);
txSignal_PA=DPD_memory_polynomials(txSignal,K,Q,coef);
%---------------------------------------------------------------------------
e=nmse(txSignal_PA, signal_feedback);
disp(['Error= ', num2str(e),' dB']);

plot(abs(txSignal), abs(txSignal_PA),'.', abs(txSignal), abs( signal_feedback),'.')

psd1=10*log10(abs(fftshift(fft(txSignal))));
f=rescale_to(1:length(psd1), [-1,1]);
figure
plot(f,psd1);
hold on
plot(f,10*log10(abs(fftshift(fft(signal_feedback)))));
plot(f,10*log10(abs(fftshift(fft(txSignal_PA)))));
