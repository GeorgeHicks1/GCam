function change_auto_expose(AutoExpose_button,~)
    fig_settings=AutoExpose_button.Parent.Parent.Parent;
    fig_camera=fig_settings.UserData.fig_camera;
    vid=fig_camera.UserData.vid;
    
    if isvalid(vid)
        vid_src=getselectedsource(vid);
        Exposure_time=findobj(fig_settings,'Type','UIControl','Tag','Exposure_Time_box');
        vid_info=imaqhwinfo(vid);
        adaptor=vid_info.AdaptorName;
        switch adaptor
            case 'gentl'
                if AutoExpose_button.Value==1
                    vid_src.AEAGEnable = 'True';
                    pause_val=0.05;
                    pause(pause_val)
                    Exposure_time.String=num2str(vid_src.ExposureTime/1000);
                else
                    vid_src.AEAGEnable ='False';
                end
        end
    end
end