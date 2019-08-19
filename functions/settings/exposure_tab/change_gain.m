function change_gain(gain_box,~)

             if ~isnan(str2double(gain_box.String))
                fig_settings=gain_box.Parent.Parent.Parent;
                fig_camera=fig_settings.UserData.fig_camera;
                vid=fig_camera.UserData.vid;
                if isvalid(vid)
                    vid_src = getselectedsource(vid);
                    vid_info=imaqhwinfo(vid);
                    adaptor=vid_info.AdaptorName;
                    property_info=propinfo(vid_src,'Gain');
                    if strcmp(property_info.Constraint,'bounded')
                        if str2double(gain_box.String)>property_info.ConstraintValue(2)
                            disp(['Gain value must be less than ' num2str(property_info.ConstraintValue(2))])
                        elseif str2double(gain_box.String)<property_info.ConstraintValue(1)
                            disp(['Gain value must be greater than ' num2str(property_info.ConstraintValue(1))])
                        else
                            vid_src.Gain=str2double(gain_box.String);
                            disp(['Gain set to ' num2str(vid_src.Gain)])
                        end
                    else
                        vid_src.Gain=str2double(gain_box.String);
                        disp(['Gain set to ' num2str(vid_src.Gain)])
                    end
                end

            else
                msgbox('Please enter a valid number','Invalid number entered')
                end
end