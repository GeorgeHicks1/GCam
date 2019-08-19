function update_throughput_slider(throughput_slider,~)
        fig_settings=throughput_slider.Parent.Parent.Parent;
        fig_camera=fig_settings.UserData.fig_camera;
        vid=fig_camera.UserData.vid;
        throughputlimit_button=findobj(fig_settings,'Tag','ThroughputLimit_button');
        if throughputlimit_button.Value==1
            if isvalid(vid)
                    vid_src = getselectedsource(vid);


                    new_limit=throughput_slider.Value;
                    new_limit_rounded=round(new_limit);

                    throughput_slider.Value=new_limit_rounded;
                    throughputlimit_box=findobj(fig_settings,'Tag','ThroughputLimit_box');
                    throughputlimit_box.String=num2str(new_limit_rounded);

                    vid_src.DeviceLinkThroughputLimit=new_limit_rounded;
            elseif throughputlimit_button.Value==0
                disp('Cannot change throughput limit when throughput limit mode is set to off')
            end
        
        
        
end