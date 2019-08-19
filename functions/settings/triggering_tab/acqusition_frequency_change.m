function acqusition_frequency_change(acquisition_frequency_box,~)
fig_settings=acquisition_frequency_box.Parent.Parent.Parent;
fig_camera=fig_settings.UserData.fig_camera;
vid=fig_camera.UserData.vid;
     if isrunning(vid)
        pulsed_triggers=timerfind('Name',['pulsed_trigger_timer' num2str(fig_camera.Number)]);
        if ~isempty(pulsed_triggers)
            stop(pulsed_triggers)
            delete(pulsed_triggers)
        end
        stop(vid)
        Run_button=findobj(fig_camera,'Type','UIControl','Tag','Run_button');
        Run_button.Value=0;
        Run_button.BackgroundColor='red';
     end
end