function set_default_settings(vid,fig_camera,adaptor)
        vid_src=getselectedsource(vid);
        vid.FramesPerTrigger=1;
        vid.TriggerRepeat = Inf;
        vid.FramesAcquiredFcnCount=1;
        vid.FramesAcquiredFcn={@show_image,fig_camera};
        
           if strcmp(adaptor,'gentl')
                %vid_src.LineSelector= 'Line2';
                  try
                     vid_src.DeviceLinkThroughputLimitMode='On';
                      disp('On')
                  catch
                      vid_src.DeviceLinkThroughputLimitMode='Yes';
                      disp('Yes')
                  end
           end
    end