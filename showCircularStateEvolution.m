function [ fig ] = showCircularStateEvolution( states, dt, timescale, render )
%SHOWSTATEEVOLUTION Summary of this function goes here
%   Detailed explanation goes here
    T = size(states,1);
    counter=0;
    fig = figure();
    figure(fig);
    if render
        mkdir output showCircularStateEvolution;
    end
    
    maxF = max(max(states(:,:,6)));
    minF = min(min(states(:,:,6)));
    meanF = mean(mean(states(:,:,6)));
    framerate=25;
    displaystep = 1/framerate;
    step = ceil(timescale*displaystep/dt);
    maxPlotRadius = 1+meanF-minF;
    for t=1:step:T
        polarplot([2*pi, 2*pi],[0,maxPlotRadius],'k'); hold on;
        polarplot(2*pi*states(t,:,5),1+meanF-states(t,:,6), '.'); hold off;
        rlim([0,maxPlotRadius]);
        title(['T = ', num2str(t*dt)]);
        counter=counter+1;
        if render
            drawnow;
            print('-r400',['output/showCircularStateEvolution/',sprintf('%05d',counter)], '-djpeg');
        else
            pause(dt/timescale);
        end
        if ~ishandle(fig)
            break;
        end
    end
end

