/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _rddefs.p

Description:
    Read a _FORM-BUFFER or DEFINE VARIABLE sections of a .w file and
    creates the _U/_F records.       
    
Input Parameters:
    p_proc-id  - Procedure Context ID for the relevent _P record.
    p_orig-ver - the original version number of the input file.
    p_options  - A comma-delimited list of options [currently unused]

Output Parameters:
   <None>

Author:  Wm.T.Wood 
Created: February 20, 1997

---------------------------------------------------------------------------- */
DEFINE INPUT  PARAMETER p_proc-id    AS INTEGER NO-UNDO .                     
DEFINE INPUT  PARAMETER p_orig-ver   AS CHAR    NO-UNDO .
DEFINE INPUT  PARAMETER p_options    AS CHAR    NO-UNDO .

/* Shared Include File definitions */
{ workshop/objects.i }     /* Object TEMP-TABLE definition                   */
{ workshop/sharvars.i }    /* Shared variables                               */
{ workshop/uniwidg.i }     /* Universal Widget TEMP-TABLE definition         */

/* WDT_v1r1: Special variable to catch the V1 Control Definitions. */
DEFINE VARIABLE l_v1CtrlDefs AS LOGICAL NO-UNDO.

DEFINE SHARED  STREAM    _P_QS.

/* Local Variables --- */
DEFINE VARIABLE  aline         AS  CHAR           NO-UNDO.
&Scoped-define MAX-TOKENS 100
DEFINE VARIABLE token  AS CHAR EXTENT {&MAX-TOKENS} NO-UNDO.

DEFINE BUFFER frm_U FOR _U.

/* --------------------------   Debugging    --------------------------- */
/* Use this to turn debugging on after each line that is read in.
   (i.e. rename no-DEBUG  to DEBUG) */
&Scoped-define no-debug yes

/* Show the current line */
&IF FALSE AND "{&debug}" ne "" &THEN                                   
  { src/web/method/cgidefs.i } 
  &Scoped-define debug {&OUT} aline .
  RUN OutputContentType IN web-utilities-hdl ("text/html":U). 
  {&debug}
&ENDIF       

/* -------------------------- Main Code Block --------------------------- */

/* WDT_v1r1: Is this a frame definition from the previous release. */
IF p_orig-ver BEGINS "WDT_v1" THEN l_v1CtrlDefs = yes.

Process-Definition-Block:
REPEAT:
  /* Read in the lines and loop for DEFINE VARIABLE lines. */
  aline = "".
  IMPORT STREAM _P_QS UNFORMATTED aline. {&debug}   

  /* Trim the line and look for ones that begin DEF */
  aline = LEFT-TRIM (aline).
  IF aline BEGINS "DEF" THEN DO:
     IF aline MATCHES "DEF* VAR*" THEN DO:
       RUN read-def-var.  
     END.
     ELSE IF aline MATCHES "DEF* FRAME *" THEN DO:
       RUN read-def-frame.   
     END.
  END.
  ELSE IF aline BEGINS "&ANALYZE-RESUME" THEN 
    LEAVE Process-Definition-Block.
  /* WDT_v1r1: Special checks only for V1 files. */
  ELSE IF l_v1CtrlDefs THEN DO:
    /*   Is this a frame definition from the previous release?
         If so, it won't end with an &ANALYZE-RESUME. */
    IF aline BEGINS "/* ":U AND INDEX(aline, " Procedure Settings ":U) > 0 
    THEN LEAVE Process-Definition-Block.
    /* Also in Version 1, Query Definitions are in a simple
        &ANALYZE-SUSPEND...&ANALYZE-RESUME block */
    ELSE IF TRIM(aline) eq "&ANALYZE-SUSPEND" THEN DO:
      /* Look for the next ANALYZE-RESUME line. */
      IMPORT STREAM _P_QS UNFORMATTED aline. {&debug}   
      DO WHILE NOT (LEFT-TRIM(aline) BEGINS "&ANALYZE-"):
        IMPORT STREAM _P_QS UNFORMATTED aline. {&debug}   
      END.
    END. /* IF...&ANALYZE-SUSPEND... */
  END. /* ...IF l_v1CtrlDefs ... */
END. /* Process-Defintion-Block: REPEAT... */

/* Final check.  Make sure all widgets are assigned to a frame. */  
FOR EACH _U WHERE _U._P-recid eq p_Proc-ID  
              AND _U._parent-recid eq ?
              AND LOOKUP(_U._TYPE, "QUERY,FRAME":U) eq 0: 
  /* Make sure there is a frame record. */
  IF NOT AVAILABLE frm_U THEN DO:  
    CREATE frm_U.
    ASSIGN /* Create links between objects. */
           frm_U._P-recid      = p_Proc-ID
           frm_U._parent-recid = ?
           frm_U._name         = "Web-Frame"
           frm_U._type         = "FRAME":U
           .
  END.   
  /* Put the object in the frame. */
  _U._parent-recid = RECID(frm_U).
END. /* FOR EACH... */

/* ------------------------ Internal Procedures ------------------------- */

/* ---------------------------------------------------------------------
   Description: Reads the DEFINE VARIABLE... statement.
   Globals: This uses and sets the aline variable.
  ------------------------------------------------------------------------*/ 
PROCEDURE read-def-var :   
  
  /* Parse lines of the form:
   *   DEFINE VARIABLE name AS data-type FORMAT "x(256)" INITIAL no
   *      VIEW-AS type options
   *      SIZE c BY r NO-UNDO.    
   */
  RUN tokenize(aline, "4GL":U). /* Use 4GL option to handle FORMAT strings */
  /* Create the _U/_F variables to hold this object. */
  CREATE _U.  
  CREATE _F.
  ASSIGN
       /* Create links between objects. */
       _U._P-recid      = p_Proc-ID
       _U._x-recid      = RECID(_F)
       _U._parent-recid = ?  /* This will be set in the DEFINE FRAME */
       /* Standard Attibutes. */ 
       _U._NAME         = token[3]
       _F._DATA-TYPE    = token[5]
       /* Reset the SIZE (which will be overwritten if a SIZE is read in.) */
       _F._WIDTH        = ?
       _F._HEIGHT       = ?
       .
  /* Go though the rest of the token string storing items */  
  RUN read-var-attributes (6).
END PROCEDURE.

/* ---------------------------------------------------------------------
   Description: Reads the DEFINE FRAME... statement.
   Globals: This uses and sets the aline variable.
  ------------------------------------------------------------------------*/ 
PROCEDURE read-def-frame :   
  DEF VAR c_dbname AS CHAR NO-UNDO.
  DEF VAR c_table  AS CHAR NO-UNDO.
  DEF VAR c_name   AS CHAR NO-UNDO.  
  DEF VAR cnt      AS INTEGER NO-UNDO.
  DEF VAR i        AS INTEGER NO-UNDO.
  DEF VAR l_dbok   AS LOGICAL NO-UNDO.
  DEF VAR last-ch  AS CHAR NO-UNDO.  

  /* Parse lines of the form:
       DEFINE FRAME name
          ...
          WITH NO-LABELS.  
   */
  RUN tokenize(aline, "":U).   
  
  /* Create the frame record to hold this name (or see if it already
     exists). Remember, the output routine creates multiple form definitions
     if the first one gets longer than 3.5K. */       
  FIND frm_U WHERE frm_U._P-recid eq p_Proc-ID 
               AND frm_U._name eq token[3] NO-ERROR.
  IF NOT AVAILABLE (frm_U) THEN DO:                         
    CREATE frm_U.
    ASSIGN /* Create links between objects. */
           frm_U._P-recid      = p_Proc-ID
           frm_U._parent-recid = ?
           frm_U._name         = token[3]
           frm_U._type         = "FRAME":U
           .   
  END.
          
  Frame-Block:
  REPEAT:
    /* Read in the lines and loop for variable/field names. */
    aline = "".
    IMPORT STREAM _P_QS UNFORMATTED aline. {&debug}   

    /* Look for the WITH line. */
    aline = LEFT-TRIM (aline).
    IF aline BEGINS "WITH " OR aline BEGINS "&ANALYZE-" 
    THEN DO:   
      /* Loop down to the end of the WITH phrase. */
      IF aline BEGINS "WITH ":U THEN DO:                 
        End-of-Frame:
        REPEAT:  
          ASSIGN aline   = TRIM(aline)
                 cnt     = LENGTH(aline, "CHARACTER":U)
                 last-ch = IF cnt eq 0 THEN "" 
                           ELSE SUBSTRING(aline, cnt, 1, "CHARACTER":U).
          IF cnt eq 0 OR last-ch eq ".":U THEN LEAVE End-of-Frame. 
          ELSE DO:
            aline = "".
            IMPORT STREAM _P_QS UNFORMATTED aline. {&debug}   
          END.
        END.
      END.
      /* We've got to the end of the frame definition. */
      LEAVE Frame-Block.  
    END.
    ELSE IF aline ne "":U THEN DO:  
      /* This is a variable name on the line. Tokenize as 4GL to catch
         FORMAT and INITIAL character values. */
      RUN tokenize(aline, "4GL":U).   

      /* Some WebSpeed WDT_v1r1 files had LABEL, VIEW-AS and SIZE lines
         for LOCAL variables (that had been converted from DB variables).
         This line skips over that case. [see bug# 97-08-15-018] */
      IF AVAILABLE(_U) AND LOOKUP(token[1],"LABEL,SIZE,VIEW-AS":U) ne 0
      THEN NEXT Frame-Block.

      /* Find the _U record for this option. The line is of the form:
           db.table.name, table.name, or name. */
   
      CASE NUM-ENTRIES(token[1], ".":U):   
        WHEN 1 THEN DO:
          ASSIGN c_name   = token[1]
                 c_table  = ?
                 c_dbname = ? .  
          FIND FIRST _U WHERE _U._p-recid eq p_proc-id
                          AND _U._TABLE eq c_table
                          AND _U._NAME  eq c_name 
                        NO-ERROR. 
        END.
        WHEN 2 THEN DO:
          ASSIGN c_name   = ENTRY(2, token[1], ".":U)
                 c_table  = ENTRY(1, token[1], ".":U)
                 c_dbname = ? .
          FIND FIRST _U WHERE _U._p-recid eq p_proc-id
                          AND _U._TABLE eq c_table
                          AND _U._NAME  eq c_name 
                        NO-ERROR. 
        END.
        OTHERWISE DO:
          ASSIGN c_name   = ENTRY(3, token[1], ".":U)
                 c_table  = ENTRY(2, token[1], ".":U)
                 c_dbname = ENTRY(1, token[1], ".":U) .
          FIND FIRST _U WHERE _U._p-recid eq p_proc-id
                          AND _U._DBNAME eq c_dbname
                          AND _U._TABLE  eq c_table
                          AND _U._NAME   eq c_name 
                        NO-ERROR. 
        END.
      END CASE.         
      /* Find the relevant _U and _F records, or create them. */
      IF AVAILABLE _U THEN DO:
        /* The record has already been defined, so just associate it with the frame */  
        FIND _F WHERE RECID(_F) eq _U._x-recid.
        _U._parent-recid = RECID(frm_U).
      END.     
      ELSE DO:  
        /* The variable is brand new. It is either a database field or a user variable. 
           Assume a DB field. User-defined fields are noted in the RUN-TIME-SETTINGS. */
        CREATE _U.  
        CREATE _F.
        ASSIGN
          /* Create links between objects. */
          _U._P-recid      = p_Proc-ID
          _U._x-recid      = RECID(_F)
          _U._parent-recid = RECID(frm_U) 
          /* Standard Attibutes. */ 
          _U._NAME         = c_name
          _U._TABLE        = c_table
          _U._DBNAME       = c_dbname  
          _U._DEFINED-BY   = "DB":U
          . 
        /* Set this up as a database field.  NOTE: At one time I had a
           check here for:
              IF NOT l_dbok THEN _U._defined-by = "User":U.
           However, this turned all DB fields into user defined when the
           user did not have a database connected.  Now the "USER" setting
           is done in Run-Time settings. */
        RUN workshop/_chkdtf.p 
           (RECID(_U), _U._DBNAME, _U._TABLE, _U._NAME, "DB":U, OUTPUT l_dbok).  
      
        /* Go though the rest of the token string storing items */  
        RUN read-var-attributes (INPUT 2).      

        /* See if the line ends with ".".  This indicates the end of
           the frame definition. */
        cnt = LENGTH(RIGHT-TRIM(aline), "CHARACTER":U).
        IF cnt > 0 AND SUBSTRING(aline, cnt, 1, "CHARACTER":U) eq ".":U 
        THEN LEAVE Frame-Block. 
        
      END. /* IF [not] AVAILABLE _U... */  

    END. /* IF [not]...WITH... */  
    
  END. /* Frame-Block: REPEAT... */
         
END PROCEDURE.   

/* ---------------------------------------------------------------------
   Description: Reads the DEFINE VARIABLE... statement.   
   Parameters:  p_start -- the first token to process.
   Globals: This uses and sets the current token array starting at the
            p_start token. It relies on, and sets attributes in, 
            the current _U and _F record .
------------------------------------------------------------------------*/ 
PROCEDURE read-var-attributes :    
  DEFINE INPUT PARAMETER p_start AS INTEGER NO-UNDO.

  DEF VAR i   AS INTEGER NO-UNDO.
  DEF VAR len AS INTEGER NO-UNDO.
  
  i = p_start. 
  Def-Line:
  DO WHILE i <= {&MAX-TOKENS} AND token[i] ne "":U:  
    CASE token[i]:
      WHEN "INITIAL":U  THEN DO:
        ASSIGN i = i + 1
               _F._initial = token[i].
      END.
      WHEN "FORMAT":U   THEN DO:
        ASSIGN i = i + 1
               _F._FORMAT = token[i].    
        IF token[i + 1] BEGINS ":":U  /* eg. an string attribute. */
        THEN ASSIGN i = i + 1
                    _F._FORMAT-ATTR = LEFT-TRIM(token[i], ":":U).   
      END. 
      WHEN "VIEW-AS":U  THEN DO:  
        aline = SUBSTRING(aline, 
                          1 + INDEX(aline, " VIEW-AS ":U),
                          -1, 
                          "CHARACTER":U).
        LEAVE Def-Line.
      END.
    END CASE.
    /* Get the next token. */
    i = i + 1.
  END. /* Def-Line: DO i... */  
  View-As-Section:  
  REPEAT:               
    aline = TRIM(aline).
    
    /* Process the VIEW-AS phrase. */
    IF aline BEGINS "VIEW-AS":U THEN DO:
       RUN read-view-as. 
       LEAVE View-As-Section.
    END.
    /* We are done processing the line if it ends in a period. */ 
    len = LENGTH(aline, "CHARACTER":U).
    IF len > 0 AND SUBSTRING(aline, len, 1, "CHARACTER":U) eq ".":U
    THEN LEAVE View-As-Section.
    
    /* Get the next line. */
    aline = "".
    IMPORT STREAM _P_QS UNFORMATTED aline. {&debug} 
  END. /* VIEW-AS block. */
  
END PROCEDURE.


/* ---------------------------------------------------------------------
   Description: Reads the VIEW-AS phrase 
   Globals: This uses and sets the aline variable and sets fields in the
            current _U and _F records.
  ------------------------------------------------------------------------*/ 
PROCEDURE read-view-as :   
  DEF VAR i AS INTEGER NO-UNDO.
  /* Parse lines of the form:
   *   VIEW-AS type option-1 option2 SIZE n BY z NO-UNDO. 
   */ 
  /* Break the line into tokens. */
  RUN tokenize(aline, "":U).
  _U._TYPE = token[2].  
  /* Start processing at token 3. */
  ASSIGN i = 3. 
  View-As-Block:
  REPEAT:   
    DO WHILE i <= {&MAX-TOKENS} AND token[i] ne "":U:   
      CASE token[i]:
        /* Stop processing on the UNDO. */
        WHEN "NO-UNDO.":U OR WHEN "NO-UNDO":U THEN LEAVE View-As-Block. 
        
        /* Read simple attributes. */
        WHEN "MULTIPLE":U   THEN _F._MULTIPLE  = yes.
        WHEN "SINGLE":U     THEN _F._MULTIPLE  = no.
        WHEN "SORT":U       THEN _F._SORT      = yes.
        WHEN "WORD-WRAP":U  THEN _F._WORD-WRAP = yes.       
        
        /* Read more complex attributes. */
        WHEN "LIST-ITEMS":U    THEN DO: 
          /* Read tokens until the end of the line, or until there is a
             token without a comma. */ 
          ASSIGN i = i + 1
                 _F._LIST-ITEMS = token[i].
          DO WHILE i <= {&MAX-TOKENS} AND token[i + 1] eq ",":U :
            ASSIGN i = i + 2
                   _F._LIST-ITEMS = _F._LIST-ITEMS + CHR(10) + token[i]. 
          END.
        END. /* WHEN list-items... */
        
        WHEN "RADIO-BUTTONS":U THEN DO:    
          /* Read the following lines until we get to the size. */
          Radio-Button-Block:   
          REPEAT:          
             /* Get the next line. */
             aline = "".
             IMPORT STREAM _P_QS UNFORMATTED aline. {&debug}  
             aline = TRIM(aline).
             IF aline BEGINS '"':U 
             THEN _F._LIST-ITEMS = _F._LIST-ITEMS + CHR(10) + aline.    
             /* Does the line end with a comma? */
             IF SUBSTRING(aline, LENGTH(aline, "CHARACTER":U), 1, "CHARACTER":U)
                ne ",":U
             THEN DO:
               /* Remove the leading CHR(10) and stop reading radio-buttons */
               ASSIGN _F._LIST-ITEMS = TRIM(_F._LIST-ITEMS).  
               LEAVE Radio-Button-Block.     
             END.
          END. /* Radio-Button-Block... */
        END. /* WHEN radio-buttons... */   
        
        /* Read size */
        WHEN "SIZE":U          THEN DO:
          _F._WIDTH  = INTEGER(token[i + 1]) NO-ERROR.
          _F._HEIGHT = INTEGER(token[i + 3]) NO-ERROR.
          LEAVE View-As-Block.
        END.
     
      END CASE.
      /* Get the next token. */
      i = i + 1.
    END. /* DO i... */  
    
    /* Get the next line and start processing at the first token. */
    ASSIGN i     = 1  
           aline = "".
    IMPORT STREAM _P_QS UNFORMATTED aline. {&debug}  
    RUN tokenize(aline, "":U). 
     
  END. /* View-As-Block: REPEAT... */
      
END PROCEDURE.



/* *************************  Standard procedures ********************** */
{ workshop/util4gl.i }
{ workshop/rdproc.i }
