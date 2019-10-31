function autosave_last_image_button_press(Autosave_last_button,~)
    fig_settings=Autosave_last_button.Parent.Parent.Parent;
    fig_camera=fig_settings.UserData.fig_camera;
    ax1=findobj(fig_camera,'Type','Axes');
    filepath_box=findobj(fig_settings,'Type','UIControl','Tag','filepath_box');
    AutoSave_number=findobj(fig_settings,'Type','UIControl','Tag','autosave_number');
    current_image=findobj(ax1,'type','Image');
    image_frame=current_image.CData;
    imwrite(image_frame,fullfile(filepath_box.String,['Shot' num2str(str2double(AutoSave_number.String),'%03d') '.tiff']),'Compression','none')
    disp(['Shot' num2str(str2double(AutoSave_number.String),'%03d') '.tiff saved'])
    AutoSave_number.String=num2str(str2double(AutoSave_number.String)+1);
end