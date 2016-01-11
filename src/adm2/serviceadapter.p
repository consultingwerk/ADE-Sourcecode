&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/
/* Copyright (c) 2005 by Progress Software Corporation      */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : adm2/serviceadapter.p
    Purpose     : Data request service adapter interface
    Notes       : This is a template stub procedure to show the required
                  APIs for the service adapater.  Logic must be implemented
                  in these APIs to interact with an OERA service interface
                  implementation.    
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getObjectType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectType Procedure 
FUNCTION getObjectType RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-retrieveData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveData Procedure 
PROCEDURE retrieveData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
         pcStartPosition
               Specifies the record where the data retrieval should start. 
               Used when a new batch of data is requested and applies to the 
               top table of the request.  
         pcEndPosition
               Specifies the record where the data retrieval should end. 
               Used when a new batch of data is requested and applies to the 
               top table of the request. 
         plFillBatch
               Set to yes if a full batch should be retrieved in cases where 
               the specified Start or End parameter would not fill the batch.  
               In the case where both Start and End are specified the filling 
               of the batch need to be done with records after the specified
               End. 
               (Start and End are only specified in the same request when data 
                before the specified Start already are on the client)   
        
               
  Notes: This is an API stub that has the required parameters needed by the
         ADM2 to interact with an OERA service interface implementation.
------------------------------------------------------------------------------*/
/* Business Entity reference */
DEFINE INPUT         PARAMETER pcEntity     AS CHARACTER     NO-UNDO EXTENT.

/* Data table request info */
DEFINE INPUT         PARAMETER pcTables        AS CHARACTER  NO-UNDO EXTENT.
DEFINE INPUT         PARAMETER pcQueries       AS CHARACTER  NO-UNDO EXTENT.
DEFINE INPUT         PARAMETER pcJoins         AS CHARACTER  NO-UNDO EXTENT.
DEFINE INPUT         PARAMETER pcPositions     AS CHARACTER  NO-UNDO EXTENT.

/* blank or semi-colon separated means multi table open (ALL top-only) 
   Single entry means batch request next,prev, where <query>, last */
DEFINE INPUT         PARAMETER pcRequest       AS CHARACTER  NO-UNDO EXTENT.

DEFINE INPUT         PARAMETER pcBatchContext  AS CHARACTER  NO-UNDO.
DEFINE INPUT         PARAMETER plAppend        AS LOGICAL    NO-UNDO.

DEFINE INPUT-OUTPUT  PARAMETER pcNumRecords    AS CHARACTER  NO-UNDO EXTENT.
/* data ref */
DEFINE INPUT-OUTPUT  PARAMETER phHandles       AS HANDLE     NO-UNDO EXTENT. 
DEFINE INPUT-OUTPUT  PARAMETER pcContext       AS CHARACTER  NO-UNDO EXTENT.

DEFINE OUTPUT        PARAMETER pcPrevContext   AS CHARACTER  NO-UNDO EXTENT.
DEFINE OUTPUT        PARAMETER pcNextContext   AS CHARACTER  NO-UNDO EXTENT.

RUN adecomm/_dimextent.p(EXTENT(pcEntity),OUTPUT pcPrevContext).
RUN adecomm/_dimextent.p(EXTENT(pcEntity),OUTPUT pcNextContext).

MESSAGE
  'The Service Adapter received a request for Business Entity "':U +
   pcEntity[1] + 
   '". In order to make this work you must add implementation logic for several APIs to adm2/serviceadapter.p.' +
   '  Refer to the template adm2/serviceadapter.p procedure shipped with the product and to ' + 
   'the documentation on ADM2 integration with OERA compliant business logic.'
    VIEW-AS ALERT-BOX WARNING BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE submitData Procedure 
PROCEDURE submitData :
/*------------------------------------------------------------------------------
  Purpose:     Interface for submit of changes
  Parameters:  <none>
  Notes:       This is an API stub that has the required parameters needed by the
               ADM2 to interact with an OERA service interface implementation.
------------------------------------------------------------------------------*/
  /* Business Entity reference */
  DEFINE INPUT         PARAMETER pcEntity     AS CHARACTER  NO-UNDO EXTENT.
  DEFINE INPUT-OUTPUT  PARAMETER phHandles    AS HANDLE     NO-UNDO EXTENT.
  DEFINE INPUT-OUTPUT  PARAMETER pcContext    AS CHARACTER  NO-UNDO EXTENT.

  MESSAGE
    'The Service Adapter received a request for Business Entity "':U +
     pcEntity[1] + 
     '". In order to make this work you must add implementation logic for several APIs to adm2/serviceadapter.p.' +
     '  Refer to the template adm2/serviceadapter.p procedure shipped with the product and to ' + 
     'the documentation on ADM2 integration with OERA compliant business logic.'
      VIEW-AS ALERT-BOX WARNING BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getObjectType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectType Procedure 
FUNCTION getObjectType RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:   
    Notes:  
------------------------------------------------------------------------------*/
  RETURN "Service". 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

