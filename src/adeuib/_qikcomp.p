/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _qikcomp.p

Description:
    Quick Compile implements Section Editor Check Syntax to do a syntax check on
    a single code section. A temporary compile file with only minimal code is
    generated to check the compilation, up to and including the specified section.
    
    The code section we are checking has RECID = _err_recid.
    
Input Parameters:
   pcStatus - When "PRINT-SECTION", this procedure is being called from Section 
              Editor Print Option and will only generate code for the section 
              being printed.  It will not fire ADE events and will not attempt 
              to compile the generated code. 

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1992

Last modified on 
    04/26/01 by jep - IZ 993. Added support for check syntax of local
                      WebSpeed V2 files. Search on variable WSV2_CkSyntx
                      for code changes.

     	                For Section Editor Check Syntax on WebSpeed V2 files,
     	                _qikcomp.p calls adeuib/_genweb.p to only generate the
     	                web file with the appropriate code necessary to check
     	                the syntax of the specified section. For all other
     	                files (non-v2), _qikcomp.p generates the appropriate
     	                code on its own (with help from call to adeshar/_gendefs.p).

    06/17/99 by tsm - added extra spaces to end of temp file when pcstatus  
                      is print-section to avoid problem where import 
                      overwrites last line with previous line when print
                      the file
    04/27/99 by tsm - added pcStatus input parameter to take advantage of
                      this procedure's code generation to generate a code
                      block for printing without checking syntax 
    04/07/99 by tsm - add support for various Intl Numeric Formats (in 
                      addition to American and European) by using session
                      set-numeric-format method to set format back
                      to user's setting after it is set to American
    10/5/94  by gfs - added XFTR.I

---------------------------------------------------------------------------- */
{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/layout.i}       /* Layout temp-table definiitons                     */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/xftr.i}         /* XFTR TEMP-TABLE definition                        */
{adeuib/brwscols.i}     /* Brose columns temptable definitions               */
{adecomm/adestds.i}
{adeuib/sharvars.i}
{adecomm/adeintl.i}

{adeshar/genshar.i NEW} /* Shared variables for _gendefs.p */

DEFINE INPUT PARAMETER pcStatus AS CHARACTER                          NO-UNDO.

/* FUNCTION PROTOTYPE */
FUNCTION db-fld-name RETURNS CHARACTER
  (INPUT rec-type AS CHARACTER, INPUT rec-recid AS RECID) IN _h_func_lib.

DEFINE VARIABLE cancel_btn   AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE curr_browse  AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE default_btn  AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE define_type  AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE frame_layer  AS WIDGET-HANDLE                         NO-UNDO.
DEFINE VARIABLE i            AS INTEGER                               NO-UNDO.
DEFINE VARIABLE lError       AS LOGICAL                               NO-UNDO.      
DEFINE VARIABLE lScrap       AS LOGICAL                               NO-UNDO.      
DEFINE VARIABLE cMsg         AS CHARACTER                             NO-UNDO.      
DEFINE VARIABLE n_down       AS INTEGER                               NO-UNDO.
DEFINE VARIABLE ok2continue  AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE p_status     AS CHARACTER  INITIAL "RUN"              NO-UNDO.
DEFINE VARIABLE iteration_ht AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE q_label      AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE rel_name     AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE self_name    AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE stack_lbl_rw AS INTEGER                               NO-UNDO.
DEFINE VARIABLE stp          AS INTEGER                               NO-UNDO.
DEFINE VARIABLE strt         AS INTEGER                               NO-UNDO.
DEFINE VARIABLE temp_file    AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE WSV2_CkSyntx AS LOGICAL                               NO-UNDO.

/* Stuff for browse etc */
DEFINE VARIABLE qry_defs     AS LOGICAL         INITIAL FALSE         NO-UNDO.
       /* qry_defs    is a flag to indicate if query variable definitions    */
       /*             have been outputted                                    */
DEFINE VARIABLE brwsr_bufs   AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE tmp_string   AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE tmp_string2  AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE OCXName      AS CHARACTER                             NO-UNDO.

DEFINE BUFFER x_U   FOR _U.
DEFINE BUFFER xx_U  FOR _U.
DEFINE BUFFER x_L   FOR _L.
DEFINE BUFFER x_C   FOR _C.
DEFINE BUFFER x_Q   FOR _Q.
DEFINE BUFFER x_F   FOR _F.
DEFINE NEW SHARED STREAM P_4GL.

/* Notify others of BEFORE and AFTER the partial check syntax.  Provide
   opportunity for developer to cancel. */
FIND _P WHERE _P._WINDOW-HANDLE eq _h_win.

IF pcStatus NE "PRINT-SECTION":U THEN DO:
  RUN adecomm/_adeevnt.p (INPUT  "AB":U,
                          INPUT  "BEFORE-CHECK-SYNTAX-PARTIAL",
                          INPUT  STRING(_P._u-recid),
                          INPUT  _P._SAVE-AS-FILE,
                          OUTPUT ok2continue).
  IF NOT ok2continue THEN RETURN.
END.  /* if not printsection */

/* Clean out _TRG._toffsets */
FOR EACH _TRG WHERE _TRG._pRECID = RECID(_P):
  _TRG._tOFFSET = ?.
END.


/* ************************************************************************* */
DO ON STOP UNDO, LEAVE:

  RUN adecomm/_setcurs.p ("WAIT").  /* Set cursor in all windows/Dialogs */
  
  ASSIGN SESSION:NUMERIC-FORMAT = "AMERICAN":U.
  
  /* Open output file                                                          */ 
  IF _comp_temp_file = ? THEN
    RUN adecomm/_tmpfile.p
        ({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB}, OUTPUT _comp_temp_file).

  ASSIGN p_status = "CHECK-SYNTAX":U.

  ASSIGN WSV2_CkSyntx = (_P._file-version BEGINS "WDT_v2":U) AND (pcStatus NE "PRINT-SECTION":U) NO-ERROR.
  IF WSV2_CkSyntx THEN
  DO:
    /* WSV2 Check syntax of specific section (_err_recid). temp_file and _comp_temp_file
       should be the same after the call. */
    RUN adeweb/_genweb.p (RECID(_P), "CHECK-SECTION":U, _err_recid, _comp_temp_file,
                          OUTPUT temp_file).
  END.
  ELSE /* Generate Code for non-WSV2 files or when print-section. */
  DO:

  OUTPUT STREAM P_4GL TO VALUE(_comp_temp_file) {&NO-MAP}.
  
  IF (pcStatus NE "PRINT-SECTION":U) THEN 
      RUN adeshar/_gendefs.p (INPUT p_status, INPUT FALSE).

  /* ************************************************************************* */
  /*                                                                           */
  /*                     OUTPUT INCLUDED LIBRARIES CODE BLOCK                  */
  /*                                                                           */
  /* ************************************************************************* */
  
  /* Output the included libraries (if any)                                    */
  IF pcStatus NE "PRINT-SECTION":U THEN DO:
    PUT STREAM P_4GL UNFORMATTED SKIP (1).
    FIND _U WHERE _U._HANDLE = _h_win.
    FIND _TRG  WHERE _TRG._wRECID = RECID(_U) AND
                     _TRG._tSECTION = "_CUSTOM" AND
                     _TRG._tEVENT BEGINS "_INCLUDED-LIB" AND
                     _TRG._STATUS EQ u_status NO-ERROR.
    IF AVAILABLE _TRG THEN RUN put_code_block.
    /* Write out any XFTRs that follow this Block. */
    IF p_status NE "EXPORT" THEN
      RUN put_next_xftrs (INPUT {&INCLUDED-LIB}, INPUT no).
  END.  /* if not printsection */
  
  
  /* ************************************************************************* */
  /*                                                                           */
  /*                       OUTPUT THE DESIRED CODE BLOCK                       */
  /*                                                                           */
  /* ************************************************************************* */
  
  FIND _TRG WHERE RECID(_TRG) = _err_recid.
  
  /* Is the desired trigger a REAL trigger (i.e. a CONTOL)? If so, write it. */
  
  IF _TRG._tSECTION = "_CONTROL" THEN DO:
    FIND _U WHERE RECID (_U) = _TRG._wRECID NO-ERROR.
    IF NOT AVAILABLE _U THEN DO:
      FIND _BC WHERE RECID(_BC) = _TRG._wRECID.
      FIND _U WHERE RECID(_U) = _BC._x-recid.
    END.
    FIND _F WHERE RECID (_F) = _U._x-recid no-error.
    IF AVAILABLE (_F) OR _U._TYPE = "BROWSE":U THEN
    DO:
      IF _U._TYPE eq "BROWSE":U THEN PUT STREAM P_4GL UNFORMATTED 
         "&Scoped-define BROWSE-NAME " _U._NAME SKIP.
      FIND x_U WHERE RECID(x_U) = _U._parent-recid.
      PUT STREAM P_4GL UNFORMATTED 
         "&Scoped-define FRAME-NAME  " x_U._NAME SKIP.
    END.
    /* Always put out SELF-NAME (which equals NAME [or tbl.name or db.tbl.name]) */
    self_name = IF _U._TABLE EQ ? OR (AVAILABLE _F AND _F._DISPOSITION EQ "LIKE":U)
                THEN _U._NAME  ELSE db-fld-name("_U":U, RECID(_U)).
    IF NUM-ENTRIES(self_name,".":U) eq 3 AND LOOKUP(ENTRY(1,self_name,".":U),_tt_log_name) > 0
    THEN self_name = ENTRY(2,self_name,".":U) + ".":U + ENTRY(3,self_name,".":U).
   
    PUT STREAM P_4GL UNFORMATTED
            "&Scoped-define SELF-NAME " self_name SKIP.
   
    /* (Removed 6/16/1999 - tomn) When checking syntax, we always want to
    ** include the code block.
    RUN Put_Special_Preprocessor_Start.
    */
  
    /*
     * Control Triggers that are special events are actually internal procedures
     * and use a different syntax than PROGRESS events. These special events in V9
     * have a value for _tSPECIAL and _tEVENT has more than one period.
     *
     * E.g., OCX Trigger events are stored internally as OCX.event but are written out
     * as frame.control.event. Changes here must be made in adeuib/_qikcomp.p too.
     */
  
    IF (NUM-ENTRIES(_TRG._tEVENT, ".") > 1) THEN
    DO:
        IF _U._TYPE = "{&WT-CONTROL}" THEN
        DO:
          /* JEP 1/16/97: OCX trigger is frame.control.event. */
          ASSIGN OCXName = IF (_U._OCX-NAME = "":U) OR (_U._OCX-NAME = ?)
                           THEN self_name ELSE _U._OCX-NAME.
          PUT STREAM P_4GL UNFORMATTED
            "PROCEDURE " self_name "." OCXName "." ENTRY(2, _TRG._tEVENT, ".") " ." SKIP
          . 
        END.
        ELSE DO:
          PUT STREAM P_4GL UNFORMATTED
            "PROCEDURE " self_name "." ENTRY(2, _TRG._tEVENT, ".") " ." SKIP
          . 
        END.
    END.
    ELSE DO:
  /*        Must compare using "not equals <>" because _TRG._tSPECIAL could
   *        be unknown value (?) and using a CAN-DO will result in a FALSE
   *        result. This was causing bug 95-07-06-036.
   * */
        IF (_TRG._tSPECIAL <> "_DISPLAY-FIELDS":U AND
            _TRG._tSPECIAL <> "_OPEN-QUERY":U AND
            _TRG._tEVENT <> "DEFINE_QUERY":U) THEN DO:
        /* ON event OF [TYPE] widget */
        PUT STREAM P_4GL UNFORMATTED
              "ON "   _TRG._tEVENT   " OF "
              (IF CAN-DO("FRAME,MENU,MENU-ITEM", _U._TYPE)  THEN  (_U._TYPE + " ")
               ELSE IF _U._TYPE = "SUB-MENU"                THEN "MENU "
               ELSE IF _U._TYPE = "DIALOG-BOX"              THEN "FRAME "
               ELSE "")
              self_name.
        IF     (AVAILABLE _F OR _U._TYPE = "BROWSE":U)
           AND (_U._TYPE <> "{&WT-CONTROL}") THEN
              PUT STREAM P_4GL UNFORMATTED " IN FRAME " x_U._NAME.
      END.  /* If not a psuedo event */
  
      PUT STREAM P_4GL UNFORMATTED SKIP.
    END.
    IF _TRG._tSPECIAL NE "_DISPLAY-FIELDS":U AND
       _TRG._tEVENT NE "DEFINE_QUERY":U THEN DO:
      IF _TRG._tSPECIAL = "_OPEN-QUERY":U THEN
        PUT STREAM P_4GL UNFORMATTED "&SCOPED-DEFINE KEY-PHRASE TRUE" SKIP.  
      _TRG._tOFFSET = SEEK(P_4GL).
      PUT STREAM P_4GL UNFORMATTED IF _TRG._tSPECIAL = "_OPEN-QUERY":U THEN
                 REPLACE(_TRG._tCODE,"~~","") ELSE _TRG._tCODE.
    END.
    
    IF (pcStatus = "PRINT-SECTION":U) AND (_TRG._tSPECIAL = "_DISPLAY-FIELDS":U) THEN
    DO:                             
      PUT STREAM P_4GL UNFORMATTED
              " DISPLAY":U SKIP.                                        
      PUT STREAM P_4GL UNFORMATTED FILL(" ":U,6) + TRIM(_TRG._tCODE) SKIP.
    END.
    
  END.
  ELSE IF NOT (_TRG._tSECTION = "_CUSTOM" and _TRG._tEVENT = "_DEFINITIONS") 
  THEN DO:
    /* _TRG is a _CUSTOM or _PROCEDURE Section.  We have already put out the
       custom "DEFINITIONS" section. We always want to put out the Main Block
       section for PROCEDURES -- The only reason we wouldn't want to put out
       the _TRG is if it is the Top-o'-file */
   
    /* *************************************************************** */
    /*                    OUTPUT MAIN CODE BLOCK                       */
    /* *************************************************************** */
    /* If we are printing then we only want to output the main block when we
       are trying to print the main block */
    IF (pcStatus = "PRINT-SECTION":U AND _TRG._tEVENT NE "_MAIN-BLOCK") THEN.
    ELSE DO:
      FIND _U WHERE _U._HANDLE = _h_win.
      FIND _TRG  WHERE _TRG._wRECID   = RECID(_U)     AND
                       _TRG._tSECTION = "_CUSTOM"     AND
                       _TRG._tEVENT   = "_MAIN-BLOCK" AND
                       _TRG._STATUS  NE "DELETED"     NO-ERROR.
      IF AVAILABLE _TRG THEN RUN put_code_block.
    END.  /* else do */
      
    /* Now do the Procedure or Function [Note that we need to re-find _TRG.] */
    FIND _TRG WHERE RECID(_TRG) = _err_recid.
    IF _TRG._tSECTION = "_PROCEDURE" THEN DO:
      /* (Removed 6/16/1999 - tomn) When checking syntax, we always want to
      ** include the code block.
      RUN Put_Special_Preprocessor_Start.
      */
      PUT STREAM P_4GL UNFORMATTED "PROCEDURE " _TRG._tEVENT.
      IF _TRG._PRIVATE-BLOCK THEN
          PUT STREAM P_4GL UNFORMATTED " PRIVATE :"  SKIP.   
      ELSE
          PUT STREAM P_4GL UNFORMATTED " :"  SKIP.   
      _TRG._tOFFSET = SEEK(P_4GL).
      /* Generate default code on the fly, otherwise use the user input code. */
      IF (_TRG._tCODE = ?) AND (_TRG._tSPECIAL <> ?) THEN DO:
        RUN adeshar/_coddflt.p (_TRG._tSPECIAL, _TRG._wrecid, OUTPUT tmp_string).
        PUT STREAM P_4GL UNFORMATTED tmp_string.
      END.
      ELSE 
        /* The trailing 'SKIP " "' ensures that the last line *with text* has a
           trailing carriage return. (dma) */
        PUT STREAM P_4GL UNFORMATTED TRIM(_TRG._tCODE) SKIP " ".    
    END.
    ELSE IF _TRG._tSECTION = "_FUNCTION" THEN DO:
      /* (Removed 6/16/1999 - tomn) When checking syntax, we always want to
      ** include the code block.
      RUN Put_Special_Preprocessor_Start.
      */
      ASSIGN tmp_string = TRIM(_TRG._tCODE).
      PUT STREAM P_4GL UNFORMATTED "FUNCTION " _TRG._tEVENT " ".
      _TRG._tOFFSET = SEEK(P_4GL).
      /* Generate default code on the fly, otherwise use the user input code */   
      IF (_TRG._tCODE = ?) AND (_TRG._tSPECIAL <> ?) THEN DO:
        RUN adeshar/_coddflt.p (_TRG._tSPECIAL, _TRG._wrecid, OUTPUT tmp_string).
      END.
      /* Before actually writing the function code block, add the PRIVATE keyword
         if necessary. */
      IF _TRG._PRIVATE-BLOCK THEN
          RUN add-func-private (INPUT-OUTPUT tmp_string).
      PUT STREAM P_4GL UNFORMATTED tmp_string.
    END.
  END.
  
  IF pcStatus = "Print-Section" AND _TRG._tEvent = "_DEFINITIONS" THEN DO:
    PUT STREAM P_4GL UNFORMATTED
      "&ANALYZE-SUSPEND _UIB-CODE-BLOCK "
                        _TRG._tSECTION " " _TRG._tEVENT " " win_name " "
                        IF (_TRG._tSPECIAL <> ?) THEN _TRG._tSPECIAL ELSE ""
                        SKIP.
    PUT STREAM P_4GL UNFORMATTED TRIM(_TRG._tCODE).
    PUT STREAM P_4GL UNFORMATTED SKIP (1) "/* _UIB-CODE-BLOCK-END */" SKIP
          "&ANALYZE-RESUME" SKIP (2).
  END.  /* if pcStatus = print-section and definitions section */
  
  /* (Removed 6/16/1999 - tomn) When checking syntax, we always want to
  ** include the code block.
  RUN Put_Special_Preprocessor_End (INPUT 1 /* skip lines */).
  */
  
  /* Outputting extra lines so that import will not overwrite last line
     with previous line when printing temp file in abprint.p */
  IF pcStatus = "Print-Section" THEN 
    PUT STREAM P_4GL UNFORMATTED SKIP(1).
    
  /* Now close the file and try to run it. */
  OUTPUT STREAM P_4GL CLOSE.
  
  /* Now that we have finished writing the file, restore the numeric format */
  SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).

  END. /* NOT WSV2_CkSyntx, ie, Generate Code for non-WSV2 files or when print-section. */
  
  IF pcStatus NE "PRINT-SECTION":U THEN DO:
  /* Check syntax on remote WebSpeed agent. */
    /*
    IF _P._TYPE BEGINS "WEB":U OR
      CAN-FIND(FIRST _TRG WHERE _TRG._pRECID   eq RECID(_P) 
                            AND _TRG._tSECTION eq "_PROCEDURE":U
                            AND _TRG._tEVENT   eq "process-web-request":U) 
    */
    IF _P._BROKER-URL ne "" THEN DO:
      /* Copy the file to a WebSpeed agent as a temp file and check syntax
         remotely. */
      RUN adeweb/_webcom.w (RECID(_P), _p._BROKER-URL, _comp_temp_file, 
                          "checkSyntax":U, OUTPUT rel_name, 
                          INPUT-OUTPUT _comp_temp_file).
      IF RETURN-VALUE BEGINS "ERROR:":U THEN DO:
        ASSIGN
          lError = TRUE
          cMsg   = SUBSTRING(RETURN-VALUE,
                     INDEX(RETURN-VALUE,CHR(10)),-1,"CHARACTER":U).
        RUN adecomm/_s-alert.p (INPUT-OUTPUT lScrap, "error":U, "ok":U, cMsg).
      END.
    END.
  
    /* Check syntax locally. */
    ELSE DO:
      COMPILE VALUE(_comp_temp_file) NO-ERROR.
      /* Make sure _MSG gets populated. */
      RUN add-cmp-msgs.
    END.  
  END.  /* if not printsection */
  
   /*Debugging Code Viewer*/
   /*RUN adeuib/_prvw4gl.p (_comp_temp_file, ?, ?, ?).*/
  

END. /* DO ON STOP */

IF pcStatus NE "PRINT-SECTION":U THEN DO:
  OS-DELETE VALUE(_comp_temp_file).

  /* Notify others that the partial check syntax has ended. */
  RUN adecomm/_adeevnt.p (INPUT  "UIB":U,
                          INPUT  "CHECK-SYNTAX-PARTIAL",
                          INPUT  STRING(_P._u-recid),
                          INPUT  _P._SAVE-AS-FILE,
                          OUTPUT ok2continue).
END.  /* if not PrintSection */

RUN adecomm/_setcurs.p ("").  /* Set cursor in all windows/Dialogs */

IF lError THEN RETURN "ERROR":U.
   
/* ************************************************************************* */
/*                                                                           */
/*     COMMON PROCEDURES FOR DEFINING VIEW-AS SUPPORT, COLOR and FONT        */
/*                                                                           */
/* ************************************************************************* */
{adeuib/_genpro2.i}


