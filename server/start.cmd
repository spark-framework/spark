IF NOT EXIST %~dp0artifacts (
    ECHO Mangler artifacts mappe!
) else (
    %~dp0artifacts\FXServer +set citizen_dir %~dp0artifacts\citizen +exec server.cfg
)