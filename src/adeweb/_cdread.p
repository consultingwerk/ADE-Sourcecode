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

File: _cdread.p

Description:     Reads a structured WDT_v2 code file (usually a .w file).

Input Parameters:
    p_proc-id  - Procedure Context ID for the relevent _P record
    p_mode     - Import Mode (WINDOW, or WINDOW UNTITLED)
    p_orig-ver - the original version number of the input file
    p_options  - A comma-delimited list of options [currently unused]

Notes:
  Uses the shared _P_QS code stream, since we're reading from a .tmp, not .qs file.
  
Author: Wm. T. Wood
Created: January 1996
Updated: 12/23/96 wood  Created from the old adeuib/_cdsuckr.p
         02/02/98 adams Adapted for Skywalker 9.0a to populate _TRG table.
         12/21/99 adams Support for V2 Function blocks
---------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER p_tempFile    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_proc-id     AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER p_mode        AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_orig-ver    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_options     AS CHARACTER NO-UNDO.

/* Shared Include File definitions */
{ adeuib/sharvars.i }    /* Shared variables                               */
{ adeuib/triggers.i }    /* _TRG temp-table                                */
{ adeuib/uniwidg.i }     /* Universal Widget TEMP-TABLE definition         */
{ adeuib/layout.i } 

DEFINE NEW SHARED STREAM _P_QS.
DEFINE NEW SHARED VARIABLE _a_line    AS CHARACTER NO-UNDO.
DEFINE NEW SHARED VARIABLE _inp_line  AS CHARACTER NO-UNDO EXTENT 100.
DEFINE     SHARED VARIABLE def_found  AS LOGICAL   NO-UNDO.           
DEFINE     SHARED VARIABLE main_found AS LOGICAL   NO-UNDO.           

/* Local definitions. */
DEFINE VARIABLE c_name         AS CHARACTER NO-UNDO.
DEFINE VARIABLE iCounter       AS INTEGER   NO-UNDO.

&SCOPED-DEFINE debug FALSE
&SCOPED-DEFINE MAX-TOKENS 15

DEFINE VARIABLE token              AS CHARACTER EXTENT {&MAX-TOKENS} NO-UNDO.

/* -------------------------- Main Code Block --------------------------- */
/* Find the relevant record. */
FIND _P WHERE RECID(_P) eq p_proc-id.

INPUT STREAM _P_QS FROM VALUE(p_tempFile) {&NO-MAP}.

RUN read-structured-file.

/* Special Cases -- if we have read an old file in, clean it up. */
IF p_orig-ver BEGINS "WDT_v1":U THEN /* Set it to compile-on-save. */
  _P._compile = yes.
  
/* Special Cases -- Remove sections that will be automatically added
   when the file is written out. These are the RUN-TIME-SETTINGS and
   query rebuild sections. */
FOR EACH _TRG WHERE _TRG._pRECID eq p_proc-id
                AND _TRG._tSECTION eq "_DELETE-ON-LOAD":U:  
  /* RUN adeweb/_del_cd.p (RECID(_TRG)). */
  DELETE _TRG.
END.

INPUT STREAM _P_QS CLOSE.
RETURN.
  
/*
 * ------------------------ Internal Procedures ------------------------- 
 */
      
/* -----------------------------------------------------------------------
   Description: look at the type of code block and decide how to hande it.  
   Parameter: p_part -- this will be set to FOOTER if the routine does
                        the reading of the body of the trigger.
            
   Notes: The array, token[], is assumed to be pointing to a line
          starting with "&ANALYZE-SUSPEND _[UIB-]CODE-BLOCK ... "     
  ------------------------------------------------------------------------*/ 
PROCEDURE process-code-block  :     
  DEFINE INPUT-OUTPUT PARAMETER p_part AS CHARACTER NO-UNDO.

  CASE token[3]:
    WHEN "_CUSTOM":U THEN DO:
      CASE token[4]:
        WHEN "Definitions":U THEN
          ASSIGN
            def_found  = TRUE
            token[4]   = "_DEFINITIONS":U.
        WHEN "Main Code Block":U THEN
          ASSIGN
            main_found = TRUE
            token[4]   = "_MAIN-BLOCK":U.
      END CASE.
      
      ASSIGN _TRG._tSECTION = token[3]
             _TRG._tEVENT   = token[4]
             _TRG._tSPECIAL = token[5]
             _TRG._wRECID   = _P._u-recid
             .
    END.
    
    /* Internal Procedure or Function Section -- for example:
     * &ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE htm-offsets _WEB-HTM-OFFSETS 
     * or
     * &ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION get-value */
    WHEN "_PROCEDURE":U OR WHEN "_FUNCTION":U THEN DO:
       ASSIGN _TRG._tSECTION = token[3]
              _TRG._tEVENT   = token[4]
              _TRG._tSPECIAL = token[5].
      
      IF _TRG._tSPECIAL eq "_WEB-HTM-OFFSETS":U THEN DO:     
        RUN adeweb/_rdoffp.p (p_proc-id). 
        ASSIGN
          _TRG._tCODE = ?
          p_part      = "footer":U. /* The read routine reads to the footer. */
      END.
    END. /* &ANALYZE-SUSPEND _CODE_BLOCK _PROCEDURE/_FUNCTION ... */
 
    WHEN "_CONTROL":U THEN DO:
      /* This is of the form: 
         &ANALYZE-SUSPEND _CODE-BLOCK _CONTROL widget
         PROCEDURE widget.INPUT .  */ 
      ASSIGN 
        _TRG._tSECTION = token[3]
        _TRG._tEVENT   = token[5] 
        _TRG._tSPECIAL = token[6]. /* Is there a special handler?*/
        
      /* Associate the widget name with the related object in WebSpeed files.
         If there is no widget, then delete the code block. */
      c_name = token[4].
      IF NUM-ENTRIES(c_name,".":U) = 1 THEN
        FIND FIRST _U WHERE _U._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                        AND _U._NAME          eq c_name   
                        AND _U._TABLE         eq ?
                        AND LOOKUP(_U._TYPE, "FRAME,QUERY":U) eq 0 NO-ERROR.
      ELSE IF NUM-ENTRIES(c_name,".":U) = 2 THEN
        FIND FIRST _U WHERE _U._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                        AND _U._NAME          eq ENTRY(2,c_name,".":U)
                        AND _U._TABLE         eq ENTRY(1,c_name,".":U)
                        AND LOOKUP(_U._TYPE, "FRAME,QUERY":U) eq 0 NO-ERROR.
      ELSE IF NUM-ENTRIES(c_name,".":U) = 3 THEN
        FIND FIRST _U WHERE _U._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                        AND _U._NAME          eq ENTRY(3,c_name,".":U)
                        AND _U._TABLE         eq ENTRY(2,c_name,".":U)
                        AND _U._DBNAME        eq ENTRY(1,c_name,".":U)  
                        AND LOOKUP(_U._TYPE, "FRAME,QUERY":U) eq 0 NO-ERROR.
      /* Make sure we have a real object. If so, get the name of the event. */ 
      IF NOT AVAILABLE (_U) THEN 
        _TRG._tSECTION = "_DELETE-ON-LOAD":U.
      ELSE DO:  
        /* Link code to object. */
        _TRG._wRECID = RECID(_U).
        /* Read the next line (of the form): PROCEDURE xxy.INPUT . */
        _inp_line = "".
        IMPORT STREAM _P_QS _inp_line.
        /* Make sure the user didn't edit the file and move the
          end of line closer to the procedure name. */
        _inp_line[2] = RIGHT-TRIM(_inp_line[2], ":.":U).
        IF (_inp_line[1] = "PROCEDURE":U AND 
          NUM-ENTRIES(_inp_line[2], ".":U) > 1) THEN
          /* Make all pseudo events LOWER-CASE, new for v2.0 (wood) */
          _TRG._tEVENT = "web.":U + 
                        LC(ENTRY(NUM-ENTRIES(_inp_line[2], ".":U),
                                            _inp_line[2], ".":U)).  
        ELSE _TRG._tEVENT = "UNKNOWN":U.    
      END. /* IF [available] _U... */      
    END. /* &ANALYZE-SUSPEND _CODE_BLOCK _CONTROL ... */
    
    OTHERWISE
        ASSIGN _TRG._tSECTION = token[3]
               _TRG._tEVENT   = token[4].
  END CASE. /* ENTRY (2... */

END PROCEDURE.

/* ---------------------------------------------------------------------
   Description: Read the file and store it in code sections.
------------------------------------------------------------------------*/ 
PROCEDURE read-structured-file :  
  DEFINE VARIABLE ch-cnt  AS INTEGER           NO-UNDO.
  DEFINE VARIABLE ln-cnt  AS INTEGER           NO-UNDO.
  DEFINE VARIABLE part    AS CHARACTER         NO-UNDO.
  DEFINE VARIABLE prev-id AS RECID             NO-UNDO.
  DEFINE VARIABLE txt     AS CHARACTER         NO-UNDO.

  CREATE _TRG.
  ASSIGN iCounter     = iCounter + 1
         _TRG._pRECID = RECID(_P) 
         _TRG._wRECID = _P._u-recid
         _TRG._seq    = iCounter
         part         = "header":U.

  Read-Loop:
  REPEAT ON END-KEY UNDO Read-Loop, LEAVE Read-Loop: 
    
    /* Read the next line */
    _a_line = "".
    IMPORT STREAM _P_QS UNFORMATTED _a_line.
    
    /* Watch for lines that have just a "?" */
    IF _a_line eq ? THEN _a_line = "?":U.
    
    /* Look for special items. */
    IF _a_line BEGINS "&ANALYZE-SUSPEND":U THEN DO:
      IF part ne "header":U THEN DO:
        /* Store the existing code. */
        IF part eq "code":U THEN 
          ASSIGN
            _TRG._tCODE = txt
            txt         = "":U
            ch-cnt      = 0
            ln-cnt      = 0.
      
        /* Create new _TRG for the next section. */
        CREATE _TRG.
        ASSIGN iCounter          = iCounter + 1
               _TRG._pRECID      = RECID(_P) 
               _TRG._wRECID      = _P._u-recid
               _TRG._seq         = iCounter.          
      END. /* IF part ne "header":U */
      
      /* Finish the analyser section. */
      ASSIGN txt          = "":U
             ch-cnt       = 0
             ln-cnt       = 0
             part         = "code":U.
      /* Figure out the name and type of the section. Use HTML because this
         was writen with &quot; in place of quotes (") within strings. */
      RUN tokenize (_a_line, "HTML":U).
      
      CASE token[2]:
        /* User Editable Code Blocks. */
        WHEN "_CODE-BLOCK":U OR 
        WHEN "_UIB-CODE-BLOCK":U THEN   
          RUN process-code-block (INPUT-OUTPUT part).
 
        /* Create Window -- This only exists in outdated (v1) files.  It will be
           removed when the file is written out. */
        WHEN "_CREATE-WINDOW":U THEN 
          ASSIGN _TRG._tSECTION = "_HIDDEN":U
                 _TRG._tSPECIAL = token[2]
                 _TRG._tEVENT   = token[2].
        
        /* Parse the definitions. */
        WHEN "_FORM-BUFFER" THEN DO:   
          ASSIGN _TRG._tSECTION = "_APPBUILDER":U
                 _TRG._tSPECIAL = token[2]
                 _TRG._tEVENT   = token[2]. 
          RUN adeweb/_rddefs.p (p_proc-id, p_orig-ver, "":U).   
          part = "footer":U. /* The read routine reads to the footer. */
        END.   
        
        WHEN "_INCLUDED-LIBRARIES":U THEN
          ASSIGN _TRG._tSECTION = "_CUSTOM":U
                 _TRG._tSPECIAL = token[2] 
                 _TRG._tEVENT   = token[2].
        
        /* Preprocessor section (v1 files call this the UIB-PREPROCESSOR-BLOCK) */
        WHEN "_PREPROCESSOR-BLOCK":U OR
        WHEN "_UIB-PREPROCESSOR-BLOCK":U THEN DO:
          ASSIGN _TRG._tSECTION = "_HIDDEN":U
                 _TRG._tSPECIAL = "_PREPROCESSOR-BLOCK":U
                 _TRG._tEVENT   = "_PREPROCESSOR-BLOCK":U.

          RUN read-preprocessor-block. 
          part = "footer":U. /* The read routine reads to the footer. */  
        END.      
 
        /* Procedure Settings Section . */
        WHEN "_PROCEDURE-SETTINGS":U  THEN DO:
          ASSIGN _TRG._tSECTION = "_APPBUILDER":U
                 _TRG._tSPECIAL = token[2]
                 _TRG._tEVENT   = "Procedure Settings":U.
          /* Read in the section. */
          RUN adeweb/_rdproc.p (p_proc-id, p_mode).  
          part = "footer":U. /* The read routine reads to the footer. */
        END.
  
        /* Read Query rebuild information. 
           (e.g. &ANALYZE-SUSPEND _QUERY-BLOCK QUERY Web-Query) */
        WHEN "_QUERY-BLOCK":U THEN DO:  
          /* This will be deleted at end of read. */
          ASSIGN _TRG._tSECTION = "_DELETE-ON-LOAD":U 
                 _TRG._tSPECIAL = token[2]
                 _TRG._tEVENT   = token[4]. 
          RUN adeweb/_rdqury.p (p_proc-id, token[4], p_orig-ver, "":U /* Options */ ).       
          part = "footer":U. /* The read routine reads to the footer. */
        END.   
        
        /* Run-time settings */
        WHEN "_RUN-TIME-ATTRIBUTES":U THEN DO:   
          /* This will be deleted at end of read. */
          ASSIGN _TRG._tSECTION = "_DELETE-ON-LOAD":U
                 _TRG._tSPECIAL = token[2]
                 _TRG._tEVENT   = token[2].                
          RUN adeweb/_readrt.p (p_proc-id, p_mode, p_orig-ver).
          part = "footer":U. /* The read routine reads to the footer. */
        END.   
        
        /* Version number: 
           &ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Web-Object [Template] */
        WHEN "_VERSION-NUMBER":U THEN DO:
          ASSIGN _TRG._tSECTION = "_HIDDEN":U
                 _TRG._tSPECIAL = token[2]
                 _TRG._tEVENT   = token[2].    
         /* Read other items from the template line. */
         IF token[4] ne "":U THEN 
           _P._TYPE = token[4].
         IF token[5] eq "Template":U AND p_mode eq "WINDOW":U THEN 
           _P._template = yes.
         RUN read-version-number. 
         part = "footer":U. /* The read routine reads to the footer. */
        END.
        
        OTHERWISE DO:
          /* Special case. We don't know what to do with it, so make it hidden. */
          ASSIGN _TRG._tSECTION = "_HIDDEN":U
                 _TRG._tEVENT   = _a_line.
        END. 
      END CASE. /* ENTRY (1... */
       
      &if {&debug} &then
      message "[_cdread.p]" skip
        "Reading" _TRG._tEVENT "[" token[2] ":" token[3] ":" token[4] ":" token[5] "]"
        view-as alert-box.
      &endif

    END. /* IF...ANALYZE-SUSPEND... */
    ELSE DO:
    
      /* Is the code section getting too big. */
      IF part eq "Code":U THEN DO:
        /* Have we got the footer. */  
        IF _a_line BEGINS "&ANALYZE-RESUME":U OR
           _a_line BEGINS "/* _UIB-":U THEN /* Used in WDT_v1r1 & UIB */
          ASSIGN _TRG._tCODE = txt
                 txt         = _a_line
                 ch-cnt      = LENGTH(_a_line, "CHARACTER":U) 
                 ln-cnt      = 1
                 part        = "footer":U.
        ELSE DO:
          ASSIGN ch-cnt = ch-cnt + LENGTH(_a_line, "CHARACTER":U)
                 ln-cnt = ln-cnt + 1.
          IF ch-cnt > 20000 THEN
            ASSIGN _TRG._tCODE = txt
                   txt         = _a_line
                   ch-cnt      = LENGTH(_a_line, "CHARACTER":U)
                   ln-cnt      = 1.
          ELSE IF TRIM(_a_line) BEGINS "FUNCTION":U THEN
            ASSIGN 
              /* Throw away extra "FUNCTION [name]" text */
              _a_line = SUBSTRING(_a_line, 10, -1, "character":U)
              _a_line = REPLACE(_a_line, _trg._tevent, "")
              txt     = txt + TRIM(_a_line) + CHR(10).
          ELSE IF NOT TRIM(_a_line) BEGINS "PROCEDURE":U OR 
            /* Accept PROCEDURE blocks inside the DEFINITIONS section.  These
               might be EXTERNAL type and must be coded here. */
            (TRIM(_a_line) BEGINS "PROCEDURE":U AND 
             _TRG._tEVENT = "_DEFINITIONS":U) THEN DO:
            ASSIGN txt = txt + _a_line + CHR(10).
          END.
        END.
      END. /* IF part eq "Code... */
    END. /* IF...<not>...ANALYZE-SUSPEND... */
  END. /* Read-Loop */
  /* Add in the last line, if necessary. */
  IF _a_line ne "":U THEN 
    txt = txt + _a_line + CHR(10).
  IF txt ne "":U AND part = "Code":U THEN 
    _TRG._tCODE = txt.
    
END PROCEDURE.

/* ----------------------------------------------------------------------------
   Read-Preprocessor-Block -
      Read in the top version number section.
   --------------------------------------------------------------------------- */
PROCEDURE Read-Preprocessor-Block :    
  DEFINE VARIABLE lDone AS LOGICAL NO-UNDO.
  
  /* We are in the Preprocessor section.  Parse it. */   
  REPEAT WHILE NOT lDone:
    _inp_line = "".
    IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].     

    /* Is the WEB-FILE defined? */
    IF _inp_line[1] BEGINS "&Scoped-define WEB-FILE ":U THEN
      _P._html-file = TRIM(SUBSTRING(_inp_line[1], 24, -1, "CHARACTER":U)). 

    /* Does this list the custom settings */
    ELSE IF _inp_line[1] BEGINS "/* Custom List Definitions ":U THEN DO:
      IMPORT STREAM _P_QS _inp_line.
      /* If the next line is not a comment, then we have an older version
         of the .w file.  This is our "tag" so that we know we can read in
         the names of the lists */
      IF _inp_line[1] eq "/*":U THEN DO:
        /* Check the length of the list for errors */
        IF NUM-ENTRIES(_inp_line[2]) eq {&MaxUserLists} THEN
          _P._LISTS = _inp_line[2].
      END.
      lDone = YES.  /* Nothing else to read here */
    END.  
    ELSE lDone = _inp_line[1] BEGINS "&ANALYZE-RESUME":U OR
                _inp_line[1] BEGINS "/* _UIB-PREPROCESSOR-BLOCK-END":U.
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
          IF p_mode eq "WINDOW":U THEN ASSIGN _P._desc = descrpt .
        END. 
      END. /* WHEN comment... */
      
      OTHERWISE NEXT Read-Loop.
  
    END CASE.  
  END. /* Read-Loop */
END PROCEDURE.            

/* Standard procedures. */
{ adeweb/util4gl.i }
{ adeweb/rdproc.i }

/* _cdread.p - end of file */
