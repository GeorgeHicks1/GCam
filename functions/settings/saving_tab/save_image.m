  function save_image(image_frame,save_filepath)
        if exist(save_filepath)==0
            imwrite(image_frame,save_filepath,'Compression','none')
            disp([save_filepath ' saved at ' datestr(now,'HH:MM:SS')])
        else
            disp([save_filepath ' already exists! Attempting to save with _conflict appended'])
            new_save_filepath=[save_filepath(1:strfind(save_filepath,'.')-1) '_conflict' save_filepath(strfind(save_filepath,'.'):end)];
            save_image(image_frame,new_save_filepath)
        end
    end