function settings_button_press(pushbutton,~)
    fig_camera=pushbutton.Parent;
    fig_settings=fig_camera.UserData.fig_settings;
    fig_settings.Visible='On';
    figure(fig_settings); %brings the figure to the front
    
end