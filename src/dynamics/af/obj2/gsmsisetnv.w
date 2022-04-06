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
       {"af/obj2/gscemfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*---------------------------------------------------------------------------------
  File: gsmsisetnv.w

  Description:  Set Site Number SmartDataViewer

  Purpose:      Allows a user to set their own site number

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/01/2002  Author:     Mark Davies (MIP)

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

&scop object-name       gsmsisetnv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}

DEFINE VARIABLE iSiteOldSequence1ICF AS INTEGER FORMAT ">>>>>>>>9":U NO-UNDO.
DEFINE VARIABLE iSiteOldSequence2ICF AS INTEGER FORMAT ">>>>>>>>9":U NO-UNDO.
DEFINE VARIABLE iSiteOldSessionIDICF AS INTEGER FORMAT ">>>>>>>>9":U NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gscemfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS lUpdateSequence iSiteSequence1ICF buOK 
&Scoped-Define DISPLAYED-OBJECTS iSiteNumberICF cSiteSequenceICF ~
lUpdateSequence iSiteSequence1ICF iSiteSequence2ICF iSiteSessionIDICF ~
fiICFDBLabel 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buOK AUTO-GO DEFAULT 
     LABEL "&Set" 
     SIZE 20 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE cSiteDivisionICF AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Site Division" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cSiteReverseICF AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Site reverse" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cSiteSequenceICF AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Site sequence" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE fiICFDBLabel AS CHARACTER FORMAT "X(35)":U INITIAL "ICFDB" 
      VIEW-AS TEXT 
     SIZE 12.8 BY 1 NO-UNDO.

DEFINE VARIABLE iSiteNumberICF AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Site number" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE iSiteSequence1ICF AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Site sequence 1" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE iSiteSequence2ICF AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Site sequence 2" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE iSiteSessionIDICF AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Session id" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE lUpdateSequence AS LOGICAL INITIAL no 
     LABEL "Update sequence values" 
     VIEW-AS TOGGLE-BOX
     SIZE 42 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     iSiteNumberICF AT ROW 2.05 COL 18.6 COLON-ALIGNED
     cSiteSequenceICF AT ROW 3.1 COL 18.6 COLON-ALIGNED
     lUpdateSequence AT ROW 4.14 COL 20.6
     iSiteSequence1ICF AT ROW 5.19 COL 18.6 COLON-ALIGNED
     cSiteReverseICF AT ROW 5.76 COL 18.6 COLON-ALIGNED
     iSiteSequence2ICF AT ROW 6.24 COL 18.6 COLON-ALIGNED
     buOK AT ROW 7.14 COL 43.4
     cSiteDivisionICF AT ROW 7.19 COL 18.6 COLON-ALIGNED
     iSiteSessionIDICF AT ROW 7.29 COL 18.6 COLON-ALIGNED
     fiICFDBLabel AT ROW 1 COL 18.6 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gscemfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gscemfullo.i}
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
         HEIGHT             = 8.29
         WIDTH              = 62.4.
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

/* SETTINGS FOR FILL-IN cSiteDivisionICF IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cSiteDivisionICF:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN cSiteReverseICF IN FRAME frMain
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       cSiteReverseICF:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN cSiteSequenceICF IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiICFDBLabel IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiICFDBLabel:PRIVATE-DATA IN FRAME frMain     = 
                "ICFDB".

/* SETTINGS FOR FILL-IN iSiteNumberICF IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN iSiteSequence2ICF IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN iSiteSessionIDICF IN FRAME frMain
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME buOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOK vTableWin
ON CHOOSE OF buOK IN FRAME frMain /* Set */
DO:

  ASSIGN
    iSiteNumberICF
    iSiteSequence1ICF
    iSiteSequence2ICF
    iSiteSessionIDICF
    .

  RUN setSequence.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME iSiteNumberICF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iSiteNumberICF vTableWin
ON VALUE-CHANGED OF iSiteNumberICF IN FRAME frMain /* Site number */
DO:
  {set DataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME iSiteSequence1ICF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iSiteSequence1ICF vTableWin
ON VALUE-CHANGED OF iSiteSequence1ICF IN FRAME frMain /* Site sequence 1 */
DO:
  {set DataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME iSiteSequence2ICF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iSiteSequence2ICF vTableWin
ON VALUE-CHANGED OF iSiteSequence2ICF IN FRAME frMain /* Site sequence 2 */
DO:
  {set DataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME iSiteSessionIDICF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iSiteSessionIDICF vTableWin
ON VALUE-CHANGED OF iSiteSessionIDICF IN FRAME frMain /* Session id */
DO:
  {set DataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lUpdateSequence
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lUpdateSequence vTableWin
ON VALUE-CHANGED OF lUpdateSequence IN FRAME frMain /* Update sequence values */
DO:

  ASSIGN
    lUpdateSequence
    .

  RUN displaySequence.
  {set DataModified TRUE}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displaySequence vTableWin 
PROCEDURE displaySequence :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:

    IF lUpdateSequence
    THEN
      ASSIGN
        iSiteSequence1ICF:SENSITIVE = YES   iSiteSequence1ICF:READ-ONLY = NO
        iSiteSequence2ICF:SENSITIVE = YES   iSiteSequence2ICF:READ-ONLY = NO
        iSiteSessionIDICF:SENSITIVE = YES   iSiteSessionIDICF:READ-ONLY = NO
        .
    ELSE
      ASSIGN
        iSiteSequence1ICF:SENSITIVE = NO    iSiteSequence1ICF:READ-ONLY = YES
        iSiteSequence2ICF:SENSITIVE = NO    iSiteSequence2ICF:READ-ONLY = YES
        iSiteSessionIDICF:SENSITIVE = NO    iSiteSessionIDICF:READ-ONLY = YES
        .

    ASSIGN
      lUpdateSequence:SCREEN-VALUE = STRING(lUpdateSequence)
      .

    DISPLAY
      iSiteSequence1ICF
      iSiteSequence2ICF
      iSiteSessionIDICF
      .
    
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSequence vTableWin 
PROCEDURE getSequence :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cCalNumberRevICF  AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE iLoop             AS INTEGER      NO-UNDO.

  DEFINE VARIABLE iSeqObj1          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeqObj2          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeqSiteDiv       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeqSiteRev       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSessnId          AS INTEGER    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN
      iSiteNumberICF    = 0
      cSiteReverseICF   = "0":U
      cSiteDivisionICF  = "0":U
      cSiteSequenceICF  = "":U
      cCalNumberRevICF  = "":U
      iSiteSequence1ICF = 0
      iSiteSequence2ICF = 0
      iSiteSessionIDICF = 0
      .

    IF CONNECTED("ICFDB":U)
    THEN DO:

      ASSIGN
        iSiteNumberICF:SENSITIVE = YES.

      RUN ry/app/rygetnobjp.p (INPUT NO,          /* do not increment */
                               OUTPUT iSeqObj1,
                               OUTPUT iSeqObj2,
                               OUTPUT iSeqSiteDiv,
                               OUTPUT iSeqSiteRev,
                               OUTPUT iSessnId).
      
      ASSIGN
        cSiteReverseICF   = STRING(iSeqSiteRev)
        cSiteDivisionICF  = STRING(iSeqSiteDiv)
        iSiteSequence1ICF = iSeqObj1
        iSiteSequence2ICF = iSeqObj2
        iSiteSessionIDICF = iSessnId
        .

      DO iLoop = LENGTH(cSiteReverseICF) TO 1 BY -1:
        cCalNumberRevICF  = cCalNumberRevICF + SUBSTRING(cSiteReverseICF,iLoop,1).
      END.

      IF  LENGTH(cSiteDivisionICF) > 1
      AND LENGTH(cSiteDivisionICF) > (LENGTH(cSiteReverseICF) + 1)
      THEN
      DO iLoop = (LENGTH(cSiteReverseICF) + 1) TO (LENGTH(cSiteDivisionICF) - 1):
        cCalNumberRevICF  = cCalNumberRevICF + "0".
      END.

      ASSIGN
        iSiteNumberICF    = INTEGER(cCalNumberRevICF)
        cSiteSequenceICF  = STRING( (INTEGER(cSiteReverseICF) / INTEGER(cSiteDivisionICF)) )
        .

    END.
    ELSE
      ASSIGN
        iSiteNumberICF:SENSITIVE = NO.

    ASSIGN
      iSiteOldSequence1ICF = iSiteSequence1ICF
      iSiteOldSequence2ICF = iSiteSequence2ICF
      iSiteOldSessionIDICF = iSiteSessionIDICF
      .

    ASSIGN
      iSiteNumberICF:SCREEN-VALUE     = STRING(iSiteNumberICF)
      cSiteReverseICF:SCREEN-VALUE    = cSiteReverseICF
      cSiteDivisionICF:SCREEN-VALUE   = cSiteDivisionICF
      cSiteSequenceICF:SCREEN-VALUE   = cSiteSequenceICF
      iSiteSequence1ICF:SCREEN-VALUE  = STRING(iSiteSequence1ICF)
      iSiteSequence2ICF:SCREEN-VALUE  = STRING(iSiteSequence2ICF)
      iSiteSessionIDICF:SCREEN-VALUE  = STRING(iSiteSessionIDICF)
      .

  END.

  RUN displaySequence.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN displayFields (INPUT "?":U).
  RUN getSequence.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSequence vTableWin 
PROCEDURE setSequence :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cCalReverseICF  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lContinueChange AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lContinueDiff   AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.

  DEFINE VARIABLE iSeqObj1          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeqObj2          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeqSiteDiv       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeqSiteRev       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSessnId          AS INTEGER    NO-UNDO.

  ASSIGN
      cCalReverseICF = "":U
      .

  IF CONNECTED("ICFDB":U)
  THEN DO:

    IF lUpdateSequence
    THEN DO:

      ASSIGN
        lContinueChange = NO
        lContinueDiff   = NO
        .

      RUN ry/app/rygetnobjp.p (INPUT NO,          /* do not increment */
                               OUTPUT iSeqObj1,
                               OUTPUT iSeqObj2,
                               OUTPUT iSeqSiteDiv,
                               OUTPUT iSeqSiteRev,
                               OUTPUT iSessnId).

      IF iSiteOldSequence1ICF <> iSeqObj1
      OR iSiteOldSequence2ICF <> iSeqObj2
      OR iSiteOldSessionIDICF <> iSessnId
      THEN
        MESSAGE "The ICFDB sequence values have been changed by another user"
          SKIP  "Do you wish to continue ? "
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lContinueChange.
      ELSE
        ASSIGN
          lContinueChange = YES.

      IF iSiteSequence1ICF < iSeqObj1
      OR iSiteSequence2ICF < iSeqObj2
      OR iSiteSessionIDICF < iSessnId
      THEN
        MESSAGE "One or more of the new ICFDB sequence values are lower than the previous values"
          SKIP  "Do you wish to continue ? "
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lContinueDiff.
      ELSE
        ASSIGN
          lContinueDiff = YES.

      IF  lContinueChange = NO
      OR lContinueDiff   = NO THEN
      DO: /* reset */
        ASSIGN
          iSiteSequence1ICF = iSeqObj1
          iSiteSequence2ICF = iSeqObj2
          iSiteSessionIDICF = iSessnId
          .
      END.
    END.

    DO iLoop = LENGTH(STRING(iSiteNumberICF)) TO 1 BY -1:
      cCalReverseICF = cCalReverseICF + SUBSTRING(STRING(iSiteNumberICF),iLoop,1).
    END.

    ASSIGN
      cSiteReverseICF    = cCalReverseICF
      cSiteDivisionICF   = "1":U + FILL("0":U,LENGTH(STRING(iSiteNumberICF)))
      cSiteSequenceICF   = STRING( (INTEGER(cSiteReverseICF) / INTEGER(cSiteDivisionICF)) )
      .

    RUN ry/app/rysetsitep.p (INPUT iSiteSequence1ICF,
                             INPUT iSiteSequence2ICF,
                             INPUT INTEGER(cSiteDivisionICF),
                             INPUT INTEGER(cSiteReverseICF),
                             INPUT iSiteSessionIDICF).
    {set DataModified FALSE}.
  END.

  ASSIGN
    lUpdateSequence = NO.

  RUN displaySequence.

  RUN getSequence.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord vTableWin 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      iSiteNumberICF
      iSiteSequence1ICF
      iSiteSequence2ICF
      iSiteSessionIDICF
      .
  END.

  RUN setSequence.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

