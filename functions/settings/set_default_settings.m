function set_default_settings(vid,fig_camera,adaptor)
        vid_src=getselectedsource(vid);
        vid.FramesPerTrigger=1;
        vid.TriggerRepeat = Inf;
        vid.FramesAcquiredFcnCount=1;
        vid.FramesAcquiredFcn={@show_image,fig_camera};
        
           if strcmp(adaptor,'gentl')
                  try
                     vid_src.DeviceLinkThroughputLimitMode='On';
                  catch
                      vid_src.DeviceLinkThroughputLimitMode='Yes';
                  end
           end
    end