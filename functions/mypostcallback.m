function mypostcallback(fig_camera,evd)
disp('zooming')
    persistent chk
if isempty(chk)
      chk = 1;
      pause(0.5); %Add a delay to distinguish single click from a double click
      if chk == 1
          %doing a single-click
          chk = [];
        fig_camera.UserData.newXLim = evd.Axes.XLim;
         fig_camera.UserData.newYLim = evd.Axes.YLim;
      end
else
      chk = [];
      %doing a double-click
      fig_camera.UserData.newXLim = evd.Axes.XLim;
      fig_camera.UserData.newYLim = evd.Axes.YLim;
 end

end