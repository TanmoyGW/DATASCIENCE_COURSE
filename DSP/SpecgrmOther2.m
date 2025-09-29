%% Spectrogram demo
addpath ../SIGNALS
sampFreq = 1024;
nSamples = 2048;
timeVec = (0:(nSamples-1))/sampFreq;

%% OtherDTS_2 signal
% Signal parameters
A = 10;
sigma = 0.2;
mu = 0.5;
a1 = 3;
a2 = 2;
a3 = 4;

%%
% Generate signal
sigVec = otherDTS_2(timeVec,A,sigma,mu,[a1,a2,a3]);

%% 
% Make spectrogram with different time-frequency resolution

figure;
spectrogram(sigVec, 128,127,[],sampFreq);
figure;
spectrogram(sigVec, 256,250,[],sampFreq);

%%
% Make plots independently of the spectrogram function
[S,F,T]=spectrogram(sigVec, 256,250,[],sampFreq);
figure;
imagesc(T,F,abs(S));axis xy;
xlabel('Time (sec)');
ylabel('Frequency (Hz)');