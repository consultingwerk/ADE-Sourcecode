&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dlg_Methods
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dlg_Methods 
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
/*------------------------------------------------------------------------
  File    :    _inscal8.w
  Purpose :    Section Editor Insert Procedure Call Dialog Box for V8 ADM.
  Syntax  :    
            RUN adeuib/_inscal8.w ( INPUT  p_Objects ,
                                    INPUT  p_This_Methods ,
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
    5/5/96 Wm.T.Wood - Allow access to adm-broker-hdl if it is running
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl    AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE web-utilities-hdl AS HANDLE NO-UNDO.

&GLOBAL-DEFINE WIN95-BTN YES

/* Parameters Definitions ---                                           */
&IF DEFINED(UIB_is_Running) = 0 &THEN
DEFINE INPUT  PARAMETER p_Objects       AS CHARACTER NO-UNDO .
    /* Delimited List of "ObjName1 ObjHandle1,ObjName2 ObjHandle2" pairs.   */
DEFINE INPUT  PARAMETER p_This_Methods  AS CHARACTER NO-UNDO .
    /* Comma-delimited list of THIS-PROCEDURE methods. */
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
DEFINE VAR Type_Event    AS CHARACTER    NO-UNDO INIT "_EVENT":U .

DEFINE VAR hObject       AS HANDLE       NO-UNDO.
DEFINE VAR NameList      AS CHARACTER    NO-UNDO.
DEFINE VAR ProcList      AS CHARACTER    NO-UNDO.
DEFINE VAR EventList     AS CHARACTER    NO-UNDO.

DEFINE VAR This_Procedure AS CHARACTER   NO-UNDO INIT "THIS-PROCEDURE".
DEFINE VAR This_Procs     AS CHARACTER   NO-UNDO.
DEFINE VAR This_Events    AS CHARACTER   NO-UNDO.
DEFINE VAR None           AS CHARACTER   NO-UNDO INIT "(None)".
DEFINE VAR Local_Marker   AS CHARACTER   NO-UNDO INIT " *".
DEFINE VAR Insert_Cmd     AS CHARACTER   NO-UNDO INIT "_INSERT":u.
DEFINE VAR Local_Cmd      AS CHARACTER   NO-UNDO INIT "_LOCAL":u.
DEFINE VAR Dispatch_Cmd   AS CHARACTER   NO-UNDO INIT "_DISPATCH":u.
DEFINE VAR Notify_Cmd     AS CHARACTER   NO-UNDO INIT "_NOTIFY":u.
DEFINE VAR Run_Cmd        AS CHARACTER   NO-UNDO INIT "_RUN-IN":u.
DEFINE VAR Ret_Val        AS LOGICAL     NO-UNDO.
DEFINE VAR local-broker-hdl AS HANDLE    NO-UNDO.
DEFINE VAR temp-broker-hdl  AS HANDLE    NO-UNDO.
DEFINE VAR Adm_Broker_Name  AS CHARACTER INIT "adm-broker-hdl":u NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dlg_Methods

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Name Type Method_List Insert_Options ~
Btn_About_Sel btn_Create_Local Insert_Code 
&Scoped-Define DISPLAYED-OBJECTS Name Type Method_List Insert_Options ~
Insert_Code Label_ProcObj Label_Methods Label_InsertCode 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_About_Sel 
     LABEL "&About Method" 
     SIZE 26 BY 1.14.

DEFINE BUTTON btn_Create_Local DEFAULT 
     LABEL "&Create Local" 
     SIZE 16 BY 1.1.

DEFINE VARIABLE Name AS CHARACTER FORMAT "X(256)":U INITIAL "THIS-PROCEDURE" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 8
     LIST-ITEMS "THIS-PROCEDURE" 
     SIZE 37 BY 1 NO-UNDO.

DEFINE VARIABLE Insert_Code AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 65 BY 3
     FONT 2 NO-UNDO.

DEFINE VARIABLE Label_Events AS CHARACTER FORMAT "X(256)":U 
     LABEL "E&vents" 
      VIEW-AS TEXT 
     SIZE 2 BY .81 NO-UNDO.

DEFINE VARIABLE Label_InsertCode AS CHARACTER FORMAT "X(256)":U 
     LABEL "Code to &Insert" 
      VIEW-AS TEXT 
     SIZE 2 BY .81 NO-UNDO.

DEFINE VARIABLE Label_Methods AS CHARACTER FORMAT "X(256)":U 
     LABEL "Me&thods" 
      VIEW-AS TEXT 
     SIZE 2 BY .81 NO-UNDO.

DEFINE VARIABLE Label_ProcObj AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Object" 
      VIEW-AS TEXT 
     SIZE 2 BY .81 NO-UNDO.

DEFINE VARIABLE Insert_Options AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&Dispatch <event>", "_DISPATCH",
"&Notify <event>", "_NOTIFY",
"&RUN <method> IN", "_RUN-IN"
     SIZE 23 BY 3.48 NO-UNDO.

DEFINE VARIABLE Type AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "ADM &Events", "_EVENT",
"&Methods", "_PROCEDURE"
     SIZE 16 BY 2.38 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 26 BY 3.19.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 26 BY 4.29.

DEFINE VARIABLE Method_List AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SORT 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 37 BY 6.29 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dlg_Methods
     Name AT ROW 2.1 COL 2 NO-LABEL
     Type AT ROW 2.52 COL 43 NO-LABEL
     Method_List AT ROW 4.24 COL 2 NO-LABEL
     Insert_Options AT ROW 6.29 COL 43 NO-LABEL
     Btn_About_Sel AT ROW 10.33 COL 41
     btn_Create_Local AT ROW 11.67 COL 40
     Insert_Code AT ROW 12.57 COL 2 NO-LABEL
     Label_ProcObj AT ROW 1.29 COL 1
     Label_Events AT ROW 3.43 COL 1
     Label_Methods AT ROW 3.43 COL 1
     Label_InsertCode AT ROW 11.76 COL 1
     " Show Procedures" VIEW-AS TEXT
          SIZE 17.8 BY .67 AT ROW 1.71 COL 42.2
     RECT-4 AT ROW 2.05 COL 41
     " Insert Options" VIEW-AS TEXT
          SIZE 15.8 BY .67 AT ROW 5.48 COL 42.2
     RECT-5 AT ROW 5.76 COL 41
     "* - event has local override" VIEW-AS TEXT
          SIZE 31 BY .62 AT ROW 10.67 COL 3
     SPACE(33.71) SKIP(4.43)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Insert Procedure Call - Version 8".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dlg_Methods
                                                                        */
ASSIGN 
       FRAME Dlg_Methods:SCROLLABLE       = FALSE
       FRAME Dlg_Methods:HIDDEN           = TRUE.

ASSIGN 
       Insert_Code:AUTO-INDENT IN FRAME Dlg_Methods      = TRUE
       Insert_Code:RETURN-INSERTED IN FRAME Dlg_Methods  = TRUE.

/* SETTINGS FOR FILL-IN Label_Events IN FRAME Dlg_Methods
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       Label_Events:HIDDEN IN FRAME Dlg_Methods           = TRUE.

/* SETTINGS FOR FILL-IN Label_InsertCode IN FRAME Dlg_Methods
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN Label_Methods IN FRAME Dlg_Methods
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN Label_ProcObj IN FRAME Dlg_Methods
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR COMBO-BOX Name IN FRAME Dlg_Methods
   ALIGN-L                                                              */
/* SETTINGS FOR RECTANGLE RECT-4 IN FRAME Dlg_Methods
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-5 IN FRAME Dlg_Methods
   NO-ENABLE                                                            */
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
ON ALT-I OF FRAME Dlg_Methods /* Insert Procedure Call - Version 8 */
ANYWHERE
DO:
  IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" THEN
    APPLY "ENTRY" TO Insert_Code.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dlg_Methods Dlg_Methods
ON ALT-O OF FRAME Dlg_Methods /* Insert Procedure Call - Version 8 */
ANYWHERE
DO:
  IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" THEN
    APPLY "ENTRY" TO Name.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dlg_Methods Dlg_Methods
ON ALT-T OF FRAME Dlg_Methods /* Insert Procedure Call - Version 8 */
ANYWHERE
DO:
  IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" THEN
    APPLY "ENTRY" TO Method_List.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dlg_Methods Dlg_Methods
ON ALT-V OF FRAME Dlg_Methods /* Insert Procedure Call - Version 8 */
ANYWHERE
DO:
  IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" THEN
    APPLY "ENTRY" TO Method_List.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dlg_Methods Dlg_Methods
ON GO OF FRAME Dlg_Methods /* Insert Procedure Call - Version 8 */
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
        
    END CASE.
    
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_About_Sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_About_Sel Dlg_Methods
ON CHOOSE OF Btn_About_Sel IN FRAME Dlg_Methods /* About Method */
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


&Scoped-define SELF-NAME btn_Create_Local
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_Create_Local Dlg_Methods
ON CHOOSE OF btn_Create_Local IN FRAME Dlg_Methods /* Create Local */
DO:
  DEFINE VAR OK_Local AS LOGICAL   NO-UNDO INIT YES.
  DEFINE VAR vMethod  AS CHARACTER NO-UNDO.
  
  DO ON STOP UNDO, RETURN:
    ASSIGN vMethod = REPLACE( Method_List:SCREEN-VALUE , Local_Marker , Nul )
           vMethod = REPLACE( vMethod , Smart_Prefix , Local_Prefix)
           . /* END ASSIGN */
           
    /* If the ADM method does not already have a local procedure,
       ask to ensure user wants to create one. Otherwise, ask if
       the user wants to go the exising code. */
    IF (INDEX(Method_List:SCREEN-VALUE, Local_Marker) = 0) THEN
    MESSAGE vMethod SKIP(1)
            "OK to create this new local override procedure?"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK-CANCEL
                    UPDATE OK_Local IN WINDOW ACTIVE-WINDOW.
    ELSE
    MESSAGE vMethod SKIP(1)
            "This local procedure is already defined." SKIP
            "Do you want to edit the existing code?"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK-CANCEL
                    UPDATE OK_Local IN WINDOW ACTIVE-WINDOW.
    IF (OK_Local = NO) THEN RETURN.
  END.
  ASSIGN p_Command = Local_Cmd.
  APPLY "GO" TO FRAME {&FRAME-NAME} .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Insert_Options
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Insert_Options Dlg_Methods
ON VALUE-CHANGED OF Insert_Options IN FRAME Dlg_Methods
DO:
  ASSIGN p_Command = Insert_Cmd.
  RUN DispInsertCode IN THIS-PROCEDURE.
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

/* JEP-UNFINISHED - Need new Insert_Procedure_Call_Dlg_Box help string
   for V8: Insert_Procedure_Call_Dlg_Box_V8 */
   
/* ADE okbar.i places standard ADE OK-CANCEL-HELP buttons.              */
{adecomm/okbar.i &TOOL = "AB"
                 &CONTEXT = {&Insert_Procedure_Call_Dlg_Box} }
                 
/* Position the Create Local button next to Cancel. */
ASSIGN btn_Create_Local:HEIGHT = btn_Cancel:HEIGHT
       btn_Create_Local:ROW    = btn_Cancel:ROW
       btn_Create_Local:COL    = (btn_Cancel:COL + btn_Cancel:WIDTH) + 1
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
  RUN StartADMBroker.
  RUN StartPersistentObjects.
  RUN SetInitValues.
  RUN enable_UI.
  RUN SetState ( INPUT Init_Type ).
  ASSIGN FRAME {&FRAME-NAME}:VISIBLE = TRUE.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

/* Cleanup local ADM broker. */
RUN StopADMBroker.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dlg_Methods _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dlg_Methods _DEFAULT-ENABLE
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
  DISPLAY Name Type Method_List Insert_Options Insert_Code Label_ProcObj 
          Label_Methods Label_InsertCode 
      WITH FRAME Dlg_Methods.
  ENABLE Name Type Method_List Insert_Options Btn_About_Sel btn_Create_Local 
         Insert_Code 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetEventList Dlg_Methods 
PROCEDURE GetEventList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_all_list  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_EventList AS CHARACTER NO-UNDO.
  
  DEFINE VAR vItem  AS INTEGER   NO-UNDO.
  DEFINE VAR vEvent AS CHARACTER NO-UNDO.
  DEFINE VAR vLocal AS CHARACTER NO-UNDO.
  
  IF p_all_list = "" THEN
  DO:
    ASSIGN p_EventList = None.
    RETURN.
  END.
  
  DO vItem = 1 TO NUM-ENTRIES( p_all_list ):
    IF NOT ENTRY( vItem , p_all_list ) BEGINS Smart_Prefix THEN
        NEXT.
    ELSE
        ASSIGN vEvent = ENTRY( vItem , p_all_list )
               vLocal = REPLACE( vEvent , Smart_Prefix , Local_Prefix).
    
    IF LOOKUP( vLocal , p_all_list ) <> 0 THEN
        ASSIGN vEvent = vEvent + Local_Marker.
        
    ASSIGN p_EventList = p_EventList + "," + vEvent.
  END.
  ASSIGN p_EventList = TRIM( p_EventList , ",").
  
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
    CASE Insert_Options:SCREEN-VALUE :
         
        WHEN Dispatch_Cmd THEN
            RUN GetDispatchCode( INPUT  vMethod ,
                                 INPUT  Name:SCREEN-VALUE ,
                                 OUTPUT p_Ret_Value ).
        WHEN Notify_Cmd THEN
            RUN GetNotifyCode( INPUT  vMethod ,
                               OUTPUT p_Ret_Value ).
                    
        WHEN Run_Cmd THEN
            RUN GetRunCode( INPUT  Name:SCREEN-VALUE ,
                            INPUT  hObject ,
                            INPUT  vMethod ,
                            OUTPUT p_Ret_Value ).
    END CASE.
  
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetNotifyCode Dlg_Methods 
PROCEDURE GetNotifyCode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_Method_Name AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Code        AS CHARACTER NO-UNDO.
  
  ASSIGN p_Method_Name = SUBSTRING(p_Method_Name , 5, -1, "CHARACTER")
         p_Code = "RUN notify IN THIS-PROCEDURE ('" + p_Method_Name + "':U).".

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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_ObjHandle   AS HANDLE    NO-UNDO.
  DEFINE INPUT  PARAMETER p_all_list    AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_ProcList    AS CHARACTER NO-UNDO.
  
  DEFINE VAR vItem      AS INTEGER NO-UNDO.
  DEFINE VAR proc_item  AS CHARACTER NO-UNDO.
  
  IF p_all_list = "" THEN
  DO:
    ASSIGN p_ProcList = None.
    RETURN.
  END.
  DO vItem = 1 TO NUM-ENTRIES( p_all_list ):
    ASSIGN proc_item = ENTRY( vItem , p_all_list ).
    IF proc_item BEGINS Smart_Prefix OR
       proc_item BEGINS Local_Prefix OR
       (proc_item BEGINS Broker_Prefix AND
        Name:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Adm_Broker_Name) THEN NEXT.

    /* Don't include if its a function. */
    IF VALID-HANDLE(p_ObjHandle) AND
       (p_ObjHandle:GET-SIGNATURE(proc_item) BEGINS "FUNCTION":U) THEN NEXT.
    
    ASSIGN p_ProcList = p_ProcList + "," + ENTRY( vItem , p_all_list ).
  END.
  ASSIGN p_ProcList = TRIM( p_ProcList , ",").
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetRunCode Dlg_Methods 
PROCEDURE GetRunCode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_Name        AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER p_ObjHandle   AS HANDLE    NO-UNDO.
  DEFINE INPUT  PARAMETER p_Method_Name AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Code        AS CHARACTER NO-UNDO.
  
  DEFINE VAR Signature AS CHARACTER NO-UNDO.
  DEFINE VAR ParamList AS CHARACTER NO-UNDO.
  DEFINE VAR Parm      AS CHARACTER NO-UNDO.
  DEFINE VAR vItem     AS INTEGER   NO-UNDO.
  
  ASSIGN p_Code = "RUN " + p_Method_Name .
  /* Since we can't determine the parameters of a THIS-PROCEDURE
     method (because its not running), return now.
  */
  IF (p_Name = This_Procedure) THEN
  DO:
    ASSIGN p_Code = p_Code + ".".
    RETURN.
  END.
  ELSE
    ASSIGN p_Code = p_Code + " IN " + p_Name.
     
                     
  ASSIGN Signature    =  p_ObjHandle:GET-SIGNATURE(p_Method_Name)
         ParamList    = SUBSTRING(Signature, INDEX(Signature, ENTRY(3, Signature)))
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
  RETURN.
  
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
      RUN GetEventList IN THIS-PROCEDURE
          (INPUT p_This_Methods , OUTPUT This_Events).
          
      ASSIGN Name:LIST-ITEMS   = NameList
             Name:SCREEN-VALUE = This_Procedure
             Name:INNER-LINES  = (IF Name:NUM-ITEMS <= 2
                                  THEN 3 ELSE 8)
             Init_Type         = (IF This_Events = Nul
                                  THEN Type_Proc ELSE Type_Event)
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
        ASSIGN Ret_Val = Insert_Options:DISABLE("Dispatch <event>")
               Ret_Val = Insert_Options:DISABLE("Notify <event>")
               btn_Create_Local:SENSITIVE = FALSE
               Btn_About_Sel:SENSITIVE    = (LOOKUP("dispatch":U , ProcList) <> 0)
               Btn_About_Sel:LABEL        = REPLACE(Btn_About_Sel:LABEL,
                                                    "Event","Method")
               Label_Events:VISIBLE       = FALSE
               Label_Methods:VISIBLE      = TRUE
               
               . /* END ASSIGN */
      END.
             
      WHEN Type_Event THEN
      DO:
        ASSIGN Insert_Options:SENSITIVE = TRUE
               Ret_Val = Insert_Options:ENABLE("Dispatch <event>")
               Ret_Val = Insert_Options:ENABLE("Notify <event>")
               Insert_Options:SCREEN-VALUE = Dispatch_Cmd
                            WHEN (Insert_Options:SCREEN-VALUE = Run_Cmd)
               btn_Create_Local:SENSITIVE = TRUE
               Btn_About_Sel:SENSITIVE = TRUE
               Btn_About_Sel:LABEL        = REPLACE(Btn_About_Sel:LABEL,
                                                    "Method","Event")
               Label_Methods:VISIBLE      = FALSE
               Label_Events:VISIBLE       = TRUE
               . /* END ASSIGN */
      END.
    END CASE.

    IF Method_List:LIST-ITEMS = None THEN
      ASSIGN Insert_Options:SENSITIVE   = FALSE
             btn_Create_Local:SENSITIVE = FALSE
             Btn_About_Sel:SENSITIVE    = FALSE
             . /* END ASSIGN */
    ELSE
      ASSIGN Ret_Val = Insert_Options:ENABLE("RUN <method> IN").
    
    IF (Name:SCREEN-VALUE <> This_Procedure) OR
       (Name:SCREEN-VALUE = Adm_Broker_Name) THEN
      ASSIGN btn_Create_Local:SENSITIVE = FALSE.
      
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
        
        WHEN Type_Event THEN
        DO:
            ASSIGN Type:SCREEN-VALUE    = Type_Event.
            CASE Name:SCREEN-VALUE:
                WHEN This_Procedure THEN
                DO:
                    ASSIGN EventList = This_Events .
                    RUN SetMethodList IN THIS-PROCEDURE
                        ( INPUT EventList ).   
                END.
                
                OTHERWISE
                DO:
                    RUN GetObjHandle IN THIS-PROCEDURE
                        ( INPUT Name:SCREEN-VALUE , INPUT NameList ,
                          INPUT p_Objects ,  OUTPUT hObject ).
                    RUN GetEventList IN THIS-PROCEDURE
                        ( INPUT hObject:INTERNAL-ENTRIES , OUTPUT EventList ).
                    RUN SetMethodList IN THIS-PROCEDURE
                        ( INPUT EventList ).   
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE StartADMBroker Dlg_Methods 
PROCEDURE StartADMBroker :
/*------------------------------------------------------------------------------
  Purpose:     Starts a "local" adm broker.
  Parameters:  <none>
  Notes:
  
  To show the user the ADM broker's internal procedures, start the ADM
  broker if its not active already. If the broker handle either isn't valid
  or isn't the right process (it's possible the handle has been reused),
  then start the broker.

------------------------------------------------------------------------------*/

  /* Store off current adm-broker-hdl. We'll restore it when dialog closes. */
  ASSIGN temp-broker-hdl = adm-broker-hdl.

  /* If THIS-PROCEDURE is not a SmartObject, and the broker is not running, 
     then assume the user is not using SmartObjects at all, and don't start
     the broker. */
  IF VALID-HANDLE(adm-broker-hdl) OR
     CAN-DO( p_This_Methods, "dispatch":u ) 
  THEN DO: 
    RUN get-attribute IN adm-broker-hdl ('TYPE':u) NO-ERROR.
    IF RETURN-VALUE <> "ADM-Broker":u THEN 
    DO: 
      RUN adm/objects/broker.p PERSISTENT SET adm-broker-hdl.
      RUN set-broker-owner IN adm-broker-hdl (THIS-PROCEDURE).
      ASSIGN local-broker-hdl = adm-broker-hdl.
    END.
    /* If not already part of the list, add ADM Broker handle. */
    IF INDEX(p_Objects, Adm_Broker_Name) = 0 THEN
    ASSIGN p_Objects = p_Objects + "," +
                       Adm_Broker_Name + " " + STRING( adm-broker-hdl )
           p_Objects = TRIM(p_Objects, ",":u).
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
    CAN-FIND(FIRST _TRG WHERE _TRG._pRECID   eq RECID(x_P)
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE StopADMBroker Dlg_Methods 
PROCEDURE StopADMBroker :
/*------------------------------------------------------------------------------
  Purpose:     Stops the "local" adm broker.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

  /* If this dialog created an instance of the ADM broker, delete it. */
  IF VALID-HANDLE(local-broker-hdl) THEN
  DO:
    RUN dispatch IN local-broker-hdl ('destroy':u) NO-ERROR.
    IF VALID-HANDLE(local-broker-hdl) THEN DELETE PROCEDURE local-broker-hdl.
  END.

  /* Restore broker variable value. Clears ERROR-STATUS as well. */
  ASSIGN adm-broker-hdl = temp-broker-hdl NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

