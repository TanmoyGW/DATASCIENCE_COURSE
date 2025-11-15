%% Calculation of GLRT for given data realisations
clear; close; clc;
addpath ../SIGNALS
addpath ../NOISE

% Load the data files
data_1 = load("data1.txt");
data_2 = load("data2.txt");
data_3 = load("data3.txt");
data_1 = data_1.';
data_2 = data_2.';
data_3 = data_3.';

% Parameters for data realization
sampFreq = 1024; % Given sampling frequency
nSamples_1 = length(data_1);
nSamples_2 = length(data_2);
nSamples_3 = length(data_3);
timeVec_1 = (0:(nSamples_1-1))/sampFreq;
timeVec_2 = (0:(nSamples_2-1))/sampFreq;
timeVec_3 = (0:(nSamples_3-1))/sampFreq;

% We will use this noise PSD here
noisePSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000 + 1;
dataLen_1 = nSamples_1/sampFreq;
kNyq_1 = floor(nSamples_1/2)+1;
posFreq_1 = (0:(kNyq_1-1))*(1/dataLen_1);
psdPosFreq_1 = noisePSD(posFreq_1);

dataLen_2 = nSamples_2/sampFreq;
kNyq_2 = floor(nSamples_2/2)+1;
posFreq_2 = (0:(kNyq_2-1))*(1/dataLen_2);
psdPosFreq_2 = noisePSD(posFreq_2);

dataLen_3 = nSamples_3/sampFreq;
kNyq_3 = floor(nSamples_3/2)+1;
posFreq_3 = (0:(kNyq_3-1))*(1/dataLen_3);
psdPosFreq_3 = noisePSD(posFreq_3);

% QC Signal parameters and GLRTs of the datas
a_1 = 10;
a_2 = 3;
a_3 = 3;
GLRT_1 = glrtqcsig(a_1,a_2,a_3,data_1,timeVec_1,psdPosFreq_1,sampFreq);
GLRT_2 = glrtqcsig(a_1,a_2,a_3,data_2,timeVec_2,psdPosFreq_2,sampFreq);
GLRT_3 = glrtqcsig(a_1,a_2,a_3,data_3,timeVec_3,psdPosFreq_3,sampFreq);
disp("GLRT of data1.txt is ")
disp(GLRT_1)
disp("GLRT of data2.txt is ")
disp(GLRT_2)
disp("GLRT of data3.txt is ")
disp(GLRT_3)

%% Estimating the significance of the GLRT values
% Template vectors
sigVec_1 = crcbgenqcsig(timeVec_1,1,[a_1,a_2,a_3]);
sigVec_2 = crcbgenqcsig(timeVec_2,1,[a_1,a_2,a_3]);
sigVec_3 = crcbgenqcsig(timeVec_3,1,[a_1,a_2,a_3]);
[tempVec_1,~] = normsig4psd(sigVec_1,sampFreq,psdPosFreq_1,1);
[tempVec_2,~] = normsig4psd(sigVec_2,sampFreq,psdPosFreq_2,1);
[tempVec_3,~] = normsig4psd(sigVec_3,sampFreq,psdPosFreq_3,1);
% Calculate GLRT under null hypothesis: data is only noise
% Number of data realisations to generate under null hypothesis:
nRl = 5000;
% For data_1:
glrtH0_1 = zeros(1,nRl); % Null hypothesis
for lpr = 1:nRl
    % Generate noise realizations
    noiseVec_1 = statgaussnoisegen(nSamples_1,[posFreq_1(:),psdPosFreq_1(:)],100,sampFreq);
    % Compute GLRT values for data_1
    llr_1 = innerprodpsd(noiseVec_1,tempVec_1,sampFreq,psdPosFreq_1);
    glrtH0_1(lpr) = llr_1^2;
end
% For data_2:
glrtH0_2 = zeros(1,nRl); % Null hypothesis
for lpr = 1:nRl
    % Generate noise realizations
    noiseVec_2 = statgaussnoisegen(nSamples_2,[posFreq_2(:),psdPosFreq_2(:)],100,sampFreq);
    % Compute GLRT values for data_2
    llr_2 = innerprodpsd(noiseVec_2,tempVec_2,sampFreq,psdPosFreq_2);
    glrtH0_2(lpr) = llr_2^2;
end
% For data_3:
glrtH0_3 = zeros(1,nRl); % Null hypothesis
for lpr = 1:nRl
    % Generate noise realizations
    noiseVec_3 = statgaussnoisegen(nSamples_3,[posFreq_3(:),psdPosFreq_3(:)],100,sampFreq);
    % Compute GLRT values for data_3
    llr_3 = innerprodpsd(noiseVec_3,tempVec_3,sampFreq,psdPosFreq_3);
    glrtH0_3(lpr) = llr_3^2;
end
% Estimate test signifance
count_1 = sum(glrtH0_1 >= GLRT_1);
count_2 = sum(glrtH0_2 >= GLRT_2);
count_3 = sum(glrtH0_3 >= GLRT_3);
testSig_1 = count_1/nRl;
testSig_2 = count_2/nRl;
testSig_3 = count_3/nRl;
% Display the estimated significance of the GLRT values
disp("Estimated significance of GLRT for data1.txt is ")
disp(testSig_1)
disp("Estimated significance of GLRT for data2.txt is ")
disp(testSig_2)
disp("Estimated significance of GLRT for data3.txt is ")
disp(testSig_3)