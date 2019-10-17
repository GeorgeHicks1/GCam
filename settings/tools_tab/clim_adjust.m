function clim_adjust(Clim_box,~)
    if ~isnan(str2double(Clim_box.String))
        fig_settings=Clim_box.Parent.Parent.Parent;
        fig_camera=fig_settings.UserData.fig_camera;
        ax1 = findobj(fig_camera,'type','axes');
        ax1.CLim(Clim_box.UserData.MinMax)=str2double(Clim_box.String);
    else
        msgbox('Please enter a valid number','Invalid number entered')
    end
end