function run_button_press(Run_button,~)
    fig_camera=Run_button.Parent;
    fig_settings=fig_camera.UserData.fig_settings;
    Trigger_listbox=findobj(fig_settings,'Type','UIControl','Tag','Trigger_Listbox');
    
    fig_main=findobj('Type','Figure','Name','G cam Camera Select');
    CamID=fig_camera.UserData.CamID;
    Camera_table=findobj(fig_main,'Tag','Camera_table');
    
    if Camera_table.Data{CamID,4}
        vid=fig_camera.UserData.vid;
        vid_info=imaqhwinfo(vid);
        adaptor=vid_info.AdaptorName;
        
        caxis_auto_button=findobj(fig_settings,'Type','UIControl','Tag','caxis_auto_button');
        Caxis_min_box=findobj(fig_settings,'Type','UIControl','Tag','Caxis_min_box');
        Caxis_max_box=findobj(fig_settings,'Type','UIControl','Tag','Caxis_max_box');
        
        if Run_button.Value==1
            if vid.NumberofBands==1
                switch adaptor
                    case 'gige'
                        vid_format=vid.VideoFormat;
                        bit_depth=str2double(vid_format(regexp(vid_format,'\d')));
                        caxis_auto_button.Value=0;
                        Caxis_min_box.String=num2str(0);
                        Caxis_max_box.String=num2str(2.^bit_depth-1);
                    case 'gentl'
                        caxis_auto_button.Value=1;
            end
         end

            
            switch Trigger_listbox.String{Trigger_listbox.Value}
                case 'Free run'
                    
                    displayed_data = findall(fig_camera,'type','image');
                    cam_ax=findobj(fig_camera,'Type','Axes');
                    disp('Starting preview, ignore following warning')
                    preview(vid,displayed_data)
                    Run_button.BackgroundColor='green';
                    fig_camera.UserData.frame_count.String='';
                    
                case 'Software'
                    %caxis_lock_button.Value=0;
                    start(vid);
                    Run_button.BackgroundColor='green';
                    fig_camera.UserData.frame_count.String='0';
                case 'Software pulsed'
                    %caxis_lock_button.Value=0;
                    start(vid);
                    Run_button.BackgroundColor='green';
                    fig_camera.UserData.frame_count.String='0';
                    Acquisition_Frequency_box=findobj(fig_settings,'Type','UIControl','Style','Edit','Tag','Acquisition_Frequency');
                    Acquisition_Freq=str2double(Acquisition_Frequency_box.String);
                    Acquisition_Period=round(1/Acquisition_Freq,3);
                    Exposure_Time_box=findobj(fig_settings,'Type','UIControl','Style','Edit','Tag','Exposure_Time_box');
                    exposure_time=str2double(Exposure_Time_box.String);
                    if Acquisition_Period<exposure_time*1e-3/0.93
                        disp(['Rep. Rate too high for exposure time. Exposure time is ' Exposure_Time_box.String 'ms, therefore rep. rate must be less than ' num2str(1e3*0.93/exposure_time) 'Hz.'])
                        Run_button.Value=0;
                        Run_button.BackgroundColor='red';
                        stop(vid)
                    else
                        pulsed_triggers{fig_camera.Number}=timer('ExecutionMode','fixedRate','Period',Acquisition_Period,'Name',['pulsed_trigger_timer' num2str(fig_camera.Number)],'TimerFcn',{@my_trigger, vid});
                        start(pulsed_triggers{fig_camera.Number})
                    end
                case 'Hardware'
                    %caxis_lock_button.Value=0;
                    fig_camera.UserData.frame_count.String='0';
                    start(vid);
                    
                    Run_button.BackgroundColor='green';
                    
            end


        disp(['Acqusition started for ' Camera_table.Data{CamID,3}])
        elseif Run_button.Value==0
            switch Trigger_listbox.String{Trigger_listbox.Value}
                case 'Free run'
                    stoppreview(vid)
                    Run_button.BackgroundColor='red';
                case 'Software'
                    stop(vid)
                    Run_button.BackgroundColor='red';
                case 'Software pulsed'
                    pulsed_triggers=timerfind('Name',['pulsed_trigger_timer' num2str(fig_camera.Number)]);
                    stop(pulsed_triggers)
                    delete(pulsed_triggers)
                    stop(vid)
                    while vid.FramesAvailable>0 %get rid of the excess frame
                        eventData.Data.AbsTime=now;
                        show_image(vid,eventData,fig_camera)
                    end
                    Run_button.BackgroundColor='red';
                case 'Hardware'
                    stop(vid)
                    Run_button.BackgroundColor='red';
            end
            disp(['Acqusition stopped for ' Camera_table.Data{CamID,3}])
        end
        fig_camera.UserData.vid=vid;
    else
        disp([Camera_table.Data{CamID,3} ' is not active'])
        Run_button.Value=1-Run_button.Value;
    end
end