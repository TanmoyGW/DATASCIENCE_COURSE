function sigVec = otherDTS2_new(dataX, SNR, P)
% P = struct('coef1',a_1,'coef2',a_2,'coef3',a_3,'mean',mu,'sd',sigma);
phaseVec = P.coef1*dataX + P.coef2*dataX.^2 + P.coef3*dataX.^3;
sigVec = exp(-(dataX - P.mean).^2/(2*P.sd^2)).*sin(2*pi*phaseVec);
sigVec = SNR * sigVec / norm(sigVec);