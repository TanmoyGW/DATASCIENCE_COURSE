%% Whitening a given data that contains CGN

clear; close; clc;
%Sampling frequency for noise realization
sampFreq = 1024; %Hz
sampInt = 1/sampFreq;

% Load the given CGN realization
file = load("testData.txt");
t = file(:,1);
dataVal = file(:,2);
sigfree = dataVal(t < 5); % The noise-only/signal-free part of the data

% Estimate the noise PSD
[pxx,f]=pwelch(sigfree,256,[],[],sampFreq);
figure;
plot(f,pxx);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Target PSD');

% Define the filter order and whiten the data
fltrOrdr = 500;
targetPSD = pxx;
freqVec = f;
psdVec = targetPSD;
[inData,outData] = taskWhiten([freqVec(:),psdVec(:)],fltrOrdr,sampFreq,dataVal);

% Plot the white noise realization
figure;
plot(inData);
title('Original Data Time Series');
figure;
plot(outData);
title('Whitened Data Time Series');

% Plot spectrogram before whitening
wLen = 0.2;
ovlp = 0.1;
wLenSamp = round(wLen/sampInt);
ovlpSamp = round(ovlp/sampInt);
[S,F,T]=spectrogram(inData,wLenSamp,ovlpSamp,[],sampFreq);
figure;
imagesc(T,F,abs(S));axis xy;
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
title('Spectrogram before whitening');

% Plot spectrogram after whitening
[S,F,T]=spectrogram(outData,wLenSamp,ovlpSamp,[],sampFreq);
figure;
imagesc(T,F,abs(S));axis xy;
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
title('Spectrogram after whitening');