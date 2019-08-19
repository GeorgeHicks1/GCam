function crosshair_save_button_press(Crosshair_save_button,~)
    fig_settings=Crosshair_save_button.Parent.Parent.Parent;
    fig_camera=fig_settings.UserData.fig_camera;
    ax1=findobj(fig_camera,'Type','Axes');
    if isfield(fig_camera.UserData,'crosshair_position')
        crosshair_position=fig_camera.UserData.crosshair_position;
        filename=uiputfile('*.mat','Save crosshair');
        if filename~=0
            save(filename,'crosshair_position')
        end
    else
        msgbox('No crosshair found, first click new crosshair')
    end
end