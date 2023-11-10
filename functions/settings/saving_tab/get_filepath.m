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
    
    %now we save the filepath to a csv
    
    
    cam_name=fig_settings.UserData.fig_camera.Name;
    
    %check to see if csv already exists
    if exist('G_cam_config.csv','file')
        disp('G_cam_config.csv found')
        settings_table = readtable('G_cam_config.csv','HeaderLines',0);
        matching_config=[];
        for i=1:length(settings_table.Camera)
            if strcmp(cam_name,settings_table.Camera(i))
                matching_config=[matching_config i];
            end
        end
        
        if length(matching_config)==1  %already an entry 
            disp(matching_config(1))
            settings_table.AutosaveFilepath(matching_config(1))={filepath_box.String};
            writetable(settings_table,'G_cam_config.csv','Delimiter',',')
            disp('Config file updated')
        elseif isempty(matching_config) %no entry, make a new one
            new_line=table({fig_settings.UserData.fig_camera.Name},{filepath_box.String},'VariableNames',{'Camera','AutosaveFilepath'});
            settings_table=[settings_table;new_line];
            writetable(settings_table,'G_cam_config.csv','Delimiter',',')
            disp('Config file updated')
        else %too many entries
            disp(['More than one entry in configuration file for ' cam_name ' no config loaded'])
        end
        
        
    else
        disp('G_cam_config.csv not found in get_filepath')
        settings_table=table({fig_settings.UserData.fig_camera.Name},{filepath_box.String},'VariableNames',{'Camera','AutosaveFilepath'});
        writetable(settings_table,'G_cam_config.csv','Delimiter',',')
        disp('Config file created')
    end
    

end