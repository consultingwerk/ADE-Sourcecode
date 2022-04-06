/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
