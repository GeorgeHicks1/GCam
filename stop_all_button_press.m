function stop_all_button_press(run_all_btn,~)
    fig_main=run_all_btn.Parent;
    Camera_table=findobj(fig_main,'Tag','Camera_table');
    if  sum([Camera_table.Data{:,4}])==0
        disp('Warning, no cameras active. Activate one or more cameras before clicking this button')
    end
 
        for i=1:size(Camera_table.Data,1)
            if Camera_table.Data{i,4}%if camera is active
                
                fig_camera=fig_main.UserData.fig_camera{i};
                Run_button=findobj(fig_camera,'Type','UIControl','Style','togglebutton','Tag','Run_button');
                if Run_button.Value==1  %and also not running
                    Run_button.Value=0;
                    run_button_press(Run_button)
                end

            end
        end


end