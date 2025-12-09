%% Detection and Estimation of Mystery Signal
clear; close; clc;
addpath ..\SIGNALS
addpath ..\NOISE
addpath ..\DETEST
addpath('\\wsl.localhost\ubuntu\home\zeno\GW_Project\SDMBIGDAT19\CODES')
% =========================================================================
%% Load the training data containing only noise
train_dat = load("TrainingData.mat");
% disp(train_dat)
% We see that train_dat is a structure containing two fields "sampFreq" and
% "trainData", so we now store these field values in variables.
sampFreq = train_dat.sampFreq;
noiseVec = train_dat.trainData;

%% Load the analysis data
sim_dat = load("analysisData.mat");
% disp(noise_dat)
% We see that sim_dat is again a structure containing two fields "dataVec" and
% "sampFreq", so we now also store these field values in variables. Since
% the value of sim_dat.sampFreq is the same as above, we do not create a
% variable for that and use the above sampFreq for noise.
dataVec = sim_dat.dataVec;
% Number of total data samples and the time vector for the data:
nSamples = length(dataVec);
timeVec = (0:(nSamples - 1))/sampFreq;
% Plotting the data realisation
figure;
plot(timeVec,dataVec)
xlabel("Time (s)")
title("Time series of the Analysis Data")
% Plotting the noise realisation
nSamp_noise = length(noiseVec);
tV_noise = (0:(nSamp_noise - 1))/sampFreq;
figure;
plot(tV_noise,noiseVec)
xlabel("Time (s)")
title("Time series of the noise realisation")

%% Estimate the noise PSD
[pxx, f] = pwelch(noiseVec, 500, [], [], sampFreq);
% Plot the estimated PSD
figure;
plot(f,pxx)
xlabel("Frequency (Hz)")
ylabel("PSD ((data unit)^2/Hz)")
title("Estimated noise PSD")
% Now we want to express this estimated noise PSD at positive DFT
% frequencies.
noisePSD = @(x) interp1(f, pxx, x, 'linear', 'extrap');
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
psdPosFreq = noisePSD(posFreq);
% Plot the interpolated noise PSD at positive DFT frequencies
figure;
plot(posFreq,psdPosFreq)
xlabel('Frequency (Hz)');
ylabel('PSD ((data unit)^2/Hz)');
title("Estimated noise PSD: at positive frequencies")
% We see that the interpolated PSD plot is similar to the pwelch PSD plot,
% and this is expected because pwelch plots the PSD values at positive DFT
% frequencies, i.e. from 0 Hz to the Nyquist frequency.

%% Using PSO to calculate GLRT and MLE
% Define the search ranges
a1_min = 40;
a1_max = 100;
a2_min = 1;
a2_max = 50;
a3_min = 1;
a3_max = 15;
rmin = [a1_min, a2_min, a3_min];
rmax = [a1_max, a2_max, a3_max];
% PSO parameters
Params = struct('dataX', timeVec,...
                  'dataY', dataVec,...
                  'dataXSq',timeVec.^2,...
                  'dataXCb',timeVec.^3,...
                  'rmin',rmin,...
                  'rmax',rmax,...
                  'npsd',psdPosFreq,...
                  'nSamp',nSamples,...
                  'sf',sampFreq);

% Now we run PSO with 2000 iterations as instructed and take best of 8 runs
nRuns = 8;
outResults = GLRTqcPSO(Params,struct('maxSteps',2000),nRuns);

%%
% Plots
figure;
hold on;
plot(timeVec,dataVec,'.');
for lpruns = 1:nRuns
    plot(timeVec,outResults.allRunsOutput(lpruns).estSig,'Color',[51,255,153]/255,'LineWidth',2.0);
end
plot(timeVec,outResults.bestSig,'Color',[76,153,0]/255,'LineWidth',4.0);
legend('Data',...
       ['Estimated signal: ',num2str(nRuns),' runs'],...
       'Estimated signal: Best run');
% Displaying the estimated parameters and best fitness
a1_est = outResults.bestQcCoefs(1);
a2_est = outResults.bestQcCoefs(2);
a3_est = outResults.bestQcCoefs(3);
best_fit = outResults.bestFitness;
disp(['Estimated parameters: a1 = ',num2str(a1_est),...
                             '; a2 = ',num2str(a2_est),...
                             '; a3 = ',num2str(a3_est)]);
disp(['Best fitness = ', num2str(best_fit)])

%% Estimation of GLRT and test significance
GLRT_est = -best_fit;
disp(['Estimated GLRT: ', num2str(GLRT_est)])
% To estimate the significance, we draw a large number of trial values of
% the GLRT under the null hypothesis
sigVec = crcbgenqcsig(timeVec,1,[a1_est, a2_est, a3_est]);
[tempVec,~] = normsig4psd(sigVec,sampFreq,psdPosFreq,1); % Template vectors
nRl = 30000; % Number of noise realisations
glrtH0 = zeros(1,nRl); % Pre-allocation
rng(0); % Set the seed
for lpr = 1:nRl
    % Generate noise realizations
    noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
    % Compute GLRT values for the data
    llr = innerprodpsd(noiseVec,tempVec,sampFreq,psdPosFreq);
    glrtH0(lpr) = llr^2;
end
% GLRT significance is the probability that a noise-only data realisation
% gives a GLRT value that is higher than the estimated GLRT of the analysis
% data. So to calculate this probability, we count the total number of
% times the GLRT values of the above ~ 30000 noise realisations is greater
% than the estimated GLRT, and then divide it with the total number of
% realisations to get the probability.
count = sum(glrtH0 >= GLRT_est);
GLRT_sig = count / nRl;
% Display the estimated significance of the GLRT
disp(['GLRT significance: ', num2str(GLRT_sig)]);