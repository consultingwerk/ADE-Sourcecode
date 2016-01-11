&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dlg_NewName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dlg_NewName 
/*********************************************************************
* Copyright (C) 2000-2002 by Progress Software Corporation ("PSC"),  *
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

  File    :    _newfunc.w
  Purpose :    Section Editor New Function Dialog Box.
  Syntax  :    
            RUN adeuib/_newfunc.w ( INPUT p_Objects       ,
                                    INPUT p_Command       ,
                                    INPUT p_Smart_List    ,
                                    INPUT p_Invalid_List  ,
                                    INPUT-OUTPUT p_Name   ,
                                    OUTPUT p_Type         ,
                                    OUTPUT p_Returns      ,
                                    OUTPUT p_Define-As    ,
                                    OUTPUT p_Code         ,
                                    OUTPUT p_OK           )
  
  Description: 
    Use the New Function dialog box to create a new function. 

  Input Parameters:
    Yes. See Definitions section for input parameters.

  Output Parameters:
    p_Name    - Name of the entered function.
    p_Type    - Type of function selected. Specifiec to UIB code gen & Sect Ed.
    p_Returns - Return Data Type of function.
    p_Define-As- Implementation (return _FUNCTION)
                 or External Prototype (_FUNCTION-EXTERNAL).
                 Currently, only _FUNCTION is supported.
    p_Code    - Full Code block of a function.
    p_OK      - TRUE means user choose OK. FALSE means user choose Cancel.

  Author:    J. Palazzo
  Created: 01/28/97

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/adestds.i}        /* Standared ADE Preprocessor Directives */
IF NOT initialized_adestds
THEN RUN adecomm/_adeload.p.

{adeuib/uibhlp.i}          /* Help File Preprocessor Directives     */

/* Parameters Definitions ---                                           */
&IF DEFINED(UIB_is_Running) NE 0 &THEN
DEFINE VARIABLE p_Objects       AS CHARACTER NO-UNDO .
DEFINE VARIABLE p_Command       AS CHARACTER NO-UNDO INIT "NEW":U.
DEFINE VARIABLE p_Smart_List    AS CHARACTER NO-UNDO INIT "getName,getDate".
DEFINE VARIABLE p_Invalid_List  AS CHARACTER NO-UNDO INIT "getName,getDate".
DEFINE VARIABLE p_Name          AS CHARACTER NO-UNDO .
DEFINE VARIABLE p_Type          AS CHARACTER NO-UNDO .
DEFINE VARIABLE p_Returns       AS CHARACTER NO-UNDO .
DEFINE VARIABLE p_Define-As     AS CHARACTER NO-UNDO .
DEFINE VARIABLE p_Code          AS CHARACTER NO-UNDO .
DEFINE VARIABLE p_OK            AS LOGICAL   NO-UNDO .
&ELSE
DEFINE INPUT  PARAMETER p_Objects       AS CHARACTER NO-UNDO .
    /* Command-Delimited List Super Procedure Handles.      */
DEFINE INPUT  PARAMETER p_Command       AS CHARACTER NO-UNDO .
    /* Dialog Command Mode - "NEW" or "OVERRIDE".           */
DEFINE INPUT  PARAMETER p_Smart_List    AS CHARACTER NO-UNDO .
    /* Comma-delimited list of ADM Smart Methods.           */
DEFINE INPUT  PARAMETER p_Invalid_List  AS CHARACTER NO-UNDO .
    /* Comma-delimited list of existing Procedures which
       cannot be accepted as a valid new name.              */
DEFINE INPUT-OUTPUT PARAMETER p_Name    AS CHARACTER NO-UNDO .
    /* Name of new procedure entered by the user.           */
DEFINE OUTPUT PARAMETER p_Type          AS CHARACTER NO-UNDO .
    /* Type of new procedure entered by the user.           */
DEFINE OUTPUT PARAMETER p_Returns       AS CHARACTER NO-UNDO .
    /* Returns Data Type                                    */
DEFINE OUTPUT PARAMETER p_Define-As     AS CHARACTER NO-UNDO .
    /* Functions FORWARD reference or External              */
DEFINE OUTPUT PARAMETER p_Code          AS CHARACTER NO-UNDO .
    /* Parameter Code Block                                 */
DEFINE OUTPUT PARAMETER p_OK            AS LOGICAL   NO-UNDO .
    /* YES - User choose OK. NO - User choose Cancel.       */
&ENDIF

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE Nul           AS CHARACTER    NO-UNDO INIT "":U .
DEFINE VARIABLE Unknown       AS CHARACTER    NO-UNDO INIT ? .
DEFINE VARIABLE Init_Type     AS CHARACTER    NO-UNDO .
DEFINE VARIABLE Smart_Prefix  AS CHARACTER    NO-UNDO INIT "adm-":U .
DEFINE VARIABLE Local_Prefix  AS CHARACTER    NO-UNDO INIT "local-":U .
DEFINE VARIABLE Type_Func     AS CHARACTER    NO-UNDO INIT "_FUNCTION":U .
DEFINE VARIABLE Type_Func_Ext AS CHARACTER    NO-UNDO INIT "_FUNCTION-EXTERNAL":U .
DEFINE VARIABLE Type_Local    AS CHARACTER    NO-UNDO INIT "_LOCAL":U .
DEFINE VARIABLE Invalid_Entry AS CHARACTER    NO-UNDO INIT "_INVALID-ENTRY":U .
DEFINE VARIABLE Indent        AS CHARACTER    NO-UNDO INIT "   ":U.

DEFINE SHARED VARIABLE _DynamicsIsRunning AS LOGICAL    NO-UNDO.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dlg_NewName

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 Name Returns-Type Type 
&Scoped-Define DISPLAYED-OBJECTS Name Returns-Type Type 

/* Custom List Definitions                                              */
/* List-Var,List-Table,List-Buffer,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetFuncCode Dlg_NewName 
FUNCTION GetFuncCode RETURNS CHARACTER
  ( /* parameter-definitions */
    INPUT p_Func_Name   AS CHARACTER,
    INPUT p_ObjHandle   AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE Returns-Type AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Returns" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 14
     LIST-ITEMS "CHARACTER","COM-HANDLE","DATE","DATETIME","DATETIME-TZ","DECIMAL","HANDLE","INTEGER","LOGICAL","LONGCHAR","MEMPTR","RAW","RECID","ROWID","WIDGET-HANDLE" 
     SIZE 42 BY 1 NO-UNDO.

DEFINE VARIABLE Smart_List AS CHARACTER FORMAT "X(64)":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 20
     LIST-ITEMS "","" 
     SIZE 42 BY 1
     FONT 2 NO-UNDO.

DEFINE VARIABLE Name AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Name" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1 NO-UNDO.

DEFINE VARIABLE Returns-Type-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Returns" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1 NO-UNDO.

DEFINE VARIABLE Type AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&Function", "_FUNCTION",
"&Override", "_LOCAL"
     SIZE 23 BY 2.86 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 52 BY 4.81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dlg_NewName
     Name AT ROW 1.48 COL 10 COLON-ALIGNED
     Smart_List AT ROW 1.48 COL 10 COLON-ALIGNED NO-LABEL
     Returns-Type AT ROW 2.67 COL 10 COLON-ALIGNED
     Returns-Type-2 AT ROW 2.67 COL 10 COLON-ALIGNED
     Type AT ROW 5.29 COL 11 NO-LABEL
     " Type" VIEW-AS TEXT
          SIZE 6.8 BY .67 AT ROW 4.1 COL 4
     RECT-4 AT ROW 4.38 COL 2
     SPACE(0.79) SKIP(0.18)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "New Function".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dlg_NewName
                                                                        */
ASSIGN 
       FRAME Dlg_NewName:SCROLLABLE       = FALSE
       FRAME Dlg_NewName:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Returns-Type-2 IN FRAME Dlg_NewName
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       Returns-Type-2:HIDDEN IN FRAME Dlg_NewName           = TRUE.

/* SETTINGS FOR COMBO-BOX Smart_List IN FRAME Dlg_NewName
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       Smart_List:HIDDEN IN FRAME Dlg_NewName           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dlg_NewName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dlg_NewName Dlg_NewName
ON GO OF FRAME Dlg_NewName /* New Function */
DO:

&Scoped-define EOL CHR(10)
&Scoped-define COMMENT-LINE ------------------------------------------------------------------------------

  DEFINE VARIABLE Valid_Entry    AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE Returns_Line   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE Code-Block     AS CHARACTER   NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:

  /* Trim leading spaces. */
  ASSIGN Name:SCREEN-VALUE = TRIM(Name:SCREEN-VALUE)
         Name              = Name:SCREEN-VALUE.
  
  /* Validate that the name is a legal PROGRESS internal procedure name. */
  RUN adecomm/_valpnam.p
      (INPUT  Name:SCREEN-VALUE, INPUT TRUE, INPUT "_INTERNAL":U,
       OUTPUT Valid_Entry ).

  IF NOT Valid_Entry THEN
  DO:    
      RUN set-state ( INPUT Type_Func + Invalid_Entry ).
      RETURN NO-APPLY.
  END.
  
  /* Don't allow the user to enter a duplicate name. */
  IF _DynamicsIsRunning AND CAN-DO ( p_Invalid_List , Name ) THEN
  DO:
     MESSAGE Name    SKIP(1)
             "This name is reserved or already defined in an included Method Library." + CHR(10) +
             "If you wish to override the existing function, you must ensure that you specify" + CHR(10) +
             "the pre-processor 'EXCLUDE-" + Name + "' in the definition section" + CHR(10) +
             "or else the procedure will not compile. " + CHR(10) + CHR(10) +
             "Are you sure you wish to continue?"
             VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE lchoice AS LOGICAL IN WINDOW ACTIVE-WINDOW .
    IF NOT lchoice THEN
    DO:
       RUN set-state ( INPUT Type_Func  + Invalid_Entry ).
       RETURN NO-APPLY.
    END.
  END.  
  ELSE  
  IF CAN-DO ( p_Invalid_List , Name ) THEN
  DO:
      MESSAGE Name  SKIP(1)
              "This name is reserved, or already defined in an included Method Library."
              VIEW-AS ALERT-BOX INFORMATION IN WINDOW ACTIVE-WINDOW .
      RUN set-state ( INPUT Type_Func + Invalid_Entry ).
      RETURN NO-APPLY.
  END.
  

  /* Function Implementation. */
  ASSIGN Returns-Type
         Returns-Type-2.
  ASSIGN p_Define-As = Type:SCREEN-VALUE.

  CASE p_Define-As:
   /**************************************************************************/
   /*                          standard FUNCTION IMPLEMENTATION              */  
   /**************************************************************************/
    WHEN Type_Func THEN
    DO:

      DEFINE VAR Return_Value AS CHARACTER NO-UNDO.
      
      ASSIGN Returns_Line = "RETURNS " + Returns-Type.
      ASSIGN Code-Block = Returns_Line + CHR(10)
                          + "  ( /* parameter-definitions */ ) :".

      IF Returns-Type = "CHARACTER":U THEN
        ASSIGN Return_Value = '""'.
      ELSE IF Returns-Type = "DECIMAL" THEN
        ASSIGN Return_Value = "0.00".
      ELSE IF Returns-Type = "INTEGER" THEN
        ASSIGN Return_Value = "0".
      ELSE IF Returns-Type = "LOGICAL" THEN
        ASSIGN Return_Value = "FALSE".
      ELSE Return_Value = "?".
      
      Code-Block =   Code-Block + {&EOL} +
      "/*{&COMMENT-LINE}" + {&EOL} +
      "  Purpose:  " + {&EOL} + 
      "    Notes:  " + {&EOL} + 
      "{&COMMENT-LINE}*/" + {&EOL} +
      {&EOL} +
      "  RETURN " + Return_Value + ".   /* Function return value. */"
      + {&EOL}
      + {&EOL} +
      "END FUNCTION.".

      ASSIGN p_Returns  = Returns-Type
             p_Code     = Code-Block .

    END. /* WHEN _FUNCTION... */
  

   /**************************************************************************/
   /*                          standard FUNCTION LOCAL OVERRIDE              */  
   /**************************************************************************/
    WHEN Type_Local THEN
      ASSIGN p_Code = GetFuncCode( INPUT Name, INPUT p_Objects ).

   /**************************************************************************/
   /*                          standard FUNCTION EXTERNAL PROTOTYPE          */  
   /**************************************************************************/
    WHEN "_FUNCTION-EXTERNAL" THEN
    DO:
      ASSIGN Returns_Line = "RETURNS " + Returns-Type.
      ASSIGN Code-Block = Returns_Line + CHR(10)
                          + "  ( /* parameter-definitions */ ) :".
      Code-Block =   Code-Block + "  /* External Prototype. */".
      p_Code     = Code-Block.
    END. /* WHEN _FUNCTION-EXTERNAL... */
  
  END CASE.

  ASSIGN p_Name     = Name
         p_Type     = Type_Func     /* Always return this to keep p_Code intact. */
         p_OK       = TRUE .
  
/*  MESSAGE
 *          p_Name SKIP
 *          p_Type SKIP
 *          p_Returns SKIP
 *          p_Define-As SKIP
 *          p_OK   SKIP
 *          view-as alert-box in window active-window.*/

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Name
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Name Dlg_NewName
ON LEAVE OF Name IN FRAME Dlg_NewName /* Name */
DO:
  ASSIGN Name:SCREEN-VALUE = TRIM( Name:SCREEN-VALUE ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Smart_List
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Smart_List Dlg_NewName
ON VALUE-CHANGED OF Smart_List IN FRAME Dlg_NewName
DO:
  IF Type:SCREEN-VALUE = Type_Local THEN
      ASSIGN Name:SCREEN-VALUE =
                 REPLACE(Smart_List:SCREEN-VALUE , Smart_Prefix , Local_Prefix ).
  ELSE
      ASSIGN Name:SCREEN-VALUE = Smart_List:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Type Dlg_NewName
ON VALUE-CHANGED OF Type IN FRAME Dlg_NewName
DO:

  CASE Type:SCREEN-VALUE :
      WHEN Type_Func THEN
          RUN set-state ( INPUT Type:SCREEN-VALUE ) .
          
      WHEN Type_Local THEN
      DO:
          IF NUM-ENTRIES(p_Smart_List) = 0 THEN
          DO:
            MESSAGE "This object does not have any functions to override."
              VIEW-AS ALERT-BOX INFORMATION IN WINDOW ACTIVE-WINDOW.
            ASSIGN Type:SCREEN-VALUE = Type_Func .
            RUN set-state ( INPUT Type_Func ) .
            RETURN NO-APPLY.
          END.
          
          RUN set-state ( INPUT Type_Local ) .
      END.
      
      WHEN Type_Func_Ext THEN
          RUN set-state ( INPUT Type:SCREEN-VALUE ) .
          
  END CASE.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dlg_NewName 


/* ***************************  
  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ? THEN
  FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.
  
/* Make this dialog the current window. */
ASSIGN
  THIS-PROCEDURE:CURRENT-WINDOW = FRAME {&FRAME-NAME}:PARENT
  CURRENT-WINDOW                = THIS-PROCEDURE:CURRENT-WINDOW.

/* ADE okbar.i places standard ADE OK-CANCEL-HELP buttons.              */
{adecomm/okbar.i &TOOL = "AB"
                 OTHER = btn_Create_Local
                 &CONTEXT = {&New_Function_DB} }

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN set-init-values.
  RUN enable_UI.
  RUN set-state ( INPUT Init_Type ).                          
  WAIT-FOR GO OF FRAME {&FRAME-NAME} FOCUS Name.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dlg_NewName _DEFAULT-DISABLE
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
  HIDE FRAME Dlg_NewName.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dlg_NewName _DEFAULT-ENABLE
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
  DISPLAY Name Returns-Type Type 
      WITH FRAME Dlg_NewName.
  ENABLE RECT-4 Name Returns-Type Type 
      WITH FRAME Dlg_NewName.
  VIEW FRAME Dlg_NewName.
  {&OPEN-BROWSERS-IN-QUERY-Dlg_NewName}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-init-values Dlg_NewName 
PROCEDURE set-init-values :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME} :

    DO ON STOP  UNDO, LEAVE
       ON ERROR UNDO, LEAVE:
        RUN adeuib/_uibinfo.p
            (INPUT  ? ,
             INPUT  "SESSION":U ,
             INPUT  "DefaultFunctionType":U ,
             OUTPUT Returns-Type).
    END.
    
    IF Returns-Type:LOOKUP(Returns-Type) = 0 THEN
      ASSIGN Returns-Type = "CHARACTER":U.

    ASSIGN Name                  = p_Name
           Init_Type             = Type_Func.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-state Dlg_NewName 
PROCEDURE set-state :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_State    AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE Ret_Val           AS LOGICAL      NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME} :
    IF p_Smart_List = Nul THEN
        ASSIGN Ret_Val = Type:DISABLE( "Override" ).

    CASE p_State :
    
        WHEN Type_Func THEN
        DO:
            ASSIGN Name:SCREEN-VALUE      = Nul
                   Name:SENSITIVE         = TRUE
                   Smart_List:SENSITIVE   = FALSE
                   Smart_List:LIST-ITEMS  = ""
                   Smart_List:SCREEN-VALUE = ?
                   Smart_List:VISIBLE     = NO
                   Returns-Type:SENSITIVE = TRUE
                   Returns-Type:VISIBLE   = TRUE
                   Returns-Type-2:VISIBLE = FALSE
                   .
            APPLY "ENTRY" TO Name .
        END.
        
        /* Process a Type_Func again, but leave the current screen-value so
           the user can change it to be a correct entry. */
        WHEN (Type_Func + Invalid_Entry) THEN
        DO:
            ASSIGN Name:SENSITIVE         = TRUE
                   Returns-Type:SENSITIVE = TRUE
                   Returns-Type:VISIBLE   = TRUE
                   Returns-Type-2:VISIBLE = FALSE
                   Smart_List:VISIBLE     = NO
                   .
            APPLY "ENTRY" TO Name .
        END.

        WHEN Type_Local THEN
        DO:
            ASSIGN Type:SCREEN-VALUE    = Type_Local.
            
            ASSIGN Smart_List:LIST-ITEMS = p_Smart_List
                   Smart_List:SCREEN-VALUE = Smart_List:ENTRY(1)
                   Name:SCREEN-VALUE    = REPLACE( Smart_List:SCREEN-VALUE ,
                                                   Smart_Prefix , Local_Prefix )
                   Name:SENSITIVE         = FALSE
                   Smart_List:SENSITIVE   = TRUE
                   Smart_List:VISIBLE     = YES
                   Returns-Type:VISIBLE   = FALSE
                   Returns-Type:SENSITIVE = FALSE
                   Returns-Type-2:VISIBLE = FALSE    /* JEP-UNFINISHED */
                   .
            ASSIGN Returns-Type-2:SCREEN-VALUE = "". /* JEP-UNFINISHED */
        END.

    END CASE.
    
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetFuncCode Dlg_NewName 
FUNCTION GetFuncCode RETURNS CHARACTER
  ( /* parameter-definitions */
    INPUT p_Func_Name   AS CHARACTER,
    INPUT p_ObjHandle   AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR Func_Code   AS CHARACTER NO-UNDO.
  DEFINE VAR Signature   AS CHARACTER NO-UNDO.
  DEFINE VAR ParamDefs   AS CHARACTER NO-UNDO.
  DEFINE VAR ParamList   AS CHARACTER NO-UNDO.
  DEFINE VAR ParamRun    AS CHARACTER NO-UNDO.
  DEFINE VAR ParamType   AS CHARACTER NO-UNDO.
  DEFINE VAR Parm        AS CHARACTER NO-UNDO.
  DEFINE VAR Return_Type AS CHARACTER NO-UNDO.
  DEFINE VAR Space_Char  AS CHARACTER NO-UNDO INIT " ".
  DEFINE VAR nItem       AS INTEGER   NO-UNDO.
  DEFINE VAR hSuper_Proc AS HANDLE    NO-UNDO.
  
  &SCOPED-DEFINE EOL CHR(10)
  &SCOPED-DEFINE COMMENT-LINE ------------------------------------------------------------------------------

  
  DO nItem = 1 TO NUM-ENTRIES(p_ObjHandle):
    ASSIGN hSuper_Proc = WIDGET-HANDLE(ENTRY(nItem, p_ObjHandle)).
    IF VALID-HANDLE( hSuper_Proc ) AND
       CAN-DO(hSuper_Proc:INTERNAL-ENTRIES, p_Func_Name) THEN LEAVE.
  END.

  ASSIGN Signature    = hSuper_Proc:GET-SIGNATURE(p_Func_Name)
         Return_Type  = CAPS(ENTRY(2, Signature))
         ParamDefs    = IF ENTRY(3, Signature) <> ""
                        THEN SUBSTRING(Signature, INDEX(Signature, ENTRY(3, Signature)))
                        ELSE ""
         ParamList    = ParamDefs
         p_Returns    = Return_Type
         NO-ERROR.
  ASSIGN
      Func_Code =
      "RETURNS " + Return_Type.

  /* Format the FUNCTION header parameter list. */
  DO nItem = 1 TO NUM-ENTRIES( ParamList ):
    ASSIGN Parm = ENTRY( nItem , ParamList ).
    
    /* Determine the various parameter formats. */
    IF ENTRY(1, Parm, " ") = "BUFFER" OR
       ENTRY(2, Parm, " ") = "TABLE" THEN
    DO:
        /* Buffer and Table parameters must use "FOR" option. */
        ParamType = "FOR":u.
    END. /* BUFFER or TABLE */
    ELSE IF ENTRY(2, Parm, " ") = "TABLE-HANDLE" THEN
    DO:
        /* Parsing string "INPUT TABLE-HANDLE table-handle-name [FOR]". */
        IF NUM-ENTRIES(Parm, " ") > 3 THEN
            /* Process the "FOR" option. */
            ParamType = "FOR":u.
        ELSE
            ParamType = "":u.
    END. /* TABLE-HANDLE */
    ELSE /* Regular Data-type parameter */
    DO:
        ParamType = "AS".
    END. /* AS DATA-TYPE */
    
    ASSIGN Parm = REPLACE( Parm ,
                           Space_Char + ENTRY(3, Parm, Space_Char) ,
                           Space_Char + ParamType + " " + ENTRY(3, Parm, Space_Char ) )
           Parm = IF nItem > 1 THEN {&EOL} + FILL(" ",4) + Parm ELSE Space_Char + Parm
           ParamList = REPLACE( ParamList , ENTRY(nItem , ParamList), Parm )
           NO-ERROR.
  END.
  IF (ParamList = "") THEN
    ASSIGN ParamList = " /* parameter-definitions */ ".
  
  ASSIGN Func_Code = Func_Code + {&EOL} + FILL(Space_Char , 2) + "(" + ParamList + ") :".

  ASSIGN Func_Code =
      Func_Code + {&EOL} +
      "/*{&COMMENT-LINE}" + {&EOL} +
      "  Purpose:     Super Override" + {&EOL} + 
      "  Notes:       " + {&EOL} + 
      "{&COMMENT-LINE}*/" + {&EOL}.

  /* Format the SUPER() FUNCTION PARAMETER statement. */
  ASSIGN ParamList    = ParamDefs.
  DO nItem = 1 TO NUM-ENTRIES(ParamDefs):
    ASSIGN parm     = ENTRY(nitem, ParamDefs).

    IF ENTRY(2, Parm, " ") = "TABLE" OR
       ENTRY(2, Parm, " ") = "TABLE-HANDLE" THEN
    DO:
      ASSIGN
           parm     = ENTRY(1, parm, " ") + " " + ENTRY(2, parm, " ") + " " + ENTRY(3, parm, " ")
           ParamRun = TRIM(ParamRun + ", " + Parm, ",").
    END. /* TABLE or TABLE-HANDLE */
    ELSE
    DO:
      ASSIGN
           parm     = ENTRY(1, parm, " ") + " " + ENTRY(2, parm, " ")
           ParamRun = TRIM(ParamRun + ", " + Parm, ",").
    END. /* DATA-TYPE and BUFFER */
  END.
  ASSIGN ParamRun = "(" + ParamRun + " )".

  ASSIGN Func_Code =
      Func_Code + {&EOL} +      
      "  /* Code placed here will execute PRIOR to standard behavior. */" + {&EOL} +
      {&EOL} +
      "  RETURN SUPER" + ParamRun + "." + {&EOL} +
      {&EOL} +
      "END FUNCTION.".

  RETURN Func_Code.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

