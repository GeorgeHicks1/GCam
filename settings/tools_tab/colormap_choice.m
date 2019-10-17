function colormap_choice(colormap_listbox,~)
    fig_settings=colormap_listbox.Parent.Parent.Parent;
    fig_camera=fig_settings.UserData.fig_camera;
    ax1=findobj(fig_camera,'Type','Axes');
    colormap(ax1,eval(colormap_listbox.String{colormap_listbox.Value}));
end