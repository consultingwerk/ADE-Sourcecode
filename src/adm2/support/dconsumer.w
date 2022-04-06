&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          temp-db          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_JMSOrders                AS HANDLE          NO-UNDO.
DEFINE VARIABLE h_JMStest                  AS HANDLE          NO-UNDO.
DEFINE VARIABLE h_orders                   AS HANDLE          NO-UNDO.

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE destination NO-UNDO LIKE destination.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:  

  Description: from DATA.W - Template For SmartData objects in the ADM

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Modified:     February 24, 1999
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataObject
&Scoped-define DB-AWARE yes

&Scoped-define ADM-SUPPORTED-LINKS Data-Source,Data-Target,Navigation-Target,Update-Target,Commit-Target,Filter-Target


/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF

&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES destination

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  destination durable selector subscription unsubscribeClose
&Scoped-define ENABLED-FIELDS-IN-destination destination durable selector ~
subscription unsubscribeClose 
&Scoped-Define DATA-FIELDS  destination durable selector subscription unsubscribeClose
&Scoped-define DATA-FIELDS-IN-destination destination durable selector ~
subscription unsubscribeClose 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "src/adm2/support/dconsumer.i"
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH destination NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main destination
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main destination


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      destination SCROLLING.
&ANALYZE-RESUME
{&DB-REQUIRED-END}


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataObject
   Allow: Query
   Frames: 0
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE APPSERVER DB-AWARE
   Temp-Tables and Buffers:
      TABLE: destination T "?" NO-UNDO TEMP-DB destination
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
  CREATE WINDOW dTables ASSIGN
         HEIGHT             = 1.62
         WIDTH              = 46.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB dTables 
/* ************************* Included-Libraries *********************** */

{src/adm2/data.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW dTables
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for SmartDataObject Query-Main
     _TblList          = "Temp-Tables.destination"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.destination.destination
"destination" "destination" ? ? "character" ? ? ? ? ? ? yes ? no 30 no
     _FldNameList[2]   > Temp-Tables.destination.durable
"durable" "durable" ? ? "logical" ? ? ? ? ? ? yes ? no 19.6 no
     _FldNameList[3]   > Temp-Tables.destination.selector
"selector" "selector" ? ? "character" ? ? ? ? ? ? yes ? no 25 no
     _FldNameList[4]   > Temp-Tables.destination.subscription
"subscription" "subscription" ? ? "character" ? ? ? ? ? ? yes ? no 20 no
     _FldNameList[5]   > Temp-Tables.destination.unsubscribeClose
"unsubscribeClose" "unsubscribeClose" ? ? "logical" ? ? ? ? ? ? yes ? no 28 no
     _Design-Parent    is WINDOW dTables @ ( 1.14 , 2.6 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK dTables 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDestinations dTables  _DB-REQUIRED
PROCEDURE createDestinations :
/*------------------------------------------------------------------------------
  Purpose:     This procedure create destination temp-table records based on the
               setting of Destinations, Selectors and Subscriptions property
               values
  Parameters:  pcDestinations  AS CHARACTER
               pcSelectors     AS CHARACTER
               pcSubscriptions AS CHARACTER
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcDestinations  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcSelectors     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcSubscriptions AS CHARACTER NO-UNDO.

DEFINE VARIABLE cSub     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iNumDest AS INTEGER   NO-UNDO.

  DO iNumDest = 1 TO NUM-ENTRIES(pcDestinations, CHR(1)):
    CREATE destination.
    ASSIGN
      destination.destination = ENTRY(iNumDest, pcDestinations, CHR(1))
      destination.selector    = ENTRY(iNumDest, pcSelectors, CHR(1)).

    IF pcSubscriptions NE "":U THEN DO:
      cSub = ENTRY(iNumDest, pcSubscriptions, CHR(1)).
      IF cSub NE "":U THEN 
        ASSIGN
          destination.durable = TRUE
          destination.subscription = ENTRY(1, cSub, CHR(2))
          destination.unsubscribeclose = IF ENTRY(2, cSub, CHR(2)) = "yes":U THEN TRUE
                                         ELSE FALSE.
    END.  /* if pcSubscriptions NE "" */
  END.  /* do iNumDest */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI dTables  _DEFAULT-DISABLE
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
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnDestinations dTables  _DB-REQUIRED
PROCEDURE returnDestinations :
/*------------------------------------------------------------------------------
  Purpose:     This procedure returns lists of Destinations, Selectors, and
               Subscriptions Names
  Parameters:  pcDomain        AS CHARACTER
               pcDestinations  AS CHARACTER
               pcSelectors     AS CHARACTER
               pcSubscriptions AS CHARACTER
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcDomain        AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcDestinations  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcSelectors     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcSubscriptions AS CHARACTER NO-UNDO.

DEFINE VARIABLE lFirst AS LOGICAL INIT TRUE NO-UNDO.

  FOR EACH destination:
    ASSIGN 
      pcDestinations = pcDestinations + 
                       (IF lFirst THEN "":U ELSE CHR(1)) +
                       destination.destination
      pcSelectors = pcSelectors + 
                    (IF lFirst THEN "":U ELSE CHR(1)) +
                    destination.selector.
    IF pcDomain = "PubSub":U THEN
      pcSubscriptions = pcSubscriptions +
                        (IF lFirst THEN "":U ELSE CHR(1)) +
                        (IF destination.subscription = "":U THEN "":U 
                         ELSE (destination.subscription + CHR(2) +
                         STRING(destination.unsubscribeclose))).
    lFirst = FALSE.
  END.  /* for each destination */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RowObjectValidate dTables  _DB-REQUIRED
PROCEDURE RowObjectValidate :
/*------------------------------------------------------------------------------
  Purpose:     This validation procedure ensures that a destination name is 
               entered and that subscription name is entered for a durable 
               subscription.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF RowObject.destination = "":U THEN
    RETURN "A destination name must be entered.".
  
  IF RowObject.durable AND RowObject.subscription = "":U THEN
    RETURN "A subscription name must be entered for a durable subscription.".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

