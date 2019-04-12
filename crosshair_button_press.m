function crosshair_button_press(crosshair_button,~)
    fig_settings=crosshair_button.Parent.Parent.Parent;
    fig_camera=fig_settings.UserData.fig_camera;
    allAxesInFigure = findall(fig_camera,'type','axes');
    ax1=allAxesInFigure(1);
    old_lines=findobj(ax1,'type','Line');
    delete(old_lines);
    axes(ax1);
    %check to see if zoom mode is enabled, we need to disable it while the
    %plot hair is chosen (part of ginputc)
    zoom_state=zoom(fig_camera);
    if strcmp(zoom_state.Enable,'on')
        zoom_state.Enable='off';
        old_zoom_state='on';
    else
        old_zoom_state='off';
    end
    [crosshair_x,crosshair_y]=ginputc(1,'Color','r');
    zoom_state.Enable=old_zoom_state;
    crosshair_position=[crosshair_x,crosshair_y];
    fig_camera.UserData.crosshair_position=crosshair_position;
    plot_crosshair(crosshair_x,crosshair_y,ax1);
end