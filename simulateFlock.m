function [ states, flashes ] = simulateFlock( Q, G, time, dt, thau, zeta, delta, alpha, beta, gamma, a, b)
% 
% alpha,beta,gamma,a,b - ResponseCurve
% thau, zeta - blind periods
% time - total simtime
% dt - time per simstep
% G - graph
% Q - flies



    T = round(time/dt);  %number of simsteps
    N = size(Q,1);       %number of flies
    delaysteps = round(delta/dt);

    states = zeros([T, size(Q)]);       %init states
    flashes = zeros(0,N+2);             %init flashes

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
                            end
                        end
                    end
                end
            end
            Qn(i,5) = Qn(i,5)+Qn(i,6)*dt;  % increase phase 
            Qn(i,7) = Qn(i,7)-Qn(i,6)*dt;  % decrease blind variable zeta
        end
        states(t,:,:) = Qn;     %update states
    end
end

