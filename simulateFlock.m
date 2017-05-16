function [ states, flashes ] = simulateFlock( Q, G, time, dt, thau, zeta, delta, alpha, beta, gamma, a, b)
% 
% alpha,beta,gamma,a,b - ResponseCurve
% thau, zeta - blind periods
% time - total simtime
% dt - time per simstep
% G - graph
% Q - flies

<<<<<<< HEAD


    T = round(time/dt);  %number of simsteps
    N = size(Q,1);       %number of flies
    delaysteps = round(delta/dt);
=======
    T = round(time/dt); % How many simulation steps to run
    N = size(Q,1);
    delaysteps = round(delta/dt); % The ammount of timesteps for a signal to propagate between two flies
>>>>>>> 13571b2cc19b6400b28677594248329d7c526a4d

    states = zeros([T, size(Q)]);       %init states
    flashes = zeros(0,N+2);             %init flashes

<<<<<<< HEAD
    states(1,:,:) = Q;                  % first simstep = Qinit
    for t=2:T  % iterate over every simstep
        flashesArrived = zeros(0,N+2);
        if delaysteps > 0 && t > delaysteps
            flashesArrived = flashes(flashes(:,end) == t-delaysteps,:);
        end
        Q = squeeze(states(t-1,:,:));    % states from previous step
        Qn = Q;
        for i=1:N % iterate over every fly
            if Qn(i,5) >= 1
                [Qn, flashes] = doFlash(t, i, Qn, states, flashes, G, thau, zeta, delaysteps, alpha, beta, gamma, a, b);
            end
            if delaysteps > 0
                neig = neighbors(G,i);
                for j = 1:size(neig,1) % iterate over every neigbor 
                    flyIndex = neig(j);
                    flashesArrivedFromJ = flashesArrived(flashesArrived(:,end-1) == flyIndex, :);
                    for k = 1:size(flashesArrivedFromJ,1)  % iterate over every flash 
                        [p, f, listening] = calcResponse(Qn(i,5), Qn(i,6), thau, alpha, beta, gamma, a, b);
                        if Qn(i, 7) <= 0    % if not blind, zeta<=0                
                            Qn(i,5) = p;    % update phase
                            Qn(i,6) = f;    % update freq
                            if listening == 1
                                Qn(i, 7) = zeta; % go blind
=======
    states(1,:,:) = Q; % Record initial state
    for t=2:T % Skip first timestep because the first state is the initial one
        flashesArrived = zeros(0,N+2); % Define the matrix dimensions before there is data. This is to avoid out of bounds errors.
        if delaysteps > 0 && t > delaysteps
            flashesArrived = flashes(flashes(:,end) == t-delaysteps,:);
        end
        Q = squeeze(states(t-1,:,:)); % Grab the last state and make it easier to work with.
        Qn = Q; % Qn is the working state, this Qn is volatile, Q does not change.
        for i=1:N
            if Qn(i,5) >= 1 % If evolution has reached 1, do a flash.
                [Qn, flashes] = doFlash(t, i, Qn, states, flashes, G, thau, zeta, delaysteps, alpha, beta, gamma, a, b, 1);
            end
            if delaysteps > 0 % If we are simulating connection delay, do this below
                neig = neighbors(G,i); % This piece of code identifies what neighbours fired exactly delaystep simulationsteps ago.
                for j = 1:size(neig,1)
                    flyIndex = neig(j);
                    flashesArrivedFromJ = flashesArrived(flashesArrived(:,end-1) == flyIndex, :);
                    for k = 1:size(flashesArrivedFromJ,1) % Receive the flashes that arrived this timestep
                        [p, f, listening] = calcResponse(Qn(i,5), Qn(i,6), thau, alpha, beta, gamma, a, b);
                        if Qn(i, 7) <= 0 % Don't do anything is the fly is recovering from already receiving a flash thoug                   
                            Qn(i,5) = p;
                            Qn(i,6) = f;
                            if listening == 1 % If it is ready to receive a flash, and listened to one, wait for zeta before you listen again
                                Qn(i, 7) = zeta;
>>>>>>> 13571b2cc19b6400b28677594248329d7c526a4d
                            end
                        end
                    end
                end
            end
<<<<<<< HEAD
            Qn(i,5) = Qn(i,5)+Qn(i,6)*dt;  % increase phase 
            Qn(i,7) = Qn(i,7)-Qn(i,6)*dt;  % decrease blind variable zeta
        end
        states(t,:,:) = Qn;     %update states
=======
            Qn(i,5) = Qn(i,5)+Qn(i,6)*dt; % Increment timers
            Qn(i,7) = Qn(i,7)-Qn(i,6)*dt;
        end
        states(t,:,:) = Qn; % Record final calculated state
>>>>>>> 13571b2cc19b6400b28677594248329d7c526a4d
    end
end

