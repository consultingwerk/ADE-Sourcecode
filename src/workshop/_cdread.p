/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _cdread.p

Description:
    Reads a structured code file (usually a .w file) into the WebSpeed Workshop

Input Parameters:
    p_proc-id  - Procedure Context ID for the relevent _P record.
    p_caller   - Procedure Handle for the calling .w (this includes the
                 AddError handler.
    p_mode     - Import Mode (OPEN, or OPEN UNTITLED)
    p_orig-ver - the original version number of the input file.
    p_options  - A comma-delimited list of options [currently unused]

Notes:
  Uses the default _P_QS code stream
  
Author: Wm. T. Wood
Date Created: January 1996

History:
    wood  12/23/96 Created from the old adeuib/_cdsuckr.p
---------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER p_proc-id    AS INTEGER NO-UNDO .                     
DEFINE INPUT  PARAMETER p_caller     AS HANDLE  NO-UNDO .
DEFINE INPUT  PARAMETER p_mode       AS CHAR    NO-UNDO .
DEFINE INPUT  PARAMETER p_orig-ver   AS CHAR    NO-UNDO .
DEFINE INPUT  PARAMETER p_options    AS CHAR    NO-UNDO .

/* Shared Include File definitions */
{ workshop/code.i }        /* Code section TEMP-TABLE definition             */
{ workshop/objects.i }     /* Object TEMP-TABLE definition                   */
{ workshop/sharvars.i }    /* Shared variables                               */
{ workshop/uniwidg.i }     /* Universal Widget TEMP-TABLE definition         */

/* Shared file-io parameters from the caller. */
DEFINE SHARED VAR _a_line    AS     CHAR             NO-UNDO.
DEFINE SHARED VAR _inp_line  AS     CHAR EXTENT 100  NO-UNDO.
DEFINE SHARED STREAM _P_QS.

/* Local definitions. */
DEFINE VARIABLE c_name             AS CHAR    NO-UNDO.
DEFINE VARIABLE l_webspeed         AS LOGICAL NO-UNDO.
DEFINE VARIABLE l_current-version  AS LOGICAL NO-UNDO.
DEFINE VARIABLE l_current-revision AS LOGICAL NO-UNDO.

&Scoped-define MAX-TOKENS 15
DEFINE VARIABLE token  AS CHAR EXTENT {&MAX-TOKENS} NO-UNDO.

/* -------------------------- Main Code Block --------------------------- */

/* Find the relevant record. */
FIND _P WHERE RECID(_P) eq p_proc-id.

/* See if this is a webspeed file by checking the start of the original
   version number. The version number is of the form "WDT_v2r1". Check
   up to the "_v".  If it is Webspeed, check the verion number and
   revision. */
IF ENTRY(1, _VERSION-NO, "_v":U) eq ENTRY(1, p_orig-ver, "_v":U)
THEN DO:
  l_webspeed = yes.
  IF ENTRY(1, _VERSION-NO, "r":U) eq ENTRY(1, p_orig-ver, "r":U)
  THEN l_current-version = yes.
  IF _VERSION-NO eq p_orig-ver THEN l_current-revision = yes. 
END.

RUN read-structured-file.

/* Special Cases -- if we have read an old file in, clean it up. */
IF l_webspeed THEN DO:
  IF p_orig-ver BEGINS "WDT_v1":U THEN DO:  
    /* Set it to compile-on-save. */
    _P._compile = yes.
    /* Remove the old _CREATE-WINDOW. */
    FOR EACH _code WHERE _code._P-recid eq p_proc-id
                     AND _code._special eq "_CREATE-WINDOW":U:  
      RUN workshop/_del_cd.p (RECID(_code)).
    END.                      
    /* Remove the old _XFTR's. */
    FOR EACH _code WHERE _code._P-recid eq p_proc-id
                     AND _code._section eq "_XFTR":U:  
      RUN workshop/_del_cd.p (RECID(_code)).
    END.                      
  END.
  
  /* Special Cases -- Remove sections that will be automatically addded
     when the file is written out. These are the RUN-TIME-SETTINGS and
     query rebuild sections. */
  FOR EACH _code WHERE _code._P-recid eq p_proc-id
                   AND _code._section eq "_DELETE-ON-LOAD":U:  
    RUN workshop/_del_cd.p (RECID(_code)).                    
  END.
END. /* IF l_webspeed... */
  
/*
 * ------------------------ Internal Procedures ------------------------- 
 */
      
/* -----------------------------------------------------------------------
   Description: look at the type of code block and decide how to hande it.  
   Parameter: p_part -- this will be set to FOOTER if the routine does
                        the readinf of the body of the trigger.
            
   Notes: The array, token[], is assumed to be pointing to a line
          starting with "&ANALYZE-SUSPEND _[UIB-]CODE-BLOCK ... "     
  ------------------------------------------------------------------------*/ 
PROCEDURE process-code-block  :     
  DEFINE INPUT-OUTPUT PARAMETER p_part AS CHAR NO-UNDO.

  CASE token[3]:
    WHEN "_CUSTOM":U THEN DO:
      ASSIGN _code._section = token[3]
             _code._name    = token[4]
             _code._special = token[5].  
      /* wdt_v1r1 compatibility:
       * Look for sections named _DEFINITIONS and _MAIN-BLOCK and get rid
       * of these special names. Also, we are moving the _INCLUDED-LIB section
       * from _CUSTOM in v1 to _WORKSHOP in v2. Check for "webspeed" so we
       * don't allow editting of UIB files method libraries. */
      CASE token[4]:                
        WHEN "_INCLUDED-LIB":U THEN DO:
          ASSIGN _code._section = "_WORKSHOP"
                 _code._name    = "Method Libraries".
          IF l_webspeed THEN _code._special = "_INCLUDED-LIBRARIES".
        END.
        WHEN "_DEFINITIONS":U THEN
          ASSIGN _code._name    = "Definitions"
                 _code._special = "".
        WHEN "_MAIN-BLOCK":U THEN
          ASSIGN _code._name    = "Main Code Block"
                 _code._special = "".
      END CASE. 
    END. /* &ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM */
    
    /* Internal Procedure or Function Section -- for example:
     * &ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE htm-offsets _WEB-HTM-OFFSETS 
     * or
     * &ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION get-value */
    WHEN "_PROCEDURE":U OR WHEN "_FUNCTION":U THEN DO:
       ASSIGN _code._section = token[3]
              _code._name    = token[4].
      /* Is there a special handler? */
      IF l_webspeed THEN DO:
        IF l_current-version
        THEN _code._special = token[5].
        ELSE _code._special = token[6].
        /* Process the rest of the line based special variable, for webspeed
           files. */   
        CASE _code._special:
          WHEN "_WEB-HTM-OFFSETS":U THEN DO:     
            RUN workshop/_rdoffp.p (p_proc-id). 
            p_part = "footer":U. /* The read routine reads to the footer. */
          END.
        END CASE.  
      END. /* IF l_WebSpeed... */
    END. /* &ANALYZE-SUSPEND _CODE_BLOCK _PROCEDURE/_FUNCTION ... */
 
    WHEN "_CONTROL":U THEN DO:
      /* This is of the form: 
          &ANALYZE-SUSPEND _CODE-BLOCK _CONTROL widget
          PROCEDURE widget.INPUT .  */ 
      ASSIGN _code._section = token[3]
             _code._name    = token[5] 
             /* Is there a special handler?*/
             _code._special = token[6].
      /* Associate the widget name with the related object in WebSpeed files.
         If there is no widget, then delete the code block. */
        c_name = token[4].
      IF NUM-ENTRIES(c_name,".") = 1 THEN
        FIND FIRST _U WHERE _U._P-recid eq p_proc-id
                        AND _U._NAME    eq c_name   
                        AND _U._TABLE   eq ?
                        AND LOOKUP(_U._TYPE, "FRAME,QUERY":U) eq 0 
                       NO-ERROR.
      ELSE IF NUM-ENTRIES(c_name,".") = 2 THEN
        FIND FIRST _U WHERE _U._P-recid eq p_proc-id
                        AND _U._NAME    eq ENTRY(2,c_name,".")
                        AND _U._TABLE   eq ENTRY(1,c_name,".")
                        AND LOOKUP(_U._TYPE, "FRAME,QUERY":U) eq 0 
                       NO-ERROR.
      ELSE IF NUM-ENTRIES(c_name,".") = 3 THEN
        FIND FIRST _U WHERE _U._P-recid eq p_proc-id
                        AND _U._NAME    eq ENTRY(3,c_name,".")
                        AND _U._TABLE   eq ENTRY(2,c_name,".")
                        AND _U._DBNAME  eq ENTRY(1,c_name,".")  
                        AND LOOKUP(_U._TYPE, "FRAME,QUERY":U) eq 0 
                       NO-ERROR.
      /* Make sure we have a real object. If so, get the name of
         the event. */ 
      IF NOT AVAILABLE (_U) THEN _code._section = "_DELETE-ON-LOAD".
      ELSE DO:  
        /* Link code to object. */
        _code._l-recid = RECID(_U).
        /* Read the next line (of the form): PROCEDURE xxy.INPUT . */
        _inp_line = "".
        IMPORT STREAM _P_QS _inp_line.
        /* Make sure the user didn't edit the file and move the
          end of line closer to the procedure name. */
        _inp_line[2] = RIGHT-TRIM(_inp_line[2], ":.":U).
        IF (_inp_line[1] = "PROCEDURE":U AND 
            NUM-ENTRIES(_inp_line[2], ".") > 1)
        THEN DO: 
          /* Make all pseudo events LOWER-CASE. This is new in
             version 2.0 (wood) */
          _code._name = "web.":U + 
                        lc(ENTRY(NUM-ENTRIES(_inp_line[2], ".":U),
                                            _inp_line[2], ".":U)).  
        END.
        ELSE _code._name = "UNKNOWN":U.    
      END. /* IF [available] _U... */      
    END. /* &ANALYZE-SUSPEND _CODE_BLOCK _CONTROL ... */
    
    OTHERWISE
        ASSIGN _code._section = token[3]
               _code._name    = token[4].
  END CASE. /* ENTRY (2... */

END PROCEDURE.

/* ---------------------------------------------------------------------
   Description: Reads the file and store it in either HEADER, code or FOOTER 
   secitons
  ------------------------------------------------------------------------*/ 
PROCEDURE read-structured-file :  
  DEFINE VAR ch-cnt  AS INTEGER           NO-UNDO.
  DEFINE VAR code-id AS INTEGER INITIAL ? NO-UNDO. 
  DEFINE VAR ln-cnt  AS INTEGER           NO-UNDO.
  DEFINE VAR part    AS CHAR              NO-UNDO.
  DEFINE VAR text-id AS INTEGER INITIAL ? NO-UNDO.
  DEFINE VAR prev-id AS RECID             NO-UNDO.
  DEFINE VAR txt     AS CHAR              NO-UNDO.

  /* Buffer for creating previous code sections */
  DEFINE BUFFER prev_code FOR _code.

  /* WDT_v1r1: Special variable to catch the V1 Control Definitions. */
  DEFINE VARIABLE l_v1CtrlDefs AS LOGICAL NO-UNDO.

  CREATE _code.
  ASSIGN _code._p-recid = RECID(_P) 
         _code._l-recid = RECID(_P)          
         part        = "header"
         code-id     = RECID(_code).

  Read-Loop:
  REPEAT ON END-KEY UNDO Read-Loop, LEAVE Read-Loop: 
    
    /* Read the next line */
    _a_line = "".
    IMPORT STREAM _P_QS UNFORMATTED _a_line.
    _a_line = _a_line + "~n".
    
    /* Watch for lines that have just a "?" */
    IF _a_line eq ? THEN _a_line = "?":U.
    
    /* WDT_v1r1: Handle the special case of looking for Version 1 
       control defintions. */
    IF l_v1CtrlDefs AND _a_line BEGINS "/* ":U AND
       INDEX(_a_line, " Control Definitions ":U) > 0
    THEN DO:
       /* Treat this like a FORM-BUFFER. */
       _a_line = "&ANALYZE-SUSPEND _FORM-BUFFER".
    END.
    
    /* Look for special items. */
    IF _a_line BEGINS "&ANALYZE-SUSPEND":U THEN DO:
      /* WDT_v1r1: Stop looking for Version 1 control definitions. */
      l_v1CtrlDefs = no.
      
      IF part ne "header":U THEN DO:
        /* Store the existing code. */
        CASE part:
          WHEN "code":U THEN 
            RUN store-code-block IN p_caller (txt, code-id, INPUT-OUTPUT text-id).
          WHEN "footer":U THEN
            _code._footer = txt.   
        END CASE.
        ASSIGN txt = "":U
               ch-cnt = 0
               ln-cnt = 0.
      
        /* Create a new code block. The current block is now the preview block. */
        /* Make sure the prev_code block is still the last code block (in case  */
        /* the last section created a special code block on the fly.)           */
        IF _code._next-id eq ? THEN prev-id = RECID(_code). 
        ELSE RUN workshop/_find_cd.p (p_proc-id, "LAST":U, "":U, OUTPUT prev-id).
        FIND prev_code WHERE RECID(prev_code) eq prev-id.
        CREATE _code.
        ASSIGN _code._p-recid     = RECID(_P) 
               _code._l-recid     = RECID(_P)
               _code._prev-id     = RECID(prev_code)
               prev_code._next-id = RECID(_code)
               code-id            = RECID(_code)
               text-id            = ?
               .          
      END. /* IF part ne "header":U */
      
      /* Finish the analyser section the analyze section. */
      ASSIGN _code._header = txt + _a_line
             txt           = "":U
             ch-cnt        = 0
             ln-cnt        = 0
             part          = "code":U.
      /* Figure out the name and type of the section. Use HTML because this
         was writen with &quot; in place of quotes (") within strings. */
      RUN tokenize (_a_line, "HTML":U).
      
      /* Handle non-webspeed files differently. */
      IF NOT l_webspeed THEN DO:  
        /* Allow editing of procedures and custom, but not TRIGGERS. */
        IF LOOKUP(token[2], "_CODE-BLOCK,_UIB-CODE-BLOCK":U) > 0 AND token[3] ne "_CONTROL":U 
        THEN RUN process-code-block (INPUT-OUTPUT part). 
        ELSE DO:
          /* Create a simple name for the section. */
          ASSIGN _code._name    = IF token[2] eq "":U THEN "SECTION":U
                                  ELSE IF token[3] eq "_CONTROL":U THEN "TRIGGER " + token[4]
                                  ELSE LEFT-TRIM(token[2], "_":U) + " " + token[3]
                 _code._section = "_WORKSHOP".
        END.     
      END. /* IF NOT l_webspeed... */ 
      ELSE DO:
        CASE token[2]:
        
          /* User Editable Code Blocks. */
          WHEN "_CODE-BLOCK" OR WHEN "_UIB-CODE-BLOCK":U THEN   
            RUN process-code-block (INPUT-OUTPUT part).
   
          /* Create Window -- This only exists in outdated (v1) files.  It will be
             removed when the file is written out. */
          WHEN "_CREATE-WINDOW":U THEN 
            ASSIGN _code._section = "_HIDDEN"
                   _code._special = token[2]
                   _code._name    = token[2].
          
          /* Parse the definitions. */
          WHEN "_FORM-BUFFER" THEN DO:   
            ASSIGN _code._section = "_WORKSHOP"
                   _code._special = token[2]
                   _code._name    = token[2]. 
            RUN workshop/_rddefs.p (p_proc-id, p_orig-ver, "":U).   
            part = "footer":U. /* The read routine reads to the footer. */
          END.   
          
          WHEN "_INCLUDED-LIBRARIES":U THEN
            ASSIGN _code._section = "_WORKSHOP"
                   _code._name    = "Method Libraries"
                   _code._special = token[2].
          
          /* Preprocessor section (v1 files call this the UIB-PREPROCESSOR-BLOCK) */
          WHEN "_PREPROCESSOR-BLOCK":U OR
          WHEN "_UIB-PREPROCESSOR-BLOCK":U THEN DO:
            ASSIGN _code._section = "_HIDDEN"
                   _code._special = "_PREPROCESSOR-BLOCK":U
                   _code._name    = "_PREPROCESSOR-BLOCK":U
                   . 
            RUN read-preprocessor-block. 
            part = "footer":U. /* The read routine reads to the footer. */  
            /* WDT_v1r1: In Version 1 this is where we can expect the 
               control definitions. */
            IF l_webspeed AND NOT l_current-version AND p_orig-ver BEGINS "WDT_v1"          
            THEN l_v1CtrlDefs = yes.
          END.      
   
          /* Procedure Settings Section . */
          WHEN "_PROCEDURE-SETTINGS":U  THEN DO:
            ASSIGN _code._section = "_WORKSHOP"
                   _code._special = token[2]
                   _code._name    = "Procedure Settings".  
            /* Read in the section. */
            IF l_webspeed THEN DO:
              RUN workshop/_rdproc.p (INPUT p_proc-id, INPUT p_mode).  
              part = "footer":U. /* The read routine reads to the footer. */
            END.
          END.
    
          /* Read Query rebuild information. 
             (e.g. &ANALYZE-SUSPEND _QUERY-BLOCK QUERY Web-Query) */
          WHEN "_QUERY-BLOCK" THEN DO:  
            ASSIGN _code._section = "_DELETE-ON-LOAD" /* This will be deleted at end of read. */
                   _code._special = token[2]
                   _code._name    = token[4]. 
            RUN workshop/_rdqury.p (p_proc-id, token[4], p_orig-ver, "":U /* Options */ ).       
            part = "footer":U. /* The read routine reads to the footer. */
          END.   
          
          /* Run-time settings */
          WHEN "_RUN-TIME-ATTRIBUTES" THEN DO:   
            ASSIGN _code._section = "_DELETE-ON-LOAD" /* This will be deleted at end of read. */
                   _code._special = token[2]
                   _code._name    = token[2].                
            RUN workshop/_readrt.p (p_proc-id, p_mode,  p_orig-ver).
            part = "footer":U. /* The read routine reads to the footer. */
          END.   
          
          /* Version number: 
             &ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Web-Object [Template] */
          WHEN "_VERSION-NUMBER":U THEN DO:
            ASSIGN _code._section = "_HIDDEN"
                   _code._special = token[2]
                   _code._name    = token[2].    
           /* Read other items from the template line. */
           IF token[4] ne "":U THEN 
             _P._TYPE = token[4].
           IF token[5] eq "Template":U AND p_mode eq "OPEN":U THEN 
             _P._template = yes.
           RUN read-version-number. 
           part = "footer":U. /* The read routine reads to the footer. */
          END.
          
          OTHERWISE DO:
            /* Special case. We don't know what to do with it, so make it hidden. */
            ASSIGN _code._name = _a_line.
                   _code._section = "_HIDDEN":U
                   .
          END. 
          
        END CASE. /* ENTRY (1... */
       END. /* IF...l_webspeed... */
       
      /*
       * Debugging code ---
       *  {&OUT} 'Reading ' _code._name '[ ' 
       *  token[2] ' : ' token[3] ' : ' token[4] ' : ' token[5] 
       *  ']<br>~n'.
       */

    END. /* IF...ANALYZE-SUSPEND... */
    ELSE DO:
    
      /* Is the code section getting too big. */
      IF part eq "Code":U THEN DO:
        /* Have we got to the footer. */  
        IF _a_line BEGINS "&ANALYZE-RESUME" OR
           _a_line BEGINS "/* _UIB-"    /* Used in WDT_v1r1 & UIB */
        THEN DO:
          RUN store-code-block IN p_caller (txt, code-id, INPUT-OUTPUT text-id).
          ASSIGN txt    = _a_line
                 ch-cnt = LENGTH(_a_line, "CHARACTER":U) 
                 ln-cnt = 1
                 part   = "footer":U.
        END.
        ELSE DO:
          ASSIGN ch-cnt = ch-cnt + LENGTH(_a_line, "CHARACTER":U)
                 ln-cnt = ln-cnt + 1.
          IF ch-cnt > 10000 THEN DO:
            RUN store-code-block IN p_caller (txt, code-id, INPUT-OUTPUT text-id).
            ASSIGN txt    = _a_line
                   ch-cnt = LENGTH(_a_line, "CHARACTER":U)
                   ln-cnt = 1.
          END.      
          ELSE ASSIGN txt = txt + _a_line .
        END.
      END. /* IF part eq "Code... */
      ELSE DO:
        /* We are in either the header or footer. Add the line. */
        ASSIGN ch-cnt = ch-cnt + LENGTH(_a_line, "CHARACTER":U)
               ln-cnt = ln-cnt + 1
               txt    = txt + _a_line
               .
        /* Check for abnormally long headers. */
        IF part eq "Header":U AND ln-cnt > 5 THEN 
          ASSIGN _code._section = "HIDDEN":U
                 _code._name    = "Unknown":U
                 part           = "code":U.
      END.
    END. /* IF...<not>...ANALYZE-SUSPEND... */
  END. /* Read-Loop */
  /* Add in the last line, if necessary. */
  IF _a_line ne "":U THEN  txt = txt + _a_line + "~n".
  IF txt ne "":U THEN DO:
    CASE part:
      WHEN "Header":U THEN _code._header = txt.
      WHEN "Code":U   THEN 
        RUN store-code-block IN p_caller (txt, code-id, INPUT-OUTPUT text-id).
      WHEN "Footer":U THEN _code._footer = txt.
    END CASE.
  END. /* IF txt ne "":U */
END PROCEDURE.

/* ----------------------------------------------------------------------------
   Read-Preprocessor-Block -
      Read in the top version number section.
   --------------------------------------------------------------------------- */
PROCEDURE Read-Preprocessor-Block :    
  define variable done as logical no-undo.
  
  /* We are in the Preprocessor section.  Parse it. */   
     
  REPEAT WHILE NOT DONE:
    _inp_line = "".
    IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].     

    /* Is the WEB-FILE defined? */
    IF _inp_line[1] BEGINS "&Scoped-define WEB-FILE ":U
    THEN DO:
      _P._html-file = TRIM(SUBSTRING(_inp_line[1], 24, -1, "CHARACTER":U)). 
      IF LOOKUP("HTML-Mapping":U, _P._type-list) eq 0
      THEN _P._type-list = _P._type-list + ",Html-Mapping". 
    END.
    /* Does this list the custom settings */
    ELSE IF _inp_line[1] BEGINS  "/* Custom List Definitions ":U 
    THEN DO:
      IMPORT STREAM _P_QS _inp_line.
      /* If the next line is not a comment, then we have an older version
         of the .w file.  This is our "tag" so that we know we can read in
         the names of the lists */
      IF _inp_line[1] eq "/*" THEN DO:
        /* Check the length of the list for errors */
        IF NUM-ENTRIES(_inp_line[2]) eq {&MaxUserLists} 
        THEN _P._LISTS = _inp_line[2].
      END.
      DONE = YES.  /* Nothing else to read here */
    END.  
    ELSE DONE = _inp_line[1] BEGINS "&ANALYZE-RESUME" OR
                _inp_line[1] BEGINS "/* _UIB-PREPROCESSOR-BLOCK-END".
  END.   
  
END PROCEDURE.

/* ----------------------------------------------------------------------------
   Read-Version-Number -
      Read in the top version number section.
   --------------------------------------------------------------------------- */
PROCEDURE Read-Version-Number :  
  DEFINE VARIABLE descrpt AS CHARACTER INITIAL "" FORMAT "X(1024)" NO-UNDO.
  
  Read-Loop:
  REPEAT ON ENDKEY UNDO Read-Loop, LEAVE Read-Loop:
    /* Read the next line */
    _inp_line = "".
    IMPORT STREAM _P_QS _inp_line.

    CASE _inp_line[1]:      
    
      WHEN "&ANALYZE-RESUME":U THEN LEAVE Read-Loop. 
       
      WHEN "/*":U THEN DO:
        IF _inp_line[2] = "Procedure" AND _inp_line[3] = "Description" THEN DO:
          /* The description is the next line. */
          IMPORT STREAM _P_QS descrpt.
          /* Only store the description when a file is "opened". That is, remove the
           description if the file is Openned Untitled (from a template)*/
          IF p_mode eq "OPEN" THEN ASSIGN _P._desc = descrpt .
        END. 
      END. /* WHEN comment... */
      
      OTHERWISE NEXT Read-Loop.
  
    END CASE.  
  END. /* Read-Loop */
END PROCEDURE.            

/* Standard procedures. */
{ workshop/util4gl.i }
{ workshop/rdproc.i }

/* 
 * ---- End of file ----- 
 */
