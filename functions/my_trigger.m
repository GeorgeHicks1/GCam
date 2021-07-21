function my_trigger(~,~,vid)
    if ~islogging(vid)
        if vid.FramesAvailable==0
            trigger(vid)
        end
    end
end