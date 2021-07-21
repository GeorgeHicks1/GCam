function update_settings(vid,fig_settings)
            vid_src=getselectedsource(vid);
            vid_info=imaqhwinfo(vid);
            adaptor=vid_info.AdaptorName;
            %% this section accounts for different adaptors using different words for exposure and using different units for exposure
            exposure_keyword_list={'gentl' 'ExposureTime';...
                            'qimaging' 'Exposure';...
                            'winvideo' 'Exposure';...
                            'gige' 'ExposureTimeAbs'};
            exposure_factor_list={'gentl' 1e-3;...
                            'qimaging' 1e3;...
                            'winvideo' 1e3;...
                            'macvideo' 1e3;...
                            'gige' 1e-3};
                        
            if ~strcmp(adaptor,'macvideo')
                exposure_keyword=exposure_keyword_list{strcmp(exposure_keyword_list(:,1),adaptor),2};
                exposure_factor=exposure_factor_list{strcmp(exposure_factor_list(:,1),'gentl'),2};

                Exposure_tab = findobj(fig_settings, 'Title', 'Exposure', 'Type', 'uitab');
                Exposure_Time_box=findobj(fig_settings,'Type','UIControl','Tag','Exposure_Time_box');
                Gain_box=findobj(fig_settings,'Type','UIControl','Tag','Gain_box');
            
            
                vid_src_info=get(vid_src);

                if strcmp(adaptor,'winvideo')
                    change_webcam_exposure(vid_src,Exposure_tab)
                else
                    Exposure_Time_box.String=num2str(double(vid_src.(exposure_keyword))*exposure_factor);
                end

                if isfield(vid_src_info,'Gain')
                    Gain_box.String=num2str(vid_src.Gain);
                else
                    Gain_box.Enable='off';
                    Gain_text=findobj('Parent',Exposure_tab,'Tag','Gain_text');
                    Gain_text.Enable='off';
                    auto_gain_button=findobj('Parent',Exposure_tab,'Tag','auto_gain_button');
                    auto_gain_button.Enable='off';
                end
            end
            
            switch adaptor
                case 'gentl'
                    ThroughputLimit_box=findobj(fig_settings,'Type','UIControl','Tag','ThroughputLimit_box');
                    ThroughputLimit_box.String=num2str(vid_src.DeviceLinkThroughputLimit);
                case 'gige'
                    PacketSize_box=findobj(fig_settings,'Type','UIControl','Tag','PacketSize_box');
                    PacketSize_box.String=num2str(vid_src.PacketSize);
                    StreamBytesPerSecond_box=findobj(fig_settings,'Type','UIControl','Tag','StreamBytesPerSecond_box');
                    StreamBytesPerSecond_box.String=num2str(vid_src.StreamBytesPerSecond*8e-6); %convert to bits
            end
end