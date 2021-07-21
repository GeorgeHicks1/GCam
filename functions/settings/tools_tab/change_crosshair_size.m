function change_crosshair_size(crosshair_size_box,~)
         if ~isnan(str2double(crosshair_size_box.String))
            tools_tab=crosshair_size_box.Parent;
            fig_settings=tools_tab.Parent.Parent;
            fig_camera=fig_settings.UserData.fig_camera;
            ax1=findobj(fig_camera,'Type','Axes');
            lines=findobj(ax1,'type','Line');
            
            for i=1:length(lines)
                line=lines(i);
                line.LineWidth=str2double(crosshair_size_box.String);
            end
            
            
            

         end
end