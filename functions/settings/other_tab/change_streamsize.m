function change_streamsize(steamsize_box,~)

     if ~isnan(str2double(steamsize_box.String))
        fig_settings=steamsize_box.Parent.Parent.Parent;
        fig_camera=fig_settings.UserData.fig_camera;
        vid=fig_camera.UserData.vid;
        if isvalid(vid)
            vid_src = getselectedsource(vid);
            vid_info=imaqhwinfo(vid);
            adaptor=vid_info.AdaptorName;
            property_info=propinfo(vid_src,'StreamBytesPerSecond');
            if strcmp(property_info.Constraint,'bounded')
                if str2double(steamsize_box.String)/8e-6>property_info.ConstraintValue(2)
                    disp(['Bus load must be less than ' num2str(property_info.ConstraintValue(2)*8e-6)])
                elseif str2double(steamsize_box.String)/8e-6<property_info.ConstraintValue(1)
                    disp(['Bus load must be greater than ' num2str(property_info.ConstraintValue(1)*8e-6)])
                else
                    vid_src.StreamBytesPerSecond=str2double(steamsize_box.String)/8e-6;
                    disp(['Bus load set to ' num2str(vid_src.StreamBytesPerSecond*8e-6)])
                end
            else
                vid_src.StreamBytesPerSecond=str2double(steamsize_box.String)/8e-6;
                disp(['Bus load set to ' num2str(vid_src.StreamBytesPerSecond*8e-6)])
            end
        end
  
    else
        msgbox('Please enter a valid number','Invalid number entered')
    end

end