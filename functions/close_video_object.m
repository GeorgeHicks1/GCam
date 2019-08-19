function close_video_object(fig_main,fig_camera)
Camera_table=findobj(fig_main,'Tag','Camera_table');
Camera_table.Data{fig_camera.UserData.CamID,4}=false;
pulsed_triggers=timerfind('Name',['pulsed_trigger_timer' num2str(fig_camera.Number)]);
if ~isempty(pulsed_triggers)
    triggers_were_running=1;
    stop(pulsed_triggers)
    delete(pulsed_triggers)
end
if isfield(fig_camera.UserData,'vid')
    vid=fig_camera.UserData.vid;
    if isvalid(vid)
        if isrunning(vid)
          stop(vid)
          disp('Acqusition Stopped')
        end
        Run_button=findobj(fig_camera,'Tag','Run_button');
        Run_button.Value=0;
        Run_button.BackgroundColor='red';
        delete(vid)
    end
 end
