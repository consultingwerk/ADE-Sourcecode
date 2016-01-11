&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" vTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" vTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"ry/obj/ryemptysdo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*---------------------------------------------------------------------------------
  File: rtbimportcompilev.w

  Description:  Import Compile Viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/29/2003  Author:     

  Update Notes: Created from Template rysttviewv.w

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rtbimportcompilev.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}
{src/adm2/widgetprto.i}

{rtb/inc/afrtbglobs.i} /* pull in Roundtable global variables */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/ryemptysdo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buButton ToDelete EdResult 
&Scoped-Define DISPLAYED-OBJECTS ToDelete EdResult 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buButton 
     LABEL "&Start Compile" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE EdResult AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 80 BY 15.71 NO-UNDO.

DEFINE VARIABLE ToDelete AS LOGICAL INITIAL no 
     LABEL "&Delete Import Table" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.6 BY .81 TOOLTIP "Delete import table when finished compiling" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buButton AT ROW 1 COL 1.4
     ToDelete AT ROW 1.19 COL 17.4
     EdResult AT ROW 2.24 COL 1 NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/ryemptysdo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/ryemptysdo.i}
      END-FIELDS.
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 17.86
         WIDTH              = 82.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

ASSIGN 
       EdResult:RETURN-INSERTED IN FRAME frMain  = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buButton
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buButton vTableWin
ON CHOOSE OF buButton IN FRAME frMain /* Start Compile */
DO:
  RUN compileSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE compileSource vTableWin 
PROCEDURE compileSource :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMessage        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    edResult:INSERT-STRING("~n":U).
    edResult:INSERT-STRING("Import Table Compile - STARTED":U + "~n":U).
    edResult:INSERT-STRING("~n":U).
    edResult:INSERT-STRING(" - Workspace ID : ":U        + grtb-wspace-id           + "~n":U).
    edResult:INSERT-STRING(" - Workspace Root Path : ":U + grtb-wsroot              + "~n":U).
    edResult:INSERT-STRING(" - Delete Import Table : ":U + STRING(toDelete:CHECKED) + "~n":U).
    edResult:INSERT-STRING("~n":U).

    FIND FIRST rtb_import NO-LOCK
      WHERE rtb_import.wspace-id = grtb-wspace-id
      AND   rtb_import.obj-type  = "PCODE"
      AND   rtb_import.done      = YES
      NO-ERROR.
    IF NOT AVAILABLE rtb_import
    THEN DO:
      edResult:INSERT-STRING(" No Import Table records found to compile ... ":U + "~n":U).
    END.

    FOR EACH rtb_import NO-LOCK
      WHERE rtb_import.wspace-id = grtb-wspace-id
      AND   rtb_import.obj-type  = "PCODE"
      AND   rtb_import.done      = YES
     ,FIRST rtb_moddef NO-LOCK
        WHERE rtb_moddef.module = rtb_import.module
        :

      IF NOT CAN-DO("*.p,*.w":U,rtb_import.object)
      THEN NEXT.

      edResult:INSERT-STRING(" ... ":U + rtb_moddef.directory + "/":U + rtb_import.object + "~n":U).

      PROCESS EVENTS.

      ASSIGN
        cMessage = "":U.

      COMPILE   VALUE(grtb-wsroot + "/":U + rtb_moddef.directory + "/":U + rtb_import.object)
      SAVE INTO VALUE(grtb-wsroot + "/":U + rtb_moddef.directory)
      NO-ERROR.

      PROCESS EVENTS.

      IF COMPILER:ERROR
      THEN
      DO iLoop = 1 TO ERROR-STATUS:NUM-MESSAGES:
        cMessage = cMessage
                 + (IF cMessage <> "":U THEN CHR(10) ELSE "":U)
                 + "     ":U + ERROR-STATUS:GET-MESSAGE(iLoop).
      END.
      ELSE
        cMessage = cMessage
                 + (IF cMessage <> "":U THEN CHR(10) ELSE "":U)
                 + "Done".

      edResult:INSERT-STRING(cMessage + "~n":U + "~n":U).
  
    END.

    IF toDelete:CHECKED
    THEN
    FOR EACH rtb_import
      WHERE rtb_import.wspace-id = grtb-wspace-id:
      DELETE rtb_import.
    END.

    edResult:INSERT-STRING("~n":U).
    edResult:INSERT-STRING("Import Table Compile - FINISH":U + "~n":U).
    edResult:INSERT-STRING("~n":U).

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
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
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

