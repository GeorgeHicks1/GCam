function crosshair_load_button_press(Crosshair_load_button,~)
    fig_settings=Crosshair_load_button.Parent.Parent.Parent;
    fig_camera=fig_settings.UserData.fig_camera;
    ax1=findobj(fig_camera,'Type','Axes');
    filename=uigetfile('*.mat','Load crosshair');
    if filename~=0
        ch_file=load(filename);
        if isfield(ch_file,'crosshair_position')
            old_lines=findobj(ax1,'type','Line');
            delete(old_lines);
            plot_crosshair(ch_file.crosshair_position(1),ch_file.crosshair_position(2),ax1)
            fig_camera.UserData.crosshair_position=ch_file.crosshair_position;
        else
            msgbox('No crosshair data found in file, please try again')
        end
    end
end