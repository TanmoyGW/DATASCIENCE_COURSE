% The mathematics for this trivariate case is provided in 
% the file 'ChallengeExTheory.pdf'
clc; close all; clear;
% Set the angle parameters
theta_1 = 18; % in degrees
theta_2 = 24;
theta_3 = 53;

% Correlation coefficients
rho_1 = sind(theta_2)*cosd(theta_1);
rho_2 = cosd(theta_2)*cosd(theta_3);
rho_3 = sind(theta_1)*sind(theta_3);
rho = [rho_1, rho_2, rho_3];

% Number of trials
nTrials = 10000;

% Trial values of uncorrelated Normal random variables
X_1 = randn(1,nTrials);
X_2 = randn(1,nTrials);
X_3 = randn(1,nTrials);

% Linear combinations
X = [X_1; X_2; X_3]';
A = [sind(theta_1) cosd(theta_1) 0;
     0 sind(theta_2) cosd(theta_2);
     sind(theta_3) 0 cosd(theta_3)];
Y = X*A;
Y_1 = Y(:,1);
Y_2 = Y(:,2);
Y_3 = Y(:,3);

% Estimate correlation coefficient
disp(['Predicted correlation coefficients: ',mat2str(rho)]);
disp(corrcoef([Y_1(:),Y_2(:),Y_3(:)]));

% Scatterplot
figure;
plot3(Y_1,Y_2,Y_3,'.');
axis tight;
axis equal;
xlabel('Trial values of Y_1');
ylabel('Trial values of Y_2');
zlabel('Trial values of Y_3');

% To get matrix A for a given covariance matrix C.
% One can show that C = A*A^T. We then diagonalise A using 
% orthogonal matrix Q so that Q^T*C*Q = Lambda. It can be seen
% that if A = Q*\sqrt{Lambda}, then A*A^T = C.
C = [1.00  0.50  0.20;
     0.50  1.25  0.40;
     0.20  0.40  1.13]; % Our desired C
[Q,Lambda] = eig(C);
A_n = Q*sqrt(Lambda);
disp('Here is C:')
disp(C);
disp("Here is A_n:");
disp(A_n);
disp('Check A_n*A_n^T = C:');
disp(A_n*A_n'); 
% Now we use this A_new to generate trial values from a trivariate normal distribution
% with covariance matrix C
Y_n = X*A_n;
Y1 = Y_n(:,1);
Y2 = Y_n(:,2);
Y3 = Y_n(:,3);

% Scatterplot
figure;
plot3(Y1,Y2,Y3,'.');
axis tight;
axis equal;
xlabel('Trial values of Y_1');
ylabel('Trial values of Y_2');
zlabel('Trial values of Y_3');