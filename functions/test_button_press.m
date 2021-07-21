function test_button_press(hObject,~)
    vid=hObject.Parent.UserData.vid;
    if isvalid(vid)
        vid
    else
        disp('No video object attached to this figure, is the camera active?')
    end
end