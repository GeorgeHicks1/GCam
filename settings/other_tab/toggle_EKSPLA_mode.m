function toggle_EKSPLA_mode(EKSPLA_mode_box,~)
    other_tab=EKSPLA_mode_box.Parent;
    EKSPLA_mode_delay_box=findobj('Parent',other_tab,'Tag','EKSPLAMode_delay_box');
    if EKSPLA_mode_box.Value==1
        EKSPLA_mode_delay_box.Enable='On';
    elseif EKSPLA_mode_box.Value==0
        EKSPLA_mode_delay_box.Enable='Off';
    end

        
end