function fig_settings=make_settings_window(fig_camera,adaptor)
    
    fig_settings=figure(); fig_settings.Visible='off';
    clf;
    fig_settings.Name=[fig_camera.Name ' Settings'];
    fig_settings.Position(1)=fig_camera.Position(1)+fig_camera.Position(3);
    fig_settings.Position(3)=266;
    fig_settings.Position(4)=252;
    fig_settings.CloseRequestFcn=@settings_window_close_request;
    
    vid=fig_camera.UserData.vid;
    vid_src=getselectedsource(vid);
    
    
    
    
    
    tgroup = uitabgroup('Parent', fig_settings);
    exposure_tab = uitab('Parent', tgroup, 'Title', 'Exposure');
    tools_tab = uitab('Parent', tgroup, 'Title', 'Tools');
    triggering_tab = uitab('Parent', tgroup, 'Title', 'Triggering');
    saving_tab = uitab('Parent', tgroup, 'Title', 'Saving');
    other_tab = uitab('Parent', tgroup, 'Title', 'Other');
    
    jig=0.01;

button_top=0.88;
vgap=0.12;
listbox_x=0.05;
button_x=0.05;

%Preview_button=uicontrol('Parent',fig_settings,'Style','togglebutton','String','Free Run','Units','Normalized','Position',[0.8 button_top-3*vgap 0.09 0.05],'BackgroundColor','red','Callback',@preview_button_press);
Gain_box=uicontrol('Parent',exposure_tab,'Style','Edit','String','','Units','Normalized','Position',[0.424 button_top-1.4833*vgap 0.234 0.1],'Tag','Gain_box','Callback',@change_gain);
Gain_text=uicontrol('Parent',exposure_tab,'Style','Text','String','Gain','Units','Normalized','Position',[0.066 button_top-1.5833*vgap 0.3 0.1],'Tag','Gain_text');
AutoGain_button=uicontrol('Parent',exposure_tab,'Style','checkbox','Units','Normalized','Position',[0.875 button_top-1.4833*vgap 0.288 0.1],'Tag','auto_gain_button','Callback',@change_gain_expose);
Exposure_time_box=uicontrol('Parent',exposure_tab,'Style','Edit','String','','UserData',2,'Units','Normalized','Position',[0.424 button_top-0.4833*vgap 0.234 0.1],'Tag','Exposure_Time_box','Callback',@change_exposure_time); %userdata is the units of the number 1=us 2=ms, 3=s
Exposure_time_text=uicontrol('Parent',exposure_tab,'Style','Text','String','Exposure Time','Units','Normalized','Position',[0.066 button_top-0.5833*vgap 0.3 0.1],'Tag','Exposure_Time_text');
%ms_text=uicontrol('Parent',exposure_tab,'Style','Text','String','ms','Units','Normalized','Position',[0.663 button_top-0.3417*vgap 0.087 0.06],'Tag','ms_text');
ms_box=uicontrol('Parent',exposure_tab,'Style','popupmenu','String',{'us','ms','s'},'Value',2,'Units','Normalized','Position',[0.67 button_top-0.3417*vgap 0.15 0.06],'Tag','ms_box','Callback',@change_exposure_units);
format_box=uicontrol('Parent',exposure_tab,'Style','popupmenu','String',{''},'Units','Normalized','Position',[0.5 button_top-3*vgap 0.4 0.1],'Tag','Format_box','Callback',@change_format);
format_text=uicontrol('Parent',exposure_tab,'Style','Text','String','Format','Units','Normalized','Position',[0.05 button_top-3.2*vgap 0.33 0.12],'Tag','Format_text');

AutoExposure_text=uicontrol('Parent',exposure_tab,'Style','Text','String','Auto','Units','Normalized','Position',[0.822 button_top-0*vgap 0.159 0.1],'Tag','auto_text');
AutoExpose_button=uicontrol('Parent',exposure_tab,'Style','checkbox','Units','Normalized','Position',[0.875 button_top-0.4833*vgap 0.288 0.1],'Tag','auto_expose_button','Callback',@change_auto_expose);

Crosshair_text=uicontrol('Parent',tools_tab,'Style','Text','String','Crosshairs','Units','Normalized','Position',[0.25 button_top-0*vgap 0.5 0.075]);
Caxis_lock_text=uicontrol('Parent',tools_tab,'Style','Text','String','Lock','Units','Normalized','Position',[0.743 button_top-2.85*vgap 0.141 0.075],'Tag','caxis_lock_text');
Caxis_lock_button=uicontrol('Parent',tools_tab,'Style','checkbox','Units','Normalized','Position',[0.785 button_top-3.558*vgap 0.07 0.1],'Tag','caxis_lock_button');
Crosshair_button=uicontrol('Parent',tools_tab,'Style','pushbutton','String','New CH','Units','Normalized','Position',[0.02 button_top-1*vgap 0.225 0.1],'Tag','New Crosshair_button','FontSize',7,'Callback',@crosshair_button_press);
Crosshair_save_button=uicontrol('Parent',tools_tab,'Style','pushbutton','String','Load CH','Units','Normalized','Position',[0.265 button_top-1*vgap 0.225 0.1],'Tag','Load Crosshair_button','FontSize',7,'Callback',@crosshair_load_button_press);
Crosshair_load_button=uicontrol('Parent',tools_tab,'Style','pushbutton','String','Save CH','Units','Normalized','Position',[0.51 button_top-1*vgap 0.225 0.1],'Tag','Save Crosshair_button','FontSize',7,'Callback',@crosshair_save_button_press);
Crosshair_clear_button=uicontrol('Parent',tools_tab,'Style','pushbutton','String','Clear CH','Units','Normalized','Position',[0.755 button_top-1*vgap 0.225 0.1],'Tag','Clear Crosshair_button','FontSize',7,'Callback',@crosshair_clear_button_press);

colormap_text=uicontrol('Parent',tools_tab,'Style','Text','String','Colour Map','Units','Normalized','Position',[0.05 button_top-2*vgap-0.01 0.4 0.1],'Tag','colormap_text');
colormap_listbox=uicontrol('Parent',tools_tab,'Style','popupmenu','String',{'gray','parula','jet','hot','prism','bone'},'Units','Normalized','Position',[0.55 button_top-2*vgap 0.4 0.1],'Tag','colormap_listbox','Callback',@colormap_choice);
Caxis_min_text=uicontrol('Parent',tools_tab,'Style','Text','String','CAxis Min','Units','Normalized','Position',[0.079 button_top-3.083*vgap 0.25 0.1],'Tag','caxis_min_text');
Caxis_min=uicontrol('Parent',tools_tab,'Style','Edit','String','','Units','Normalized','Position',[0.05 button_top-3.6*vgap 0.3 0.1],'Tag','Caxis_min_box','Callback',@clim_adjust);
Caxis_min.UserData.MinMax=1;
Caxis_max_text=uicontrol('Parent',tools_tab,'Style','Text','String','CAxis Max','Units','Normalized','Position',[0.437 button_top-3.083*vgap 0.25 0.1],'Tag','caxis_max_text');
Caxis_max=uicontrol('Parent',tools_tab,'Style','Edit','String','','Units','Normalized','Position',[0.4 button_top-3.6*vgap 0.3 0.1],'Tag','Caxis_max_box','Callback',@clim_adjust);
Caxis_max.UserData.MinMax=2;

Trigger_text=uicontrol('Parent',triggering_tab,'Style','Text','String','Trigger Mode','Units','Normalized','Position',[0.092 button_top-0*vgap 0.287 0.077],'Callback',@change_hardware_trigger);
Trigger_button=uicontrol('Parent',triggering_tab,'Style','pushbutton','String','Software trigger','Units','Normalized','Position',[0.3 button_top-2.15*vgap 0.4 0.1],'Callback',{@trigger_button_press, fig_camera});
Trigger_listbox=uicontrol('Parent',triggering_tab,'Style','popupmenu','String',{'Free run','Software','Software pulsed','Hardware'},'Value',1,'Units','Normalized','Position',[0.49 button_top-0.1*vgap 0.45 0.1],'Tag','Trigger_Listbox','Callback',@change_hardware_trigger);
Acquisition_Frequency=uicontrol('Parent',triggering_tab,'Style','Edit','String','1','Units','Normalized','Position',[0.5 button_top-1*vgap 0.263 0.1],'Callback',@acqusition_frequency_change,'Tag','Acquisition_Frequency');
Acquisition_Freq_text=uicontrol('Parent',triggering_tab,'Style','Text','String','Pulse Freq.','Units','Normalized','Position',[0.069 button_top-1*vgap 0.33 0.1],'Tag','Acquisition_Frequency_text');
Hz_text=uicontrol('Parent',triggering_tab,'Style','Text','String','Hz','Units','Normalized','Position',[0.786 button_top-1*vgap 0.115 0.1]);

example_text_text=uicontrol('Parent',saving_tab,'Style','Text','String','Next autosave filename:','Units','Normalized','Position',[0.243 button_top-4.49*vgap 0.543 0.077],'Tag','Savename_text_text');
example_text=uicontrol('Parent',saving_tab,'Style','Text','String','','Units','Normalized','Position',[0.05 button_top-5.525*vgap 0.9 0.121],'Tag','Savename_text');
zeropadding_text=uicontrol('Parent',saving_tab,'Style','Text','String','Padding','Units','Normalized','Position',[0.029 button_top-2.65*vgap 0.173 0.076],'Tag','zeropadding_text');
zeropadding_number=uicontrol('Parent',saving_tab,'Style','Edit','String','4','Units','Normalized','Position',[0.225 button_top-2.725*vgap 0.151 0.1],'Tag','zeropadding_number','Callback',@UpdateSavename);
save_name_box=uicontrol('Parent',saving_tab,'Style','Edit','String','Shot_','Units','Normalized','Position',[0.325 button_top-1.62*vgap 0.646 0.1],'Tag','savename_box','Callback',@UpdateSavename);
save_name_text=uicontrol('Parent',saving_tab,'Style','Text','String','Save name','Units','Normalized','Position',[0.02 button_top-1.4833*vgap 0.266 0.065],'Tag','save_name_text');
Autosave_number_text=uicontrol('Parent',saving_tab,'Style','Text','String','Autosave number','Units','Normalized','Position',[0.426 button_top-2.4667*vgap 0.365 0.0527],'Tag','Info_text');
filepath_text=uicontrol('Parent',saving_tab,'Style','Text','String','Filepath','Units','Normalized','Position',[0.05 button_top-0*vgap 0.7 0.1],'Tag','Info_text');
filepath_box=uicontrol('Parent',saving_tab,'Style','Edit','String','','Units','Normalized','Position',[0.05 button_top-0.62*vgap 0.7 0.1],'Tag','filepath_box');
filepath_get_button=uicontrol('Parent',saving_tab,'Style','pushbutton','String','...','Units','Normalized','Position',[0.77 button_top-0.62*vgap 0.2 0.1],'Callback',@get_filepath,'Tag','find_button');
AutoSave_button=uicontrol('Parent',saving_tab,'Style','checkbox','Units','Normalized','Position',[0.617 button_top-3.6667*vgap 0.063 0.1],'Tag','autosave_button');
AutoSave_text=uicontrol('Parent',saving_tab,'Style','Text','String','Auto Save','Units','Normalized','Position',[0.365 button_top-3.525*vgap 0.221 0.07],'Tag','Info_text');
Autosave_number=uicontrol('Parent',saving_tab,'Style','Edit','String','1','Units','Normalized','Position',[0.816 button_top-2.725*vgap 0.151 0.1],'Tag','autosave_number','Callback',@UpdateSavename);
Autsave_last_button=uicontrol('Parent',saving_tab,'Style','pushbutton','String','Autosave last image','Units','Normalized','Position',[0.02 button_top-7.225*vgap 0.52 0.1],'Tag','Autosave_last_image_button','Callback',@autosave_last_image_button_press);
Save_file_button=uicontrol('Parent',saving_tab,'Style','pushbutton','String','Save last image','Units','Normalized','Position',[0.56 button_top-7.225*vgap 0.42 0.1],'Tag','Save_last_image_button','Callback',@save_last_image_button_press);
example_text.String=[save_name_box.String num2str(str2double(Autosave_number.String),['%0' zeropadding_number.String 'd']) '.tiff'];


ThroughputLimit_box=uicontrol('Parent',other_tab,'Style','Edit','String','','Units','Normalized','Position',[0.8 button_top-2.05*vgap 0.18 0.1],'Tag','ThroughputLimit_box','Callback',@change_throughputlimit,'Enable','Off');
ThroughputLimit_text=uicontrol('Parent',other_tab,'Style','Text','String','Bandwidth Limit','Units','Normalized','Position',[0.01 button_top-2.2*vgap 0.2 0.12],'Tag','ThroughputLimit_text');
%disp([1/double(property_info.ConstraintValue(2)-property_info.ConstraintValue(1)) 1])
%disp(['Slider min: ' num2str(property_info.ConstraintValue(1)) ', Slider max: ' num2str(property_info.ConstraintValue(2))])
ThroughputLimit_button=uicontrol('Parent',other_tab,'Style','checkbox','Units','Normalized','Position',[0.25 button_top-2.2*vgap 0.12 0.12],'Value',0,'Tag','ThroughputLimit_button','Callback',@change_throughputlimitmode,'Enable','Off');
ThroughputLimit_slider=uicontrol('Parent',other_tab,'Style','Slider','Units','Normalized','Position',[0.32 button_top-2*vgap 0.45 0.08],'Tag','ThroughputLimit_slider','CallBack',@update_throughput_slider,'Enable','Off');

StreamBytesPerSecond_box=uicontrol('Parent',other_tab,'Style','Edit','String','','Units','Normalized','Position',[0.5 button_top-3*vgap 0.4 0.1],'Tag','StreamBytesPerSecond_box','Callback',@change_streamsize,'Enable','Off');
StreamBytesPerSecond_text=uicontrol('Parent',other_tab,'Style','Text','String','Bus Load','Units','Normalized','Position',[0.05 button_top-3.2*vgap 0.33 0.12],'Tag','StreamBytesPerSecond_text');
packet_size_box=uicontrol('Parent',other_tab,'Style','Edit','String','','Units','Normalized','Position',[0.5 button_top-4*vgap 0.4 0.1],'Tag','PacketSize_box','Callback',@change_packetsize,'Enable','Off');
packet_size_text=uicontrol('Parent',other_tab,'Style','Text','String','Packet Size','Units','Normalized','Position',[0.05 button_top-4.2*vgap 0.33 0.12],'Tag','PacketSize_text');

if strcmp(adaptor,'gentl')
    ThroughputLimit_button.Enable='On';
    ThroughputLimit_slider.Enable='On';
    ThroughputLimit_box.Enable='On';
    ThroughputLimit_button.Value=1;
    property_info=propinfo(vid_src,'DeviceLinkThroughputLimit');
    ThroughputLimit_slider.Min=property_info.ConstraintValue(1);
    ThroughputLimit_slider.Max=property_info.ConstraintValue(2);
    ThroughputLimit_slider.Value=1000;

elseif strcmp(adaptor,'gige')
    StreamBytesPerSecond_box.Enable='On';
    packet_size_box.Enable='On';
end

EKSPLAMode_text=uicontrol('Parent',other_tab,'Style','Text','String','EKSPLA mode','Units','Normalized','Position',[0.01 button_top-1.2*vgap 0.3 0.08],'Tag','EKSPLAMode_text');
EKSPLAMode_box=uicontrol('Parent',other_tab,'Style','checkbox','Units','Normalized','Position',[0.5 button_top-1*vgap 0.4 0.1],'Tag','EKSPLAMode_box');
EKSPLAMode_delay_text=uicontrol('Parent',other_tab,'Style','Text','String','EKSPLA mode delay','Units','Normalized','Position',[0.01 button_top-0.2*vgap 0.3 0.12],'Tag','EKSPLAMode_delay_text');
EKSPLAMode_delay_box=uicontrol('Parent',other_tab,'Style','Edit','String','6','Units','Normalized','Position',[0.5 button_top-0*vgap 0.4 0.1],'Tag','EKSPLAMode_delay_box');

fig_camera.UserData.fig_settings=fig_settings;
fig_settings.UserData.fig_camera=fig_camera;

    end