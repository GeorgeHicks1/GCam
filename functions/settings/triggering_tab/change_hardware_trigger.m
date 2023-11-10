function change_hardware_trigger(Trigger_listbox,~)
    Triggering_tab=Trigger_listbox.Parent;
    fig_settings=Triggering_tab.Parent.Parent; %find the settings figure by going up from listbox>triggering tab>tab group>figure
    fig_camera=fig_settings.UserData.fig_camera;
    vid=fig_camera.UserData.vid;
    stoppreview(vid)
    Run_button=findobj(fig_camera,'Type','UIControl','Tag','Run_button');
    Run_button.Value=0;
    Run_button.BackgroundColor='red';
    
    AquisitionFrequencyBox=findobj('Parent',Triggering_tab,'Tag','Acquisition_Frequency');
    SoftwareTriggerButton=findobj('Parent',Triggering_tab,'Tag','TriggerButton');
    ToolsTab=findobj(fig_settings, 'Title', 'Tools');
    Caxis_min=findobj('Parent',ToolsTab,'Tag','Caxis_min_box');
    Caxis_max=findobj('Parent',ToolsTab,'Tag','Caxis_max_box');
    Caxis_auto_button=findobj('Parent',ToolsTab,'Tag','caxis_auto_button');
    
    
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
                AquisitionFrequencyBox.Enable='Off';
                SoftwareTriggerButton.Enable='On';
                Caxis_min.Enable='On';
                Caxis_max.Enable='On';
                Caxis_auto_button.Enable='On';
                
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
                AquisitionFrequencyBox.Enable='On';
                SoftwareTriggerButton.Enable='Off';
                Caxis_min.Enable='On';
                Caxis_max.Enable='On';
                Caxis_auto_button.Enable='On';
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
                AquisitionFrequencyBox.Enable='Off';
                SoftwareTriggerButton.Enable='Off';
                Caxis_min.Enable='On';
                Caxis_max.Enable='On';
                Caxis_auto_button.Enable='On';
                fig_camera.UserData.frame_count.String='0';
                if strcmp(adaptor,'gentl')
                    vid_src.TriggerMode='On';
                    vid_src.TriggerSource='Line0';
                    triggerconfig(vid,'hardware');
                elseif strcmp(adaptor,'qimaging')
                    triggerconfig(vid, 'hardware', 'risingEdge', 'TTL')
                elseif strcmp(adaptor,'gige')
                    triggerconfig(vid,'hardware');
                    vid_src.TriggerMode='On';
                    vid_src.TriggerSource='Line1';
                end
            case 'Free run'
                %turn off triggering
                triggerconfig(vid,'immediate');
                vid_src.TriggerMode='Off';
                
                %disable GUI features that aren't compatible
                SoftwareTriggerButton.Enable='Off';
                AquisitionFrequencyBox.Enable='Off';
                Caxis_min.Enable='Off';
                Caxis_max.Enable='Off';
                Caxis_auto_button.Enable='Off';
                
                %remove frame counter
                fig_camera.UserData.frame_count.String='';
        end
    end
    

        
   
end