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
nSamples = length(data_1); % same for all the datas
timeVec = (0:(nSamples-1))/sampFreq;

% We will use this noise PSD here
noisePSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000 + 1;
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
psdPosFreq = noisePSD(posFreq);

% QC Signal parameters and GLRTs of the datas
a_1 = 10;
a_2 = 3;
a_3 = 3;
GLRT_1 = glrtqcsig(a_1,a_2,a_3,data_1,timeVec,psdPosFreq,sampFreq);
GLRT_2 = glrtqcsig(a_1,a_2,a_3,data_2,timeVec,psdPosFreq,sampFreq);
GLRT_3 = glrtqcsig(a_1,a_2,a_3,data_3,timeVec,psdPosFreq,sampFreq);
disp("GLRT of data1.txt is ")
disp(GLRT_1)
disp("GLRT of data2.txt is ")
disp(GLRT_2)
disp("GLRT of data3.txt is ")
disp(GLRT_3)

%% Estimating the significance of the GLRT values
% Template vectors
sigVec = crcbgenqcsig(timeVec,1,[a_1,a_2,a_3]);
[tempVec,~] = normsig4psd(sigVec,sampFreq,psdPosFreq,1);
% Calculate GLRT under null hypothesis: data is only noise
% Number of data realisations to generate under null hypothesis:
nRl = 20000;
glrtH0 = zeros(1,nRl); % Null hypothesis
rng(0); % Set the seed
for lpr = 1:nRl
    % Generate noise realizations
    noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
    % Compute GLRT values for data_1
    llr = innerprodpsd(noiseVec,tempVec,sampFreq,psdPosFreq);
    glrtH0(lpr) = llr^2;
end

% Estimate test signifance
count_1 = sum(glrtH0 >= GLRT_1);
count_2 = sum(glrtH0 >= GLRT_2);
count_3 = sum(glrtH0 >= GLRT_3);
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