function run_all_button_press(run_all_btn,~)
    fig_main=run_all_btn.Parent;
    camera_table=fig_main.Children(2);
    if  sum([camera_table.Data{:,4}])==0
        disp('Warning, no cameras active. Activate one or more cameras before clicking this button')
    end
    
 
        for i=1:size(camera_table.Data,1) %loop over table of cameras
            if camera_table.Data{i,4} %if camera is active
                fig_camera=fig_main.UserData.fig_camera{i};
                Run_button=findobj(fig_camera,'Type','UIControl','Tag','Run_button');
                if Run_button.Value==0 % and also not running
                    Run_button.Value=1;
                    run_button_press(Run_button)
                end
            end
        end
 
end