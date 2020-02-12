% Code for creating a GIF

%% initialize Figure
%--------------------------------------------------------------------------
fig_gif = figure;
fig_gif.Position = [100 100 900 500]; % set size of figure
filename = 'gif_figure.fig'; % set gif filename

N_frames = 20; % set number of frames

for n = 1:N_frames

    drawnow
    frame = getframe(fig_gif);
    im{n} = frame2im(frame);
    [A,map] = rgb2ind(im{n},256);
    if n == 1
        imwrite(A,map,filename,'gif','Loopcount',inf,'DelayTime',.2);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',.2);
    end
end

for n = 1:N_frames
    [A,map] = rgb2ind(im{n},256);
    if n == 1
        imwrite(A,map,filename,'gif','Loopcount',inf,'DelayTime',.2);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',.2);
    end
end

        
        
        
        
        