function discovered_devices=search_for_cameras(table1)
    adaptor_info=imaqhwinfo;
    discovered_devices=cell(1,2);
    k=1;
    
    if exist('ximea_list.csv')
        FID=fopen('ximea_list.csv');
        ximea_list = textscan(FID,'%s %s','Delimiter',',');
    else
        ximea_list{1}={''};
        ximea_list{2}={''};
    end
    
    if exist('gigE_list.csv')
        FID=fopen('gigE_list.csv');
        gigE_list = textscan(FID,'%s %s','Delimiter',',');
    else
            gigE_list{1}={''};
            gigE_list{2}={''};
    end


    for i=1:length(adaptor_info.InstalledAdaptors)%loop over installed adaptors
        adaptor_summary=imaqhwinfo(adaptor_info.InstalledAdaptors{i});%get the details of each adaptor
        for j=1:length(adaptor_summary.DeviceInfo)%loop over the devices on each adaptor
            %adaptor_summary.DeviceInfo(j)
            discovered_devices{k,1}=adaptor_info.InstalledAdaptors{i};%extract a list of the devices
            
            if strcmp(adaptor_info.InstalledAdaptors{i},'gentl')
                for l=1:length(ximea_list{1})%loop over the list of ximeas to rename them from their serial numbers
                    ximea_named=strfind(adaptor_summary.DeviceInfo(j).DeviceName,ximea_list{1}(l));
                    if ~isempty(ximea_named)
                        discovered_devices{k,3}=ximea_list{2}{l};
                        break
                    else
                        discovered_devices{k,3}=adaptor_summary.DeviceInfo(j).DeviceName;
                    end    
                end
            elseif strcmp(adaptor_info.InstalledAdaptors{i},'gige')
                temp_vid = videoinput('gige',j,adaptor_summary.DeviceInfo(j).DefaultFormat);
                temp_vid_src=getselectedsource(temp_vid);
                ID_number=temp_vid_src.DeviceID;
                
                
                for m=1:length(gigE_list{1})
                    gigE_named=strfind(temp_vid_src.DeviceID,gigE_list{1}(m));
                    if ~isempty(gigE_named)
                        discovered_devices{k,3}=gigE_list{2}{m};
                        break
                    else
                        discovered_devices{k,3}=[temp_vid_src.DeviceModelName ' (#' temp_vid_src.DeviceID ')'];
                    end   
                end
                
                delete(temp_vid)
                clear('temp_vid')
                clear('temp_vid_src')
            else
                discovered_devices{k,3}=adaptor_summary.DeviceInfo(j).DeviceName;
            end
            discovered_devices{k,2}=adaptor_summary.DeviceIDs{j};
            discovered_devices{k,4}=false;
            k=k+1;
            
        end
    end
    discovered_devices
    table1.Data=discovered_devices;
end
    