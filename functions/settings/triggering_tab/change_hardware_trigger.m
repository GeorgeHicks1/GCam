function change_hardware_trigger(Trigger_listbox,~)
    fig_settings=Trigger_listbox.Parent.Parent.Parent; %find the settings figure by going up from listbox>triggering tab>tab group>figure
    fig_camera=fig_settings.UserData.fig_camera;
    vid=fig_camera.UserData.vid;
    stoppreview(vid)
    Run_button=findobj(fig_camera,'Type','UIControl','Tag','Run_button');
    Run_button.Value=0;
    Run_button.BackgroundColor='red';
    if isvalid(vid)
        if isrunning(vid)
            pulsed_triggers=timerfind('Name',['pulsed_trigger_timer' num2str(fig_camera.Number)]);
            if ~isempty(pulsed_triggers)
                stop(pulsed_triggers)
                delete(pulsed_triggers)
            end
            stop(vid)
        end
        
        vid_src=getselectedsource(vid);
        Trigger_listbox=findobj(fig_settings,'Type','UIControl','Tag','Trigger_Listbox');

        vid_info=imaqhwinfo(vid);
        adaptor=vid_info.AdaptorName;
        switch Trigger_listbox.String{Trigger_listbox.Value}
            case 'Software'
                fig_camera.UserData.frame_count.String='0';
                if strcmp(adaptor,'gentl')
                    vid_src.TriggerMode='Off';
                    triggerconfig(vid,'manual');
                elseif strcmp(adaptor,'qimaging')
                    triggerconfig(vid, 'manual', 'none', 'none')
                elseif strcmp(adaptor,'winvideo')
                    triggerconfig(vid,'manual');
                elseif strcmp(adaptor,'gige')
                    vid_src.TriggerMode='Off';
                    triggerconfig(vid,'manual');
                end
            case 'Software pulsed'
                fig_camera.UserData.frame_count.String='0';
                if strcmp(adaptor,'gentl')
                    vid_src.TriggerMode='Off';
                    triggerconfig(vid,'manual');
                elseif strcmp(adaptor,'qimaging')
                    triggerconfig(vid, 'manual', 'none', 'none')
                elseif strcmp(adaptor,'winvideo')
                    triggerconfig(vid,'manual');
                elseif strcmp(adaptor,'gige')
                    vid_src.TriggerMode='Off';
                    triggerconfig(vid,'manual');
                end
            case 'Hardware'
                fig_camera.UserData.frame_count.String='0';
                if strcmp(adaptor,'gentl')
                    vid_src.TriggerMode='On';
                    triggerconfig(vid,'hardware');
                elseif strcmp(adaptor,'qimaging')
                    triggerconfig(vid, 'hardware', 'risingEdge', 'TTL')
                elseif strcmp(adaptor,'gige')
                    triggerconfig(vid,'hardware');
                    vid_src.TriggerMode='On';
                    vid_src.TriggerSource='Line1';
                end
            case 'Free run'
                fig_camera.UserData.frame_count.String='';
        end
    end
    

        
   
end