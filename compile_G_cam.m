version='4_0';

mcc -m G_cam_viewer.m...
    -a 'C:\Users\George\OneDrive - Imperial College London\Experiments\GCam\GCam-master\GCam-master\*.m'...
    -a 'C:\ProgramData\MATLAB\SupportPackages\R2016b\toolbox\imaq\supportpackages\gentl'...
    -a 'C:\ProgramData\MATLAB\SupportPackages\R2016b\toolbox\imaq\supportpackages\gige'...
    -a 'C:\ProgramData\MATLAB\SupportPackages\R2016b\toolbox\imaq\supportpackages\genericvideo'

movefile('G_cam_viewer.exe','G_cam_viewer_4_0.exe','f')
