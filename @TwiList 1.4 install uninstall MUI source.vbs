'TWILIST: List folders & files from here & Windows prompt here
'Designed for: Windows NT4/2000/XP/Vista/7/8/8.1/10 & Windows Server NT4/2000/2003/2008/2012/2016/2019 both x86/x64
'Requierements: wscript.exe in PATH, run as admin
'Infos: no exe / no process while not running  'in batch : >>>="^>^>^>"

set objShell = CreateObject("Wscript.Shell")
set fso=CreateObject("Scripting.FileSystemObject")
private const MSG_EMAIL = "vintive@gmail.com"
private const MSG_TITLE_SOFTWARE = "TwiList"
private const MSG_VERSION = "1.4"
private const MSG_YEARS = "2007-2020"
private const MSG_SEPARATOR = " - "
private const MSG_SEPARATOR_TRANSITION = " » "
private const MSG_TRANSITION = "» "
private const MSG_URL_FULL = "http://www.twilist.org"
private const MSG_OWNER = "Vincent Bourdeau"

dim strLang
LANG = GetLang() '0=EN, 1=FR
MSG_TITLECommandPromptHereAndDirHere = array("Files listing", "Listing des fichiers")
MSG_DONATE = array("PayPal Donate","Contributions PayPal")
MSG_TITLE = MSG_TITLE_SOFTWARE & " " & MSG_VERSION & MSG_SEPARATOR_TRANSITION & MSG_DONATE(LANG) & MSG_SEPARATOR_TRANSITION & MSG_EMAIL
DIR_HERE_TITLE_MSG = array("CTRL+A and CTRL+C, then CTRL+V in other app, then close", _
	"CTRL+A et CTRL+C, puis CTRL+V dans une autre application, puis fermer")
	'Select content, copy, paste, then close windows", _
DIR_HERE_TITLE = MSG_TITLE_SOFTWARE & " " & MSG_VERSION & MSG_SEPARATOR_TRANSITION & DIR_HERE_TITLE_MSG(LANG)
MSG_PROPERTY = array("All rights reserved ","Propriété de ")
MSG_NOTEPAD_NAME = array("Notepad", _
	"Bloc-notes")
MSG_LOADING = array("Loading: ", _
	"Chargement en cours : ")
MSG_LOADED_10 = array("Loaded.", _
	"Chargement terminé.")
MSG_LOADED_12 = array("It's an alphabetical listing of folders and files.", _
	"Il s'agit d'un classement alphabétique des dossiers puis des fichiers.")
MSG_LOADED_13 = array("Folders and files, hidden, system, and protected are displayed.", _
	"Les dossiers et fichiers, cachés, systèmes et protégés sont également affichés.")
MSG_LOADED_14 = array("It works on all folders, including network folders.", _
	"Ceci fonctionne sur tous les dossiers, y compris racine et emplacements réseau.")
MSG_LOADED_15 = array("All kind of characters in all languages are supported.", _
	"Tous les types de caractères de toutes langues sont pris en charge.")
MSG_LOADED_20 = array("You can copy/paste content of " & MSG_NOTEPAD_NAME(LANG), _
	"Vous pouvez copier/coller le contenu du " & MSG_NOTEPAD_NAME(LANG))
MSG_LOADED_30 = array("or save as..., and close it.", _
	"ou l'enregistrer sous..., puis le fermer.")
MSG_LOADED_32 = MSG_TITLE_SOFTWARE & " for Windows " & MSG_VERSION & " [" & strLang & "]"
MSG_LOADED_33 = MSG_URL_FULL & MSG_SEPARATOR & MSG_EMAIL
MSG_LOADED_34 = MSG_YEARS & " " & MSG_PROPERTY(LANG) & MSG_OWNER
MSG_LOADED_37 = array("Free for personal use.", _
	"Gratuit pour une utilisation privée non commerciale.")
MSG_LOADED_38 = array("For an enterprise deployment, please contact us.", _
	"Pour un déploiement en entreprise, contactez nous.")
MSG_LOADED_40 = array("To encourage development with PayPal" & MSG_SEPARATOR_TRANSITION & MSG_EMAIL, _
	"Pour encourager le développement via PayPal" & MSG_SEPARATOR_TRANSITION & MSG_EMAIL)
MSG_FORWINDOWSNT = array(MSG_TITLE_SOFTWARE & " is designed for Windows NT Technology : installation refused.", _
	MSG_TITLE_SOFTWARE & " est conçu pour Windows NT Technology : installation impossible.")
MSG_EXTENSIONS_UNLOCKED = array("Files extensions unlocked are : ", _
	"Les extensions débloquées désormais accessibles sont : ")
MSG_LIST_FILES_HERE = array("&List all folders and files in ", _
	"&Lister tous dossiers et fichiers dans ") '& pour _ raccourci clavier
MSG_LIST_FILES_HERE_SUB = array("List complete &tree from here in ", _
	"Lister toute l'&arborescence d'ici dans ") '& pour _ raccourci clavier
CMD_HERE_MSG = array("&Command prompt here", _
	"Invite de &commande") '& pour _ raccourci clavier
CMD_HERE_ADMIN_MSG = array("Command prompt here (&admin)", _
	"Invite de commande (&admin)") '& pour _ raccourci clavier
MSG_UNINSTALL = array("will be uninstalled if you continue.", _
	"sera désinstallé si vous continuez.")
'MSG_INSTALL = array("Install", _
'	"Voulez-vous installer")
MSG_UNINSTALLED = array("was successfully uninstalled.", _
	"a été correctement désinstallé.")
MSG_INSTALLED = array("was successfully installed.", _
	"a été correctement installé.")
MSG_NOTICE = array("To use it, right click on a folder from Windows Explorer..." & vbcr & "Don't use on special folders: Desktop / Libraries.", _
	"Pour l'utiliser, faites un clic droit sur un dossier dans l'Explorateur Windows..." & vbcr & "Ne s'applique pas aux dossiers spéciaux : Bureau / Bibliothèques.")
'MSG_REPORT_ASK = array("Do you want to send a report with you comments via email?", "Voulez-vous envoyer un rapport d'installation avec vos commentaires ?")
MSG_VISIT_WEB = array("Click OK to visit home page [disabled]" & vbcr & MSG_URL_FULL & " . Thank you for your comments!", _
	"Vous allez être redirigé vers le site Web [desactivé]" & vbcr & MSG_URL_FULL & " . Merci pour vos commentaires !")
MSG_REPORT = array("REPORT", _
	"RAPPORT D'INSTALLATION / DESINSTALLATION")
MSG_COMMENTS = array("YOUR COMMENTS", _
	"VOS REMARQUES")
END_INSTALLATION = "" 'for init
'on error goto 0

class CommandPromptHereAndDirHere
	public application_name
	public application_comment
	Private Sub Class_Initialize()
		application_name = MSG_TITLECommandPromptHereAndDirHere(LANG)
	End Sub
	public function IsInstallable()
		IsInstallable = true
	end function
	public function IsInstalled()
		IsInstalled = not IsEmpty(ReadKey("HKEY_CLASSES_ROOT\Directory\shell\run0ListHere\command\"))
	end function
	public function Install()
		call NTListHereInstall
	end function
	public function Uninstall()
		x = array("Drive", "Directory"): y = array("run0ListHere", "run1ListHereSub", "run2CmdHere", "runas")
		for each i in x
			for each j in y
				if Not(IsEmpty(ReadKey("HKEY_CLASSES_ROOT\" & i & "\shell\" & j & "\"))) then
					call objshell.RegDelete("HKEY_CLASSES_ROOT\" & i & "\shell\" & j & "\command\")
					call objshell.RegDelete("HKEY_CLASSES_ROOT\" & i & "\shell\" & j & "\")
				end if
			next
		next
	end function
end class

'Début
if ReadKey("HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\EnableLUA") and not WScript.Arguments.length then
	'UAC ON et pas d'arguments au script
	Set objShell = CreateObject("Shell.Application")
	objShell.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName & Chr(34) & " uac", "", "runas", 1 'chr(34)=" ; start .vbs dangereux car pas forcément associé
else
	for each current_application in array( _
		new CommandPromptHereAndDirHere)
		if current_application.IsInstallable then
			if current_application.IsInstalled then
				if msgbox (MSG_TITLE_SOFTWARE & " " & MSG_TRANSITION & current_application.application_name & vbcr & MSG_UNINSTALL(LANG), vbOkCancel+vbExclamation, MSG_TITLE) = vbok then
					current_application.Uninstall
					END_INSTALLATION = END_INSTALLATION & MSG_TITLE_SOFTWARE & " " & MSG_TRANSITION & current_application.application_name & vbcr & MSG_UNINSTALLED(LANG) & vbcr & vbcr
					icon_end_install = vbExclamation
				end if
			else
				'if msgbox (MSG_INSTALL(LANG) & vbcr & "["&current_application.application_name&"] ?" & current_application.application_comment, vbyesno+vbquestion, MSG_TITLE) = vbyes then
					current_application.Install
					END_INSTALLATION = END_INSTALLATION & MSG_TITLE_SOFTWARE & " " & MSG_TRANSITION & current_application.application_name & vbcr & MSG_INSTALLED(LANG) & vbcr & vbcr & MSG_NOTICE(LANG) & vbcr & vbcr
					icon_end_install = vbInformation
				'end if
			end if
		end if
	next
	if msgbox(END_INSTALLATION & MSG_VISIT_WEB(LANG), vbokcancel+icon_end_install, MSG_TITLE) = vbok then 'X ou OK renvoient 1
		set wShell = CreateObject("Shell.Application")
		'wShell.Open MSG_URL_FULL '2020 04 19: no website anymore, temporary disabled #DEBUG
	end if
end if

private sub NTListHereInstall()
	EDITORS = array ( _
		array("WordPad", "%ProgramFiles%\Windows NT\Accessoires\wordpad.exe", "", " /A", "Windows Built-in", ""), _
		array("Notepad", "%WINDIR%\SYSTEM32\NOTEPAD.exe", "", " /U", "Windows Built-in", "")) '.txt not needed: Windows 2K/XP/2K3 ; 2=param sous l'éditeur ; 3=param sous cmd ; 5=extension
	for each EDITOR in EDITORS
		if fso.FileExists(objshell.ExpandEnvironmentStrings(EDITOR(1))) then
			EDITOR_REAL = EDITOR
			exit for
		end if
	next
	EDITOR_REAL=EDITORS(1) 'to force notepad
	LIST_HERE_MSG = MSG_TRANSITION & MSG_LIST_FILES_HERE(LANG) & MSG_NOTEPAD_NAME(LANG)
	LIST_HERE_ICON = "%SystemRoot%\System32\pifmgr.dll,-20"
	LIST_HERE_SUB_MSG = MSG_TRANSITION & MSG_LIST_FILES_HERE_SUB(LANG) & MSG_NOTEPAD_NAME(LANG)
	LIST_HERE_SUB_ICON = "%SystemRoot%\System32\mmcndmgr.dll,16"
	CMD_HERE_ICON = "%windir%\system32\cmd.exe"
	CMD_HERE_ADMIN_ICON = "%SystemRoot%\System32\pifmgr.dll,-1"
	'icons:	%systemroot%\system32\imageres.dll
	'icons:	%SystemRoot%\System32\mmcndmgr.dll,16
	'icons: %SystemRoot%\System32\pifmgr.dll,-1
	'icons: %SystemRoot%\System32\moreicons.dll,-2
	'icons: %SystemRoot%\System32\mmcndmgr.dll,-15
	DESTINATION_FILE = "%%TEMP%%\" & DIR_HERE_TITLE & EDITOR_REAL(5) '& "11" "%%RANDOM%%" "%%time:~-2%%"
	FULL_DESTINATION_FILE = """" & DESTINATION_FILE & """"
	SUB_COMMAND_NEWLINE = "&echo."
	SUB_COMMAND_05 = objshell.ExpandEnvironmentStrings("%ComSpec%") '%%ComSpec%% à la place de cmd.exe ne fonctionne pas / en démarrant par start.exe, l'application est introuvable, CMD obligatoire
	SUB_COMMAND_08 = "&color CF"
	SUB_COMMAND_10 = "&title " & MSG_TITLE_SOFTWARE & " " & MSG_VERSION & MSG_SEPARATOR_TRANSITION & "Command Prompt"
	SUB_COMMAND_12 = "&echo " & MSG_LOADING(LANG)
	SUB_COMMAND_15 = "&set OS=%%RANDOM%%"'%L&set TOTO=%TOTO:~3,3%"
	SUB_COMMAND_20 = "&dir ""%L"" /ad /b /on>>" & FULL_DESTINATION_FILE
	SUB_COMMAND_21 = "&dir ""%L"" /ad /b /s /on>>" & FULL_DESTINATION_FILE 'sub folders
	SUB_COMMAND_NEWLINE_FILE = SUB_COMMAND_NEWLINE & ">>" & FULL_DESTINATION_FILE
	SUB_COMMAND_30 = "&dir ""%L"" /a-d /b /on>>" & FULL_DESTINATION_FILE
	SUB_COMMAND_31 = "&dir ""%L"" /a-d /b /s /on>>" & FULL_DESTINATION_FILE 'sub folders
	SUB_COMMAND_CLEARSCREEN = "&cls"
	SUB_COMMAND_37 = "&color 2F"
	SUB_COMMAND_38 = "&echo " & MSG_LOADED_10(LANG) & _
		SUB_COMMAND_NEWLINE & _
		"&echo " & MSG_LOADED_12(LANG) & _
		"&echo " & MSG_LOADED_13(LANG) & _
		"&echo " & MSG_LOADED_14(LANG) & _
		"&echo " & MSG_LOADED_15(LANG) & _
		SUB_COMMAND_NEWLINE & _
		"&echo " & MSG_LOADED_20(LANG) & _
		"&echo " & MSG_LOADED_30(LANG) & _
		SUB_COMMAND_NEWLINE & _
		"&echo " & MSG_LOADED_32 & _
		"&echo " & MSG_LOADED_33 & _
		"&echo " & MSG_LOADED_34 & _
		SUB_COMMAND_NEWLINE & _
		"&echo " & MSG_LOADED_37(LANG) & _
		"&echo " & MSG_LOADED_38(LANG) & _
		"&echo " & MSG_LOADED_40(LANG)
	SUB_COMMAND_45 = "&start """" /wait """ & objshell.ExpandEnvironmentStrings(EDITOR_REAL(1)) & """" & EDITOR_REAL(2) & " " & FULL_DESTINATION_FILE
	SUB_COMMAND_50 = "&del " & FULL_DESTINATION_FILE
	LIST_HERE_DATA = SUB_COMMAND_05 & EDITOR_REAL(3) & " /C ""cls" & SUB_COMMAND_08 & SUB_COMMAND_10 & SUB_COMMAND_12 & "1/3" & SUB_COMMAND_15 & SUB_COMMAND_20 & SUB_COMMAND_CLEARSCREEN & SUB_COMMAND_12 & "2/3" & SUB_COMMAND_NEWLINE_FILE & SUB_COMMAND_30 & SUB_COMMAND_CLEARSCREEN & SUB_COMMAND_37 & SUB_COMMAND_38 & SUB_COMMAND_45 & SUB_COMMAND_50 & """"
	LIST_HERE_SUB_DATA = SUB_COMMAND_05 & EDITOR_REAL(3) & " /C ""cls" & SUB_COMMAND_08 & SUB_COMMAND_10 & SUB_COMMAND_12 & "1/3" & SUB_COMMAND_15 & SUB_COMMAND_21 & SUB_COMMAND_CLEARSCREEN & SUB_COMMAND_12 & "2/3" & SUB_COMMAND_NEWLINE_FILE & SUB_COMMAND_31 & SUB_COMMAND_CLEARSCREEN & SUB_COMMAND_37 & SUB_COMMAND_38 & SUB_COMMAND_45 & SUB_COMMAND_50 & """"
	CMD_HERE_DATA = SUB_COMMAND_05 & " /T:0E /F:ON /K ""ver" & SUB_COMMAND_10 & "&cd /D ""%L""""" '/D is required since Windows Vista (to change also letter drive)
	'Windows 7 ; HKEY_CLASSES_ROOT\LibraryFolder : works
	'%L="::{031E4825-7B94-4DC3-B131-E946B44C8DD5}\Documents.library-ms"
	'%L="::{031E4825-7B94-4DC3-B131-E946B44C8DD5}\Music.library-ms"
	'%L="::{031E4825-7B94-4DC3-B131-E946B44C8DD5}\Pictures.library-ms"
	'%L="::{031E4825-7B94-4DC3-B131-E946B44C8DD5}\Videos.library-ms"
	'HKEY_CLASSES_ROOT\DesktopBackground : error : "This file does not have a program associated with it for performing this action."
	
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Directory\shell\run0ListHere\", LIST_HERE_MSG, "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Directory\shell\run0ListHere\Icon", LIST_HERE_ICON, "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Directory\shell\run0ListHere\command\", LIST_HERE_DATA, "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Drive\shell\run0ListHere\", LIST_HERE_MSG, "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Drive\shell\run0ListHere\Icon", LIST_HERE_ICON, "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Drive\shell\run0ListHere\command\",LIST_HERE_DATA, "REG_SZ")

	call objshell.RegWrite("HKEY_CLASSES_ROOT\Directory\shell\run1ListHereSub\", LIST_HERE_SUB_MSG, "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Directory\shell\run1ListHereSub\Icon", LIST_HERE_SUB_ICON, "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Directory\shell\run1ListHereSub\command\", LIST_HERE_SUB_DATA, "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Drive\shell\run1ListHereSub\", LIST_HERE_SUB_MSG, "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Drive\shell\run1ListHereSub\Icon", LIST_HERE_SUB_ICON, "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Drive\shell\run1ListHereSub\command\", LIST_HERE_SUB_DATA, "REG_SZ")

	call objshell.RegWrite("HKEY_CLASSES_ROOT\Directory\shell\run2CmdHere\", MSG_TRANSITION & CMD_HERE_MSG(LANG), "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Directory\shell\run2CmdHere\Icon", CMD_HERE_ICON, "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Directory\shell\run2CmdHere\command\", CMD_HERE_DATA, "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Drive\shell\run2CmdHere\", MSG_TRANSITION & CMD_HERE_MSG(LANG), "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Drive\shell\run2CmdHere\Icon", CMD_HERE_ICON, "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Drive\shell\run2CmdHere\command\", CMD_HERE_DATA, "REG_SZ")
	'by default, runas is dedicated to run as administrator
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Directory\shell\runas\", MSG_TRANSITION & CMD_HERE_ADMIN_MSG(LANG), "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Directory\shell\runas\Icon", CMD_HERE_ADMIN_ICON, "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Directory\shell\runas\command\", CMD_HERE_DATA, "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Drive\shell\runas\", MSG_TRANSITION & CMD_HERE_ADMIN_MSG(LANG), "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Drive\shell\runas\Icon", CMD_HERE_ADMIN_ICON, "REG_SZ")
	call objshell.RegWrite("HKEY_CLASSES_ROOT\Drive\shell\runas\command\", CMD_HERE_DATA, "REG_SZ")
end sub

private Function GetLang() 'return OS lang only
	strComputer = "."
	Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
	Set colItems = objWMIService.ExecQuery("Select * From Win32_OperatingSystem")
	GetLang = 0
	For Each objItem in colItems 
		Select Case objItem.OSLanguage 
			Case 1 strLang = "Arabic" 
			Case 4 strLang = "Chinese (Simplified) - China" 
			Case 9 strLang = "English" 
			Case 1025 strLang = "Arabic - Saudi Arabia" 
			Case 1026 strLang = "Bulgarian" 
			Case 1027 strLang = "Catalan" 
			Case 1028 strLang = "Chinese (Traditional) - Taiwan" 
			Case 1029 strLang = "Czech" 
			Case 1030 strLang = "Danish" 
			Case 1031 strLang = "German - Germany" 
			Case 1032 strLang = "Greek" 
			Case 1033 strLang = "English - United States"
			Case 1034 strLang = "Spanish - Traditional Sort" 
			Case 1035 strLang = "Finnish" 
			Case 1036 strLang = "French - France" 
			Case 1037 strLang = "Hebrew" 
			Case 1038 strLang = "Hungarian" 
			Case 1039 strLang = "Icelandic" 
			Case 1040 strLang = "Italian - Italy" 
			Case 1041 strLang = "Japanese" 
			Case 1042 strLang = "Korean" 
			Case 1043 strLang = "Dutch - Netherlands" 
			Case 1044 strLang = "Norwegian - Bokmal" 
			Case 1045 strLang = "Polish" 
			Case 1046 strLang = "Portuguese - Brazil" 
			Case 1047 strLang = "Rhaeto-Romanic" 
			Case 1048 strLang = "Romanian" 
			Case 1049 strLang = "Russian" 
			Case 1050 strLang = "Croatian" 
			Case 1051 strLang = "Slovak" 
			Case 1052 strLang = "Albanian" 
			Case 1053 strLang = "Swedish" 
			Case 1054 strLang = "Thai" 
			Case 1055 strLang = "Turkish" 
			Case 1056 strLang = "Urdu" 
			Case 1057 strLang = "Indonesian" 
			Case 1058 strLang = "Ukrainian" 
			Case 1059 strLang = "Belarusian" 
			Case 1060 strLang = "Slovenian" 
			Case 1061 strLang = "Estonian" 
			Case 1062 strLang = "Latvian" 
			Case 1063 strLang = "Lithuanian" 
			Case 1065 strLang = "Persian" 
			Case 1066 strLang = "Vietnamese" 
			Case 1069 strLang = "Basque" 
			Case 1070 strLang = "Serbian" 
			Case 1071 strLang = "Macedonian (FYROM)" 
			Case 1072 strLang = "Sutu" 
			Case 1073 strLang = "Tsonga" 
			Case 1074 strLang = "Tswana" 
			Case 1076 strLang = "Xhosa" 
			Case 1077 strLang = "Zulu" 
			Case 1078 strLang = "Afrikaans" 
			Case 1080 strLang = "Faeroese" 
			Case 1081 strLang = "Hindi" 
			Case 1082 strLang = "Maltese" 
			Case 1084 strLang = "Gaelic" 
			Case 1085 strLang = "Yiddish" 
			Case 1086 strLang = "Malay - Malaysia" 
			Case 2049 strLang = "Arabic - Iraq" 
			Case 2052 strLang = "Chinese (Simplified) - PRC" 
			Case 2055 strLang = "German - Switzerland" 
			Case 2057 strLang = "English - United Kingdom" 
			Case 2058 strLang = "Spanish - Mexico" 
			Case 2060 strLang = "French - Belgium" 
			Case 2064 strLang = "Italian - Switzerland" 
			Case 2067 strLang = "Dutch - Belgium" 
			Case 2068 strLang = "Norwegian - Nynorsk" 
			Case 2070 strLang = "Portuguese - Portugal" 
			Case 2072 strLang = "Romanian - Moldova" 
			Case 2073 strLang = "Russian - Moldova" 
			Case 2074 strLang = "Serbian - Latin" 
			Case 2077 strLang = "Swedish - Finland" 
			Case 3073 strLang = "Arabic - Egypt" 
			Case 3076 strLang = "Chinese (Traditional) - Hong Kong SAR" 
			Case 3079 strLang = "German - Austria" 
			Case 3081 strLang = "English - Australia" 
			Case 3082 strLang = "Spanish - International Sort" 
			Case 3084 strLang = "French - Canada" 
			Case 3098 strLang = "Serbian - Cyrillic" 
			Case 4097 strLang = "Arabic - Libya" 
			Case 4100 strLang = "Chinese (Simplified) - Singapore" 
			Case 4103 strLang = "German - Luxembourg" 
			Case 4105 strLang = "English - Canada" 
			Case 4106 strLang = "Spanish - Guatemala" 
			Case 4108 strLang = "French - Switzerland" 
			Case 5121 strLang = "Arabic - Algeria" 
			Case 5127 strLang = "German - Liechtenstein" 
			Case 5129 strLang = "English - New Zealand" 
			Case 5130 strLang = "Spanish - Costa Rica" 
			Case 5132 strLang = "French - Luxembourg" 
			Case 6145 strLang = "Arabic - Morocco" 
			Case 6153 strLang = "English - Ireland" 
			Case 6154 strLang = "Spanish - Panama" 
			Case 7169 strLang = "Arabic - Tunisia" 
			Case 7177 strLang = "English - South Africa" 
			Case 7178 strLang = "Spanish - Dominican Republic" 
			Case 8193 strLang = "Arabic - Oman" 
			Case 8201 strLang = "English - Jamaica" 
			Case 8202 strLang = "Spanish - Venezuela" 
			Case 9217 strLang = "Arabic - Yemen" 
			Case 9226 strLang = "Spanish - Colombia" 
			Case 10241 strLang = "Arabic - Syria" 
			Case 10249 strLang = "English - Belize" 
			Case 10250 strLang = "Spanish - Peru" 
			Case 11265 strLang = "Arabic - Jordan" 
			Case 11273 strLang = "English - Trinidad" 
			Case 11274 strLang = "Spanish - Argentina" 
			Case 12289 strLang = "Arabic - Lebanon" 
			Case 12298 strLang = "Spanish - Ecuador" 
			Case 13313 strLang = "Arabic - Kuwait" 
			Case 13322 strLang = "Spanish - Chile" 
			Case 14337 strLang = "Arabic - U.A.E." 
			Case 14346 strLang = "Spanish - Uruguay" 
			Case 15361 strLang = "Arabic - Bahrain" 
			Case 15370 strLang = "Spanish - Paraguay" 
			Case 16385 strLang = "Arabic - Qutar" 
			Case 16394 strLang = "Spanish - Bolivia" 
			Case 17418 strLang = "Spanish - El Salvador" 
			Case 18442 strLang = "Spanish - Honduras" 
			Case 19466 strLang = "Spanish - Nicaragua" 
			Case 20490 strLang = "Spanish - Puerto Rico" 
			Case Else strLang = objItem.OSLanguage
		End Select
	Next
	'MsgBox strLang
end function

private function ReadKey(keyValue)
	on error resume next
	ReadKey = objshell.RegRead(keyValue)
	on error goto 0
end function

'' SIG '' Begin signature block
'' SIG '' MIIDKQYJKoZIhvcNAQcCoIIDGjCCAxYCAQExDjAMBggq
'' SIG '' hkiG9w0CBQUAMGYGCisGAQQBgjcCAQSgWDBWMDIGCisG
'' SIG '' AQQBgjcCAR4wJAIBAQQQTvApFpkntU2P5azhDxfrqwIB
'' SIG '' AAIBAAIBAAIBAAIBADAgMAwGCCqGSIb3DQIFBQAEEA0F
'' SIG '' XJYLd0k8EhI/etuA3SGgggGTMIIBjzCCATmgAwIBAgIQ
'' SIG '' kFDTSxAAoaIR1DKaQiUeEDANBgkqhkiG9w0BAQQFADAX
'' SIG '' MRUwEwYDVQQDEwxFcmljIExpcHBlcnQwHhcNMDAwMTAx
'' SIG '' MDcwMDAwWhcNMDYwMTAxMDcwMDAwWjAXMRUwEwYDVQQD
'' SIG '' EwxFcmljIExpcHBlcnQwXDANBgkqhkiG9w0BAQEFAANL
'' SIG '' ADBIAkEA3VIzvDbRfyssTEP+KJ1tO8e2/4Et3ZKK23gH
'' SIG '' GlIBlUJ6ss3Ro7GyILOWZCL+33NGpYQKL7mYZ+p5xSjc
'' SIG '' tQNYPwIDAQABo2EwXzATBgNVHSUEDDAKBggrBgEFBQcD
'' SIG '' AzBIBgNVHQEEQTA/gBAOsjyOexvxG/OkX9N6F8eMoRkw
'' SIG '' FzEVMBMGA1UEAxMMRXJpYyBMaXBwZXJ0ghCQUNNLEACh
'' SIG '' ohHUMppCJR4QMA0GCSqGSIb3DQEBBAUAA0EAYhQpLNPx
'' SIG '' ab25g+3RdIKkSYiRKTUSeSpOVSsCEFVzZON8D93HYCAN
'' SIG '' Wc+5ZhsKvs/U2/J50yXsxdLeRBqGWstuqDGCAQAwgf0C
'' SIG '' AQEwKzAXMRUwEwYDVQQDEwxFcmljIExpcHBlcnQCEJBQ
'' SIG '' 00sQAKGiEdQymkIlHhAwDAYIKoZIhvcNAgUFAKBsMBAG
'' SIG '' CisGAQQBgjcCAQwxAjAAMBkGCSqGSIb3DQEJAzEMBgor
'' SIG '' BgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEE
'' SIG '' AYI3AgEVMB8GCSqGSIb3DQEJBDESBBDKAv0x3ULOrAx+
'' SIG '' Uo3S9F8cMA0GCSqGSIb3DQEBAQUABEDF2tdMhRr8xzKi
'' SIG '' cFi45A+xB2/zRLtmVXCywfR42J29m6ybYP+CjIQtNxS0
'' SIG '' naHd+wxLsLJwDXGq9BjGpuUPtuz9
'' SIG '' End signature block