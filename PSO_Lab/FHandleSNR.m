%% Demonstration of the use of function handles
% First we add the path to the SIGNALS folder to access the otherDTS2_new
% signal file
addpath ..\SIGNALS
% Pass the structure field values
P = struct('coef1',3,'coef2',2,'coef3',4,'mean',0.5,'sd',0.2);

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

% Create a function handle for otherDTS2_new
F = @(x) otherDTS2_new(timeVec,x,P);

% Plot the time series for SNR values 10, 12 and 15
figure;
hold on;
plot(timeVec, F(10));
plot(timeVec, F(12));
plot(timeVec, F(15));
xlabel('Time (s)')
title('Time series for SNR = 10, 12, 15')
legend