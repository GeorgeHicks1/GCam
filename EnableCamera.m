function EnableCamera(table1,CellEditData)
    fig_cam_list=table1.Parent;
    CamID=CellEditData.Indices(1);
    AdaptorCamID=CellEditData.Source.Data{CamID,2};
    if CellEditData.NewData==1 %if the user is activating a camera
        table1.ColumnEditable=[false false false false];
        camera_name=table1.Data{CamID,3};
        adaptor=table1.Data{CamID,1};
        old_fig_camera=findobj('Type','Figure','Name',camera_name);%check to see if there is already a figure for this camera name


        if isempty(old_fig_camera)
            %run this section if there was no old figure available
            fig_camera{CamID}=figure();
            fig_camera{CamID}.Name=table1.Data{CamID,3};
            fig_camera{CamID}.Position(3:4)=[368 420];
            fig_camera{CamID}.UserData.CamID=CamID;
            fig_camera{CamID}.CloseRequestFcn={@camera_closereq,1};
            %fig_camera{CamID}.SizeChangedFcn=@figure_resize_function;
            fig_camera{CamID}.UserData.figure_position=fig_camera{CamID}.Position;
            fig_camera{CamID}.UserData.FullScreenMode=false;
            

            adaptor_summary=imaqhwinfo(adaptor);
            device_info=adaptor_summary.DeviceInfo(AdaptorCamID);
            if strcmp(adaptor,'gentl')
                vid_format=device_info.SupportedFormats{2};
            else
                vid_format=device_info.DefaultFormat;
            end
            vid = videoinput(adaptor, AdaptorCamID,vid_format);
            vid_src = getselectedsource(vid);
            fig_camera{CamID}.UserData.vid=vid;
            
            h = zoom;
            h.ActionPostCallback = @mypostcallback;
            
            uicontrol('Parent',fig_camera{CamID},'Style','togglebutton','String','Run','Units','Normalized','Position',[0.1 0.88 0.16 0.08],'BackgroundColor','red','Tag','Run_button','Callback',@run_button_press);
            uicontrol('Parent',fig_camera{CamID},'Style','pushbutton','String','Settings','Units','Normalized','Position',[0.3 0.88 0.16 0.08],'Callback',@settings_button_press,'Tag','Settings_button');
            uicontrol('Parent',fig_camera{CamID},'Style','pushbutton','String','Status','Units','Normalized','Position',[0.5 0.88 0.16 0.08],'Callback',@test_button_press,'Tag','Status_button');
            
            %set a few default settings
            set_default_settings(vid,fig_camera{CamID},adaptor)
            set_initial_settings(vid,adaptor)
            
            fig_settings=make_settings_window(fig_camera{CamID},adaptor);
            tgroup = findobj('Parent', fig_settings, 'Type', 'uitabgroup');

            
        else
            %this section runs when there was an old figures window
            %available
            fig_camera{CamID}=old_fig_camera;
            fig_settings=fig_camera{CamID}.UserData.fig_settings;
            figure(fig_camera{CamID})
            Format_box=findobj(fig_settings,'Tag','Format_box');
            vid_format=Format_box.String{Format_box.Value};
            
            vid = videoinput(adaptor, AdaptorCamID,vid_format);
            vid_src = getselectedsource(vid);
            fig_camera{CamID}.UserData.vid=vid;
        end
        table1.ColumnEditable=[false false false true];


        
        if contains(vid_format,'YUY')
            vid.ReturnedColorSpace='rgb';
        end
        


 %%     
        if isempty(old_fig_camera)
            %run this section if there was no old figure available
            figure(fig_camera{CamID})
            ax1=axes;
            ax1.Position=[0.01 0.01 0.98 0.86];
            vidRes = vid.VideoResolution;
            displayed_data=imagesc(ax1,zeros(vidRes(2), vidRes(1), vid.NumberofBands ));
            displayed_data.ButtonDownFcn=@FullScreenToggle;
            axis image;
            colormap(ax1,gray);
            ax1.XTick=[];
            ax1.YTick=[];
            
            frame_count=annotation('textbox');
            frame_count.Units='pixel';
            frame_count.Position=[0 15 5 5];
            frame_count.EdgeColor='none';
            frame_count.Color='r';
            fig_camera{CamID}.UserData.frame_count=frame_count;
            frame_count.Units='normalized';
            
            
            Format_box=findobj(fig_settings,'Type','UIControl','Tag','Format_box');
            Format_box.String=device_info.SupportedFormats;
            Format_box.Value=find(strcmp(vid_format,device_info.SupportedFormats));
            
            update_settings(vid,fig_settings)
            fig_camera{CamID}.UserData.fig_settings=fig_settings;


        else
            fig_camera{CamID}.UserData.vid=vid;
            fig_camera{CamID}.UserData.frame_count.String='0';
            set_default_settings(vid,fig_camera{CamID},adaptor)
            fig_settings=fig_camera{CamID}.UserData.fig_settings;
            fig_settings.UserData.fig_camera=fig_camera{CamID};
            Trigger_listbox=findobj(fig_settings,'Tag','Trigger_Listbox');
            change_hardware_trigger(Trigger_listbox,0);
            Exposure_Time_box=findobj(fig_settings,'Type','UIControl','Tag','Exposure_Time_box');
            Gain_box=findobj(fig_settings,'Type','UIControl','Tag','Gain_box');
            


            if strcmp(adaptor,'gige')
                 vid_src.ExposureTimeAbs=str2double(Exposure_Time_box.String)*1e3;
                 vid_src.Gain=str2double(Gain_box.String);
                 PacketSize_box=findobj(fig_settings,'Type','UIControl','Tag','PacketSize_box');
                 vid_src.PacketSize=str2double(PacketSize_box.String);
                 StreamBytesPerSecond_box=findobj(fig_settings,'Type','UIControl','Tag','StreamBytesPerSecond_box');
                 vid_src.StreamBytesPerSecond=str2double(StreamBytesPerSecond_box.String)/8e-6; %convert to bits
            else
                disp('This message shoud not be shown, you have released a non- gigE camera! This messgae is created in EnableCamera.m')
            end
            
        end


        
        fig_cam_list.UserData.fig_camera{CamID}=fig_camera{CamID};
        
    end
    if CellEditData.NewData==0
        camera_closereq(fig_cam_list.UserData.fig_camera{CamID},0,0)
    end
    
        
        
        
end