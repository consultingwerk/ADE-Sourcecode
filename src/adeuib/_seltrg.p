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
&SCOPED-DEFINE WINDOW-NAME f_sections
/*-----------------------------------------------------------------------------

  File: _seltrg.p

  Description: 
      Select one trigger section from the list of triggers or perform some
      treeview specific command.

  Must be kept in sync with:
      adeuib/_seprocs.i PROCEDURE GetNextSearchSection.
      adeuib/_seprocs.i PROCEDURE GetSearchAllList.

  Input Parameters:
      p_trg_win   -  The handle of the window to list triggers for.
      p_command   -  Command to perform on behalf of caller.
      
  Input-Output Parameters:
      p_section - the current section at input; the desired section at
                  output (eg. _CUSTOM, _CONTROL, _PROCEDURE, _FUNCTION)
      p_recid   - the current (and desired) recid
      p_event   - the current (and desired) name of pseudo-event or event.
                  eg.  CHOOSE or _DEFINITIONS.
  
  Output Parameters:
      p_codeitems  - Comma-delimited list of one or more code sections. Used
                     by treeview code.
      p_ok     - TRUE if user pressed OK.

  Author: Wm. T. Wood

  Created: 02/26/93 -  1:20 pm
  
  Modified: 
      2/04/98 by jep -- Changed section names to Capitalized case from Upper case.
      1/30/98 by jep -- Changed to support treeview code calls.
      4/04/97 by jep -- Added wait cursor & removed old rule code.
      1/29/97 by jep -- Added support for FUNCTIONS section.
      5/04/95 by jep -- Changed code to handle object names for dbfields
                        (dbname.table.name).
      4/12/95 by GFS -- Added ability to list XFTRs (those with Edit methods)
                        and to call their edit routine when selected.
-----------------------------------------------------------------------------*/
/*             This .W file was created with the Progress UIB.               */
/*---------------------------------------------------------------------------*/

/* Define Parameters. */
DEFINE INPUT        PARAMETER  p_trg_win    AS WIDGET            NO-UNDO.
DEFINE INPUT        PARAMETER  p_command    AS CHAR              NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER  p_section    AS CHAR              NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER  p_recid      AS RECID             NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER  p_event      AS CHAR              NO-UNDO.
DEFINE       OUTPUT PARAMETER  p_codeitems  AS CHAR              NO-UNDO.
DEFINE       OUTPUT PARAMETER  p_ok         AS LOGICAL           NO-UNDO.

/* Include Files. */
&SCOPED-DEFINE use-3D YES
&GLOBAL-DEFINE WIN95-BTN YES
{adeuib/sharvars.i}            /* Standard shared definitions               */
{adecomm/adestds.i}            /* Standard Definitions                      */
{adeuib/uniwidg.i}             /* Definition of Universal Widget TEMP-TABLE */
{adeuib/brwscols.i}            /* Temp-table definitions of browse columns  */
{adeuib/triggers.i}            /* Definition of Triggers TEMP-TABLE         */
{adeuib/xftr.i}                /* eXtended Features definition              */
{adeuib/uibhlp.i}     	   /* Help pre-processor directives             */

/* Local Variable Definitions. */
DEFINE BUFFER b_U FOR _U.

DEF  VAR win_recid    AS RECID                                   NO-UNDO.
         /* RECID of window for the triggers and code                 */
DEF  VAR l_dummy      AS LOGICAL                                 NO-UNDO.
         /* dummy logical to accept result of methods                 */
DEF  VAR item         AS CHAR                                    NO-UNDO.
         /* store 1 item of sel-list                                  */
DEF  VAR object_name  AS CHAR                                    NO-UNDO.
/* _UIB-CODE-BLOCK-END */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE sel-list AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL 
     SIZE-CHAR 50 BY 12  NO-UNDO.

/* Buttons for the bottom of the screen                                      */
DEFINE BUTTON btn_ok     LABEL "OK":C12     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON btn_cancel LABEL "Cancel":C12 {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON btn_help   LABEL "&Help":C12  {&STDPH_OKBTN}.

/* standard button rectangle */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.
&ENDIF

/* Definitions of the frame widgets                                     */
DEFINE FRAME f_sections
     SKIP({&TFM_WID})
     "Code Sections:" AT 2 VIEW-AS TEXT SKIP({&VM_WID})
     sel-list AT 2 NO-LABEL

   {adecomm/okform.i
      &BOX    = "rect_btns"
      &STATUS = "no"
      &OK     = "btn_OK"
      &CANCEL = "btn_Cancel"
      &HELP   = "btn_Help"}

    WITH SIDE-LABELS DEFAULT-BUTTON btn_Ok TITLE "List Sections"
	VIEW-AS DIALOG-BOX THREE-D.
 
&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/*  TEXT TEXT-1 1.52 4 "Code Sections:"  */
/* _RUN-TIME-ATTRIBUTES-END */
/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "FRAME f_sections" 
   &BOX   = "rect_Btns"
   &OK    = "btn_OK" 
   &HELP  = "btn_Help"
}
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f_sections 
/* Standard UIB stuff for dialog boxes - including WINDOW-CLOSE = END-ERROR */
{adeuib/std_dlg.i &FRAME_CLOSE = f_sections }  

/* ----------------------------------------------------------- */
/*                        TRIGGERS                             */
/* ----------------------------------------------------------- */
/* Help triggers */
ON CHOOSE OF btn_help IN FRAME f_sections OR HELP OF FRAME f_sections
  RUN adecomm/_adehelp.p ( "AB", "CONTEXT", {&Section_List_Dlg_Box}, ? ).

/* Exit gracefully - Note that btn_ok is AUTO-GO */
ON GO OF FRAME f_sections  OR  DEFAULT-ACTION OF sel-list
DO:
  ASSIGN sel-list   = sel-list:SCREEN-VALUE in FRAME f_sections.
         p_ok = TRUE.
  RUN Return-Section.
  /* Exit out of here */
  APPLY "U1" TO FRAME f_sections.
END.
   
/* ----------------------------------------------------------- */
/*                      Setup for Run                          */
/* ----------------------------------------------------------- */

IF (p_Command BEGINS "_LIST":U) THEN
    RUN adecomm/_setcurs.p (INPUT "WAIT":U).

/* Get the window record */
FIND b_U WHERE b_U._HANDLE = p_trg_win NO-ERROR.
IF NOT AVAILABLE b_U THEN RETURN.  /* this should never happen. */
ASSIGN win_recid = RECID(b_U)
       p_ok      = FALSE. /* Unless we here otherwise */

/* Go though all the widgets and initialize the selection list, starting
   with the TOPOFFILE XFTR, then DEFINITIONS.  */  
sel-list:LIST-ITEMS = "":U .
RUN put_next_xftrs (INPUT {&TOPOFFILE}).
IF p_section = "_CUSTOM" AND 
  (p_event = "_DEFINITIONS" OR p_event = "Definitions") THEN
  sel-list = "Definitions".
l_dummy = sel-list:ADD-LAST ("Definitions":U).

RUN put_next_xftrs (INPUT {&DEFINITIONS}).
RUN put_next_xftrs (INPUT {&STDPREPROCS}).

ASSIGN item = "".
/* Now controls */
FOR EACH b_U WHERE b_U._WINDOW-HANDLE = p_trg_win
              AND b_U._STATUS <> "DELETED":
  FOR EACH _TRG WHERE _TRG._wRECID = RECID (b_U)
                  AND _TRG._STATUS <> "DELETED"
                  AND _TRG._tSECTION = "_CONTROL":
    /* Check if dbfield and if so, change to db.table.name. */
    IF b_U._DBNAME = ? THEN
        ASSIGN object_name = b_U._NAME.
    ELSE
        ASSIGN object_name = b_U._DBNAME + "." + b_U._TABLE + "." + b_U._NAME.
    
    ASSIGN item    = ("Trigger " + _TRG._tEVENT + " Of " + object_name)
           l_dummy = sel-list:ADD-LAST(item).
    IF p_section = "_CONTROL" AND p_recid = RECID(b_U)  AND p_event = _TRG._tEVENT 
    THEN sel-list = item.
  END.
  IF b_U._TYPE = "BROWSE":U THEN DO:
    FOR EACH _BC WHERE _BC._x-recid = RECID(b_U),
        EACH _TRG WHERE _TRG._wRECID = RECID (_BC) AND
                        _TRG._STATUS <> "DELETED" AND
                        _TRG._tSECTION = "_CONTROL":
      ASSIGN item    = ("Trigger " + _TRG._tEVENT + " Of " + _BC._DISP-NAME + 
                        " In Browse " + b_U._NAME)
             l_dummy = sel-list:ADD-LAST(item).
      IF (sel-list = ?) AND (p_section = "_CONTROL") AND (p_recid = RECID(_BC)) AND
         (p_event = _TRG._tEVENT) THEN sel-list = item.
    END.
  END.
  RUN put_next_xftrs (INPUT INT(RECID(_TRG))).
END.

RUN put_next_xftrs (INPUT {&CONTROLDEFS}).
RUN put_next_xftrs (INPUT {&RUNTIMESET}).

/* WebSpeed V2 Included Libraries */
FIND _P WHERE _P._WINDOW-HANDLE eq p_trg_win.  
IF _P._file-version BEGINS "WDT_v2":U THEN
  ASSIGN 
    l_dummy  = sel-list:ADD-LAST("Included Libraries")
    sel-list = IF p_section = "_CUSTOM":U AND 
                 (p_event = "_INCLUDED-LIBRARIES") 
               THEN "Included Libraries" ELSE sel-list.
    
RUN put_next_xftrs (INPUT {&INCLUDED-LIB}).
RUN put_next_xftrs (INPUT {&CONTROLTRIG}).

/* Main Block */
ASSIGN 
  l_dummy  = sel-list:ADD-LAST("Main Block")
  sel-list = IF p_section = "_CUSTOM":U AND 
               (p_event = "_MAIN-BLOCK" OR p_event = "Main Code Block":U) 
             THEN "Main Block" ELSE sel-list.
    
RUN put_next_xftrs (INPUT {&MAINBLOCK}).

/* Procedures */
ASSIGN item = "".
FOR EACH _TRG WHERE _TRG._wRECID = win_recid  AND _TRG._STATUS <> "DELETED"
                      AND _TRG._tSECTION = "_PROCEDURE":
    ASSIGN item    = "Procedure " + _TRG._tEVENT.
           l_dummy = sel-list:ADD-LAST(item).
    IF (p_section = "_PROCEDURE") AND (p_recid = win_recid) AND (p_event = _TRG._tEVENT)
    THEN ASSIGN sel-list = item.      
    /* Put XFTR's that follow this procedure. */
    RUN put_next_xftrs (INPUT INT(RECID(_TRG))).
END.

RUN put_next_xftrs (INPUT {&INTPROCS}).

/* Functions */
ASSIGN item = "".
FOR EACH _TRG WHERE _TRG._wRECID = win_recid  AND _TRG._STATUS <> "DELETED"
                      AND _TRG._tSECTION = "_FUNCTION":
    ASSIGN item    = "Function " + _TRG._tEVENT.
           l_dummy = sel-list:ADD-LAST(item).
    IF (p_section = "_FUNCTION") AND (p_recid = win_recid) AND (p_event = _TRG._tEVENT)
    THEN ASSIGN sel-list = item.      
    /* Put XFTR's that follow this procedure. */
    RUN put_next_xftrs (INPUT INT(RECID(_TRG))).
END.

/* RUN put_next_xftrs (INPUT {&INTPROCS}). */


IF (p_Command BEGINS "_LIST":U OR p_Command = "") THEN
DO:
    /* ----------------------------------------------------------- */
    /* Main Code Block - Enable Widgets, Exit condition, Clean-up  */
    /* ----------------------------------------------------------- */
    
    RUN enable_UI.     
    DISPLAY sel-list WITH FRAME f_sections. /* Show the current value */
    RUN adecomm/_setcurs.p (INPUT "":U).
    
    WAIT-FOR "U1" OF FRAME f_sections.
END.
ELSE IF (p_Command BEGINS "_GET":U) THEN
DO: /* Treeview command */
    IF p_Command <> "_GET-CURRENT":U THEN
        ASSIGN p_codeitems = sel-list:LIST-ITEMS IN FRAME f_sections.
    ELSE
        ASSIGN p_codeitems = sel-list.
    RETURN.
END.
ELSE IF (p_Command BEGINS "_EDIT":U) THEN
DO: /* Treeview command */
    DEFINE SHARED VAR hSecEd AS HANDLE NO-UNDO.
    
    ASSIGN sel-list = p_section.
    RUN Return-Section.
    IF p_section BEGINS "XFTR" THEN RETURN.
    
    FIND _TRG WHERE _TRG._wRECID = p_recid
                AND _TRG._STATUS <> "DELETED"
                AND _TRG._tSECTION = p_section
                AND _TRG._tEVENT = p_event.
    
    ASSIGN _err_recid = RECID(_TRG).
    RUN call_sew IN _h_uib ("SE_ERROR":U).
    ASSIGN _err_recid = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/******************************************************************/
/*                     Internal Procedures                        */
/******************************************************************/

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI f_sections 
PROCEDURE enable_UI .
  /* ----------------------------*/
  /* Default Enabling Procedure  */
  /* ----------------------------*/
  ENABLE sel-list btn_ok btn_cancel btn_help
    WITH FRAME f_sections.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE put_next_xftrs f_sections 
PROCEDURE put_next_xftrs :
/* -----------------------------------------------------------
  Purpose:     List xftrs following a given .W section
  Parameters:  loc (int)
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER loc AS INTEGER NO-UNDO.
  
  DO WITH FRAME f_sections:
   
    FIND FIRST _TRG WHERE _TRG._tLOCATION eq loc
                AND _TRG._wRECID    eq win_recid NO-ERROR.
    
    DO WHILE AVAILABLE _TRG:
      FIND _xftr WHERE RECID(_xftr) eq _TRG._xRECID NO-ERROR.
      /* Only XFTRs with an edit procedure will be added to the list */ 
      IF AVAILABLE _xftr AND _xftr._edit NE ? THEN
          ASSIGN l_dummy  = sel-list:ADD-LAST("Xftr - " + _xftr._name) IN FRAME f_sections.
      ASSIGN loc = INT(RECID(_TRG)).
      FIND _TRG WHERE _TRG._tLOCATION eq loc
                  AND _TRG._wRECID    eq win_recid NO-ERROR.     
    END.
    
  END. /* DO WITH FRAME */

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Return-Section f_sections 
PROCEDURE Return-Section.
  
  DEFINE VARIABLE tcode AS CHARACTER NO-UNDO.
  
  FIND _P WHERE _P._WINDOW-HANDLE eq p_trg_win.  
  
  IF sel-list = "DEFINITIONS" THEN
       ASSIGN p_section = "_CUSTOM"
              p_recid   = win_recid
              p_event   = "_DEFINITIONS":U.
  ELSE IF sel-list = "INCLUDED LIBRARIES" THEN
       ASSIGN p_section = "_CUSTOM"
              p_recid   = win_recid
              p_event   = "_INCLUDED-LIBRARIES":U.
  ELSE IF sel-list = "MAIN BLOCK" THEN
       ASSIGN p_section = "_CUSTOM"
              p_recid   = win_recid
              p_event   = "_MAIN-BLOCK":U.
  ELSE IF sel-list BEGINS "PROCEDURE" THEN
       ASSIGN p_section = "_PROCEDURE"
              p_recid   = win_recid
              p_event   = ENTRY( 2 , sel-list , " " ).
  ELSE IF sel-list BEGINS "FUNCTION" THEN
       ASSIGN p_section = "_FUNCTION"
              p_recid   = win_recid
              p_event   = ENTRY( 2 , sel-list , " " ).
  ELSE IF sel-list BEGINS "XFTR -" THEN DO:
    FIND _XFTR WHERE _XFTR._wRecid = win_recid AND 
                     _XFTR._NAME   = SUBSTRING(sel-list,8,-1,"CHARACTER").
    FIND _TRG WHERE _TRG._xRecid = RECID(_XFTR).
    ASSIGN tcode = _TRG._tCode.
    IF _XFTR._edit <> ? THEN 
    DO ON STOP UNDO, LEAVE:
      HIDE FRAME f_sections.
      RUN VALUE(_XFTR._edit) (INPUT INT(RECID(_TRG)), INPUT-OUTPUT tCode).
      IF _TRG._tCode <> tCode THEN DO:          /* code changed */
        ASSIGN _TRG._tCode      = tCode
               _P._FILE-SAVED   = no.
      END.
    END.
    /* ELSE RUN adeuib/_xfcedit.w (INPUT-OUTPUT tCode). */
  END.
  ELSE IF sel-list <> ? THEN DO:
    /* sel-list = ON event OF widget */
    
    /* Get the name and check to see if its a dbfield (db.table.name). */
    ASSIGN object_name = TRIM(ENTRY( 4, sel-list, " ")).
    IF INDEX( object_name , "." ) = 0 THEN
        FIND b_U WHERE b_U._WINDOW-HANDLE = p_trg_win
                  AND b_U._NAME          = object_name
                  AND b_U._STATUS        <> "DELETED" NO-ERROR.
    ELSE
        FIND b_U WHERE b_U._WINDOW-HANDLE = p_trg_win
                  AND b_U._NAME          = ENTRY(3,object_name,".")
                  AND b_U._DBNAME        = ENTRY(1,object_name,".")
                  AND b_U._TABLE         = ENTRY(2,object_name,".")
                  AND b_U._STATUS        <> "DELETED" NO-ERROR.
                      
    IF NOT AVAILABLE b_U AND ENTRY(6, sel-list, " ") = "BROWSE":U THEN DO:
      /* Handle the browse-column case */
      FIND b_U WHERE b_U._WINDOW-HANDLE = p_trg_win AND
                    b_U._NAME          = TRIM(ENTRY(7, sel-list, " ")) AND
                    b_U._STATUS        <> "DELETED" NO-ERROR.
      IF AVAILABLE b_U THEN
        FIND _BC WHERE _BC._DISP-NAME = TRIM(ENTRY(4, sel-list, " ")) NO-ERROR.
    END.
    IF NOT AVAILABLE b_U AND NOT AVAILABLE _BC THEN p_ok = FALSE.
    ELSE IF AVAILABLE _BC AND ENTRY(6, sel-list, " ") = "BROWSE":U THEN
      ASSIGN p_section = "_CONTROL"
             p_recid   = RECID (_BC)
             p_event   = ENTRY (2, sel-list," ").
    ELSE
      ASSIGN p_section = "_CONTROL"
             p_recid   = RECID (b_U)
             p_event   = ENTRY (2, sel-list," ").
  END.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&UNDEFINE WINDOW-NAME
