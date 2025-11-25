% Signal Parameters
P = struct('coef1',3,'coef2',2,'coef3',4,'mean',0.5,'sd',0.2);
A = 10; % SNR

% Instantaneous frequency after 1 sec is 
maxFreq = P.coef1 + 2*P.coef2 + 3*P.coef3;
% Nyqust frequency guess: 2 * max. instantaneous frequency
nyqFreq = 2*maxFreq;
% Sampling frequency
sampFreq = 2*nyqFreq;
% samplFreq = 10*nyqFreq;
samplIntrvl = 1/sampFreq;
% Time samples 
timeVec = -0.2:samplIntrvl:1.2;
% Number of samples
nSamples = length(timeVec);

% Generate the signal
sigVec = otherDTS2_new(timeVec,A,P);

% Plot the signal time series
figure;
plot(timeVec,sigVec,'Marker','.','MarkerSize',24);
xlabel('Time (sec)');
title('Signal Time Series');

% Plot the periodogram 
dataLen = nSamples/sampFreq;
% DFT sample corresponding to Nyquist frequency
kNyq = floor(nSamples/2)+1;
% Positive Fourier frequencies
posFreq = (0:(kNyq-1))*(1/dataLen);
% FFT of signal
fftSig = fft(sigVec);
% Discard negative frequencies
fftSig = fftSig(1:kNyq);
figure;
plot(posFreq,abs(fftSig));
xlabel('Frequency (Hz)');
ylabel('|FFT|');
title('Periodogram');