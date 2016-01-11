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
**********************************************************************/ 
/****************************************************************************
Procedure: adeuib/_adeuib.p

Syntax:
    RUN adeuib/_adeuib.p ( p_Object_ID_List ).

Purpose:          
    An ADE Tool uses this module to pass a list of one or more ADE 
    Objects the Tool wants the AppBuilder to open for editing.

Description:
    The Tool passes the ADE Objects to open as a comma-delimited list of
    Object ID's ( p_Obj_ID_List ).

INPUT Parameters
    p_Object_ID_List (CHARACTER)
        Comma-delimited list of ADE Object IDs for the AppBuilder to open 
        for editing.  Each Object ID corresponds to one or more physical
        operating system files the AppBuilder will open for editing.  

Author: Ross Hunter

Created: 9/29/92 

*********************************************************************/

/* ADE Object ID List. */
DEFINE INPUT PARAMETER p_Object_ID_List AS CHARACTER NO-UNDO.

DEFINE VARIABLE File_List       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE List_Item       AS INTEGER    NO-UNDO.  
DEFINE VARIABLE Obj_FileList    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE Obj_FileSpec    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE Obj_Id          AS INTEGER    NO-UNDO.

STOP_BLOCK:
DO ON STOP UNDO STOP_BLOCK, RETRY STOP_BLOCK 
   ON ENDKEY UNDO STOP_BLOCK, RETRY STOP_BLOCK 
   ON ERROR UNDO STOP_BLOCK, RETRY STOP_BLOCK :
   
  IF RETRY THEN DO:
    PAUSE.
    LEAVE STOP_BLOCK.
  END.

  DO List_Item = 1 TO NUM-ENTRIES( p_Object_ID_List ) :
    /* ADE Object IDs are integers. */
    Obj_Id = INTEGER( ENTRY( List_Item , p_Object_ID_List ) ) .
 
    /* objfile, given an object id, returns a comma-delimited list of
       os files the editor will open for editing. */
    RUN adeamgr/objfile.p ( Obj_Id , OUTPUT Obj_FileSpec ) .
  
    /* If the object has no OS file(s) associated with it, don't open. */
    IF Obj_Filespec <> "" THEN /* Build comma delimited File list. */
      Obj_FileList = Obj_FileList + Obj_FileSpec +
                     (IF List_Item < NUM-ENTRIES( p_Object_ID_List ) 
                      THEN "," ELSE "").
  END.
 
  /* Run PROGRESS Editor with list of files to open for editing. */
  RUN adeuib/_uibmain.p ( Obj_FileList ) .

END.

IF PROGRAM-NAME(2) = ? THEN QUIT.
ELSE RETURN.

/* _adeuib.p - end of file */
