function change_throughputlimit(throughputlimitbox,~)
        if ~isnan(str2double(throughputlimitbox.String))
            fig_settings=throughputlimitbox.Parent.Parent.Parent;
            fig_camera=fig_settings.UserData.fig_camera;
            vid=fig_camera.UserData.vid;
            
            ThroughputLimit_slider=findobj(fig_settings,'Tag','ThroughputLimit_slider');
            if isvalid(vid)
                vid_src=getselectedsource(vid);

                property_info=propinfo(vid_src,'DeviceLinkThroughputLimit');
                if strcmp(property_info.Constraint,'bounded')
                    %previosuly the value typed in the text box was divided
                    %by 8e-6. Not sure why
                    if str2double(throughputlimitbox.String)>property_info.ConstraintValue(2)
                        disp(['Throughout limit must be less than ' num2str(property_info.ConstraintValue(2))])
                    elseif str2double(throughputlimitbox.String)<property_info.ConstraintValue(1)
                        disp(['Throughout limit must be greater than ' num2str(property_info.ConstraintValue(1))])
                    else
                        ThroughputLimit_slider.Value=str2double(throughputlimitbox.String);
                        vid_src.DeviceLinkThroughputLimit=str2double(throughputlimitbox.String);
                        disp(['Stream set to ' num2str(vid_src.DeviceLinkThroughputLimit)])
                    end
                else
                    vid_src.DeviceLinkThroughputLimit=str2double(throughputlimitbox.String);
                    disp(['Stream set to ' num2str(vid_src.DeviceLinkThroughputLimit)])
                end
            end
    else
        msgbox('Please enter a valid number','Invalid number entered')
    end

end