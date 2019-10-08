function G_cam_viewer
%0.1 connects to 1 ximea, free run, software triggering, auto expose toggle
%and exposure time
%0.2 addded hardware triggering and adaptor and camera selection
%0.3 added Q cam support
%0.4 added autosave 
%0.5 removed getData timeout bug and added frame number
%0.6  persistant zoom after trigger, crosswire, video stopping on figure
%close and colourmap and colour limit control
%0.7 added pulsed software trigger mode
%1.0 Big overhaul, changed UI, multi-camera support, ximea transfer rate
%limit
%1.1 Added option to change ximea transfer rate and stopped settings window
%appearing on trigger
%1.2 Tried to optimise fpr speed, update CData everyt trigger rather than
%running imagesc, also update the frame count. Crosshair may be broken now
%1.3 EKSPLA mode- only autosave if there has been a trigger less than 10
%seconds before this one
%1.4 Added control of EKSPLA delay and fixed some bugs
%1.5 saving, loading and clearing crosshairs. Autosave and save after a
%shot is taken. Labelling of colourmap and caxis boxes.
%1.6 added compatibility for VImicro cameras
%1.7 format choosing option
%1.8 moved some options around in the settings window and tidied up a lot 
%1.9 added gain control, fixed pulsed mode using timer functions, lockable
%CLims (they were previously always locked!), check for user input that
%needs to be numeric and addded lots of labels to things
%1.10 Added look up function for renaming cameras (only Ximeas at the
%moment)
%1.11 Added a run all cameras button
%1.12 Added change all triggers and autosave all
%1.13 Made all functions seperate and stopped using specific figure numbers
%v2.0 Added gigE cam support, fixed bug in pulsed triggers and added check for too fast triggers, checks for open
%versions of G cam before opening, added camera refresh button
%v2.1 Customisable autosave name and added colour and text notification of
%when Gcam is refreshing the camera list. Fixed bug not letting a user make
%a new crosshair. Fixed bug in setting CLims and manually saving images.
%Gige cameras now release on exit
%v2.2 Changed Ximea naming to be in a .csv not a .mat file
%v2.3 Revamped settings that affect all cameras, including adding a
%software trigger all button. Made the frame counter number reset to zero
%whenever the video is restarted
%2.4 Can now release a gige camera so it can be used on other computers
%2.4.1 Fixed so that camera stops running when released and settings
%changes when released do not lead to errors
%2.4.2 Moved close camera dialog window to the detected camera list figure
%if it was deactivated friom the checkbox. Stopped the software trigger
%button from working when camera is not active
%2.4.3 made YUY format cameras (generally usb cameras) output in rgb
%3.0 Free run added
%3.0.1 Fixed a bug that didn't automatically set default settings properly,
%should get rid of TriggerMode='off' warning for giges. Also, stopped ximea
%names being written to command line
%3.1 Caxis limits now appear in the boxes while Free running. Software and
%Software pulsed triggers now check that the video object is both not
%logging and has no frames available before it triggers
%3.1.1 Fixed bug with crosshairs
%3.1.2 Removed all use of Children, so object referencing is based on tags
%3.2 Fixed two bugs when using crosshairs while zoomed. Fixed position of
%frame counter.
%3.2 Added slider for Ximea throughput. Made it so that all settings items
%appear in settings windows, but are disabled if not applicable. Fixed gain
%control for USB cameras
%4.1 added rotation of images

if ~isdeployed
    addpath(genpath(pwd))
end

if ~isempty(findobj('Type','Figure','Name','G cam Camera Select'))
    msgbox('An instance of G-Cam is already running, please close it before opening a new instance','G-cam already running')
else

    fig_cam_list=figure(); clf;
    fig_cam_list.Position=[360 276 520 350];
    fig_cam_list.Name='G cam Camera Select';
    fig_cam_list.CloseRequestFcn=@gui_closereq;
    
    software_trigger_all_button=uicontrol('Parent',fig_cam_list,'Style','pushbutton','String','Software trigger all','Units','Normalized','Position',[0.363 0.01 0.235 0.06],'Callback',@software_trigger_all);
    autosave_off_button=uicontrol('Parent',fig_cam_list,'Style','pushbutton','String','Off','Units','Normalized','Position',[0.853 0.027 0.08 0.08],'Callback',@autosave_all_off);
    stop_all_button=uicontrol('Parent',fig_cam_list,'Style','pushbutton','String','Stop all','Units','Normalized','Position',[0.05 0.008 0.16 0.08],'Callback',@stop_all_button_press);
    refresh_button=uicontrol('Parent',fig_cam_list,'Style','pushbutton','String','Refresh','Units','Normalized','Position',[0.792 0.881 0.16 0.08],'Callback',@refresh_button_press);
    run_all_button=uicontrol('Parent',fig_cam_list,'Style','pushbutton','String','Run all','Units','Normalized','Position',[0.05 0.1 0.16 0.08],'Callback',@run_all_button_press);
    Trigger_listbox=uicontrol('Parent',fig_cam_list,'Style','popupmenu','String',{'Freerun','Software','Software pulsed','Hardware'},'Value',1,'Units','Normalized','Position',[0.384 0.072 0.2 0.056],'Callback',@change_all_triggers);
    uicontrol('Parent',fig_cam_list,'Style','Text','String','Change all camera triggers to:','Units','Normalized','Position',[0.332 0.135 0.291 0.047]);
    autosave_on_button=uicontrol('Parent',fig_cam_list,'Style','pushbutton','String','On','Units','Normalized','Position',[0.719 0.027 0.08 0.08],'Callback',@autosave_all_on);
    uicontrol('Parent',fig_cam_list,'Style','Text','String','Turn all autosaving:','Units','Normalized','Position',[0.704 0.125 0.239 0.052]);




    table1=uitable(fig_cam_list);
    table1.Tag='Camera_table';
    table1.ColumnName={'Adaptor','Camera ID','Camera Name','Active'};
    table1.Units='normalized';
    table1.Position=[0.05 0.2 0.9 0.65];
    table1.ColumnWidth={50,60,250,50};
    table1.ColumnEditable=[false false false true];
    table1.CellEditCallback=@EnableCamera;
    cam_text=uicontrol('Style','Text','String','Detected Cameras','Units','Normalized','Position',[0.289 0.88 0.45 0.08],'FontSize',16);
    
    discovered_devices=search_for_cameras(table1);
end
end


    