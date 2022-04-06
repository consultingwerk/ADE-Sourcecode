/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure :  _dlggetf.p
    
    Purpose : GUI and Character-mode version of SYSTEM-DIALOG GET-FILE for both
              Open and Save As dialogs.

    Syntax  :
    
        RUN adeedit/_dlggetf.p 
            ( INPUT p_Title ,
              INPUT p_Save_As ,
              INPUT p_Initial_Filter ,
              INPUT-OUTPUT p_File_Spec ,
              OUTPUT p_Return_Status ) .

    Parmameters :

        p_Title           : String to use for dialog box title.
        p_Save_As         : YES means use Save As dlg; NO means Open.
        p_Initial_Filter  : A number indicating which filter should be
                            the initial filter.  Currently unused.
        p_File_Spec       : File spec passed in and out.
        p_Return_Status   : YES - User successfully selected a file name
                            which could be found executing a PROGRESS RUN.
                            NO  - User press Cancel or STOP.
**************************************************************************/

DEFINE INPUT  PARAMETER p_Title            AS CHAR    NO-UNDO.
DEFINE INPUT  PARAMETER p_Save_As          AS LOGICAL NO-UNDO.
DEFINE INPUT  PARAMETER p_Initial_Filter   AS INTEGER INIT 1 NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_File_Spec  AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER p_Return_Status    AS LOGICAL INIT FALSE NO-UNDO.

DEFINE VAR vAction  AS CHAR NO-UNDO.
DEFINE VAR vMode    AS CHAR NO-UNDO.

/* ADE Standards Include */
{ adecomm/adestds.i }
IF NOT initialized_adestds
THEN RUN adecomm/_adeload.p.

/* Help Context */
{ adecomm/commeng.i }

/* Define temporary widget handle for run-time attributes.            */
DEFINE VAR tmp_handle     AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VAR File_Name AS CHAR LABEL "File Name" FORMAT "x({&PATH_WIDG})"
    VIEW-AS FILL-IN SIZE 60 BY 1.

DEFINE BUTTON btn_OK LABEL "OK"
    {&STDPH_OKBTN} AUTO-GO.

DEFINE BUTTON btn_Cancel LABEL "Cancel"
    {&STDPH_OKBTN} AUTO-ENDKEY.

DEFINE BUTTON btn_Browse LABEL "&Files..."
    {&STDPH_OKBTN}.

DEFINE BUTTON btn_Help LABEL "&Help"
    {&STDPH_OKBTN}.

/* Dialog Button Box */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE GF_Btn_Box    {&STDPH_OKBOX}.
&ENDIF

/* Dialog Box */    
FORM  
  SKIP( {&TFM_WID} )
     "File Name:" {&AT_OKBOX} VIEW-AS TEXT
  SKIP( {&VM_WID} )
     File_Name {&AT_OKBOX}
    { adecomm/okform.i
        &BOX    ="GF_Btn_Box"
        &OK     ="btn_OK"
        &CANCEL ="btn_Cancel"
        &OTHER  ="SPACE( {&HM_BTNG} ) btn_Browse"
        &HELP   ="btn_Help" 
    }
    WITH FRAME DLG-GET-FILE NO-LABELS TITLE p_Title
         VIEW-AS DIALOG-BOX
                 DEFAULT-BUTTON btn_OK
                 CANCEL-BUTTON btn_Cancel.
    { adecomm/okrun.i
        &FRAME  = "FRAME DLG-GET-FILE"
        &BOX    = "GF_Btn_Box"
        &OK     = "btn_OK"
        &OTHER  = "btn_Browse"
        &HELP   = "btn_Help"
    }

/*-------------------- UI Triggers  ------------------------------*/
ON HELP OF FRAME DLG-GET-FILE ANYWHERE
  RUN adecomm/_adehelp.p
      ( INPUT "comm" ,
        INPUT "CONTEXT" , INPUT {&Chr_Open_Dlg_Box} , INPUT ? ).

ON CHOOSE OF btn_Help IN FRAME DLG-GET-FILE
  RUN adecomm/_adehelp.p
      ( INPUT "comm" ,
        INPUT "CONTEXT" , INPUT {&Chr_Open_Dlg_Box} , INPUT ? ).

ON RETURN,ENTER OF File_Name IN FRAME DLG-GET-FILE
DO:
  APPLY "GO" TO FRAME DLG-GET-FILE.
  RETURN NO-APPLY.
END.

ON GO OF FRAME DLG-GET-FILE
DO:
   DEFINE VAR File_Spec    AS CHAR NO-UNDO.
   DEFINE VAR File_Exists  AS LOGI NO-UNDO.
   DEFINE VAR File_Valid   AS LOGI NO-UNDO.
   
   File_Spec = TRIM( File_Name:SCREEN-VALUE IN FRAME DLG-GET-FILE ) .

   /*--------------------------------------------------------------------
       Don't accept blank or unknown as file names.
   --------------------------------------------------------------------*/
   RUN FileValidName ( INPUT p_Title , File_Spec , OUTPUT File_Valid ).
   IF ( File_Valid = NO ) 
   THEN DO:
      APPLY "ENTRY" TO File_Name IN FRAME DLG-GET-FILE.  
      RETURN NO-APPLY.
   END.

   /*--------------------------------------------------------------------
       If Open dialog, file must exist. Using FILE-INFO handle allows
       us to test for a file relative to the PROGRESS PROPATH.
   --------------------------------------------------------------------*/
   IF ( p_Save_As = FALSE )
   THEN DO:
      RUN FileExists ( INPUT p_Title , File_Spec , OUTPUT File_Exists ).
      IF ( File_Exists = NO ) THEN RETURN NO-APPLY.
   END.
 
   HIDE FRAME DLG-GET-FILE NO-PAUSE .
   /* Return filename specification. */
   p_Return_Status = TRUE.
   p_File_Spec = File_Spec.
END.

ON CHOOSE OF btn_Browse IN FRAME DLG-GET-FILE
DO:
   DEFINE VAR File_Spec  AS CHAR NO-UNDO.

   /* Take initial value user typed. Maybe get-file can use it
      as the inital-dir. */
   ASSIGN File_Spec = File_Name:SCREEN-VALUE IN FRAME DLG-GET-FILE.

   RUN SysGetFile 
        ( INPUT "Files" /* p_Title */ ,
          INPUT p_Save_As ,
          INPUT p_Initial_Filter ,
          INPUT-OUTPUT File_Spec ,
          OUTPUT p_Return_Status ) .
    
   IF    ( p_Return_Status = NO )  
      OR ( File_Spec = ? ) 
   THEN RETURN NO-APPLY.
   ELSE DO:
       HIDE FRAME DLG-GET-FILE NO-PAUSE .
       File_Name:SCREEN-VALUE IN FRAME DLG-GET-FILE = File_Spec.
       APPLY "CHOOSE" TO btn_OK IN FRAME DLG-GET-FILE .
   END.
END.


ON WINDOW-CLOSE OF FRAME DLG-GET-FILE
   OR CHOOSE OF btn_Cancel IN FRAME DLG-GET-FILE
DO:
   p_Return_Status = FALSE.
END.


DO: /* Main */

  Dlg_Open :
  DO ON STOP   UNDO Dlg_Open , LEAVE Dlg_Open
     ON ERROR  UNDO Dlg_Open , LEAVE Dlg_Open
     ON ENDKEY UNDO Dlg_Open , LEAVE Dlg_Open :
  
    /*------------------------------------------------------------ 
       If nothing passed for Title, use one of the defaults. 
    ------------------------------------------------------------*/
    IF ( TRIM( p_Title ) = "" ) THEN
      ASSIGN p_Title = IF ( p_Save_As = TRUE ) THEN "Save As" ELSE "Open".
      
    IF ( SESSION:WINDOW-SYSTEM <> "TTY":U ) THEN
    DO:
        ASSIGN vAction  = IF p_Save_As THEN "Save As" ELSE "Open".
        ASSIGN vMode    = IF p_Save_As THEN "Save" ELSE "Open".
        RUN adecomm/_getfile.p
            (INPUT ACTIVE-WINDOW , INPUT ?,
             INPUT vAction      /* Action : "Save As" or "Open" */,
             INPUT p_Title      /* Title */,
             INPUT vMode        /* Mode   : "SAVE" or "OPEN" */,
             INPUT-OUTPUT p_File_Spec,
             OUTPUT p_Return_Status).
        LEAVE Dlg_Open.
    END.
    
    /* If Doing Save As, go straight to TTY get-file dialog. */
    IF ( p_Save_As = YES ) THEN
    DO:
       RUN SysGetFile
           ( INPUT p_Title ,
             INPUT p_Save_As ,
             INPUT p_Initial_Filter ,
             INPUT-OUTPUT p_File_Spec ,
             OUTPUT p_Return_Status ) .
        LEAVE Dlg_Open.
    END.
    ELSE DO:
    /* When TTY/Open, use initial Filename Open dialog with option to browse. */
       VIEW FRAME DLG-GET-FILE .
       UPDATE 
           File_Name
           btn_OK btn_Cancel btn_Browse btn_Help {&WHEN_HELP}
           GO-ON( GO,WINDOW-CLOSE )
           WITH FRAME DLG-GET-FILE .
    END. /* TTY/Open */
  
  END. /* DO ON Dlg_Open */
  
END.  /* Main */


PROCEDURE FileValidName .
   /*--------------------------------------------------------------------
       Don't accept blank or unknown as file names.
   --------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_Title      AS CHAR NO-UNDO.
  DEFINE INPUT  PARAMETER p_File_Spec  AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Valid      AS LOGI INIT TRUE NO-UNDO.

  ASSIGN p_Valid = TRUE.

  /* Validate that the name is a legal PROGRESS external procedure name. */
  RUN adecomm/_valpnam.p
      (INPUT  p_File_Spec, INPUT TRUE, INPUT "_EXTERNAL":U,
       OUTPUT p_Valid).

END PROCEDURE.


PROCEDURE FileExists .
   /*--------------------------------------------------------------------
       Test if file exists. Using FILE-INFO handle allows
       us to test for a file relative to the PROGRESS PROPATH.
   --------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_Title      AS CHAR NO-UNDO.
  DEFINE INPUT  PARAMETER p_File_Spec  AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Exists     AS LOGI INIT FALSE NO-UNDO.

   ASSIGN FILE-INFO:FILE-NAME = p_File_Spec. 
   IF ( FILE-INFO:FULL-PATHNAME = ? )
   THEN DO:
       MESSAGE p_File_Spec                SKIP
               "Cannot find this file." SKIP(1)
               "Please verify that the correct path and filename are given."
               VIEW-AS ALERT-BOX WARNING BUTTONS OK.
       p_Exists = FALSE.
   END.
   ELSE p_Exists = TRUE.

END PROCEDURE.


PROCEDURE SysGetFile .
  /*---------------------------------------------------------------------
    Purpose : Runs the appropriate Get-File (Open or Save As) dialog box,
              and returns the file spec and dialog status (ie, did user
              press OK or Cancel?)

    Syntax  :
    
        RUN SysGetFile 
            ( INPUT p_Title ,
              INPUT p_Save_As ,
              INPUT p_Initial_Filter ,
              INPUT-OUTPUT p_File_Spec ,
              OUTPUT p_Return_Status ) .
  ---------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_Title            AS CHAR    NO-UNDO.
  DEFINE INPUT  PARAMETER p_Save_As          AS LOGICAL NO-UNDO.
  DEFINE INPUT  PARAMETER p_Initial_Filter   AS INTEGER INIT 1 NO-UNDO .
  DEFINE INPUT-OUTPUT PARAMETER p_File_Spec  AS CHAR    NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Return_Status    AS LOGICAL INIT FALSE NO-UNDO.

  DEFINE VARIABLE vOptions     AS CHAR NO-UNDO.
  DEFINE VARIABLE vInitial_Dir AS CHAR NO-UNDO.

  DO: /* Main */
    /*------------------------------------------------------------ 
       If nothing passed for Title, use one of the defaults. 
    ------------------------------------------------------------*/
    IF ( TRIM( p_Title ) = "" ) THEN
        ASSIGN p_Title = IF ( p_Save_As = TRUE ) THEN "Save As" ELSE "Open".
    
    IF ( SESSION:WINDOW-SYSTEM = "TTY" ) THEN
    DO:
      ASSIGN vOptions = "ASK-OVERWRITE,MUST-EXIST" .
      
      /* Its possible that p_File_Spec is a dir name, so try and
         use it as the p_Dir name (pass in) and blank out the
         p_File_Spec. */
      ASSIGN vInitial_Dir = p_File_Spec
             p_File_Spec  = "".
  
      REPEAT ON STOP UNDO, LEAVE:
        RUN adecomm/_filecom.p
          ( INPUT "" /* p_Filter */, 
            INPUT vInitial_Dir /* p_Dir */ , 
            INPUT "" /* p_Drive */ ,
            INPUT p_Save_As ,  
            INPUT p_Title ,
            INPUT vOptions , 
            INPUT-OUTPUT p_File_Spec ,
            OUTPUT p_Return_Status ).
          IF p_Return_Status <> TRUE THEN LEAVE.
          RUN adecomm/_valpnam.p
              (INPUT  p_File_Spec, INPUT YES /* Show Msg */, INPUT "_EXTERNAL":U,
               OUTPUT p_Return_Status).
          IF p_Return_Status = TRUE THEN LEAVE.
      END.
    END.

  END. /* Main */
END PROCEDURE.

