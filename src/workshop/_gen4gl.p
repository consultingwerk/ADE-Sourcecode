/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _gen4gl.p

Description:
    Creation of 4GL code -- This routine makes the .w file.
 
Input Parameters:
   p_proc-id    Current procedure id.
   p_status     "SAVE"    .
                "PREVIEW" . [same as a save.]
                "RUN"     .   
                "CHECK-SYNTAX"
                "CHECK-SECTION"  
   p_code-id    For Check-Section files, if this value is not
                not unknown, then we stop outputting
                sections, triggers, procedures when this item is reached.
   p_outfile    Desired output file. If PREVIEW then
                the output file will be the _comp_temp_file regardless
                of this value.
                
Output Parameters:
   p_savepath   Full path of the file saved (or ? if the file not saved.)

Author: William T. Wood     [Based on adeshar/_gen4gl.p]

Date Created: 1997  

Last Modified: 

           - - - - - - - - - - - - - - - - - - - - - - - - 
Historical Notes for UIB developers:
- the UIB supports three extra modes:
   "EXPORT"  - not supported in WebSpeed 2.0 due to time contraints
   "DEBUG"   - not supported because there is no remote debugger.
   "PREVIEW" - in WebSpeed, we don't distinguish between the preview and
               the SAVE.
---------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER p_proc-id  AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER p_status   AS CHAR    NO-UNDO.    
DEFINE INPUT  PARAMETER p_code-id  AS RECID   NO-UNDO.
DEFINE INPUT  PARAMETER p_outfile  AS CHAR    NO-UNDO.

DEFINE OUTPUT PARAMETER p_savepath AS CHAR NO-UNDO INITIAL ?.


/* Include files. */
{ workshop/objects.i }     /* Universal Widget TEMP-TABLE definition         */
{ workshop/uniwidg.i }     /* Universal Widget TEMP-TABLE definition         */
{ workshop/htmwidg.i }     /* HTML Field TEMP-TABLE definition               */
{ workshop/code.i }        /* Code Section TEMP-TABLE definition             */
{ workshop/sharvars.i }    /* Shared variables                               */
{ workshop/pre_proc.i }    /* Preprocessor Variables                         */  
{ workshop/errors.i }      /* Error handler and functions.                   */

{ workshop/genshar.i NEW}  /* Shared variables for _gendefs.p                */

/* Preprocessor directives. */
&GLOBAL-DEFINE AMPER-IF     "&IF"
&GLOBAL-DEFINE AMPER-THEN   "&THEN"
&GLOBAL-DEFINE AMPER-ENDIF  "&ENDIF"

DEFINE VARIABLE cd-recid       AS RECID              NO-UNDO.
DEFINE VARIABLE context        AS CHAR               NO-UNDO. 
DEFINE VARIABLE err-offset     AS INTEGER            NO-UNDO.
DEFINE VARIABLE l_first-custom AS LOGICAL            NO-UNDO.
DEFINE VARIABLE l_webspeed     AS LOGICAL            NO-UNDO.
DEFINE VARIABLE done-fun       AS LOGICAL            NO-UNDO.
DEFINE VARIABLE next-id        LIKE _code._next-id   NO-UNDO.
DEFINE VARIABLE ok2continue    AS LOGICAL            NO-UNDO.
DEFINE VARIABLE write-access   AS CHARACTER          NO-UNDO.

/* Buffer for Checking one section */
DEFINE BUFFER chk_code FOR _code.

/* ************************************************************************* */

/* Initialize u_status - used to check status of an _U record                */
ASSIGN u_status = IF p_status EQ "EXPORT" THEN "EXPORT" ELSE "NORMAL".

/* Get the procedure we are saving. See if it is a webspeed file.            */
FIND _P WHERE RECID(_P) eq p_proc-id.
IF LOOKUP ("Structured":U, _P._type-list) > 0 AND
   LOOKUP ("UIB":U, _P._type-list) eq 0
THEN l_webspeed = yes.

/* Note that all source code must use AMERICAN numerals to be compilable.    */
ASSIGN SESSION:NUMERIC-FORMAT = "AMERICAN":U.

/* Notify others of BEFORE and AFTER events (except for preview).  Provide
   opportunity for developer to cancel. */
IF p_status ne "PREVIEW":U THEN DO:
  /* Give others a chance to abort the save */
  context = STRING(RECID(_P)).
  RUN adecomm/_adeevnt.p (INPUT  "{&TOOL-SHORT-NAME}":U, 
                          INPUT  "BEFORE-":U + p_status,
                          INPUT  context,
                          INPUT  p_outfile,
                          OUTPUT ok2continue).
  IF NOT ok2continue THEN RETURN "Error-Override":U.
END.

/* Make sure the p_code-id is only given for CHECK-SECTION. Otherwise
   find the code section we are checking. */  
IF p_status ne "CHECK-SECTION" THEN p_code-id = ?. 
ELSE FIND chk_code WHERE RECID(chk_code) eq p_code-id.

/* Open output file. */
IF p_status ne "SAVE" THEN DO: 
  /* Create a temporary file when previewing or checking syntax */
  IF _comp_temp_file = ?
  THEN RUN adecomm/_tmpfile.p ({&STD_TYP_WS_COMPILE}, {&STD_EXT_WS},
                                OUTPUT _comp_temp_file).
  p_outfile = _comp_temp_file.
END. 
ELSE /* The SAVE case. */
  DO ON STOP  UNDO, RETRY
     ON ERROR UNDO, RETRY: /* if an error occurs writing this file, abort */
   IF RETRY THEN DO:
     RUN Add-Error IN _err-hdl 
           ("ERROR":U, ?,
            SUBSTITUTE ("An error has occurred while writing to &1. " + 
                        "This file cannot be saved until the problem is resolved.",
                        p_outfile)).
     RETURN "Error-Write":U.
   END.
  ASSIGN write-access = "W":U. 
  RUN adecomm/_osfrw.p
      (INPUT p_outfile, INPUT "_WRITE-TEST":U , OUTPUT write-access).
  IF write-access <> "W":U THEN
  DO:
      RUN Add-Error IN _err-hdl
           ("ERROR":U, ?,
            SUBSTITUTE ("Cannot save to &1. File is read-only, or the path " +
                        "specified is invalid. Use a different filename.", 
                        p_outfile)).
      RETURN "Error-Write":U.
  END.
END.
  
/* Output to the stream. */
OUTPUT STREAM P_4GL TO VALUE(p_outfile).

/* ************************************************************************* */
/*                                                                           */
/*                     OUTPUT SPECIAL TOP-OF-FILE LINES                      */
/*                                                                           */
/* ************************************************************************* */
/* Place some predefined 4GL preprocessors at the top of the file to aid
   in debugging 4GL code. */
IF CAN-DO ("RUN,DEBUG",p_status) THEN
  PUT STREAM P_4GL UNFORMATTED
    "&Scoped-define Running_from_{&TOOL-SHORT-NAME} " _comp_temp_file SKIP
    "&Scoped-define NEW NEW" SKIP.

/* ************************************************************************* */
/*                                                                           */
/*      OUTPUT ALL SECTIONS (EXCEPT PROCEDURES, FUNCTION and CONTROLS)       */
/*                                                                           */
/* ************************************************************************* */

/* First, see if there are any functions to output in the custom FUNCTION section. */
/* We do this only if this is a WebSpeed file. */
IF NOT l_webspeed THEN done-fun = yes.
ELSE done-fun = NOT CAN-FIND (FIRST _code WHERE _code._P-recid eq p_proc-id 
                                       AND _code._section eq "_FUNCTION":U).

/* Get the first section. */             
RUN workshop/_find_cd.p (p_proc-id, "FIRST":U, "":U, OUTPUT next-id).
DO WHILE next-id ne ?:    
  /* Get the current section, and set up for the next one. */
  FIND _code WHERE RECID(_code) eq next-id .  
  next-id = _code._next-id. 

  /* Output each section. */   
  IF NOT l_webspeed THEN RUN put-code-section.  
  ELSE DO: 
    /* This is a Workshop maintained file. Structure the code blocks. */
 
    /* Make sure functions are in front of the SECOND custom block. 
      (The first one will be the top of the file, with header comments). */
    IF _code._section eq "_CUSTOM":U THEN DO:
      IF l_first-custom eq no THEN l_first-custom = yes.
      ELSE IF NOT done-fun THEN RUN put-internal ("_FUNCTION":U).
    END.
       
    IF LOOKUP(_code._section, "_CONTROL,_FUNCTION,_PROCEDURE":U) eq 0 THEN DO: 
      IF _code._special eq "":U 
      THEN RUN put-structured-section.
      ELSE RUN put-special-section.
    END. /* IF...[not] _CONTROL,_PROCEDURE... */
  END.  /* IF...l_webspeed... */

  /* Stop outputting sections if we are in a CHECK-SECTION case, and
     we've got to the section we are checking. */
  IF p_code-id ne ? AND RECID(_code) eq p_code-id THEN next-id = ?.
  
END. /* DO WHILE next-id ne ?... */


/* If functions have not been output, then do it now. 
   We need to do this even if we are checking only one section (because 
   the section might be using on of the functions. */
IF NOT done-fun THEN RUN put-internal ("_FUNCTION":U).

/* Don't bother putting out all the procedures etc if we are checking
   only one section. */
IF p_status eq "CHECK-SECTION":U THEN DO:

  /* Put the one procedure, or control section.  Functions are already done. */
  IF LOOKUP(chk_code._section, "_CONTROL,_PROCEDURE":U) > 0 THEN DO: 
    /* Custom write out the section. Don't worry about ANALYSE-SUSPEND etc,
       but do remember the offset information in the file. */
    FIND _code WHERE RECID(_code) eq RECID(chk_code).
    _code._offset = SEEK(P_4GL).  
    /* Controls need the code entered in a PROCEDURE. Give this a dummy name
       that is unlikely to exist (eg. web.input.2325)  */
    IF _code._section eq "_CONTROL":U 
    THEN PUT STREAM P_4GL UNFORMATTED SKIP 
             "PROCEDURE " _code._name "." RECID(_code) " :":U  SKIP.
    RUN put-code-text.
    /* Remember the end of the section. */
    _code._offset-end = SEEK(P_4GL).      
  END. /* IF...control, function, or procedure...*/
END. /* IF check-section... */
ELSE IF l_webspeed THEN DO:

  /* Output the rest of the file structured for webspeed. */
  /* If functions have not been output, then do it now.   */
  IF NOT done-fun THEN RUN put-internal ("_FUNCTION":U).

  /* *********************************************************************** */
  /*                                                                         */
  /*                           OUTPUT PROCEDURES                             */
  /*                                                                         */
  /* *********************************************************************** */
  /* Are there any procedures to output? */
  FIND FIRST _code WHERE _code._p-recid = RECID(_P) 
                     AND _code._section = "_PROCEDURE":U NO-ERROR.
  IF (AVAILABLE _code) THEN RUN put-internal ("_PROCEDURE":U).
  
  /* *********************************************************************** */
  /*                                                                         */
  /*                       OUTPUT TRIGGERS AND EVENTS                        */
  /*                                                                         */
  /* *********************************************************************** */
  /* Are there any procedures to output? */
  FIND FIRST _code WHERE _code._p-recid = RECID(_P) 
                     AND _code._section = "_CONTROL":U NO-ERROR.
  IF (AVAILABLE _code) THEN RUN put-triggers.
  
  /* *********************************************************************** */
  /*                                                                         */
  /*                               QUERIES                                   */
  /*                                                                          */
  /* *********************************************************************** */
  
  /* Put queries out at the end because the information is all in comments.    */
  RUN put-query-info. 
  
END. /* IF [not] CHECK-SECTION... */
  
OUTPUT STREAM P_4GL CLOSE.

/* Now that we have finished writing the file, restore the numeric format */
SESSION:NUMERIC-FORMAT = _numeric_format.   
 
/* Return the fullpath of the saved file. */ 
ASSIGN 
  FILE-INFO:FILE-NAME = p_outfile
  p_savepath = FILE-INFO:FULL-PATHNAME.

/* Compile the file we just created. */
CASE p_status: 

  WHEN "CHECK-SECTION":U THEN DO:  
    ASSIGN _err_recid = ?
           _err_num = ?.
    COMPILE VALUE(_comp_temp_file) NO-ERROR. 
    IF COMPILER:ERROR THEN DO:   
      ASSIGN _err_num = ERROR-STATUS:GET-NUMBER( 1 )  
             err-offset = COMPILER:FILE-OFFSET.
      /* Create the _err_msg global from the compiler errors. */
      RUN workshop/_errmsgs.p (_comp_temp_file, "no-line-numbers":U).
      /* An error occurred. Figure out where it occured.  If we can't
         find the section, it may be due to a poorly specifed err-offset
         (see bug #97-03-25-058, for example). In that case, just return 
         the current section. */
      FIND FIRST _code WHERE _code._P-recid eq p_proc-id
                         AND _code._offset < err-offset
                         AND err-offset < _code._offset-end
                       NO-ERROR.
      IF AVAILABLE _code THEN _err_recid = RECID(_code).
      ELSE _err_recid = p_code-id.

    END. /* IF COMPILER:ERROR... */
    /* Debugging - copy the file locally  OS-COPY VALUE(_comp_temp_file) checksyn.w. */
    OS-DELETE VALUE(_comp_temp_file).
  END. /*  "CHECK-SYNTAX":U... */  
  
  WHEN "CHECK-SYNTAX":U THEN DO:  
    RUN webtools/util/_fileact.p 
            (_P._filename,            /* Name to use in display */
             _comp_temp_file,         /* temporary file name */
             "CheckSyntax":U,         /* action */
             "No-Head":U +            /* options */
              IF LOOKUP ("HTML":U, _P._type-list) > 0 THEN ",e4gl-gen" ELSE ""
             ).
    /* Compile the file, report errors, then delete. */
    OS-DELETE VALUE(_comp_temp_file). 
  END. /*  "CHECK-SYNTAX":U... */

END CASE.

/* Let others know that the save was a success. (Again, except for Preview.)  */
IF p_status NE "PREVIEW":U
THEN RUN adecomm/_adeevnt.p 
          (INPUT "{&TOOL-SHORT-NAME}":U, p_status, context, p_outfile,
           OUTPUT ok2continue).

/* Now that syntax has been check discard all trigger offsets so that they   */
/* won't get confused with offsets from other windows being generated        */
FOR EACH _code WHERE _code._offset NE ?:
  ASSIGN _code._offset     = ?   
         _code._offset-end = ?
         .
END.

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
    WHEN 1 THEN file-base = file-base + ".r".
    OTHERWISE   ENTRY(cnt, file-base, ".") = "r".
  END CASE.
  
  /* Is the p_dir (compile) directory a real directory?  If so, parse it,
     Otherwise, use the current directory. */
  IF p_dir ne ? AND  p_dir ne "." THEN DO:
    /* Is the compile directory a full path, or is it relative to the file 
       prefix?  Check for names that have ":", indicating a DRIVE or names
       that start with / or \.  */
    IF (CAN-DO("OS2,MSDOS,WIN32,UNIX,VMS":u,OPSYS) AND INDEX(p_dir,":":u) > 0) 
       OR
       CAN-DO("~\/", SUBSTRING(p_dir, 1, 1, "CHARACTER"))
    THEN file-prfx = p_dir + "/".
    ELSE file-prfx = file-prfx + p_dir + "/".
  END.
  
  /* Return the full pathname of the compiled file, if it exists. */
  ASSIGN FILE-INFO:FILE-NAME = file-prfx + file-base
         p_rcode = FILE-INFO:FULL-PATHNAME
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
  RUN put-code-text.  
  
  PUT STREAM P_4GL UNFORMATTED
      "&ANALYZE-RESUME _END-INCLUDED-LIBRARIES" 
      SKIP (1).   
      
END PROCEDURE.  

/* *************************************************************************  
 * PUT-INTERNAL -
 *  Put the internal functions and procedures.
 *  Parameter: p_type (_FUNCTION, or _PROCEDURE)
 * ************************************************************************* */
PROCEDURE put-internal :
  DEFINE INPUT PARAMETER p_type AS CHAR      NO-UNDO.

  DEFINE VARIABLE i             AS INTEGER   NO-UNDO.
  DEFINE VARIABLE tmp_string    AS CHAR      NO-UNDO.

  CASE p_type:
    WHEN "_FUNCTION":U  THEN DO:
      PUT STREAM P_4GL UNFORMATTED SKIP
      "/* ***************************  Functions  **************************** */".   
      /* Note that Functions are done. */
      done-fun = yes.
    END.
    WHEN "_PROCEDURE":U THEN PUT STREAM P_4GL UNFORMATTED SKIP
    "/* **********************  Internal Procedures  *********************** */".
  END CASE.

  PUT STREAM P_4GL UNFORMATTED SKIP (1).

  /*  Output all procedures. */
  FOR EACH _code WHERE _code._p-recid eq RECID(_P) 
                   AND _code._section eq p_type
                    BY _code._name:

    /* Start Method Libaray Procedure EXCLUDE Preprocessor block. */
    IF _P._TYPE = "Method-Library":U THEN
        PUT STREAM P_4GL UNFORMATTED
          {&AMPER-IF} ' DEFINED(EXCLUDE-' _code._name ') = 0 ' {&AMPER-THEN}
          SKIP(1).
      
    /* Heading = _PROCEDURE name [SPECIAL] */
    PUT STREAM P_4GL UNFORMATTED
        "&ANALYZE-SUSPEND _CODE-BLOCK "
        _code._section SPACE _code._name SPACE _code._special
        SKIP.

    /* Generate default code on the fly, otherwise use the user input code */   
    IF _code._special ne "":U THEN DO:
      RUN workshop/_coddflt.p (_code._special, _code._p-recid, OUTPUT tmp_string).
      _code._offset = SEEK(P_4GL). 
      PUT STREAM P_4GL UNFORMATTED tmp_string. 
      _code._offset-end = SEEK(P_4GL).      
    END.
    ELSE RUN put-code-text.
    
    PUT STREAM P_4GL UNFORMATTED SKIP "&ANALYZE-RESUME" SKIP .

    IF _P._TYPE ne "Method-Library":U
    THEN PUT STREAM P_4GL UNFORMATTED SKIP.
    ELSE DO:
      /* End Method Libaray Procedure EXCLUDE Preprocessor block. */
      PUT STREAM P_4GL UNFORMATTED SKIP (1).
      PUT STREAM P_4GL UNFORMATTED {&AMPER-ENDIF} SKIP(1).
    END.  
  END. /* FOR EACH _code... */

END PROCEDURE.


/* *************************************************************************  
 * PUT-PROCEDURE-SETTINGS 
 * ************************************************************************* */
PROCEDURE put-procedure-settings :

  /* Make sure the settings are consistent with the type-list. */
  IF LOOKUP("INCLUDE":U, _P._type-list) > 0  
  THEN ASSIGN _P._compile = no
              _P._compile-into = ?.
  
  PUT STREAM P_4GL UNFORMATTED SKIP
 "/* *********************** Procedure Settings ************************ */"
    SKIP (1).

  PUT STREAM P_4GL UNFORMATTED
      "&ANALYZE-SUSPEND _PROCEDURE-SETTINGS" SKIP.

  PUT STREAM P_4GL UNFORMATTED
   "/* Settings for THIS-PROCEDURE" SKIP.

  IF _P._compile-into ne ?
  THEN PUT STREAM P_4GL UNFORMATTED
   "   Compile into: " _P._compile-into SKIP.   

  IF LOOKUP("INCLUDE":U, _P._type-list) > 0 OR  _P._compile
  THEN PUT STREAM P_4GL UNFORMATTED
   "   Other Settings:" 
   (IF LOOKUP("INCLUDE":U, _P._type-list) > 0 THEN " INCLUDE-ONLY" ELSE "") 
   (IF _P._compile                            THEN " COMPILE" ELSE "")
   SKIP.
  
  PUT STREAM P_4GL UNFORMATTED
   " */" SKIP.

  PUT STREAM P_4GL UNFORMATTED
      "&ANALYZE-RESUME _END-PROCEDURE-SETTINGS" 
      SKIP (1).
END PROCEDURE. 

/* *************************************************************************  
 * put-query-info: Put the information needed to rebuild all the queries.  
 * ************************************************************************* */
PROCEDURE put-query-info :
  DEFINE VARIABLE i             AS INTEGER       NO-UNDO.
  DEFINE VARIABLE i_count       AS INTEGER       NO-UNDO.
  DEFINE VARIABLE tmp_string    AS CHAR          NO-UNDO.
  DEFINE VARIABLE tmp_string2   AS CHAR          NO-UNDO.
  DEFINE VARIABLE TuneOpts      AS CHAR          NO-UNDO.
  
  /* Define the Queries and Browse Widgets for this window                     */
  /* Put out the header for the section only for the first non-blank query.    */
  i_count = 0.
  FOR EACH _U WHERE _U._P-recid eq p_proc-id
                AND _U._TYPE    eq "QUERY"  
                AND _U._STATUS  eq u_status,
      EACH _Q WHERE RECID(_Q)    = _U._x-recid BY _U._NAME BY _U._TYPE:
      
    /* The NOT OpenQury is to preserve that status even if not tables in the */
    /* the query.                                                            */
    i_count = i_count + 1.
    IF i_count eq 1 
    THEN PUT STREAM P_4GL UNFORMATTED SKIP (1)
      "/* Setting information for Queries                                      */"
      SKIP (1).
    PUT STREAM P_4GL UNFORMATTED
        "&ANALYZE-SUSPEND _QUERY-BLOCK " _U._TYPE " " _U._NAME SKIP .

    PUT STREAM P_4GL UNFORMATTED          
        "/* Query rebuild information for "  _U._TYPE " " _U._NAME SKIP.

    /* Handle freeform query situation */
    FIND _code WHERE _code._l-recid eq RECID(_U) AND
                     _code._name eq "OPEN_QUERY":U NO-ERROR.
    IF AVAILABLE _code THEN DO:  /* A Freeform query */
      PUT STREAM P_4GL UNFORMATTED          
        "     _START_FREEFORM" SKIP. 
      RUN put-code-text.
      PUT STREAM P_4GL UNFORMATTED "     _END_FREEFORM" SKIP.     
    END.  /* Freeform query */
    ELSE DO:  /* Not a freeform query */
      ASSIGN TuneOpts = REPLACE(REPLACE(TRIM(_Q._TuneOptions),CHR(13),""),
                                CHR(10),CHR(10) + FILL(" ",26)) .
             
      IF _Q._TblList ne "" THEN PUT STREAM P_4GL UNFORMATTED 
             "     _TblList          = """ _Q._TblList """" SKIP .
    
      IF _Q._OptionList ne "":U
      THEN PUT STREAM P_4GL UNFORMATTED 
             "     _Options          = """ _Q._OptionList """" SKIP.
      IF TuneOpts ne "" THEN PUT STREAM P_4GL UNFORMATTED 
             "     _TuneOptions      = """ TuneOpts """" SKIP.
      IF _Q._TblOptList ne "" THEN PUT STREAM P_4GL UNFORMATTED 
             "     _TblOptList       = """ TRIM(_Q._TblOptList) """" SKIP.   
      IF _Q._OrdList ne "" THEN PUT STREAM P_4GL UNFORMATTED 
          "     _OrdList          = """ _Q._OrdList """" SKIP.

      Extent-Stuff:
      REPEAT i = 1 TO NUM-ENTRIES(_Q._TblList):
        IF _Q._JoinCode[i] = ? AND
           _Q._Where[i] = ? THEN NEXT Extent-Stuff.
        ASSIGN tmp_string = REPLACE(_Q._Where[i],CHR(34),CHR(34) + CHR(34))
               tmp_string2 = REPLACE(_Q._JoinCode[i],CHR(34),CHR(34) + CHR(34)).
        IF _Q._JoinCode[i] ne ? AND _Q._JoinCode[i] ne ""
        THEN PUT STREAM P_4GL UNFORMATTED
             "     _JoinCode[" i "]      = "
                      IF tmp_string2 = ? THEN tmp_string2
                             ELSE ("~"" + tmp_string2 + "~"") SKIP.
        IF _Q._Where[i] ne ? and _Q._Where[i] ne ""
        THEN PUT STREAM P_4GL UNFORMATTED 
             "     _Where[" i "]         = "
                      IF tmp_string = ?  THEN tmp_string
                             ELSE ("~"" + tmp_string + "~"") SKIP.
      END. /* Extent-Stuff: REPEAT... */
    END. /* IF [not freeform] AVAILALBE _code...  */
    
    /* This line signals the end of the Query rebuild information. */
    PUT STREAM P_4GL UNFORMATTED 
      '*/  /* ' _U._TYPE SPACE _U._NAME ' */' SKIP 
      '&ANALYZE-RESUME':U
      SKIP (1).

  END.  /* FOR EACH...QUERY. */

  PUT STREAM P_4GL UNFORMATTED " " SKIP (1).
END PROCEDURE. 

/* *************************************************************************  
 * put-special-section: Look at the SPECIAL handler for a procedure and
 * output the section.  
 * ************************************************************************* */
PROCEDURE put-special-section :
  CASE _code._special :

    WHEN "_CREATE-WINDOW":U THEN DO:
       /* v2 files do not need this section anymore, so don't output it. */
       /* That is, do nothing.                                           */
    END.  
     
    WHEN "_FORM-BUFFER":U THEN DO:
      RUN workshop/_gendefs.p (p_proc-id, p_status, no).
      RUN workshop/_genrt.p (p_proc-id, p_status).   
    END.  
    
    WHEN "_INCLUDED-LIBRARIES":U THEN DO:
      RUN put-included-libs.    
      /* This is a good place to put out the FUNCTIONS. */
      IF NOT done-fun THEN RUN put-internal ("_FUNCTION":U).
    END.

    WHEN "_PREPROCESSOR-BLOCK":U THEN RUN workshop/_preproc.p (p_proc-id, p_status).      
    WHEN "_PROCEDURE-SETTINGS":U THEN RUN put-procedure-settings.            
    WHEN "_VERSION-NUMBER":U     THEN RUN put-version-number.     
      
    OTHERWISE DO:   
      /* Save the section as is --- this way we won't loose anything that
         we are not prepared to handle. */
      RUN put-code-section.
    END.            
    
  END CASE.
END PROCEDURE. 

/* *************************************************************************  
 * PUT-TRIGGERS: Write out the code for the trigger (Event Procedures).
 * ************************************************************************* */
PROCEDURE put-triggers :

  DEFINE VARIABLE i             AS INTEGER   NO-UNDO.
  DEFINE VARIABLE self-name     AS CHAR      NO-UNDO.
  DEFINE VARIABLE event-tag     AS CHAR      NO-UNDO.
  DEFINE VARIABLE tmp_string    AS CHAR      NO-UNDO.

  PUT STREAM P_4GL UNFORMATTED SKIP
 "/* ********************  Control Event Procedures  ********************* */" 
    SKIP (1).

  /*  Output all event procedures, by widget.  Make sure that SELF-NAME is defined. 
      NOTE that the QUERY pseudo-trigger (for OPEN_QUERY) is handled in the put-query
      section. */  
  FOR EACH _U WHERE _U._P-recid eq RECID(_P) 
                AND _U._type ne "QUERY":U
                AND CAN-FIND (FIRST _code WHERE _code._l-recid eq RECID(_U))
                USE-INDEX _NAME:
  
    /* Output the SELF-NAME */
    self-name = { workshop/name_u.i &U_BUFFER = "_U" }.
    PUT STREAM P_4GL UNFORMATTED SKIP "&SCOPED-DEFINE SELF-NAME " self-name SKIP.
       
    FOR EACH _code WHERE _code._l-recid = RECID(_U)
                     AND _code._section = "_CONTROL":U 
                      BY _code._name:

      /* Heading => _CONTROL self-name event 
         Replace the "web." part of the event procedure with self-name. */  
      event-tag = _code._name.
      IF event-tag BEGINS "web." 
      THEN event-tag = SUBSTRING(event-tag, 5, -1, "CHARACTER":U).
      PUT STREAM P_4GL UNFORMATTED
        "&ANALYZE-SUSPEND _CODE-BLOCK _CONTROL " self-name SPACE _code._name SPACE _code._special
        SKIP
        "PROCEDURE " self-name "." event-tag " :":U
        SKIP.

      /* Generate default code on the fly, otherwise use the user input code */   
      IF _code._special ne "":U THEN DO:
        RUN workshop/_coddflt.p (_code._special, _code._p-recid, OUTPUT tmp_string).
        _code._offset = SEEK(P_4GL). 
        PUT STREAM P_4GL UNFORMATTED tmp_string. 
        _code._offset-end = SEEK(P_4GL).      
      END.
      ELSE RUN put-code-text.
    
      PUT STREAM P_4GL UNFORMATTED SKIP "&ANALYZE-RESUME" SKIP (1).
    END. /* FOR EACH _code .. */
  END. /* FOR EACH _U... */
END PROCEDURE.

/* *************************************************************************  
 * put-version-number 
 *   Output _VERSION-NUMBER tag line, and description.
 * ************************************************************************* */
PROCEDURE put-version-number :
  PUT STREAM P_4GL UNFORMATTED
      "&ANALYZE-SUSPEND _VERSION-NUMBER " _VERSION-NO SPACE 
      _P._TYPE
      IF _P._template THEN " Template" ELSE ""
      SKIP.               
  /* Place name of html mapping file. */
  IF LOOKUP('HTML-Mapping':U, _P._type-list) > 0 THEN DO:
    PUT STREAM P_4GL UNFORMATTED
      "/* Maps: " (IF _P._html-file eq "":U THEN "HTML" ELSE _P._html-file)
      " */":U SKIP .
  END.
  /* Place description. */
  IF _P._DESC <> "" THEN DO:
    /* Outputs the Procedure Description into the .W */
    PUT STREAM P_4GL UNFORMATTED
      "/* Procedure Description" SKIP.
    EXPORT STREAM P_4GL _P._DESC.
    PUT STREAM P_4GL UNFORMATTED
      SKIP "*/" SKIP.  
  END.
  PUT STREAM P_4GL UNFORMATTED "&ANALYZE-RESUME" SKIP.
END.

/* Other standard procedures. */
{ workshop/genproc.i }

/* 
 * ---- End of file ----- 
 */
 

