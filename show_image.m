function show_image(vid,eventData,fig_camera)
        timestamp=eventData.Data.AbsTime;
        image_frame=getdata(vid);
        fig_settings=fig_camera.UserData.fig_settings;
        ax1=findobj(fig_camera,'Type','Axes');
        displayed_data = findall(fig_camera,'type','Image');
        displayed_data.CData=image_frame;
        frame_counter = findall(fig_camera,'type','Text');
        frame_counter.String=vid.FramesAcquired;
        
        if isfield(fig_camera.UserData,'newXLim')
            ax1.XLim=fig_camera.UserData.newXLim;
            ax1.YLim=fig_camera.UserData.newYLim;
        end

        colormap_listbox=findobj(fig_settings,'Type','UIControl','Style','popupmenu','Tag','colormap_listbox');
        Caxis_min=findobj(fig_settings,'Type','UIControl','Style','edit','Tag','Caxis_min_box');
        Caxis_max=findobj(fig_settings,'Type','UIControl','Style','edit','Tag','Caxis_max_box');
        Caxis_lock_button=findobj(fig_settings,'Type','UIControl','Style','checkbox','Tag','caxis_lock_button');
        

        colormap(ax1,eval(colormap_listbox.String{colormap_listbox.Value}));
        
        if size(image_frame,3)==1
            if Caxis_lock_button.Value==1
                ax1.CLim=[str2double(Caxis_min.String) str2double(Caxis_max.String)];
            else
                if min(min(image_frame))<max(max(image_frame))
                    ax1.CLim=[min(min(image_frame)) max(max(image_frame))];
                end
                Caxis_min.String=num2str(ax1.CLim(1));
                Caxis_max.String=num2str(ax1.CLim(2));
            end
        elseif size(image_frame,3)==3
            if Caxis_lock_button.Value==1
                %ax1.CLim=[str2double(Caxis_min.String) str2double(Caxis_max.String)];
            else
%                 if min(min(image_frame))<max(max(image_frame))
%                     ax1.CLim=[min(min(image_frame)) max(max(image_frame))];
%                 end
                Caxis_min.String=num2str(ax1.CLim(1));
                Caxis_max.String=num2str(ax1.CLim(2));
            end
        end
        AutoSave_button=findobj(fig_settings,'Type','UIControl','Style','checkbox','Tag','autosave_button');
        filepath_box=findobj(fig_settings,'Type','UIControl','Style','edit','Tag','filepath_box');
        AutoSave_number=findobj(fig_settings,'Type','UIControl','Style','edit','Tag','autosave_number');
        SaveName=findobj(fig_settings,'Type','UIControl','Style','text','Tag','Savename_text');
        EKSPLAMode_box=findobj(fig_settings,'Type','UIControl','Style','checkbox','Tag','EKSPLAMode_box');
        




        

      
        if AutoSave_button.Value==1
            if EKSPLAMode_box.Value==1
                if isfield(fig_camera.UserData,'PreviousTriggerTime')
                    %work out time between triggers in seconds
                    time_between_triggers=(datenum(timestamp)-datenum(fig_camera.UserData.PreviousTriggerTime))*24*3600;           
                    EKSPLAMode_delay_box=findobj(fig_settings,'Type','UIControl','Style','edit','Tag','EKSPLAMode_delay_box');
                    if time_between_triggers<str2double(EKSPLAMode_delay_box.String)
                        %save_filepath=fullfile(filepath_box.String,['Shot' num2str(str2double(AutoSave_number.String),'%03d') '.tiff']);
                        save_filepath=fullfile(filepath_box.String,SaveName.String);
                        save_image(image_frame,save_filepath)
                        AutoSave_number.String=num2str(str2double(AutoSave_number.String)+1);
                        UpdateSavename(AutoSave_number,0);
                    else
                        disp(['Recieved trigger but did not autosave because the last trigger was ' num2str(time_between_triggers) ' seconds ago which is more than ' EKSPLAMode_delay_box.String ' seconds'])
                    end
                end
            elseif EKSPLAMode_box.Value==0               
                save_filepath=fullfile(filepath_box.String,SaveName.String);
                save_image(image_frame,save_filepath)
                AutoSave_number.String=num2str(str2double(AutoSave_number.String)+1);
                UpdateSavename(AutoSave_number,0);
            end
        end
        fig_camera.UserData.PreviousTriggerTime=timestamp;
end