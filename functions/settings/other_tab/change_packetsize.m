function change_packetsize(packetsize_box,~)

         if ~isnan(str2double(packetsize_box.String))
             fig_settings=packetsize_box.Parent.Parent.Parent;
             fig_camera=fig_settings.UserData.fig_camera;
             vid=fig_camera.UserData.vid;
            if isvalid(vid)
                vid_src = getselectedsource(vid);
                vid_info=imaqhwinfo(vid);
                adaptor=vid_info.AdaptorName;
                property_info=propinfo(vid_src,'PacketSize');
                ConstraintValue=[256 32768]; %set my own constraints here as it doesn't seem to be constrained by the camera
                    if str2double(packetsize_box.String)>ConstraintValue(2)
                        disp(['Packet size must be less than or equal to ' num2str(ConstraintValue(2))])
                    elseif str2double(packetsize_box.String)<ConstraintValue(1)
                        disp(['Packet size must be greater than or equal to ' num2str(ConstraintValue(1))])
                    else
                        vid_src.PacketSize=str2double(packetsize_box.String);
                        disp(['Packet size set to ' num2str(vid_src.PacketSize)])
                    end
            end

        else
            msgbox('Please enter a valid number','Invalid number entered')
         end
        

end