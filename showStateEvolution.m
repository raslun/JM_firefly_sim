function [ fig ] = showStateEvolution( states, dt, timescale, render )
%SHOWSTATEEVOLUTION Summary of this function goes here
%   Detailed explanation goes here
    framerate = 25;
    counter=0;
    T = size(states,1);
    displaystep = 1/framerate;
    step = ceil(timescale*displaystep/dt);
    minF = min(min(states(:,:,6)));
    maxF = max(max(states(:,:,6)));
    if render
    mkdir output showStateEvolution;    
    end
    fig = figure();
    figure(fig);
    
    subplot(1,2,1);
    title('Phase')
    subplot(1,2,2);
    title('Speed')
    
    for t=1:step:T
        suptitle(num2str(t*dt));
        figure(fig);
        subplot(1,2,1);
        plot([0,size(states,2)+1],[1,1],'k'); hold on;
        plot(states(t,:,5),'.'); hold off;
        ylim([0,1.1]);
        xlim([0,size(states,2)+1]);
        subplot(1,2,2);
        plot(states(t,:,6),'.');
        grid on;
        ylim([minF-0.5,maxF+0.5]);
        xlim([0,size(states,2)+1]);
        counter=counter+1;
        if render
            drawnow;
            print('-r400',['output/showStateEvolution/',sprintf('%05d',counter)], '-djpeg');
        else
            pause(displaystep);
        end
        if ~ishandle(fig)
            break;
        end
    end
end

