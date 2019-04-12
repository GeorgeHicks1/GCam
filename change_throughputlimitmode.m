function change_throughputlimitmode(throughputlimitcheckbox,~)


        fig_settings=throughputlimitcheckbox.Parent.Parent.Parent;
        fig_camera=fig_settings.UserData.fig_camera;
        vid=fig_camera.UserData.vid;

        ThroughputLimit_slider=findobj(fig_settings,'Tag','ThroughputLimit_slider');
        ThroughputLimit_box=findobj(fig_settings,'Tag','ThroughputLimit_box');

        if throughputlimitcheckbox.Value==1
            ThroughputLimit_slider.Enable='on';
            ThroughputLimit_box.Enable='on';
            
            if isvalid(vid)
                vid_src=getselectedsource(vid);
                vid_src.DeviceLinkThroughputLimitMode='On';
                ThroughputLimit_slider.Value=vid_src.DeviceLinkThroughputLimit;
                ThroughputLimit_box.String=num2str(vid_src.DeviceLinkThroughputLimit);
                
            end
        elseif throughputlimitcheckbox.Value==0
            ThroughputLimit_slider.Enable='off';
            ThroughputLimit_box.Enable='off';
                        
            if isvalid(vid)
                vid_src=getselectedsource(vid);
                vid_src.DeviceLinkThroughputLimitMode='Off';
            end
            
        end
        
end