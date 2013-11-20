 #CommentFlag ;
 #Warn, All, OutputDebug

gCurrentVersion := "0.5.0"
gDbFilename := A_ScriptDir "\AHKKeywords.sqlite"

/*
	Title: GenerateAHKKeywordDB.ahk
		Generate a sqlite-Database containing keywords of AutoHotkey

	Author: 
	hoppfrosch

	Credits: 
		
	License: 
	WTFPL (http://sam.zoy.org/wtfpl/)
		
*/

; Do Preparation-work
CopyTemplateDB()

;-------------------------------------------------------------------------------
; 	Copy the template DB to the working DB
;
; 	Parameter: 
;		forceOverwrite - Overwrite working DB unless it already exists
CopyTemplateDB(forceOverwrite:=0){
	Global gDbFilename
	templatedb := A_ScriptDir "\Template\AHKKeywords.sqlite"

	; Copy empty database - if it doesn't exist
	if (!FileExist(gDbFilename) || forceOverwrite = 1) {
		if(FileExist(gDbFilename)) {
			FileDelete, % gDbFilename
		}
		FileCopy , % templatedb, % gDbFilename
	}
	return
}
