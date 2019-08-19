function autosave_all_off(autosave_all_btn,~)
    fig100=autosave_all_btn.Parent;
    camera_table=findobj(fig100,'Tag','Camera_table');
    if  sum([camera_table.Data{:,4}])==0
        disp('Warning, no cameras active. Activate one or more cameras before clicking this box')
        %autosave_all_btn.Value=0;
    end
    
   
        for i=1:size(camera_table.Data,1)
            if camera_table.Data{i,4} %if camera is active
                fig_camera=fig100.UserData.fig_camera{i};
                fig_settings=fig_camera.UserData.fig_settings;
                autosave_button=findobj(fig_settings,'Style','Checkbox','Tag','autosave_button');
                autosave_button.Value=0;
            end
        end
end