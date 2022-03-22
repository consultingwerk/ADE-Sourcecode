/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/********************************************************************/
/* Encrypted code which is part of this file is subject to the      */
/* Possenet End User Software License Agreement Version 1.0         */
/* (the "License"); you may not use this file except in             */
/* compliance with the License. You may obtain a copy of the        */
/* License at http://www.possenet.org/license.html                  */
/********************************************************************/

/**************************************************************************
    Procedure:  _pwcmpfl.p
    
    Purpose:    Compiles the contents of an editor widget or disk file to
                check its syntax.
                
    Syntax :
    
        RUN adecomm/_pwcmpfl.p   (INPUT  p_Editor       /* Editor handle.   */ ,
                                INPUT  p_Msgs_Output  /* Messages Dest.   */ ,
                                INPUT  p_Comp_File    /* Compile file.    */ ,
                                INPUT  p_Msgs_File    /* Messages file.   */ ,
                                OUTPUT p_Comp_Stopped /* Compile Stopped? */ ).

    Parameters:
    
    p_Editor
        Handle of Editor widget whose contents you want compiled. Pass Unknown
        (?) to bypass Editor widget and procedure will compile the contents of
        p_Comp_File.

    p_Msgs_Output
        String indicating the destination of the compiler messages.
    
            VALUE           COMPILER MESSAGES DESTINATION
            -------------   -------------------------------
            "CMP_KEEP"      File specified by p_Msgs_File.
            "CMP_NOERROR"   ERROR-STATUS handle.
            "" or anything  CURRENT-WINDOW.
                  else
    
    p_Comp_File
        Name of file to compile.  If you pass p_Editor and p_Comp_File, the
        contents of p_Editor are written to p_Comp_File and compiled. If you
        do not pass p_Editor, contents of p_Comp_File are compiled directly.
                    
        If you do not pass p_Comp_File (ie, pass Null ""), this routine
        generates a standard temp file name to use. When this routine generates
        the p_Comp_File, it also deletes it before returning. If you pass
        p_Comp_File, the file is NOT deleted. That's left as your job.
                    
    p_Msgs_File 
        If you do not pass p_Msgs_File (ie, Null ""), this routine generates
        a standard temp file name to use. When this routine generates the
        p_Msgs_File, it also deletes it before returning.  If you pass
        p_Msgs_File, the file is NOT deleted.  That's left as your job.
    
    p_Comp_Stopped
        TRUE if, for any reason, the compilation was halted. Examples: User
        pressed STOP (Ctrl-C) at any time, the file to compile could not be
        found.  FALSE if PROGRESS got through the COMPILE statement successfully.
    
    Description:
        Returns a TRUE value if the compilation was stopped (in any way) and
        returns FALSE if the compilation completed uninterupted. Calling
        routine is then responsible for examining the COMPILER handle for
        the actual results of the compilation.

    Notes  :
    
        1. If you don't pass anything for p_Editor and p_Comp_File, the
           routine will attempt to compile the self-generated temp file
           name for p_Comp_File.  Of course, this file won't exist and
           you'll get an error: Can't find "pnnnnn.cmp".
           Always pass one or the other.
           
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

DEFINE INPUT  PARAMETER p_Editor       AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p_Msgs_Output  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p_Comp_File    AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p_Msgs_File    AS CHARACTER     NO-UNDO.
DEFINE OUTPUT PARAMETER p_Comp_Stopped AS LOGICAL INIT TRUE NO-UNDO.

&SCOPED-DEFINE  CMP_KEEP       "CMP_KEEP"
&SCOPED-DEFINE  CMP_NOERROR    "CMP_NOERROR"

DEFINE VARIABLE ok_save       AS LOGICAL NO-UNDO.
DEFINE VARIABLE ed_mod        AS LOGICAL NO-UNDO.
DEFINE VARIABLE error_num     AS INTEGER NO-UNDO.
DEFINE VARIABLE Del_Comp_File AS LOGICAL NO-UNDO.  
DEFINE VARIABLE Del_Msgs_File AS LOGICAL NO-UNDO.

REPEAT ON QUIT       , RETRY
       ON STOP   UNDO, RETRY
       ON ERROR  UNDO, RETRY
       ON ENDKEY UNDO, RETRY :

    IF NOT RETRY
    THEN DO:
        IF p_Comp_File = ? OR p_Comp_File = ""
        THEN DO:
            RUN adecomm/_tmpfile.p ( INPUT "" , INPUT ".cmp" ,
                                     OUTPUT p_Comp_File ).
            ASSIGN Del_Comp_File = TRUE.
        END.
        
        IF VALID-HANDLE( p_Editor ) /* AND p_Editor:TYPE = "EDITOR" */
        THEN DO:
            ASSIGN ed_mod = p_Editor:MODIFIED.
            ASSIGN ok_save = p_Editor:SAVE-FILE( p_Comp_File ) NO-ERROR.
            ASSIGN p_Editor:MODIFIED = ed_mod.
            
            IF NOT ok_save OR
               ERROR-STATUS:NUM-MESSAGES > 0
            THEN DO:
                MESSAGE p_Comp_File SKIP
                        "Unable to create compile file. Compilation cancelled."
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            
                /* Break out and return. */
                STOP.
            END.
            RUN SetEdBufType (INPUT p_Editor, INPUT p_Editor:NAME).   /* adecomm/peditor.i */
        END. /* IF VALID-HANDLE */
        
        /* This REPEAT needed in case the OUTPUT TO fails and raises the
           STOP condition.
        */
        REPEAT ON STOP  UNDO, RETRY
               ON ERROR UNDO, RETRY:
            IF NOT RETRY
            THEN DO:
                IF p_Msgs_Output = {&CMP_KEEP}
                THEN DO:
                    IF p_Msgs_File = ? OR p_Msgs_File = ""
                    THEN DO:
                        RUN adecomm/_tmpfile.p ( INPUT "" , INPUT ".msg" ,
                                                 OUTPUT p_Msgs_File ).
                        ASSIGN Del_Msgs_File = TRUE.
                    END.
                    OUTPUT TO VALUE( p_Msgs_File ) UNBUFFERED KEEP-MESSAGES.
                END.
                    
                IF p_Msgs_Output = {&CMP_NOERROR} THEN
                DO:
                    COMPILE VALUE( p_Comp_File ) NO-ERROR.
                    /* Populate _MSG with messages suppressed by NO-ERROR. */
                    RUN add-cmp-msgs.
                END.
                ELSE COMPILE VALUE( p_Comp_File ). /* CMP_KEEP OR CMP_DEFAULT */
                
                ASSIGN p_Comp_Stopped = COMPILER:STOPPED.
            END.
            LEAVE.
        END.
        
        /* User pressed Ctrl-C during compile, so break out and return. */
        IF COMPILER:STOPPED THEN STOP.    

    END. /* IF NOT RETRY */
    
    /* Just to be sure output is closed. */
    OUTPUT CLOSE.

    IF Del_Comp_File
        THEN OS-DELETE VALUE( p_Comp_File ).
    IF Del_Msgs_File
        THEN OS-DELETE VALUE( p_Msgs_File ).
    
    RETURN.

END. /* REPEAT RETRY */


/* Populate _MSG statment with ERROR-STATUS messages.
   If you execute COMPILE..NO-ERROR, _MSG population is suppressed.
   Call this routine if you want it populated. */
PROCEDURE add-cmp-msgs:

    DEFINE VARIABLE error_num AS INTEGER NO-UNDO.
    
    DO error_num = 1 TO ERROR-STATUS:NUM-MESSAGES:
      ASSIGN _MSG = ERROR-STATUS:GET-NUMBER( error_num ).
    END.

END PROCEDURE.

{ adecomm/peditor.i }   /* Editor procedures. */
