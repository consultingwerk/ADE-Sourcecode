&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f_ML_Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS f_ML_Dlg 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _mldlg.w

  Purpose: Method Libraries Dialog Box.
  
  Syntax:
        RUN adeuib/_mldlg.w
            (INPUT   p_Object_Name ,
             OUTPUT  p_Include_List ,
             OUTPUT  p_Code ,
             OUTPUT  p_OK ).

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:   J. Palazzo
  Created:  03/95  

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES

{adecomm/adestds.i}        /* Standared ADE Preprocessor Directives */
IF NOT initialized_adestds THEN
  RUN adecomm/_adeload.p.

{adeuib/uibhlp.i}          /* Help File Preprocessor Directives     */
{adeuib/uniwidg.i}

/* Parameters Definitions ---                                           */

&IF DEFINED(UIB_is_Running) = 0 &THEN
DEFINE INPUT        PARAMETER p_Object_Name   AS CHARACTER NO-UNDO .
    /* Object Name to display in dialog title.              */
DEFINE INPUT        PARAMETER p_Parent_ID     AS CHARACTER NO-UNDO .
    /* Parent ID to pass to LIB-MGR.                        */
DEFINE OUTPUT PARAMETER p_Include_List        AS CHARACTER NO-UNDO .
    /* Comma-delimited list of Included Libraries.          */
DEFINE OUTPUT PARAMETER p_Code                AS CHARACTER NO-UNDO .
    /* _INCLUDED-LIB Code Block.                            */
DEFINE OUTPUT       PARAMETER p_OK            AS LOGICAL   NO-UNDO .
    /* YES - User choose OK. NO - User choose Cancel.       */
&ELSE
DEFINE VARIABLE p_Object_Name   AS CHARACTER NO-UNDO INIT "SmartWindow".
DEFINE VARIABLE p_Parent_ID     AS CHARACTER NO-UNDO .
DEFINE VARIABLE p_Include_List  AS CHARACTER NO-UNDO INIT "adm/method/smart.i".
DEFINE VARIABLE p_Code          AS CHARACTER NO-UNDO .
DEFINE VARIABLE p_OK            AS LOGICAL   NO-UNDO .
&ENDIF


/* ***************************  Definitions  ************************** */

DEFINE VARIABLE cBrokerURL  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE Open_Curly  AS CHARACTER  NO-UNDO 
  FORMAT "x(1)" INITIAL "~{":U.
DEFINE VARIABLE Close_Curly AS CHARACTER  NO-UNDO 
  FORMAT "x(1)" INITIAL "~}":U.
DEFINE VARIABLE h_mlmgr     AS HANDLE     NO-UNDO.
                /* Procedure handle of LIB-MGR.  */
DEFINE VARIABLE wintitle as char no-undo init "Method Libraries":L.
DEFINE VARIABLE l_ok     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE new_file AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lAction  As CHAR NO-UNDO.  
DEFINE VAR old_file AS CHARACTER NO-UNDO.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f_ML_Dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS file-list b_add b_Modify b_delete b_move_up ~
b_move_down 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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

DEFINE VARIABLE file-list AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 48 BY 6.48 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f_ML_Dlg
     file-list AT ROW 2.1 COL 3 NO-LABEL
     b_add AT ROW 2.1 COL 53
     b_Modify AT ROW 3.43 COL 53
     b_delete AT ROW 4.76 COL 53
     b_move_up AT ROW 6.14 COL 53
     b_move_down AT ROW 7.48 COL 53
     "Method Library Include References:" VIEW-AS TEXT
          SIZE 36 BY .67 AT ROW 1.29 COL 3
     SPACE(29.85) SKIP(6.76)
    WITH 
    &if DEFINED(IDE-IS-RUNNING) = 0  &then
    VIEW-AS DIALOG-BOX TITLE wintitle
    &else
    NO-BOX
    &endif
         SIDE-LABELS THREE-D  SCROLLABLE 
         .

 {adeuib/ide/dialoginit.i "FRAME f_ML_Dlg:handle"}
&if DEFINED(IDE-IS-RUNNING) <> 0  &then
   dialogService:View(). 
&endif

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX f_ML_Dlg
   UNDERLINE Default                                                    */
ASSIGN 
       FRAME f_ML_Dlg:SCROLLABLE       = FALSE
       FRAME f_ML_Dlg:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b_add IN FRAME f_ML_Dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON b_delete IN FRAME f_ML_Dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON b_Modify IN FRAME f_ML_Dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON b_move_down IN FRAME f_ML_Dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON b_move_up IN FRAME f_ML_Dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR SELECTION-LIST file-list IN FRAME f_ML_Dlg
   NO-DISPLAY                                                           */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME f_ML_Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f_ML_Dlg f_ML_Dlg
ON GO OF FRAME f_ML_Dlg /* Method Libraries */
DO:
  &SCOPED-DEFINE EOL    CHR(10)
  
  DEFINE VARIABLE l_OK       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE Old_List   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ventry     AS INTEGER    NO-UNDO.
  
  DO ON ERROR  UNDO, LEAVE
     ON ENDKEY UNDO, LEAVE
     ON STOP   UNDO, LEAVE :
     
    RUN adecomm/_setcurs.p ( INPUT "WAIT":U ).
    ASSIGN Old_List = p_Include_List .
    
    RUN adeshar/_coddflt.p (INPUT "_INCLUDED-LIB":U , INPUT ? ,
                            OUTPUT p_Code ).
    IF file-list:NUM-ITEMS = 0 THEN
      ASSIGN p_Include_List = "" .
    ELSE DO:
      DO ventry = 1 TO file-list:NUM-ITEMS :
        ASSIGN p_Code = p_Code + {&EOL} + file-list:ENTRY( ventry  ).
        
        ASSIGN l_OK = file-list:REPLACE( TRIM( file-list:ENTRY( ventry  ) , 
                                              Open_Curly + " " + Close_Curly ) ,
                                         file-list:ENTRY( ventry  ) ) .
      
      END.  
      ASSIGN p_Include_List = file-list:LIST-ITEMS NO-ERROR.
    END.
    
    &IF DEFINED(UIB_is_Running) = 0 &THEN
    /* Get the ADE LIB-MGR Object handle. */
    RUN adecomm/_adeobj.p ( INPUT "LIB-MGR":U , INPUT-OUTPUT h_mlmgr ).
    
    IF (p_Include_List <> Old_List ) AND VALID-HANDLE( h_mlmgr ) THEN DO:
      RUN close-parent IN h_mlmgr (INPUT p_Parent_ID ).
      RUN open-lib IN h_mlmgr (p_Parent_ID, p_Include_List, cBrokerURL).
    END.
    &ENDIF
  END.
  
  /* Even though the user pressed OK, return TRUE only of the list
     actually changed. */
  ASSIGN p_OK = ( p_Include_List <> Old_List ).
  RUN adecomm/_setcurs.p ( INPUT "":U ).
  HIDE FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_add f_ML_Dlg
ON CHOOSE OF b_add IN FRAME f_ML_Dlg /* Add... */
DO:
  Assign lAction = "Add"
         new_file = "".
         
  DEFINE VARIABLE l_Dupe   AS LOGICAL    NO-UNDO.
  &if DEFINED(IDE-IS-RUNNING) <> 0  &then
         dialogService:SetCurrentEvent(this-procedure,"ide_choose_mlref").
         run runChildDialog in hOEIDEService (dialogService) .
   &else
    RUN adeuib/_mlref.p ( "Add", cBrokerURL,
                          INPUT-OUTPUT new_file, OUTPUT l_ok ) .
   &endif         
              
    IF NOT l_ok THEN RETURN.
    
    ASSIGN new_file = ( Open_Curly + new_file + Close_Curly).
    RUN CheckDupeItem (INPUT new_file , OUTPUT l_Dupe ).
    IF l_Dupe THEN RETURN.
    
    IF file-list:NUM-ITEMS = 0 THEN
      ASSIGN l_ok = file-list:ADD-FIRST ( new_file ) .
    ELSE
      ASSIGN l_ok = file-list:INSERT( new_file , file-list:SCREEN-VALUE ).
    
    ASSIGN file-list:SCREEN-VALUE = new_file.
    RUN set-state.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_delete f_ML_Dlg
ON CHOOSE OF b_delete IN FRAME f_ML_Dlg /* Remove */
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Modify
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Modify f_ML_Dlg
ON CHOOSE OF b_Modify IN FRAME f_ML_Dlg /* Modify... */
DO:
  RUN Modify-Selection.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_move_down
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_move_down f_ML_Dlg
ON CHOOSE OF b_move_down IN FRAME f_ML_Dlg /* Move Down */
DO:
  RUN move_item IN THIS-PROCEDURE (INPUT file-list:SCREEN-VALUE , "DOWN":U ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_move_up
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_move_up f_ML_Dlg
ON CHOOSE OF b_move_up IN FRAME f_ML_Dlg /* Move Up */
DO:
  RUN move_item IN THIS-PROCEDURE (INPUT file-list:SCREEN-VALUE , "UP":U ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME file-list
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL file-list f_ML_Dlg
ON DEFAULT-ACTION OF file-list IN FRAME f_ML_Dlg
DO:
  RUN Modify-Selection.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL file-list f_ML_Dlg
ON VALUE-CHANGED OF file-list IN FRAME f_ML_Dlg
DO:
  /* Change the sensitivity of the buttons. */
  RUN set-state.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f_ML_Dlg 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* ADE okbar.i places standard ADE OK-CANCEL-HELP buttons.              */
{adecomm/okbar.i &TOOL = "AB"
                 &CONTEXT = {&Method_Libraries_Dlg_Box} }

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
 &scoped-define CANCEL-EVENT U2
{adeuib/ide/dialogstart.i btn_ok btn_cancel wintitle}
MAIN-BLOCK:
DO ON STOP    UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN adecomm/_setcurs.p (INPUT "WAIT":U).

  FIND _P WHERE STRING(_P._window-handle) = p_parent_id NO-ERROR.
  IF AVAILABLE _P THEN
    cBrokerURL = _P._broker-url.

  RUN set-init-values.
  RUN enable_UI.
  RUN set-state.
  RUN adecomm/_setcurs.p (INPUT "":U).
  &if DEFINED(IDE-IS-RUNNING) = 0  &then
        WAIT-FOR GO OF FRAME {&FRAME-NAME}.
    &ELSE
        WAIT-FOR "choose" of btn_ok in frame {&FRAME-NAME} or "u2" of this-procedure.       
        if cancelDialog THEN UNDO, LEAVE.  
    &endif
  
END.
RUN adecomm/_setcurs.p (INPUT "":U).
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CheckDupeItem f_ML_Dlg 
PROCEDURE CheckDupeItem :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p_File_Spec AS CHAR               NO-UNDO.
    DEFINE OUTPUT PARAMETER p_Duplicate AS LOGICAL INIT FALSE NO-UNDO.

    DO WITH FRAME {&FRAME-NAME} :
        ASSIGN p_Duplicate = ( file-list:LOOKUP( p_File_Spec ) <> 0 ).
          
        IF p_Duplicate = TRUE THEN
        MESSAGE p_File_Spec SKIP(1)
                "This Method Library reference is already in the list and" SKIP
                "cannot be added again."
                VIEW-AS ALERT-BOX WARNING IN WINDOW ACTIVE-WINDOW.
    END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI f_ML_Dlg _DEFAULT-DISABLE
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
  HIDE FRAME f_ML_Dlg.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI f_ML_Dlg _DEFAULT-ENABLE
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
  ENABLE file-list b_add b_Modify b_delete b_move_up b_move_down 
      WITH FRAME f_ML_Dlg.
  VIEW FRAME f_ML_Dlg.
  {&OPEN-BROWSERS-IN-QUERY-f_ML_Dlg}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Modify-Selection f_ML_Dlg 
PROCEDURE Modify-Selection :
/*------------------------------------------------------------------------------
  Purpose:    Change the value of the currently selected file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*  DEFINE VAR l_ok     AS LOGICAL   NO-UNDO.*/
/*  DEFINE VAR new_file AS CHARACTER NO-UNDO.*/
/*  DEFINE VAR old_file AS CHARACTER NO-UNDO.*/
  DEFINE VAR item     AS CHARACTER NO-UNDO.
  DEFINE VAR l_Dupe   AS LOGICAL   NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
      Assign lAction = "Modify".
          
             
    ASSIGN new_file = TRIM( file-list:SCREEN-VALUE ,
                            Open_Curly + " " + Close_Curly )
           old_file = new_file.
   
  &if DEFINED(IDE-IS-RUNNING) <> 0  &then
         dialogService:SetCurrentEvent(this-procedure,"ide_choose_mlref").
         run runChildDialog in hOEIDEService (dialogService) .
   &else       
    RUN adeuib/_mlref.p ( "Modify", cBrokerURL,
                          INPUT-OUTPUT new_file, OUTPUT l_ok ).
   &endif                       
    IF NOT l_ok OR ( new_file = old_file ) THEN RETURN.
   
    ASSIGN new_file = Open_Curly + new_file + Close_Curly.
    RUN CheckDupeItem (INPUT new_file , OUTPUT l_Dupe ).
    IF l_Dupe THEN RETURN.

    IF new_file = file-list:SCREEN-VALUE THEN RETURN.
    
    ASSIGN l_ok     = file-list:INSERT( new_file , file-list:SCREEN-VALUE )
           l_ok     = file-list:DELETE( file-list:SCREEN-VALUE )  
           file-list:SCREEN-VALUE = new_file .
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE move_item f_ML_Dlg 
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
             file-list:SCREEN-VALUE = p_Item .
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-init-values f_ML_Dlg 
PROCEDURE set-init-values :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VAR ventry AS INTEGER NO-UNDO.
  DEFINE VAR l_OK   AS LOGICAL NO-UNDO.
  
  &IF DEFINED(UIB_is_Running) = 0 &THEN
  /* Initialize the ADE LIB-MGR Object if not already there. */
  RUN adecomm/_adeobj.p ( INPUT "LIB-MGR":U , INPUT-OUTPUT h_mlmgr ).
    
  IF VALID-HANDLE( h_mlmgr ) THEN
    RUN get-inclib-names IN h_mlmgr( p_Parent_ID, OUTPUT p_Include_List ).
  &ENDIF
  
  DO WITH FRAME {&FRAME-NAME} :
      ASSIGN file-list:LIST-ITEMS  = p_Include_List
             FRAME {&FRAME-NAME}:TITLE = FRAME {&FRAME-NAME}:TITLE + " - " +
                                         p_Object_name .
      IF file-list:NUM-ITEMS > 0 AND NOT file-list:ENTRY( 1 ) BEGINS Open_Curly THEN
      DO ventry = 1 TO file-list:NUM-ITEMS :
        ASSIGN l_OK = file-list:REPLACE( Open_Curly + file-list:ENTRY( ventry  ) +
                                         Close_Curly ,
                                         file-list:ENTRY( ventry  ) ).
      END.

      ASSIGN file-list = file-list:ENTRY( 1 ) NO-ERROR.
      DISPLAY file-list WITH FRAME {&FRAME-NAME}.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-state f_ML_Dlg 
PROCEDURE set-state :
/* -----------------------------------------------------------
  Purpose:     Change the Sensitivity of all the buttons based
               on the state of the selection-list.
  Parameters:  <none>
-------------------------------------------------------------*/
  DEF VAR cnt       AS INTEGER NO-UNDO.
  DEF VAR iSelected AS INTEGER NO-UNDO.
  
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

procedure ide_choose_mlref:
    define variable l_Dupe as logical no-undo.
    
        RUN adeuib/ide/_dialog_mlref.p ( lAction, cBrokerURL,
                          INPUT-OUTPUT new_file, OUTPUT l_ok ) .
                        
    IF lAction = "Add" then
    DO :              
           IF NOT l_ok THEN RETURN.
        
        ASSIGN new_file = ( Open_Curly + new_file + Close_Curly).
        RUN CheckDupeItem (INPUT new_file , OUTPUT l_Dupe ).
        IF l_Dupe THEN RETURN.
        
        IF file-list:NUM-ITEMS IN FRAME f_ML_Dlg = 0 THEN
          ASSIGN l_ok = file-list:ADD-FIRST ( new_file ) .
        ELSE
          ASSIGN l_ok = file-list:INSERT( new_file , file-list:SCREEN-VALUE ).
        
        ASSIGN file-list:SCREEN-VALUE = new_file.
        RUN set-state.
    END.   
    else
    do:
        IF NOT l_ok OR ( new_file = old_file ) THEN RETURN.
   
    ASSIGN new_file = Open_Curly + new_file + Close_Curly.
    RUN CheckDupeItem (INPUT new_file , OUTPUT l_Dupe ).
    IF l_Dupe THEN RETURN.

    IF new_file = file-list:SCREEN-VALUE THEN RETURN.
    
    ASSIGN l_ok     = file-list:INSERT( new_file , file-list:SCREEN-VALUE )
           l_ok     = file-list:DELETE( file-list:SCREEN-VALUE )  
           file-list:SCREEN-VALUE = new_file .
    end.               
end procedure.

