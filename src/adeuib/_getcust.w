&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f_dlg
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _getcust.w

  Purpose: Let the user change the list of files to load as Custom Object Files.
  
  Syntax:
        RUN adeshar/_getcust.w (INPUT-OUTPUT  p_FileList ,
                                OUTPUT        p_OK ).

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:   Wm.T.Wood
  Created:  03/95  

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN  YES

{adecomm/adestds.i}        /* Standared ADE Preprocessor Directives     */
IF NOT initialized_adestds
THEN RUN adecomm/_adeload.p.

{ adeuib/uibhlp.i }          /* Help File Preprocessor Directives       */

/* Parameters Definitions ---                                           */

&IF DEFINED(UIB_is_Running) = 0 &THEN
DEFINE INPUT-OUTPUT PARAMETER p_FileList      AS CHARACTER NO-UNDO .
    /* Comma-delimited list of Included Libraries.          */
DEFINE OUTPUT       PARAMETER p_OK            AS LOGICAL   NO-UNDO .
    /* YES - User choose OK. NO - User choose Cancel.       */
&ELSE
DEFINE VARIABLE p_FileList      AS CHARACTER NO-UNDO INIT "template/progress.cst".
DEFINE VARIABLE p_OK            AS LOGICAL   NO-UNDO .
&ENDIF


/* ***************************  Definitions  ************************** */
DEFINE VARIABLE glDYnamicsCST AS LOGICAL    NO-UNDO.
define variable cTitle        as character no-undo init "Use Custom":L.



/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f_dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS file-list b_add b_Modify b_delete b_move_up ~
b_move_down 
&Scoped-Define DISPLAYED-OBJECTS fiLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */




/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_add 
     LABEL "&Add...":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_delete 
     LABEL "&Remove":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_Modify 
     LABEL "&Modify...":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_move_down 
     LABEL "Move &Down":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_move_up 
     LABEL "Move &Up":L 
     SIZE 15 BY 1.14.

DEFINE VARIABLE fiLabel AS CHARACTER FORMAT "X(50)":U INITIAL "Custom Object Files:" 
     CONTEXT-HELP-ID 0
      VIEW-AS TEXT 
     SIZE 47 BY .86 NO-UNDO.

DEFINE VARIABLE file-list AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 48 BY 6.48 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f_dlg
     file-list AT ROW 2.1 COL 3 NO-LABEL
     b_add AT ROW 2.1 COL 52
     b_Modify AT ROW 3.43 COL 52
     b_delete AT ROW 4.76 COL 52
     b_move_up AT ROW 6.14 COL 52
     b_move_down AT ROW 7.48 COL 52
     fiLabel AT ROW 1.19 COL 1 COLON-ALIGNED NO-LABEL
     SPACE(17.56) SKIP(6.67)
     WITH 
   &if DEFINED(IDE-IS-RUNNING) = 0  &then
     VIEW-AS DIALOG-BOX NO-HELP
     TITLE ctitle
   &endif  
     SIDE-LABELS THREE-D SCROLLABLE. 
 

/* ***********  Runtime Attributes and AppBuilder Settings  *********** */
  {adeuib/ide/dialoginit.i "frame f_dlg:handle"}

/* SETTINGS FOR DIALOG-BOX f_dlg
   UNDERLINE                                                            */
ASSIGN 
       FRAME f_dlg:SCROLLABLE       = FALSE
       FRAME f_dlg:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b_add IN FRAME f_dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON b_delete IN FRAME f_dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON b_Modify IN FRAME f_dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON b_move_down IN FRAME f_dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON b_move_up IN FRAME f_dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN fiLabel IN FRAME f_dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR SELECTION-LIST file-list IN FRAME f_dlg
   NO-DISPLAY                                                           */
/* _RUN-TIME-ATTRIBUTES-END */

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME f_dlg
ON GO OF FRAME f_dlg /* Use Custom */
DO:
  ASSIGN p_FileList = file-list:LIST-ITEMS
         p_OK       = YES.
  HIDE FRAME {&FRAME-NAME}. 
END.



&Scoped-define SELF-NAME b_add
ON CHOOSE OF b_add IN FRAME f_dlg /* Add... */
DO:
   run choose_add.
END.



&Scoped-define SELF-NAME b_delete
ON CHOOSE OF b_delete IN FRAME f_dlg /* Remove */
DO:
  DEFINE VAR i      AS INTEGER NO-UNDO.
  DEFINE VAR choice AS CHAR    NO-UNDO.
  DEFINE VAR l_ok   AS LOGICAL NO-UNDO.
  DEFINE VAR adedir AS CHAR    NO-UNDO.
  
  ASSIGN choice = file-list:SCREEN-VALUE.
  DO i = 1 TO NUM-ENTRIES(choice):
    l_ok = file-list:DELETE(ENTRY(i,choice)).
  END.
  ASSIGN file-list:SCREEN-VALUE = file-list:ENTRY(1).
  RUN set-state.
END.



&Scoped-define SELF-NAME b_Modify
ON CHOOSE OF b_Modify IN FRAME f_dlg /* Modify... */
DO:
  RUN Modify-Selection.
END.



&Scoped-define SELF-NAME b_move_down
ON CHOOSE OF b_move_down IN FRAME f_dlg /* Move Down */
DO:
  RUN move_item IN THIS-PROCEDURE (INPUT file-list:SCREEN-VALUE , "DOWN":U ).
END.



&Scoped-define SELF-NAME b_move_up
ON CHOOSE OF b_move_up IN FRAME f_dlg /* Move Up */
DO:
  RUN move_item IN THIS-PROCEDURE (INPUT file-list:SCREEN-VALUE , "UP":U ).
END.



&Scoped-define SELF-NAME file-list
ON DEFAULT-ACTION OF file-list IN FRAME f_dlg
DO:
  RUN Modify-Selection.
END.



ON VALUE-CHANGED OF file-list IN FRAME f_dlg
DO:
  /* Change the sensitivity of the buttons. */
  RUN set-state.
END.



&UNDEFINE SELF-NAME



/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* ADE okbar.i places standard ADE OK-CANCEL-HELP buttons.              */
{adecomm/okbar.i &TOOL = "AB"
                 &CONTEXT = {&Use_Custom_Dlg_Box} }

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

 &scoped-define CANCEL-EVENT U2
{adeuib/ide/dialogstart.i btn_ok btn_cancel cTitle}

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN set-init-values.
  RUN enable_UI.
  RUN set-state.
  &if DEFINED(IDE-IS-RUNNING) = 0  &then   
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  &else
   WAIT-FOR GO OF FRAME {&FRAME-NAME} or "{&CANCEL-EVENT}" of this-procedure. 
  &endif
END.
RUN disable_UI.



/* **********************  Internal Procedures  *********************** */

PROCEDURE CheckDupeItem :
/* -----------------------------------------------------------
  Purpose:    See if the File sent in is a DUPLICATE of any 
              existing name in the list. 
-------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p_File_Spec AS CHAR               NO-UNDO.
    DEFINE OUTPUT PARAMETER p_Duplicate AS LOGICAL INIT FALSE NO-UNDO.

    DO WITH FRAME {&FRAME-NAME} :
        ASSIGN p_Duplicate = ( file-list:LOOKUP( p_File_Spec ) <> 0 ).
          
        IF p_Duplicate = TRUE THEN
        do:
           &if DEFINED(IDE-IS-RUNNING) <> 0 &then
               ShowMessageInIDE("This Method Library reference is already in the list and ~n 
                                 cannot be added again.",
                                 "Warning",?,"OK",yes).
    
           &else    
           MESSAGE p_File_Spec SKIP(1)
                "This Method Library reference is already in the list and" SKIP
                "cannot be added again."
                VIEW-AS ALERT-BOX WARNING IN WINDOW ACTIVE-WINDOW.
           &endif        
        end.        
    END.
  
END PROCEDURE.


PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f_dlg.
END PROCEDURE.


PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY fiLabel 
      WITH FRAME f_dlg.
  ENABLE file-list b_add b_Modify b_delete b_move_up b_move_down 
      WITH FRAME f_dlg.
  VIEW FRAME f_dlg.
  {&OPEN-BROWSERS-IN-QUERY-f_dlg}
END PROCEDURE.

procedure choose_add:
    &if DEFINED(IDE-IS-RUNNING) <> 0 &then 
         dialogService:SetCurrentEvent(this-procedure,"do_choose_add").
         run runChildDialog in hOEIDEService (dialogService) .
    &else  
         RUN do_choose_add.
    &endif
end.    
procedure do_choose_add:
    DEFINE VAR l_ok     AS LOGICAL   NO-UNDO.
  DEFINE VAR new_file AS CHARACTER NO-UNDO.
  DEFINE VAR l_Dupe   AS LOGICAL   NO-UNDO.
           
    RUN Get-Filename ( INPUT        "Add" ,
                       INPUT        {&Add_Custom_Dlg_Box},
                       INPUT-OUTPUT new_file ,
                       OUTPUT       l_ok ) .
  IF l_ok THEN DO:    
    RUN CheckDupeItem (INPUT new_file , OUTPUT l_Dupe ).
    IF NOT l_Dupe THEN DO:
      /* Always add new items at the end of the list (because order is important).
         Adding it in place is generally the wrong idea because users will add it
         in order they want the palette to be created. */
      ASSIGN l_ok = file-list:ADD-LAST ( new_file ) in FRAME {&FRAME-NAME}
             file-list:SCREEN-VALUE = new_file.
      RUN set-state.
    END.
  END.
end procedure.    
PROCEDURE Get-Filename :
/*------------------------------------------------------------------------------
  Purpose:     Call adeshar/_filname.p with many parameters already filled in.
------------------------------------------------------------------------------*/
  DEFINE INPUT        PARAMETER p_mode AS CHAR NO-UNDO.
  DEFINE INPUT        PARAMETER p_help_context AS INTEGER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_File_Spec AS CHAR FORMAT "X(256)" NO-UNDO.
  DEFINE OUTPUT       PARAMETER p_Return_Status AS LOGICAL NO-UNDO.
  &if DEFINED(IDE-IS-RUNNING) <> 0 &then
    RUN adeuib/ide/_dialog_filname.p 
       ( INPUT        p_mode + " Custom Object File",  /* Dialog Title Bar */
         INPUT        NO,                            /* YES is \'s converted to /'s */
         INPUT        YES,                           /* YES if file must exist */
         INPUT        '':U,                          /* No additional options */
         INPUT        "Custom Object Files (*.cst)", /* File Filter (eg. "Include") */
         INPUT        "*.cst",                       /* File Spec  (eg. *.i) */
         INPUT        "AB",           /* ADE Tool (used for help call) */
         INPUT        p_help_context,  /* Context ID for HELP call */
         INPUT-OUTPUT p_File_Spec ,    /* File Spec entered */
         OUTPUT       p_Return_Status  /* YES if user hits OK */
       ) .  
  &else           
  RUN adeshar/_filname.p 
       ( INPUT        p_mode + " Custom Object File",  /* Dialog Title Bar */
         INPUT        NO,                            /* YES is \'s converted to /'s */
         INPUT        YES,                           /* YES if file must exist */
         INPUT        '':U,                          /* No additional options */
         INPUT        "Custom Object Files (*.cst)", /* File Filter (eg. "Include") */
         INPUT        "*.cst",                       /* File Spec  (eg. *.i) */
         INPUT        "AB",           /* ADE Tool (used for help call) */
         INPUT        p_help_context,  /* Context ID for HELP call */
         INPUT-OUTPUT p_File_Spec ,    /* File Spec entered */
         OUTPUT       p_Return_Status  /* YES if user hits OK */
       ) .  
   &endif
END PROCEDURE.

procedure Modify-Selection:
    &if DEFINED(IDE-IS-RUNNING) <> 0 &then 
         dialogService:SetCurrentEvent(this-procedure,"choose_Modify-Selection").
         run runChildDialog in hOEIDEService (dialogService) .
    &else  
         RUN choose_Modify-Selection.
    &endif
end procedure.

PROCEDURE choose_Modify-Selection :
/*------------------------------------------------------------------------------
  Purpose:    Change the value of the currently selected file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR l_ok     AS LOGICAL   NO-UNDO.
  DEFINE VAR new_file AS CHARACTER NO-UNDO.
  DEFINE VAR old_file AS CHARACTER NO-UNDO.
  DEFINE VAR item     AS CHARACTER NO-UNDO.
  DEFINE VAR l_Dupe   AS LOGICAL   NO-UNDO.
  
  IF glDynamicsCST THEN
     RETURN.
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN new_file = TRIM( file-list:SCREEN-VALUE )
           old_file = new_file.
    
        
    RUN Get-Filename ( INPUT        "Modify" ,
                       INPUT        {&Modify_Custom_Dlg_Box},
                       INPUT-OUTPUT new_file ,
                       OUTPUT       l_ok ) .
                       
    IF NOT l_ok OR ( new_file = old_file ) THEN RETURN.
     
    RUN CheckDupeItem (INPUT new_file , OUTPUT l_Dupe ).
    IF NOT l_Dupe AND new_file NE file-list:SCREEN-VALUE THEN DO:
      
      ASSIGN l_ok = file-list:INSERT( new_file , file-list:SCREEN-VALUE )
             l_ok = file-list:DELETE( file-list:SCREEN-VALUE )  
             file-list:SCREEN-VALUE = new_file .
    END.
  END.
END PROCEDURE.


PROCEDURE move_item :
/* -----------------------------------------------------------
  Purpose:     Move a given item "UP" or "DOWN" in the list. 
-------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Item      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_Direction AS CHARACTER NO-UNDO.
  
  DEFINE VAR cur_pos AS INTEGER     NO-UNDO.
  DEFINE VAR l_ok    AS LOGICAL     NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    IF ( file-list:NUM-ITEMS <= 1 ) OR (  p_Item = ? )
      THEN RETURN.
    ASSIGN cur_pos = file-list:LOOKUP( p_Item ).
    
    IF ( p_Direction = "UP":U ) AND ( cur_pos <= 1 )
      THEN RETURN.
    IF ( p_Direction = "DOWN":U ) AND ( cur_pos = file-list:NUM-ITEMS )
      THEN RETURN.
  
    IF p_Direction = "UP":U THEN
    DO:
      ASSIGN l_ok    = file-list:INSERT( p_Item , cur_pos - 1)
             l_ok    = file-list:DELETE( cur_pos + 1) .
             file-list:SCREEN-VALUE = p_Item
             .
    END.
    ELSE
    DO:
      /* To move down, we simply move the item below the current one
         up. Then assign s-v to the item we moved down.
      */
      RUN move_item ( INPUT file-list:ENTRY( cur_pos + 1 ) , INPUT "UP":U ).
      ASSIGN file-list:SCREEN-VALUE = p_Item.
    END.
    
    /* Change the sensitivity of (UP & DOWN) buttons */
    RUN set-state.
       
  END.
  
END PROCEDURE.


PROCEDURE set-init-values :
/* -----------------------------------------------------------
  Purpose:     Set the initial values of the dialog-box.
  Parameters:  <none>
-------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME} :
     /* This occurs when running dynamics and the palette and template
        information comes from the repository */
     IF p_FileList BEGINS "~~@Dummy":U THEN 
     DO:
         ASSIGN p_FileList    = SUBSTRING(p_FileList,8,-1,"CHARACTER":U)
                glDynamicsCST = TRUE
                fiLabel       = "Dynamic Templates and Palette Objects:" .
     END.
      ASSIGN file-list:LIST-ITEMS  = p_FileList
             file-list = file-list:ENTRY( 1 ) NO-ERROR.
      DISPLAY file-list WITH FRAME {&FRAME-NAME}.
  END.

END PROCEDURE.


PROCEDURE set-state :
/* -----------------------------------------------------------
  Purpose:     Change the Sensitivity of all the buttons based
               on the state of the selection-list.
  Parameters:  <none>
-------------------------------------------------------------*/
  DEF VAR cnt       AS INTEGER NO-UNDO.
  DEF VAR iSelected AS INTEGER NO-UNDO.
  
  IF glDYnamicsCST THEN
  DO WITH FRAME {&FRAME-NAME} :  
     ASSIGN b_Add:SENSITIVE       = FALSE
            b_Modify:SENSITIVE    = FALSE
            b_delete:SENSITIVE    = FALSE
            b_Move_up:SENSITIVE   = FALSE
            b_Move_down:SENSITIVE = FALSE.
     RETURN.       
  END.
  DO WITH FRAME {&FRAME-NAME} :
    
    ASSIGN cnt = file-list:NUM-ITEMS.
    IF cnt = 0 THEN iSelected = 0.
    ELSE iSelected = file-list:LOOKUP(file-list:SCREEN-VALUE).
    IF file-list:NUM-ITEMS = 0 THEN
        DISABLE b_delete b_Modify b_move_down b_move_up .
    ELSE DO:
        ENABLE b_delete b_Modify.
        ASSIGN b_move_down:SENSITIVE = (iSelected < cnt)
               b_move_up:SENSITIVE   = (iSelected > 1)
               .
    END.
  END.
  
END PROCEDURE.


