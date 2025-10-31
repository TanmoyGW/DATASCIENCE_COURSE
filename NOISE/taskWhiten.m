function [inData,outData] = taskWhiten(psdVals,fltrOrdr,sampFreq,data)
% Whiten a given data containing CGN realisation and a mystery signal
% Y = taskWhiten(PSD,O,Fs,data)
% Generates a realization Y of whitened data with a target
% power spectral density given by the CGN PSD. Fs is the sampling frequency
% of Y. PSD is an M-by-2 matrix containing frequencies and the corresponding
% PSD values in the first and second columns respectively. The frequencies
% must start from 0 and end at Fs/2. The order of the FIR filter to be used
% is given by O.

%Tanmoy Chakraborty, Oct 25, 2025

% Design FIR filter with T(f)= 1/(square root of target PSD)
freqVec = psdVals(:,1);

% Handle the non-positive PSD values
psdVals(psdVals(:,2)<=0,2)=min(psdVals(psdVals(:,2)>0,2));

% Design the whitening filter using target PSD
transfn = 1 ./ sqrt(psdVals(:,2));
b = fir2(fltrOrdr,freqVec/(sampFreq/2),transfn);

% Pass data through the filter
inData = data;
outData = fftfilt(b,inData);
end