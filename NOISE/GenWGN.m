%% Generating white gaussian noise
close all; clear; clc;

% Choose number of samples
N = 10000;

% mean = 0, std. deviation = 1
mean_1 = 0;
sd_1 = 1;
X_1 = mean_1 + sd_1*randn(1,N);
samp_mean_1 = mean(X_1);
samp_sd_1 = std(X_1);

% mean = 0, std. deviation = 2
mean_2 = 0;
sd_2 = 2;
X_2 = mean_2 + sd_2*randn(1,N);
samp_mean_2 = mean(X_2);
samp_sd_2 = std(X_2);

% mean = 0, variance = 2
variance_3 = 2;
mean_3 = 0;
sd_3 = sqrt(variance_3);
X_3 = mean_3 + sd_3*randn(1,N);
samp_mean_3 = mean(X_3);
samp_sd_3 = std(X_3);

% mean = 2, variance = 2;
variance_4 = 2;
mean_4 = 2;
sd_4 = sqrt(variance_4);
X_4 = mean_4 + sd_4*randn(1,N);
samp_mean_4 = mean(X_4);
samp_sd_4 = std(X_4);

% Plot the histograms of each WGN realisation
figure;
subplot(2,2,1);
histogram(X_1, 30);                                
xlabel('Value');
ylabel('Frequency');
title("$\mu_s = " + samp_mean_1 + ",\, \sigma_s = " + samp_sd_1 + "$", 'Interpreter', 'latex')
grid on
subplot(2,2,2);
histogram(X_2, 30);                                
xlabel('Value');
ylabel('Frequency');
title("$\mu_s = " + samp_mean_2 + ",\, \sigma_s = " + samp_sd_2 + "$", 'Interpreter', 'latex')
grid on
subplot(2,2,3);
histogram(X_3, 30);                                
xlabel('Value');
ylabel('Frequency');
title("$\mu_s = " + samp_mean_3 + ",\, \sigma_s = " + samp_sd_3 + "$", 'Interpreter', 'latex')
grid on
subplot(2,2,4);
histogram(X_4, 30);                                
xlabel('Value');
ylabel('Frequency');
title("$\mu_s = " + samp_mean_4 + ",\, \sigma_s = " + samp_sd_4 + "$", 'Interpreter', 'latex')
grid on