function figure_resize_function(fig_camera,~)
    if ~fig_camera.UserData.FullScreenMode
        fig_camera.Units='pixels';
        fig_camera.UserData.figure_position=fig_camera.Position;
    end
end