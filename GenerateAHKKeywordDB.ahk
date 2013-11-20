#CommentFlag ;
#Warn, All, OutputDebug
#NoEnv
#SingleInstance force
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1

gCurrentVersion := "0.0.1"
gDbFilename := A_ScriptDir "\AHKKeywords.sqlite"
gDB := ""

#Include <Class_SQLiteDB>
/* *****************************************************************************
	Title: GenerateAHKKeywordDB.ahk
		Generate a sqlite-Database containing keywords of AutoHotkey

	Author: 
	hoppfrosch

	Credits: 
	Class-SQLiteDB - https://gist.github.com/AHK-just-me/4633751
		
	License: 
	WTFPL (http://sam.zoy.org/wtfpl/) - 
	*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
	Please consider that the license is only valid for this script itself. 
	Used Libs might have another license!!!
	*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
********************************************************************************
*/

; Do Preparation-work
CopyTemplateDB()

gDB := new SQLiteDB
If !gDB.OpenDB(gDbFilename) {
	MsgBox, 16, SQLite Error, % "Msg:`t" . gDB.ErrorMsg . "`nCode:`t" . gDB.ErrorCode
	ExitApp
}


If !gDB.CloseDB() {
	MsgBox, 16, SQLite Error, % "Msg:`t" . gDB.ErrorMsg . "`nCode:`t" . gDB.ErrorCode
}
ExitApp

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
