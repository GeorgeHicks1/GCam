%version='4_0';

mcc -m G_cam_viewer.m...
    -a 'C:\Users\George\OneDrive - Imperial College London\Experiments\GCam\GCam-master\GCam-master_v4_1'...
    -a 'C:\ProgramData\MATLAB\SupportPackages\R2016b\toolbox\imaq\supportpackages\gentl'...
    -a 'C:\ProgramData\MATLAB\SupportPackages\R2016b\toolbox\imaq\supportpackages\gige'...
    -a 'C:\ProgramData\MATLAB\SupportPackages\R2016b\toolbox\imaq\supportpackages\genericvideo'

movefile('G_cam_viewer.exe','G_cam_viewer_4_1_64bit.exe','f')
