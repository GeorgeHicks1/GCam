function autosave_last_image_button_press(Autosave_last_button,~)
    fig_settings=Autosave_last_button.Parent.Parent.Parent;
    fig_camera=fig_settings.UserData.fig_camera;
    ax1=findobj(fig_camera,'Type','Axes');
    
    filepath_box=findobj(fig_settings,'Type','UIControl','Tag','filepath_box');
    SaveName=findobj(fig_settings,'Type','UIControl','Style','text','Tag','Savename_text');
    timestamp_format_box=findobj(fig_settings,'Type','UIControl','Tag','timestamp_format'); 

    current_image=findobj(ax1,'type','Image');
    image_frame=current_image.CData;
    
    Autosave_style=findobj(fig_settings,'Type','UIControl','Tag','Autosave_style');
    
    if Autosave_style.Value==1
        %save with timestamp
        timestamp=fig_camera.UserData.PreviousTriggerTime;
        save_filepath=fullfile(filepath_box.String,[datestr(timestamp,timestamp_format_box.String) '.tiff']);
    elseif Autosave_style.Value==2
        %save with prefix and number
        AutoSave_number=findobj(fig_settings,'Type','UIControl','Style','edit','Tag','autosave_number');
        save_filepath=fullfile(filepath_box.String,SaveName.String);
        AutoSave_number.String=num2str(str2double(AutoSave_number.String)+1);
        UpdateSavename(AutoSave_number,0);
    end
    
    save_image(image_frame,save_filepath)
    

end