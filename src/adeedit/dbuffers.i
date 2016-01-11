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
. /* END-WORKFILE */

DEFINE VARIABLE Buffers_Open AS INTEGER NO-UNDO.



