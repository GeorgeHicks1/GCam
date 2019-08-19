function save_last_image_button_press(Autosave_last_button,~)
    fig_settings=Autosave_last_button.Parent.Parent.Parent;
    fig_camera=fig_settings.UserData.fig_camera;
    ax1=findobj(fig_camera,'Type','Axes');
    filepath_box=findobj(fig_settings,'Type','UIControl','Style','Edit','Tag','filepath_box');
    current_image=findobj(ax1,'type','Image');
    image_frame=current_image.CData;
    
    [new_filename,new_filepath]=uiputfile(fullfile(filepath_box.String,'Reference.tiff'),'Save file name');
    
    if new_filename~=0
        imwrite(image_frame,fullfile(new_filepath,new_filename),'Compression','none')
    	disp([fullfile(new_filepath,new_filename) ' saved'])
    end
end