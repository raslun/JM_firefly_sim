%% Save results
name = datetime;

clear Q G states flashes top bottom pivot
clear flockDensity flockDensityIndex flockRadius flockRadiusIndex
clear frequencySpread frequencySpreadIndex iteration zeta zetaIndex
clear thau thayIndex connectionThreshold connectionThresholdIndex

mkdir output simulations;
save(['output/simulations/', char(name), ' manual save']);
%% Batch simulate

%TODO
<<<<<<< HEAD




clear;
name='freq(0,0.6,7)';  % Name of simulation
=======
%
%
% Parameters

clear;
name='kurvskillnader';  % Name of simulation
>>>>>>> 13571b2cc19b6400b28677594248329d7c526a4d

%Make dir+dir for plots, stop if simulation exist
%dir_save= ['output/simulations/', name,'/'];
%dir_pics=[dir_save,'pics'];
%if exist(dir_save,'dir')==7
%    error('A simulation with that name already exist');
%end
%mkdir('output/simulations', name);
%mkdir(dir_pics);


%Simulation variables
dt = 5*10^-3;
time = 60;
findTrueSynchronyLevel = 1; % Use slow binary search to find actual synchronization level
synchronyLimit = 0.85;
timeTolerance = [-0.025, 0.025];
numberOfIterations = 100;
frequencyTolerance = 0.05;


<<<<<<< HEAD
%Responsecurve variables
alphas = 0.5;
betas = linspace(0.1,0.5,5);
gammas = 0.05;
as = linspace(0,0.4,5);
bs = linspace(0,0.4,5);
=======
%Responsecurve
alphas = 0.5;
betas = 0.4;
gammas = 0;
as = 0.2;
bs = 0.4;
>>>>>>> 13571b2cc19b6400b28677594248329d7c526a4d



%flock variables
frequencySpreads = 0.5; %base freq + frequency spread
<<<<<<< HEAD
phaseSpreads = 1;  % starting phase [0,phasespreads]
flockRadi = 4; % Radius of spherical flock
flockDensities = 0.3; % Density of generated flock
connectionThresholds = 2.5; % Distance flys can see eachother
=======
phaseSpreads = 1;  % phase spread [0,1]
flockRadi = 1*2*pi; % Radius of spherical flock
flockDensities = 0.1; % Density of generated flock
connectionThresholds = 2.75; % Distance flys can see eachother
>>>>>>> 13571b2cc19b6400b28677594248329d7c526a4d

% fly variables
baseFrequency = 1; % base frequency of a oscillator
deltas = 0;  % Time delay
zetas = 0.05; % fraction of period to go blind after seeing a flash
thaus = 0; % fraction of period to go blind after flashing


% init synchronyTime matrix
synchronyTime = zeros([ ...
    size(frequencySpreads, 2), ...
    size(phaseSpreads, 2), ...
    size(flockRadi, 2), ...
    size(flockDensities, 2), ...
    numberOfIterations, ... % ammount of simulations to average when stochastic variables are present
    size(connectionThresholds, 2), ...
    size(zetas, 2), ...
    size(thaus, 2), ...
    size(deltas, 2), ...
    size(alphas, 2), ...
    size(betas, 2), ...
    size(gammas, 2), ...
    size(as, 2), ...
    size(bs, 2), ...
    ]);

avgFlashesToSync = synchronyTime; % Make a copy of the empty matrix
averageSynchronyLevel = synchronyTime; % Again
averageConnections = synchronyTime; % Again
finalAverageFrequency = synchronyTime; % Again
numberOfFlies = synchronyTime; % Again
finalFrequencySpread = synchronyTime; % Again
frequencyLimitReachedTime = synchronyTime; % Again

if findTrueSynchronyLevel
    trueSynchronyLevelResult = synchronyTime; % Again
end


<<<<<<< HEAD
evaluations = numel(synchronyTime); %Number of simulations
counter = 0;    % Keep track of calculations done
progressBar = waitbar(0, [num2str(counter), '/', num2str(evaluations)]);
=======
counter = 0;    % Keep track of calculations done

%Number of simulations
evaluations = numel(synchronyTime);
progressBar = waitbar(counter/evaluations, [num2str(counter), '/', num2str(evaluations)]);
>>>>>>> 13571b2cc19b6400b28677594248329d7c526a4d
tic; % Initialize update timer

%Simulation
% Nested loops keeping track of indexes for result vectors.
for frequencySpreadIndex = 1:size(frequencySpreads, 2)
    frequencySpread = frequencySpreads(frequencySpreadIndex);
    for phaseSpreadIndex = 1:size(phaseSpreads, 2)
        phaseSpread = phaseSpreads(phaseSpreadIndex);
        for flockRadiusIndex = 1:size(flockRadi, 2)
            flockRadius = flockRadi(flockRadiusIndex);
            for flockDensityIndex = 1:size(flockDensities,2)
                flockDensity = flockDensities(flockDensityIndex);
                
                % No need to generate a new flock when we only vary the
                % flies. Therefore the flock is generated here.
                for iteration = 1:numberOfIterations
                    % Generate flock
                    Qinit = sphereFlock(flockRadius, flockDensity);
                    N = size(Qinit, 1);
                    Qinit(:,5) = phaseSpread*rand(N,1);
                    Qinit(:,6) = baseFrequency+frequencySpread*rand(N,1);
                    Qinit(:,7) = zeros(N,1);
                    
                    % When changing connection threshold only the graph
                    % changes.
                    for connectionThresholdIndex = 1:size(connectionThresholds,2)
                        connectionThreshold = connectionThresholds(connectionThresholdIndex);
                        
                        [Q, G] = calculateGraph(Qinit, connectionThreshold);
                        
                        for zetaIndex = 1:size(zetas, 2)
                            zeta = zetas(zetaIndex);
                            for thauIndex = 1:size(thaus, 2)
                                thau = thaus(thauIndex);
                                for deltaIndex = 1:size(deltas, 2)
                                    delta = deltas(deltaIndex);
                                    for alphaIndex = 1:size(alphas,2)
                                        alpha = alphas(alphaIndex);
                                        for betaIndex = 1:size(betas,2)
                                            beta=betas(betaIndex);
                                            for gammaIndex = 1:size(gammas,2)
                                                gamma=gammas(gammaIndex);
                                                for aIndex = 1:size(as,2)
                                                    a=as(aIndex);
                                                    for bIndex = 1:size(bs,2)
                                                        b=bs(bIndex);
                                                        
                                                        clear states; clear flashes; % Free up some memory
                                                        
<<<<<<< HEAD
                                                        % Simulate
                                                        [states, flashes] = simulateFlock(Q, G, time, dt, thau, zeta, delta, alpha, beta, gamma, a, b);
=======
                                                        %save
                                                        %save([dir_save,[name,num2str(counter,'%03d') '.mat'] ],'states');
>>>>>>> 13571b2cc19b6400b28677594248329d7c526a4d
                                                        
                                                        % evaluate
                                                        if findTrueSynchronyLevel
                                                            % Determine best level of synchrony
                                                            
                                                            level = trueSynchronyLevel(states, flashes, dt, timeTolerance, 10);
                                                            
                                                            trueSynchronyLevelResult( ...
                                                                frequencySpreadIndex, ...
                                                                phaseSpreadIndex, ...
                                                                flockRadiusIndex, ...
                                                                flockDensityIndex, ...
                                                                iteration, ...
                                                                connectionThresholdIndex, ...
                                                                zetaIndex, ...
                                                                thauIndex, ...
                                                                deltaIndex, ...
                                                                alphaIndex, ...
                                                                betaIndex, ...
                                                                gammaIndex, ...
                                                                aIndex, ...
                                                                bIndex ...
                                                                ) = level;
                                                            
                                                            [synchronyTimeData, avgFlashesToSyncData, averageSynchronyLevelData ] = ...
                                                                evaluateSynchrony( states, flashes, dt, level, timeTolerance );
                                                            
                                                        else
                                                            [synchronyTimeData, avgFlashesToSyncData, averageSynchronyLevelData ] = ...
                                                                evaluateSynchrony( states, flashes, dt, synchronyLimit, timeTolerance );
                                                        end
                                                        
                                                        % save result
                                                        synchronyTime( ...
                                                            frequencySpreadIndex, ...
                                                            phaseSpreadIndex, ...
                                                            flockRadiusIndex, ...
                                                            flockDensityIndex, ...
                                                            iteration, ...
                                                            connectionThresholdIndex, ...
                                                            zetaIndex, ...
                                                            thauIndex, ...
                                                            deltaIndex, ...
                                                            alphaIndex, ...
                                                            betaIndex, ...
                                                            gammaIndex, ...
                                                            aIndex, ...
                                                            bIndex ...
                                                            ) = synchronyTimeData;
                                                        
                                                        avgFlashesToSync( ...
                                                            frequencySpreadIndex, ...
                                                            phaseSpreadIndex, ...
                                                            flockRadiusIndex, ...
                                                            flockDensityIndex, ...
                                                            iteration, ...
                                                            connectionThresholdIndex, ...
                                                            zetaIndex, ...
                                                            thauIndex, ...
                                                            deltaIndex, ...
                                                            alphaIndex, ...
                                                            betaIndex, ...
                                                            gammaIndex, ...
                                                            aIndex, ...
                                                            bIndex ...
                                                            ) = avgFlashesToSyncData;
                                                        
                                                        averageSynchronyLevel( ...
                                                            frequencySpreadIndex, ...
                                                            phaseSpreadIndex, ...
                                                            flockRadiusIndex, ...
                                                            flockDensityIndex, ...
                                                            iteration, ...
                                                            connectionThresholdIndex, ...
                                                            zetaIndex, ...
                                                            thauIndex, ...
                                                            deltaIndex, ...
                                                            alphaIndex, ...
                                                            betaIndex, ...
                                                            gammaIndex, ...
                                                            aIndex, ...
                                                            bIndex ...
                                                            ) = averageSynchronyLevelData;
                                                        
                                                        averageConnections( ...
                                                            frequencySpreadIndex, ...
                                                            phaseSpreadIndex, ...
                                                            flockRadiusIndex, ...
                                                            flockDensityIndex, ...
                                                            iteration, ...
                                                            connectionThresholdIndex, ...
                                                            zetaIndex, ...
                                                            thauIndex, ...
                                                            deltaIndex, ...
                                                            alphaIndex, ...
                                                            betaIndex, ...
                                                            gammaIndex, ...
                                                            aIndex, ...
                                                            bIndex ...
                                                            ) = mean(degree(G));
                                                        
                                                        finalAverageFrequency( ...
                                                            frequencySpreadIndex, ...
                                                            phaseSpreadIndex, ...
                                                            flockRadiusIndex, ...
                                                            flockDensityIndex, ...
                                                            iteration, ...
                                                            connectionThresholdIndex, ...
                                                            zetaIndex, ...
                                                            thauIndex, ...
                                                            deltaIndex, ...
                                                            alphaIndex, ...
                                                            betaIndex, ...
                                                            gammaIndex, ...
                                                            aIndex, ...
                                                            bIndex ...
                                                            ) = mean(states(end,:,6));
                                                        
                                                        numberOfFlies( ...
                                                            frequencySpreadIndex, ...
                                                            phaseSpreadIndex, ...
                                                            flockRadiusIndex, ...
                                                            flockDensityIndex, ...
                                                            iteration, ...
                                                            connectionThresholdIndex, ...
                                                            zetaIndex, ...
                                                            thauIndex, ...
                                                            deltaIndex, ...
                                                            alphaIndex, ...
                                                            betaIndex, ...
                                                            gammaIndex, ...
                                                            aIndex, ...
                                                            bIndex ...
                                                            ) = size(states, 2);
                                                        %save
                                                        save([dir_save,[name,num2str(counter,'%03d') '.mat']],'trueSynchronyLevelResult', 'synchronyTime', 'avgFlashesToSync', 'averageSynchronyLevel', 'averageConnections', 'finalAverageFrequency', 'numberOfFlies', 'states');
                                                        
                                                        finalFrequencySpread( ...
                                                            frequencySpreadIndex, ...
                                                            phaseSpreadIndex, ...
                                                            flockRadiusIndex, ...
                                                            flockDensityIndex, ...
                                                            iteration, ...
                                                            connectionThresholdIndex, ...
                                                            zetaIndex, ...
                                                            thauIndex, ...
                                                            deltaIndex, ...
                                                            alphaIndex, ...
                                                            betaIndex, ...
                                                            gammaIndex, ...
                                                            aIndex, ...
                                                            bIndex ...
                                                            ) = max(states(end, :, 6))-min(states(end, :, 6));
                                                        
                                                        
                                                        frequencyLimitReachedTime( ...
                                                            frequencySpreadIndex, ...
                                                            phaseSpreadIndex, ...
                                                            flockRadiusIndex, ...
                                                            flockDensityIndex, ...
                                                            iteration, ...
                                                            connectionThresholdIndex, ...
                                                            zetaIndex, ...
                                                            thauIndex, ...
                                                            deltaIndex, ...
                                                            alphaIndex, ...
                                                            betaIndex, ...
                                                            gammaIndex, ...
                                                            aIndex, ...
                                                            bIndex ...
                                                            ) = frequencyLimitTime(states, flashes, dt, frequencyTolerance);

                                                        
                                                        if mod(counter, 1000) == 0
                                                            name = datetime;
                                                            save(['output/simulations/', char(name)]);
                                                            disp('saved with name:');
                                                            disp(name);
                                                        end
                                                        
                                                        counter = counter + 1;
                                                        
                                                        if toc >= 1 % Update progress bar at most every second.
                                                            waitbar(counter/evaluations, progressBar, [num2str(counter), '/', num2str(evaluations)]);
                                                            tic;
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                    
                                    
                                end
                            end
                        end
                    end
                end
                
            end
        end
    end
end
close(progressBar);

% This value can be computed after the simulation
connectionDegree = averageConnections./numberOfFlies;

<<<<<<< HEAD

=======
name = datetime;
save(['output/simulations/', char(name)]);
disp('saved with name:')
disp(name);
%% grej
[X Y] = meshgrid(connectionThresholds, flockRadi);
Zlevel = squeeze(mean(trueSynchronyLevelResult, 5));
contour(X, Zlevel, Y); c = colorbar;
title('Synkronisering vs kopplingsavstånd vs flockradie');
xlabel('Kopplingsavstånd');
ylabel('Synkroniseringsgrad');
ylabel(c, 'Flockens radie');
grid on;

%% varying connection thresholds, flock radius
f3 = figure()
E = reshape(connectionDegree, 1, numel(connectionDegree));
F = reshape(trueSynchronyLevelResult, 1, numel(trueSynchronyLevelResult)); 
rem = find(E > 0.15);
E(rem) = [];
F(rem) = [];
hist3([E;F]',[25,25]); hold on;
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
>>>>>>> 13571b2cc19b6400b28677594248329d7c526a4d
%% varying connection thresholds, 2 thaus, any number of iterations
avgTrueSynchronyLevelResult = squeeze(mean(trueSynchronyLevelResult,5));
avgNumberOfFlies = squeeze(mean(numberOfFlies, 5));

f1 = figure()
yyaxis('right')
plot(connectionThresholds, avgNumberOfFlies(:,1), ':'); hold on;
ylabel('antal')
yyaxis('left')
plot(connectionThresholds, avgTrueSynchronyLevelResult(:, 1));
plot(connectionThresholds, avgTrueSynchronyLevelResult(:, 2), '--'); grid on;
ylabel('synkroniseringsgrad')
xlabel('kopplingsavst?nd')
legend('\xi = 0','\xi = 0.1','medelantal flugor', 'Location', 'southeast');
title('Synkroniseringsgrad m.a.p kopplingsavst?nd');

f2 = figure()
A = averageConnections(:,:,:,:,:,:,:,1);
B = trueSynchronyLevelResult(:,:,:,:,:,:,:,1);
scatter(reshape(A, 1, prod(size(A))),reshape(B, 1, prod(size(B))),'.'); hold on;
C = averageConnections(:,:,:,:,:,:,:,2);
D = trueSynchronyLevelResult(:,:,:,:,:,:,:,2);
scatter(reshape(C, 1, prod(size(C))),reshape(D, 1, prod(size(D))),'.'); grid on;
xlabel('medelantal kopplingar per oscillator');
ylabel('synkroniseringsgrad');
legend('\xi = 0', '\xi = 0.1', 'Location', 'southeast');
title('Utfall av synkronisering m.a.p antal kopplingar');
ylim([0,1.05]);

f3 = figure()
E = averageConnections(:,:,:,:,:,:,:,1);
F = finalAverageFrequency(:,:,:,:,:,:,:,1);
scatter(reshape(E, 1, prod(size(E))),reshape(F, 1, prod(size(F))),'.'); hold on;
G = averageConnections(:,:,:,:,:,:,:,2);
H = finalAverageFrequency(:,:,:,:,:,:,:,2);
scatter(reshape(G, 1, prod(size(G))),reshape(H, 1, prod(size(H))),'.'); grid on;

a = mean(reshape(F, 1, prod(size(F))));
b = mean(reshape(H, 1, prod(size(H))));
lim = xlim;
plot(lim, [a, a], 'blue--');
plot(lim, [b, b], 'red--');
xlabel('medelantal kopplingar per oscillator');
ylabel('slutgiltig medelfrekvens');
legend('\xi = 0', '\xi = 0.1', 'medel f?r \xi = 0', 'medel f?r \xi = 0.1', 'Location', 'southeast');
title('Utfall av slutfrekvens m.a.p antal kopplingar');
%% Percent success with 20 connection thresholds, 2 thaus and 25 iterations

numberOfOk = zeros(2, 20);
for i=1:20
    for j=1:2
        numberOfOk(j, i) = nnz(averageSynchronyLevel(1,1,1,1,:,i,1,j));
    end
end

percentSuccess = numberOfOk/25;

plot(connectionThresholds, percentSuccess(1,:)); hold on;
plot(connectionThresholds, percentSuccess(2,:), '--'); grid on;




%% funkar bara f?r mig
close all
%colors=['b', 'r', 'y', 'k', 'g', 'm', 'c'];
plotFreqVariableParam('default_values')

%%
%   Order of color
name='freq(0,0.6,7)';
colors=['b', 'r', 'y', 'k', 'g', 'm', 'c','b', 'r', 'y', 'k', 'g', 'm', 'c','b', 'r', 'y', 'k', 'g', 'm', 'c','b', 'r', 'y', 'k', 'g', 'm', 'c','b', 'r', 'y', 'k', 'g', 'm', 'c' ];
% Change directory to 'name'
cd_str=['~/Documents/JM_Firefly_Sim/output/simulations/',name];
if exist(cd_str, 'dir') == 7
    cd(cd_str);
    %lista simuleringar
    dirs=dir;
    dirs(3).name;
    % (. .. pics sim1 sim2 sim3) i dir
    % figure('Name', ['Frequencychange for oscillators' char(datetime)])
    for i=0:size(dirs,1)-4
        if exist(cd_str, 'dir') == 7
            cd(cd_str);
        end
        load([name num2str(i,'%03d') '.mat'])
        cd ../../..
        scatter(frequencySpread,trueSynchronyLevel);
        hold on
        %plotFrequencyChange(states, colors, i)
    end
    
    %cd_pics_str=[cd_str,'/pics'];
    %cd(cd_pics_str);
    %print(name,'-depsc','-r200');
    %back to workspace directory
    %cd ../../../..
end


%%

[X,Y,Z]=meshgrid(as,bs,betas);
BF=squeeze(averageSynchronyLevel);
KL=reshape(BF,[size(BF,1),size(BF,2), size(BF,3)]);
surf(X,Y,KL);


%% surf
clear alpha;

for i=1:1:size(betas,2)
    workOn = finalAverageFrequency(:,:,:,:,:,:,:,1,:,:,i,:,:,:);
    x = as;
    y = bs;

    mnsq = squeeze(mean(workOn,5));
    [X, Y] = meshgrid(x, y);
    surf(X,Y,mnsq, betas(i)*ones(size(mnsq))); hold on;
end

c = colorbar;
xlabel('a');
ylabel('b');
ylabel(c,'beta');
alpha 0.65;

clear alpha;

%%
for i=2:2:size(betas,2)
    workOn = frequencyLimitReachedTime(:,:,:,:,:,:,:,1,:,:,i,:,:,:);
    x = as;
    y = bs;

    workOn(workOn > 14) = NaN;
    sucrate = 100*sum(~isnan(workOn),5)/numberOfIterations;
    sq = squeeze(sucrate);
    [X, Y] = meshgrid(x, y);
    surf(X,Y,sq, betas(i)*ones(size(sq))); hold on;
end

c = colorbar;
xlabel('a');
ylabel('b');
ylabel(c,'beta');
alpha 0.65;