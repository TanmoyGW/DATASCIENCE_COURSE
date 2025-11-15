function GLRTValQC = glrtqcsig(a1,a2,a3,dataVec,timeVec,psdPosFreq,sampFreq)
sigVec = crcbgenqcsig(timeVec,1,[a1,a2,a3]);
[tempVec,~] = normsig4psd(sigVec,sampFreq,psdPosFreq,1);
llr = innerprodpsd(dataVec,tempVec,sampFreq,psdPosFreq);
GLRTValQC = llr^2;