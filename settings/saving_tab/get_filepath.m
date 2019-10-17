function get_filepath(get_filepath_button,~)
    Autosave_tab=get_filepath_button.Parent;
    filepath_box=findobj(Autosave_tab,'Type','UIControl','Tag','filepath_box');
    exisiting_filepath=filepath_box.String;
    
    fig_settings=Autosave_tab.Parent.Parent;
    fig_camera=fig_settings.UserData.fig_camera;
    
    
    %check if the exisiting filepath is actually a filepath and if it is
    %start the dialog from there
    if length(exisiting_filepath)>2
        requested_filepath=uigetdir(exisiting_filepath,['Select autosave directory for ' fig_camera.Name]);
    else
        requested_filepath=uigetdir(pwd,['Select autosave directory for ' fig_camera.Name]);
    end
    
    %if the user chooses a new filepath, change the edit box to that. If they cancel the dialog box, keep the filepath as it was
    %before
    if requested_filepath==0
        filepath_box.String=exisiting_filepath;
    else
        filepath_box.String=requested_filepath;
    end
end