%% Generate a simulated LIGO noise relisation

clear; close; clc;
%Number of samples to generate
nSamples = 20000;
%Load target psd
data = load("iLIGOSensitivity.txt",'-ascii');
targetPSD = data(:,2);

%Plot PSD
freqVec = data(:,1);
psdVec = targetPSD;
loglog(freqVec,psdVec); % Plotting on the log scale
xlabel('Frequency (Hz)');
ylabel('$\sqrt{S_n(f)}$', 'Interpreter', 'latex');
title('Target PSD');
ylim_vals = ylim;

%Time samples
maxFreq = max(freqVec);
sampFreq = 2*maxFreq; % Respecting Nyquist theorem
timeVec = (0:(nSamples-1))/sampFreq;

% Modify the PSD
psdVec_1 = targetPSD;
psdVec_1(freqVec <= 50) = targetPSD(find(freqVec >= 50, 1, "first"));
psdVec_1(freqVec >= 700) = targetPSD(find(freqVec <= 700, 1, "last"));
disp(min(freqVec));  % turns out to be non-zero
% Add zero as the first frequency
freqVec = [0; freqVec];
psdVec_1  = [psdVec_1(1); psdVec_1];
disp(min(freqVec));

% Plot the modified PSD
figure;
loglog(freqVec, psdVec_1); % Plotting on the log scale
xlabel('Frequency (Hz)');
ylabel('$\sqrt{S_n(f)}$', 'Interpreter', 'latex');
title('Modified PSD');
ylim(ylim_vals);

% Design the FIR filter
fltrOrdr = 500;
[inNoise,outNoise] = simLIGOnoise(nSamples,[freqVec(:),psdVec_1(:)],fltrOrdr,sampFreq);

% Estimate the PSD of the simulated LIGO noise
[pxx,f]=pwelch(outNoise,256,[],[],sampFreq);
figure;
loglog(f,pxx); % Plotting on the log scale
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Estimated PSD of simulated LIGO noise');

% Plot the generated noise time-series
figure;
plot(timeVec,outNoise);
title('Simulated LIGO noise time-series');

%% Define local functions
function [inNoise,outNoise] = simLIGOnoise(nSamples,psdVals,fltrOrdr,sampFreq)
% Generate a realization of stationary Gaussian noise with given 2-sided PSD
% Y = simLIGOnoise(N,PSD,O,Fs)
% Generates a realization Y of stationary gaussian noise with a target
% 2-sided power spectral density given by PSD. Fs is the sampling frequency
% of Y. PSD is an M-by-2 matrix containing frequencies and the corresponding
% PSD values in the first and second columns respectively. The frequencies
% must start from 0 and end at Fs/2. The order of the FIR filter to be used
% is given by O.

% Tanmoy Chakraborty, Oct 25, 2025

% Design FIR filter with T(f)= square root of target PSD
freqVec = psdVals(:,1);
sqrtPSD = psdVals(:,2); % The seconf column is already the 
% square-rooted values of the PSD.
b = fir2(fltrOrdr,freqVec/(sampFreq/2),sqrtPSD);

%%
% Generate a WGN realization and pass it through the designed filter
inNoise = randn(1,nSamples);
outNoise = sqrt(sampFreq)*fftfilt(b,inNoise);
end