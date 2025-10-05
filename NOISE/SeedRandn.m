clc; clear; close all;

% Set the number of trial values
N = 5000;

% Generate two sets of random trial values
rng(0);
trVal_1 = randn(1,N);
rng(0);
trVal_2 = randn(1,N);

% Check if some trial values are in common
commonVal = intersect(trVal_1,trVal_2);

% Display the number of common trial values
nCommon = numel(commonVal);
disp(['Number of common trial values: ', num2str(nCommon)]);