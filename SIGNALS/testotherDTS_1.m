%% Generate the signal:

% Signal parameters
a1=7;
A = 15;
tau = 0.35;

% Instantaneous frequency after 1 sec is 
maxFreq = a1;
%Nyqust frequency guess: 2 * max. instantaneous frequency
nyqFreq = 2*maxFreq;
%Sampling frequency
samplFreq = 5*nyqFreq;
%samplFreq = 10*nyqFreq;
samplIntrvl = 1/samplFreq;

% Time samples 
timeVec = -1.0:samplIntrvl:1.0;

% Number of samples
nSamples = length(timeVec);

% Generate the signal
sigVec = otherDTS_1(timeVec,A,tau,a1);

%Plot the signal 
figure;
plot(timeVec,sigVec,'Marker','.','MarkerSize',24);
xlabel('Time (sec)');
title('Sampled signal');

%Plot the periodogram
%--------------
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

%Plot periodogram
figure;
plot(posFreq,abs(fftSig));
xlabel('Frequency (Hz)');
ylabel('|FFT|');
title('Periodogram');

% Plot spectrogram
[S,F,T]=spectrogram(sigVec,25,24,[],samplFreq);
figure;
imagesc(T,F,abs(S));axis xy;
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
title('Spectrogram');