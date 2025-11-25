clear; close; clc;

addpath ..\SIGNALS
addpath ..\NOISE
addpath ..\DETEST
addpath('\\wsl.localhost\ubuntu\home\zeno\GW_Project\SDMBIGDAT19\CODES')

% Signal Parameters
a_1 = 10;
a_2 = 3;
a_3 = 3;
SNR = 10;
nSamples = 512;
sampFreq = 512;
timeVec = (0:(nSamples - 1))/sampFreq;

% Noise PSD we are using
noisePSD = @(f) (f>=50 & f<=100).*(f-50).*(100-f)/625 + 1;
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
psdPosFreq = noisePSD(posFreq);

% Plot the traget PSD
figure;
plot(posFreq,psdPosFreq);
axis([0,posFreq(end),0,max(psdPosFreq)]);
xlabel('Frequency (Hz)');
ylabel('PSD ((data unit)^2/Hz)');

% Generate the signal with a given SNR: this is our true signal
sigVec_temp = QuadChirpDTS(timeVec,1,[a_1,a_2,a_3]);
[sigVec_norm, ~] = normsig4psd(sigVec_temp,sampFreq,psdPosFreq,1);
sigVec = SNR * sigVec_norm;

% Generate the colored noise with the above PSD
rng('default');
noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
% Estimate the noise PSD
[pxx,f]=pwelch(noiseVec,100,[],[],sampFreq);
figure;
plot(f,pxx);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Estimated PSD');

% Data realisation from signal and colored noise
dataVec = noiseVec + sigVec;

figure;
plot(timeVec,dataVec);
hold on;
plot(timeVec,sigVec);
xlabel('Time (sec)');
ylabel('Data');

% Search ranges
a1_min = 1;
a1_max = 180;
delta_a = 0.5;
A = a1_min : delta_a : a1_max;
a2_min = 1;
a2_max = 10;
a3_min = 1;
a3_max = 10;
rmin = [a1_min, a2_min, a3_min];
rmax = [a1_max, a2_max, a3_max];

% Create matrix X
nRows = length(A);
nColumns = 3;
X = zeros(nRows, nColumns); % Pre-allocation
for i = 1:nRows
    X(i,1) = (A(i) - a1_min)/(a1_max - a1_min);
    X(i,2) = (a_2 - a2_min)/(a2_max - a2_min);
    X(i,3) = (a_3 - a3_min)/(a3_max - a3_min);
end

Params = struct('dataX', timeVec,...
                  'dataY', dataVec,...
                  'dataXSq',timeVec.^2,...
                  'dataXCb',timeVec.^3,...
                  'rmin',rmin,...
                  'rmax',rmax,...
                  'npsd',psdPosFreq,...
                  'nSamp',nSamples,...
                  'sf',sampFreq);

% Calculate the fitness values
[fitVals, ~] = glrtqcsig4pso(X, Params);
% Plot fitVals vs A values
figure;
plot(A, fitVals')
xlabel('Values of a1')
ylabel('Fitness function values')

% GLRTqcPSO runs PSO on the glrtqcsig4pso fitness function. As an
% illustration of usage, we change one of the PSO parameters from its
% default value.
% Number of independent PSO runs
nRuns = 8;
outResults = GLRTqcPSO(Params,struct('maxSteps',3000),nRuns);

%%
% Plots
figure;
hold on;
plot(timeVec,dataVec,'.');
plot(timeVec,sigVec);
for lpruns = 1:nRuns
    plot(timeVec,outResults.allRunsOutput(lpruns).estSig,'Color',[51,255,153]/255,'LineWidth',2.0);
end
plot(timeVec,outResults.bestSig,'Color',[76,153,0]/255,'LineWidth',4.0);
legend('Data','Signal',...
       ['Estimated signal: ',num2str(nRuns),' runs'],...
       'Estimated signal: Best run');
disp(['Estimated parameters: a1=',num2str(outResults.bestQcCoefs(1)),...
                             '; a2=',num2str(outResults.bestQcCoefs(2)),...
                             '; a3=',num2str(outResults.bestQcCoefs(3))]);