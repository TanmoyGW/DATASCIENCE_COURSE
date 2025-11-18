%% Using fHandle and struct to generate time series for A = {10, 12, 15}
% Signal Parameters
% P = struct('coef1',a_1,'coef2',a_2,'coef3',a_3,'mean',mu,'sd',sigma);
P = struct('coef1',3,'coef2',2,'coef3',4,'mean',0.5,'sd',0.2);
% Instantaneous frequency after 1 sec is 
maxFreq = P.coef1 + 2*P.coef2 + 3*P.coef3;
% Nyqust frequency guess: 2 * max. instantaneous frequency
nyqFreq = 2*maxFreq;
% Sampling frequency
sampFreq = 4*nyqFreq;
% samplFreq = 10*nyqFreq;
samplIntrvl = 1/sampFreq;
% Time samples 
timeVec = -0.2:samplIntrvl:1.2;
% Number of samples
nSamples = length(timeVec);

% Create a fHandle to otherDTS2_new
DTS2H = @(x) otherDTS2_new(timeVec,x,P); % x = SNR

% Plot the time series for A = {10, 12, 15}
A = [10, 12, 15];
figure;
hold on;
sigVec_1 = DTS2H(A(1));
plot(timeVec,sigVec_1,'Marker','.','MarkerSize',24)
sigVec_2 = DTS2H(A(2));
plot(timeVec,sigVec_2,'Marker','.','MarkerSize',24)
sigVec_3 = DTS2H(A(3));
plot(timeVec,sigVec_3,'Marker','.','MarkerSize',24)
xlabel('Time (sec)');
title('Signal Time Series');
legend