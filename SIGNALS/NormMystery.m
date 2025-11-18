%% Generate a quadratic chirp signal with two different sampling
% frequencies. 

% Signal parameters
P = struct('coef1',10,'coef2',3,'coef3',3);
A = 10;

% Instantaneous frequency after 1 sec is 
maxFreq = P.coef1 + 2*P.coef2 + 3*P.coef3;
%Nyqust frequency guess: 2 * max. instantaneous frequency
nyqFreq_1 = 2*maxFreq;
nyqFreq_2 = 2*maxFreq;
% Sampling frequency
samplFreq_1 = 5*nyqFreq_1;
samplFreq_2 = 10*nyqFreq_2;
% samplFreq = 10*nyqFreq;
samplIntrvl_1 = 1/samplFreq_1;
samplIntrvl_2 = 1/samplFreq_2;

% Time samples
timeVec_1 = 0:samplIntrvl_1:1.0;
timeVec_2 = 0:samplIntrvl_2:1.0;

% Generate the signal
sigVec_1 = QuadChirpDTS(timeVec_1,A,P);
sigVec_2 = QuadChirpDTS(timeVec_2,A,P);

% Plot the signal 
figure;
subplot(1,2,1)
plot(timeVec_1,sigVec_1,'Marker','.','MarkerSize',20);
xlabel('Time (sec)');
title('Quadratic Chirp (sampFreq = 5*nyqFreq)');
subplot(1,2,2)
plot(timeVec_2,sigVec_2,'Marker','.','MarkerSize',20);
xlabel('Time (sec)');
title('Quadratic Chirp (sampFreq = 10*nyqFreq)');

% Notice that in the two plots, for the same time t = 0.024s, Y_1 = 0.893
% and Y_2 = 0.632. But changing the sampFreq shouldn't change the signal
% values at the same time, right? Nevretheless it changes because sigVec_1
% has fewer samples than sigVec_2, and so the norm(sigVec_i), which is just
% sqrt(sum(sigVec_i.^2)), is different for the two cases, and we are diving
% the sigVec_i by its norm.

%% Local functions
function sigVec = QuadChirpDTS(dataX,SNR,P)
phaseVec = P.coef1*dataX + P.coef2*dataX.^2 + P.coef3*dataX.^3;
sigVec = sin(2*pi*phaseVec);
sigVec = SNR * sigVec/norm(sigVec); 
end