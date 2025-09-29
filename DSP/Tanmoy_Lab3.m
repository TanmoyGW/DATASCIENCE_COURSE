addpath ../SIGNALS;
sampFreq = 1024;
nSamples = 2048;

timeVec = (0:(nSamples-1))/sampFreq;

%% Sum of three sinusoids
% Signal Parameters
a1 = 10;
a2 = 5;
a3 = 2.5;
f1_0 = 100;
f2_0 = 200;
f3_0 = 300;
phi1_0 = 0;
phi2_0 = pi/6;
phi3_0 = pi/4;

% Maximum frequency
maxFreq = max([f1_0, f2_0, f3_0]);
disp(['The maximum frequency of the signal is ', num2str(maxFreq)]);

% Generate the signal
sigVec = SumThreeSin(timeVec,a1,a2,a3,f1_0,f2_0,f3_0,phi1_0,phi2_0,phi3_0);

%% Design the band pass filters
FiltOrder = 30;
% Suppress f2_0 and f3_0
b1 = fir1(FiltOrder,[99,101]/(sampFreq/2),'bandpass');
% Suppress f1_0 and f3_0
b2 = fir1(FiltOrder,[199,201]/(sampFreq/2),'bandpass');
% Suppress f1_0 and f2_0
b3 = fir1(FiltOrder,[299,301]/(sampFreq/2),'bandpass');

% Apply the filters
filtSig1 = fftfilt(b1,sigVec);
filtSig2 = fftfilt(b2,sigVec);
filtSig3 = fftfilt(b3,sigVec);

%% Plots
figure;
subplot(2,1,1)
hold on;
plot(timeVec,sigVec);
plot(timeVec,filtSig1);
xlabel('Time (s)');

subplot(2,1,2)
hold on;
%Length of data 
dataLen = timeVec(end)-timeVec(1);
%DFT sample corresponding to Nyquist frequency
kNyq = floor(nSamples/2)+1;
% Positive Fourier frequencies
posFreq = (0:(kNyq-1))*(1/dataLen);
% FFT of signal
fftSig = fft(sigVec);
% Discard negative frequencies
fftSig = fftSig(1:kNyq);

%Plot periodogram of input signal
plot(posFreq,abs(fftSig));
xlabel('Frequency (Hz)');
ylabel('|FFT|');
title('Periodogram');

% Plot periodogram of filtSig1
fftfiltSig1 = fft(filtSig1);
fftfiltSig1 = fftfiltSig1(1:kNyq);
plot(posFreq,abs(fftfiltSig1));
title('Periodogram');
legend('Original','Filtered');

figure;
subplot(2,1,1)
hold on;
plot(timeVec,sigVec);
plot(timeVec,filtSig2);
xlabel('Time (s)');

subplot(2,1,2)
hold on;

%Plot periodogram of input signal
plot(posFreq,abs(fftSig));
xlabel('Frequency (Hz)');
ylabel('|FFT|');
title('Periodogram');

% Plot periodogram of filtSig2
fftfiltSig2 = fft(filtSig2);
fftfiltSig2 = fftfiltSig2(1:kNyq);
plot(posFreq,abs(fftfiltSig2));
title('Periodogram');
legend('Original','Filtered');

figure;
subplot(2,1,1)
hold on;
plot(timeVec,sigVec);
plot(timeVec,filtSig3);
xlabel('Time (s)');

subplot(2,1,2)
hold on;

%Plot periodogram of input signal
plot(posFreq,abs(fftSig));
xlabel('Frequency (Hz)');
ylabel('|FFT|');
title('Periodogram');

% Plot periodogram of filtSig3
fftfiltSig3 = fft(filtSig3);
fftfiltSig3 = fftfiltSig3(1:kNyq);
plot(posFreq,abs(fftfiltSig3));
title('Periodogram');
legend('Original','Filtered');