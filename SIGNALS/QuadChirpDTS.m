function sigVec = QuadChirpDTS(dataX,SNR,qcCoefs)
%phaseVec = Pr.coef1*dataX + Pr.coef2*dataX.^2 + Pr.coef3*dataX.^3;
phaseVec = qcCoefs(1)*dataX + qcCoefs(2)*dataX.^2 + qcCoefs(3)*dataX.^3;
sigVec = sin(2*pi*phaseVec);
sigVec = SNR * sigVec/norm(sigVec); 