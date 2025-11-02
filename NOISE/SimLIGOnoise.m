%% Generate a simulated LIGO noise relisation

clear; close; clc;
%Number of samples to generate
%SDM: Increased number of samples in order to get a better estimated PSD
nSamples = 2000000;
%Load target psd
data = load("iLIGOSensitivity.txt",'-ascii');
%SDM Note that the sensitivity curve is the square root of the PSD already.
%It is called the Amplitude Spectral Density (ASD). Hence, I have renamed
%the variable.
%targetPSD = data(:,2);
targetASD = data(:,2);

%Plot PSD
freqVec = data(:,1);
%FIXME Why create a new variable psdVec here? It is only used for the plot.
%psdVec = targetPSD;
%loglog(freqVec,psdVec); % Plotting on the log scale
loglog(freqVec,targetASD);
xlabel('Frequency (Hz)');
ylabel('$\sqrt{S_n(f)}$', 'Interpreter', 'latex');
title('Target PSD');
ylim_vals = ylim;

%Time samples
maxFreq = max(freqVec);
sampFreq = 2*maxFreq; % Respecting Nyquist theorem
timeVec = (0:(nSamples-1))/sampFreq;

% Modify the PSD
%SDM Again, this is the ASD, not PSD. So, variables were renamed.
asdVec_1 = targetASD;
asdVec_1(freqVec <= 50) = targetASD(find(freqVec >= 50, 1, "first"));
asdVec_1(freqVec >= 700) = targetASD(find(freqVec <= 700, 1, "last"));
disp(min(freqVec));  % turns out to be non-zero
% Add zero as the first frequency
freqVec = [0; freqVec];
asdVec_1  = [asdVec_1(1); asdVec_1];
disp(min(freqVec));

% Plot the modified ASD
figure;
loglog(freqVec, asdVec_1); % Plotting on the log scale
xlabel('Frequency (Hz)');
ylabel('$\sqrt{S_n(f)}$', 'Interpreter', 'latex');
%title('Modified PSD');
title('Modified ASD');
%FIXME The ylim was squeezing the relevant part of the plot to the bottom
%ylim(ylim_vals);

% Design the FIR filter
fltrOrdr = 500;
%FIXME bad function name; almost conflicts with script name. 
%[inNoise,outNoise] = simLIGOnoise(nSamples,[freqVec(:),psdVec_1(:)],fltrOrdr,sampFreq);
[inNoise,outNoise] = SimLIGOnoise_core(nSamples,[freqVec(:),asdVec_1(:)],fltrOrdr,sampFreq);

% Estimate the PSD of the simulated LIGO noise
%SDM Using a larger number of samples allows increasing segment length in
%pwelch
[pxx,f]=pwelch(outNoise,4096,[],[],sampFreq);
figure;
hold on;
loglog(f,pxx); % Plotting on the log scale
%SDM compare with the target PSD
loglog(freqVec,asdVec_1.^2);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Estimated PSD of simulated LIGO noise');

% Plot the generated noise time-series
figure;
plot(timeVec,outNoise);
title('Simulated LIGO noise time-series');

%% Define local functions
function [inNoise,outNoise] = SimLIGOnoise_core(nSamples,asdVals,fltrOrdr,sampFreq)
%FIXME LIGO sensitivity curve is one-sided ASD, not 2-side PSD
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
freqVec = asdVals(:,1);
sqrtPSD = asdVals(:,2); % The seconf column is already the 
% square-rooted values of the PSD.
%FIXME However, it is the square root of the one-sided PSD. We need the
%square root of the two-sided PSD
%b = fir2(fltrOrdr,freqVec/(sampFreq/2),sqrtPSD);
b = fir2(fltrOrdr,freqVec/(sampFreq/2),sqrtPSD/sqrt(2));

%%
% Generate a WGN realization and pass it through the designed filter
%FIXME Better to pad with extra samples to avoid filter startup transients
inNoise = randn(1,nSamples+fltrOrdr);
outNoise = sqrt(sampFreq)*fftfilt(b,inNoise);
%SDM drop the padded samples containing a possible FIR filter transient
outNoise = outNoise((fltrOrdr+1):end);
end