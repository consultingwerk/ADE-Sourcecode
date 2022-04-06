/***********************************************************************
* Copyright (C) 2005-2010 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
************************************************************************/
/*----------------------------------------------------------------------------

File: _cdsuckr.p

Description:
    Suck in code blocks from the qs file.

Input Parameters:
   pImportMode

Output Parameters:
   <None>

Author: D. Ross Hunter

Created: 1993
Updated: 03/05/95 jap   Added LIB-MGR support
         12/15/00 adams Added Remote File Management support

---------------------------------------------------------------------------- */
/*--------------------------------------------------------------------------
  Purpose:       Parse the current input line to determine where a code
                 block should be stored.  Read from the input stream until
                 we have a _UIB-CODE-BLOCK-END line.
  Run Syntax:    RUN set_event_list.
  Parameters:    <none>
  Notes:         Require a current _inp_line array and an open STREAM.
                 _inp_line [2]          [3]         [4]         [5]
                 --------- ----------   ----------- ----------- ----------
                 custom:   _CUSTOM      _MAIN-BLOCK window-name [_SPECIAL]; OR
                 triggers: _CONTROL     widget-name window-name           ;
                 triggers  _CONTROL     widget-name window-name [_SPECIAL]
                           (really a procedure block, eg. OCX's.)
                 Browse Column Triggers:
                           _CONTROL     db.tbl.nm   browse-name _BROWSE-COLUMN
                           _inp_line[6] is window-namew                   ; OR
                 XFTRs:    _XFTR        "Label"     window-name _INLINE   ; OR
                           _XFTR        NAME        window-name           ; OR
                 procedure:_PROCEDURE   proc-name*  window-name [_SPECIAL]
                            (proc-name is ignored here. we get in on next line)
                 function: _FUNCTION    func-name*  window-name [_SPECIAL]
                            (func-name is ignored here. we get in on next line)

  Side-effects:  This fills _TRG records.  It also sets the booleans
                 def_found main_found [which indicate if a DEFINITIONS or
                 main_code block have been found.]
---------------------------------------------------------------------------*/

{adecomm/adefext.i}
{adeuib/uniwidg.i}    /* Universal Widget TEMP-TABLE definition            */
{adeuib/brwscols.i}   /* Temp-table definitions of browse columns          */
{adeuib/triggers.i}   /* Trigger TEMP-TABLE definition                     */
{adeuib/xftr.i}       /* eXtended Features definition                      */
{adeuib/name-rec.i}   /* Name indirection table                            */
{adeuib/sharvars.i}   /* Shared variables                                  */
{adecomm/adeintl.i}

/* Standard End-of-line character */
&SCOPED-DEFINE EOL CHR(10)
/* Define a SKIP for alert-boxes that only exists under Motif */
&GLOBAL-DEFINE SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

DEFINE INPUT  PARAMETER pImportMode AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pBrokerURL  AS CHARACTER  NO-UNDO.

DEFINE SHARED VARIABLE _inp_line    AS CHARACTER  NO-UNDO EXTENT 100.
DEFINE SHARED VARIABLE cur_sect     AS INTEGER    NO-UNDO.
DEFINE SHARED VARIABLE def_found    AS LOGICAL    NO-UNDO.
DEFINE SHARED VARIABLE ips_found    AS LOGICAL    NO-UNDO.
DEFINE SHARED VARIABLE main_found   AS LOGICAL    NO-UNDO.
DEFINE SHARED VARIABLE trig_found   AS LOGICAL    NO-UNDO.

DEFINE SHARED STREAM _P_QS.

DEFINE VARIABLE browse-column AS LOGICAL    NO-UNDO.
DEFINE VARIABLE browse-name   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE db-name       AS CHARACTER  NO-UNDO INITIAL ?.
DEFINE VARIABLE fld-name      AS CHARACTER  NO-UNDO INITIAL ?.
DEFINE VARIABLE tbl-name      AS CHARACTER  NO-UNDO INITIAL ?.
DEFINE VARIABLE l_proc-name   AS CHARACTER  FORMAT "x(40)":U.
DEFINE VARIABLE lastCopied    AS INTEGER    NO-UNDO.
DEFINE VARIABLE i             AS INTEGER    NO-UNDO.
DEFINE VARIABLE ml_inclibs    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE org-name      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE proc-hit      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE private_block AS CHARACTER  NO-UNDO.
DEFINE VARIABLE trig-hit      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE valid_code    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE vbx_proc      AS LOGICAL    NO-UNDO.

DEFINE BUFFER x_trg FOR _TRG.
DEFINE BUFFER x_P   FOR _P.

/* We don't need _FUNCTION-FORWARD blocks. The actual function implementation code
   is in the _FUNCTION block, which comes later in the file.
   
   We do need EXTERNAL's, because they are the code block for that function, since
   the Section Editor doesn't support defining both an external function prototype
   and an internal function implementation in one UIB file.  So we change the block
   type to _FUNCTION, which is read correctly later in this file.
   - jep _FUNC 1/31/97 */
IF (_inp_line[2] BEGINS "_FUNCTION-":U) THEN DO:
  IF (_inp_line[2] = "_FUNCTION-FORWARD":U) THEN RETURN.
  IF (_inp_line[2] = "_FUNCTION-EXTERNAL":U) THEN
    ASSIGN _inp_line[2] = "_FUNCTION":U.
END.

/* We use the procedure _TYPE later. WEB stuff. */
FIND x_P WHERE x_P._WINDOW-HANDLE = _h_win.

CREATE _TRG.
ASSIGN _TRG._tSECTION = _inp_line[2]  /* The Section */
       _TRG._tSPECIAL = IF _inp_line[5] = "" THEN ?  ELSE _inp_line[5]             
       _TRG._tCODE    = ""
       _TRG._pRECID   = RECID(x_P)
       valid_code     = TRUE.

IF (_inp_line[5] = "_DB-REQUIRED":u OR _inp_line[6] = "_DB-REQUIRED":u) THEN DO:
  _TRG._DB-REQUIRED = TRUE.
  _TRG._tSPECIAL    = IF _inp_line[5] = "_DB-REQUIRED":u THEN ?  ELSE _inp_line[5].
END.
ELSE
  _TRG._DB-REQUIRED = FALSE.

IF _TRG._tSECTION = "_DISPLAY-FIELDS":U THEN DO: /* OOPs Rearrange things */
  IF _inp_line[5] NE "_FREEFORM":U THEN DO:
    DELETE _TRG.
    RETURN.
  END.  
  FIND _NAME-REC WHERE _NAME-REC._wNAME  eq _inp_line[3]
                   AND _NAME-REC._wTYPE  eq "BROWSE":U.
  ASSIGN _TRG._tSPECIAL = _TRG._tSECTION
         _TRG._tSECTION = "_CONTROL":U
         _TRG._tEVENT   = "DISPLAY":U
         _TRG._wRECID   = _NAME-REC._wRECID.
      
  /* Need to read once more to move over blank line put in by ANALYZER */
  IMPORT STREAM _P_QS _inp_line.
  /* Read again to read over the "DISPLAY" */
  IMPORT STREAM _P_QS _inp_line.
  _inp_line = "".
END.

/* All non-control (trigger) sections are associated with the window itself */
IF _TRG._tSECTION ne "_CONTROL" THEN DO:
  FIND _U WHERE _U._HANDLE = _h_win.
  _TRG._wRECID = RECID(_U).
END.

/* Continue filling the _TRG record. */
IF _TRG._tSPECIAL NE "_DISPLAY-FIELDS":U THEN
CASE _TRG._tSECTION:

  WHEN "_CONTROL":U THEN DO: /* Widget Trigger code */
    ASSIGN org-name       = _inp_line[3]
           browse-column  = FALSE.
    
    IF NOT trig_found THEN
      ASSIGN cur_sect   = {&CONTROLTRIG}
             trig_found = YES.
             
    CASE NUM-ENTRIES(org-name,".":U):
      WHEN 1 THEN ASSIGN db-name  = ?
                         tbl-name = ?
                         fld-name = org-name.
      WHEN 2 THEN ASSIGN db-name = ?
                         tbl-name = ENTRY(1,org-name,".")
                         fld-name = ENTRY(2,org-name,".").
      WHEN 3 THEN ASSIGN db-name  = ENTRY(1,org-name,".")
                         tbl-name = ENTRY(2,org-name,".")
                         fld-name = ENTRY(3,org-name,".").
    END CASE.
    IF _inp_line[5] = "_BROWSE-COLUMN":U THEN
      ASSIGN browse-column = TRUE
             browse-name   = _inp_line[4].
      
    /* Need to read once more to move over blank line put in by ANALYZER */
    IMPORT STREAM _P_QS _inp_line.
    _inp_line = "".
    _inp_line[2] = ?.
    IMPORT STREAM _P_QS _inp_line.
    IF _inp_line[2] = ? THEN _inp_line[2] = "-".  /* This is necessary because - is */
                                                  /* a valid keystroke event and    */
                                                  /* would otherwise get converted  */
                                                  /* to " "                         */
    IF NOT browse-column THEN DO:                
      /* Get the _NAME-REC - Note that db-name may be unknown if the user asked
         to suppress_dbname in the source code, so we must handle this case by
         not checking the _wDBNAME. */
      /* Added the check for "PROCEDURE" to support special events that can be attached
         to any widget type. Example, Adm.Validate attached to DB field. - jep 11/21/97 */
      FIND _NAME-REC WHERE _NAME-REC._wNAME  = fld-name 
                       AND _NAME-REC._wTABLE = tbl-name
                       AND (IF db-name NE ? 
                            THEN _NAME-REC._wDBNAME = db-name
                            ELSE TRUE) 
                       AND (IF _inp_line[1] <> "PROCEDURE"
                            THEN _NAME-REC._wFRAME = _inp_line[7]
                            ELSE TRUE)
                       NO-ERROR.
      IF NOT AVAILABLE _NAME-REC AND x_P._TYPE BEGINS "WEB":u THEN DO:
      /* WEB events are only attached to the DEFAULT-FRAME. So _inp_lin[7]
         will not contain any data. So we must try the find again without using
         the _wFRAME reference. */
        FIND _NAME-REC WHERE _NAME-REC._wNAME  = fld-name 
                         AND _NAME-REC._wTABLE = tbl-name
                         AND (IF db-name NE ? 
                              THEN _NAME-REC._wDBNAME = db-name
                              ELSE TRUE) NO-ERROR.
      END.
      ELSE IF NOT AVAILABLE _NAME-REC AND pImportMode = "IMPORT" THEN DO:
        FIND _U WHERE _U._HANDLE = _h_frame NO-ERROR.
         IF AVAILABLE _U THEN
           FIND _NAME-REC WHERE _NAME-REC._wNAME  = fld-name 
                            AND _NAME-REC._wTABLE = tbl-name
                            AND (IF db-name NE ? 
                                 THEN _NAME-REC._wDBNAME = db-name
                                 ELSE TRUE) 
                            AND _NAME-REC._wFRAME = _U._NAME NO-ERROR.
      
      END.
    END.  /* If normal _U type widget */
    ELSE DO:  /* IF browse column trigger */
      FIND _NAME-REC WHERE _NAME-REC._wNAME = browse-name.
      FIND _BC WHERE _BC._x-recid = _NAME-REC._wRECID
                 AND _BC._TABLE  = tbl-name
                 AND _BC._NAME   = fld-name
                 AND (IF db-name NE ? 
                      THEN _BC._DBNAME = db-name ELSE TRUE) NO-ERROR.
      /* Added if field removed from SDO (or database) and trigger exists */
      IF NOT AVAILABLE _BC THEN
      DO:
         DELETE _TRG.
         RETURN.
      END.
    END.

    IF NOT AVAILABLE _NAME-REC THEN  /* Menus, windows, frames
                                        and dialog-boxes                  */
      FIND _NAME-REC WHERE _NAME-REC._wNAME  = org-name NO-ERROR.

    IF NOT AVAILABLE _NAME-REC THEN valid_code = FALSE.
    ELSE DO:
      /* Associate the trigger with this record */
      _TRG._wRECID = IF NOT browse-column THEN _NAME-REC._wRECID
                                          ELSE RECID(_BC).

      /* Find _tEVENT in the next line which contains:
       *    "ON event OF widget"   
       * or "ON event OF FRAME widget"
       * or PROCEDURE frame.control-name.event (OCX's)
       * or PROCEDURE Adm.event (special events)
       */
      
      ASSIGN valid_code = no
             vbx_proc   = no. 
      IF     (_inp_line[1] = "ON" AND _inp_line[3] = "OF")
         AND (_inp_line[4] = org-name OR _inp_line[5] = org-name) THEN valid_code = yes.
      ELSE IF (_inp_line[1] = "PROCEDURE":U AND NUM-ENTRIES(_inp_line[2], ".":U) > 1) OR
              (_inp_line[1] = "PROCEDURE":U AND x_P._TYPE BEGINS "WEB":U) THEN DO:

        /* Special events where _tSPECIAL is ? are considered OCX events from V8 files,
           so we upgrade to the new file format. */
        IF (_TRG._tSPECIAL = ?) THEN DO:
          /* The names of OCX and WEB event procedures are translated from 
             <frame>.<control>.<event> to OCX.<event> or WEB.<event> in the 
             internal data structures.
           */
          ASSIGN _TRG._tSPECIAL = "{&WT-CONTROL}" + ".":U +
                             ENTRY(NUM-ENTRIES(_inp_line[2], ".":U),_inp_line[2], ".":U).
        END.

        /*
         * The names of VBX and WEB event procedures are translated from
         * <var>.<event> to VBX.<event> or WEB.<event> in the internal data
         * structures. That is how the event will appear to the user.
         */
        ASSIGN valid_code  = yes
               vbx_proc    = NOT (x_P._TYPE BEGINS "WEB":U) 
              _inp_line[2] = (IF vbx_proc THEN _TRG._tSPECIAL ELSE 
                "WEB.":U + ENTRY(NUM-ENTRIES(_inp_line[2], ".":U),_inp_line[2], ".":U)).

        /*
        ASSIGN valid_code  = yes
               vbx_proc    = yes
              _inp_line[2] = _TRG._tSPECIAL.
        */

        /* Store special event info. */
        ASSIGN _TRG._tTYPE = "_CONTROL-PROCEDURE":U.
      END.
      
      /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
        COMPATIBILITY CHECK --
         In 7.2A-7.2E, database fields had a problem.  The org-name is only
         the field-name, not the db.table.  For compatability, then, check
         whether a failed load here is the result of a database field having
         the wrong number of db.tbl.name items.  If this is the problem, then
         just assume that the name in _inp_line[4] is correct. */
      IF valid_code eq FALSE AND 
         NUM-ENTRIES(org-name, ".") < NUM-ENTRIES(_inp_line[4], ".") THEN DO:
        org-name = _inp_line[4]. 
        IF NUM-ENTRIES(org-name,".":U) eq 2 
        THEN ASSIGN db-name = ?
                    tbl-name = ENTRY(1,org-name,".")
                    fld-name = ENTRY(2,org-name,".").
        ELSE ASSIGN db-name  = ENTRY(1,org-name,".")
                    tbl-name = ENTRY(2,org-name,".")
                    fld-name = ENTRY(3,org-name,".").
        /* Get the _NAME-REC - Note that db-name may be unknown if the user asked
           to suppress_dbname in the source code, so we must handle this case by
           not checking the _wDBNAME. */
        FIND _NAME-REC WHERE _NAME-REC._wNAME  = fld-name 
                         AND _NAME-REC._wTABLE = tbl-name
                         AND (IF db-name NE ? 
                              THEN _NAME-REC._wDBNAME = db-name
                              ELSE TRUE) 
                         AND _NAME-REC._wFRAME = _inp_line[7] NO-ERROR.
        IF AVAILABLE _NAME-REC
        THEN ASSIGN _TRG._wRECID = _NAME-REC._wRECID
                    valid_code    = TRUE.
      END.         
      /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
      IF valid_code THEN _TRG._tEVENT = _inp_line[2].
    END.  /* Found the name */
  END.

  WHEN "_PROCEDURE":U THEN DO: /* .W Procedure code */
    /* Need to read once more to move over blank line put in by ANALYZER */
    IF NOT ips_found THEN
      ASSIGN cur_sect  = {&INTPROCS}
             ips_found = YES.
    
    IMPORT STREAM _P_QS _inp_line.
    _inp_line = "".
    IMPORT STREAM _P_QS _inp_line.
    
    /* Find _tEVENT in the next line which contains "PROCEDURE name." */  
    /* (i.e. tEVENT maps to the procedure name)                       */ 
    IF _inp_line[1] = "PROCEDURE" THEN DO:
      /* The proc_name is item 2 -- remove trailing periods or colons. 
         (We write out the procedure as "PROCEDURE name :", but someone
          could have editted the file to say: "PROCEDURE name." */
      l_proc-name = RIGHT-TRIM(_inp_line[2], ".:":U).
      
      /* Make sure the name doesn't already exist */
      find first x_trg where x_trg._wrecid   = _TRG._wRECID
                         and x_trg._tsection = "_PROCEDURE":U
                         and x_trg._tEVENT   = l_proc-name
                       no-error.
      i = 0.
      repeat while available x_trg:
        assign i = i - 1.
        find first x_trg where x_trg._wrecid   = _TRG._wRECID
                           and x_trg._tsection = "_PROCEDURE":U
                           and x_trg._tEVENT   = l_proc-name + string(i,"->>>9":U)
                        no-error.
      end.  /* REPEAT */
      IF i < 0 then assign l_proc-name = l_proc-name + TRIM(string(i,"->>>9":U)).
      _TRG._tEVENT = l_proc-name.     

      /* Check for PRIVATE keyword. jep-code */
      ASSIGN private_block = RIGHT-TRIM(_inp_line[3], ".:":U).
      IF TRIM(private_block) = "PRIVATE":U THEN
        ASSIGN _TRG._PRIVATE-BLOCK = TRUE.

    END.
    ELSE valid_code = FALSE.
  END.

  WHEN "_FUNCTION":U OR WHEN "_FUNCTION-EXTERNAL":U THEN DO: /* .W Function code */
    /* Need to read once more to move over blank line put in by ANALYZER */
    IF NOT ips_found THEN
      ASSIGN cur_sect  = {&INTPROCS}  /* jep {&INTFUNCS} */
             ips_found = YES.
    
    IMPORT STREAM _P_QS _inp_line.
    _inp_line = "".
    IMPORT STREAM _P_QS _inp_line.
    
    /* Find _tEVENT in the next line which contains "FUNCTION name." */  
    /* (i.e. tEVENT maps to the function name)                       */ 
    IF _inp_line[1] = "FUNCTION" THEN DO:
      /* The func_name is input 2 -- remove trailing periods or colons. 
         We write out the func as "FUNCTION name RETURNS <data-type> [PRIVATE]".
         The RETURNS <data-type> is actually part of the code block. */
      ASSIGN l_proc-name = TRIM(_inp_line[2]).
      ASSIGN _TRG._tCODE = _inp_line[3]
             lastCopied  = 3.
    
      /* If input 3 is the RETURNS keyword, then input 4 is the data-type.
         So add it after the RETURNS keyword. Otherwise, input 3 should be
         the data-type, so we do not add input 4. */
      IF TRIM(_inp_line[3]) = "RETURNS":U THEN
          ASSIGN _TRG._tCODE = _TRG._tCODE + " " + _inp_line[4]
                 lastCopied  = 4.
      
      /* Check for PRIVATE keyword. Must come right after data-type. So that's
         either input 4 or 5, since RETURNS is actually optional.
         jep-code */
      ASSIGN _TRG._PRIVATE-BLOCK = (TRIM(_inp_line[4]) = "PRIVATE" OR
                                    TRIM(_inp_line[5]) = "PRIVATE").

      /* Before adding the newline character, make sure we copy all tokens IZ 1947 */
      Copy-Entire-Line:
      DO i = lastCopied + 1 TO 100:
        IF _inp_line[i] NE "":U THEN
          _TRG._tCode = _TRG._tCode + " ":U + _inp_line[i].
        ELSE LEAVE Copy-Entire-Line.
      END.

      ASSIGN _TRG._tCODE = _TRG._tCODE + CHR(10).

      /* Make sure the name doesn't already exist */
      find first x_trg where x_trg._wrecid   = _TRG._wRECID
                         and x_trg._tsection = "_FUNCTION":U
                         and x_trg._tEVENT   = l_proc-name
                       no-error.
      i = 0.
      repeat while available x_trg:
        assign i = i - 1.
        find first x_trg where x_trg._wrecid   = _TRG._wRECID
                           and x_trg._tsection = "_FUNCTION":U
                           and x_trg._tEVENT   = l_proc-name + string(i,"->>>9":U)
                        no-error.
      end.  /* REPEAT */
      IF i < 0 then assign l_proc-name = l_proc-name + TRIM(string(i,"->>>9":U)).
      _TRG._tEVENT = l_proc-name.     
    END.
    ELSE valid_code = FALSE.
  END.

  WHEN "_XFTR":U THEN DO: /* .W Procedure code */
    org-name = _inp_line[3]. /* Name of xftr type. */
    /* Is it a INLINE XFTR (where the next line is the definition of the
     * XFTR access functions)? If so, create the XFTR record and read the
     * access functions.  NOTE: assign all inline xftr's a related .w recid.
     */
    IF _TRG._tSPECIAL eq "_INLINE":U THEN DO:
      CREATE _xftr.  
      ASSIGN _xftr._name   = org-name
             _xftr._wRECID = _TRG._wRECID.
      /* Need to read once more to move over blank line put in by ANALYZER */
      IMPORT STREAM _P_QS _inp_line.
      
      /* Read the access function line of form:                         */ 
      /* Functions: <realize.p> <edit.p> <destroy.p> <read.p> <write.p> */
      _inp_line = "".
      IMPORT STREAM _P_QS _inp_line.
      ASSIGN _xftr._realize = _inp_line[3]
             _xftr._edit    = _inp_line[4]
             _xftr._destroy = _inp_line[5]
             _xftr._read    = _inp_line[6]
             _xftr._write   = _inp_line[7]
             .
    END. 
    ELSE DO:
      /* If the XFTR is not inline, then make sure it exists seperately. */ 
      FIND _xftr WHERE _xftr._name eq org-name
                   AND _xftr._wRECID eq ?
                 NO-ERROR.
      IF NOT AVAILABLE _xftr THEN valid_code = FALSE.
    END.
    /* Point from the _TRG to the related _XFTR (we store the RECID of the
       _XFTR in the _TRG._tEVENT field) */          
    IF valid_code THEN
      ASSIGN
        _TRG._xRECID = RECID(_XFTR)
        _TRG._tLOCATION = cur_sect
        _TRG._tEVENT = ?.   
      ASSIGN cur_sect = INT(RECID(_TRG)).
  END.
    
  /* _CUSTOM sections */
  WHEN "_CUSTOM" THEN DO:
    _TRG._tEVENT = _inp_line[3].
    IF _TRG._tEVENT = "_DECLARATIONS" THEN DO:
      /* we're not supporting any XFTR before this, so we don't set cur_sect 
        (see comments where "_DECLARATIONS" is written in gendefs.p ) */    
      IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].
    END.
    ELSE IF _TRG._tEVENT = "_DEFINITIONS" THEN DO:
      def_found = TRUE.
      ASSIGN cur_sect = {&DEFINITIONS}.
      IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].
    END.
    ELSE IF _TRG._tEVENT = "_MAIN-BLOCK" THEN DO:
      main_found = TRUE.               
      ASSIGN cur_sect = {&MAINBLOCK}.
      IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].
      IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].
      IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].
    END.
    ELSE IF _TRG._tEVENT = "_INCLUDED-LIB" THEN DO:
      ASSIGN cur_sect = {&INCLUDED-LIB}.
      IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].
    END.
  END.
  OTHERWISE valid_code = FALSE.  /* We have an unexpected section */
END CASE.             

/* Now read the trigger. Note the special case of the "Create-objects"
   procedure.  In this case we need to generate objects. */
IF (_TRG._tSECTION = "_PROCEDURE":U) AND 
   (_TRG._tSPECIAL = "_ADM-CREATE-OBJECTS":U) THEN DO:
  IF x_P._adm-version = "" THEN x_P._adm-version = "ADM1".
  RUN adeuib/_rdsmar.p (_TRG._wRECID).
END.
ELSE IF (_TRG._tSECTION = "_PROCEDURE":U) AND 
        (_TRG._tSPECIAL = "_WEB-HTM-OFFSETS":U) THEN 
  RUN adeweb/_rdoffp.p (_TRG._pRECID).
ELSE DO: 
  /* Just read in the code block */
  READ-CODE:
  REPEAT ON END-KEY UNDO READ-CODE, RETRY READ-CODE:
    IF RETRY THEN _TRG._tCODE = _TRG._tCODE + "." + {&EOL}.
    IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].  
    /* Watch for lines that contain only ? 
       (eg. in an XFTR section.  -- Bug # 96-06-06-010 */
    IF _inp_line[1] eq ? THEN _inp_line[1] = "?".
    IF TRIM(_inp_line[1]) = "/* _UIB-CODE-BLOCK-END */" 
      THEN LEAVE READ-CODE.
    ELSE _TRG._tCODE = _TRG._tCODE + _inp_line[1] + {&EOL}.
  END.  /* READ-CODE:REPEAT */
END.

IF _TRG._tSECTION = "_XFTR" THEN /* wait til after code block is read in */  
  IF _XFTR._read NE ? THEN 
  DO ON STOP UNDO, LEAVE:
      run run_xftr_procedure in _h_uib(_XFTR._read, input INT(RECID(_TRG)),input-output _TRG._tCode).
 
  /*    RUN value(_XFTR._read) (INPUT INT(RECID(_TRG)), INPUT-OUTPUT _TRG._tCode).*/
  
  END.
  
/* Report an error if necessary. */
IF NOT valid_code THEN DO:
  /* Reset the cursor for user input.*/
  RUN adecomm/_setcurs.p ("").
  MESSAGE "Could not read code block:" SKIP
          _TRG._tSECTION _TRG._tEVENT org-name SKIP(2)
          SUBSTRING(_TRG._tCODE,1,240,"RAW":U)
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  /* Remove the _TRG if it could not be loaded */
  DELETE _TRG.
END.
ELSE DO:
  /* If this is a default PROCEDURE section then set the tCODE to unknown 
     (It will be  regenerated as needed. */
  IF (_TRG._tSECTION = "_PROCEDURE":U) AND (_TRG._tSPECIAL <> ?) THEN
    _TRG._tCODE = ?.
  /* Call ADE LIB-MGR to open Included Library files. */
  ELSE IF _TRG._tEVENT = "_INCLUDED-LIB":U THEN DO:
    IF VALID-HANDLE( _h_mlmgr ) THEN DO:
      RUN get-inclib-list IN _h_mlmgr ( _TRG._tCODE, {&EOL},
                                        OUTPUT ml_inclibs ).
      RUN open-lib IN _h_mlmgr ( STRING(_U._WINDOW-HANDLE), ml_inclibs,
                                 pBrokerURL ).
    END.
  END.
END.

/******************** debug code *************************
  MESSAGE "Code block for:" 
               _TRG._tSECTION _TRG._tSPECIAL 
               _TRG._tEVENT   org-name 
               SKIP (2)  SUBSTRING (_TRG._tCODE,1,360, "raw")
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.  */ 
  
/* _cdsuckr.p - end of file */
