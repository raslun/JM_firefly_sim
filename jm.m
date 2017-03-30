%% Generate initial state
clear all;

flockRadius = 4;
flockDensity = 0.4;
connectionThreshold = 1.7;

[Q, G] = sphereFlock(flockRadius, flockDensity, connectionThreshold);
N = size(Q, 1);
Q(:,5) = 1*rand(N,1);
Q(:,6) = 1+0.5*rand(N,1);

graphMetrics(G);

%% Simulate
dt = 0.005;
time = 3;

[states, flashes] = simulateFlock(Q, G, time, dt);

%% Show graph metrics
graphMetrics(G);

%% Visa flugor
plotFlock(Q, G);

%% Show response curves
showResponseCurves();

%% Tidsserie
showTimeSeries(states, flashes, dt);

%% Tillståndsevolution
showStateEvolution(states, dt, false);

%% Visa simulering
showSimulation(states, flashes, dt, false, false);

%% Visa en flugas detalierade tillst�nd
fly = 1;
plotFlyDetailed(states, flashes, dt, fly);
yyaxis('left');
ylim(1.1*ylim);
grid on;

%% Visa gammal ful simulering
oldPlotBlob(states, flashes, dt);
