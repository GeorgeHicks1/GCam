function autosave_style_change(autosave_style_popupmenu,~)
    saving_tab=autosave_style_popupmenu.Parent;
    fig_settings=saving_tab.Parent.Parent;
    
    next_savename_box=findobj('Parent',saving_tab,'Tag','Savename_text');
    save_name_box=findobj('Parent',saving_tab,'Tag','savename_box');
    Autosave_number=findobj('Parent',saving_tab,'Tag','autosave_number');
    zeropadding_number=findobj('Parent',saving_tab,'Tag','zeropadding_number');
    timestamp_format_box=findobj('Parent',saving_tab,'Tag','timestamp_format');
    
    prefix_tags={'zeropadding_text','zeropadding_number','savename_box','save_name_text','autosave_number_text','autosave_number'};
    timestamp_tags={'timestamp_format','timestamp_format_text'};

    if autosave_style_popupmenu.Value==1
        for i=1:length(prefix_tags)
            object=findobj('Parent',saving_tab,'Tag',prefix_tags{i});
            object.Visible='off';
        end
        for j=1:length(timestamp_tags)
            object=findobj('Parent',saving_tab,'Tag',timestamp_tags{j});
            object.Visible='on';
        end
        next_savename_box.String=[datestr(now,timestamp_format_box.String) '.tiff'];
    elseif autosave_style_popupmenu.Value==2
        for k=1:length(timestamp_tags)
            object=findobj('Parent',saving_tab,'Tag',timestamp_tags{k});
            object.Visible='off';
        end
        for l=1:length(prefix_tags)
            object=findobj('Parent',saving_tab,'Tag',prefix_tags{l});
            object.Visible='on';
        end
        next_savename_box.String=[save_name_box.String num2str(str2double(Autosave_number.String),['%0' zeropadding_number.String 'd']) '.tiff'];
    end
    
    
    

end