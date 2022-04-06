/***********************************************************************
* Copyright (C) 2005-2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------------

File: _wrcont.p

Description:
    Writes out the CREATE CONTROL-FRAME statements into a .w file.  These widgets
    define all the OCX's.
    
Input Parameters:
   ph_win        The handle of the window to check
   pu_status     The _U._STATUS values to write out ("EXPORT" , or "NORMAL")
   p_status
                
Output Parameters:
   <None>

Author: Wm.T.Wood

Date Created: 1995

Last Modified: 
  06/07/99 tsm Added CONTEXT-HELP-ID attribute
  02/10/98 gfs Added support for NO-TAB-STOP
  12/19/96 gfs Ported to OCX
---------------------------------------------------------------------------- */
DEFINE INPUT PARAMETER ph_win    AS WIDGET    NO-UNDO.
DEFINE INPUT PARAMETER pu_status AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_status  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER fName     AS CHARACTER NO-UNDO.

{adeuib/pre_proc.i}
{adeuib/sharvars.i}
{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/layout.i}       /* Layout temp-table definitions                     */
{adecomm/adefext.i}

/* FUNCTION PROTOTYPE */
FUNCTION db-fld-name RETURNS CHARACTER
  (INPUT rec-type AS CHARACTER, INPUT rec-recid AS RECID) IN _h_func_lib.

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

DEFINE VARIABLE anchor-recid AS RECID     NO-UNDO.
DEFINE VARIABLE pList        as CHARACTER NO-UNDO.
DEFINE VARIABLE s            as INTEGER   NO-UNDO.
DEFINE VARIABLE i            as INTEGER   NO-UNDO.
DEFINE VARIABLE isa-smo      as LOGICAL   NO-UNDO.
DEFINE VARIABLE move-method  as CHARACTER NO-UNDO.
DEFINE VARIABLE str          as CHARACTER NO-UNDO.
DEFINE VARIABLE junk         as CHARACTER NO-UNDO.
DEFINE VARIABLE nItems       as INTEGER   NO-UNDO.
DEFINE VARIABLE OCXBinary    as CHARACTER NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER anchor_U FOR _U.
DEFINE BUFFER anchor_F FOR _F.

/*
 * Get the information about the file.
 */
FIND _P WHERE _P._WINDOW-HANDLE eq ph_win.

DEFINE SHARED STREAM P_4GL.

str = "~{":U  + "~&":U + "OPSYS":U + "~}":U.  

RUN adeuib/_isa.p (INTEGER(RECID(_P)), "SmartObject":U, OUTPUT isa-smo). 

/*
 * Write out the things needed by allcontainers/controls.
 *
 * The container is kept from other platforms by using conditional
 * compiling
 */
 
PUT STREAM P_4GL UNFORMATTED SKIP (1)
    '&IF "':U str '" = "WIN32":U AND "~{~&WINDOW-SYSTEM~}" NE "TTY":U &THEN':U
     skip.

   
/* If not the default, write out where the OCX binary is saved. */
OCXBinary = entry(1, _P._VBX-FILE).
IF OCXBinary <> ? AND length(OCXBinary) <> 0 THEN
    PUT STREAM P_4GL UNFORMATTED SKIP (1)
        "/* OCX BINARY:FILENAME is: " OCXBinary " */" skip
    .
        
/* ************************************************************************* */
FOR EACH _U WHERE _U._WINDOW-HANDLE eq ph_win
              AND _U._TYPE          eq "{&WT-CONTROL}":U
              AND _U._STATUS        eq pu_status
            USE-INDEX _OUTPUT,
      EACH _F WHERE RECID(_F) eq _U._x-recid BY _U._PARENT BY _U._TAB-ORDER:
   /* Get the Layout information */
   FIND _L WHERE _L._u-recid = RECID(_U) AND _L._LO-NAME = "Master Layout".

   /* Find the parent */
   FIND parent_U WHERE RECID(parent_U) eq _U._parent-recid.

   /* Now create the widget. */
   PUT STREAM P_4GL UNFORMATTED SKIP (1)
       "CREATE {&WT-CONTAINER} ":U _U._NAME " ASSIGN":U SKIP
       "       FRAME           = FRAME ":U parent_U._NAME ":HANDLE":U SKIP 
       .   
   PUT STREAM P_4GL UNFORMATTED SKIP
       "       ROW             = ":U _L._ROW SKIP
       "       COLUMN          = ":U _L._COL SKIP
       "       HEIGHT          = ":U _L._HEIGHT SKIP
       "       WIDTH           = ":U _L._WIDTH SKIP
       .
       
   IF _L._BGCOLOR <> ? THEN
       PUT STREAM P_4GL UNFORMATTED
       "       BGCOLOR         = ":U _L._BGCOLOR SKIP
       .   
   IF LENGTH(_U._HELP) > 0 THEN DO:
       ASSIGN str = REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                      _U._HELP,"~~","~~~~"), "~"","~~~""), "~\","~~~\"),
                      "~{","~~~{"), "~;","~~~;").
       PUT STREAM P_4GL UNFORMATTED  
       "       HELP            = ~"":U _U._HELP "~"":U SKIP
       .
   END.
   IF LENGTH(_U._PRIVATE-DATA) > 0 THEN
       PUT STREAM P_4GL UNFORMATTED  
       "       PRIVATE-DATA    = ~"":U + _U._PRIVATE-DATA + "~"":U SKIP
       .
   IF _U._NO-TAB-STOP EQ TRUE THEN
       PUT STREAM P_4GL UNFORMATTED  
       "       TAB-STOP        = no":U SKIP
       .   
   IF _U._CONTEXT-HELP-ID NE ? THEN
       PUT STREAM P_4GL UNFORMATTED
       "       CONTEXT-HELP-ID = ":U _U._CONTEXT-HELP-ID SKIP
       .
   IF _U._WIDGET-ID NE ? THEN
       PUT STREAM P_4GL UNFORMATTED
       "       WIDGET-ID       = ":U _U._WIDGET-ID SKIP
       .
   /* Set the following attributes last, since they can force the control
      to realize. */
   /* If we are going to REMOVE-FROM-LAYOUT, then we don't need to set
      HIDDEN.  However, we write it out always when HIDDEN = YES so that
      we can retain the information when we read it back in. */
   IF NOT _L._REMOVE-FROM-LAYOUT OR _U._HIDDEN
   THEN PUT STREAM P_4GL UNFORMATTED SKIP 
          "       HIDDEN          = ":U _U._HIDDEN  
          .  
   /* We set VISIBLE as the flag for REMOVE-FROM-LAYOUT. */
   IF _L._REMOVE-FROM-LAYOUT
   THEN PUT STREAM P_4GL UNFORMATTED SKIP 
          "       VISIBLE         = no":U
          .
   PUT STREAM P_4GL UNFORMATTED SKIP
       "       SENSITIVE       = ":U _U._SENSITIVE ".":U skip.
END.  /* FOR EACH OCX */

IF isa-smo THEN
  PUT STREAM P_4GL UNFORMATTED SKIP (1)
            'PROCEDURE adm-create-controls:' SKIP.

FOR EACH _U WHERE _U._WINDOW-HANDLE eq ph_win
              AND _U._TYPE          eq "{&WT-CONTROL}":U
              AND _U._STATUS        eq pu_status
            USE-INDEX _OUTPUT,
      EACH _F WHERE RECID(_F) eq _U._x-recid BY _U._PARENT BY _U._TAB-ORDER:
   /* Get the Layout information */
   FIND _L WHERE _L._u-recid = RECID(_U) AND _L._LO-NAME = "Master Layout".

   /*Bug# 20051202-051.
     If the object is a Window or Dialog (not smart), the name of the
     control-frame is assigned in the control_load procedure*/
   IF _P._adm-version NE "" THEN
   DO:
       /* Find the parent */
       FIND parent_U WHERE RECID(parent_U) eq _U._parent-recid.
   
       PUT STREAM P_4GL UNFORMATTED SKIP
           "      ":U + _U._NAME + ":NAME = ~"" _U._NAME "~":U":U " .":U SKIP
       .
   END.

   /*
    * Write out only the vbx load statement. For RUN or
    * DEBUG, write out the full path of the temp file
    * name into the temp .w file. Otherwise use the
    * name provided or the vbx-file name.
    */
   IF p_status = "RUN":U OR p_status = "DEBUG":U THEN
      str = fName.
   ELSE IF OCXBinary = ? OR length(OCXBinary) = 0 THEN
       RUN adecomm/_osprefx.p(fName, output junk, output str).
   ELSE
       str = OCXBinary.
       
   PUT STREAM P_4GL UNFORMATTED SKIP
       "/* ":U _U._NAME " OCXINFO:CREATE-CONTROL from: ":U _F._IMAGE-FILE 
       " type: ":U _U._OCX-NAME " */":U skip
   .
END. /* FOR EACH...OCX... */

/* Write out tab-order placement */
FOR EACH _U WHERE _U._WINDOW-HANDLE eq ph_win
              AND _U._TYPE          eq "{&WT-CONTROL}":U
              AND _U._STATUS        eq pu_status
              AND NOT _U._NO-TAB-STOP
            USE-INDEX _OUTPUT,
      EACH _F WHERE RECID(_F) eq _U._x-recid BY _U._PARENT BY _U._TAB-ORDER:

   /* Find the parent */
   FIND parent_U WHERE RECID(parent_U) eq _U._parent-recid.
   anchor-recid = ?.
   IF _U._TAB-ORDER = 1 THEN DO:
     ASSIGN move-method = "BEFORE":U.
     DO PRESELECT EACH anchor_U WHERE
                  anchor_U._WINDOW-HANDLE eq ph_win AND
                  anchor_U._PARENT-RECID  eq _U._PARENT-RECID AND
                  anchor_U._TAB-ORDER     gt 1 AND
                  LOOKUP(anchor_U._TYPE,"RECTANGLE,OCX,TEXT,IMAGE,QUERY,LABEL") = 0 AND
                  anchor_U._SUBTYPE ne "TEXT"
            BY anchor_U._TAB-ORDER:
       FIND FIRST anchor_U NO-ERROR.
       THROW_OUT_NON-VISIBLE_SMOs:  /* And no-focus buttons */
       REPEAT WHILE AVAILABLE anchor_U AND
              (anchor_U._TYPE = "SmartObject":U OR
               anchor_U._TYPE = "BUTTON":U):
         CASE anchor_U._TYPE:
           WHEN "SmartObject":U THEN DO:
             FIND _S WHERE RECID(_S) = anchor_U._x-recid NO-ERROR.
             IF AVAILABLE _S AND _S._VISUAL AND _S._PAGE-NUMBER = 0 THEN LEAVE THROW_OUT_NON-VISIBLE_SMOs.
             ELSE FIND NEXT anchor_U.
           END.  /* SmartObject */
           WHEN "BUTTON" THEN DO:
             FIND _L WHERE _L._u-recid = RECID(anchor_U) AND _L._LO-NAME = "Master Layout":U.
             IF NOT _L._NO-FOCUS THEN LEAVE THROW_OUT_NON-VISIBLE_SMOs.
             ELSE FIND NEXT anchor_U.
           END. /* Button */
         END CASE.
       END. /* REPEAT */
       IF AVAILABLE anchor_U THEN anchor-recid = RECID(anchor_U).
     END. /* Do Preselect */
   END.  /* If first in the tab order */
   ELSE DO:
     ASSIGN move-method = "AFTER":U.
     DO PRESELECT EACH anchor_U WHERE
                  anchor_U._WINDOW-HANDLE eq ph_win AND
                  anchor_U._PARENT-RECID  eq _U._PARENT-RECID AND
                  anchor_U._TAB-ORDER     lt _U._TAB-ORDER AND
                  LOOKUP(anchor_U._TYPE,"RECTANGLE,TEXT,IMAGE,QUERY,LABEL") = 0 AND
                  anchor_U._SUBTYPE ne "TEXT" AND
                  anchor_U._TAB-ORDER > 0
            BY anchor_U._TAB-ORDER:
       FIND LAST anchor_U NO-ERROR.
       THROW_OUT_NON-VISIBLE_SMOs: /* And no-focus buttons */
       REPEAT WHILE AVAILABLE anchor_U AND
              (anchor_U._TYPE = "SmartObject":U OR
               anchor_U._TYPE = "BUTTON":U):
         CASE anchor_U._TYPE:
           WHEN "SmartObject":U THEN DO:
             FIND _S WHERE RECID(_S) = anchor_U._x-recid NO-ERROR.
             IF AVAILABLE _S AND _S._VISUAL AND _S._PAGE-NUMBER = 0 THEN LEAVE THROW_OUT_NON-VISIBLE_SMOs.
             ELSE FIND PREV anchor_U.
           END.  /* SmartObject */
           WHEN "BUTTON" THEN DO:
             FIND _L WHERE _L._u-recid = RECID(anchor_U) AND _L._LO-NAME = "Master Layout":U.
             IF NOT _L._NO-FOCUS THEN LEAVE THROW_OUT_NON-VISIBLE_SMOs.
             ELSE FIND PREV anchor_U.
           END. /* Button */
         END CASE.
       END. /* REPEAT */
       IF AVAILABLE anchor_U THEN anchor-recid = RECID(anchor_U).
     END. /* Do Preselect */
   END. /* If not first in the tab order */
   
   IF anchor-recid ne ? AND anchor-recid NE _U._PARENT-RECID THEN DO:
     /* It is necessary to check for anchor to not also be the parent when dealing
        with dialog boxes containing only OCX's */
     FIND anchor_U WHERE RECID(anchor_U) = anchor-recid.
     IF anchor_U._TYPE = "SmartObject":U THEN DO: /* Use broker adjust-tab-order method  */
       /* We are switching the  object and the anchor, so the move-method is switched */
       PUT STREAM P_4GL UNFORMATTED
        (IF _P._adm-version < "ADM2" THEN 
            "      RUN adjust-tab-order IN adm-broker-hdl ( ":U 
        ELSE
            "      RUN adjustTabOrder ( ":U) +
               anchor_U._name + " , ":U + _U._NAME + " , '":U +
               (IF move-method = "AFTER" THEN "BEFORE" ELSE "AFTER") +
               "':U ).":U SKIP.
     END.
     ELSE DO:
       FIND anchor_F WHERE RECID(anchor_F) EQ anchor_U._x-recid NO-ERROR.
       PUT STREAM P_4GL UNFORMATTED
          "      ":U + _U._NAME + ":MOVE-" + move-method + "(":U + 
            (IF anchor_U._TYPE = "FRAME":U THEN "FRAME ":U ELSE "":U) +
            (IF anchor_U._DBNAME EQ ? OR (AVAILABLE anchor_F AND anchor_F._DISPOSITION EQ "LIKE":U)
             THEN anchor_U._NAME
             ELSE db-fld-name("_U":U, RECID(anchor_U))) +
            (IF anchor_U._TYPE eq "{&WT-CONTROL}":U THEN ").":U
            ELSE ":HANDLE" + (IF LOOKUP(parent_U._TYPE,"FRAME,DIALOG-BOX":U) > 0 AND
                                 LOOKUP(anchor_U._TYPE,"FRAME,DIALOG-BOX":U) = 0 THEN
                " IN FRAME " + parent_U._NAME ELSE "") + ").":U) SKIP.
     END.
  END. /* If there is an anchor */
      
END. /* FOR EACH...OCX... */

IF isa-smo THEN
  PUT STREAM P_4GL UNFORMATTED SKIP (1)
            'END PROCEDURE.':U SKIP.

PUT STREAM P_4GL UNFORMATTED SKIP (1)
    "&ENDIF":U skip




