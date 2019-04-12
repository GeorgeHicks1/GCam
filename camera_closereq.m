function camera_closereq(fig_camera,~,arg)
    fig_main=findobj('Type','Figure','-and','Name','G cam Camera Select');
    
    if arg==1
        fig_camera.Units='normalized';
        questdlg_position=fig_camera.Position(1:2)+[fig_camera.Position(3)*-0.05 fig_camera.Position(4)*0.4];
        fig_camera.Units='pixel';
    elseif arg==0
        fig_main.Units='normalized';
        questdlg_position=fig_main.Position(1:2)+[fig_main.Position(3)*0.1 fig_main.Position(4)*0.4];
        fig_main.Units='pixel';
    end
    
    if isfield(fig_camera.UserData,'vid')
        if isvalid(fig_camera.UserData.vid)
            vid_info=imaqhwinfo(fig_camera.UserData.vid);
        else
            vid_info.AdaptorName='none';
        end
    else
        vid_info.AdaptorName='none';
    end
        if strcmp(vid_info.AdaptorName,'gige')
            selection = MFquestdlg(questdlg_position,['Close ' fig_camera.Name '?'],...
            'Close Request Function',...
            'Yes','No','Release camera','Yes'); 
        elseif strcmp(vid_info.AdaptorName,'none')
            selection = MFquestdlg(questdlg_position,['Close ' fig_camera.Name '?'],...
            'Close Request Function',...
            'Yes','No','Yes');
        else
            selection = MFquestdlg(questdlg_position,['Close ' fig_camera.Name '?'],...
            'Close Request Function',...
            'Yes','No','Yes');
        end
        
       switch selection
          case 'Yes'
              disp(['Closing camera ' num2str(fig_camera.UserData.CamID)])
             close_video_object(fig_main,fig_camera)
             
             if isfield(fig_camera.UserData,'fig_settings')
                %find if the fig_settings has been entered into the
                %fig_camera UserData
                delete(fig_camera.UserData.fig_settings)
             end
             delete(fig_camera)
          case 'No'
              Camera_table=findobj(fig_main,'Tag','Camera_table');
              Camera_table.Data{fig_camera.UserData.CamID,4}=true;
          return
          case 'Release camera'

             fig_main=findobj('Type','Figure','-and','Name','G cam Camera Select');
             close_video_object(fig_main,fig_camera)
       end
end