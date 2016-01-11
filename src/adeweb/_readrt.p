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

File: _readrt.p

Description:
    Reads a _RUN-TIME-SETTINGS section of a web-object.

Input Parameters:
    p_proc-id  - Procedure Context ID for the relevent _P record.
    p_orig-ver - the original version number of the input file.
    p_options  - A comma-delimited list of options [currently unused]
 
Notes:
  Uses the default _P_QS code stream
  
Author:  Wm. T. Wood
Created: 02/97
Updated: 02/13/98 adams Modified for Skywalker
         10/25/00 adams Support for V2 user fields
         04/26/01 jep   IZ 993 - Check Syntax support for local WebSpeed V2 files.
                        Added _L._LO-NAME = "Master Layout" assignment.

---------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER p_proc-id    AS INTEGER    NO-UNDO.
DEFINE INPUT  PARAMETER p_orig-ver   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER p_options    AS CHARACTER  NO-UNDO.

/* Shared Include File definitions */
{ adeuib/sharvars.i } /* Shared variables                       */
{ adeuib/uniwidg.i }  /* Universal Widget TEMP-TABLE definition */
{ adeuib/layout.i } 

/* Shared file-io parameters from the caller. */
DEFINE SHARED VARIABLE _a_line   AS CHARACTER  NO-UNDO.
DEFINE SHARED VARIABLE _inp_line AS CHARACTER  NO-UNDO EXTENT 100.
DEFINE SHARED STREAM _P_QS.

DEFINE VARIABLE cName       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cType       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE frame-nam   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE frame-recid AS RECID      NO-UNDO.
DEFINE VARIABLE ix          AS INTEGER    NO-UNDO.
DEFINE VARIABLE jx          AS INTEGER    NO-UNDO.
DEFINE VARIABLE settings    AS CHARACTER  NO-UNDO.

DEFINE BUFFER frm_U FOR _U. /* frame object */

FIND _P WHERE RECID(_P) eq p_proc-id.
  
Run-Time-Block:
REPEAT:
  ASSIGN
    _inp_line = ""
    cName     = ""
    cType     = "".
    
  IMPORT STREAM _P_QS _inp_line.

  /* Exit condition. This is the &ANALYZE-RESUME line */
  IF _inp_line[1] eq "&ANALYZE-RESUME":U THEN
    LEAVE Run-Time-Block.
  
  /* Catch a SETTINGS FOR widget... */            
  ELSE IF _inp_line[1] = "/*":U AND _inp_line[2] = "SETTINGS":U
                                AND _inp_line[3] = "FOR":U THEN DO:
    IF _inp_line[4] ne "WINDOW":U THEN DO:
      /* Get the frame name of the widget. The line will either be:
            SETTINGS FOR FRAME xxx
         or
            SETTINGS FOR xyz IN FRAME xxx
       */
      frame-nam = IF _inp_line[4] eq "FRAME":U
                  THEN _inp_line[5] ELSE _inp_line[8].
      FIND _U WHERE _U._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                AND _U._TYPE          eq "FRAME":U
                AND _U._NAME          eq frame-nam.
      frame-recid = RECID(_U).
      
      CASE NUM-ENTRIES(_inp_line[5],".":U):
        WHEN 1 THEN DO:
          FIND _U WHERE _U._parent-recid eq frame-recid
                    AND _U._NAME         eq _inp_line[5]
                    AND _U._TYPE         eq _inp_line[4] NO-ERROR.
          IF NOT AVAILABLE _U THEN
            FIND _U WHERE _U._parent-recid eq frame-recid
                      AND _U._NAME         eq _inp_line[5] 
                      AND _U._TABLE        eq ?
                      AND _U._DBNAME       eq ?
                      AND _U._TYPE         eq _inp_line[4] NO-ERROR.
        END.
        WHEN 2 THEN
          FIND _U WHERE _U._parent-recid eq frame-recid
                    AND _U._NAME         eq ENTRY(2,_inp_line[5],".":U) 
                    AND _U._TABLE        eq ENTRY(1,_inp_line[5],".":U) 
                    AND _U._TYPE         eq _inp_line[4] NO-ERROR.
                    
        WHEN 3 THEN
          FIND _U WHERE _U._parent-recid eq frame-recid
                    AND _U._NAME         eq ENTRY(3,_inp_line[5],".":U) 
                    AND _U._TABLE        eq ENTRY(2,_inp_line[5],".":U) 
                    AND _U._DBNAME       eq ENTRY(1,_inp_line[5],".":U) 
                    AND _U._TYPE         eq _inp_line[4] NO-ERROR.
      END CASE.
    END. /*IF...ne "WINDOW" THEN DO:...*/
    
    ELSE
      /* WDT_v1r1: Settings used to exist on the Design time window.
         Just ignore WINDOW sections in WebSpeed v2 and above */     
      NEXT Run-Time-Block.
         
    /* This line checks the compile time preprocessor variables to ensure that 
       we are looking for all the possible User-List preprocessor variables.  
       Currently this is set to 6.  */
    &IF {&MaxUserLists} > 6 &THEN
    &MESSAGE [_qssuckr.p] *** FIX NOW *** User list can have unexpected value (wood)
    &ENDIF

    /* This is a new, possibly user-defined variable. We need to grab the field
       name and type now, since we are about to read the next line and will lose
       this information. */
    IF NOT AVAILABLE _U AND NUM-ENTRIES(_inp_line[5],".":U) = 1 AND
      _inp_line[4] NE "WINDOW":U THEN
      ASSIGN
        cName = _inp_line[5]
        cType = _inp_line[4].

    _inp_line = "".
    IMPORT STREAM _P_QS _inp_line.
    ASSIGN ix        = 1
           settings = "".
           
    /* This is a new, possibly user-defined variable. */
    IF cName <> "" THEN DO:
      CREATE _U.  
      CREATE _F.
      CREATE _L.
      ASSIGN
        /* Create links between objects. */
        _U._WINDOW-HANDLE = _h_win
        _U._x-recid       = RECID(_F)
        _U._lo-recid      = RECID(_L)
        _U._parent-recid  = frame-recid
        _L._u-recid       = RECID(_U)
        _L._lo-name       = "Master Layout"
        _L._WIN-TYPE      = _cur_win_type
        _U._WIN-TYPE      = _cur_win_type
       
        /* Standard Attributes. */ 
        _U._NAME          = cName
        _U._TABLE         = ?
        _U._DBNAME        = ?
        _U._DEFINED-BY    = "USER":U
        _U._TYPE          = cType
        . 
      /* Create a field-level widget. */
      FIND frm_U WHERE RECID(frm_U) = frame-recid.
      CREATE TEXT _U._HANDLE ASSIGN
        FRAME = frm_U._HANDLE.
    END.
              
    DO WHILE _inp_line[ix] NE "*/":
      /* Look for simple integers that indicate an element of the User-List.  
         Otherwise append the item at the end of settings. Don't worry about 
         an initial comma because we are going to remove it later. */
      jx = INDEX("123456":U, _inp_line[ix]).
      IF jx ne 0 THEN 
        _U._User-List[ jx ] = TRUE.
      ELSE
        settings = settings + (IF settings eq "":U THEN "" ELSE ",":U) +
                   _inp_line[ix].
      ix = ix + 1.
    END.
                                                        
    /* WDT_v1r1: In WebSpeed 2, there are no run-time settings for frames or
       windows. */
    IF LOOKUP(_U._TYPE, "FRAME,WINDOW":U) eq 0 THEN DO: 
      FIND _F WHERE RECID(_F) = _U._x-recid.
      IF CAN-DO(settings,"DISPLAY":U)    THEN _U._DISPLAY       = TRUE.
      IF CAN-DO(settings,"NO-DISPLAY":U) THEN _U._DISPLAY       = FALSE.
      IF CAN-DO(settings,"NO-ENABLE":U)  THEN _U._ENABLE        = FALSE.
      IF CAN-DO(settings,"USER":U)       THEN _U._DEFINED-BY    = "User":U.
      IF CAN-DO(settings,"EXP-FORMAT":U) THEN _F._FORMAT-SOURCE = "E":U.
      IF CAN-DO(settings,"DEF-FORMAT":U) THEN _F._FORMAT-SOURCE = "D":U.
    END. /* IF LOOKUP(_U._TYPE... */
  END.  /* IF SETTINGS COMMENT */

  ELSE IF _inp_line[1] = "FRAME":U AND _inp_line[3] = "=":U AND
    INDEX(_inp_line[2],":":U) > 0 THEN DO:
    /* WDT_v1r1: In version 2, we don't pay any attention to frame attributes. */
  END.
    
  /* Handle run-time settings of the form:
      name:attribute IN FRAME web-frame = .... */        
  ELSE IF _inp_line[5] = "=":U AND INDEX(_inp_line[1],":":U) > 0 THEN DO:
  
    /* Get the name of the widget and the name of the frame. */
    ASSIGN cName = ENTRY(1,_inp_line[1],":":U).
    IF frame-nam ne _inp_line[4] THEN DO:
      frame-nam = _inp_line[4].
      FIND _U WHERE _U._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                AND _U._TYPE          eq "FRAME":U
                AND _U._NAME          eq frame-nam.
      frame-recid = RECID(_U).
    END.
         
    /* Find the _U record. */  
    IF NUM-ENTRIES(cName,".":U) = 1 THEN
      FIND _U WHERE _U._NAME         eq cName 
                AND _U._TYPE         ne "FRAME":U
                AND _U._parent-recid eq frame-recid NO-ERROR.
    ELSE IF NUM-ENTRIES(cName,".":U) = 2 THEN
      FIND _U WHERE _U._NAME         eq ENTRY(2,cName,".":U)
                AND _U._TABLE        eq ENTRY(1,cName,".":U)
                AND _U._TYPE         ne "FRAME":U
                AND _U._parent-recid eq frame-recid NO-ERROR.
    ELSE IF NUM-ENTRIES(cName,".":U) = 3 THEN
      FIND _U WHERE _U._NAME         eq ENTRY(3,cName,".":U)
                AND _U._TABLE        eq ENTRY(2,cName,".":U)
                AND _U._DBNAME       eq ENTRY(1,cName,".":U)
                AND _U._TYPE         ne "FRAME":U
                AND _U._parent-recid eq frame-recid NO-ERROR.  
    /* Get the associated _F record. */
    FIND _F WHERE RECID(_F) eq _U._x-recid NO-ERROR.
                      
    CASE ENTRY(2,_inp_line[1],":":U):
      WHEN "PRIVATE-DATA":U   THEN RUN read-string(OUTPUT _U._PRIVATE-DATA).
      WHEN "READ-ONLY":U      THEN _F._READ-ONLY = TRUE. 
    END CASE. /* ENTRY(2,_inp_line[1],":") -- ATTRIBUTE */
  END.
END.  /* Run-Time-Block: Repeat block */

RETURN.

/*--------------------------------------------------------------------------*/
/* Reads Private-Data as a string.  That is, we start saving data when we
   get to the first quote.  We ignore any tilde characters, and stop at
   the second quote. */
PROCEDURE read-string:
  DEFINE OUTPUT PARAMETER p_out AS CHAR NO-UNDO.
  DEFINE VARIABLE lin        AS CHAR    NO-UNDO.
  DEFINE VARIABLE ch         AS CHAR    NO-UNDO.
  DEFINE VARIABLE ix         AS INTEGER NO-UNDO.
  DEFINE VARIABLE cnt        AS INTEGER NO-UNDO.
  DEFINE VARIABLE l_inString AS LOGICAL NO-UNDO.

  REPEAT:
    /* Read a line. */
    IMPORT STREAM _P_QS UNFORMATTED lin.
    /* Emergency Test. */
    IF lin BEGINS "&ANALYZE-":U THEN RETURN.
    ASSIGN ix  = 0
           cnt = LENGTH(lin, "CHARACTER":U).
    DO WHILE ix < cnt:
      ASSIGN ix = ix + 1
             ch = SUBSTRING(lin, ix, 1, "CHARACTER":U).
      IF NOT l_inString THEN DO:
        IF ch eq '"':U THEN 
          l_inString = TRUE.
        ELSE if ch ne ' ':U THEN RETURN.  /* The line should start with spaces. */
      END.
      ELSE DO:
        /* In the string.  Look for the next quote. */
        IF ch eq '"':U THEN RETURN.
        ELSE IF ch eq '~~':U THEN DO:
          ix = ix + 1.
          IF ix <= cnt THEN 
            ASSIGN ch    = SUBSTRING(lin, ix, 1, "CHARACTER":U)
                   p_out = p_out + ch.
        END.
        ELSE p_out = p_out + ch.
      END. /* IF...l_inString... */   
    END. /* DO... */
    /* If we get here, we are starting a new line, so add CHR(10) to the
       output string (unless the previous line ended in tilde). */
    IF l_inString AND ch ne '~~':U THEN 
      p_out = p_out + CHR(10).
  END. /* REPEAT:... */
END PROCEDURE.

/* _readrt.p - end of file */
