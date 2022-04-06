&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Include _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afxmlcfgtt.i

  Description:  XML Configuration File temp-tables

  Purpose:      This include file contains the definitions of the temp-tables used to parse the
                XML configuration file.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000027   UserRef:    
                Date:   12/05/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template ryteminclu.i

  (v:010001)    Task:           0   UserRef:    
                Date:   08/22/2001  Author:     

  Update Notes: Added order field to ttManager to take care of starting services in the right order.

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Astra 2 object identifying preprocessor */
&glob   AstraInclude    yes

/* The following tables are all populated during the parsing of the 
   icfconfig.xml file. This data is transitory. IOW, it is not valid for any
   length of time. There are several different scenarios when data will
   be found in these tables:
   1) At Session Startup while the icfconfig file is being parsed.
   2) When the entire icfconfig file is read in for all session types.
   3) When data is put into the temp-tables to be written to the icfconfig file.

   All procedures that manipulate these tables should ensure that they are emptied
   when the atomic functions that they perform are complete. Note that the 
   handles to these buffers may be passed around to other procedures.
   */

&IF DEFINED(defineTTParam) &THEN
/* This table contains the session's parameters. All values are get and
   set using the getValue and setValue functions. */
DEFINE TEMP-TABLE ttParam NO-UNDO RCODE-INFORMATION
  FIELD cOption    AS CHARACTER FORMAT "X(25)" LABEL "Parameter"
  FIELD cValue     AS CHARACTER
  FIELD cDispValue AS CHARACTER FORMAT "X(128)" LABEL "Value"
  INDEX pudx IS UNIQUE PRIMARY
    cOption
  .
&ENDIF

/* ttProperty are read from the "attributes" section of the icfconfig.xml
   file. */
DEFINE TEMP-TABLE ttProperty{&ttPropertyExt} NO-UNDO
  FIELD cSessionType     AS CHARACTER
  FIELD cProperty        AS CHARACTER FORMAT "X(25)"
  FIELD cValue           AS CHARACTER FORMAT "X(50)"
  FIELD lUpdated         AS LOGICAL
  FIELD lDelete          AS LOGICAL
  INDEX pudx IS UNIQUE PRIMARY
    cSessionType
    cProperty
  .

/* ttService are read from the "services" section of the icfconfig.xml file */
DEFINE TEMP-TABLE ttService{&ttServiceExt} NO-UNDO
  FIELD cSessionType      AS CHARACTER
  FIELD iOrder            AS INTEGER 
  FIELD cServiceType      AS CHARACTER FORMAT "X(30)"
  FIELD cServiceName      AS CHARACTER FORMAT "X(30)"
  FIELD cPhysicalService  AS CHARACTER FORMAT "X(30)"
  FIELD cConnectParams    AS CHARACTER FORMAT "X(60)"
  FIELD lDefaultService   AS LOGICAL
  FIELD lConnectAtStartup AS LOGICAL INITIAL YES
  FIELD lCanRunLocal      AS LOGICAL
  FIELD iStartOrder       AS INTEGER 
  FIELD iDBOrder          AS INTEGER INITIAL ?
  FIELD iCFGOrder         AS INTEGER INITIAL ?
  FIELD lUpdated          AS LOGICAL
  FIELD lDelete           AS LOGICAL
  INDEX pudx IS PRIMARY UNIQUE
    cSessionType
    iOrder
  INDEX udxServiceName 
    cSessionType
    cServiceName
  INDEX udxServiceType 
    cSessionType
    cServiceType
    iOrder
  INDEX dxStartOrder
    iStartOrder
  INDEX dxCFGOrder
    cSessionType
    iCFGOrder
  INDEX dxDBOrder
    cSessionType
    iDBOrder
  .

/* ttManager are read from the "managers" section of the icfconfig.xml file */
DEFINE TEMP-TABLE ttManager{&ttManagerExt} NO-UNDO RCODE-INFORMATION
  FIELD cSessionType     AS CHARACTER
  FIELD iOrder           AS INTEGER
  FIELD cManagerName     AS CHARACTER FORMAT "X(30)" LABEL "Manager Name"
  FIELD cFileName        AS CHARACTER FORMAT "X(60)" LABEL "Manager Procedure"
  FIELD cHandleName      AS CHARACTER FORMAT "X(5)"  LABEL "Handle Used"
  FIELD cSuperOf         AS CHARACTER FORMAT "X(30)"  LABEL "Super Of"
  FIELD hHandle          AS HANDLE 
  FIELD iUniqueID        AS INTEGER
  FIELD iDBOrder   AS INTEGER INITIAL ?
  FIELD iCFGOrder  AS INTEGER INITIAL ?
  FIELD lUpdated         AS LOGICAL
  FIELD lDelete          AS LOGICAL
  INDEX pudx IS PRIMARY UNIQUE
    cSessionType
    iOrder
  INDEX udxManager 
    cSessionType
    cManagerName
  INDEX dxFilePath
    cSessionType
    cFileName
    iOrder
  INDEX dxHandle
    cSessionType
    hHandle
    iOrder
  INDEX dxCFGOrder
    cSessionType
    iCFGOrder
  INDEX dxDBOrder
    cSessionType
    iDBOrder
  .

&IF DEFINED(session-table) <> 0 &THEN
  DEFINE TEMP-TABLE ttSession{&ttSessionExt} NO-UNDO
    FIELD cSessionType AS CHARACTER 
    {&session-table-fields}
    INDEX pudx IS PRIMARY UNIQUE
      cSessionType
    .
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNextOrderNum Include 
FUNCTION getNextOrderNum RETURNS INTEGER PRIVATE
  ( INPUT phBuffer   AS HANDLE,
    INPUT pcSessType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getProperty Include 
FUNCTION getProperty RETURNS CHARACTER PRIVATE
  ( INPUT pcSessType AS CHARACTER,
    INPUT pcProperty AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setProperty Include 
FUNCTION setProperty RETURNS LOGICAL PRIVATE
  ( INPUT pcSessType   AS CHARACTER,
    INPUT pcProperty   AS CHARACTER,
    INPUT pcValue      AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 32.38
         WIDTH              = 58.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNextOrderNum Include 
FUNCTION getNextOrderNum RETURNS INTEGER PRIVATE
  ( INPUT phBuffer   AS HANDLE,
    INPUT pcSessType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Calculates the next order number for the input table.
    Notes:  This function assumes that the input table has a field called
            cSessionType and a field called iOrder and that there is a unique
            index on a combination of the two fields.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery        AS HANDLE   NO-UNDO.
  DEFINE VARIABLE cQueryString  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iOrder        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hOrder        AS HANDLE   NO-UNDO.

  /* Set up the query string that for the query-prepare */
  cQueryString = "FOR EACH ":U + phBuffer:NAME + " NO-LOCK ":U +
                 "  WHERE cSessionType = '":U + pcSessType +
                 "'  BY cSessionType BY iOrder":U.

  /* Get the handle to the iOrder field */
  hOrder = phBuffer:BUFFER-FIELD("iOrder":U).

  /* Create the query */
  CREATE QUERY hQuery.

  /* Set the buffers, prepare the query and open it */
  hQuery:SET-BUFFERS(phBuffer).
  hQuery:QUERY-PREPARE(cQueryString).
  hQuery:QUERY-OPEN().

  /* Go to the last record */
  hQuery:GET-LAST().

  /* If there are records in the table, add 1 to the 
     last record's order number. */
  IF NOT hQuery:QUERY-OFF-END THEN
    iOrder = hOrder:BUFFER-VALUE + 1.
  ELSE
    /* Otherwise set the order number to 1 */
    iOrder = 1.

  /* Close the query and delete the object handle */
  hQuery:QUERY-CLOSE().
  DELETE OBJECT hQuery.
  hQuery = ?.

  RETURN iOrder.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getProperty Include 
FUNCTION getProperty RETURNS CHARACTER PRIVATE
  ( INPUT pcSessType AS CHARACTER,
    INPUT pcProperty AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value associated with a Property.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttProperty FOR ttProperty{&ttPropertyExt}.
  DEFINE VARIABLE cRetVal AS CHARACTER  NO-UNDO.

  /* Find the ttProperty record and set the return value 
     to the value of the property */
  DO FOR bttProperty:
    FIND bttProperty
      WHERE bttProperty.cSessionType = pcSessType
        AND bttProperty.cProperty = pcProperty
      NO-ERROR.
    IF NOT AVAILABLE(bttProperty) THEN
      cRetVal = ?.
    ELSE
      cRetVal = bttProperty.cValue.
  END.
  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setProperty Include 
FUNCTION setProperty RETURNS LOGICAL PRIVATE
  ( INPUT pcSessType   AS CHARACTER,
    INPUT pcProperty   AS CHARACTER,
    INPUT pcValue      AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the value of properties in the ttProperty table.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE BUFFER bttProperty FOR ttProperty{&ttPropertyExt}.


  /* Find the ttProperty record, creating it if necessary, and set the 
     value of the property to the value in the input parameter */
  DO FOR bttProperty:
    FIND FIRST bttProperty
      WHERE bttProperty.cSessionType = pcSessType
        AND bttProperty.cProperty = pcProperty
      NO-ERROR.
    IF NOT AVAILABLE(bttProperty) THEN
    DO:
      CREATE bttProperty.
      ASSIGN
        bttProperty.cSessionType = pcSessType
        bttProperty.cProperty = pcProperty
        .
    END.

    ERROR-STATUS:ERROR = NO.

    ASSIGN
      bttProperty.cValue  = pcValue
      .
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

