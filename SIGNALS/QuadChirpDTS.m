function sigVec = QuadChirpDTS(dataX,SNR,qcCoef)
%phaseVec = Pr.coef1*dataX + Pr.coef2*dataX.^2 + Pr.coef3*dataX.^3;
phaseVec = qcCoef(1)*dataX + qcCoef(2)*dataX.^2 + qcCoef(3)*dataX.^3;
sigVec = sin(2*pi*phaseVec);
%sigVec = SNR * sigVec/norm(sigVec); 
sigVec = SNR * sigVec;