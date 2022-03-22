&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"src/adm2/support/db2b.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------

  File:

  Description: from viewer.w - Template for SmartDataViewer objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE gcDirection AS CHAR     NO-UNDO.
DEFINE VARIABLE glMulti     AS LOGICAL  NO-UNDO.

/* stores and display the values so that uncheck/check does not loose data */
DEFINE VARIABLE gcPublicId AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSystemId AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "adm2/support/db2b.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fFrame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.xmlschema RowObject.destination ~
RowObject.replyreq RowObject.replysel RowObject.dtdPublicId ~
RowObject.dtdSystemId RowObject.name 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS lUseDTD bMulti BrowseSchema BrowseDTD rRect 
&Scoped-Define DISPLAYED-FIELDS RowObject.xmlschema RowObject.destination ~
RowObject.replyreq RowObject.replysel RowObject.dtdPublicId ~
RowObject.dtdSystemId RowObject.name 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD disableButton vTableWin 
FUNCTION disableButton RETURNS LOGICAL
  (plModified AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDirection vTableWin 
FUNCTION getDirection RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initDTD vTableWin 
FUNCTION initDTD RETURNS CHARACTER
  ( plUseDTD AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setButtonLabel vTableWin 
FUNCTION setButtonLabel RETURNS LOGICAL
  ( pcLabel AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataModified vTableWin 
FUNCTION setDataModified RETURNS LOGICAL
  (lModified AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDirection vTableWin 
FUNCTION setDirection RETURNS LOGICAL
  (pcDirection AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHeight vTableWin 
FUNCTION setHeight RETURNS LOGICAL
  ( pdHeight AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNameVisible vTableWin 
FUNCTION setNameVisible RETURNS LOGICAL
  ( plView AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bMulti 
     LABEL "" 
     SIZE 28 BY 1.14.

DEFINE BUTTON BrowseDTD 
     LABEL "Brow&se..." 
     SIZE 16 BY 1.14.

DEFINE BUTTON BrowseSchema 
     LABEL "Browse..." 
     SIZE 16 BY 1.14.

DEFINE RECTANGLE rRect
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 93 BY 10.

DEFINE VARIABLE lUseDTD AS LOGICAL INITIAL no 
     LABEL "Use DTD Reference Instead of XML Schema" 
     VIEW-AS TOGGLE-BOX
     SIZE 48.2 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fFrame
     RowObject.xmlschema AT ROW 1.48 COL 7.6
          VIEW-AS FILL-IN 
          SIZE 50 BY 1
     RowObject.destination AT ROW 2.76 COL 23.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 35 BY 1
     RowObject.replyreq AT ROW 3.95 COL 25.8
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .81
     RowObject.replysel AT ROW 4.91 COL 23.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 67 BY 1
     lUseDTD AT ROW 6.1 COL 25.8
     RowObject.dtdPublicId AT ROW 7.1 COL 23.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 67.2 BY 1
     RowObject.dtdSystemId AT ROW 8.29 COL 23.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 49.2 BY 1
     RowObject.name AT ROW 9.48 COL 23.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     bMulti AT ROW 9.67 COL 64.8
     BrowseSchema AT ROW 1.48 COL 76.8
     BrowseDTD AT ROW 8.29 COL 76.8
     rRect AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "adm2/support/db2b.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {adm2/support/db2b.i}
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
         HEIGHT             = 10
         WIDTH              = 93.
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
/* SETTINGS FOR FRAME fFrame
   NOT-VISIBLE Size-to-Fit L-To-R,COLUMNS                               */
ASSIGN 
       FRAME fFrame:SCROLLABLE       = FALSE
       FRAME fFrame:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX lUseDTD IN FRAME fFrame
   NO-DISPLAY                                                           */
ASSIGN 
       RowObject.name:HIDDEN IN FRAME fFrame           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.xmlschema IN FRAME fFrame
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fFrame
/* Query rebuild information for FRAME fFrame
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME fFrame */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME bMulti
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bMulti vTableWin
ON CHOOSE OF bMulti IN FRAME fFrame
DO:
  DEFINE VARIABLE hSource AS HANDLE NO-UNDO. 
  DEFINE VARIABLE iPage   AS INT    NO-UNDO.

  hSource = DYNAMIC-FUNCTION('getContainerSource':U).
  iPage   = DYNAMIC-FUNCTION('getCurrentPage':U IN hsource).  
  
  RUN selectPage IN hsource (IF iPage = 2 THEN 3 ELSE 2).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BrowseDTD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrowseDTD vTableWin
ON CHOOSE OF BrowseDTD IN FRAME fFrame /* Browse... */
DO:
  DEFINE VARIABLE cFilterFile AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFilterName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRelName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSchema     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTitle      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lUpdate     AS LOGICAL   NO-UNDO.

  IF gcdirection = "Producer":U THEN 
    ASSIGN cFilterName = "Document Type Definition (*.dtd)":U 
           cFilterFile = "*.dtd":U
           cTitle = "Choose Producer DTD File":U.
    
    SYSTEM-DIALOG GET-FILE cSchema
    FILTERS cFilterName cFilterFile,
            "All Files (*.*)":U "*.*":U
    MUST-EXIST
    TITLE cTitle
    UPDATE lUpdate.
  
  IF lUpdate THEN DO:
    RUN adecomm/_relfile.p 
      (INPUT cSchema,
       INPUT NO,
       INPUT "":U,
       OUTPUT cRelName).

    ASSIGN RowObject.dtdSystemId:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cRelName.

    APPLY "VALUE-CHANGED":U TO RowObject.xmlschema.
  END.  /* if lUpdate */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BrowseSchema
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrowseSchema vTableWin
ON CHOOSE OF BrowseSchema IN FRAME fFrame /* Browse... */
DO:
  DEFINE VARIABLE cFilterFile AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFilterName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRelName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSchema     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTitle      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lUpdate     AS LOGICAL   NO-UNDO.

  IF gcdirection = "Producer":U THEN 
    ASSIGN cFilterName = "Producer Mapping File (*.xmp)":U 
           cFilterFile = "*.xmp":U
           cTitle = "Choose Producer XML Mapping File":U.
  ELSE ASSIGN cFilterName = "Consumer Mapping File (*.xmc)":U
              cFilterFile = "*.xmc":U
              cTitle = "Choose Consumer XML Mapping File":U.

  SYSTEM-DIALOG GET-FILE cSchema
    FILTERS cFilterName cFilterFile,
            "All Files (*.*)":U "*.*":U
    MUST-EXIST
    TITLE cTitle
    UPDATE lUpdate.
  
  IF lUpdate THEN DO:
    RUN adecomm/_relfile.p 
      (INPUT cSchema,
       INPUT NO,
       INPUT "":U,
       OUTPUT cRelName).

    ASSIGN RowObject.xmlschema:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cRelName.
    APPLY "VALUE-CHANGED":U TO RowObject.xmlschema.
  END.  /* if lUpdate */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lUseDTD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lUseDTD vTableWin
ON VALUE-CHANGED OF lUseDTD IN FRAME fFrame /* Use DTD Reference Instead of XML Schema */
DO:
  ASSIGN lUseDTD.
  initDTD(lUseDTD).
  DYNAMIC-FUNCTION('setDataModified':U,TRUE). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.xmlschema
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.xmlschema vTableWin
ON VALUE-CHANGED OF RowObject.xmlschema IN FRAME fFrame /* XML Mapping File */
DO:
  DEFINE VARIABLE cBasename AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPrefix   AS CHARACTER NO-UNDO.

  RUN adecomm/_osprefx.p
    (INPUT RowObject.xmlschema:SCREEN-VALUE,
     OUTPUT cPrefix,
     OUTPUT cBasename).

  ASSIGN RowObject.NAME:SCREEN-VALUE = ENTRY(1, cBaseName, ".":U).

  {set DataModified YES}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecord vTableWin 
PROCEDURE deleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override to set button sensitive if only one record left 
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  RUN SUPER.
  disableButton(NO).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFields vTableWin 
PROCEDURE disableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcFieldType AS CHARACTER NO-UNDO.
  
  lUseDTD:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcFieldType).

  /* Code placed here will execute AFTER standard behavior.    */

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
  HIDE FRAME fFrame.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields vTableWin 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.

  RUN SUPER( INPUT pcColValues).
  initDTD(RowObject.dtdSystemID:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields vTableWin 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  lUseDTD:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

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
  DEFINE VARIABLE lConsumer AS LOG NO-UNDO.
  
  lConsumer   = getDirection() = "Consumer":U.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      RowObject.Destination:HIDDEN = lConsumer 
      RowObject.Replyreq:HIDDEN = lConsumer  
      RowObject.Replysel:HIDDEN = lConsumer
      lUseDTD:HIDDEN  = lConsumer  
      RowObject.DTDPublicID:HIDDEN = lConsumer
      RowObject.DTDSystemID:HIDDEN = lConsumer
      BrowseDTD:HIDDEN = lConsumer
     /* If this is a Consumer, just adjust the rectangle to fit the only 
        visible field xmlschema. */ 
      rRect:HEIGHT = (IF lConsumer 
                      THEN RowObject.xmlschema:ROW + 
                           RowObject.xmlschema:HEIGHT +
                           0.34 - rRect:ROW
                      ELSE rRect:HEIGHT)
      bMulti:HIDDEN = lConsumer NO-ERROR.
  END.
  RUN SUPER.
  IF NOT lConsumer THEN 
    disableButton(NO).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord vTableWin 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose: Implicit Delete if OK on page 1 or 2 and every field is blank     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:  
    IF NOT glMulti  /* all blank + replyreq = 'no' then delete */           
    AND (RowObject.XMLSchema:SCREEN-VALUE
        /*  + RowObject.DTD:SCREEN-VALUE */
         + RowObject.Destination:SCREEN-VALUE 
         + RowObject.ReplySel:SCREEN-VALUE 
         + RowObject.dtdPublicId:SCREEN-VALUE 
         + RowObject.dtdSystemId:SCREEN-VALUE = '':U)
     AND lUseDTD:CHECKED = NO
     AND RowObject.ReplyReq:CHECKED = NO THEN
    DO:
      RUN deleteRecord.
      
      DYNAMIC-FUNCTION('setDataModified':U,FALSE).  
    END.
    ELSE DO:      
      IF lUseDTD:CHECKED THEN
      DO:
        IF  RowObject.dtdSystemId:SCREEN-VALUE = '':U  
        AND RowObject.dtdPublicId:SCREEN-VALUE = '':U THEN
        DO:
          MESSAGE 'Specify DTD information or uncheck the ~'Use DTD Reference~' option.' 
                     VIEW-AS ALERT-BOX INFORMATION.  
          APPLY 'entry':U TO lUseDTD.
          RETURN 'adm-error':U.
        END.

        IF RowObject.dtdSystemId:SCREEN-VALUE = '':U THEN
        DO:
          MESSAGE 'System Id is mandatory for DTD' 
                   VIEW-AS ALERT-BOX INFORMATION.  
          APPLY 'entry':U TO RowObject.dtdSystemId.
          RETURN 'adm-error':U.
        END.
      END.
      

      RUN SUPER.

    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION disableButton vTableWin 
FUNCTION disableButton RETURNS LOGICAL
  (plModified AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Turn off switch button when editing or multiple records   
Parameter: plModifed - TRUE the record is being modifed - always disable. 
                     - FALSE not modifying - enable if one or none records.  
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.
   DEFINE VARIABLE cQueryPos   AS CHARACTER  NO-UNDO.
   IF NOT plModified THEN
   DO:
     hDataSource = DYNAMIC-FUNCTION('getDataSource':U).

     IF VALID-HANDLE(hDataSource) THEN
       ASSIGN
         cQueryPos  = DYNAMIC-FUNCTION('getQueryPosition':U IN hDataSource)
         plModified = NOT CAN-DO('OnlyRecord,NoRecordAvailable',cQueryPos).
   END.

   bMulti:SENSITIVE IN FRAME {&FRAME-NAME} = NOT plModified.
   RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDirection vTableWin 
FUNCTION getDirection RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN gcDirection.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initDTD vTableWin 
FUNCTION initDTD RETURNS CHARACTER
  ( plUseDTD AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  disable/enable DTD fields
    Notes:  Called from displayField and value changed of plUseDTD
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hdl AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      lUseDTD:CHECKED = plUseDTD
      BrowseDTD:SENSITIVE = plUseDTD
      RowObject.dtdPublicId:READ-ONLY = NOT plUseDTD
      RowObject.dtdSystemId:READ-ONLY = NOT plUseDTD
      RowObject.dtdPublicId:TAB-STOP  = plUseDTD
      RowObject.dtdSystemId:TAB-STOP  = plUseDTD.
    IF plUseDTD THEN
    DO:
      /* This is only set if unchecked previously (see below) */ 
      IF gcPublicID <> '':U THEN
        RowObject.dtdPublicId:SCREEN-VALUE = gcPublicID.
      /* This is only set if unchecked previously (see below) */ 
      IF gcSystemID <> '':U THEN
        RowObject.dtdSystemId:SCREEN-VALUE = gcSystemID.

      RowObject.dtdSystemId:MOVE-BEFORE(RowObject.name:HANDLE) .
      RowObject.dtdPublicId:MOVE-BEFORE(RowObject.dtdSystemId:HANDLE). 
    END.
    ELSE
    DO:
      ASSIGN
        gcPublicID = RowObject.dtdPublicId:SCREEN-VALUE 
        gcSystemID = RowObject.dtdSystemId:SCREEN-VALUE
        RowObject.dtdPublicId:SCREEN-VALUE = '':U
        RowObject.dtdSystemId:SCREEN-VALUE = '':U.
    END.
  END.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setButtonLabel vTableWin 
FUNCTION setButtonLabel RETURNS LOGICAL
  ( pcLabel AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  bMulti:LABEL IN FRAME {&FRAME-NAME} = pcLabel.
  RETURN TRUE.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataModified vTableWin 
FUNCTION setDataModified RETURNS LOGICAL
  (lModified AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       We are not prepared to deal with changes between multiple/single 
               during changes. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cPos        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNew        AS CHARACTER  NO-UNDO.

  IF lModified THEN
  DO:
    cNew        = DYNAMIC-FUNCTION('getNewRecord':U).
      
    /* Mark the mandatory blank fields as modified for new record */       
    DO WITH FRAME {&FRAME-NAME}:
      IF cNew <> "NO":U THEN
        ASSIGN
          RowObject.XmlSchema:MODIFIED = TRUE 
          RowObject.Destination:MODIFIED = RowObject.Destination:HIDDEN = FALSE. 
      RowObject.Name:MODIFIED = RowObject.Name:HIDDEN = FALSE.
    END.
  END.

  IF gcDirection = 'Producer':U THEN
  DO:    
    hDataSource = DYNAMIC-FUNCTION('getDataSource':U).    
    
    IF VALID-HANDLE(hDataSource) THEN
    DO:      
      cPos = DYNAMIC-FUNCTION('getQueryPosition':U IN hDataSource).
      /* Cannot swith page when more than one record or change pending */     
      bMulti:SENSITIVE IN FRAME {&FRAME-NAME} = 
        NOT lModified  AND CAN-DO('OnlyRecord,NoRecordAvailable',CPos).

    END. /* dataSource */
  END. /* producer */
  
  RETURN SUPER( INPUT lModified ).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDirection vTableWin 
FUNCTION setDirection RETURNS LOGICAL
  (pcDirection AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Set the direction and change the interface accordingly.   
    Notes:  
------------------------------------------------------------------------------*/
  gcDirection = pcDirection.
 
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHeight vTableWin 
FUNCTION setHeight RETURNS LOGICAL
  ( pdHeight AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dOldHeight AS DEC NO-UNDO.
  
  ASSIGN 
    FRAME {&FRAME-NAME}:HEIGHT = pdHeight
    rRect:HEIGHT = pdHeight - rRect:ROW.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNameVisible vTableWin 
FUNCTION setNameVisible RETURNS LOGICAL
  ( plView AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RowObject.Name:HIDDEN IN FRAME {&FRAME-NAME} = NOT plView.
  
  RETURN TRUE.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

