function EnableCamera(table1,CellEditData)
    fig_cam_list=table1.Parent;
    CamID=CellEditData.Indices(1);
    AdaptorCamID=CellEditData.Source.Data{CamID,2};
    if CellEditData.NewData==1 %if the user is activating a camera
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
            if strcmp(adaptor,'gentl')
                vid_format=adaptor_summary.DeviceInfo(AdaptorCamID).SupportedFormats{2};
            else
                vid_format=adaptor_summary.DeviceInfo(AdaptorCamID).DefaultFormat;
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
        


        



        
        if contains(vid_format,'YUY')
            vid.ReturnedColorSpace='rgb';
        end
       
        if isempty(old_fig_camera)
            %run this section if there was no old figure available
            figure(fig_camera{CamID})
            ax1=axes;
            ax1.Position=[0.01 0.01 0.98 0.86];
            vidRes = vid.VideoResolution;
            displayed_data=imagesc(ax1,zeros(vidRes(2), vidRes(1), vid.NumberofBands ));
            displayed_data.ButtonDownFcn=@FullScreenToggle;
%             %data_size=size(displayed_data.CData)
%             ax1.Position
%             pbaspect(ax1,[vidRes(1) vidRes(2) 1])
%             ax1.Position
            axis image;
            colormap(ax1,gray);
            ax1.XTick=[];
            ax1.YTick=[];
            
            
            %frame_count=text(ax1,ax1.XLim(1)+range(ax1.XLim)*0.98,ax1.YLim(1)+range(ax1.YLim)*0.03,' ','Color','red','HorizontalAlignment','right');
            frame_count=annotation('textbox');
            frame_count.Units='pixel';
            frame_count.Position=[0 15 5 5];
            frame_count.EdgeColor='none';
            frame_count.Color='r';
            fig_camera{CamID}.UserData.frame_count=frame_count;
            frame_count.Units='normalized';
            

            Format_box=findobj(fig_settings,'Type','UIControl','Tag','Format_box');
            Format_box.String=adaptor_summary.DeviceInfo(AdaptorCamID).SupportedFormats;
            Format_box.Value=find(strcmp(vid_format,adaptor_summary.DeviceInfo(AdaptorCamID).SupportedFormats));

            Exposure_tab = findobj('Parent', tgroup, 'Title', 'Exposure', 'Type', 'uitab');
            Exposure_Time_box=findobj(fig_settings,'Type','UIControl','Tag','Exposure_Time_box');
            Gain_box=findobj(fig_settings,'Type','UIControl','Tag','Gain_box');
            
            vid_src_info=get(vid_src);
            if strcmp(adaptor,'gentl')
                ThroughputLimit_box=findobj(fig_settings,'Type','UIControl','Tag','ThroughputLimit_box');
                ThroughputLimit_box.String=num2str(vid_src.DeviceLinkThroughputLimit);
                Exposure_Time_box.String=num2str(double(vid_src.ExposureTime)*1e-3);
                Gain_box.String=num2str(vid_src.Gain);
            elseif strcmp(adaptor,'qimaging')
                %camera exposure time uses s units
                Exposure_Time_box.String=num2str(double(vid_src.Exposure)*1e3);
            elseif strcmp(adaptor,'winvideo')
                if isfield(vid_src_info,'Exposure')
                    %camera exposure time uses 2^(exposure) s
                    Exposure_Time_box.String=num2str((2^double(vid_src.Exposure))*1e3);
                else
                    %if the camera doesn't have the exposure time option
                    %then we delete all the settings window objects
                    %relating to exposure time
                    %delete(Exposure_Time_box)
                    Exposure_Time_box.Enable='off';
                    %delete(findobj('Parent',Exposure_tab,'Tag','ms_box'))
                    ms_box=findobj('Parent',Exposure_tab,'Tag','ms_box');
                    ms_box.Enable='off';
                    %delete(findobj('Parent',Exposure_tab,'Tag','Exposure_Time_text'))
                    Exposure_Time_text=findobj('Parent',Exposure_tab,'Tag','Exposure_Time_text');
                    Exposure_Time_text.Enable='off';
                    %delete(findobj('Parent',Exposure_tab,'Tag','auto_expose_button'))
                    auto_expose_button=findobj('Parent',Exposure_tab,'Tag','auto_expose_button');
                    auto_expose_button.Enable='off';
                    
                    
                end
                
                if isfield(vid_src_info,'Gain')
                    Gain_box.String=num2str(vid_src.Gain);
                else
                    %delete(Gain_box)
                    Gain_box.Enable='off';
                    %delete(findobj('Parent',Exposure_tab,'Tag','Gain_text'))
                    Gain_text=findobj('Parent',Exposure_tab,'Tag','Gain_text');
                    Gain_text.Enable='off';
                    %delete(findobj('Parent',Exposure_tab,'Tag','auto_gain_button'))
                    auto_gain_button=findobj('Parent',Exposure_tab,'Tag','auto_gain_button');
                    auto_gain_button.Enable='off';
                end
                
%                 %delete the auto text if both exposure and gain can't be
%                 %set
%                 if ~isvalid(Exposure_Time_box) && ~isvalid(Gain_box)
%                     delete(findobj('Parent',Exposure_tab,'Tag','auto_text'))
%                 end
                
            elseif strcmp(adaptor,'gige')
                %camera exposure time uses us units
                 Exposure_Time_box.String=num2str(double(vid_src.ExposureTimeAbs)*1e-3);
                 Gain_box.String=num2str(vid_src.Gain);
                 PacketSize_box=findobj(fig_settings,'Type','UIControl','Tag','PacketSize_box');
                 PacketSize_box.String=num2str(vid_src.PacketSize);
                 StreamBytesPerSecond_box=findobj(fig_settings,'Type','UIControl','Tag','StreamBytesPerSecond_box');
                 StreamBytesPerSecond_box.String=num2str(vid_src.StreamBytesPerSecond*8e-6); %convert to bits
            end
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
            %set exposure time etc
            if strcmp(adaptor,'gentl')
                ThroughputLimit_box=findobj(fig_settings,'Type','UIControl','Tag','ThroughputLimit_box');
                vid_src.DeviceLinkThroughputLimit=str2double(ThroughputLimit_box.String);
                vid_src.ExposureTime=str2double(Exposure_Time_box.String)*1e3;
                vid_src.Gain=num2str(Gain_box.String);
            elseif strcmp(adaptor,'qimaging')
                vid_src.Exposure=num2str(Exposure_Time_box.String)*1e-3;
            elseif strcmp(adaptor,'gige')
                 vid_src.ExposureTimeAbs=str2double(Exposure_Time_box.String)*1e3;
                 vid_src.Gain=str2double(Gain_box.String);
                 PacketSize_box=findobj(fig_settings,'Type','UIControl','Tag','PacketSize_box');
                 vid_src.PacketSize=str2double(PacketSize_box.String);
                 StreamBytesPerSecond_box=findobj(fig_settings,'Type','UIControl','Tag','StreamBytesPerSecond_box');
                 vid_src.StreamBytesPerSecond=str2double(StreamBytesPerSecond_box.String)/8e-6; %convert to bits
            end
            
        end


        
        fig_cam_list.UserData.fig_camera{CamID}=fig_camera{CamID};
        
    end
    if CellEditData.NewData==0
        camera_closereq(fig_cam_list.UserData.fig_camera{CamID},0,0)
    end
    
        
        
        
end