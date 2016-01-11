&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dlg_Methods
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dlg_Methods 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File    :    _inscall.w
  Purpose :    Section Editor Insert Procedure Call Dialog Box for V9+.
  Syntax  :    
            RUN adeuib/_inscall.w ( INPUT  p_Objects      ,
                                    INPUT  p_This_Methods ,
                                    INPUT  p_This_Funcs   ,
                                    INPUT  p_Super_Handles,
                                    OUTPUT p_Command      ,
                                    OUTPUT p_Return_Value ,
                                    OUTPUT p_OK           ) .
  
  Description: 

  Input Parameters:
    Yes. See Definitions section for input parameters.

  Output Parameters:
    p_Command      - "_INSERT" - Insert Code.
                     "_LOCAL"  - Create Local Method.
    p_Return_Value - If p_Command is "_INSERT", then the string to be inserted.
                     If p_Command is "_LOCAL", then string "local-<method>"
                     is returned for the Section Editor to create a local
                     override method.
                     
    p_OK           - TRUE means user choose OK. FALSE means user choose Cancel.

  Author:    J. Palazzo
  Created: 04/20/95
  Modified:
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE NEW GLOBAL SHARED VARIABLE web-utilities-hdl AS HANDLE NO-UNDO.

DEFINE SHARED VAR _h_mlmgr AS HANDLE NO-UNDO. /* Defined in sharvars.i */

&GLOBAL-DEFINE WIN95-BTN YES

/* Parameters Definitions ---                                           */
&IF DEFINED(UIB_is_Running) = 0 &THEN
DEFINE INPUT  PARAMETER p_Objects       AS CHARACTER NO-UNDO .
    /* Delimited List of "ObjName1 ObjHandle1,ObjName2 ObjHandle2" pairs.   */
DEFINE INPUT  PARAMETER p_This_Methods  AS CHARACTER NO-UNDO .
    /* Comma-delimited list of THIS-PROCEDURE methods. */
DEFINE INPUT  PARAMETER p_This_Funcs    AS CHARACTER NO-UNDO .
    /* Comma-delimited list of THIS-PROCEDURE functions. */
DEFINE INPUT  PARAMETER p_Super_Handles AS CHARACTER NO-UNDO .
    /* Comma-delimited list of THIS-PROCEDURE super procedure handles. */
DEFINE INPUT  PARAMETER p_Proc_Id       AS RECID     NO-UNDO .
    /* RECID of procedure's _P record. */
DEFINE OUTPUT PARAMETER p_Command AS CHARACTER NO-UNDO .
    /* Command to be carried out by caller.     */
DEFINE OUTPUT PARAMETER p_Return_Value  AS CHARACTER NO-UNDO .
    /* String value to return to caller.        */
DEFINE OUTPUT PARAMETER p_OK            AS LOGICAL   NO-UNDO .
    /* YES - User choose OK. NO - User choose Cancel.       */
&ELSE
DEFINE VAR p_Objects       AS CHARACTER NO-UNDO INIT "THIS-PROCEDURE":u.
DEFINE VAR p_This_Methods  AS CHARACTER NO-UNDO
           INIT "adm-exit,adm-hello,enable_UI,disable_UI,local-exit":u .
DEFINE VAR p_This_Funcs    AS CHARACTER NO-UNDO
           INIT "getToday,getNext":u .
DEFINE VAR p_Super_Handles AS CHARACTER NO-UNDO .
DEFINE VAR p_Proc_Id       AS RECID     NO-UNDO .
DEFINE VAR p_Command       AS CHARACTER NO-UNDO INIT "_INSERT":u.
DEFINE VAR p_Return_Value  AS CHARACTER NO-UNDO .
DEFINE VAR p_OK            AS LOGICAL   NO-UNDO .
&ENDIF

{adeuib/uniwidg.i}
{adeuib/triggers.i}

{adecomm/adestds.i}        /* Standared ADE Preprocessor Directives */
IF NOT initialized_adestds
THEN RUN adecomm/_adeload.p.

{adeuib/uibhlp.i}          /* Help File Preprocessor Directives     */

DEFINE BUFFER x_P FOR _P.

/* Preprocessor Definitions ---                                    */
&GLOBAL-DEFINE EOL CHR(10)

/* Local VAR Definitions ---                                       */

DEFINE VAR Nul           AS CHARACTER    NO-UNDO INIT "":U .
DEFINE VAR Unknown       AS CHARACTER    NO-UNDO INIT ? .
DEFINE VAR Space_Char    AS CHARACTER    NO-UNDO INIT " ".
DEFINE VAR Init_Type     AS CHARACTER    NO-UNDO .
DEFINE VAR Smart_Prefix  AS CHARACTER    NO-UNDO INIT "adm-":U .
DEFINE VAR Local_Prefix  AS CHARACTER    NO-UNDO INIT "local-":U .
DEFINE VAR Broker_Prefix AS CHARACTER    NO-UNDO INIT "broker-":U .
DEFINE VAR Type_Proc     AS CHARACTER    NO-UNDO INIT "_PROCEDURE":U .
DEFINE VAR Type_Function AS CHARACTER    NO-UNDO INIT "_FUNCTION":U .

DEFINE VAR hObject       AS HANDLE       NO-UNDO.
DEFINE VAR NameList      AS CHARACTER    NO-UNDO.
DEFINE VAR ProcList      AS CHARACTER    NO-UNDO.
DEFINE VAR FuncList      AS CHARACTER    NO-UNDO.

DEFINE VAR This_Procedure AS CHARACTER   NO-UNDO INIT "THIS-PROCEDURE".
DEFINE VAR This_Procs     AS CHARACTER   NO-UNDO.
DEFINE VAR This_Funcs     AS CHARACTER   NO-UNDO.
DEFINE VAR None           AS CHARACTER   NO-UNDO INIT "(None)".
DEFINE VAR Local_Marker   AS CHARACTER   NO-UNDO INIT " *".
DEFINE VAR Insert_Cmd     AS CHARACTER   NO-UNDO INIT "_INSERT":u.
DEFINE VAR Local_Cmd      AS CHARACTER   NO-UNDO INIT "_LOCAL":u.
DEFINE VAR Dispatch_Cmd   AS CHARACTER   NO-UNDO INIT "_DISPATCH":u.
DEFINE VAR Notify_Cmd     AS CHARACTER   NO-UNDO INIT "_NOTIFY":u.
DEFINE VAR Run_Cmd        AS CHARACTER   NO-UNDO INIT "_RUN-IN":u.
DEFINE VAR Ret_Val        AS LOGICAL     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dlg_Methods

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Name Type Method_List btn_v8_inscall ~
Btn_About_Sel Insert_Code 
&Scoped-Define DISPLAYED-OBJECTS Name Type Method_List Insert_Code ~
Label_ProcObj Label_ProcObj-2 Label_InsertCode 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetFuncCode Dlg_Methods 
FUNCTION GetFuncCode RETURNS CHARACTER
  ( /* parameter-definitions */
    INPUT p_Name        AS CHARACTER,
    INPUT p_ObjHandle   AS HANDLE,
    INPUT p_Func_Name   AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetRunCode Dlg_Methods 
FUNCTION GetRunCode RETURNS CHARACTER
  ( /* parameter-definitions */
    INPUT p_Name        AS CHARACTER,
    INPUT p_ObjHandle   AS HANDLE,
    INPUT p_Method_Name AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetSignatureFunc Dlg_Methods 
FUNCTION GetSignatureFunc RETURNS CHARACTER
  ( INPUT p_hObject AS HANDLE, INPUT p_Name AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetSignatureProc Dlg_Methods 
FUNCTION GetSignatureProc RETURNS CHARACTER
  ( INPUT p_hObject AS HANDLE, INPUT p_Name AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_About_Sel 
     LABEL "&About Entry" 
     SIZE 15 BY 1.14.

DEFINE BUTTON btn_v8_inscall 
     LABEL "V8 Call..." 
     SIZE 15 BY 1.14.

DEFINE VARIABLE Name AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 8
     SIZE 71 BY 1 NO-UNDO.

DEFINE VARIABLE Insert_Code AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 71 BY 5.57
     FONT 2 NO-UNDO.

DEFINE VARIABLE Label_InsertCode AS CHARACTER FORMAT "X(256)":U 
     LABEL "Code to &Insert" 
      VIEW-AS TEXT 
     SIZE 2 BY .81 NO-UNDO.

DEFINE VARIABLE Label_ProcObj AS CHARACTER FORMAT "X(256)":U 
     LABEL "Procedure &Object" 
      VIEW-AS TEXT 
     SIZE 2 BY .81 NO-UNDO.

DEFINE VARIABLE Label_ProcObj-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Entries in Object" 
      VIEW-AS TEXT 
     SIZE 2 BY .81 NO-UNDO.

DEFINE VARIABLE Type AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "&Procedures", "_PROCEDURE",
"&Functions", "_FUNCTION"
     SIZE 31 BY 1.1 NO-UNDO.

DEFINE VARIABLE Method_List AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SORT 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 71 BY 6.29 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dlg_Methods
     Name AT ROW 2.1 COL 2 NO-LABEL
     Type AT ROW 3.38 COL 24 NO-LABEL
     Method_List AT ROW 4.48 COL 2 NO-LABEL
     btn_v8_inscall AT ROW 11 COL 30
     Btn_About_Sel AT ROW 11 COL 58
     Insert_Code AT ROW 12.57 COL 2 NO-LABEL
     Label_ProcObj AT ROW 1.24 COL 18 COLON-ALIGNED
     Label_ProcObj-2 AT ROW 3.62 COL 17 COLON-ALIGNED
     Label_InsertCode AT ROW 11.71 COL 15 COLON-ALIGNED
     SPACE(54.99) SKIP(5.90)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Insert Procedure Call".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dlg_Methods
                                                                        */
ASSIGN 
       FRAME Dlg_Methods:SCROLLABLE       = FALSE
       FRAME Dlg_Methods:HIDDEN           = TRUE.

ASSIGN 
       Insert_Code:AUTO-INDENT IN FRAME Dlg_Methods      = TRUE
       Insert_Code:RETURN-INSERTED IN FRAME Dlg_Methods  = TRUE.

/* SETTINGS FOR FILL-IN Label_InsertCode IN FRAME Dlg_Methods
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Label_ProcObj IN FRAME Dlg_Methods
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Label_ProcObj-2 IN FRAME Dlg_Methods
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX Name IN FRAME Dlg_Methods
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dlg_Methods
/* Query rebuild information for DIALOG-BOX Dlg_Methods
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX Dlg_Methods */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dlg_Methods
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dlg_Methods Dlg_Methods
ON ALT-E OF FRAME Dlg_Methods /* Insert Procedure Call */
ANYWHERE
DO:
    APPLY "ENTRY" TO Method_List.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dlg_Methods Dlg_Methods
ON ALT-I OF FRAME Dlg_Methods /* Insert Procedure Call */
ANYWHERE
DO:
    APPLY "ENTRY" TO Insert_Code.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dlg_Methods Dlg_Methods
ON ALT-O OF FRAME Dlg_Methods /* Insert Procedure Call */
ANYWHERE
DO:
    APPLY "ENTRY" TO Name.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dlg_Methods Dlg_Methods
ON GO OF FRAME Dlg_Methods /* Insert Procedure Call */
DO:
  DEFINE VAR vMethod AS CHARACTER NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME} :
    ASSIGN p_OK   = TRUE .
    CASE p_Command :
        WHEN Insert_Cmd THEN
        DO:
            ASSIGN p_Return_Value = TRIM(Insert_Code:SCREEN-VALUE) NO-ERROR.
            ASSIGN p_OK = (p_Return_Value <> Nul).
        END.
        
        WHEN Local_Cmd THEN
        DO:
            ASSIGN VMethod = REPLACE( Method_List:SCREEN-VALUE ,
                                      Local_Marker , Nul )
                   p_Return_Value = REPLACE(vMethod ,
                                            Smart_Prefix, Local_Prefix )
                   . /* END ASSIGN */
        END.
        
        OTHERWISE
        DO:
          IF p_Command BEGINS "_V8":U THEN
            ASSIGN p_Command = REPLACE(p_Command, "_V8":U, "").
        END.
        
    END CASE.
    
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_About_Sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_About_Sel Dlg_Methods
ON CHOOSE OF Btn_About_Sel IN FRAME Dlg_Methods /* About Entry */
DO:
  DEFINE VAR vMethod   AS CHARACTER NO-UNDO.
  DEFINE VAR HelpFound AS LOGICAL   NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME} :
  
    ASSIGN vMethod = REPLACE( Method_List:SCREEN-VALUE , Local_Marker , Nul ) .
    IF Name:SCREEN-VALUE <> This_Procedure THEN
    DO:
        RUN GetObjHandle IN THIS-PROCEDURE
            ( INPUT Name:SCREEN-VALUE , INPUT NameList ,
              INPUT p_Objects ,  OUTPUT hObject ).
        IF LOOKUP( "object-help":U , hObject:INTERNAL-ENTRIES ) <> 0 THEN
        DO:
            RUN object-help IN hObject
                ( INPUT  ""            /* Help File      */,
                  INPUT  "PARTIAL-KEY" /* Help Command   */,
                  INPUT  ?             /* Context Number */,
                  INPUT  vMethod       /* Search String  */,
                  OUTPUT HelpFound     /* Found Help?    */).
            IF HelpFound THEN RETURN.
        END.
    END.
    
    RUN adecomm/_adehelp.p
        (INPUT "AB" , INPUT "PARTIAL-KEY" , INPUT ? , INPUT vMethod).
    
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_v8_inscall
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_v8_inscall Dlg_Methods
ON CHOOSE OF btn_v8_inscall IN FRAME Dlg_Methods /* V8 Call... */
DO:
    RUN adeuib/_inscal8.w
      (INPUT  p_Objects ,
       INPUT  p_This_Methods ,
       INPUT  p_Proc_Id,
       OUTPUT p_Command      ,
       OUTPUT p_Return_Value ,
       OUTPUT p_OK           ) .

    IF p_OK THEN
    DO:
      ASSIGN p_Command = "_V8":U + p_Command.
      APPLY "GO":U TO FRAME {&FRAME-NAME}.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Method_List
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Method_List Dlg_Methods
ON DEFAULT-ACTION OF Method_List IN FRAME Dlg_Methods
DO:  
  APPLY "GO" TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Method_List Dlg_Methods
ON VALUE-CHANGED OF Method_List IN FRAME Dlg_Methods
DO:
  RUN SetSensitive ( INPUT Type:SCREEN-VALUE ) .
  RUN DispInsertCode.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Name
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Name Dlg_Methods
ON VALUE-CHANGED OF Name IN FRAME Dlg_Methods
DO:
  DO WITH FRAME {&FRAME-NAME} :
    RUN SetState IN THIS-PROCEDURE ( INPUT Type:SCREEN-VALUE ).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Type Dlg_Methods
ON VALUE-CHANGED OF Type IN FRAME Dlg_Methods
DO:
    RUN SetState ( INPUT Type:SCREEN-VALUE ) .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dlg_Methods 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT = ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* ADE okbar.i places standard ADE OK-CANCEL-HELP buttons.              */
{adecomm/okbar.i &TOOL = "AB"
                 &CONTEXT = {&Insert_Procedure_Call_Dlg_Box} }

/* Position the V8 Call Button button next to Cancel. */
ASSIGN btn_v8_inscall:HEIGHT = btn_Cancel:HEIGHT
       btn_v8_inscall:ROW    = btn_Cancel:ROW
       btn_v8_inscall:COL    = (btn_Cancel:COL + btn_Cancel:WIDTH) + 1
       . /* END ASSIGN */
                 
/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Override the okbar.i help trigger on HELP of FRAME to process
   keyword help in the Insert Code editor widget.
*/
ON HELP OF FRAME {&FRAME-NAME} DO:
    RUN adecomm/_kwhelp.p
        ( INPUT Insert_Code:HANDLE ,
          INPUT "AB", INPUT {&Insert_Procedure_Call_Dlg_Box} ).
END.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON STOP    UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN StartPersistentObjects.
  RUN SetInitValues.
  RUN enable_UI.
  RUN SetState ( INPUT Init_Type ).
  ASSIGN FRAME {&FRAME-NAME}:VISIBLE = TRUE.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuildNameList Dlg_Methods 
PROCEDURE BuildNameList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_Objects  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_NameList AS CHARACTER NO-UNDO.
  
  DEFINE VAR ObjPair AS CHARACTER NO-UNDO.
  DEFINE VAR vItem   AS INTEGER   NO-UNDO.
  
  IF (p_Objects = "") OR (p_Objects = This_Procedure) THEN
  DO:
    ASSIGN p_NameList = This_Procedure.
    RETURN.
  END.
  
  /* Process "ObjName ObjHandle, ObjName ObjHandle" pairs. */
  DO vItem = 1 TO NUM-ENTRIES( p_Objects ) :
    ASSIGN ObjPair    = ENTRY( vItem , p_Objects )
           p_NameList = p_NameList + "," + ENTRY( 1 , ObjPair , " " ).
  END.
  ASSIGN p_NameList = TRIM( p_NameList , "," ).

  /* Make sure THIS-PROCEDURE is placed in the dialog's version of
     it (stored in This_Procedure variable in definitions section).
  */
  ASSIGN p_NameList = REPLACE(p_NameList, "THIS-PROCEDURE" , This_Procedure).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dlg_Methods  _DEFAULT-DISABLE
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
  HIDE FRAME Dlg_Methods.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DispInsertCode Dlg_Methods 
PROCEDURE DispInsertCode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
    IF Method_List:SCREEN-VALUE = None THEN
        ASSIGN p_Return_Value = "".
    ELSE
        RUN GetInsertCode (OUTPUT p_Return_Value).
    
    ASSIGN Insert_Code:SCREEN-VALUE = p_Return_Value.

  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dlg_Methods  _DEFAULT-ENABLE
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
  DISPLAY Name Type Method_List Insert_Code Label_ProcObj Label_ProcObj-2 
          Label_InsertCode 
      WITH FRAME Dlg_Methods.
  ENABLE Name Type Method_List btn_v8_inscall Btn_About_Sel Insert_Code 
      WITH FRAME Dlg_Methods.
  VIEW FRAME Dlg_Methods.
  {&OPEN-BROWSERS-IN-QUERY-Dlg_Methods}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDispatchCode Dlg_Methods 
PROCEDURE GetDispatchCode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_Method_Name AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER p_Object_Name AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Code        AS CHARACTER NO-UNDO.
  
  ASSIGN p_Object_Name = "THIS-PROCEDURE" WHEN (p_Object_Name = This_Procedure) 
         p_Method_Name = SUBSTRING(p_Method_Name , 5, -1, "CHARACTER")
         p_Code = "RUN dispatch IN " + p_Object_Name + " ('" + p_Method_Name + "':U).".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetFuncList Dlg_Methods 
PROCEDURE GetFuncList :
/*------------------------------------------------------------------------------
  Purpose:     Returns a list of internal functions available of the object
               available to be run by THIS-PROCEDURE.
  Parameters:  See list below.
  Notes:       List is comma-delimited.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_ObjHandle   AS HANDLE    NO-UNDO.
  DEFINE INPUT  PARAMETER p_all_list    AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_FuncList    AS CHARACTER NO-UNDO.
  
  IF VALID-HANDLE(p_ObjHandle) THEN
  DO:
      /* Build list of the object's internal functions. Although the call
         is to get-super-funcs, it just returns the object's internal-entries
         that are functions. */
      RUN get-super-funcs IN _h_mlmgr (INPUT STRING(p_ObjHandle),
                                       INPUT-OUTPUT p_FuncList).
    
      /* If the object is a not a Super Procedure of THIS-PROCEDURE, then
         add the internal functions for all Super Procedures of the object.
         For example, if p_ObjHandle is a SmartObject, it will not be one of 
         THIS-PROCEDURE's Super Procedures. So we do want to retrieve its Super 
         Procedure internal functions.
         
         If the object is a Super Procedure of THIS-PROCEDURE, then there is no 
         need to search its Super Procedure's, because the 4GL doesn't use them 
         as part of THIS-PROCEDURE's runnable entries.
      */
         
      IF LOOKUP(STRING(p_ObjHandle), p_Super_Handles) = 0 AND
         (p_ObjHandle:SUPER-PROCEDURES <> "") THEN
          RUN get-super-funcs IN _h_mlmgr (INPUT p_ObjHandle:SUPER-PROCEDURES,
                                           INPUT-OUTPUT p_FuncList).
  END.
  ELSE
  DO:
    ASSIGN p_FuncList = p_all_list.
  END.
    
  ASSIGN p_FuncList = TRIM(p_FuncList , ",").
  IF (p_FuncList = "") THEN
    ASSIGN p_FuncList = None.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetInsertCode Dlg_Methods 
PROCEDURE GetInsertCode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER p_Ret_Value AS CHARACTER NO-UNDO.
  
  DEFINE VAR vMethod AS CHARACTER NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
  
    ASSIGN vMethod = REPLACE( Method_List:SCREEN-VALUE , Local_Marker , Nul ).
    CASE Type:SCREEN-VALUE :
         
        WHEN Type_Proc THEN
          p_Ret_Value = GetRunCode
                           (INPUT  Name:SCREEN-VALUE ,
                            INPUT  hObject ,
                            INPUT  vMethod ).

        WHEN Type_Function THEN
            p_Ret_Value = GetFuncCode
                           (INPUT  Name:SCREEN-VALUE ,
                            INPUT  hObject ,
                            INPUT  vMethod ).

    END CASE.
  
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetObjHandle Dlg_Methods 
PROCEDURE GetObjHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_Name     AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER p_NameList AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER p_Objects  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_hObject  AS HANDLE    NO-UNDO.
  
  DEFINE VAR ObjPair AS CHARACTER NO-UNDO.
  DEFINE VAR vItem   AS INTEGER   NO-UNDO.
  
  DO vItem = 1 TO NUM-ENTRIES( p_NameList ):
    IF ( p_Name <> ENTRY( vItem , p_NameList ) ) THEN NEXT.

    ASSIGN ObjPair   = ENTRY( vItem , p_Objects ).
    ASSIGN p_hObject = WIDGET-HANDLE( ENTRY( 2 , ObjPair , " " ) ).
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetProcList Dlg_Methods 
PROCEDURE GetProcList :
/*------------------------------------------------------------------------------
  Purpose:     Returns a list of internal procedures available of the object
               available to be run by THIS-PROCEDURE.
  Parameters:  See list below.
  Notes:       List is comma-delimited.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_ObjHandle   AS HANDLE    NO-UNDO.
  DEFINE INPUT  PARAMETER p_all_list    AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_ProcList    AS CHARACTER NO-UNDO.
  
  IF VALID-HANDLE(p_ObjHandle) THEN
  DO:
      /* Build list of the object's internal procedures. Although the call
         is to get-super-procs, it just returns the object's internal-entries
         that are procedures. */
      RUN get-super-procs IN _h_mlmgr (INPUT STRING(p_ObjHandle),
                                       INPUT-OUTPUT p_ProcList).
    
      /* If the object is a not a Super Procedure of THIS-PROCEDURE, then
         add the internal procedures for all Super Procedures of the object.
         For example, if p_ObjHandle is a SmartObject, it will not be one of 
         THIS-PROCEDURE's Super Procedures. So we do want to retrieve its Super 
         Procedure internal procedures.
         
         If the object is a Super Procedure of THIS-PROCEDURE, then there is no 
         need to search its Super Procedure's, because the 4GL doesn't use them 
         as part of THIS-PROCEDURE's runnable entries.
      */

      IF LOOKUP(STRING(p_ObjHandle), p_Super_Handles) = 0 AND
         (p_ObjHandle:SUPER-PROCEDURES <> "") THEN
          RUN get-super-procs IN _h_mlmgr (INPUT p_ObjHandle:SUPER-PROCEDURES,
                                           INPUT-OUTPUT p_ProcList).
  END.
  ELSE
  DO:
    ASSIGN p_ProcList = p_all_list.
  END.
    
  ASSIGN p_ProcList = TRIM(p_ProcList , ",").
  IF (p_ProcList = "") THEN
    ASSIGN p_ProcList = None.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetInitValues Dlg_Methods 
PROCEDURE SetInitValues :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME} :

/* testing */

/*
assign p_Objects = p_Objects + " 0".
def var h as handle.
assign h = session:first-procedure.
do while valid-handle(h):
  assign p_objects = p_objects + "," + h:file-name + " " + string(h)
         h = h:next-sibling
         .
end.
assign p_objects = trim(p_objects , ",").
*/

      RUN BuildNameList (INPUT p_Objects , OUTPUT NameList ).
      RUN GetProcList IN THIS-PROCEDURE
          (INPUT ?, INPUT p_This_Methods , OUTPUT This_Procs).
      RUN GetFuncList IN THIS-PROCEDURE
          (INPUT ?, INPUT p_This_Funcs , OUTPUT This_Funcs).
          
      ASSIGN Name:LIST-ITEMS   = NameList
             Name:SCREEN-VALUE = This_Procedure
             Name:INNER-LINES  = 8
             Init_Type         = (IF This_Procs = Nul
                                  THEN Type_Function ELSE Type_Proc)
             p_Command         = Insert_Cmd
             . /* END ASSIGN */

      RUN SetState IN THIS-PROCEDURE
          ( INPUT Init_Type ).
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetMethodList Dlg_Methods 
PROCEDURE SetMethodList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_MethodList AS CHARACTER NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME} :
    IF (p_MethodList = "") THEN ASSIGN p_MethodList = None.
    ASSIGN Method_List:LIST-ITEMS   = p_MethodList
           Method_List:SCREEN-VALUE = Method_List:ENTRY(1)
           Method_List              = Method_List:SCREEN-VALUE
           . /* END ASSIGN */
  END.
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetSensitive Dlg_Methods 
PROCEDURE SetSensitive :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
-------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_State    AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE Ret_Val           AS LOGICAL      NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME} :
  
    CASE p_State :
      WHEN Type_Proc THEN
      DO:
        ASSIGN 
               Btn_About_Sel:SENSITIVE  = TRUE
               Btn_About_Sel:LABEL        = REPLACE(Btn_About_Sel:LABEL,
                                                    "Function","Procedure")
               . /* END ASSIGN */
      END.
             
      WHEN Type_Function THEN
      DO:
        ASSIGN
               Btn_About_Sel:SENSITIVE = TRUE
               Btn_About_Sel:LABEL        = REPLACE(Btn_About_Sel:LABEL,
                                                    "Function","Procedure")
               . /* END ASSIGN */
      END.
    END CASE.

    IF Method_List:LIST-ITEMS = None THEN
      ASSIGN Btn_About_Sel:SENSITIVE    = FALSE
             . /* END ASSIGN */
    
    IF (Name:SCREEN-VALUE = None) THEN
      ASSIGN Type:SENSITIVE = FALSE.
      
  END. /* DO WITH FRAME */
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetState Dlg_Methods 
PROCEDURE SetState :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_State    AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE Ret_Val           AS LOGICAL      NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME} :
    CASE p_State :
    
        WHEN Type_Proc THEN
        DO:
            ASSIGN Type:SCREEN-VALUE    = Type_Proc.
            CASE Name:SCREEN-VALUE:
                WHEN This_Procedure THEN
                DO:
                    ASSIGN ProcList = This_Procs .
                    RUN SetMethodList IN THIS-PROCEDURE
                        ( INPUT ProcList ).   
                END.
                
                OTHERWISE
                DO:
                    RUN GetObjHandle IN THIS-PROCEDURE
                        ( INPUT Name:SCREEN-VALUE , INPUT NameList ,
                          INPUT p_Objects ,  OUTPUT hObject ).
                    RUN GetProcList IN THIS-PROCEDURE
                        ( INPUT hObject, INPUT hObject:INTERNAL-ENTRIES , OUTPUT ProcList ).
                    RUN SetMethodList IN THIS-PROCEDURE
                        ( INPUT ProcList ).   
                END.
            END CASE.
            
        END.
        
        WHEN Type_Function THEN
        DO:
            ASSIGN Type:SCREEN-VALUE    = Type_Function.
            CASE Name:SCREEN-VALUE:
                WHEN This_Procedure THEN
                DO:
                    ASSIGN FuncList = This_Funcs .
                    RUN SetMethodList IN THIS-PROCEDURE
                        ( INPUT FuncList ).   
                END.
                
                OTHERWISE
                DO:
                    RUN GetObjHandle IN THIS-PROCEDURE
                        ( INPUT Name:SCREEN-VALUE , INPUT NameList ,
                          INPUT p_Objects ,  OUTPUT hObject ).
                    RUN GetFuncList IN THIS-PROCEDURE
                        ( INPUT hObject, INPUT hObject:INTERNAL-ENTRIES , OUTPUT FuncList ).
                    RUN SetMethodList IN THIS-PROCEDURE
                        ( INPUT FuncList ).   
                END.
            END CASE.
        END.
    END CASE.
    
    RUN SetSensitive IN THIS-PROCEDURE ( INPUT p_State ).   
    RUN DispInsertCode.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE StartPersistentObjects Dlg_Methods 
PROCEDURE StartPersistentObjects :
/*------------------------------------------------------------------------------
  Purpose:     Starts any other persistent objects that should be added.
  Parameters:  <none>
  Notes:
  
  To show run-time objects internal procedures, start these objects
  broker if its not active already.

------------------------------------------------------------------------------*/
  /* In the WEB tool, start the web-utilities procedure. */
  FIND x_P WHERE RECID(x_P) eq p_Proc_Id.
  IF x_P._TYPE BEGINS "WEB":U OR
    CAN-FIND(FIRST _TRG WHERE _TRG._pRECID   eq p_Proc_Id
                          AND _TRG._tSECTION eq "_PROCEDURE":U
                          AND _TRG._tEVENT   eq "process-web-request":U)
    THEN DO:
    IF NOT VALID-HANDLE(web-utilities-hdl) THEN
      RUN web/objects/web-util.p PERSISTENT SET web-utilities-hdl.
    IF VALID-HANDLE(web-utilities-hdl) AND
      INDEX(p_objects,"web-utilities-hdl":U) = 0 THEN
      p_Objects = (IF p_Objects ne "":U THEN p_Objects + ",":U ELSE "") +
                     "web-utilities-hdl ":U + STRING(web-utilities-hdl).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetFuncCode Dlg_Methods 
FUNCTION GetFuncCode RETURNS CHARACTER
  ( /* parameter-definitions */
    INPUT p_Name        AS CHARACTER,
    INPUT p_ObjHandle   AS HANDLE,
    INPUT p_Func_Name   AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR p_Code    AS CHARACTER NO-UNDO.
  DEFINE VAR Signature AS CHARACTER NO-UNDO.
  DEFINE VAR ParamList AS CHARACTER NO-UNDO.
  DEFINE VAR Parm      AS CHARACTER NO-UNDO.
  DEFINE VAR vItem     AS INTEGER   NO-UNDO.
  
  ASSIGN p_Code = "DYNAMIC-FUNCTION('" + p_Func_Name + "':U" .

  /* Since we can't determine the parameters of a THIS-PROCEDURE function
     (because its not running), return now.  */
  IF (p_Name = This_Procedure) THEN
  DO:
    ASSIGN p_Code = p_Code + ")".
    RETURN p_Code.
  END.
  ELSE
  DO:
    /* If its any object other than a Super Procedure, use the IN handle option.
       Otherwise, don't use the IN handle option. */
    IF VALID-HANDLE(p_ObjHandle) AND LOOKUP(STRING(p_ObjHandle:HANDLE), p_Super_Handles) = 0 THEN
        ASSIGN p_Code = p_Code + " IN " + p_Name.
  END.

  ASSIGN Signature    = GetSignatureFunc( p_ObjHandle, p_Func_Name )
         ParamList    = IF ENTRY(3, Signature) <> ""
                        THEN SUBSTRING(Signature, INDEX(Signature, ENTRY(3, Signature)))
                        ELSE ""
         NO-ERROR. 

  /* Generate the parameter list. This is the mode, then parameter name, followed by
     datatype. Does vary for Buffer, Table, and Table-Handle parameters. We put the
     datatype and buffer source name in comments as helpful reminders. */
  DO vItem = 1 TO NUM-ENTRIES( ParamList ):
    ASSIGN Parm = ENTRY( vItem , ParamList ).

    /* Table-Handle, Buffer, and Data-Type parameters have special cases. Handle them. */
    IF ENTRY(2, Parm, Space_Char) = "TABLE-HANDLE":u THEN
    DO:
        /* Omit the "FOR" option (ENTRY 4) - it doesn't belong on a RUN statement. */
        Parm     = ENTRY(1, Parm, Space_Char) + " " + ENTRY(2, Parm, Space_Char) + " " + ENTRY(3, Parm, Space_Char).
    END.
    ELSE IF ENTRY(2, Parm, Space_Char) <> "TABLE":u THEN
    DO:
      /* Comment the buffer "source" and data-type info. */
      ASSIGN Parm = REPLACE( Parm , Space_Char + ENTRY(3, Parm, Space_Char) ,
                                    Space_Char + "/* " + ENTRY(3, Parm, Space_Char ) + " */") NO-ERROR.
    END.
    
    ASSIGN
        Parm = (Space_Char + Parm)
        Parm = IF vItem > 1 THEN {&EOL} + FILL(Space_Char, 5) + Parm ELSE Parm
        ParamList = REPLACE( ParamList , ENTRY(vItem , ParamList), Parm )
        NO-ERROR.
  END.
  
  IF (ParamList <> "") THEN
    ASSIGN p_Code = p_Code + ",":U + {&EOL} + FILL(" " , 4) + "" + ParamList + ")" + {&EOL}.
  ELSE
    ASSIGN p_Code = p_Code + ")".
    
  RETURN p_Code.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetRunCode Dlg_Methods 
FUNCTION GetRunCode RETURNS CHARACTER
  ( /* parameter-definitions */
    INPUT p_Name        AS CHARACTER,
    INPUT p_ObjHandle   AS HANDLE,
    INPUT p_Method_Name AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR p_Code    AS CHARACTER NO-UNDO.
  DEFINE VAR Signature AS CHARACTER NO-UNDO.
  DEFINE VAR ParamList AS CHARACTER NO-UNDO.
  DEFINE VAR Parm      AS CHARACTER NO-UNDO.
  DEFINE VAR vItem     AS INTEGER   NO-UNDO.
  
  ASSIGN p_Code = "RUN " + p_Method_Name .
  /* Since we can't determine the parameters of a THIS-PROCEDURE procedure
     (because its not running), return now.
  */
  IF (p_Name = This_Procedure) THEN
  DO:
    ASSIGN p_Code = p_Code + ".".
    RETURN p_Code.
  END.
  ELSE
  DO:
    /* If its any object other than a Super Procedure, use the IN handle option.
       Otherwise, don't use the IN handle option. */
    IF VALID-HANDLE(p_ObjHandle) AND LOOKUP(STRING(p_ObjHandle:HANDLE), p_Super_Handles) = 0 THEN
        ASSIGN p_Code = p_Code + " IN " + p_Name.
  END.

  ASSIGN Signature    = GetSignatureProc( p_ObjHandle, p_Method_Name )
         ParamList    = IF ENTRY(3, Signature) <> ""
                        THEN SUBSTRING(Signature, INDEX(Signature, ENTRY(3, Signature)))
                        ELSE ""
         NO-ERROR. 
  
  /* Generate the parameter list. This is the mode, then parameter name, followed by
     datatype. Does vary for Buffer, Table, and Table-Handle parameters. We put the
     datatype and buffer source name in comments as helpful reminders. */
  DO vItem = 1 TO NUM-ENTRIES( ParamList ):
    ASSIGN Parm = ENTRY( vItem , ParamList ).

    /* Table-Handle, Buffer, and Data-Type parameters have special cases. Handle them. */
    IF ENTRY(2, Parm, Space_Char) = "TABLE-HANDLE":u THEN
    DO:
        /* Omit the "FOR" option (ENTRY 4) - it doesn't belong on a RUN statement. */
        Parm     = ENTRY(1, Parm, Space_Char) + " " + ENTRY(2, Parm, Space_Char) + " " + ENTRY(3, Parm, Space_Char).
    END.
    ELSE IF ENTRY(2, Parm, Space_Char) <> "TABLE":u THEN
    DO:
      /* Comment the buffer "source" and data-type info. */
      ASSIGN Parm = REPLACE( Parm , Space_Char + ENTRY(3, Parm, Space_Char) ,
                                    Space_Char + "/* " + ENTRY(3, Parm, Space_Char ) + " */") NO-ERROR.
    END.
    
    ASSIGN
        Parm = (Space_Char + Parm)
        Parm = IF vItem > 1 THEN {&EOL} + FILL(Space_Char, 5) + Parm ELSE Parm
        ParamList = REPLACE( ParamList , ENTRY(vItem , ParamList), Parm )
        NO-ERROR.
  END.

  IF (ParamList = "") THEN
    ASSIGN p_Code = p_Code + ".".
  ELSE  
    ASSIGN p_Code = p_Code + {&EOL} + FILL(" " , 4) + "(" + ParamList + ")." + {&EOL}.

  RETURN p_Code.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetSignatureFunc Dlg_Methods 
FUNCTION GetSignatureFunc RETURNS CHARACTER
  ( INPUT p_hObject AS HANDLE, INPUT p_Name AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VAR retSignature AS CHARACTER  NO-UNDO.
  DEFINE VAR hSuperProc   AS HANDLE     NO-UNDO.
  DEFINE VAR iItem        AS INTEGER    NO-UNDO.
  DEFINE VAR vSignature   AS CHARACTER  NO-UNDO.
      
  IF VALID-HANDLE(p_hObject) THEN
  DO:
      ASSIGN vSignature = p_hObject:GET-SIGNATURE(p_Name).
      IF (vSignature <> "":U) AND (ENTRY(2, vSignature) <> "":U) THEN
        ASSIGN retSignature = vSignature.
      ELSE
      DO iItem = 1 TO NUM-ENTRIES(p_hObject:SUPER-PROCEDURES):
        hSuperProc = WIDGET-HANDLE(ENTRY(iItem, p_hObject:SUPER-PROCEDURES)).
        vSignature = hSuperProc:GET-SIGNATURE(p_Name).
        IF (vSignature <> "":U) AND (ENTRY(2, vSignature) <> "":U) THEN
        DO:
          ASSIGN retSignature = vSignature.
          LEAVE.
        END.
      END.
  END.

  RETURN retSignature.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetSignatureProc Dlg_Methods 
FUNCTION GetSignatureProc RETURNS CHARACTER
  ( INPUT p_hObject AS HANDLE, INPUT p_Name AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VAR retSignature AS CHARACTER  NO-UNDO.
  DEFINE VAR hSuperProc   AS HANDLE     NO-UNDO.
  DEFINE VAR iItem        AS INTEGER    NO-UNDO.
  DEFINE VAR vSignature   AS CHARACTER  NO-UNDO.
      
  IF VALID-HANDLE(p_hObject) THEN
  DO:
      ASSIGN vSignature = p_hObject:GET-SIGNATURE(p_Name).
      IF (vSignature <> "":U) AND (ENTRY(2, vSignature) = "":U) THEN
        ASSIGN retSignature = vSignature.
      ELSE
      DO iItem = 1 TO NUM-ENTRIES(p_hObject:SUPER-PROCEDURES):
        hSuperProc = WIDGET-HANDLE(ENTRY(iItem, p_hObject:SUPER-PROCEDURES)).
        vSignature = hSuperProc:GET-SIGNATURE(p_Name).
        IF (vSignature <> "":U) AND (ENTRY(2, vSignature) = "":U) THEN
        DO:
          ASSIGN retSignature = vSignature.
          LEAVE.
        END.
      END.
  END.

  RETURN retSignature.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

