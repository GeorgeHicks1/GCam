function change_exposure_units(ms_box,~)
    exposure_tab=ms_box.Parent;
    exposure_time_box=findobj(exposure_tab,'Tag','Exposure_Time_box');
    factor=10^(3*(exposure_time_box.UserData-ms_box.Value));
    exposure_time_box.String=num2str(str2double(exposure_time_box.String)*10^(3*(exposure_time_box.UserData-ms_box.Value)));
    exposure_time_box.UserData=ms_box.Value;
    



end