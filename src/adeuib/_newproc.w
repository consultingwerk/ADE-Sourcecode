&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dlg_NewName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dlg_NewName 
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

  File    :    _newproc.w
  Purpose :    Section Editor New Procedure Dialog Box.
  Syntax  :    
            RUN adeuib/_newproc.w ( INPUT p_Objects       ,
                                    INPUT p_Command       ,
                                    INPUT p_Smart_List    ,
                                    INPUT p_Invalid_List  ,
                                    INPUT-OUTPUT p_Name   ,
                                    OUTPUT p_Type         ,
                                    OUTPUT p_OK           )
  
  Description: 
    Use the New Procedure dialog box to create a new procedure. 

  Input Parameters:
    Yes. See Definitions section for input parameters.

  Output Parameters:
    p_Name    - Name of the entered procedure.
    p_Type    - Type of procedure selected.
    p_OK      - TRUE means user choose OK. FALSE means user choose Cancel.

  Author:    J. Palazzo

  Created: 01/20/95 -  5:38 pm

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
DEFINE VARIABLE p_Smart_List    AS CHARACTER NO-UNDO INIT "adm-exit,adm-hello".
DEFINE VARIABLE p_Invalid_List  AS CHARACTER NO-UNDO INIT "adm-exit,adm-hello,dispatch".
DEFINE VARIABLE p_Name          AS CHARACTER NO-UNDO .
DEFINE VARIABLE p_Type          AS CHARACTER NO-UNDO .
DEFINE VARIABLE p_Code_Block    AS CHARACTER NO-UNDO .
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
DEFINE OUTPUT PARAMETER p_Code_Block    AS CHARACTER NO-UNDO .
    /* Code to create in Section Editor.                    */
DEFINE OUTPUT PARAMETER p_OK            AS LOGICAL   NO-UNDO .
    /* YES - User choose OK. NO - User choose Cancel.       */
&ENDIF

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE Nul           AS CHARACTER    NO-UNDO INIT "":U .
DEFINE VARIABLE Unknown       AS CHARACTER    NO-UNDO INIT ? .
DEFINE VARIABLE Init_Type     AS CHARACTER    NO-UNDO .
DEFINE VARIABLE Smart_Prefix  AS CHARACTER    NO-UNDO INIT "adm-":U .
DEFINE VARIABLE Local_Prefix  AS CHARACTER    NO-UNDO INIT "local-":U .
DEFINE VARIABLE Type_Proc     AS CHARACTER    NO-UNDO INIT "_PROCEDURE":U .
DEFINE VARIABLE Type_Local    AS CHARACTER    NO-UNDO INIT "_LOCAL":U .
DEFINE VARIABLE Type_Default  AS CHARACTER    NO-UNDO INIT "_DEFAULT":U .
DEFINE VARIABLE Default_List  AS CHARACTER    NO-UNDO .
DEFINE VARIABLE Invalid_Entry AS CHARACTER    NO-UNDO INIT "_INVALID-ENTRY":U .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dlg_NewName

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 Name Type 
&Scoped-Define DISPLAYED-OBJECTS Name Type 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetDefParams Dlg_NewName 
FUNCTION GetDefParams RETURNS CHARACTER
  ( INPUT p_ParamList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetProcCode Dlg_NewName 
FUNCTION GetProcCode RETURNS CHARACTER
  ( /* parameter-definitions */
    INPUT p_Proc_Name   AS CHARACTER,
    INPUT p_ObjHandle   AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE Smart_List AS CHARACTER FORMAT "X(64)":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 20
     LIST-ITEMS "","" 
     SIZE 42 BY 1
     FONT 2 NO-UNDO.

DEFINE VARIABLE Name AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Name" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1 NO-UNDO.

DEFINE VARIABLE Type AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&Procedure", "_PROCEDURE",
"&Override", "_LOCAL"
     SIZE 23 BY 2.86 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 50 BY 4.81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dlg_NewName
     Name AT ROW 1.48 COL 8 COLON-ALIGNED
     Smart_List AT ROW 1.48 COL 8 COLON-ALIGNED NO-LABEL
     Type AT ROW 4.38 COL 11 NO-LABEL
     " Type" VIEW-AS TEXT
          SIZE 6.8 BY .67 AT ROW 3.14 COL 4
     RECT-4 AT ROW 3.43 COL 2
     SPACE(0.79) SKIP(0.18)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "New Procedure".


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
       FRAME Dlg_NewName:SCROLLABLE       = FALSE.

/* SETTINGS FOR COMBO-BOX Smart_List IN FRAME Dlg_NewName
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       Smart_List:HIDDEN IN FRAME Dlg_NewName           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dlg_NewName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dlg_NewName Dlg_NewName
ON GO OF FRAME Dlg_NewName /* New Procedure */
DO:

  DEFINE VARIABLE Valid_Entry    AS LOGICAL     NO-UNDO.

  /* Trim leading spaces. */
  ASSIGN Name:SCREEN-VALUE = TRIM(Name:SCREEN-VALUE).
  
  /* Validate that the name is a legal PROGRESS internal procedure name. */
  RUN adecomm/_valpnam.p
      (INPUT  Name:SCREEN-VALUE, INPUT TRUE, INPUT "_INTERNAL":U,
       OUTPUT Valid_Entry ).

  IF NOT Valid_Entry THEN
  DO:    
      RUN set-state ( INPUT Type:SCREEN-VALUE + Invalid_Entry ).
      RETURN NO-APPLY.
  END.
  
  /* Don't allow the user to enter a duplicate name. */
  IF CAN-DO ( p_Invalid_List , Name:SCREEN-VALUE ) THEN
  DO:
      MESSAGE Name:SCREEN-VALUE    SKIP(1)
              "This name is reserved, or already defined in an included Method Library."
              VIEW-AS ALERT-BOX INFORMATION IN WINDOW ACTIVE-WINDOW .
      RUN set-state ( INPUT Type:SCREEN-VALUE + Invalid_Entry ).
      RETURN NO-APPLY.
  END.

  ASSIGN p_Name = Name:SCREEN-VALUE
         p_Type = Type:SCREEN-VALUE
         p_OK   = TRUE .

  /* If type is local, check if user is working with an "adm-" V8 style local override.
     If not, build the V9 style super override code. */
  IF (p_Type = Type_Local) AND NOT (Smart_List:SCREEN-VALUE BEGINS Smart_Prefix) THEN
    p_Code_Block = GetProcCode( INPUT p_Name, INPUT p_Objects).

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
      WHEN Type_Proc THEN
          RUN set-state ( INPUT Type:SCREEN-VALUE ) .
          
      WHEN Type_Local THEN
      DO:
          IF NUM-ENTRIES(p_Smart_List) = 0 THEN
          DO:
            MESSAGE "This object does not have any procedures to override."
              VIEW-AS ALERT-BOX INFORMATION IN WINDOW ACTIVE-WINDOW.
            ASSIGN Type:SCREEN-VALUE = Type_Proc .
            RUN set-state ( INPUT Type_Proc ) .
            RETURN NO-APPLY.
          END.
          
          RUN set-state ( INPUT Type_Local ) .
      END.
      
      WHEN Type_Default THEN
          RUN set-state ( INPUT Type:SCREEN-VALUE ) .
          
  END CASE.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dlg_NewName 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* ADE okbar.i places standard ADE OK-CANCEL-HELP buttons.              */
{adecomm/okbar.i &TOOL = "AB"
                 &CONTEXT = {&New_Procedure_Dlg_Box} }

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
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
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
  DISPLAY Name Type 
      WITH FRAME Dlg_NewName.
  ENABLE RECT-4 Name Type 
      WITH FRAME Dlg_NewName.
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
      ASSIGN Name                  = p_Name
             Default_List          = "adm-create-objects,adm-row-available," +
                                     "enable_UI,disable_UI,send-records"
             Init_Type             = Type_Proc
             . /* END ASSIGN */

      IF p_Command = "OVERRIDE":U THEN
        ASSIGN Init_Type  = Type_Local.
  
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
    
        WHEN Type_Proc THEN
        DO:
            ASSIGN Name:SCREEN-VALUE    = Nul
                   Name:SENSITIVE       = TRUE
                   Smart_List:SENSITIVE = FALSE
                   Smart_List:LIST-ITEMS = ""
                   Smart_List:SCREEN-VALUE = ?
                   Smart_List:VISIBLE   = NO
                   .
            APPLY "ENTRY" TO Name .
        END.
        
        /* Process a Type_Proc again, but leave the current screen-value so
           the user can change it to be a correct entry. */
        WHEN Type_Proc + Invalid_Entry THEN
        DO:
            ASSIGN Name:SENSITIVE       = TRUE
/*                   Smart_List:SENSITIVE = FALSE */
                   Smart_List:VISIBLE   = NO
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
                   Name:SENSITIVE       = FALSE
                   Smart_List:SENSITIVE = TRUE
                   Smart_List:VISIBLE   = YES
                   .
        END.
        
        WHEN Type_Default THEN
        DO:
            ASSIGN Type:SCREEN-VALUE    = Type_Default.
            
            ASSIGN Smart_List:LIST-ITEMS   = Default_List
                   Smart_List:SCREEN-VALUE = Smart_List:ENTRY(1)
                   Name:SCREEN-VALUE       = Smart_List:ENTRY(1)
                   Name:SENSITIVE          = FALSE
                   Smart_List:SENSITIVE    = TRUE
                   Smart_List:VISIBLE      = YES
                   .
        END.

    END CASE.
    
    
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetDefParams Dlg_NewName 
FUNCTION GetDefParams RETURNS CHARACTER
  ( INPUT p_ParamList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Return the DEFINE PARAMETER statements for a GET-SIGNATURE param list.
    
  Input Parameters:
    p_ParamList - Parameter List string from a GET-SIGNATURE call.
 
  Output Parameters:
    p_code     - The DEFINE PARAMETER statements.

  Author: John Palazzo
------------------------------------------------------------------------------*/

&SCOPED-DEFINE EOL CHR(10)

DEFINE VARIABLE DefParams   AS CHARACTER NO-UNDO.
DEFINE VARIABLE paramItem   AS CHARACTER NO-UNDO.
DEFINE VARIABLE varMode     AS CHARACTER NO-UNDO.
DEFINE VARIABLE varName     AS CHARACTER NO-UNDO.
DEFINE VARIABLE varType     AS CHARACTER NO-UNDO.
DEFINE VARIABLE AlignName   AS INTEGER   NO-UNDO.
DEFINE VARIABLE AlignMode   AS INTEGER   NO-UNDO.
DEFINE VARIABLE nItem       AS INTEGER   NO-UNDO.

IF ( p_ParamList <> "" ) then
DO:
  DO nItem = 1 TO NUM-ENTRIES(p_ParamList, ","):
    ASSIGN paramItem   = ENTRY(nItem, p_ParamList).

    /* Determine the various PARAMETER statement formats. */
    IF ENTRY(2, paramItem, " ") = "TABLE" THEN
    DO:
        /* Parsing string "INPUT TABLE table-name". Treat TABLE keyword as name. */
        ASSIGN varMode = ENTRY(1, paramItem, " ")
               varName = ENTRY(2, paramItem, " ").
    END.
    ELSE IF ENTRY(3, paramItem, " ") = "TABLE-HANDLE" THEN
    DO:
        /* Parsing string "INPUT TABLE-HANDLE table-handle-name [FOR]".
           Treat TABLE-HANDLE keyword as name. */
        ASSIGN varMode = ENTRY(1, paramItem, " ")
               varName = ENTRY(2, paramItem, " ").
    END.
    ELSE /* Regular Data-type or Buffer parameter */
    DO:
        /* Parsing string "INPUT param-name Data-Type" or
                          "BUFFER buf-name table-name". */
        ASSIGN varMode = ENTRY(1, paramItem, " ")
               varName = ENTRY(2, paramItem, " ").
    END.
    
    /* We'll use mode & name to align the define parameter statements. */
    ASSIGN AlignMode = MAXIMUM(AlignMode, LENGTH(varMode, "character"))
           AlignName = MAXIMUM(AlignName, LENGTH(varName, "character")).
  END.
END.

DO nItem = 1 TO NUM-ENTRIES(p_ParamList):
    /* Extract the parameter mode, name and type. We also use the previously
       calculated maximum name length to align the "AS" and "FOR" phrases in the
       define parameter statements. */
    ASSIGN paramItem   = ENTRY(nItem, p_ParamList).

    /* Determine the various PARAMETER statement formats. */
    IF ENTRY(2, paramItem, " ") = "TABLE" THEN
    DO:
        /* Parsing string "INPUT TABLE table-name". Treat TABLE keyword as name. */
        ASSIGN varMode = ENTRY(1, paramItem, " ")
               varMode = varMode + FILL(" " , AlignMode - LENGTH(varMode, "character"))
               varName = ENTRY(2, paramItem, " ")
               varName = varName + FILL(" " , AlignName - LENGTH(varName, "character"))
               varType = ENTRY(3, paramItem, " ").
        ASSIGN DefParams = DefParams
               + ("  DEFINE " + varMode + " PARAMETER " + varName + " ")
               + ("FOR " + varType + "." + {&EOL}).
    END. /* TABLE */
    ELSE IF ENTRY(2, paramItem, " ") = "TABLE-HANDLE" THEN
    DO:
        /* Parsing string "INPUT TABLE-HANDLE table-handle-name [FOR]". */
        ASSIGN varMode = ENTRY(1, paramItem, " ")
               varMode = varMode + FILL(" " , AlignMode - LENGTH(varMode, "character"))
               varName = ENTRY(2, paramItem, " ")
               varName = varName + FILL(" " , AlignName - LENGTH(varName, "character"))
               varType = ENTRY(3, paramItem, " ").
        IF NUM-ENTRIES(paramItem, " ") > 3 THEN
        DO: /* Process the "FOR" option. */
            varType = ENTRY(4, paramItem, " ") /* FOR */ + " " + varType.
        END.
        ASSIGN DefParams = DefParams
               + ("  DEFINE " + varMode + " PARAMETER " + varName + " ")
               + (varType + "." + {&EOL}).
    END. /* TABLE-HANDLE */
    ELSE /* Regular Data-type or Buffer parameter */
    DO:
        /* Parsing string "INPUT param-name Data-Type" or
                          "BUFFER buf-name table-name". */
        ASSIGN varMode = ENTRY(1, paramItem, " ")
               varMode = varMode + FILL(" " , AlignMode - LENGTH(varMode, "character"))
               varName = ENTRY(2, paramItem, " ")
               varName = varName + FILL(" " , AlignName - LENGTH(varName, "character"))
               varType = ENTRY(3, paramItem, " ").
        IF varMode = "BUFFER" THEN
        DO:
          ASSIGN DefParams = DefParams
                 + ("  DEFINE PARAMETER ":u + varMode + " ":u)
                 + varName
                 + (" FOR " + varType + ".") + {&EOL}.
        END. /* Buffer */
        ELSE /* Data-Type */
        DO:
          ASSIGN DefParams = DefParams
                 + ("  DEFINE " + varMode + " PARAMETER ")
                 + varName
                 + (" AS " + varType + " NO-UNDO.") + {&EOL}.
        END. /* Data-Type */
    END. /* Data-Type|Buffer */
END. /* DO NUM-ENTRIES(p_ParamList) */

RETURN DefParams.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetProcCode Dlg_NewName 
FUNCTION GetProcCode RETURNS CHARACTER
  ( /* parameter-definitions */
    INPUT p_Proc_Name   AS CHARACTER,
    INPUT p_ObjHandle   AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR p_Code      AS CHARACTER NO-UNDO.
  DEFINE VAR Signature   AS CHARACTER NO-UNDO.
  DEFINE VAR ParamDef    AS CHARACTER NO-UNDO.
  DEFINE VAR ParamRun    AS CHARACTER NO-UNDO.
  DEFINE VAR Parm        AS CHARACTER NO-UNDO.
  DEFINE VAR nItem       AS INTEGER   NO-UNDO.
  DEFINE VAR hSuper_Proc AS HANDLE    NO-UNDO.
  
  &SCOPED-DEFINE EOL CHR(10)
  &SCOPED-DEFINE COMMENT-LINE ------------------------------------------------------------------------------

  
  DO nItem = 1 TO NUM-ENTRIES(p_ObjHandle):
    ASSIGN hSuper_Proc = WIDGET-HANDLE(ENTRY(nItem, p_ObjHandle)).
    IF VALID-HANDLE( hSuper_Proc ) AND
       CAN-DO(hSuper_Proc:INTERNAL-ENTRIES, p_Proc_Name) THEN LEAVE.
  END.

  ASSIGN
      p_Code = 
      "/*{&COMMENT-LINE}" + {&EOL} +
      "  Purpose:     Super Override" + {&EOL} + 
      "  Parameters:  " + {&EOL} + 
      "  Notes:       " + {&EOL} + 
      "{&COMMENT-LINE}*/" + {&EOL}.

  ASSIGN Signature  =  hSuper_Proc:GET-SIGNATURE(p_Proc_Name)
         ParamDef   = IF ENTRY(3, Signature) <> ""
                      THEN SUBSTRING(Signature, INDEX(Signature, ENTRY(3, Signature)))
                      ELSE ""
         NO-ERROR.

  /* Format the RUN SUPER PARAMETER statements. */
  DO nItem = 1 TO NUM-ENTRIES(ParamDef):
    ASSIGN parm     = ENTRY(nitem, ParamDef).
    IF ENTRY(2, parm, " ") = "TABLE" THEN
    DO:
        ParamRun = TRIM(ParamRun + ", " + Parm, ",").
    END.
    ELSE IF ENTRY(2, parm, " ") = "TABLE-HANDLE" THEN
    DO:
        /* Omit any "FOR" options (ENTRY 4) - don't belong on RUN statements. */
        parm     = ENTRY(1, parm, " ") + " " + ENTRY(2, parm, " ") + " " +
                   ENTRY(3, parm, " ").
        ParamRun = TRIM(ParamRun + ", " + Parm, ",").
    END.
    ELSE /* Regular Data-type or Buffer parameter */
    DO:
        parm     = ENTRY(1, parm, " ") + " " + ENTRY(2, parm, " ").
        ParamRun = TRIM(ParamRun + ", " + Parm, ",").
    END.
  END.

  /* Format the DEFINE PARAMETER statements. */
  ParamDef = GetDefParams(INPUT ParamDef).

  IF (ParamDef <> "") THEN
    ASSIGN p_Code   = p_Code + {&EOL} + ParamDef
           ParamRun = "(" + ParamRun + ")".

  ASSIGN p_Code = p_Code + {&EOL} +      
      "  /* Code placed here will execute PRIOR to standard behavior. */" + {&EOL} +
      {&EOL} +
      "  RUN SUPER" + ParamRun + "." + {&EOL} +
      {&EOL} +
      "  /* Code placed here will execute AFTER standard behavior.    */" + {&EOL} +
      {&EOL} +
      "END PROCEDURE.".

  RETURN p_Code.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

