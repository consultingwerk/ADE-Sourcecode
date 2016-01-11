/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _genweb.p

Description:
    Creation of 4GL code -- This routine makes the WS2.x .w file. 
    Based on adeshar/_gen4gl.p.
 
Input Parameters:
   p_proc-id    Current procedure recid.
   p_status     "SAVE"    .
                "PREVIEW" . [same as a save.]
                "RUN"     .   
                "CHECK-SYNTAX"  [Full AppBuilder Check-Syntax]
                "CHECK-SECTION" [Section Editor Check-Syntax]
   p_code-id    For Check-Section files, if this value is not unknown, then 
                we stop outputting sections, triggers, procedures when this 
                item is reached.
   p_outfile    Desired output file. If PREVIEW then the output file will 
                be the _comp_temp_file regardless of this value.
                
Output Parameters:
   p_savepath   Full path of the file saved (or ? if the file not saved.)

Author:  W.T.Wood
Created: 1997  
Updated: 2/13/98 adams Modified to write WS 2.x files for Skywalker
	 4/16/99 tsm   Added support for various Intl Numeric Formats (in 
	               addition to American and European) by using session
	               set-numeric-format method to set format back to 
	               user's setting after setting it to American

	 3/30/01 jep   20010205-003 Adding a function to a v2.1 file and saving writes
	               definitions and other sections twice, corrupting the file.
	               
	               Fixed by using BUFFER put_TRG FOR _TRG in procedure put-internal
	               so the FOR EACH in it doesn't move the _TRG record buffer,
	               thus preventing sections from being read twice in the WRITE_SECTIONS
	               block in this file. (put-interal is called from put-special-section
	               when the object has a function to write out).
	               
	               Procedure put-code-text now takes an _TRG
	               buffer as well.
	               
	04/26/01 jep   IZ 993 Support for Check Syntax of local WebSpeed V2 files.
	
                 "CHECK-SYNTAX"
	               For the purposes of AppBuilder Check Syntax, _genweb.p
	               is called to do everything: generate the appropriate web file,
	               compile it, and display compiler messages.
	               
                 "CHECK-SECTION"
	               For the purposes of Section Editor Check Syntax, _genweb.p
	               is called to only generate the web file with the appropriate
	               code necessary to check the syntax of the specified section.
	               The actual compiling is done by caller adeuib/_qikcomp.p.
	               
	               Added internal procedures check-syntax and add-cmp-msgs, and
	               made additional changes to support the two cases of Check Syntax
	               for local WebSpeed V2 files.
	               
           - - - - - - - - - - - - - - - - - - - - - - - - 
Historical Notes for UIB developers:
- the UIB supports three extra modes:
   "EXPORT"  - not supported in WebSpeed 2.0 due to time contraints
   "DEBUG"   - not supported because there is no remote debugger.
   "PREVIEW" - in WebSpeed, we don't distinguish between the preview and
               the SAVE.
---------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER p_proc-id  AS RECID   NO-UNDO.
DEFINE INPUT  PARAMETER p_status   AS CHAR    NO-UNDO.    
DEFINE INPUT  PARAMETER p_code-id  AS RECID   NO-UNDO.
DEFINE INPUT  PARAMETER p_outfile  AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER p_savepath AS CHAR    NO-UNDO INITIAL ?.

/* Include files. */
{ adeuib/uniwidg.i }     /* Universal Widget TEMP-TABLE definition         */
{ adeweb/htmwidg.i }     /* HTML Field TEMP-TABLE definition               */
{ adeuib/sharvars.i }    /* Shared variables                               */
{ adeweb/genshar.i NEW}  /* Shared variables for _gendefs.p                */
{ adeuib/triggers.i }

/* Preprocessor directives. */
&GLOBAL-DEFINE AMPER-IF     "&IF"
&GLOBAL-DEFINE AMPER-THEN   "&THEN"
&GLOBAL-DEFINE AMPER-ENDIF  "&ENDIF"
&SCOPED-DEFINE debug        FALSE

DEFINE VARIABLE cd-recid       AS RECID              NO-UNDO.
DEFINE VARIABLE context        AS CHARACTER          NO-UNDO. 
DEFINE VARIABLE cOptions       AS CHARACTER          NO-UNDO. 
DEFINE VARIABLE cRelName       AS CHARACTER          NO-UNDO. 
DEFINE VARIABLE cTempFile      AS CHARACTER          NO-UNDO. 
DEFINE VARIABLE done-fun       AS LOGICAL            NO-UNDO.
DEFINE VARIABLE err-offset     AS INTEGER            NO-UNDO.
DEFINE VARIABLE l_first-custom AS LOGICAL            NO-UNDO.
DEFINE VARIABLE l_scrap        AS LOGICAL            NO-UNDO.
DEFINE VARIABLE ok2continue    AS LOGICAL            NO-UNDO.
DEFINE VARIABLE write-access   AS CHARACTER          NO-UNDO.

DEFINE BUFFER chk_TRG FOR _TRG.  /* Buffer for Checking one section */

/* ************************************************************************* */
&if {&debug} &then
message "[_genweb.p] #1" skip
  "p_proc-id"  p_proc-id  skip
  "p_status"   p_status   skip
  "p_code-id"  p_code-id  skip
  "p_outfile"  p_outfile  skip
  "p_savepath" p_savepath skip
  "web-tmp-file" web-tmp-file skip
  view-as alert-box.
&endif

/* Initialize u_status - used to check status of an _U record                */
ASSIGN u_status = IF p_status EQ "EXPORT":U THEN "EXPORT":U ELSE "NORMAL":U.

/* Get the procedure we are saving.                                          */
FIND _P WHERE RECID(_P) eq p_proc-id.

/* Note that all source code must use AMERICAN numerals to be compilable.    */
ASSIGN SESSION:NUMERIC-FORMAT = "AMERICAN":U.

/* Notify others of BEFORE and AFTER events (except for PREVIEW).  Provide
   opportunity for developer to cancel. */
/* We don't do this for Check-Section either-- it's done by
   caller adeuib/_qikcomp.p. IZ 993. */
IF p_status ne "PREVIEW":U AND p_status <> "CHECK-SECTION":U THEN DO:
  /* Give others a chance to abort the save */
  context = STRING(RECID(_P)).
  RUN adecomm/_adeevnt.p ("{&TOOL-SHORT-NAME}":U, "BEFORE-":U + p_status, 
                          context, p_outfile, OUTPUT ok2continue).
  IF NOT ok2continue THEN 
    RETURN "Error-Override":U.
END.

/* Make sure the p_code-id is only given for CHECK-SECTION. Otherwise
   find the code section we are checking. */  
IF p_status ne "CHECK-SECTION":U THEN  
  p_code-id = ?. 
ELSE 
  FIND chk_TRG WHERE RECID(chk_TRG) eq p_code-id.

/* Open output file. */
IF p_status ne "SAVE":U THEN DO: 
  /* Create a temporary file when previewing or checking syntax */
  IF _comp_temp_file = ? THEN
    RUN adecomm/_tmpfile.p ("ws":U, ".tmp":U, OUTPUT _comp_temp_file).
  p_outfile = _comp_temp_file.
END. 
ELSE IF web-tmp-file = "" THEN
  DO ON STOP  UNDO, RETRY
     ON ERROR UNDO, RETRY: /* if an error occurs writing this file, abort */
    IF RETRY THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT l_scrap,"error":u,"ok":u,
        SUBSTITUTE("An error has occurred while writing to &1. " + 
                   "This file cannot be saved until the problem is resolved.",
                   p_outfile)).
     RETURN "Error-Write":U.
    END.
    ASSIGN write-access = "W":U. 
    
    RUN adecomm/_osfrw.p
      (INPUT p_outfile, INPUT "_WRITE-TEST":U , OUTPUT write-access).

    IF write-access ne "W":U THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT l_scrap,"error":u,"ok":u,
        SUBSTITUTE("Cannot save to &1. File is read-only, or the path " +
                   "specified is invalid. Use a different filename.", 
                   p_outfile)).
      RETURN "Error-Write":U.
    END.
  END.
  
/* Output to the stream. */
OUTPUT STREAM P_4GL TO VALUE(IF web-tmp-file ne "" THEN web-tmp-file ELSE p_outfile).

/* ************************************************************************* */
/*                                                                           */
/*                     OUTPUT SPECIAL TOP-OF-FILE LINES                      */
/*                                                                           */
/* ************************************************************************* */
/* Place some predefined 4GL preprocessors at the top of the file to aid
   in debugging 4GL code. */
/*
IF CAN-DO ("RUN,DEBUG":U,p_status) THEN
  PUT STREAM P_4GL UNFORMATTED
    "&Scoped-define Running_from_{&TOOL-SHORT-NAME} " _comp_temp_file SKIP
    "&Scoped-define NEW NEW" SKIP.
*/

/* ************************************************************************* */
/*                                                                           */
/*      OUTPUT ALL SECTIONS (EXCEPT PROCEDURES, FUNCTION and CONTROLS)       */
/*                                                                           */
/* ************************************************************************* */

/* First, see if there are any functions to output in the custom FUNCTION section. */
/* We do this only if this is a WebSpeed file. */
done-fun = NOT CAN-FIND (FIRST _TRG WHERE _TRG._pRECID   eq p_proc-id 
                                      AND _TRG._tSECTION eq "_FUNCTION":U).

/* Get the first section. */             
FIND FIRST _TRG WHERE _TRG._pRECID = p_proc-id NO-ERROR.
WRITE_SECTIONS:
DO WHILE AVAILABLE _TRG:
  /* Output each section. This is a AppBuilder maintained file. Structure the 
     code blocks.  Make sure functions are in front of the SECOND custom block. 
    (The first one will be the top of the file, with header comments). */
  IF _TRG._tSECTION eq "_CUSTOM":U AND l_first-custom eq no THEN 
    l_first-custom = yes.
     
  IF LOOKUP(_TRG._tSECTION, "_CONTROL,_FUNCTION,_PROCEDURE":U) eq 0 THEN DO: 
    IF _TRG._tSPECIAL eq "":U OR _TRG._tSPECIAL eq ? THEN
      RUN put-structured-section.
    ELSE 
      RUN put-special-section.
  END. /* IF...[not] _CONTROL,_PROCEDURE... */

  /* Get the next section. */
  FIND NEXT _TRG WHERE _TRG._pRECID = p_proc-id NO-ERROR.
END. /* WRITE_SECTIONS */

/* If functions have not been output, then do it now. 
   We need to do this even if we are checking only one section (because 
   the section might be using on of the functions. */
IF NOT done-fun THEN 
  RUN put-internal ("_FUNCTION":U).

/* Don't bother putting out all the procedures, etc. if we are checking
   only one section. */
IF p_status eq "CHECK-SECTION":U THEN DO:
  /* Put the one procedure, or control section.  Functions are already done. */
  IF LOOKUP(chk_TRG._tSECTION, "_CONTROL,_PROCEDURE":U) > 0 THEN DO: 
    /* Custom write out the section. Don't worry about ANALYSE-SUSPEND etc,
       but do remember the offset information in the file. */
    FIND _TRG WHERE RECID(_TRG) eq RECID(chk_TRG).
    _TRG._tOFFSET = SEEK(P_4GL).  
    /* Controls need the code entered in a PROCEDURE. Give this a dummy name
       that is unlikely to exist (eg. web.input.2325). Procedures just use the name.  */
    IF _TRG._tSECTION eq "_CONTROL":U THEN
      PUT STREAM P_4GL UNFORMATTED SKIP 
        "PROCEDURE ":U _TRG._tEVENT ".":U RECID(_TRG) " :":U  SKIP.
    ELSE       /* IZ 993 */
      PUT STREAM P_4GL UNFORMATTED SKIP 
        "PROCEDURE ":U _TRG._tEVENT " :":U  SKIP.
    RUN put-code-text (BUFFER _TRG).
    /* Remember the end of the section. */
    _TRG._tOFFSET-END = SEEK(P_4GL).      
  END. /* IF...control, function, or procedure...*/
END. /* IF check-section... */
ELSE DO:

  /* Output the rest of the file structured for webspeed. */
  /* If functions have not been output, then do it now.   */
  IF NOT done-fun THEN 
    RUN put-internal ("_FUNCTION":U).

  /* *********************************************************************** */
  /*                                                                         */
  /*                           OUTPUT PROCEDURES                             */
  /*                                                                         */
  /* *********************************************************************** */
  /* Are there any procedures to output? */
  FIND FIRST _TRG WHERE _TRG._pRECID   eq RECID(_P) 
                    AND _TRG._tSECTION eq "_PROCEDURE":U NO-ERROR.
  IF AVAILABLE _TRG THEN 
    RUN put-internal ("_PROCEDURE":U).
  
  /* *********************************************************************** */
  /*                                                                         */
  /*                       OUTPUT TRIGGERS AND EVENTS                        */
  /*                                                                         */
  /* *********************************************************************** */
  /* Are there any procedures to output? */
  FIND FIRST _TRG WHERE _TRG._pRECID   eq RECID(_P) 
                    AND _TRG._tSECTION eq "_CONTROL":U NO-ERROR.
  IF AVAILABLE _TRG THEN 
    RUN put-triggers.
  
  /* *********************************************************************** */
  /*                                                                         */
  /*                               QUERIES                                   */
  /*                                                                         */
  /* *********************************************************************** */
  /* Put queries out at the end because the information is all in comments.  */
  RUN put-query-info. 
  
END. /* IF [not] CHECK-SECTION... */
  
OUTPUT STREAM P_4GL CLOSE.

/* Now that we have finished writing the file, restore the numeric format */
SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
 
/* Return the fullpath of the saved file only if we're saving locally and not
   to a WebSpeed agent. */
ASSIGN 
  FILE-INFO:FILE-NAME = p_outfile
  p_savepath          = (IF web-tmp-file eq "" THEN FILE-INFO:FULL-PATHNAME 
                         ELSE p_outfile).

/* Compile the file we just created. This is not done for Section Editor
   CHECK-SECTION because adeuib/_qikcomp.p does the compile and message
   processing. IZ 993 */
CASE p_status: 
  WHEN "CHECK-SYNTAX":U THEN DO:
    RUN check-syntax.
  END.

  WHEN "CHECK-SECTION":U THEN DO:
    /* NOTHING. Let caller compile and display messages. IZ 993. */
  END.

END CASE.

/* Let others know that the save or check-syntax was a success.
   (Again, except for Preview and Check-Section.) IZ 993 */
IF p_status ne "PREVIEW":U AND p_status <> "CHECK-SECTION":U THEN
  RUN adecomm/_adeevnt.p ("{&TOOL-SHORT-NAME}":U, p_status, context, p_outfile, 
                          OUTPUT ok2continue).

/* Make sure we return something because the calling program looks for the 
   RETURN-VALUE, and if we don't set it, then the value won't be reset. */
RETURN "".   

/* ************************************************************************* */
/*                                                                           */
/*                            INTERNAL PROCEDURES                            */
/*                                                                           */
/* ************************************************************************* */

/* get-comp-file: starting with a source file and a compile-into directory,
 * Try to get the full pathname of the file that they were compiled into.
 * If the r-code does not exist, return ?. */
PROCEDURE get-comp-file :
  DEFINE INPUT  PARAMETER p_source AS CHAR NO-UNDO.
  DEFINE INPUT  PARAMETER p_dir    AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER p_rcode  AS CHAR NO-UNDO.
  
  DEFINE VAR cnt       AS INTEGER NO-UNDO.
  DEFINE VAR file-base AS CHAR NO-UNDO.
  DEFINE VAR file-prfx AS CHAR NO-UNDO.

  /* Break the file name into its component parts. For example:
     c:\bin.win\gui\test.w => file-prfx "c:\bin.win\gui\", file-base "test.r" */
  RUN adecomm/_osprefx.p (p_source, OUTPUT file-prfx, OUTPUT file-base).

  /* Replace the file extention with "r". */
  cnt = NUM-ENTRIES(file-base, ".").
  CASE cnt:
    WHEN 0 THEN file-base = ?.
    WHEN 1 THEN file-base = file-base + ".r":U.
    OTHERWISE   ENTRY(cnt, file-base, ".") = "r":U.
  END CASE.
  
  /* Is the p_dir (compile) directory a real directory?  If so, parse it,
     Otherwise, use the current directory. */
  IF p_dir ne ? AND  p_dir ne ".":U THEN
    /* Is the compile directory a full path, or is it relative to the file 
       prefix?  Check for names that have ":", indicating a DRIVE or names
       that start with / or \.  */
    file-prfx = IF (CAN-DO("OS2,MSDOS,WIN32,UNIX,VMS":u,OPSYS) AND 
                    INDEX(p_dir,":":u) > 0) OR
                    CAN-DO("~\/":U, SUBSTRING(p_dir,1,1,"CHARACTER":U)) THEN
                  p_dir + "/":U ELSE file-prfx + p_dir + "/":U.
  
  /* Return the full pathname of the compiled file, if it exists. */
  ASSIGN FILE-INFO:FILE-NAME = file-prfx + file-base
         p_rcode             = FILE-INFO:FULL-PATHNAME
         .
END PROCEDURE.   

 /* *************************************************************************  
 * PUT-INCLUDED-LIBS
 *   Output the Included-Libraries section.
 * ************************************************************************* */
PROCEDURE put-included-libs :

  PUT STREAM P_4GL UNFORMATTED
    "&ANALYZE-SUSPEND _INCLUDED-LIBRARIES" SKIP. 
      
  /* Put the section. 
     (wood) In BETA 1 we just dump the section. In beta 2 we will 
     process the include file list. */
  RUN put-code-text (BUFFER _TRG).
  
  PUT STREAM P_4GL UNFORMATTED
    "&ANALYZE-RESUME _END-INCLUDED-LIBRARIES" SKIP(1).   
      
END PROCEDURE.  

/* *************************************************************************  
 * PUT-INTERNAL -
 *  Put the internal functions and procedures.
 *  Parameter: p_type (_FUNCTION, or _PROCEDURE)
 * ************************************************************************* */
PROCEDURE put-internal :
  DEFINE INPUT PARAMETER p_type AS CHAR      NO-UNDO.

  DEFINE BUFFER   put_TRG       FOR _TRG.
  DEFINE VARIABLE tmp_string    AS CHAR      NO-UNDO.

  CASE p_type:
    WHEN "_FUNCTION":U  THEN DO:
      PUT STREAM P_4GL UNFORMATTED SKIP
      "/* ***************************  Functions  **************************** */".   
      /* Note that Functions are done. */
      done-fun = yes.
    END.
    WHEN "_PROCEDURE":U THEN 
      PUT STREAM P_4GL UNFORMATTED SKIP
      "/* **********************  Internal Procedures  *********************** */".
  END CASE.

  PUT STREAM P_4GL UNFORMATTED SKIP (1).

  /*  Output all procedures. */
  FOR EACH put_TRG WHERE put_TRG._pRECID   eq RECID(_P) 
                     AND put_TRG._tSECTION eq p_type
                      BY put_TRG._tEVENT:

    /* Start Method Library Procedure EXCLUDE Preprocessor block. */
    IF _P._TYPE = "Method-Library":U THEN
      PUT STREAM P_4GL UNFORMATTED
        {&AMPER-IF} ' DEFINED(EXCLUDE-':U put_TRG._tEVENT ') = 0 ':U {&AMPER-THEN}
        SKIP(1).
      
    &if {&debug} &then
    message "[_genweb.p] #4 put-internal" skip
      "_tsection" put_trg._tsection skip
      "_tevent" put_trg._tevent skip
      "_tspecial" "|" + put_trg._tspecial + "|" skip
      view-as alert-box.
    &endif
      
    /* Heading = _PROCEDURE name [SPECIAL] */
    PUT STREAM P_4GL UNFORMATTED
      "&ANALYZE-SUSPEND _CODE-BLOCK ":U 
      put_TRG._tSECTION SPACE put_TRG._tEVENT SPACE
      IF (put_TRG._tSPECIAL ne ?) THEN put_TRG._tSPECIAL ELSE "" SKIP.

    CASE p_type:
      WHEN "_FUNCTION":U THEN
        PUT STREAM P_4GL UNFORMATTED
          "FUNCTION ":U put_TRG._tEVENT " ":U.
      WHEN "_PROCEDURE":U THEN
        PUT STREAM P_4GL UNFORMATTED
          "PROCEDURE ":U put_TRG._tEVENT " :":U SKIP.
    END CASE.
    
    /* Generate default code on the fly, otherwise use the user input code */   
    IF put_TRG._tSPECIAL ne "":U AND put_TRG._tSPECIAL ne ? THEN DO:
      &if {&debug} &then
      message "[_genweb.p] #5 pre _coddflt.p #1" skip
        "_tspecial" put_trg._tspecial skip
        "_wrecid" put_trg._wrecid skip
        view-as alert-box.
      &endif
      
      RUN adeshar/_coddflt.p (put_TRG._tSPECIAL, put_TRG._wRECID, OUTPUT tmp_string).
      put_TRG._tOFFSET = SEEK(P_4GL). 
      PUT STREAM P_4GL UNFORMATTED 
        tmp_string. 
      put_TRG._tOFFSET-END = SEEK(P_4GL).      
    END.
    ELSE
      RUN put-code-text (BUFFER put_TRG).
    
    PUT STREAM P_4GL UNFORMATTED 
      SKIP "&ANALYZE-RESUME" SKIP.

    IF _P._TYPE ne "Method-Library":U THEN
      PUT STREAM P_4GL UNFORMATTED SKIP.
    ELSE DO:
      /* End Method Libaray Procedure EXCLUDE Preprocessor block. */
      PUT STREAM P_4GL UNFORMATTED SKIP (1).
      PUT STREAM P_4GL UNFORMATTED {&AMPER-ENDIF} SKIP(1).
    END.  
  END. /* FOR EACH put_TRG... */

END PROCEDURE.


/* *************************************************************************  
 * PUT-PROCEDURE-SETTINGS 
 * ************************************************************************* */
PROCEDURE put-procedure-settings :

  /* Make sure the settings are consistent with the type-list. */
  IF _P._file-type = "i":U THEN
    ASSIGN _P._compile      = no
           _P._compile-into = ?.
  
  PUT STREAM P_4GL UNFORMATTED SKIP
    "/* *********************** Procedure Settings ************************ */":U
    SKIP (1).

  PUT STREAM P_4GL UNFORMATTED
    "&ANALYZE-SUSPEND _PROCEDURE-SETTINGS":U SKIP.

  PUT STREAM P_4GL UNFORMATTED
    "/* Settings for THIS-PROCEDURE":U SKIP.

  IF _P._compile-into ne ? THEN
    PUT STREAM P_4GL UNFORMATTED
      "   Compile into: ":U _P._compile-into SKIP.   

  IF _P._file-type = "i":U OR  _P._compile THEN
    PUT STREAM P_4GL UNFORMATTED
      "   Other Settings:" 
      (IF _P._file-type = "i":U THEN " INCLUDE-ONLY" ELSE "") 
      (IF _P._compile           THEN " COMPILE" ELSE "") SKIP.
  
  PUT STREAM P_4GL UNFORMATTED
    " */":U SKIP.

  PUT STREAM P_4GL UNFORMATTED
    "&ANALYZE-RESUME _END-PROCEDURE-SETTINGS":U SKIP (1).
END PROCEDURE. 

/* *************************************************************************  
 * put-query-info: Put the information needed to rebuild all the queries.  
 * ************************************************************************* */
PROCEDURE put-query-info :
  DEFINE VARIABLE ix            AS INTEGER       NO-UNDO.
  DEFINE VARIABLE i_count       AS INTEGER       NO-UNDO.
  DEFINE VARIABLE tmp_string    AS CHAR          NO-UNDO.
  DEFINE VARIABLE tmp_string2   AS CHAR          NO-UNDO.
  DEFINE VARIABLE TuneOpts      AS CHAR          NO-UNDO.
  
  /* Define the Queries and Browse Widgets for this window.  Put out the header
     for the section only for the first non-blank query.    */
  i_count = 0.
  FOR EACH _U WHERE _U._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                AND _U._TYPE          eq "QUERY":U
                AND _U._STATUS        eq u_status,
      EACH _C WHERE RECID(_C)         eq _U._x-recid,
      EACH _Q WHERE RECID(_Q)         eq _C._q-recid
      BY _U._NAME BY _U._TYPE:
      
    /* The NOT OpenQury is to preserve that status even if not tables in the
       the query.  */
    i_count = i_count + 1.
    IF i_count eq 1 THEN
      PUT STREAM P_4GL UNFORMATTED SKIP (1)
        "/* Setting information for Queries                                      */"
        SKIP (1).
    PUT STREAM P_4GL UNFORMATTED
        "&ANALYZE-SUSPEND _QUERY-BLOCK ":U _U._TYPE " ":U _U._NAME SKIP.

    PUT STREAM P_4GL UNFORMATTED          
        "/* Query rebuild information for "  _U._TYPE " ":U _U._NAME SKIP.

    /* Handle freeform query situation */
    FIND _TRG WHERE _TRG._wRECID eq RECID(_U) AND
                    _TRG._tEVENT eq "OPEN_QUERY":U NO-ERROR.
    IF AVAILABLE _TRG THEN DO:  /* A Freeform query */
      PUT STREAM P_4GL UNFORMATTED          
        "     _START_FREEFORM":U SKIP. 
      RUN put-code-text (BUFFER _TRG).
      PUT STREAM P_4GL UNFORMATTED "     _END_FREEFORM":U SKIP.     
    END.  /* Freeform query */
    ELSE DO:  /* Not a freeform query */
      ASSIGN TuneOpts = REPLACE(REPLACE(TRIM(_Q._TuneOptions),CHR(13),""),
                                CHR(10),CHR(10) + FILL(" ":U,26)).
             
      IF _Q._TblList ne "" THEN
         PUT STREAM P_4GL UNFORMATTED 
           "     _TblList          = """:U _Q._TblList """":U SKIP.
    
      IF _Q._OptionList ne "":U THEN
        PUT STREAM P_4GL UNFORMATTED 
          "     _Options          = """:U _Q._OptionList """":U SKIP.
      IF TuneOpts ne "" THEN 
        PUT STREAM P_4GL UNFORMATTED 
          "     _TuneOptions      = """:U TuneOpts """":U SKIP.
      IF _Q._TblOptList ne "" THEN 
        PUT STREAM P_4GL UNFORMATTED 
          "     _TblOptList       = """:U TRIM(_Q._TblOptList) """":U SKIP.   
      IF _Q._OrdList ne "" THEN 
        PUT STREAM P_4GL UNFORMATTED 
          "     _OrdList          = """:U _Q._OrdList """":U SKIP.

      Extent-Stuff:
      REPEAT ix = 1 TO NUM-ENTRIES(_Q._TblList):
        IF _Q._JoinCode[ix] = ? AND _Q._Where[ix] = ? THEN 
          NEXT Extent-Stuff.
        ASSIGN tmp_string  = REPLACE(_Q._Where[ix],CHR(34),CHR(34) + CHR(34))
               tmp_string2 = REPLACE(_Q._JoinCode[ix],CHR(34),CHR(34) + CHR(34)).
               
        IF _Q._JoinCode[ix] ne ? AND _Q._JoinCode[ix] ne "" THEN
          PUT STREAM P_4GL UNFORMATTED
            "     _JoinCode[":U ix "]      = ":U
            IF tmp_string2 = ? THEN tmp_string2
            ELSE ("~"":U + tmp_string2 + "~"":U) SKIP.
        IF _Q._Where[ix] ne ? and _Q._Where[ix] ne "" THEN
          PUT STREAM P_4GL UNFORMATTED 
            "     _Where[":U ix "]         = ":U
            IF tmp_string = ?  THEN tmp_string
            ELSE ("~"":U + tmp_string + "~"":U) SKIP.
      END. /* Extent-Stuff: REPEAT... */
    END. /* IF [not freeform] AVAILALBE _TRG...  */
    
    /* This line signals the end of the Query rebuild information. */
    PUT STREAM P_4GL UNFORMATTED 
      '*/  /* ':U _U._TYPE " ":U _U._NAME ' */':U SKIP 
      '&ANALYZE-RESUME':U SKIP(1).

  END.  /* FOR EACH...QUERY. */

  PUT STREAM P_4GL UNFORMATTED " ":U SKIP (1).
END PROCEDURE. 

/* *************************************************************************  
 * put-special-section: Look at the SPECIAL handler for a procedure and
 * output the section.  
 * ************************************************************************* */
PROCEDURE put-special-section :
  CASE _TRG._tSPECIAL:

    WHEN "_CREATE-WINDOW":U THEN DO:
       /* v2 files do not need this section anymore, so don't output it.
          That is, do nothing.  */
    END.  
     
    WHEN "_FORM-BUFFER":U THEN DO:
      RUN adeweb/_gendefs.p (p_proc-id, p_status, no).
      RUN adeweb/_genrt.p (p_proc-id, p_status).   
    END.  
    
    WHEN "_INCLUDED-LIBRARIES":U THEN DO:
      RUN put-included-libs.    
      /* This is a good place to put out the FUNCTIONS. */
      IF NOT done-fun THEN 
        RUN put-internal ("_FUNCTION":U).
    END.

    WHEN "_PREPROCESSOR-BLOCK":U THEN RUN adeweb/_preproc.p (p_proc-id, p_status).      
    WHEN "_PROCEDURE-SETTINGS":U THEN RUN put-procedure-settings.            
    WHEN "_VERSION-NUMBER":U     THEN RUN put-version-number.     
      
    OTHERWISE DO:   
      /* Save the section as is --- this way we won't loose anything that
         we are not prepared to handle. */
      /*RUN put-code-section.*/
      RUN put-structured-section.
    END.            
    
  END CASE.
END PROCEDURE. 

/* *************************************************************************  
 * PUT-TRIGGERS: Write out the code for the trigger (Event Procedures).
 * ************************************************************************* */
PROCEDURE put-triggers :

  DEFINE VARIABLE ix            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE self-name     AS CHAR      NO-UNDO.
  DEFINE VARIABLE event-tag     AS CHAR      NO-UNDO.
  DEFINE VARIABLE tmp_string    AS CHAR      NO-UNDO.

  PUT STREAM P_4GL UNFORMATTED SKIP
    "/* ********************  Control Event Procedures  ********************* */":U
    SKIP (1).

  /*  Output all event procedures, by widget.  Make sure that SELF-NAME is defined. 
      NOTE that the QUERY pseudo-trigger (for OPEN_QUERY) is handled in the put-query
      section. */  
  FOR EACH _U WHERE _U._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                AND NOT CAN-DO("QUERY,WINDOW":U,_U._TYPE)
                AND CAN-FIND(FIRST _TRG WHERE _TRG._wRECID eq RECID(_U))
                USE-INDEX _NAME:
  
    /* Output the SELF-NAME */
    self-name = { adeweb/name_u.i &U_BUFFER = "_U" }.
    PUT STREAM P_4GL UNFORMATTED SKIP "&SCOPED-DEFINE SELF-NAME ":U self-name SKIP.
       
    FOR EACH _TRG WHERE _TRG._wRECID   eq RECID(_U)
                    AND _TRG._tSECTION eq "_CONTROL":U 
                     BY _TRG._tEVENT:

      /* Heading => _CONTROL self-name event 
         Replace the "web." part of the event procedure with self-name. */  
      event-tag = _TRG._tEVENT.
      IF event-tag BEGINS "web.":U THEN
        event-tag = SUBSTRING(event-tag, 5, -1, "CHARACTER":U).
        
      &if {&debug} &then
      message "[_genweb.p] #6 put-triggers" skip
        "_tsection" _trg._tsection skip
        "_tevent" _trg._tevent skip
        "_tspecial" "|" + _trg._tspecial + "|" skip
        view-as alert-box.
      &endif
      
      PUT STREAM P_4GL UNFORMATTED
        "&ANALYZE-SUSPEND _CODE-BLOCK _CONTROL ":U self-name SPACE
        _TRG._tEVENT SPACE
        IF (_TRG._tSPECIAL ne ?) THEN _TRG._tSPECIAL ELSE "" SKIP
        "PROCEDURE ":U self-name ".":U event-tag " :":U SKIP.

      /* Generate default code on the fly, otherwise use the user input code */   
      IF _TRG._tSPECIAL ne "":U AND _TRG._tSPECIAL ne ? THEN DO:
        &if {&debug} &then
        message "[_genweb.p] #7 _coddflt.p #2" skip
          "_tspecial" _trg._tspecial skip
          "_wrecid" _trg._wrecid skip
          view-as alert-box.
        &endif
      
        RUN adeshar/_coddflt.p (_TRG._tSPECIAL, _TRG._wRECID, OUTPUT tmp_string).
        _TRG._tOFFSET = SEEK(P_4GL). 
        PUT STREAM P_4GL UNFORMATTED tmp_string. 
        _TRG._tOFFSET-END = SEEK(P_4GL).      
      END.
      ELSE RUN put-code-text (BUFFER _TRG).
    
      PUT STREAM P_4GL UNFORMATTED SKIP "&ANALYZE-RESUME":U SKIP (1).
    END. /* FOR EACH _TRG .. */
  END. /* FOR EACH _U... */
END PROCEDURE.

/* **************************************************************************  
 * put-version-number 
 *   Output _VERSION-NUMBER tag line, and description.  Maintain the original
 *   version number, but update the revision
 * ************************************************************************** */
PROCEDURE put-version-number :
  DEFINE VARIABLE new-version AS CHARACTER NO-UNDO.
  
  new-version = ENTRY(1,_P._file-version,"r":U) + "r":U +
                ENTRY(2,_UIB_VERSION,"r":U).
  PUT STREAM P_4GL UNFORMATTED
    "&ANALYZE-SUSPEND _VERSION-NUMBER ":U new-version " ":U _P._TYPE
    (IF _P._template THEN " Template":U ELSE "") SKIP.               
    
  /* Place name of html mapping file. */
  IF _P._TYPE BEGINS "WEB":U THEN DO:
    PUT STREAM P_4GL UNFORMATTED
      "/* Maps: " (IF _P._html-file eq "":U THEN "HTML":U ELSE _P._html-file)
      " */":U SKIP.
  END.
  /* Place description. */
  IF _P._desc ne "" THEN DO:
    /* Outputs the Procedure Description into the .W */
    PUT STREAM P_4GL UNFORMATTED
      "/* Procedure Description":U SKIP.
    EXPORT STREAM P_4GL _P._DESC.
    PUT STREAM P_4GL UNFORMATTED SKIP "*/":U SKIP.  
  END.
  PUT STREAM P_4GL UNFORMATTED "&ANALYZE-RESUME":U SKIP.
END.

/* **************************************************************************  
 * check-syntax 
 *   Checks syntax of an entire web-object file and reports compiler messages.
 *   Part of fix for IZ 993 Support for Check Syntax of local WebSpeed V2 files.
 * ************************************************************************** */
PROCEDURE check-syntax :
  DEFINE VARIABLE compiler_error AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE compiler_file  AS CHARACTER NO-UNDO.

  CHECK-SYNTAX-BLK:
  DO ON STOP UNDO CHECK-SYNTAX-BLK, LEAVE CHECK-SYNTAX-BLK
     ON ERROR UNDO CHECK-SYNTAX-BLK, LEAVE CHECK-SYNTAX-BLK:
  
    COMPILE VALUE(_comp_temp_file) NO-ERROR.
    ASSIGN compiler_file  = COMPILER:FILE-NAME
           compiler_error = COMPILER:ERROR.
    RUN add-cmp-msgs.
    RUN adecomm/_setcurs.p ("").
    /* Display any error or preprocessor messages. */
    RUN adecomm/_errmsgs.p ( INPUT _h_menu_win , INPUT compiler_file ,
                             INPUT _comp_temp_file ).
  
    IF compiler_error THEN DO:
        err-offset = COMPILER:FILE-OFFSET.
        /* An error occurred. Figure out where it occured.  If we can't
           find the section, it may be due to a poorly specifed err-offset
           (see bug #19970325-058, for example). In that case, just return 
           the current section. */
        FIND FIRST _TRG WHERE _TRG._pRECID  eq p_proc-id
                          AND _TRG._tOFFSET lt err-offset
                          AND err-offset    lt _TRG._tOFFSET-END NO-ERROR.
        _err_recid = (IF AVAILABLE _TRG THEN RECID(_TRG) ELSE p_code-id).
    END. /* Handling compiler errors */
    ELSE IF NOT compiler_error THEN DO:
      MESSAGE "Syntax is correct" 
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK TITLE "Information"
                          IN WINDOW _h_menu_win.
    END. /* not compiler_error */
  
  END. /* RUN-BLK */
  /* Debugging - copy the file locally  OS-COPY VALUE(_comp_temp_file) checksyn.w. */
  OS-DELETE VALUE(_comp_temp_file).

  /* Now that syntax has been checked discard all trigger offsets so that they */
  /* won't get confused with offsets from other windows being generated.       */
  FOR EACH _TRG WHERE _TRG._tOFFSET NE ?:
    ASSIGN _TRG._tOFFSET     = ?   
           _TRG._tOFFSET-END = ?.
  END.

END PROCEDURE. /* check-syntax */


/* Populate _MSG statment with ERROR-STATUS messages.
   If you execute COMPILE..NO-ERROR, _MSG population is suppressed.
   Call this routine if you want it populate. */
PROCEDURE add-cmp-msgs:

    DEFINE VARIABLE error_num AS INTEGER NO-UNDO.
    
    DO error_num = 1 TO ERROR-STATUS:NUM-MESSAGES:
      ASSIGN _MSG = ERROR-STATUS:GET-NUMBER( error_num ).
    END.

END PROCEDURE.


/* Other standard procedures. */
{ adeweb/genproc.i }

/* _genweb.p - end of file */

