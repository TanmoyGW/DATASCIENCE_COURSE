clc; clear; close all;

% We choose number of trial values
N = 10000;

% Generate random trial values
%rng(0); % We can set the seed
trVal_rand = rand(1,N);
trVal_randn = randn(1,N);

% Plot the histograms of the trial values
figure;
subplot(1, 2, 1);
histogram(trVal_rand, 30);
title('Histogram of Random Values for rand');
xlabel('Value');
ylabel('Frequency');
grid on
subplot(1, 2, 2);
histogram(trVal_randn, 30);
title('Histogram of Random Values for randn');
xlabel('Value');
ylabel('Frequency');
grid on