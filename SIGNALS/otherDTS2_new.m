function sigVec = otherDTS2_new(dataX, SNR, P)
% P is a structure with the fields 'coef1', 'coef2', 'coef3' for the three
% chirp coefficients, and 'mean' for the mean of the gaussian part and 'sd'
% for its standard deviation.
phaseVec = P.coef1*dataX + P.coef2*dataX.^2 + P.coef3*dataX.^3;
sigVec = exp(-(dataX - P.mean).^2/(2*P.sd^2)).*sin(2*pi*phaseVec);
sigVec = SNR * sigVec / norm(sigVec);