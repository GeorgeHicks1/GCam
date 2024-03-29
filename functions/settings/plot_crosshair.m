function plot_crosshair(crosshair_x,crosshair_y,ax1,crosshair_size_box)
    hold(ax1,'on');
    displayed_data=findobj(ax1,'Type','Image');
    data_size=size(displayed_data.CData);
    plot(ax1,ones(1,2)*crosshair_x,[1 data_size(1)],'r','linewidth',str2double(crosshair_size_box.String))
    plot(ax1,[1 data_size(2)],ones(1,2)*crosshair_y,'r','linewidth',str2double(crosshair_size_box.String))
    hold(ax1,'off');
end