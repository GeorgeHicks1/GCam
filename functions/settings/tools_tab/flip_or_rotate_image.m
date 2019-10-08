function flip_or_rotate_image(flip_or_rotate_listbox,~)
    fig_settings=flip_or_rotate_listbox.Parent.Parent.Parent;
    rotate_listbox=findobj(fig_settings,'Tag','rotation_listbox');
    flip_listbox=findobj(fig_settings,'Tag','flip_checkbox');
    rotation_angle=rotate_listbox.String{rotate_listbox.Value};
    fig_camera=fig_settings.UserData.fig_camera;
    ax1=findobj(fig_camera,'Type','Axes');
    
    
    view(ax1,str2double(rotation_angle),flip_listbox.Value*180+90)
end