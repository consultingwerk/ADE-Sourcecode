/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _genpro2.i

Description:
    Include file containing the internal procedures.  The reason
    for breaking this out into an include file these procedures need to be included
    in _gen4gl.p, _gendefs.p and _qikcomp.p
    
Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1992

Date Modified:
    12/02/94 GFS added ENABLED-FIELDS-IN-QUERY-<frame-name> PREPROCESSOR
    09/22/94 GFS added XFTR support
    2/94 by RPR (added attributes to 'OPEN QUERY')

---------------------------------------------------------------------------- */
/* ************************************************************************* */
/*                                                                           */
/*     COMMON PROCEDURES FOR DEFINING VIEW-AS SUPPORT, COLOR and FONT        */
/*                                                                           */
/* ************************************************************************* */



/* Build a simple list of tables from a 4gl query */
{adeuib/bld_tbls.i}  /* Contains build_table_list internal procedure */
  
/* Put out a simple code block for the current _TRG record. */
PROCEDURE put_code_block.
  IF p_status NE "PREVIEW"
  THEN PUT STREAM P_4GL UNFORMATTED
      "&ANALYZE-SUSPEND _UIB-CODE-BLOCK "
                        _TRG._tSECTION " " _TRG._tEVENT " " win_name " "
                        IF (_TRG._tSPECIAL <> ?) THEN _TRG._tSPECIAL ELSE ""
                        SKIP.
  IF _trg._tEVENT = "_MAIN-BLOCK" THEN PUT STREAM P_4GL UNFORMATTED SKIP (2).
  _TRG._tOFFSET = SEEK(P_4GL).
  PUT STREAM P_4GL UNFORMATTED TRIM(_TRG._tCODE).
  
  IF p_status NE "PREVIEW" 
  THEN PUT STREAM P_4GL UNFORMATTED SKIP (1) "/* _UIB-CODE-BLOCK-END */" SKIP
          "&ANALYZE-RESUME" SKIP (2).
  ELSE PUT STREAM P_4GL UNFORMATTED SKIP (2).
END PROCEDURE.


/* WRITES OUT XFTRs FOLLOWING A GIVEN UIB .W SECTION (loc) */
PROCEDURE put_next_xftrs:    
  DEFINE INPUT PARAMETER loc          AS INT   NO-UNDO. /* location */  
  DEFINE INPUT PARAMETER null_section AS LOG   NO-UNDO. 
  
  DEFINE VAR Uid                      AS RECID NO-UNDO. /* recid of window*/  
  
  FIND _U WHERE _U._HANDLE eq _h_win.
  Uid = RECID(_U).
  
  FIND  _TRG WHERE _TRG._tLOCATION EQ loc AND 
        _TRG._wRECID = Uid NO-ERROR.
  /* If nothing was written out for Triggers AND/OR Internal Procedures AND
   * we have XFTRs to write, we will write out a stub to mark the location 
   * to ensure that any XFTRs following these sections will be put in the 
   * correct place
   */                  
  IF null_section          AND 
     (loc = {&CONTROLTRIG}  OR loc = {&INTPROCS})   AND 
     p_status NE "PREVIEW" AND 
     AVAILABLE(_TRG)      THEN 
  DO:
    PUT STREAM P_4GL UNFORMATTED "&ANALYZE-SUSPEND ".
    IF loc = {&CONTROLTRIG} THEN
         PUT STREAM P_4GL UNFORMATTED "_UIB-CTRLTRIG-STUB" skip "/* _UIB-CTRLTRIG-STUB-END */" skip.
    ELSE PUT STREAM P_4GL UNFORMATTED "_UIB-INTPROC-STUB"  skip "/* _UIB-INTPROC-STUB-END */"  skip.
    PUT STREAM P_4GL UNFORMATTED "&ANALYZE-RESUME" skip(1).   
  END.

  DO WHILE AVAILABLE _TRG:
    FIND _xftr WHERE RECID(_xftr) EQ _TRG._xRECID.
    IF _xftr._write NE ? THEN 
    DO ON STOP UNDO, LEAVE:
      RUN VALUE(_xftr._write) (INPUT INT(RECID(_TRG)), INPUT-OUTPUT _TRG._tCode).
    END.
    IF p_status NE "PREVIEW" THEN DO:
      PUT STREAM P_4GL UNFORMATTED 
        "&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR " + "~"" + _xftr._name + "~" " +
        _U._NAME.
      IF _TRG._tSPECIAL = "_INLINE" THEN DO:
        PUT STREAM P_4GL UNFORMATTED " _INLINE" SKIP.
        PUT STREAM P_4GL UNFORMATTED "/* Actions: ".
      /*PUT STREAM P_4GL UNFORMATTED _XFTR._create.
        PUT STREAM P_4GL UNFORMATTED " ".     */
        PUT STREAM P_4GL UNFORMATTED _XFTR._realize. 
        PUT STREAM P_4GL UNFORMATTED " ".
        PUT STREAM P_4GL UNFORMATTED _XFTR._edit.
        PUT STREAM P_4GL UNFORMATTED " ". 
        PUT STREAM P_4GL UNFORMATTED _XFTR._destroy.
        PUT STREAM P_4GL UNFORMATTED " ".
        PUT STREAM P_4GL UNFORMATTED _XFTR._read.
        PUT STREAM P_4GL UNFORMATTED " ".
        PUT STREAM P_4GL UNFORMATTED _XFTR._write. 
        PUT STREAM P_4GL UNFORMATTED " */" SKIP.
      END.
      ELSE PUT STREAM P_4GL UNFORMATTED SKIP.   
    END.
    PUT STREAM P_4GL UNFORMATTED _TRG._tCode.    

    IF LENGTH(_TRG._tCode,"CHARACTER":u) > 0 THEN
      IF SUBSTRING(_TRG._tCode,LENGTH(_TRG._tCode,"CHARACTER":u),1,
                 "CHARACTER":u) <> CHR(10) THEN
        PUT STREAM p_4GL UNFORMATTED SKIP. ELSE.
    ELSE PUT STREAM p_4GL UNFORMATTED SKIP.

    IF p_status NE "PREVIEW":U THEN
      PUT STREAM P_4GL UNFORMATTED
        "/* _UIB-CODE-BLOCK-END */" skip
        "&ANALYZE-RESUME" skip(1).
    loc = INT(RECID(_TRG)).
    FIND _TRG WHERE _TRG._tLOCATION eq loc
              AND _TRG._wRECID      eq Uid NO-ERROR.     
  END.  
END. /* put_next_xftrs */

/* This sets the POSITION of a field level widget.        */
/* It operates on the current x_U, _C  records.           */ 
/*  INPUT indent = the new line indenting (eg. "     ")   */
PROCEDURE put_position.
  /* This is the indent to use on a new line */
  DEF INPUT PARAMETER indent AS CHAR.
  DEF INPUT PARAMETER usage  AS CHAR.  /* "DEF" or "R-T" of Run-Time adjust    */

  DEF VAR    tty_xcol AS DECIMAL NO-UNDO.
  DEF VAR    xcol     AS DECIMAL NO-UNDO.
  DEF VAR    lbl      AS CHAR    NO-UNDO.   
  DEF VAR    lbl_wdth AS DECIMAL NO-UNDO.
  DEF VAR    i        AS INTEGER NO-UNDO.
  DEF BUFFER tty_L    FOR _L.

  /* Need to be sure that it compiles in TTY mode                                 */
  IF usage = "DEF":U THEN
    FIND FIRST tty_L WHERE tty_L._u-recid = RECID(x_U) AND NOT tty_L._WIN-TYPE NO-ERROR.

  IF AVAILABLE tty_L THEN
    PUT STREAM P_4GL UNFORMATTED
	  SKIP "          &IF '~{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW "
	       (IF NOT _L._NO-LABELS AND NOT _C._SIDE-LABELS
      THEN INTEGER( 1 + MAX( 0, tty_L._ROW - _C._FRAME-BAR:ROW - 
					      (2 / SESSION:PIXELS-PER-ROW)))
      ELSE INTEGER(tty_L._ROW)) " COL ".

  /* Look at the label of fill-ins, if there is one and we need to left-align. */
  IF (CAN-DO("FILL-IN,COMBO-BOX",x_U._TYPE)    AND  NOT x_L._NO-LABELS  AND
     NOT _L._NO-LABELS  AND x_U._l-recid NE ?  AND  x_U._ALIGN = "L")
  THEN DO:
    lbl_wdth = 0.
    /* Get the currently specified label */
    IF _U._LABEL-SOURCE = "D" THEN DO:
      IF _U._TABLE EQ ? THEN lbl = x_U._NAME.
      ELSE RUN adeuib/_strfmt.p (x_U._LABEL, x_U._LABEL-ATTR, no, OUTPUT lbl).
    END.
    ELSE 
      RUN adeuib/_strfmt.p (x_U._LABEL, x_U._LABEL-ATTR, no, OUTPUT lbl).

    /* Note, on MS-WINDOWS, & characters are removed (and && becomes &).
       This allows for mnemonics in the label. */
    &IF "{&WINDOW-SYSTEM}" eq "MS-WINDOWS" &THEN
    lbl = REPLACE (REPLACE( REPLACE (lbl,"&&",CHR(10)) ,"&",""), CHR(10),"&").
    &ENDIF

    /* Check for no-labels or down-frame */ 
    IF _C._SIDE-LABELS THEN
      /* Compute the size of the label - then add in the ": ". */
      ASSIGN lbl      = lbl + ": "
             lbl_wdth = (IF NOT _L._WIN-TYPE THEN LENGTH(lbl,"CHARACTER":U) ELSE
                       FONT-TABLE:GET-TEXT-WIDTH (lbl, _L._FONT)).
    ELSE DO:
      lbl_wdth = 0.
      /* Get each line (! delimited) of the label and find the maximum width */
      DO i = 1 TO NUM-ENTRIES (lbl, "!"):
        lbl_wdth = MAX (lbl_wdth,
                        (IF NOT _L._WIN-TYPE THEN LENGTH(lbl,"CHARACTER":U) ELSE
                         FONT-TABLE:GET-TEXT-WIDTH(ENTRY(i,lbl,"!"), _L._FONT))).
      END.
    END.   
    IF AVAILABLE tty_L THEN 
      ASSIGN tty_xcol = MAX(INTEGER(tty_L._COL - LENGTH(lbl,"CHARACTER":U)), 1). 
    ASSIGN xcol = MAX(x_L._COL - lbl_wdth, 1). 
  END.
  /* All others. */
  ELSE DO:
    /* Emergency test -- Change alignment a colon-aligned widget that would
     otherwise be outside the screen */
    IF x_U._ALIGN = "C":U AND x_L._COL < 3 THEN x_U._ALIGN = "L":U.
    IF x_U._LAYOUT-UNIT THEN 
      CASE x_U._ALIGN:
	WHEN "C" THEN xcol = x_L._COL - 2.
	WHEN "R" THEN xcol = x_L._COL + x_L._WIDTH - 1.0.
	OTHERWISE     xcol = x_L._COL.
      END CASE.
    ELSE /* LAYOUT in Pixels */
      CASE x_U._ALIGN:
	WHEN "C" THEN xcol = INTEGER((x_L._COL - 1) * SESSION:PIXELS-PER-COLUMN) -
				  (2 * SESSION:PIXELS-PER-COLUMN).
	WHEN "R" THEN xcol = INTEGER((x_L._COL - 1) * SESSION:PIXELS-PER-COLUMN) +
				  INTEGER(x_L._WIDTH * SESSION:PIXELS-PER-COLUMN) - 1.
	OTHERWISE     xcol = INTEGER((x_L._COL - 1) * SESSION:PIXELS-PER-COLUMN).
      END CASE.
  END.
  ASSIGN xcol = MAX( IF x_U._LAYOUT-UNIT THEN 1 ELSE 0, xcol).   
  IF tty_xcol = 0 AND AVAILABLE tty_L THEN 
    /* If tty_xcol was not calculated, then default to INT(tty_L._COL) */
    ASSIGN tty_xcol = MAX(INTEGER(tty_L._COL), 1). 
  
  /* Everything is settled (almost).  xcol is the place.  However, if there is a
     TTY based layout and xcol is less than the length of the label + 1, we must
     move it over to the right or it won't compile in TTY mode.  Therefore, we need
     the following block.                                                        */
  IF (CAN-DO("FILL-IN,COMBO-BOX",x_U._TYPE)    AND  NOT x_L._NO-LABELS  AND
     NOT _L._NO-LABELS  AND x_U._l-recid NE ?  AND  x_U._ALIGN = "C" AND
     AVAILABLE tty_L AND LENGTH(x_U._LABEL,"RAW") > tty_L._COL - 2) THEN
       PUT STREAM P_4GL UNFORMATTED INTEGER(LENGTH(x_U._LABEL,"RAW") + 2)
       " COLON-ALIGNED" SKIP "          &ELSE".
  ELSE IF AVAILABLE tty_L THEN DO: 
       PUT STREAM P_4GL UNFORMATTED 
         (IF x_U._ALIGN = "C" THEN INTEGER(tty_L._COL - 2)
          ELSE IF x_U._ALIGN = "R" THEN INTEGER(tty_L._COL + tty_L._WIDTH - 1)
          ELSE IF CAN-DO("FILL-IN,COMBO-BOX",x_U._TYPE) THEN tty_xcol
          ELSE INTEGER(tty_L._COL))
         (IF x_U._ALIGN = "C" THEN " COLON-ALIGNED"
          ELSE IF x_U._ALIGN = "R" THEN " RIGHT-ALIGNED"
          ELSE "") SKIP "          &ELSE".  
  END.
  IF x_U._LAYOUT-UNIT
   THEN PUT STREAM P_4GL UNFORMATTED indent "AT ROW " 
     (IF NOT _L._NO-LABELS AND NOT _C._SIDE-LABELS
      THEN ROUND ( 1 + MAX( 0, x_L._ROW - _C._FRAME-BAR:ROW - 
					      (2 / SESSION:PIXELS-PER-ROW)), 2 )
      ELSE ROUND(x_L._ROW, 2)) " COL ".
   ELSE PUT STREAM P_4GL UNFORMATTED indent "AT Y " 
     (IF NOT _L._NO-LABELS AND NOT _C._SIDE-LABELS THEN
       MAX(INTEGER((x_L._ROW - 1) * SESSION:PIXELS-PER-ROW) - _C._FRAME-BAR:Y - 2, 0)
					    ELSE
       (INTEGER((x_L._ROW - 1) * SESSION:PIXELS-PER-ROW))) " X ".

    PUT STREAM P_4GL UNFORMATTED 
      ROUND (xcol, IF x_U._LAYOUT-UNIT THEN 2 ELSE 0)
      IF x_U._ALIGN = "C" THEN " COLON-ALIGNED"
      ELSE IF x_U._ALIGN = "R" THEN " RIGHT-ALIGNED"
      ELSE "".
  IF AVAILABLE tty_L THEN
    PUT STREAM P_4GL UNFORMATTED " &ENDIF".
    
END PROCEDURE.

 
/* This sets the SIZE of a field level widget.             */
/* It operates on the current x_U  records.                */ 
/*  INPUT indent = the new line indenting (eg. "     ")    */
PROCEDURE put_size.
  /* This is the indent to use on a new line */
  DEF INPUT PARAMETER indent AS CHAR.
  DEF INPUT PARAMETER usage  AS CHAR.  /* "DEF" or "R-T" of Run-Time adjust    */

  DEF BUFFER tty_L FOR _L.
  
  FIND x_L WHERE x_L._u-recid = RECID(x_U) AND x_L._LO-NAME = "Master Layout".
  IF NOT x_L._WIN-TYPE THEN DO:  /* If TTY mode make sure sizes are above mins */
    IF CAN-DO("RECTANGLE,BUTTON,COMBO-BOX,FILL-IN,TEXT",x_U._TYPE) THEN DO:
      IF x_L._HEIGHT < 1 OR x_L._WIDTH < 1 THEN  RUN adjust_size_x (1, 1).
    END.
    ELSE IF x_U._TYPE = "EDITOR":U AND NOT x_U._SCROLLBAR-V THEN DO:
      IF x_L._HEIGHT < 1 OR x_L._WIDTH < 3 THEN  RUN adjust_size_x (1, 3).
    END.
    ELSE IF CAN-DO("RADIO-SET,SELECTION-LIST,EDITOR",x_U._TYPE) THEN DO:
      IF x_L._HEIGHT < 3 OR x_L._WIDTH < 3 THEN  RUN adjust_size_x (3, 3).
    END.
    ELSE IF x_U._TYPE = "TOGGLE-BOX" THEN DO:
      IF x_L._HEIGHT < 1 OR x_L._WIDTH < 3 THEN  RUN adjust_size_x (1, 3).
    END.
    ELSE IF x_U._TYPE = "SLIDER" THEN DO:
      IF _F._HORIZONTAL AND (x_L._HEIGHT < 2 OR x_L._WIDTH < 7) THEN
	  RUN adjust_size_x (2, 7).
      IF NOT _F._HORIZONTAL AND (x_L._HEIGHT < 3 OR x_L._WIDTH < 9) THEN
	  RUN adjust_size_x (3, 9).
      END.  /* Slider */
  END.
  
  /* Make sure TTY version (if exists) will compile                                  */
  IF usage = "DEF":U THEN
    FIND FIRST tty_L WHERE tty_L._u-recid = RECID(x_U) AND NOT tty_L._WIN-TYPE NO-ERROR.
  IF AVAILABLE tty_L THEN 
    PUT STREAM P_4GL UNFORMATTED
	  SKIP indent "&IF '~{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE "
	      INTEGER(tty_L._WIDTH) " BY " INTEGER(tty_L._HEIGHT) SKIP indent "&ELSE ".
  ELSE PUT STREAM P_4GL UNFORMATTED SKIP indent.
  
  IF x_U._LAYOUT-UNIT THEN
    PUT STREAM P_4GL UNFORMATTED
	  "SIZE " ROUND(x_L._WIDTH, 2) " BY " ROUND(x_L._HEIGHT, 2).
  ELSE
    PUT STREAM P_4GL UNFORMATTED
	  "SIZE-PIXELS " MAX(1,INTEGER(x_L._WIDTH * SESSION:PIXELS-PER-COLUMN))
	   " BY "        MAX(1,INTEGER(x_L._HEIGHT * SESSION:PIXELS-PER-ROW)).
  IF AVAILABLE tty_L THEN 
    PUT STREAM P_4GL UNFORMATTED " &ENDIF".
	   
END PROCEDURE.

                            
PROCEDURE adjust_size_x.
  DEFINE INPUT PARAMETER min-hgt  AS INTEGER                               NO-UNDO.
  DEFINE INPUT PARAMETER min-wdth AS INTEGER                               NO-UNDO.
  
  MESSAGE x_U._TYPE x_U._NAME "is too small for character mode realization." SKIP
          "Increasing its size to" MAX(x_L._HEIGHT,min-hgt) "BY"
                                   MAX(x_L._WIDTH,min-wdth) "for character mode only."
          VIEW-AS ALERT-BOX.
  ASSIGN x_L._HEIGHT = MAX(x_L._HEIGHT,min-hgt)
         x_L._WIDTH  = MAX(x_L._WIDTH,min-wdth).
END.  /* Procedure adjust-size */


PROCEDURE Put_Special_Preprocessor_Start.

    DEFINE VAR Db-Required_Start AS CHAR INIT '~{&DB-REQUIRED-START~}'.

    /* Start DB-REQUIRED Preprocessor block. */
    IF _P._DB-AWARE AND _TRG._DB-REQUIRED THEN
        PUT STREAM P_4GL UNFORMATTED Db-Required_Start SKIP(1).

    /* Start Method Libary Procedure EXCLUDE Preprocessor block. */
    IF (_P._TYPE = "Method-Library":U OR _P._TYPE = "Procedure":U) THEN
        PUT STREAM P_4GL UNFORMATTED
          {&AMPER-IF} ' DEFINED(EXCLUDE-' _TRG._tEVENT ') = 0 ' {&AMPER-THEN}
          SKIP(1).
END PROCEDURE.


PROCEDURE Put_Special_Preprocessor_End.

    DEFINE INPUT PARAM p_Skip AS INTEGER NO-UNDO.

    DEFINE VAR Db-Required_End AS CHAR INIT '~{&DB-REQUIRED-END~}'.

    /* End Method Libary Procedure EXCLUDE Preprocessor block or
       PDO Preprocessor block. */
    IF (_P._TYPE <> "Method-Library":U AND _P._TYPE <> "Procedure":U) AND
       (NOT _TRG._DB-REQUIRED AND NOT _P._DB-AWARE)
    THEN PUT STREAM P_4GL UNFORMATTED SKIP (p_Skip).
    ELSE DO:
      PUT STREAM P_4GL UNFORMATTED SKIP (1).
      IF (_P._TYPE = "Method-Library":U OR _P._TYPE = "Procedure":U)
      THEN PUT STREAM P_4GL UNFORMATTED {&AMPER-ENDIF} SKIP(1).
      IF _P._DB-AWARE AND _TRG._DB-REQUIRED
      THEN PUT STREAM P_4GL UNFORMATTED Db-Required_End SKIP(1).
    END.
END PROCEDURE.

PROCEDURE add-func-private.
/*------------------------------------------------------------------------------
  Purpose:  Adds the PRIVATE keyword to the first line in a code block for
            functions defined as "private".
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER p_Code AS CHARACTER NO-UNDO.

  DEFINE VAR First-Line AS CHARACTER NO-UNDO.
  /* We'll add the PRIVATE keyword just before the first EOL character.
     This will change lines like this:
        FUNCTION Func_Private RETURNS CHARACTER
     to this:
        FUNCTION Func_Private RETURNS CHARACTER PRIVATE
  */
  ASSIGN First-Line = SUBSTRING(p_Code, 1, INDEX(p_Code, CHR(10)), "CHARACTER":U).
  /* If the PRIVATE keyword isn't already in the first code line, add it to the end. */
  IF INDEX(First-Line, " PRIVATE":U) = 0 THEN
  DO:
    ENTRY(1, p_Code, CHR(10)) = TRIM(ENTRY(1, p_Code, CHR(10))) + " PRIVATE":U.
  END.
END PROCEDURE.


PROCEDURE remove-func-private.
/*------------------------------------------------------------------------------
  Purpose:  Removes the PRIVATE keyword from the first line in a code block for
            functions defined as not "private".
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER p_Code AS CHARACTER NO-UNDO.

  DEFINE VAR First-Line AS CHARACTER NO-UNDO.
  DEFINE VAR iPosition  AS INTEGER   NO-UNDO.
  /* We'll add the PRIVATE keyword just before the first EOL character.
     This will change lines like this:
        FUNCTION Func_Private RETURNS CHARACTER
     to this:
        FUNCTION Func_Private RETURNS CHARACTER PRIVATE
  */
  ASSIGN First-Line = SUBSTRING(p_Code, 1, INDEX(p_Code, CHR(10)), "CHARACTER":U)
         iPosition  = INDEX(First-Line, " PRIVATE":U).
  /* If the PRIVATE keyword isn't already in the first code line, add it to the end. */
  IF iPosition > 0 THEN
  DO:
    ENTRY(1, p_Code, CHR(10)) = SUBSTRING(ENTRY(1, p_Code, CHR(10)), 1, iPosition).
  END.
END PROCEDURE. /* remove-func-private */


/* Populate _MSG statment with ERROR-STATUS messages.
   If you execute COMPILE..NO-ERROR, _MSG population is suppressed.
   Call this routine if you want it populate. */
PROCEDURE add-cmp-msgs:

    DEFINE VARIABLE error_num AS INTEGER NO-UNDO.
    
    DO error_num = 1 TO ERROR-STATUS:NUM-MESSAGES:
      ASSIGN _MSG = ERROR-STATUS:GET-NUMBER( error_num ).
    END.

END PROCEDURE.


