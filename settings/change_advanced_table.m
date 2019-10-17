function change_advanced_table(advanced_table,event)
	fig_settings=advanced_table.Parent.Parent.Parent;
    fig_camera=fig_settings.UserData.fig_camera;
    vid=fig_camera.UserData.vid;
    vid_src=getselectedsource(vid);
    field_changed=advanced_table.Data{event.Indices(1),1};
    property_info=propinfo(vid_src,field_changed);
    
    switch property_info.ReadOnly
        case 'notCurrently'
            vid_src.(field_changed)=event.NewData;
            advanced_table.Data{event.Indices(1),2}=vid_src.(field_changed); %this line is here in case the camera changes the value
        case 'currently' %then field cannot be changed 
            advanced_table.Data{event.Indices(1),2}=event.PreviousData;
    end
    
    
    update_settings(vid,fig_settings)
    
    
end