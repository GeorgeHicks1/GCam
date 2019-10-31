function autosave_toggle(autosave_button,~)
    saving_tab=autosave_button.Parent;
    fig_settings=saving_tab.Parent.Parent;
    
    fig_camera=fig_settings.UserData.fig_camera;
    
    filepath_box=findobj('Parent',saving_tab,'Tag','filepath_box');
    
    if autosave_button.Value==1 %if autosaving is being turned on
        if isempty(filepath_box.String) % and the user hasn't entered a filepath yet
         filepath_box.String=fullfile(pwd,'Data',fig_camera.Name); % create a default filepath called Data/camera_name
         if ~exist(filepath_box.String,'dir')
             mkdir(fullfile(pwd,'Data'),fig_camera.Name)
             disp(['Automatically created directory ' filepath_box.String])
         end
        end

end