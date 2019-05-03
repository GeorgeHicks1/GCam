function change_all_triggers(all_trigger_list_box,~)
    %fig100=all_trigger_list_box.Parent;
    fig_main=all_trigger_list_box.Parent;
    Camera_table=findobj(fig_main,'Tag','Camera_table');
    if  sum([Camera_table.Data{:,4}])==0
        disp('Warning, no cameras active. Activate one or more cameras before clicking this button')
    end
    
   
        for i=1:size(Camera_table.Data,1)
            if Camera_table.Data{i,4} %if camera is active
                fig_camera=fig_main.UserData.fig_camera{i};
                fig_settings=fig_camera.UserData.fig_settings;
                Trigger_Listbox=findobj(fig_settings,'Type','UIControl','Tag','Trigger_Listbox');
                Trigger_Listbox.Value=all_trigger_list_box.Value;
                change_hardware_trigger(Trigger_Listbox)
            end
        end
end