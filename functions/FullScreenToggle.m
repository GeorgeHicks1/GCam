function FullScreenToggle(displayed_data,~)
    ax1=displayed_data.Parent;
    fig_camera=ax1.Parent;
    Run_button=findobj(fig_camera,'Type','UIControl','Style','togglebutton','Tag','Run_button');
    Settings_button=findobj(fig_camera,'Type','UIControl','Style','pushbutton','Tag','Settings_button');
    Status_button=findobj(fig_camera,'Type','UIControl','Style','pushbutton','Tag','Status_button');
    persistent chk
    if isempty(chk)
          chk = 1;
          pause(0.5); %Add a delay to distinguish single click from a double click
          if chk == 1
              %single click
              chk = [];
          end
    else
          %double click
          chk = [];
          if fig_camera.UserData.FullScreenMode==false
              fig_camera.UserData.figure_position=fig_camera.Position;
              ax1.Position=[0 0 1 1];
              Run_button.Visible='off';
              Settings_button.Visible='off';
              Status_button.Visible='off';

              fig_camera.UserData.FullScreenMode=true;
              fig_camera.Units='pixels';
              graphics_root=groot;
              fig_camera.Position(1)=1;
              fig_camera.Position(3)=graphics_root.ScreenSize(3);
              fig_camera.OuterPosition(2)=35;
              fig_camera.OuterPosition(4)=graphics_root.ScreenSize(3)-fig_camera.OuterPosition(2);
          else
              ax1.Position=[0.01 0.01 0.98 0.86];
              Run_button.Visible='on';
              Settings_button.Visible='on';
              Status_button.Visible='on';
              fig_camera.Units='pixels';
              fig_camera.Position=fig_camera.UserData.figure_position;
              fig_camera.UserData.FullScreenMode=false;
          end

    end
end