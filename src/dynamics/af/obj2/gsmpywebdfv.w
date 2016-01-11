&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sObject _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" sObject _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gsmpyjmdfv.w

  Description:  WebService Connection Parameter SDF

  Purpose:      Accepts the connection parameters to a WEbService Binding

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000027   UserRef:    
                Date:   04/20/2004  Author:     Sunil Belgaonkar

  Update Notes: Created from Template rysttdatfv.w

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

&scop object-name       gsmpywebdfv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataField yes

{af/sup2/afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataField
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiWSDL fiWSDLUserId fiWSDLPassword raOption ~
fiService fiServiceNamespace fiPort fiSOAPEndpointUserId ~
fiSOAPEndpointPassword fiTargetNamespace fiMaxConnections fiPf EdEditor 
&Scoped-Define DISPLAYED-OBJECTS fiWSDL fiWSDLUserId fiWSDLPassword ~
raOption fiService fiServiceNamespace fiPort fiBinding fiBindingNamespace ~
fiSOAPEndPoint fiSOAPEndpointUserId fiSOAPEndpointPassword ~
fiTargetNamespace fiMaxConnections fiPf EdEditor 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataValue sObject 
FUNCTION getDataValue RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataValue sObject 
FUNCTION setDataValue RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE EdEditor AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 118.4 BY 6.38 NO-UNDO.

DEFINE VARIABLE fiBinding AS CHARACTER FORMAT "X(256)":U 
     LABEL "Binding name (-Binding)" 
     VIEW-AS FILL-IN 
     SIZE 73.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiBindingNamespace AS CHARACTER FORMAT "X(256)":U 
     LABEL "Binding namespace (-BindingNamespace)" 
     VIEW-AS FILL-IN 
     SIZE 73.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiMaxConnections AS CHARACTER FORMAT "X(256)":U 
     LABEL "Maximum connections (-maxConnections)" 
     VIEW-AS FILL-IN 
     SIZE 19.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiPf AS CHARACTER FORMAT "X(256)":U 
     LABEL "Parameter filename (-pf)" 
     VIEW-AS FILL-IN 
     SIZE 73.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiPort AS CHARACTER FORMAT "X(256)":U 
     LABEL "Port name (-Port)" 
     VIEW-AS FILL-IN 
     SIZE 73.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiService AS CHARACTER FORMAT "X(256)":U 
     LABEL "Service name (-Service)" 
     VIEW-AS FILL-IN 
     SIZE 73.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiServiceNamespace AS CHARACTER FORMAT "X(256)":U 
     LABEL "Service namespace (-ServiceNamespace)" 
     VIEW-AS FILL-IN 
     SIZE 73.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiSOAPEndPoint AS CHARACTER FORMAT "X(256)":U 
     LABEL "URL endpoint (-SOAPEndPoint)" 
     VIEW-AS FILL-IN 
     SIZE 73.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiSOAPEndpointPassword AS CHARACTER FORMAT "X(256)":U 
     LABEL "SOAPEndpoint Password (-SOAPEndpointPassword)" 
     VIEW-AS FILL-IN 
     SIZE 73.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiSOAPEndpointUserId AS CHARACTER FORMAT "X(256)":U 
     LABEL "SOAPEndPoint User ID (-SOAPEndpointUserId)" 
     VIEW-AS FILL-IN 
     SIZE 73.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiTargetNamespace AS CHARACTER FORMAT "X(256)":U 
     LABEL "Target namespace (-TargetNamespace)" 
     VIEW-AS FILL-IN 
     SIZE 73.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiWSDL AS CHARACTER FORMAT "X(256)":U 
     LABEL "WSDL document (-WSDL)" 
     VIEW-AS FILL-IN 
     SIZE 73.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiWSDLPassword AS CHARACTER FORMAT "X(256)":U 
     LABEL "WSDL Password (-WSDLPassword)" 
     VIEW-AS FILL-IN 
     SIZE 73.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiWSDLUserId AS CHARACTER FORMAT "X(256)":U 
     LABEL "WSDL User ID (-WSDLUserId)" 
     VIEW-AS FILL-IN 
     SIZE 73.6 BY 1 NO-UNDO.

DEFINE VARIABLE raOption AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Service and Port", "S",
"Binding and SOAP endpoint", "B"
     SIZE 66 BY .76 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiWSDL AT ROW 1.1 COL 50.4 COLON-ALIGNED
     fiWSDLUserId AT ROW 2.14 COL 50.4 COLON-ALIGNED
     fiWSDLPassword AT ROW 3.14 COL 50.4 COLON-ALIGNED
     raOption AT ROW 4.29 COL 46.6 NO-LABEL
     fiService AT ROW 5.19 COL 50.4 COLON-ALIGNED
     fiServiceNamespace AT ROW 6.19 COL 11.4
     fiPort AT ROW 7.19 COL 35.4
     fiBinding AT ROW 8.38 COL 50.4 COLON-ALIGNED
     fiBindingNamespace AT ROW 9.38 COL 11.8
     fiSOAPEndPoint AT ROW 10.38 COL 21.2
     fiSOAPEndpointUserId AT ROW 11.62 COL 50.4 COLON-ALIGNED
     fiSOAPEndpointPassword AT ROW 12.62 COL 50.4 COLON-ALIGNED
     fiTargetNamespace AT ROW 13.62 COL 13.4
     fiMaxConnections AT ROW 14.67 COL 12.2
     fiPf AT ROW 15.71 COL 29
     EdEditor AT ROW 16.86 COL 12 NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataField
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
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
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 22.67
         WIDTH              = 134.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/field.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

ASSIGN 
       EdEditor:RETURN-INSERTED IN FRAME frMain  = TRUE
       EdEditor:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN fiBinding IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiBindingNamespace IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fiMaxConnections IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiPf IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiPort IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiServiceNamespace IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiSOAPEndPoint IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fiTargetNamespace IN FRAME frMain
   ALIGN-L                                                              */
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

&Scoped-define SELF-NAME fiWSDL
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiWSDL sObject
ON VALUE-CHANGED OF fiWSDL IN FRAME frMain /* WSDL document (-WSDL) */
,fiBinding, fiBindingNamespace, fiMaxConnections, fiPf, fiPort, fiService, fiServiceNamespace, fiSOAPEndPoint, fiSOAPEndpointPassword, fiSOAPEndpointUserId, fiTargetNamespace, fiWSDL, fiWSDLPassword, fiWSDLUserId
DO:
  {set DataModified TRUE}.
    /* createString is run to create the connection string and display it in the 
     editor */
  RUN createString.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raOption
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raOption sObject
ON VALUE-CHANGED OF raOption IN FRAME frMain
DO:
  {set DataModified TRUE}.

  /* radioChanged is run to enable/disable fields appropriately based on 
     the option chosen */
  RUN radioChanged (SELF:SCREEN-VALUE).
  RUN createString.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createString sObject 
PROCEDURE createString :
/*------------------------------------------------------------------------------
  Purpose:     This procedure creates the connection string and displays it in 
               the read-only editor
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cString AS CHARACTER    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
     EdEditor:SCREEN-VALUE = 
       (IF fiWSDL:SCREEN-VALUE > "":U THEN "-WSDL ":U + fiWSDL:SCREEN-VALUE ELSE "":U) +
       (IF fiWSDLUserId:SCREEN-VALUE > "":U THEN " -WSDLUserId ":U + fiWSDLUserId:SCREEN-VALUE ELSE "":U) +
       (IF fiWSDLPassword:SCREEN-VALUE > "":U THEN " -WSDLPassword ":U + fiWSDLPassword:SCREEN-VALUE ELSE "":U) +
       (IF fiService:SCREEN-VALUE > "":U THEN " -Service ":U + fiService:SCREEN-VALUE ELSE "":U) +
       (IF fiServiceNamespace:SCREEN-VALUE > "":U THEN " -ServiceNamespace ":U + fiServiceNamespace:SCREEN-VALUE ELSE "":U) +
       (IF fiPort:SCREEN-VALUE > "":U THEN " -Port ":U + fiPort:SCREEN-VALUE ELSE "":U) +
       (IF fiBinding:SCREEN-VALUE > "":U THEN " -Binding ":U + fiBinding:SCREEN-VALUE ELSE "":U) +
       (IF fiBindingNamespace:SCREEN-VALUE > "":U THEN " -BindingNamespace ":U + fiBindingNamespace:SCREEN-VALUE ELSE "":U) +
       (IF fiSOAPEndPoint:SCREEN-VALUE > "":U THEN " - SOAPEndpoint ":U + fiSOAPEndPoint:SCREEN-VALUE ELSE "":U) +
       (IF fiSOAPEndPointUserId:SCREEN-VALUE > "":U THEN " - SOAPEndpointUserId ":U + fiSOAPEndPointUserId:SCREEN-VALUE ELSE "":U) +
       (IF fiSOAPEndPointPassword:SCREEN-VALUE > "":U THEN " - SOAPEndpointPassword ":U + fiSOAPEndPointPassword:SCREEN-VALUE ELSE "":U) +
       (IF fiTargetNamespace:SCREEN-VALUE > "":U THEN " -TargetNamespace ":U + fiTargetNamespace:SCREEN-VALUE ELSE "":U) +
       (IF fiMaxConnections:SCREEN-VALUE > "":U THEN " -maxConnections ":U + fiMaxConnections:SCREEN-VALUE ELSE "":U) +
       (IF fiPf:SCREEN-VALUE > "":U THEN " -pf ":U + fiPf:SCREEN-VALUE ELSE "":U).
  END.  /* do with frame */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableField sObject 
PROCEDURE disableField :
/*------------------------------------------------------------------------------
  Purpose:   Disable the field   
  Parameters:  <none>
  Notes:    SmartDataField:disableFields will call this for all Objects of type
            PROCEDURE that it encounters in the EnableFields Property.  
            The developer must add logic to disable the actual SmartField.    
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiBinding:SENSITIVE = FALSE
           fiBindingNamespace:SENSITIVE = FALSE
           fiMaxConnections:SENSITIVE = FALSE
           fiPf:SENSITIVE = FALSE
           fiPort:SENSITIVE = FALSE
           fiService:SENSITIVE = FALSE
           fiServiceNamespace:SENSITIVE = FALSE
           fiSOAPEndPoint:SENSITIVE = FALSE
           fiSOAPEndpointPassword:SENSITIVE = FALSE
           fiSOAPEndpointUserId:SENSITIVE = FALSE
           fiTargetNamespace:SENSITIVE = FALSE
           fiWSDL:SENSITIVE = FALSE
           fiWSDLPassword:SENSITIVE = FALSE
           fiWSDLUserId:SENSITIVE = FALSE
           raOption:SENSITIVE = FALSE.
  END.
  {set FieldEnabled FALSE}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableField sObject 
PROCEDURE enableField :
/*------------------------------------------------------------------------------
  Purpose:   Enable the field   
  Parameters:  <none>
  Notes:    SmartDataField:enableFields will call this for all Objects of type
            PROCEDURE that it encounters in the EnableFields Property.  
            The developer must add logic to enable the SmartField.    
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
    RUN radioChanged(raOption:SCREEN-VALUE).
  END.
  {set FieldEnabled TRUE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableObject sObject 
PROCEDURE enableObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  RUN SUPER.

  /* radioChanged is run to enabled/disable fields appropriately */
  RUN radioChanged (INPUT raOption:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainerSource    AS HANDLE       NO-UNDO.

  hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U).
  /* subscribe to validateField in the viewer */
  SUBSCRIBE TO 'validateField':U IN hContainerSource.

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE parseValue sObject 
PROCEDURE parseValue :
/*------------------------------------------------------------------------------
  Purpose:     This procedure parses the connection string to display the 
               connection data in appropriate fields.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcValue AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cList       AS CHARACTER  INIT '-WSDL,-WSDLUserId,-WSDLPassword,-Service,-ServiceNamespace,-Port,-Binding,-BindingNamespace,-SOAPEndPoint,-SOAPEndPointUserId,-SOAPEndPointPassword,-TargetNamespace,-maxConnections,-pf'  NO-UNDO.
  DEFINE VARIABLE cString     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iPosition   AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iNext       AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iNum        AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iSpace      AS INTEGER      NO-UNDO.

  ASSIGN pcValue = ' ':U + pcValue.

  DO WITH FRAME {&FRAME-NAME}:
    DO iNum = 1 TO NUM-ENTRIES(cList):
      iPosition = INDEX(pcValue, ENTRY(iNum, cList)).
      IF iPosition > 0 THEN
      DO:
        ASSIGN
          iSpace  = INDEX(pcValue, ' ':U, iPosition + 1)
          iNext   = INDEX(pcValue, ' -':U, iPosition + 1)
          iNext   = (IF iNext = 0 THEN -1 ELSE iNext - 1 - iSpace)
          cString = SUBSTRING(pcValue, iSpace + 1, iNext).
          
        CASE ENTRY(iNum, cList):
          WHEN '-WSDL':U THEN fiWSDL:SCREEN-VALUE = cString.
          WHEN '-WSDLUserId':U THEN fiWSDLUserId:SCREEN-VALUE = cString.
          WHEN '-WSDLPassword':U THEN fiWSDLPassword:SCREEN-VALUE = cString.
          WHEN '-Service':U THEN fiService:SCREEN-VALUE = cString.
          WHEN '-ServiceNamespace':U THEN fiServiceNamespace:SCREEN-VALUE = cString.
          WHEN '-Port':U THEN fiPort:SCREEN-VALUE = cString.
          WHEN '-Binding':U THEN fiBinding:SCREEN-VALUE = cString.
          WHEN '-BindingNamespace':U THEN fiBindingNamespace:SCREEN-VALUE = cString.
          WHEN '-SOAPEndPoint':U THEN fiSOAPEndPoint:SCREEN-VALUE = cString.
          WHEN '-SOAPEndPointUserId':U THEN fiSOAPEndPointUserId:SCREEN-VALUE = cString.
          WHEN '-SOAPEndPointPassword':U THEN fiSOAPEndPointPassword:SCREEN-VALUE = cString.
          WHEN '-TargetNamespace':U THEN fiTargetNamespace:SCREEN-VALUE = cString.
          WHEN '-maxConnections':U THEN fiMaxConnections:SCREEN-VALUE = cString.
          WHEN '-pf':U THEN fiPf:SCREEN-VALUE = cString.
        END CASE.
      END.  /* option found */
    END.  /* do while */
  END.  /* do with frame */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE radioChanged sObject 
PROCEDURE radioChanged :
/*------------------------------------------------------------------------------
  Purpose:     This procedure enables/disables field appropriately based on the
               option chosen.  It also sets the screen-value to blank as
               appropriate.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER cValue AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lService    AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE lBinding    AS LOGICAL      NO-UNDO.

  CASE cValue:
    WHEN 'S':U THEN
      ASSIGN
        lService = TRUE
        lBinding = FALSE.
    WHEN 'B':U THEN
      ASSIGN
        lService = FALSE
        lBinding = TRUE.
  END CASE.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiWSDL:SENSITIVE = TRUE
           fiWSDLUserId:SENSITIVE = TRUE
           fiWSDLPassword:SENSITIVE = TRUE
           fiTargetNamespace:SENSITIVE = TRUE
           fiMaxConnections:SENSITIVE = TRUE
           fiPf:SENSITIVE = TRUE.

    ASSIGN
      fiBinding:SENSITIVE = lBinding
      fiBindingNamespace:SENSITIVE = lBinding
      fiSOAPEndPoint:SENSITIVE = lBinding
      fiSOAPEndpointPassword:SENSITIVE = lBinding
      fiSOAPEndpointUserId:SENSITIVE = lBinding
      fiPort:SENSITIVE = lService
      fiService:SENSITIVE = lService
      fiServiceNamespace:SENSITIVE = lService.

    IF (lService) THEN
      ASSIGN 
        fiBinding:SCREEN-VALUE = "":U
        fiBindingNamespace:SCREEN-VALUE = "":U
        fiSOAPEndPoint:SCREEN-VALUE = "":U
        fiSOAPEndpointPassword:SCREEN-VALUE = "":U
        fiSOAPEndpointUserId:SCREEN-VALUE = "":U.
  
    IF (lBinding) THEN
      ASSIGN 
        fiPort:SCREEN-VALUE = "":U
        fiService:SCREEN-VALUE = "":U
        fiServiceNamespace:SCREEN-VALUE = "":U.

    /*
    ASSIGN
     fiMaxConnections:SCREEN-VALUE = "%maxConnections"
     fiWSDLUserId:SCREEN-VALUE = "%WSDLUserId"
     fiWSDLPassword:SCREEN-VALUE = "%WSDLPassword"
     fiSOAPEndpointUserId:SCREEN-VALUE = "%DynUserId"
     fiSOAPEndpointPassword:SCREEN-VALUE = "%SOAPEndpointPassword"
    */
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateField sObject 
PROCEDURE validateField :
/*------------------------------------------------------------------------------
  Purpose:     Checks whether data has been entered for certain fields based on 
               the chosen option and returns the appropriate list of error numbers.
  Parameters:  OUTPUT pcError AS CHARACTER
  Notes:       validateField is published from updateRecord of the Physical
               Service SmartDataViewer (gsmpyviewv.w).
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcError AS CHARACTER NO-UNDO.
  /* Only WSDL document is mandatory field */
  DO WITH FRAME {&FRAME-NAME}:
    IF fiWSDL:SCREEN-VALUE = "":U THEN
      pcError = '148':U.
  END.  /* do with frame */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataValue sObject 
FUNCTION getDataValue RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current value of the SmartDataField object.
   Params:  none
    Notes:  This function must be defined by the developer of the object
            to return its value.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cConnectString  AS CHARACTER    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN cConnectString = raOption:SCREEN-VALUE + CHR(3) + edEditor:SCREEN-VALUE.
  END.  /* do with frame */                                            
  RETURN cConnectString.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataValue sObject 
FUNCTION setDataValue RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function receives the value for the SmartDataField and assigns it.
   Params:  The parameter and its datatype must be defined by the developer.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cConnectString  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cOption         AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hSource         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNew            AS CHARACTER  NO-UNDO.

  IF pcValue = '':U OR NUM-ENTRIES(pcValue, CHR(3)) = 0 THEN
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN raOption:SCREEN-VALUE  = "S":U.
  END.
  ELSE 
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN cOption = ENTRY(1, pcValue, CHR(3))
       raOption:SCREEN-VALUE = cOption.
    
    RUN radioChanged (INPUT cOption).

    ASSIGN cConnectString = ENTRY(2, pcValue, CHR(3)).
    RUN parseValue (INPUT cConnectString).
    RUN createString.
  END.  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

