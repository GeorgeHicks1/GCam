function change_format(format_box,~)
    fig_settings=format_box.Parent.Parent.Parent;
    fig_camera=fig_settings.UserData.fig_camera;
    vid=fig_camera.UserData.vid;
    Run_button=fig_camera.Children(3);
    if isvalid(vid)
        vid_info=imaqhwinfo(vid);

         if isrunning(vid)
            pulsed_triggers=timerfind('Name',['pulsed_trigger_timer' num2str(fig_camera.Number)]);
            if ~isempty(pulsed_triggers)
                triggers_were_running=1;
                stop(pulsed_triggers)
                delete(pulsed_triggers)
            end
            stop(vid)
            Run_button.Value=0;
            Run_button.BackgroundColor='red';
         else
             if Run_button.Value==1
                stoppreview(vid)
                Run_button.Value=0;
                Run_button.BackgroundColor='red';
             end
         end
        adaptor=vid_info.AdaptorName;
        device_ID=vid.DeviceID;
        delete(vid)
        clear('vid')
        vid = videoinput(vid_info.AdaptorName, device_ID,format_box.String{format_box.Value});
        vid_src = getselectedsource(vid);
        %set a few defualt settings
        set_default_settings(vid,fig_camera,adaptor)
                Exposure_Time_box=findobj(fig_settings,'Type','UIControl','Tag','Exposure_Time_box');
                
                if strcmp(adaptor,'gentl')
                    Exposure_Time_box.String=num2str(vid_src.ExposureTime*1e-3);
                    ThroughputLimit_box=findobj(fig_settings,'Type','UIControl','Tag','ThroughputLimit_box');
                    ThroughputLimit_box.String=num2str(vid_src.DeviceLinkThroughputLimit);
                elseif strcmp(adaptor,'qimaging')
                    Exposure_Time_box.String=num2str(vid_src.Exposure*1e3);
                elseif strcmp(adaptor,'winvideo')
                    Exposure_Time_box.String=num2str((2^double(vid_src.Exposure))*1e3);
                elseif strcmp(adaptor,'gige')
                    Exposure_Time_box.String=vid_src.ExposureTimeAbs*1e-3;
                end
                fig_camera.UserData.vid=vid;
                Trigger_listbox=findobj(fig_settings,'Type','UIControl','Tag','Trigger_Listbox');
                change_hardware_trigger(Trigger_listbox,0);
    end
end