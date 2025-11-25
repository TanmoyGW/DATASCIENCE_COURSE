%% Plotting fitness functions
% Define the range for both variables x1 and x2
x = linspace(-5, 5, 500);
% Create a 2D grid out of the 1D range
[x_1, x_2] = meshgrid(x, x);
% Define the Rastrigin-type function f(x1,x2)
F = (x_1.^2 - 10*cos(2*pi*x_1) + 10) + (x_2.^2 - 10*cos(2*pi*x_2) + 10);
% Produce a 3D surface plot
surf(x_1, x_2, F);
shading interp;
lighting none; 
colorbar;