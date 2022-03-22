/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*-----------------------------------------------------------------------------

    File        : _fspec.p

    Syntax      : RUN adecomp/_fspec.p 
                      ( INPUT-OUTPUT p_File_Spec ,
                        INPUT-OUTPUT p_Proc_Types ,
                        OUTPUT       p_Return_Status ) .

    Description :  Procedure Specification dialog box to allow user to
                   enter a file or directory to add or modify in the 
                   Procedures to Compile List box of the Application 
                   Compiler Tool.

  Input Parameters:
      <none>

  VARs:
      p_File_Spec        : File or directory name entered by user.

      p_Proc_Types       : Procedure types (e.g., *.p *.w).  Returns
                           null if user enters a directory.  Wildcard usage
                           is limited to that specified by the PROGRESS
                           4GL MATCHES function.

  Output Parameters:
      p_Return_Status    : Returns YES if user pressed OK; ? if user pressed
                           Cancel.

  Author       : John Palazzo
  Date Created : 03/93

-----------------------------------------------------------------------------*/

/* FORMATS of "X(50)" and "X(15)" must be in synch with adecomp/_procomp.p
   definition (see DEFINE WORK-TABLE...).
	Last change:  WLB   9 Jun 93    8:19 am
*/
DEFINE INPUT-OUTPUT PARAMETER p_File_Spec AS CHAR LABEL "File or Directory"
    FORMAT "X(256)" .
DEFINE INPUT-OUTPUT PARAMETER p_Proc_Types AS CHAR LABEL "Types"
    FORMAT "X(256)" .
DEFINE OUTPUT       PARAMETER p_Return_Status AS LOGICAL 
    INIT ? .

&GLOBAL-DEFINE WIN95-BTN YES
/* ADE Standards Include */
{ adecomm/adestds.i }
IF NOT initialized_adestds
    THEN RUN adecomm/_adeload.p.

/* Help Context Definitions. */
{ adecomp/comphelp.i }

/*--------------------------------------------------------------------------
  GET-FILE Definitions.
--------------------------------------------------------------------------*/
{ adeedit/dsysgetf.i }
/*--------------------------------------------------------------------------
  GET-FILE Procedures.
--------------------------------------------------------------------------*/
{ adeedit/psysgetf.i }

DEFINE VAR v_File_Spec  LIKE p_File_Spec  NO-UNDO .
DEFINE VAR v_Proc_Types LIKE p_Proc_Types NO-UNDO .

/* Define a dialog box                                          */

/* Definitions of the field level widgets                             */
DEFINE BUTTON btn_OK LABEL "OK"
    {&STDPH_OKBTN} AUTO-GO .
    
DEFINE BUTTON btn_Cancel LABEL "Cancel"
    {&STDPH_OKBTN} AUTO-ENDKEY .

DEFINE BUTTON btn_Browse LABEL "&Files..."
    {&STDPH_OKBTN} .

DEFINE BUTTON btn_Help  LABEL "&Help"
    {&STDPH_OKBTN} .

/* Dialog Button Box */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE FS_Btn_Box    {&STDPH_OKBOX}.
&ENDIF

/* Dialog Box */    
DEFINE FRAME DIALOG-1
    SKIP( {&TFM_WID} )
     "File or Directory &Name:" 
        VIEW-AS TEXT SIZE 28 BY 1 {&AT_OKBOX}
     "&Types:" 
        VIEW-AS TEXT SIZE 13 BY 1 AT 53 
     SKIP( {&VM_WID} )
     p_File_Spec
        VIEW-AS FILL-IN SIZE 50 BY 1 {&STDPH_FILL} {&AT_OKBOX}
     p_Proc_Types
        VIEW-AS FILL-IN SIZE 15 BY 1 {&STDPH_FILL}
    { adecomm/okform.i
        &BOX    ="FS_Btn_Box"
        &OK     ="btn_OK"
        &CANCEL ="btn_Cancel"
        &OTHER  ="SPACE( {&HM_BTNG} ) btn_Browse"
        &HELP   ="btn_Help" 
    }
    WITH OVERLAY NO-LABELS TITLE "File Specification"
         VIEW-AS DIALOG-BOX 
                 DEFAULT-BUTTON btn_OK
                 CANCEL-BUTTON  btn_Cancel.
    { adecomm/okrun.i
        &FRAME  = "FRAME DIALOG-1"
        &BOX    = "FS_Btn_Box"
        &OK     = "btn_OK"
        &CANCEL = "btn_Cancel"
        &OTHER  = "btn_Browse"
        &HELP   = "btn_Help"
    }

/******************************************************************/
/*                     UI TRIGGERS                                */
/******************************************************************/

ON ALT-N OF FRAME DIALOG-1 ANYWHERE
DO:
    IF p_File_Spec:SENSITIVE THEN APPLY "ENTRY":U TO p_File_Spec.
END.

ON ALT-T OF FRAME DIALOG-1 ANYWHERE
DO:
    IF p_Proc_Types:SENSITIVE THEN APPLY "ENTRY":U TO p_Proc_Types.
END.
    
ON HELP OF FRAME DIALOG-1 ANYWHERE
DO:
  DO ON STOP UNDO, LEAVE:
    RUN adecomm/_adehelp.p
        ( INPUT "comp" ,
          INPUT "CONTEXT" , 
          INPUT {&FileSpec_Dialog_Box} , INPUT ? ).
  END.    
END.

ON CHOOSE OF btn_Help IN FRAME DIALOG-1
DO:
  DO ON STOP UNDO, LEAVE:
    RUN adecomm/_adehelp.p
        ( INPUT "comp" ,
          INPUT "CONTEXT" , 
          INPUT {&FileSpec_Dialog_Box} , INPUT ? ).
  END.    
END.

ON GO OF FRAME DIALOG-1
DO:
    DEFINE VAR Focus_Widget      AS WIDGET-HANDLE.
    
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
DO:
    RUN PressedCancel.
END .

ON CHOOSE OF btn_Browse IN FRAME DIALOG-1
DO:
    DEFINE VAR Return_Status AS LOGICAL.
    DEFINE VAR Focus_Widget      AS WIDGET-HANDLE.
    
    Focus_Widget = FOCUS.   
    DO ON STOP UNDO, RETRY :    
        IF RETRY THEN RETURN NO-APPLY.
        ELSE DO:
            RUN BrowseFiles ( OUTPUT Return_Status ).
            IF ( Return_Status = TRUE )
            THEN 
                APPLY "ENTRY" TO btn_OK IN FRAME DIALOG-1.
            ELSE 
                APPLY "ENTRY" TO Focus_Widget .
        END.
    END.
    
END .


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
    
    DEFINE VAR Invalid_IsOK  AS LOGICAL INIT NO.
    DEFINE VAR ReadOnly_IsOK AS LOGICAL INIT NO.
    
    FILE-INFO:FILENAME = TRIM( p_File_Spec:SCREEN-VALUE IN FRAME DIALOG-1 ) .
    IF ( FILE-INFO:FULL-PATHNAME = ? )
    THEN DO:
        MESSAGE TRIM( p_File_Spec:SCREEN-VALUE IN FRAME DIALOG-1 ) SKIP
                "Cannot find this file or directory." SKIP(1)
                "The file or directory should be specified with" SKIP
                "a full path or exist in the PROGRESS PROPATH."  SKIP
                "Do you want to continue?"
                VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO 
                        UPDATE Invalid_IsOK .
        IF ( Invalid_IsOK = NO ) THEN RETURN ERROR.
    END.
    
    /* If directory and read-only, warn user. */
    IF ( INDEX( FILE-INFO:FILE-TYPE , "D" ) > 0 AND 
         INDEX( FILE-INFO:FILE-TYPE , "W" ) = 0 )
    THEN DO:
        MESSAGE TRIM( p_File_Spec:SCREEN-VALUE IN FRAME DIALOG-1 ) SKIP
                "Specified directory is read-only." SKIP(1)
                "Compiler may not be able to create .r files."
                VIEW-AS ALERT-BOX WARNING BUTTONS OK-CANCEL
                        UPDATE ReadOnly_IsOK.
        IF ( ReadOnly_IsOK = NO ) THEN RETURN ERROR.
    END.
    
    ASSIGN  p_Return_Status = TRUE
            INPUT FRAME DIALOG-1 p_File_Spec
            INPUT FRAME DIALOG-1 p_Proc_Types
            p_File_Spec  = TRIM( p_File_Spec )
            p_Proc_Types = TRIM( p_Proc_Types )
    . /* END ASSIGN. */
    
    /* If user wants the Invalid File entry, return it exactly as is. */
    IF ( Invalid_IsOK = YES ) THEN RETURN.

    /* If user entered a file, clear out the Types field. */
    IF INDEX( FILE-INFO:FILE-TYPE , "F" ) > 0
        THEN p_Proc_Types = "".    
END.


PROCEDURE PressedCancel .

    ASSIGN  p_Return_Status = ?  /* Cancel */
            p_File_Spec     = v_File_Spec
            p_Proc_Types    = v_Proc_Types
    . /* END ASSIGN. */
END.


PROCEDURE BrowseFiles .
  DEFINE OUTPUT PARAMETER p_Return_Status AS LOGICAL INIT FALSE NO-UNDO.
  
  DEFINE VAR v_GotFile         AS CHAR NO-UNDO.

  /* 20050812-040 For GUI, call adecomm/_getfile.p to 
   * display the File Open dialog, so that we get *.cls
   * in the filter list. */
  IF ( SESSION:WINDOW-SYSTEM <> "TTY":U ) THEN
  DO:
      RUN adecomm/_getfile.p
            (INPUT ACTIVE-WINDOW , INPUT ?,
             INPUT "Open"       /* Action : "Save As" or "Open" */,
             INPUT "Files"      /* Title */,
             INPUT "Open"        /* Mode   : "SAVE" or "OPEN" */,
             INPUT-OUTPUT v_GotFile,
             OUTPUT p_Return_Status).
  END.
  ELSE
  DO:
      RUN SysGetFile
            ( INPUT "Files" /* p_Title */ ,
              INPUT NO /* p_Save_As */ ,
              INPUT 1 /* p_Initial_Filter */ ,
              INPUT-OUTPUT v_GotFile ,
              OUTPUT p_Return_Status ) .
  END.

  IF ( p_Return_Status = NO ) THEN RETURN .

  ASSIGN  p_File_Spec:SCREEN-VALUE  IN FRAME DIALOG-1 = v_GotFile
          p_Proc_Types:SCREEN-VALUE IN FRAME DIALOG-1 = ""
  . /* END ASSIGN */
END.

/****************************************************************
* Main Code Section                                             *
****************************************************************/

DO ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE:
    
    STATUS INPUT "".
    ASSIGN  p_Return_Status = ?  /* Cancel */
            v_File_Spec = p_File_Spec
            v_Proc_Types = p_Proc_Types.

    ENABLE ALL EXCEPT btn_Help WITH FRAME DIALOG-1.
    ENABLE btn_Help {&WHEN_HELP} WITH FRAME DIALOG-1.
    
    DO ON STOP UNDO, LEAVE ON ERROR UNDO , LEAVE ON ENDKEY UNDO, LEAVE:
        UPDATE p_File_Spec p_Proc_Types
            WITH FRAME DIALOG-1.            
    END.

    STATUS INPUT.
    
END. /* MAIN */
HIDE FRAME DIALOG-1.
