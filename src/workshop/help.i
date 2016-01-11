/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/* workshop/help.i */
&IF FALSE &THEN
/*
*****************************************************
* This include file defines the help                *
* context strings that the WorkShop uses to         *
* display help topics from the HTML file:           *
*     webspeed/doc/workshop/<context>               * 
* Please contact documentation to                   *
* make changes to this file. Thanks.                *
*                                                   *
* The form used in this file is:                    *
*                                                   *
* <Name of the Help Topic>                          *
*  &Global-define <context-string> <file-name>      *
*****************************************************
*/
&ENDIF

/* Main Contents for WebSpeed Documentation -
User chooses the Help button at Welcome screen */
&GLOBAL-DEFINE Doc_Contents docindex.htm

/* User chooses the Tool button at Welcome screen */
&GLOBAL-DEFINE Web_Tools_Help webtools.htm

/* File Menu Bar: All files */
&GLOBAL-DEFINE File_Menu_Bar_Help filemenu.htm   

/* File/New: Choose a template */
&GLOBAL-DEFINE File_New_Help newfile.htm

/* Workshop HTML Mapping: Choose a template */
&GLOBAL-DEFINE HTML_Mapping_Help htmlmap.htm

/* Workshop Preferences: Set preferences */
&GLOBAL-DEFINE File_Preferences_Help prefs.htm

/* Workshop Property Sheet Help */
&GLOBAL-DEFINE Property_Sheet_Help property.htm

/* Workshop Project (a.k.a. Files) index */
&GLOBAL-DEFINE Project_Index_Help project.htm

/* Section Editor document (containing SE Applet).
   NOTE: This is also called directly from the Section Editor where the link is HARD-CODED.
   Changing the html file here WILL NOT AUTOMATICALLY BE PROPAGATED TO THE BUILD !!!
 */
&GLOBAL-DEFINE Section_Editor_Help sected.htm

/* New Section Dialog Box - Section Editor */
&GLOBAL-DEFINE New_Section_DB newsecdb.htm

/* Find Dialog Box - Section Editor */
&GLOBAL-DEFINE Find_DB finddb.htm

/* Replace Dialog Box - Section Editor */
&GLOBAL-DEFINE Replace_DB replcedb.htm

/* Insert Call Dialog Box - Section Editor */
&GLOBAL-DEFINE Insert_Call_DB incalldb.htm

/* File/Check Syntax: Check the syntax of a file - */
&GLOBAL-DEFINE Check_Syntax_Help filemenu.htm#Check

/* File/Delete: Ask user if they want to delete a file - */
&GLOBAL-DEFINE File_Delete_Help filemenu.htm#Delete 

/* File/View: view a document -- */
&GLOBAL-DEFINE File_View_Help filemenu.htm#View

/* File/Save: "Save As" document - ask user to enter new save name. */
&GLOBAL-DEFINE Save_As_Help filemenu.htm#SaveAs

/* File/Save: "Saving" document - */
&GLOBAL-DEFINE Saving_File_Help filemenu.htm#Save

/* NEW ITEMS ADDED AFTER BETA1
   --  bill wood (4/2/97) */

/* Opened Files: List all files open and/or modified in WorkShop */
&GLOBAL-DEFINE Opened_Files_Help openfile.htm

/* Procedure Settings: Settings and options for a .p/.w/.i */
&GLOBAL-DEFINE Procedure_Settings_Help procset.htm

/* Method Libraries: Included libraries for .p/.w/.i files */
&GLOBAL-DEFINE Method_Libraries_Help methlib.htm

/* help.i - end of file */
