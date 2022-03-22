&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
/* Procedure Description
"ADM dynamic SmartDataObject.

This dynamic object is used as a client proxy for a SmartDataObject."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:  

  Description: DYNDATA.W - Dynamic SmartData object in the ADM

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Modified    : May 16, 2001 Version 9.1C
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.
/* tell smart.i that we can use the default destroyObject */ 
&SCOPED-DEFINE include-destroyobject
/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


  DEFINE VARIABLE gcUpdatable  AS CHARACTER  NO-UNDO.

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

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdatableColumns dTables 
FUNCTION getUpdatableColumns RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRowObjectTable dTables 
FUNCTION setRowObjectTable RETURNS LOGICAL
  ( phHandle AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdatableColumns dTables 
FUNCTION setUpdatableColumns RETURNS LOGICAL
  ( pcUpdatableColumns AS CHAR  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataObject
   Allow: Query
   Frames: 0
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE APPSERVER DB-AWARE
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
         HEIGHT             = 1.57
         WIDTH              = 61.6.
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
     _Options          = "NO-LOCK INDEXED-REPOSITION"
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject dTables 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Dynamic SDO version of initializeObject
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObjectTable      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjUpdTable      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAppServer           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cUpdColumns          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumnsByTable      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTables              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainer           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lIsFetchPending      AS LOGICAL    NO-UNDO.

  {get Containersource hContainer}.
  
  /* We need to get the table and updatablecolumns props here unless
     a data container manages the server request */
    IF NOT VALID-HANDLE(hContainer)
    OR (VALID-HANDLE(hContainer) AND NOT {fn IsFetchPending hContainer}) THEN
    DO:
      {get ASHandle hAppServer}. 
      IF VALID-HANDLE(hAppServer) THEN
      DO:
        cUpdcolumns = DYNAMIC-FUNCTION('getUpdatableColumns':U IN hAppserver).
        cTables     = DYNAMIC-FUNCTION('getTables':U IN hAppserver).
        cColumnsByTable = DYNAMIC-FUNCTION('getDataColumnsByTable':U IN hAppserver).
      END.
      ELSE
        RETURN 'adm-error':U.
      RUN unbindServer IN TARGET-PROCEDURE ('unconditional':U). 
      
      DYNAMIC-FUNCTION('setTables':U IN TARGET-PROCEDURE,
                        cTables).
  
      DYNAMIC-FUNCTION('setUpdatableColumns':U IN TARGET-PROCEDURE,
                       cUpdColumns).
      
      DYNAMIC-FUNCTION('setDataColumnsByTable':U IN TARGET-PROCEDURE,
                       cColumnsByTable).
    END.  
  RUN SUPER.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdatableColumns dTables 
FUNCTION getUpdatableColumns RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return the updatablecolumns 
    Notes: This is set from the server object in initializeServerObject.
           Changing this does not affect which fields really are updatable, it
           only gives an error on the client if the field are updated.
------------------------------------------------------------------------------*/
  RETURN gcUpdatable.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRowObjectTable dTables 
FUNCTION setRowObjectTable RETURNS LOGICAL
  ( phHandle AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: override to set Datacolumns create RowObjUpd dynamically on 
           non-repository client 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOk        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE i          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cColumns   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE     NO-UNDO.

  lOk =  SUPER(phHandle).
  
  IF lOk THEN
  DO:
     DYNAMIC-FUNCTION ('createRowObjUpdTable':U IN TARGET-PROCEDURE).
     {get RowObject hRowObject}.  
     IF VALID-HANDLE(hROwObject) THEN
     DO i = 1 TO hRowObject:NUM-FIELDS - 4: /* don't include the row* fields*/ 
      ASSIGN 
         hField = hRowObject:BUFFER-FIELD(i)
         cColumns = cColumns 
                  + (IF i = 1 THEN '':U ELSE ',':U) 
                  + hField:NAME.
     END.
     {set DataColumns cColumns}.
  END.
  RETURN lOk.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdatableColumns dTables 
FUNCTION setUpdatableColumns RETURNS LOGICAL
  ( pcUpdatableColumns AS CHAR  ) :
/*------------------------------------------------------------------------------
  Purpose: Set updatable columns  
    Notes: Only called by non repository client  
------------------------------------------------------------------------------*/
  
  gcUpdatable = pcUpdatablecolumns.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

