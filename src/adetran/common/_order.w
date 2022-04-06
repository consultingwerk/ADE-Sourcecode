&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* 


Procedure:    adetran/common/_order.w
Author:       
Created:      
Updated:      11/96 SLK Replace IMAGE button's w/ labels to use Tooltip
Purpose:      VT and PM both use this routine 
Called By:    

*/
{ adetran/vt/vthlp.i }    /* definitions for VT help strings */ 
{ adetran/pm/tranhelp.i } /* definitions for TM help strings */

define input parameter hOrdProcedure as handle no-undo.  
define input parameter CurrentTool as char no-undo. 
 
define SHARED VAR CurrentMode as integer no-undo. 
define SHARED VAR OrdMode2 as char no-undo.
define SHARED VAR OrdMode3 as char no-undo.

define var SortExpr as char no-undo.
define var TempFile as char no-undo. 
define var result as logical no-undo.
DEFINE VARIABLE tCnt AS INTEGER NO-UNDO.
DEFINE VARIABLE tLog AS LOGICAL NO-UNDO. 
DEFINE VARIABLE tChar AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-5 BtnOK SELECT-1 BtnInsert SELECT-2 ~
BtnCancel BtnRemove BtnHelp BtnUp BtnDown AvailLabel SelLabel 
&Scoped-Define DISPLAYED-OBJECTS SELECT-1 SELECT-2 AvailLabel SelLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY 
     LABEL "Cancel":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnDown 
     IMAGE-UP FILE "adetran/images/down":U
     LABEL "Down" 
     SIZE 3.2 BY .86 TOOLTIP "Down".

DEFINE BUTTON BtnHelp 
     LABEL "&Help":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnInsert 
     IMAGE-UP FILE "adetran/images/next":U
     LABEL "Insert" 
     SIZE 3.2 BY .86 TOOLTIP "Insert".

DEFINE BUTTON BtnOK AUTO-GO 
     LABEL "OK":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnRemove 
     IMAGE-UP FILE "adetran/images/prev":U
     LABEL "Remove" 
     SIZE 3.2 BY .86 TOOLTIP "Remove".

DEFINE BUTTON BtnUp 
     IMAGE-UP FILE "adetran/images/up":U
     LABEL "Up" 
     SIZE 3.2 BY .86 TOOLTIP "Up".

DEFINE VARIABLE AvailLabel AS CHARACTER FORMAT "X(256)":U INITIAL "&Available:" 
      VIEW-AS TEXT 
     SIZE 20 BY .67 NO-UNDO.

DEFINE VARIABLE SelLabel AS CHARACTER FORMAT "X(256)":U INITIAL "&Selected:" 
      VIEW-AS TEXT 
     SIZE 20 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 50.8 BY 5.29.

DEFINE VARIABLE SELECT-1 AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     SIZE 20 BY 3.67 NO-UNDO.

DEFINE VARIABLE SELECT-2 AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     SIZE 20 BY 3.67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     BtnOK AT ROW 1.52 COL 54.6
     SELECT-1 AT ROW 2.52 COL 4.4 NO-LABEL
     BtnInsert AT ROW 2.52 COL 26
     SELECT-2 AT ROW 2.52 COL 30.4 NO-LABEL
     BtnCancel AT ROW 2.71 COL 54.6
     BtnRemove AT ROW 3.33 COL 26
     BtnHelp AT ROW 3.91 COL 54.6
     BtnUp AT ROW 4.57 COL 26
     BtnDown AT ROW 5.38 COL 26
     AvailLabel AT ROW 1.76 COL 4.4 NO-LABEL
     SelLabel AT ROW 1.76 COL 30.4 NO-LABEL
     RECT-5 AT ROW 1.52 COL 2
     SPACE(16.80) SKIP(0.49)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Order Columns":L
         DEFAULT-BUTTON BtnOK.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DIALOG-1
   L-To-R                                                               */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN AvailLabel IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN SelLabel IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DIALOG-1 DIALOG-1
ON ALT-A OF FRAME DIALOG-1 /* Order Columns */
DO:
  APPLY "ENTRY" TO SELECT-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DIALOG-1 DIALOG-1
ON ALT-S OF FRAME DIALOG-1 /* Order Columns */
DO:
  APPLY "ENTRY" TO SELECT-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDown DIALOG-1
ON CHOOSE OF BtnDown IN FRAME DIALOG-1 /* Down */
DO:
  RUN MoveItem("D":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp DIALOG-1
ON CHOOSE OF BtnHelp IN FRAME DIALOG-1 /* Help */
OR HELP OF FRAME {&FRAME-NAME} DO:
  if CurrentTool = "VT" then
    run adecomm/_adehelp.p ("vt":u,"context":u,{&VT_Order_Columns_Dialog_Box}, ?).      
  else
    run adecomm/_adehelp.p ("tran":u,"context":u,{&Order_Columns_Dlgbx}, ?).       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnInsert
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnInsert DIALOG-1
ON CHOOSE OF BtnInsert IN FRAME DIALOG-1 /* Insert */
DO:   
  /* for multi-selection */                                           
  tChar = (SELECT-1:SCREEN-VALUE).
  DO tCnt = 1 TO NUM-ENTRIES(tChar):
     tLog = SELECT-2:ADD-LAST(ENTRY(tcnt,tChar)).
  END.
  DO tCnt = 1 TO NUM-ENTRIES(tChar):  
     tLog = SELECT-1:DELETE(ENTRY(tcnt,tChar)).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOK DIALOG-1
ON CHOOSE OF BtnOK IN FRAME DIALOG-1 /* OK */
DO:                                        
   IF CurrentMode = 2 THEN
      RUN OrderColumn IN hOrdProcedure(INPUT-OUTPUT OrdMode2,SELECT-2:LIST-ITEMS).
   ELSE                                                          
      RUN OrderColumn IN hOrdProcedure(INPUT-OUTPUT OrdMode3,SELECT-2:LIST-ITEMS).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnRemove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnRemove DIALOG-1
ON CHOOSE OF BtnRemove IN FRAME DIALOG-1 /* Remove */
DO:
   /* for multi-selection */
   tChar = SELECT-2:SCREEN-VALUE.
   DO tCnt = 1 TO NUM-ENTRIES(tChar):
      tLog = SELECT-1:ADD-LAST(ENTRY(tcnt,tChar)).
   END.                                              
   DO tCnt = 1 TO NUM-ENTRIES(tChar):
      tLog = SELECT-2:DELETE(ENTRY(tcnt,tChar)).
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnUp DIALOG-1
ON CHOOSE OF BtnUp IN FRAME DIALOG-1 /* Up */
DO:
  RUN MoveItem("U":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SELECT-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SELECT-1 DIALOG-1
ON MOUSE-SELECT-DBLCLICK OF SELECT-1 IN FRAME DIALOG-1
DO:
  APPLY "CHOOSE":u TO BtnInsert.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SELECT-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SELECT-2 DIALOG-1
ON MOUSE-SELECT-DBLCLICK OF SELECT-2 IN FRAME DIALOG-1
DO:
  APPLY "CHOOSE":u TO BtnRemove.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN Realize.
                            
  assign
    AvailLabel:screen-value = "&Available:"
    SelLabel:screen-value   = "&Selected:"
    select-1:list-items     = if CurrentMode = 2 then OrdMode2 else OrdMode3.
  
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1  _DEFAULT-DISABLE
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
  HIDE FRAME DIALOG-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MoveItem DIALOG-1 
PROCEDURE MoveItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pChar AS CHAR FORMAT "X(1)":u NO-UNDO.
   DEFINE VAR vMoveItem AS CHAR NO-UNDO.
   DEFINE VAR vMoveList AS CHAR NO-UNDO.
   DEFINE VAR vOldPos AS INT NO-UNDO.
   DEFINE VAR vListSize AS INT NO-UNDO.
   DEFINE VAR vNewPos AS INT NO-UNDO.

   IF SELECT-2:SCREEN-VALUE IN FRAME {&Frame-Name} = ? 
      OR NUM-ENTRIES(SELECT-2:SCREEN-VALUE) GT 1 THEN
      RETURN.
  
   ASSIGN vMoveItem = SELECT-2:SCREEN-VALUE IN FRAME {&Frame-Name}
          vMoveList = SELECT-2:LIST-ITEMS IN FRAME {&Frame-Name}
          vOldPos = LOOKUP(vMoveItem,vMoveList)
          vListSize = NUM-ENTRIES(vMoveList).
             
   IF vListSize = 1 OR
      (pChar = "U":u AND vOldPos EQ 1) OR
      (pChar = "D":u AND vOldPos = vListSize) THEN
      RETURN.

   IF pChar = "U":u THEN 
      ASSIGN vNewPos = vOldPos - 1.
   ELSE vNewPos = vOldPos + 1.

   ASSIGN                     
     tLog = SELECT-2:DELETE(vOldPos) IN FRAME {&Frame-Name}
     tLog = SELECT-2:INSERT(vMoveItem,vNewPos) IN FRAME {&Frame-Name}
     SELECT-2:SCREEN-VALUE IN FRAME {&Frame-Name} = vMoveItem .
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize DIALOG-1 
PROCEDURE Realize :
enable
    Select-1 
    BtnInsert
    BtnRemove
    BtnUp
    BtnDown  
    Select-2
    BtnOk
    BtnCancel
    BtnHelp
  with frame {&frame-name}.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

