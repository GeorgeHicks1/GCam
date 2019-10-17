function trigger_button_press(~,~,fig_camera)
    vid=fig_camera.UserData.vid;
    if isvalid(vid)
        if isrunning(vid)
            my_trigger(0,0,vid)
        else
            disp('Warning, camera is not running')
        end
    else
        disp('Warning, camera is not active')
    end
end