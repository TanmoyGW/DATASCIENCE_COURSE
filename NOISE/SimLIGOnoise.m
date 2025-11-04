%% Generate a simulated LIGO noise relisation

clear; close; clc;
%Number of samples to generate
nSamples = 2000000;
%Load target psd
data = load("iLIGOSensitivity.txt",'-ascii');
targetASD = data(:,2); % ASD: Amplitude Spectral Density

%Plot PSD
freqVec = data(:,1);
loglog(freqVec,targetASD); % Plotting on the log scale
xlabel('Frequency (Hz)');
ylabel('$\sqrt{S_n(f)}$', 'Interpreter', 'latex');
title('Target ASD');
ylim_vals = ylim;

%Time samples
maxFreq = max(freqVec);
sampFreq = 2*maxFreq; % Respecting Nyquist theorem
timeVec = (0:(nSamples-1))/sampFreq;

% Modify the PSD
asdVec_1 = targetASD;
asdVec_1(freqVec <= 50) = targetASD(find(freqVec >= 50, 1, "first"));
asdVec_1(freqVec >= 700) = targetASD(find(freqVec <= 700, 1, "last"));
disp(min(freqVec));  % turns out to be non-zero
% Add zero as the first frequency
freqVec = [0; freqVec];
asdVec_1  = [asdVec_1(1); asdVec_1];
disp(min(freqVec)); % which is 0 now

% Plot the modified ASD
figure;
loglog(freqVec, asdVec_1); % Plotting on the log scale
xlabel('Frequency (Hz)');
ylabel('$\sqrt{S_n(f)}$', 'Interpreter', 'latex');
title('Modified Target ASD');

% Design the FIR filter
fltrOrdr = 500;
[inNoise,outNoise] = SimLIGOnoise_core(nSamples,[freqVec(:),asdVec_1(:)],fltrOrdr,sampFreq);

% Estimate the PSD of the simulated LIGO noise
%SDM Using a larger number of samples allows increasing segment length in
%pwelch
[pxx,f]=pwelch(outNoise,4096,[],[],sampFreq);
figure;
hold on;
loglog(f,pxx); % Plotting on the log scale
loglog(freqVec,asdVec_1.^2); % Compare with modified target PSD
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Estimated PSD of simulated LIGO noise');

% Plot the generated noise time-series
figure;
plot(timeVec,outNoise);
title('Simulated LIGO noise time-series');

%% Define local functions
function [inNoise,outNoise] = SimLIGOnoise_core(nSamples,asdVals,fltrOrdr,sampFreq)
% We note that LIGO sensitivity curve is one-sided ASD, not 2-sided.
% We generate a realization of stationary Gaussian noise with given 2-sided ASD
% Y = simLIGOnoise(N,PSD,O,Fs)
% Generates a realization Y of stationary gaussian noise with a target
% 2-sided power spectral density given by PSD. Fs is the sampling frequency
% of Y. PSD is an M-by-2 matrix containing frequencies and the corresponding
% PSD values in the first and second columns respectively. The frequencies
% must start from 0 and end at Fs/2. The order of the FIR filter to be used
% is given by O.

% Tanmoy Chakraborty, Oct 25, 2025

% Design FIR filter with T(f)= square root of target PSD
freqVec = asdVals(:,1);
sqrtPSD = asdVals(:,2); % The second column is already the 
% square-rooted values of the one sided PSD. But we need the square root 
% of the two-sided PSD.
b = fir2(fltrOrdr,freqVec/(sampFreq/2),sqrtPSD/sqrt(2));

%%
% Generate a WGN realization and pass it through the designed filter
% Its better to pad with extra samples to avoid filter startup transients
inNoise = randn(1,nSamples+fltrOrdr);
outNoise = sqrt(sampFreq)*fftfilt(b,inNoise);
% We drop the padded samples containing a possible FIR filter transient
outNoise = outNoise((fltrOrdr+1):end);
end