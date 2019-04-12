function software_trigger_all(software_trigger_all_button,~)
    fig_main=software_trigger_all_button.Parent;
    Camera_table=findobj(fig_main,'Tag','Camera_table');
    if  sum([Camera_table.Data{:,4}])==0
        disp('Warning, no cameras active. Activate one or more cameras before clicking this box')
        %autosave_all_btn.Value=0;
    end
    
   
        for i=1:size(Camera_table.Data,1)
            if Camera_table.Data{i,4} %if camera is active
                fig_camera=fig_main.UserData.fig_camera{i};
                fig_settings=fig_camera.UserData.fig_settings;
                
                Trigger_Listbox=findobj(fig_settings,'Tag','Trigger_Listbox');
                vid=fig_camera.UserData.vid;
                if isrunning(vid)
                    if Trigger_Listbox.Value==1
                        trigger(vid)
                    end
                end
                    
            end
        end
end