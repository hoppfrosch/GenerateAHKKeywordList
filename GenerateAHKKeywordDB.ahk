#CommentFlag ;
#Warn, All, OutputDebug
#NoEnv
#SingleInstance force
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1

gCurrentVersion := "0.0.2"
gOpt := {}
gOpt.DbFilename := A_ScriptDir "\AHKKeywords.sqlite"
gOpt.DB := ""

gOpt.AHKSources := {}

gOpt.AHKSources.basepath := A_Scriptdir "\..\AutoHotkey_L\source"
gOpt.AHKSources.files := {}
gOpt.AHKSources.files.version := gOpt.AHKSources.basepath "\ahkversion.h"

; AHK-Sourcefiles to be parsed

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
CopyTemplateDB(1)

DB := new SQLiteDB
gOpt.DB := DB
If !DB.OpenDB(gOpt.DBFilename) {
	MsgBox, 16, SQLite Error, % "Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode
	ExitApp
}

version := ParseAHKVersion(gOpt.AHKSources.files.version)
DB.Exec("BEGIN TRANSACTION;")
SQL := "INSERT INTO ahkversions VALUES(1,'" version "');"
MsgBox % SQL
If !DB.Exec(SQL)
   MsgBox, 16, SQLite Error, % "Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode  	
DB.Exec("COMMIT TRANSACTION;")


If !DB.CloseDB() {
	MsgBox, 16, SQLite Error, % "Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode
}
ExitApp

;-------------------------------------------------------------------------------
; 	Parse AHK version from sources
;
; 	Parameter: 
;		source - filename of source of AHK version
;	Returns:
;		AHK-version as String
ParseAHKVersion(sourcefile) {

	x := CallStack(10,0)
	version := ""
	file := FileOpen(sourcefile, "r") ; read the file ("r"), share all access except for delete ("-d")
	if !IsObject(file)
	{
		MsgBox % "Can't open " FileName " for reading."
		return version
	}
	while (Line := File.ReadLine()) {
		FoundPos := RegexMatch(Line, "O)\s*AHK_VERSION\s*\""(.*)\""", Match)
		if (FoundPos > 0)  {
			version := Match.value(1)
			Break
		}
	}
	file.Close()

	return version
}

;-------------------------------------------------------------------------------
; 	Copy the template DB to the working DB
;
; 	Parameter: 
;		forceOverwrite - Overwrite working DB unless it already exists
CopyTemplateDB(forceOverwrite:=0){
	Global gOpt
	templatedb := A_ScriptDir "\Template\AHKKeywords.sqlite"

	; Copy empty database - if it doesn't exist
	if (!FileExist(gOpt.DbFilename) || forceOverwrite = 1) {
		if(FileExist(gOpt.DbFilename)) {
			FileDelete, % gOpt.DbFilename
		}
		FileCopy , % templatedb, % gOpt.DbFilename
	}
	return
}
