function set_initial_settings(vid,adaptor)
        triggerconfig(vid,'manual')
        vid_src=getselectedsource(vid);
           if strcmp(adaptor,'gentl')
                vid_src.AEAGEnable = 'False';
                %vid_src.DeviceLinkThroughputLimit=1000;
           elseif strcmp(adaptor,'gige')
               vid_src.TriggerMode='off';
            end
    end