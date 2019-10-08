function rotate_image(rotate_listbox,~)
    fig_settings=rotate_listbox.Parent.Parent.Parent;
    fig_camera=fig_settings.UserData.fig_camera;
    ax1=findobj(fig_camera,'Type','Axes');
    rotation_angle=rotate_listbox.String{rotate_listbox.Value};
    view(ax1,str2double(rotation_angle),90)
end