function UpdateSavename(updated_box,~)
    Saving_tab=updated_box.Parent;
    Autosave_number=findobj(Saving_tab,'Type','UIControl','Style','Edit','Tag','autosave_number');
    savename_box=findobj(Saving_tab,'Type','UIControl','Style','Edit','Tag','savename_box');
    zeropadding_number=findobj(Saving_tab,'Type','UIControl','Style','Edit','Tag','zeropadding_number');
    example_text=findobj(Saving_tab,'Type','UIControl','Style','text','Tag','Savename_text');
    example_text.String=[savename_box.String num2str(str2double(Autosave_number.String),['%0' zeropadding_number.String 'd']) '.tiff'];

end