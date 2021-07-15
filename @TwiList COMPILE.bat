set FILE_NAME=@TwiList 1.4 install uninstall MUI
set SOURCE_FILE_NAME=%FILE_NAME% source.vbs
set COMPILED_FILE_NAME=%FILE_NAME%.vbe
set COMPILED_FILE_NAME_FOR_DOWNLOAD=twilist-install-uninstall.vbe
screnc "%SOURCE_FILE_NAME%" "..\%COMPILED_FILE_NAME%"
screnc "%SOURCE_FILE_NAME%" "%COMPILED_FILE_NAME_FOR_DOWNLOAD%"
pause

::set FILE_NAME_DL=%FILE_NAME: =-%.vbe
::"Windows Script Sign File" /file:"%FILE_NAME_DL%" /cert:Administrator /store:"Trusted Root Certification Authorities"
::"Windows Script Sign File" /file:"%FILE_NAME_DL%" /cert:Administrator /store:"Autorit�s de certification racines de confiance"