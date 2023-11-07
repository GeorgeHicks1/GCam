function set_initial_settings(vid,adaptor)
        triggerconfig(vid,'manual')
        vid_src=getselectedsource(vid);
           if strcmp(adaptor,'gentl')
               vid_src_fields=get(vid_src);
               if isfield(vid_src_fields,'AEAGEnable')
                   vid_src.AEAGEnable = 'False';
               elseif isfield(vid_src_fields,'GainAuto')
                   vid_src.GainAuto = 'Off';
                %vid_src.DeviceLinkThroughputLimit=1000;
           elseif strcmp(adaptor,'gige')
               vid_src.TriggerMode='off';
            end
    end