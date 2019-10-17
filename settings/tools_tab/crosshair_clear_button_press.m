function crosshair_clear_button_press(Crosshair_load_button,~)
    fig_settings=Crosshair_load_button.Parent.Parent.Parent;
    fig_camera=fig_settings.UserData.fig_camera;
    ax1=findobj(fig_camera,'Type','Axes');
    old_lines=findobj(ax1,'type','Line');
    delete(old_lines);
    
    if isfield(fig_camera.UserData,'crosshair_position')
        fig_camera.UserData=rmfield(fig_camera.UserData,'crosshair_position');
    end

end