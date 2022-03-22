/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: widthvar.i

Description:
   Definitions for _sqlwidt.p, the field with browser for SQL-92 client.
   
Author: Mario Brunetti

Date Created: 02/16/99
    Modified: 05/28/99 Mario B.  Made query dynamic.  Added code to prevent
                       unnecessary screen re-draw.  
              07/01/99 Mario B. Fine tuning + add SwitchTable button
    	      07/28/99 Mario B. Support for array data types. BUG 19990716-033.
	      10/14/99 Mario B. 2k width limit now 31995. BUG 19990825-005.
              06/09/00 D. McMann Added open of query to surpress 3159 error 
----------------------------------------------------------------------------*/
DEFINE {1} TEMP-TABLE t_Field LIKE _Field. 

DEFINE {1} BUFFER w_Field FOR t_Field.

/* This is a dummy placeholder for a dynamic query.    */
DEFINE {1} QUERY qry-width FOR w_Field SCROLLING.
OPEN QUERY qry-width FOR EACH w_field.

DEFINE {1}    VARIABLE qry-width-hdl AS WIDGET-HANDLE NO-UNDO.
DEFINE {1}    VARIABLE b-test        AS LOGICAL       NO-UNDO.

DEFINE {1} BROWSE brw-width QUERY qry-width
   DISPLAY w_Field._Field-Name w_Field._Width w_Field._Format
   ENABLE w_Field._Width 
WITH 
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   12 DOWN 
&ELSE
   15 DOWN   
&ENDIF   
   SEPARATORS. 

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN

/* These constants are defined in the GUI Dict, but not avail in char.  *
 * Needed to be defined so that we could share the code.                */
&SCOPED-DEFINE VM_WID 0
&SCOPED-DEFINE VM_WIDG 0
&SCOPED-DEFINE IVM_OKBOX 0
&SCOPED-DEFINE HM_DBTN 1
&SCOPED-DEFINE HM_DBTNG 1
&SCOPED-DEFINE HFM_OKBOX 0
&SCOPED-DEFINE VM_OKBOX 0

/* Allows exit with END-ERROR and cancel, but doesn't apply it so as to *
 * not undo all previous saves.  Enables sharing of code between GUI    *
 * and char dictionary.                                                 */
DEF VAR s_ExitNoSave AS LOG NO-UNDO. 
DEF VAR s_NoPrivMsg AS CHAR NO-UNDO
   init "You do not have permission to".
DEF VAR saveCurr AS LOG     NO-UNDO INIT TRUE.
DEF VAR rowsModified AS LOG NO-UNDO INIT FALSE.

DEFINE BUTTON s_btn_OK LABEL "OK" AUTO-GO.
DEFINE BUTTON s_btn_Save LABEL "Save".
DEFINE BUTTON s_btn_Close LABEL "Close".
DEFINE BUTTON s_btn_Help LABEL "Help".
DEFINE BUTTON s_btn_Switch LABEL "SwitchTable".

DEFINE {1} FRAME frm-width
   brw-width 
   {adecomm/okform.i 
      &STATUS = NO
      &AT_OKBTN = "AT 24"
      &OK     = s_btn_OK 
      &OTHER  = "s_btn_Close SPACE(2) s_btn_Switch"
      &CANCEL = s_btn_Save      
      }
WITH FRAME frm-width 
     1 DOWN 
     WIDTH 82 
     NO-BOX 
     KEEP-TAB-ORDER 
     SIDE-LABELS 
     OVERLAY.
&ELSE           /*----- GUI Frame Layout and Other Defintions -----*/
DEF {1} VAR s_StatusLineHdl  AS HANDLE    NO-UNDO.
DEF {1} VAR s_StatusLineFlds AS INT       NO-UNDO.
DEF {1} VAR s_PreviousSort   AS INT       NO-UNDO.
DEF {1} VAR s_PreviousTbl    AS CHAR      NO-UNDO.
DEFINE {1} FRAME frm-width
   SKIP({&VM_WIDG})
   brw-width SKIP({&VM_WID}) 
   {adecomm/okform.i 
      &STATUS = NO 
      &OK     = s_btn_OK
      &OTHER  = "SPACE({&HM_DBTN}) 
                s_btn_Close SPACE({&HM_DBTNG}) 
                s_btn_Prev  SPACE({&HM_DBTN})
                s_btn_Next"
      &CANCEL = "s_btn_Save"
      &HELP   = s_btn_Help} 
      SKIP(.33) 
WITH FRAME frm-width 
     1 DOWN 
     WIDTH 83 
     NO-BOX 
     KEEP-TAB-ORDER 
     SIDE-LABELS.
&ENDIF

