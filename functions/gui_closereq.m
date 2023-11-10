function gui_closereq(fig_main,~)
try
   selection = questdlg({'Close Gcam?';'This will close all cameras'},...
      'Close Request Function',...
      'Yes','No','Yes'); 
   Camera_table=findobj(fig_main,'Tag','Camera_table');
   switch selection
      case 'Yes'
          if ~isempty(Camera_table.Data) %check the table that lists all the cameras and see if it's empty. If it is empty it means there are no cameras detected! So we skip most of the next part
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
              
          else
              disp('No cameras were running')
          end
         delete(fig_main)

      case 'No'
      return 
   end
catch
    
end

end