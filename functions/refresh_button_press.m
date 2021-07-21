function refresh_button_press(refresh_button,~)
    fig_main=refresh_button.Parent;
   selection = questdlg({'Refresh Gcam?';'This will close all cameras'},...
  'Camera refresh',...
  'Yes','No','Yes'); 
    refresh_button.Enable='Off';
    refresh_button.String='Refreshing...';
    refresh_button.BackgroundColor='red';
    Camera_table=findobj(fig_main,'Tag','Camera_table');
    disp('Refreshing camera list, please wait and don''t press refresh again')
  
   switch selection
      case 'Yes'
          
          if ~isempty(cell2mat(Camera_table.Data(1))) %check the table that lists all the cameras and see if it's empty. If it is empty it means there are no cameras detected! So we skip most of the next part
              cam_figures_to_close=cell2mat(Camera_table.Data(:,4)); %find the list of cameras to close
              for i=1:length(cam_figures_to_close)
                  if cam_figures_to_close(i)==true
                      fig_camera=fig_main.UserData.fig_camera{i};%how to get just the ones that are open
                      if isvalid(fig_camera)
                        if isfield(fig_camera.UserData,'vid')
                            vid=fig_camera.UserData.vid;
                        end
                      end
                      pulsed_triggers=timerfindall;
                        if ~isempty(pulsed_triggers)
                            triggers_were_running=1;
                            stop(pulsed_triggers)
                            delete(pulsed_triggers)
                        end
                      if exist('vid')
                          if ~isempty(vid)
                              if isrunning(vid)
                                  stop(vid)
                                  disp('Acqusition Stopped')
                              end
                              delete(vid)
                              clear('vid')
                          end
                      end
                      if isvalid(fig_camera)
                        delete(fig_camera.UserData.fig_settings)
                        delete(fig_camera)
                      end
                  end
              end

          end
          
      case 'No'
      return 
   end


    imaqreset
    discovered_devices=search_for_cameras(Camera_table);
    disp('List refreshed')
    refresh_button.String='Refresh';
    refresh_button.Enable='On';
    refresh_button.BackgroundColor=[0.94 0.94 0.94];
    if ~isempty(imaqfind)
        disp('video object exists')
        imaqfind
    end
end