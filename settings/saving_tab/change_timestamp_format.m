function change_timestamp_format(timestamp_format_box,~)
    saving_tab=timestamp_format_box.Parent;
    fig_settings=saving_tab.Parent.Parent;
    
    timestamp_format_box=findobj('Parent',saving_tab,'Tag','timestamp_format');
    next_savename_box=findobj('Parent',saving_tab,'Tag','Savename_text');
    try
        next_savename_box.String=[datestr(now,timestamp_format_box.String) '.tiff'];
        timestamp_format_box.UserData.LastValidFormat=timestamp_format_box.String;
    catch
        disp('Time format invalid, returning to last valid format')
        timestamp_format_box.String=timestamp_format_box.UserData.LastValidFormat;
        next_savename_box.String=[datestr(now,timestamp_format_box.String) '.tiff'];
    end
    
end