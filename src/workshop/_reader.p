/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _reader.p

Description:
    Reads a text file (usually a .w file) into the WebSpeed Workshop

Input Parameters:
   p_fullpath - Full pathname (should be a .w file) to read in. If we
                are openning an existing file, then an _P record is
                assumed to exist.  If we are openning a template, then
                a _P is created.
   p_mode - Mode for operation.
                  "OPEN" - open a .w file
                  "OPEN UNTITLED" - open a .w file but don't save the
                                    name (open as UNTITLED).
                  "IMPORT" -- was in v1, not in v2 [unsupported]
Output Parameters:  
   p_proc-id - The context ID of the procedure that was openned or created.
               If no file was openned this returns ?.

Author: Wm. T. Wood
Date Created: December 1996

History:
    wood  12/23/96 Created from the old adeuib/_qssucker.p
---------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER p_fullpath AS CHAR NO-UNDO .
                        /* File to open                                      */
DEFINE INPUT  PARAMETER p_mode     AS CHAR NO-UNDO .
                        /* "OPEN", or "OPEN UNTITLED"                        */

DEFINE OUTPUT PARAMETER p_proc-id  AS INTEGER NO-UNDO INITIAL ?.
                        /* Context ID of the _P record.                      */

/* Shared Include File definitions */

{ workshop/objects.i }      /* Object TEMP-TABLE definition   */
{ workshop/code.i }         /* Code Section TEMP-TABLE        */
{ workshop/sharvars.i }     /* Shared variables               */
{ workshop/pre_proc.i }     /* Preprocessor variables        */ 
{ workshop/errors.i }       /* Error handler and functions.   */

DEFINE NEW SHARED VAR _a_line    AS CHAR                    NO-UNDO.
DEFINE NEW SHARED VAR _inp_line  AS CHAR EXTENT 100         NO-UNDO.
DEFINE NEW SHARED STREAM _P_QS.

DEFINE VAR AbortImport           AS LOGICAL INITIAL FALSE   NO-UNDO.
DEFINE VARIABLE block_pointer    AS INTEGER                 NO-UNDO.
DEFINE VARIABLE dot_w_file       AS CHAR   FORMAT "X(40)"   NO-UNDO.
DEFINE VARIABLE err_msgs         AS CHAR                    NO-UNDO.
DEFINE VARIABLE i                AS INTEGER                 NO-UNDO.
DEFINE VARIABLE isa-e4gl         AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE file_ext         AS CHAR                    NO-UNDO.
DEFINE VARIABLE ldummy           AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE no-block-flag    AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE orig-version-no  AS CHAR                    NO-UNDO. 
DEFINE VARIABLE testname         AS CHAR                    NO-UNDO.

DEFINE BUFFER x_P FOR _P.

/* Numbers/Dates in 4GL source code use American defaults. */
SESSION:NUMERIC-FORMAT = "AMERICAN":U.

/* Make sure we have the full pathname, so that we don't open the same
   file twice. */
ASSIGN FILE-INFO:FILE-NAME = p_fullpath
       dot_w_file = FILE-INFO:FULL-PATHNAME.

/* Make sure the file exists.  */ 
IF dot_w_file eq ? THEN DO:
  RUN Add-Error IN _err-hdl 
      ("ERROR":U, ?, SUBSTITUTE ('File "&1" not found.', p_fullpath)).
  RETURN "_ABORT":U.
END.

/*
 * If the user is trying to open a file that is already open then
 * tell caller. The caller should then make that window the active one.
 * Do not open the window twice. The UIB can open the same window twice.
 * However, the windows are disjoint and cause useability problems since
 * the windows are not in synch.
 *
 * This situation handles reopening a file via "Edit Master...".
 *
 * We don't need to do this if p_mode is "OPEN UNTITLED".
 */

CASE p_mode:
  WHEN "OPEN" THEN DO:

    /* Search the universal records for a window with the same file name. */
    FIND _P WHERE _P._fullpath eq dot_w_file NO-ERROR.
    IF NOT AVAILABLE (_P) THEN DO:
      RUN Add-Error IN _err-hdl 
        ("ERROR":U, ?, 
         SUBSTITUTE ('Could not open &1 because internal file record could not be found',
                      p_fullpath)).
      RETURN "_ABORT":U.
    END.
    /* This _P is the current record. */
    p_proc-id = RECID(_P).
  
    /* Tell caller file already exists using "reopen" message. */   
    IF _P._open THEN RETURN "_REOPEN,":U + STRING(RECID(_P)).
  
  END. /* OPEN */  
  
  WHEN "OPEN UNTITLED":U THEN DO:     
    /* Create a new _P record and initialize it based on the template. */
    CREATE _P.
    /* Figure out the type of this file. */
    RUN webtools/util/_filetyp.p (dot_w_file, OUTPUT _P._type, OUTPUT _P._type-list).
    /* The basic file could be a template... remove this setting. */
    i = LOOKUP("Template", _P._type-list).
    IF i > 0 THEN ENTRY(i,_P._type-list) = "".
    /* Also store the file extension. */
    RUN adecomm/_osfext.p (dot_w_file, OUTPUT _P._fileext).
    IF _P._fileext BEGINS ".":U THEN SUBSTRING(_P._fileext, 1, 1, "CHARACTER") = "".
    /* Give this a unique untitled name. */
    ASSIGN i = 1
           testname = "Untitled".
    DO WHILE CAN-FIND (FIRST x_P WHERE x_P._filename eq testname): 
      ASSIGN i = i + 1
             testname = "Untitled:" + TRIM(STRING(i,">>>>9":U)).
    END.                                                        
    _P._filename = testname.
    /* This _P is the current record. */
    p_proc-id = RECID(_P).
  
  END. /* OPEN UNTITLED */  
  
  OTHERWISE DO:
    RUN Add-Error IN _err-hdl 
      ("ERROR":U, ?, SUBSTITUTE( "Unknown Workshop load mode &1. Aborting load." , p_mode)).
    RETURN "_ABORT":U.
  END. 
END CASE.

/* Analyse and Verify the file we are looking at. If there is a problem
   then exit. */
AbortImport = no.
{ workshop/vrfyimp.i }
IF AbortImport THEN DO:
  RUN reader_cleanup.
  RETURN "_ABORT":U.
END.

/* Reopen the file. */
INPUT STREAM _P_QS CLOSE.
INPUT STREAM _P_QS FROM VALUE(dot_w_file) {&NO-MAP}.


/* Read in all the code sections. Do this differently if the file is not structured. */  
IF LOOKUP("Structured", _P._type-list) > 0
THEN RUN workshop/_cdread.p 
            (INTEGER(RECID(_P)), THIS-PROCEDURE, p_mode, orig-version-no, "":U).
ELSE DO:
  RUN read-text-file.

  /* For E4GL files, check wsoptions. */
  IF LOOKUP("HTML":U, _P._type-list) > 0 AND LOOKUP("MAPPED":U, _P._type-list) eq 0
  THEN DO:
    /* Initialize based on type. */
    _P._compile = yes.
    RUN workshop/_wsopt.p (INTEGER(RECID(_P)), OUTPUT isa-e4gl).
  END.
END. /* Text files. */

/* Cleanup after ourselves. */
RUN reader_cleanup.

/* Send event to notify anyone interested that the UIB has opened a file.
   Note that opening a window UNTITLED counts as a NEW event.  */
CASE p_mode:
  WHEN "OPEN":U THEN
    RUN adecomm/_adeevnt.p 
        (INPUT  "{&TOOL-SHORT-NAME}":U, "OPEN":U, STRING(RECID(_P)), _P._filename,
         OUTPUT ldummy).
  WHEN "OPEN UNTITLED":U THEN
    RUN adecomm/_adeevnt.p
        (INPUT  "{&TOOL-SHORT-NAME}":U, "NEW":U, STRING(RECID(_P)), ?,
         OUTPUT ldummy).
END CASE.

/* If we got here, the file openned successfully. */
ASSIGN _P._open  = yes.
 
RETURN.

/****************************** Internal Procedures ***************************/

/* ---------------------------------------------------------------------
   Description: Close open file streams and restore cursor.  This
                should be called everywhere we return from _reader.p          
   Parameters:  None
   Non-local effects: _P_QS closed
------------------------------------------------------------------------*/ 
PROCEDURE reader_cleanup:
  /* Close Streams. */
  INPUT STREAM _P_QS CLOSE.    
  /* Restore environment. */
  SESSION:NUMERIC-FORMAT = _numeric_format.
END PROCEDURE.
 
/* ---------------------------------------------------------------------
   Description: Reads the whole file line by line and stores the blocks.
  ------------------------------------------------------------------------*/ 
PROCEDURE read-text-file :  
  DEFINE VAR ch-cnt       AS INTEGER NO-UNDO.
  DEFINE VAR code-size    AS INTEGER NO-UNDO.
  DEFINE VAR line-size    AS INTEGER NO-UNDO.
  DEFINE VAR code-id      AS INTEGER NO-UNDO INITIAL ?. 
  DEFINE VAR line-cnt     AS INTEGER NO-UNDO.
  DEFINE VAR l_new-block  AS LOGICAL NO-UNDO.
  DEFINE VAR new-name     AS CHAR    NO-UNDO.
  DEFINE VAR overflow     AS INTEGER NO-UNDO. 
  DEFINE VAR text-id      AS INTEGER NO-UNDO.
  DEFINE VAR txt          AS CHAR    NO-UNDO.
  
  /* Buffor for huge sections. */
  DEFINE BUFFER prev_code FOR _code.

  /* Create a code block to store the code.  NOTE: Do this outside the READ-LOOP because
     we want all files, even empty ones, to have at least one code section.
     Otherwise the WebSpeed Editor will be confused. */
  CREATE _code.
  /* Link the code block to the procedure and to its text segments. */
  ASSIGN _code._p-recid = RECID(_P)
         _code._l-recid = RECID(_P)
         _code._section = "_CUSTOM"
         _code._name    = "Contents" 
         code-id        = RECID(_code)
         text-id        = ?
         code-size      = 0
         l_new-block    = no
         . 

  READ-LOOP:
  REPEAT ON END-KEY UNDO READ-LOOP, LEAVE READ-LOOP:   
     /* Read the next line */
    _a_line = "".
    IMPORT STREAM _P_QS UNFORMATTED _a_line.
    _a_line = _a_line + "~n".
   
    /* Watch for lines that have just a "?" */
    IF _a_line eq ? THEN _a_line = "?":U.

    /* Do we need to create a new code section to store the block. */
    IF l_new-block THEN DO:
      CREATE _code.
      /* Link this to the previous code block, if any. */
      IF code-id ne ? THEN DO:
        FIND prev_code WHERE RECID(prev_code) eq code-id.
        ASSIGN _code._prev-id     = RECID(prev_code)
               prev_code._next-id = RECID(_code).
      END.
      /* Link the code block to the procedure and to its text segments. */       
      ASSIGN _code._p-recid = RECID(_P) 
             _code._l-recid = RECID(_P)
             _code._section = "_CUSTOM"
             _code._name    = new-name
             code-id        = RECID(_code) 
             text-id        = ?
             code-size      = 0
             l_new-block    = no.
    END. /* IF l_new-block THEN DO... */
     
    /* Is the code block getting too big? */
    ASSIGN line-size = LENGTH(_a_line, "CHARACTER":U)
           line-cnt  = line-cnt + 1.
    IF ch-cnt + line-size < 10000
    THEN ASSIGN txt    = txt    + _a_line
                ch-cnt = ch-cnt + line-size .
    ELSE DO:
      RUN store-code-block (txt, code-id, INPUT-OUTPUT text-id).
      ASSIGN code-size  = code-size + ch-cnt   /* Total code stored the section. */
             txt        = _a_line              /* text of next block.            */    
             ch-cnt     = LENGTH(_a_line, "CHARACTER":U)
             line-cnt   = 1
             .
      /* See if we need to start a new section [Section editor must be < 32K] */
      /* The code here will be multiples of 10K. So if we've stored >16K then */
      /* we are really at 20K. */
      IF code-size > 16000 THEN DO:
        ASSIGN l_new-block = yes
               overflow = overflow + 1
               new-name = "Continued" + (IF overflow < 2 THEN "":U
                                         ELSE SUBSTITUTE(" (&1)":U, overflow)).
      END. /* IF code-size > 25000... */
    END. /* IF ch-cnt...> 10000... */
  END. /* READ-LOOP */
  
  /* Add in the last line, if necessary. */
  IF _a_line ne "":U THEN txt = txt + _a_line + "~n".
  IF txt ne "":U THEN RUN store-code-block (txt, code-id, INPUT-OUTPUT text-id).

END PROCEDURE.

/* ---------------------------------------------------------------------
   Description: Create a code block for the code.
   Notes:       This is called from this file and in routines that
                are called by file (eg. _cdread.p)
  ------------------------------------------------------------------------*/ 
PROCEDURE store-code-block :
  DEFINE INPUT        PARAMETER p_text    AS CHAR NO-UNDO.
  DEFINE INPUT        PARAMETER p_code-id AS INTEGER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_text-id AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE new-id AS INTEGER NO-UNDO.
  /* Create a new code section. */
  CREATE _code-text.
  ASSIGN _code-text._text    = p_text
         _code-text._code-id = p_code-id
         _code-text._next-id = ?
         new-id = RECID(_code-text).

  /* Make the previous text object point to this one. If there is no previous object,
     then point the code record itself to this one. */
  IF p_text-id eq ? THEN DO:
    FIND _code WHERE RECID(_code) eq p_code-id.
    _code._text-id = new-id.
  END.
  ELSE DO:
    FIND _code-text WHERE RECID(_code-text) eq p_text-id.
    _code-text._next-id = new-id.
  END.
  /* Return the recid of the new code block. */
  p_text-id = new-id.  
END.
