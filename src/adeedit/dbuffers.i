/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  dbuffers.i
  Buffer Defines for Editor 
--------------------------------------------------------------------------*/

DEFINE WORKFILE Edit_Window NO-UNDO
  FIELD hWindow AS WIDGET-HANDLE
  FIELD Current_Buffer AS WIDGET-HANDLE
. /* END-WORKFILE */
  
DEFINE WORKFILE Edit_Buffer NO-UNDO
  FIELD hWindow   AS WIDGET-HANDLE
  FIELD hBuffer   AS WIDGET-HANDLE
  /* Stores full file name (OS-SEARCH(FILENAME)) of original file name buffer was read from. */
  FIELD File_Name AS CHARACTER FORMAT "x(40)"  LABEL "File Name"
  /* Stores hBuffer:PRIVATE-DATA - ie, Buffer File Name. */
  FIELD Buffer_Name AS CHARACTER FORMAT "x(40)" LABEL "Buffer Name"
  FIELD Read_Only     AS LOGICAL LABEL "Read-only" VIEW-AS TOGGLE-BOX
  FIELD Auto_Indent  AS LOGICAL LABEL "Auto-indent" VIEW-AS TOGGLE-BOX
  FIELD Cursor_Line  AS INTEGER FORMAT ">>>>9" LABEL "Line"
  FIELD Cursor_Char  AS INTEGER FORMAT ">>>>9" LABEL "Column"
  FIELD Font_Num     AS INTEGER LABEL "Font"
  FIELD Length AS INTEGER FORMAT ">>>>>>9" LABEL "Bytes"
  FIELD Modified  AS LOGICAL LABEL "Modified" FORMAT "Yes/No"
  FIELD Obj-ID    AS INTEGER                /* ADE Object ID */
  FIELD Compile_Name AS CHARACTER FORMAT "x(40)"  LABEL "Compile Name"
  FIELD Class_Type  AS CHARACTER FORMAT "x(40)" LABEL "Class Type" INIT ?
  FIELD Class_TmpDir AS CHARACTER FORMAT "x(40)" LABEL "Class Dir" INIT ?
. /* END-WORKFILE */

DEFINE VARIABLE Buffers_Open AS INTEGER NO-UNDO.



