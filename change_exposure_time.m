function change_exposure_time(exposure_time_box,~)
         if ~isnan(str2double(exposure_time_box.String))
            exposure_tab=exposure_time_box.Parent;
            fig_settings=exposure_tab.Parent.Parent;
            fig_camera=fig_settings.UserData.fig_camera;
            vid=fig_camera.UserData.vid;
            
            ms_box=findobj(exposure_tab,'Tag','ms_box');
            bandwidth_limit_box=findobj(fig_settings,'Tag','ThroughputLimit_box');
            
            
            if isvalid(vid)
                vid_src = getselectedsource(vid);
                vid_info=imaqhwinfo(vid);
                adaptor=vid_info.AdaptorName;
                if strcmp(adaptor,'gentl')
                    property_info=propinfo(vid_src,'ExposureTime');
                    %camera exposure time uses us units
                    exposure_units_factor=10^(3*(ms_box.Value-1));
                    requested_exposure=str2double(exposure_time_box.String)*exposure_units_factor;
                    vid_src.ExposureTime=requested_exposure;
                    real_exposure=double(vid_src.ExposureTime);
                    if str2double(bandwidth_limit_box.String)<400 && abs(requested_exposure-real_exposure)>20
                        disp('Note: with low bandwidth limits (<400), the exposure times permissible are spaced further apart')
                    end
                    disp(['Exposure time set to ' num2str(double(vid_src.ExposureTime)/exposure_units_factor) ' ' ms_box.String{ms_box.Value}])
                    exposure_time_box.String=num2str(double(vid_src.ExposureTime)/exposure_units_factor);
                elseif strcmp(adaptor,'qimaging')
                    %camera exposure time uses s units
                    exposure_units_factor=10^(3*(1-ms_box.Value));
                    vid_src.Exposure=str2double(exposure_time_box.String)*exposure_units_factor;
                    disp(['Exposure time set to ' num2str(vid_src.Exposure/exposure_units_factor) ' ' ms_box.String{ms_box.Value}]);
                    exposure_time_box.String=num2str(double(vid_src.ExposureTime)/exposure_units_factor);
                elseif strcmp(adaptor,'winvideo')
                    %camera exposure time uses s units
                    exposure_units_factor=10^(3*(1-ms_box.Value));
                    requested_exposure=str2double(exposure_time_box.String)*exposure_units_factor;
                    closest_log2_integer=round(log2(requested_exposure));
                    if closest_log2_integer<-8
                        closest_log2_integer=-8;
                    elseif closest_log2_integer>-3
                        closest_log2_integer=-3;
                    end
                    vid_src.Exposure=closest_log2_integer;
                    disp(['Exposure time set to ' num2str((2^double(vid_src.Exposure))/exposure_units_factor) ' ' ms_box.String{ms_box.Value}]);
                    exposure_time_box.String=num2str((2^double(vid_src.Exposure))/exposure_units_factor);

                elseif strcmp(adaptor,'gige')
                    %camera exposure time uses us units
                    exposure_units_factor=10^(3*(ms_box.Value-1));
                    vid_src.ExposureTimeAbs=str2double(exposure_time_box.String)*exposure_units_factor;
                    disp(['Exposure time set to ' num2str(vid_src.ExposureTimeAbs/exposure_units_factor) ' ' ms_box.String{ms_box.Value}]);
                    exposure_time_box.String=num2str(double(vid_src.ExposureTimeAbs)/exposure_units_factor);

                end
            end
    else
        msgbox('Please enter a valid number','Invalid number entered')
         end
end