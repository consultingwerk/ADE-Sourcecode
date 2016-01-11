&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" wiWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" wiWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wiWin 
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
/*---------------------------------------------------------------------------------
  File: afrtbcompw.w

  Description:  RTB Import Table Compiler
  
  Purpose:      RTB Import Table Compiler

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000149   UserRef:    
                Date:   24/05/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rysttbconw.w

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

&scop object-name       afrtbcompw.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartWindow yes

{af/sup2/afglobals.i}

{rtb/inc/afrtbglobs.i} /* pull in Roundtable global variables */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buButton ToDelete EdResult 
&Scoped-Define DISPLAYED-OBJECTS ToDelete EdResult 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wiWin AS WIDGET-HANDLE NO-UNDO.

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
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wiWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Roundtable Import Table Compile"
         HEIGHT             = 17
         WIDTH              = 80
         MAX-HEIGHT         = 45.33
         MAX-WIDTH          = 256
         VIRTUAL-HEIGHT     = 45.33
         VIRTUAL-WIDTH      = 256
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wiWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wiWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
                                                                        */
ASSIGN 
       EdResult:RETURN-INSERTED IN FRAME frMain  = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
THEN wiWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON END-ERROR OF wiWin /* Roundtable Import Table Compile */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON WINDOW-CLOSE OF wiWin /* Roundtable Import Table Compile */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON WINDOW-RESIZED OF wiWin /* Roundtable Import Table Compile */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      FRAME {&FRAME-NAME}:WIDTH-PIXELS = SELF:WIDTH-PIXELS
      FRAME {&FRAME-NAME}:HEIGHT-PIXELS = SELF:HEIGHT-PIXELS
      EdResult:WIDTH-PIXELS = SELF:WIDTH-PIXELS
      EdResult:HEIGHT-PIXELS = SELF:HEIGHT-PIXELS
      NO-ERROR.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buButton
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buButton wiWin
ON CHOOSE OF buButton IN FRAME frMain /* Start Compile */
DO:
  RUN CompileSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wiWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wiWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE compileSource wiWin 
PROCEDURE compileSource :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cErrorMessage AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMessage AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop    AS INTEGER    NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

  FOR EACH rtb_import NO-LOCK
    WHERE rtb_import.wspace-id = grtb-wspace-id
    AND   rtb_import.obj-type  = "PCODE"
    AND   rtb_import.done      = YES,
    FIRST rtb_moddef 
    WHERE rtb_moddef.module = rtb_import.module NO-LOCK:

    IF NOT CAN-DO("*.p,*.w":U,rtb_import.OBJECT) THEN
      NEXT.
  
    edResult:INSERT-STRING(grtb-wsroot + "/":U + rtb_moddef.DIRECTORY + "/":U + rtb_import.OBJECT + " ... ":U).
    
    PROCESS EVENTS.

    COMPILE VALUE(grtb-wsroot + "/":U + rtb_moddef.DIRECTORY + "/":U + rtb_import.OBJECT) SAVE INTO
            VALUE(grtb-wsroot + "/":U + rtb_moddef.DIRECTORY) NO-ERROR.

    PROCESS EVENTS.

    IF COMPILER:ERROR THEN
    DO iLoop = 1 TO ERROR-STATUS:NUM-MESSAGES:
      cMessage = cMessage + CHR(10) + "    ":U + ERROR-STATUS:GET-MESSAGE(iLoop).
    END.
    ELSE
      cMessage = "Done".

    /* Compile client proxy _cl version of SDO also */
    IF SEARCH("rtb/prc/afcompsdop.p":U) <> ?
    OR SEARCH("rtb/prc/afcompsdop.r":U) <> ?
    THEN DO:
        FIND FIRST rtb_object NO-LOCK
            WHERE rtb_object.wspace-id = rtb_import.wspace-id
            AND   rtb_object.object    = rtb_import.object
            NO-ERROR.
        IF AVAILABLE rtb_object
        THEN
            FIND FIRST rtb_ver NO-LOCK
                WHERE rtb_ver.obj-type  = "PCODE":U
                AND   rtb_ver.object    = rtb_object.object
                AND   rtb_ver.pmod      = rtb_object.pmod
                AND   rtb_ver.version   = rtb_object.version
                NO-ERROR.
            IF AVAILABLE rtb_ver
            AND rtb_ver.sub-type = "SDO":U
            THEN DO:
                RUN rtb/prc/afcompsdop.p (INPUT STRING(RECID(rtb_object)) ).
            END.
    END.

    IF SEARCH("rtb/prc/afrtbappsp.p":U) <> ?
    OR SEARCH("rtb/prc/afrtbappsp.r":U) <> ?
    THEN
      RUN rtb/prc/afrtbappsp.p (INPUT 0,                  
                                INPUT rtb_import.OBJECT,  
                                OUTPUT cErrorMessage).

    IF cErrorMessage <> "" THEN
      ASSIGN
        cMessage = cMessage + CHR(10) + "    ":U + cErrorMessage.

    edResult:INSERT-STRING(cMessage + CHR(10)).
  
    ASSIGN
      cMessage = "":U.

  END.

  IF toDelete:CHECKED THEN
  FOR EACH rtb_import
    WHERE rtb_import.wspace-id = grtb-wspace-id:
    DELETE rtb_import.
  END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wiWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
  THEN DELETE WIDGET wiWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wiWin  _DEFAULT-ENABLE
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
  DISPLAY ToDelete EdResult 
      WITH FRAME frMain IN WINDOW wiWin.
  ENABLE buButton ToDelete EdResult 
      WITH FRAME frMain IN WINDOW wiWin.
  {&OPEN-BROWSERS-IN-QUERY-frMain}
  VIEW wiWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wiWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

