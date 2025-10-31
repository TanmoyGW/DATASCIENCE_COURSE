%% Demo for colored Gaussian noise generation
clear; close; clc;
%Sampling frequency for noise realization
sampFreq = 1024; %Hz
%Number of samples to generate
nSamples = 16384;
%nSamples = 32768;
%nSamples = 65536;
%Time samples
timeVec = (0:(nSamples-1))/sampFreq;

%Target two-sided PSD given by the inline function handle
targetPSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000;

%Plot PSD
freqVec = 0:0.1:512;
psdVec = targetPSD(freqVec);
plot(freqVec,psdVec);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Target PSD');

%%
% Design FIR filter with T(f)= square root of target PSD
% sqrtPSD = sqrt(psdVec);
 fltrOrdr = 500;
% b = fir2(fltrOrdr,freqVec/(sampFreq/2),sqrt(psdVec));
% 
% %%
% % Generate a WGN realization and pass it through the designed filter
% % (Comment out the line below if new realizations of WGN are needed in each run of this script)
% rng('default'); 
% inNoise = randn(1,nSamples);
% outNoise = fftfilt(b,inNoise);

%% Generate noise realization
[inNoise,outNoise] = statgaussnoisegen(nSamples,[freqVec(:),psdVec(:)],fltrOrdr,sampFreq);

%%
% Estimate the PSD
% figure;
% pwelch(outNoise, 512,[],[],sampFreq);
% hold on;
% pwelch(inNoise, 512, [], [], sampFreq);
%Pwelch plots in dB (= 10*log10(x)); plot on a linear scale
[pxx,f]=pwelch(outNoise,256,[],[],sampFreq);
figure;
plot(f,pxx);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Estimated PSD'); % The FFT bin spacing in Welch's method
% is inversely proportional to nSamples. So if nSamples is increased, the 
% frequency spacing decreases and hence the PSD curve smoothens because of
% better sampling.

% Plot the colored noise realization
figure;
plot(inNoise);
title('White Gaussian Noise');
figure;
plot(timeVec,outNoise); % We can zoom in and see that the colored gaussian
% noise realisation has kind of synchronised wiggles which is a sharp 
% contrast with the WGN above, which has completely random fluctuations.
title('Colored Gaussian Noise');

% Plot histograms
figure;
subplot(1,2,1);
histogram(inNoise,30);
xlabel('Value');
ylabel('Frequency');
title('Histogram of WGN');
grid on;
subplot(1,2,2);
histogram(outNoise,30);
xlabel('Value');
ylabel('Frequency');
title('Histogram of CGN');
grid on;
% As we can see, the histogram of CGN is still a normal pdf.