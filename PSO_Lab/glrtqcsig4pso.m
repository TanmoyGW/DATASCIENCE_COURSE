function [fitVal,varargout] = glrtqcsig4pso(xVec,params)
% Fitness function for quadratic chirp regression
% F = GLRTQCSIG4PSO(X,P)
% Compute the fitness function (log-likelihood ratio for colored noise maximized over the 
% amplitude parameter) for data containing the
% quadratic chirp signal at the parameter values in X.  The fitness values 
% are returned in F. X is standardized, that is 0<=X(i,j)<=1. The fields P.rmin and 
% P.rmax  are used to convert X(i,j) internally before computing the fitness:
% X(:,j) -> X(:,j)*(rmax(j)-rmin(j))+rmin(j).
% The fields P.dataY and P.dataX are used to transport the data and its
% time stamps. The fields P.dataXSq and P.dataXCb contain the timestamps
% squared and cubed respectively. The field P.npsd is used to provide the
% noise PSD. The fields P.nSamp and P.sf are the number of samples and the
% sampling frequency respectively.
%
% [F,R] = GLRTQCSIG4PSO(X,P)
% returns the quadratic chirp coefficients corresponding to the rows of X in R.
% Converts standardized to real (unstandardized) coordinates, i.e., the parameters 
% a1, a2, and a3.
%
% [F,R,S] = GLRTQCSIG4PSO(X,P)
% Returns the quadratic chirp signals corresponding to the rows of X in S.
% Converts the real coordinates to QC signal time series.

% Tanmoy Chakraborty
% Nov, 2025
%==========================================================================

% rows: points
% columns: coordinates of a point
[nVecs,~]=size(xVec);

% storage for fitness values
fitVal = zeros(nVecs,1);

% Check for out of bound coordinates and flag them
validPts = crcbchkstdsrchrng(xVec);
% Set fitness for invalid points to infty
fitVal(~validPts)=inf;
xVec(validPts,:) = s2rv(xVec(validPts,:),params);

for lpc = 1:nVecs
    if validPts(lpc)
    % Only the body of this block should be replaced for different fitness
    % functions
        x = xVec(lpc,:);
        fitVal(lpc) = ssrqc(x, params);
    end
end

% Return real coordinates if requested
if nargout > 1
    varargout{1}=xVec;
end

% Sum of squared residuals after maximizing over amplitude parameter
function ssrVal = ssrqc(x,params)
% Generate normalized quadratic chirp
phaseVec = x(1)*params.dataX + x(2)*params.dataXSq + x(3)*params.dataXCb;
qc = sin(2*pi*phaseVec);
%qc = qc/norm(qc);

% Compute fitness
%nSamples = params.nSamp;
sampFreq = params.sf;
% dataLen = nSamples/sampFreq;
% kNyq = floor(nSamples/2)+1;
%posFreq = (0:(kNyq-1))*(1/dataLen);
psdPosFreq = params.npsd;
% Template waveform
[tempVec,~] = normsig4psd(qc,sampFreq,psdPosFreq,1);
llr = innerprodpsd(params.dataY,tempVec,sampFreq,psdPosFreq);
ssrVal = -llr^2;