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
Updated: 01/20/98 adams added support for WebSpeed 2.x files to Skywalker
         06/18/99 tsm   changed reference to _F._initial to _F._initial-data
         04/26/01 jep   IZ 993 - Check Syntax support for local WebSpeed V2 files.
                        Added _L._LO-NAME = "Master Layout" assignments and
                        frm_C._TITLE = FALSE assignment.

---------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER p_proc-id    AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER p_orig-ver   AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_options    AS CHARACTER NO-UNDO.

/* Shared Include File definitions */
{ adeuib/sharvars.i }    /* Shared variables                               */
{ adeuib/uniwidg.i }     /* Universal Widget TEMP-TABLE definition         */
{ adeuib/layout.i } 

/* WDT_v1r1: Special variable to catch the V1 Control Definitions. */
DEFINE VARIABLE l_v1CtrlDefs AS LOGICAL NO-UNDO.

DEFINE SHARED STREAM _P_QS.

/* Local Variables */
DEFINE VARIABLE aline  AS CHARACTER NO-UNDO.
&SCOPED-DEFINE MAX-TOKENS 100
DEFINE VARIABLE token  AS CHARACTER NO-UNDO EXTENT {&MAX-TOKENS}.

DEFINE BUFFER frm_C FOR _C.
DEFINE BUFFER frm_L FOR _L.
DEFINE BUFFER frm_Q FOR _Q.
DEFINE BUFFER frm_U FOR _U. /* frame object */
DEFINE BUFFER win_U FOR _U. /* window object */

/* -------------------------- Main Code Block --------------------------- */
FIND _P WHERE RECID(_P) = p_proc-id.
FIND win_U WHERE win_U._HANDLE = _h_win. /* to parent frame _U. */

/* WDT_v1r1: Is this a frame definition from the previous release. */
IF p_orig-ver BEGINS "WDT_v1":U THEN l_v1CtrlDefs = yes.

Process-Definition-Block:
REPEAT:
  /* Read in the lines and loop for DEFINE VARIABLE lines. */
  aline = "".
  IMPORT STREAM _P_QS UNFORMATTED aline. 

  /* Trim the line and look for ones that begin DEF */
  aline = LEFT-TRIM (aline).
  IF aline BEGINS "DEF":U THEN DO:
     IF aline MATCHES "DEF* VAR*":U THEN DO:
       RUN read-def-var.  
     END.
     ELSE IF aline MATCHES "DEF* FRAME *":U THEN DO:
       RUN read-def-frame.   
     END.
  END.
  ELSE IF aline BEGINS "&ANALYZE-RESUME":U THEN 
    LEAVE Process-Definition-Block.
  /* WDT_v1r1: Special checks only for V1 files. */
  ELSE IF l_v1CtrlDefs THEN DO:
    /* Is this a frame definition from the previous release?
       If so, it won't end with an &ANALYZE-RESUME. */
    IF aline BEGINS "/* ":U AND INDEX(aline, " Procedure Settings ":U) > 0 
    THEN LEAVE Process-Definition-Block.
    /* Also in Version 1, Query Definitions are in a simple
       &ANALYZE-SUSPEND...&ANALYZE-RESUME block */
    ELSE IF TRIM(aline) eq "&ANALYZE-SUSPEND":U THEN DO:
      /* Look for the next ANALYZE-RESUME line. */
      IMPORT STREAM _P_QS UNFORMATTED aline. 
      DO WHILE NOT (LEFT-TRIM(aline) BEGINS "&ANALYZE-":U):
        IMPORT STREAM _P_QS UNFORMATTED aline. 
      END.
    END. /* IF...&ANALYZE-SUSPEND... */
  END. /* ...IF l_v1CtrlDefs ... */
END. /* Process-Defintion-Block: REPEAT... */

/* Final check.  Make sure all widgets are assigned to a frame. */  
FOR EACH _U WHERE _U._WINDOW-HANDLE eq _h_win
              AND _U._parent-recid  eq ?
              AND LOOKUP(_U._TYPE, "QUERY,FRAME":U) eq 0: 
  /* Make sure there is a frame _U and frame object. */
  RUN make-frame ("Web-Frame":U).
  /* Put the object in the frame. */
  ASSIGN _U._parent-recid = RECID(frm_U).
END. /* FOR EACH... */

RETURN.

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
  CREATE _L.
  ASSIGN
    /* Create links between objects. */
    _U._WINDOW-HANDLE = _h_win
    _U._x-recid       = RECID(_F)
    _U._lo-recid      = RECID(_L)
    _U._parent-recid  = ?  /* This will be set in the DEFINE FRAME */
    _L._u-recid       = RECID(_U)
    _L._LO-NAME       = "Master Layout"
    _L._WIN-TYPE      = _cur_win_type
    _U._WIN-TYPE      = _cur_win_type
  
    /* Standard Attibutes. */ 
    _U._NAME          = token[3]
    _F._DATA-TYPE     = token[5]
    .

  /* Make sure there is a frame _U and frame object. */
  RUN make-frame ("Web-Frame":U).
  /* Create a field-level widget. */
  CREATE TEXT _U._HANDLE
    ASSIGN FRAME = frm_U._HANDLE.
    
  /* Go through the rest of the token string storing items. */  
  RUN read-var-attributes (6).
END PROCEDURE.

/* ---------------------------------------------------------------------
   Description: Reads the DEFINE FRAME... statement.
   Globals: This uses and sets the aline variable.
  ------------------------------------------------------------------------*/ 
PROCEDURE read-def-frame :   
  DEFINE VARIABLE c_dbname AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_table  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_name   AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE cnt      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE ix       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE l_dbok   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE last-ch  AS CHARACTER NO-UNDO.  

  /* Parse lines of the form:
       DEFINE FRAME name
          ...
          WITH NO-LABELS.  
   */
  RUN tokenize(aline, "":U).   
  
  /* Create the frame record to hold this name (or see if it already
     exists). Remember, the output routine creates multiple form definitions
     if the first one gets longer than 3.5K. */       
  FIND frm_U WHERE frm_U._WINDOW-HANDLE eq _h_win
               AND frm_U._name eq token[3] NO-ERROR.
  /* Make sure there is a frame _U and frame widget. */
  RUN make-frame (token[3]).

  Frame-Block:
  REPEAT:
    /* Read in the lines and loop for variable/field names. */
    aline = "".
    IMPORT STREAM _P_QS UNFORMATTED aline. 

    /* Look for the WITH line. */
    aline = LEFT-TRIM (aline).
    IF aline BEGINS "WITH ":U OR aline BEGINS "&ANALYZE-":U THEN DO:   
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
            IMPORT STREAM _P_QS UNFORMATTED aline. 
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
      /* Find the _U record for this option. The line is of the form:
           db.table.name, table.name, or name. */
   
      CASE NUM-ENTRIES(token[1], ".":U):   
        WHEN 1 THEN
          ASSIGN c_name   = token[1]
                 c_table  = ?
                 c_dbname = ? .  
        WHEN 2 THEN
          ASSIGN c_name   = ENTRY(2, token[1], ".":U)
                 c_table  = ENTRY(1, token[1], ".":U)
                 c_dbname = ? .
        OTHERWISE
          ASSIGN c_name   = ENTRY(3, token[1], ".":U)
                 c_table  = ENTRY(2, token[1], ".":U)
                 c_dbname = ENTRY(1, token[1], ".":U) .
      END CASE.         
      FIND FIRST _U WHERE _U._WINDOW-HANDLE eq _h_win 
                      AND _U._DBNAME        eq c_dbname
                      AND _U._TABLE         eq c_table
                      AND _U._NAME          eq c_name NO-ERROR. 

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
        CREATE _L.
        ASSIGN
          /* Create links between objects. */
          _U._WINDOW-HANDLE = _h_win
          _U._x-recid       = RECID(_F)
          _U._lo-recid      = RECID(_L)
          _U._parent-recid  = RECID(frm_U) 
          _L._u-recid       = RECID(_U)
          _L._LO-NAME       = "Master Layout"
          _L._WIN-TYPE      = _cur_win_type
          _U._WIN-TYPE      = _cur_win_type
          
          /* Standard Attributes. */ 
          _U._NAME          = c_name
          _U._TABLE         = c_table
          _U._DBNAME        = c_dbname  
          _U._DEFINED-BY    = "DB":U
          . 
        /* Create a field-level widget. */
        CREATE TEXT _U._HANDLE
          ASSIGN FRAME = frm_U._HANDLE.
      
        /* Set this up as a database field.  NOTE: At one time I had a
           check here for:
              IF NOT l_dbok THEN _U._defined-by = "User":U.
           However, this turned all DB fields into user-defined when the
           user did not have a database connected.  Now the "USER" setting
           is done in Run-Time settings. */
        RUN adeweb/_chkdtf.p
           (RECID(_U), _U._DBNAME, _U._TABLE, _U._NAME, "DB":U, OUTPUT l_dbok).

        /* Go through the rest of the token string storing items */  
        RUN read-var-attributes (2).      

        /* See if the line ends with ".".  This indicates the end of
           the frame definition. */
        cnt = LENGTH(RIGHT-TRIM(aline), "CHARACTER":U).
        IF cnt > 0 AND SUBSTRING(aline, cnt, 1, "CHARACTER":U) eq ".":U THEN
          LEAVE Frame-Block. 
        
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

  DEFINE VARIABLE ix   AS INTEGER NO-UNDO.
  DEFINE VARIABLE len  AS INTEGER NO-UNDO.
  
  ix = p_start. 
  Def-Line:
  DO WHILE ix <= {&MAX-TOKENS} AND token[ix] ne "":U:  
    CASE token[ix]:
      WHEN "INITIAL":U  THEN
        ASSIGN ix               = ix + 1
               _F._initial-data = token[ix].
      WHEN "FORMAT":U   THEN DO:
        ASSIGN ix         = ix + 1
               _F._FORMAT = token[ix].    
        IF token[ix + 1] BEGINS ":":U THEN /* eg. an string attribute. */
          ASSIGN ix              = ix + 1
                 _F._FORMAT-ATTR = LEFT-TRIM(token[ix], ":":U).   
      END. 
      WHEN "VIEW-AS":U  THEN DO:  
        aline = SUBSTRING(aline, 1 + INDEX(aline, " VIEW-AS ":U), -1,
                          "CHARACTER":U).
        LEAVE Def-Line.
      END.
    END CASE.
    /* Get the next token. */
    ix = ix + 1.
  END. /* Def-Line: DO ix... */  
  
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
    IMPORT STREAM _P_QS UNFORMATTED aline. 
  END. /* VIEW-AS block. */
  
END PROCEDURE.

/* ---------------------------------------------------------------------
   Description: Reads the VIEW-AS phrase 
   Globals: This uses and sets the aline variable and sets fields in the
            current _U, _F, and _L records.
  ------------------------------------------------------------------------*/ 
PROCEDURE read-view-as :   
  DEFINE VARIABLE ix AS INTEGER NO-UNDO.
  
  /* Parse lines of the form:
   *   VIEW-AS type option-1 option2 SIZE n BY z NO-UNDO. 
   */ 
  /* Break the line into tokens. */
  RUN tokenize(aline, "":U).
  _U._TYPE = token[2].  
  /* Start processing at token 3. */
  ASSIGN ix = 3. 
  
  View-As-Block:
  REPEAT:   
    DO WHILE ix <= {&MAX-TOKENS} AND token[ix] ne "":U:   
      CASE token[ix]:
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
          ASSIGN ix             = ix + 1
                 _F._LIST-ITEMS = token[ix].
          DO WHILE ix <= {&MAX-TOKENS} AND token[ix + 1] eq ",":U :
            ASSIGN ix             = ix + 2
                   _F._LIST-ITEMS = _F._LIST-ITEMS + CHR(10) + token[ix]. 
          END.
        END. /* WHEN list-items... */
        
        WHEN "RADIO-BUTTONS":U THEN DO:    
          /* Read the following lines until we get to the size. */
          Radio-Button-Block:   
          REPEAT:          
             /* Get the next line. */
             aline = "".
             IMPORT STREAM _P_QS UNFORMATTED aline. 
             aline = TRIM(aline).
             IF aline BEGINS '"':U THEN
               _F._LIST-ITEMS = _F._LIST-ITEMS + CHR(10) + aline.    
             /* Does the line end with a comma? */
             IF SUBSTRING(aline, LENGTH(aline, "CHARACTER":U), 1, "CHARACTER":U)
               ne ",":U THEN DO:
               /* Remove the leading CHR(10) and stop reading radio-buttons */
               ASSIGN _F._LIST-ITEMS = TRIM(_F._LIST-ITEMS).  
               LEAVE Radio-Button-Block.     
             END.
          END. /* Radio-Button-Block... */
        END. /* WHEN radio-buttons... */   

        WHEN "SKIP":U THEN /* bug 99-03-22-034 */
          LEAVE View-As-Block.

        /* Read size */
        WHEN "SIZE":U THEN DO:
          ASSIGN _L._WIDTH  = INTEGER(token[ix + 1])
                 _L._HEIGHT = INTEGER(token[ix + 3]).
          LEAVE View-As-Block.
        END.
      END CASE.
      /* Get the next token. */
      ix = ix + 1.
    END. /* DO i... */  
    
    /* Get the next line and start processing at the first token. */
    ASSIGN ix    = 1  
           aline = "".
    IMPORT STREAM _P_QS UNFORMATTED aline. 
    RUN tokenize(aline, "":U). 
  END. /* View-As-Block: REPEAT... */
END PROCEDURE.

/* ---------------------------------------------------------------------
   Description: Make a frame, if it doesn't already exist.
   Globals: This creates a frame _U and its associated _L, _C, _Q
  ------------------------------------------------------------------------*/ 
PROCEDURE make-frame :   
  DEFINE INPUT PARAMETER p_name AS CHARACTER NO-UNDO.  
  
  IF NOT AVAILABLE frm_U THEN DO:  
    CREATE frm_L.
    CREATE frm_C.
    CREATE frm_Q.
    CREATE frm_U.
    ASSIGN /* Create links between objects. */
      frm_U._WINDOW-HANDLE = _h_win
      frm_U._parent-recid  = RECID(win_U)
      frm_U._name          = p_name
      frm_U._type          = "FRAME":U
      frm_U._WIN-TYPE      = _cur_win_type
      frm_U._x-recid       = RECID(frm_C)
      frm_U._lo-recid      = RECID(frm_L)
      frm_U._SENSITIVE     = TRUE
      frm_C._q-recid       = RECID(frm_Q)
      frm_L._u-recid       = RECID(frm_U)
      frm_L._LO-NAME       = "Master Layout"
      frm_L._WIN-TYPE      = _cur_win_type
      frm_C._TITLE         = FALSE
      .
      
    /* Create frame widget. */
    CREATE FRAME frm_U._HANDLE
      ASSIGN 
        PARENT   = _h_win
        HIDDEN   = TRUE
        HEIGHT-P = {&ImageSize}
        WIDTH-P  = {&ImageSize}
        .
    _h_frame = frm_U._HANDLE.
  END.   
END PROCEDURE.

/* *************************  Standard procedures ********************** */
{ adeweb/util4gl.i }
{ adeweb/rdproc.i }

/* _rddefs.p - end of file */
