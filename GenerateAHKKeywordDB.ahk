#CommentFlag ;
#Warn, All, OutputDebug
#NoEnv
#SingleInstance force
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1

gCurrentVersion := "0.0.3"
gOpt := {}
gOpt.DbFilename := A_ScriptDir "\AHKKeywords.sqlite"
gOpt.DB := ""

gOpt.AHKSources := {}

gOpt.AHKSources.basepath := A_Scriptdir "\..\AutoHotkey_L\source"
gOpt.AHKSources.files := {}
gOpt.AHKSources.files.version := gOpt.AHKSources.basepath "\ahkversion.h"

; AHK-Sourcefiles to be parsed

#Include <DBA>
/* *****************************************************************************
	Title: GenerateAHKKeywordDB.ahk
		Generate a sqlite-Database containing keywords of AutoHotkey

	Author: 
	hoppfrosch

	Credits: 
	DBA - IsNull (https://github.com/IsNull/ahkDBA)
		
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

try {
	DB := DBA.DataBaseFactory.OpenDataBase("SQLite", gOpt.DBFilename)
}
catch e {
	MsgBox,16, Error, % "Failed to create connection. Check your Connection string and DB Settings!`n`n" ExceptionDetail(e)
	ExitApp
}

version := ParseAHKVersion(gOpt.AHKSources.files.version)
record := {}
record.version := version
DB.Insert(record, "ahkversions")

if(IsObject(DB))
	DB.Close()

ExitApp

;-------------------------------------------------------------------------------
; 	Parse AHK version from sources
;
; 	Parameter: 
;		source - filename of source of AHK version
;	Returns:
;		AHK-version as String
ParseAHKVersion(sourcefile) {
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
