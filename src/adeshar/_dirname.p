/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*-----------------------------------------------------------------------------

    File        : _dirname.p

    Syntax      :
        RUN adeshar/_dirname.p 
         ( INPUT        p_Dlg_title ,    /* Dialog Title Bar */
           INPUT        p_PROG_portable, /* YES is \'s converted to /'s */
           INPUT        p_must_exist,    /* YES if directory must exist */
           INPUT        p_help_tool,     /* ADE Tool (used for help call) */
           INPUT        p_help_context,  /* Context ID for HELP call */
           INPUT-OUTPUT p_Dir_Name ,    /* File Spec entered */
           OUTPUT       p_Return_Status  /* YES if user hits OK */
         ) .

   Description :  Directory-name Dialog, where the user can type in any
                  directory name.

  Input Output Parameters:
      p_Dir_Name        : File Reference name entered by user.


  Output Parameters:
      p_Return_Status    : Returns YES if user pressed OK; ? if user pressed
                           Cancel.

  Author       : Wm. T. Wood
  Date Created : 04/95

-----------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER p_Dlg_title AS CHAR NO-UNDO.
DEFINE INPUT        PARAMETER p_PROG_portable AS LOGICAL NO-UNDO.
DEFINE INPUT        PARAMETER p_must_exist AS LOGICAL NO-UNDO.
DEFINE INPUT        PARAMETER p_help_tool AS CHAR NO-UNDO.
DEFINE INPUT        PARAMETER p_help_context AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_Dir_Name AS CHAR FORMAT "X(256)" NO-UNDO.
DEFINE OUTPUT       PARAMETER p_Return_Status AS LOGICAL NO-UNDO.

/* ADE Standards Include */
&Scoped-define USE-3D YES
&GLOBAL-DEFINE WIN95-BTN YES
{ adecomm/adestds.i }
{ adeuib/uibhlp.i }

IF NOT initialized_adestds
    THEN RUN adecomm/_adeload.p.

/* Help Context Definitions. */

/*--------------------------------------------------------------------------
  GET-FILE Definitions.
--------------------------------------------------------------------------*/
{ adeedit/dsysgetf.i }

/*--------------------------------------------------------------------------
  GET-FILE Procedures.
--------------------------------------------------------------------------*/
{ adeedit/psysgetf.i }

DEFINE VAR v_Dir_Name LIKE p_Dir_Name .

/* Define a dialog box                                          */   
DEFINE FRAME DIALOG-1
     SKIP( {&TFM_WID} )
     SPACE( {&HFM_WID} )
     p_Dir_Name LABEL "Directory &Name" VIEW-AS FILL-IN SIZE 45 BY 1
    WITH OVERLAY NO-LABELS
    &if DEFINED(IDE-IS-RUNNING) = 0  &then  
    TITLE p_Dlg_Title
    VIEW-AS DIALOG-BOX
    &else
    NO-BOX
    &endif 
    THREE-D SIDE-LABELS.
 {adeuib/ide/dialoginit.i "FRAME DIALOG-1:handle"}
&IF DEFINED(IDE-IS-RUNNING) <> 0 &THEN
dialogService:View().
&else
ASSIGN FRAME DIALOG-1:PARENT = ACTIVE-WINDOW.  
&ENDIF 



{ adecomm/okbar.i
        &FRAME-NAME  = "DIALOG-1"
}


     
/* Standard Help Trigger - Note that we cannot pass this to okbar.i because
   the help tool is a variable.  */
ON CHOOSE OF btn_help OR HELP OF FRAME DIALOG-1 DO:
   RUN adecomm/_adehelp.p (p_help_tool, "CONTEXT", p_help_context, "").
END.

/******************************************************************/
/*                     UI TRIGGERS                                */
/******************************************************************/

ON GO OF FRAME DIALOG-1 DO:
    DEFINE VAR Focus_Widget      AS HANDLE.
    
    Focus_Widget = FOCUS.   
    DO ON STOP UNDO, RETRY ON ERROR UNDO, RETRY :    
        IF RETRY 
        THEN DO: 
            RUN ApplyEntry( Focus_Widget ). 
            RETURN NO-APPLY. 
        END.
        ELSE DO:
            RUN PressedOK ( OUTPUT p_Return_Status ).
            IF ( p_Return_Status = FALSE )
            THEN RUN ApplyEntry( Focus_Widget ).
        END.
    END.
END .

ON WINDOW-CLOSE OF FRAME DIALOG-1
  APPLY "END-ERROR" TO FRAME DIALOG-1.
    
ON CHOOSE OF btn_Cancel IN FRAME DIALOG-1
  RUN PressedCancel.


/****************************************************************
* Main Code Section                                             *
****************************************************************/

DO ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE:
    
    STATUS INPUT "".
    ASSIGN  p_Return_Status = FALSE  /* Cancel */
            v_Dir_Name     = p_Dir_Name
            .
            
    ENABLE ALL WITH FRAME DIALOG-1.
    
    DO ON STOP UNDO, LEAVE ON ERROR UNDO , LEAVE ON ENDKEY UNDO, LEAVE: 
        DISPLAY p_Dir_Name WITH FRAME DIALOG-1.
        &scoped-define CANCEL-EVENT U2
        {adeuib/ide/dialogstart.i btn_ok btn_cancel p_Dlg_title}
        &if DEFINED(IDE-IS-RUNNING) = 0  &then
         WAIT-FOR GO OF FRAME DIALOG-1.
        &ELSE
         WAIT-FOR GO OF FRAME DIALOG-1 or "U2" of this-procedure.       
        if cancelDialog THEN UNDO, LEAVE.  
      &endif
         
    END.

    STATUS INPUT.   
    HIDE FRAME DIALOG-1.
    
END. /* MAIN */
HIDE FRAME DIALOG-1.


/******************************************************************/
/*                     Internal Procedures                        */
/******************************************************************/

PROCEDURE ApplyEntry .
    DEFINE INPUT PARAMETER p_Widget AS WIDGET-HANDLE.

    IF ( p_Widget:SENSITIVE = TRUE )
    THEN APPLY "ENTRY" TO p_Widget.
END.

PROCEDURE PressedOK .

    DEFINE OUTPUT PARAMETER p_Return_Status AS LOGICAL INIT FALSE NO-UNDO.
     
    ASSIGN INPUT FRAME DIALOG-1 p_Dir_Name
           p_Dir_Name = TRIM( p_Dir_Name )  
           .
             
    FILE-INFO:FILENAME = TRIM( p_Dir_Name ) .
    /* Are we required to have a valid directory ? */
    IF p_must_exist THEN DO:
      IF ( FILE-INFO:FULL-PATHNAME = ? )
      THEN DO:
          MESSAGE TRIM( p_Dir_Name ) SKIP
                  "Cannot find this directory." SKIP(1)
                  "The directory should be specified with a full path" SKIP
                  "or exist relative to the PROGRESS PROPATH."
                  VIEW-AS ALERT-BOX WARNING.
          RETURN ERROR.
      END.
    END.
      
    /* If it exists, make sure it is a directory. */   
    IF  ( FILE-INFO:FILENAME ne ?) AND NOT ( FILE-INFO:FILE-TYPE BEGINS "D" )
    THEN DO:
        MESSAGE TRIM( p_Dir_Name ) SKIP
                  "This file is not a directory." SKIP(1)
                  "Please enter another name."
                  VIEW-AS ALERT-BOX WARNING.
          RETURN ERROR.
    END.
      
    /* Convert filenames to "Portable Progress" standards.  */
    IF p_PROG_portable THEN DO:
      p_Dir_Name = REPLACE(p_Dir_Name, "~\", "~/").  
      /* Use lower case for non-unix files */
      IF OPSYS ne "UNIX" THEN p_Dir_Name = LC(p_Dir_Name). 
    END.

    /* The value is OK. */
    ASSIGN  p_Return_Status = TRUE .


END.



PROCEDURE PressedCancel .
    ASSIGN  p_Return_Status = FALSE  /* Cancel */
            p_Dir_Name     = v_Dir_Name
            . 
END.

