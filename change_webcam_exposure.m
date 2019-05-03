function change_webcam_exposure(vid_src,Exposure_tab)
    vid_src_info=get(vid_src);
    Exposure_Time_box=findobj(Exposure_tab,'Type','UIControl','Tag','Exposure_Time_box');

     if isfield(vid_src_info,'Exposure')
        %camera exposure time uses 2^(exposure) s
        Exposure_Time_box.String=num2str((2^double(vid_src.Exposure))*1e3);
    else
        %if the camera doesn't have the exposure time option
        %then we disable all the settings window objects
        %relating to exposure time
        Exposure_Time_box.Enable='off';
        ms_box=findobj('Parent',Exposure_tab,'Tag','ms_box');
        ms_box.Enable='off';
        Exposure_Time_text=findobj('Parent',Exposure_tab,'Tag','Exposure_Time_text');
        Exposure_Time_text.Enable='off';
        auto_expose_button=findobj('Parent',Exposure_tab,'Tag','auto_expose_button');
        auto_expose_button.Enable='off';


    end