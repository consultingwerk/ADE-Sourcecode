&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/  
/* Copyright (c) 1984-2007 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : _imp-policies.p
    Purpose     : Imports a xml file containing audit policies into either a 
                  database or a dataset.

    Syntax      : 

    Description : This should be run as a persistent procedure and caller
                  should call the methods for db or dataset cases.

    Author(s)   : Fernando de Souza
    Created     : Feb 23,2005
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* temp-table definitions */
{auditing/ttdefs/_audpolicytt.i}
{auditing/ttdefs/_audfilepolicytt.i}
{auditing/ttdefs/_audfieldpolicytt.i}
{auditing/ttdefs/_audeventpolicytt.i}

{auditing/include/_dspolicy.i} /* dataset definition */

/* temp-tables used to hold the data imported from the xml file */
DEFINE TEMP-TABLE workAuditPolicy      LIKE ttAuditPolicy.
DEFINE TEMP-TABLE workAuditFilePolicy  LIKE ttAuditFilePolicy.
DEFINE TEMP-TABLE workAuditFieldPolicy LIKE ttAuditFieldPolicy.
DEFINE TEMP-TABLE workAuditEventPolicy LIKE ttAuditEventPolicy.

/* buffers for the working temp-tables defined above */
DEFINE VARIABLE hBuf-AuditPolicy      AS HANDLE NO-UNDO. 
DEFINE VARIABLE hBuf-AuditFilePolicy  AS HANDLE NO-UNDO. 
DEFINE VARIABLE hBuf-AuditFieldPolicy AS HANDLE NO-UNDO. 
DEFINE VARIABLE hBuf-AuditEventPolicy AS HANDLE NO-UNDO. 


DEFINE VARIABLE hFld AS HANDLE. 

/* state machine - used to validate the XML file */
DEF VAR iProcessingState as INT. 

&SCOPED-DEFINE READY-TO-START        1 
&SCOPED-DEFINE GETTING-POLICIES      2 
&SCOPED-DEFINE GETTING-POLICY        3 
&SCOPED-DEFINE GETTING-PROPERTIES    4 
&SCOPED-DEFINE GETTING-TABLE         5 
&SCOPED-DEFINE GETTING-FIELDS        6 
&SCOPED-DEFINE GETTING-EVENT         7 
&SCOPED-DEFINE DONE-POLICIES         8 
&SCOPED-DEFINE DONE-POLICY           9 
&SCOPED-DEFINE DONE-PROPERTIES      10
&SCOPED-DEFINE DONE-TABLE           11 
&SCOPED-DEFINE DONE-FIELDS          12 
&SCOPED-DEFINE DONE-EVENT           13 


&SCOPED-DEFINE LINENUM " (Line " + STRING(SELF:LOCATOR-LINE-NUMBER) + ")"

/* variable in which to accumulate all the text data for one element 
   coming in through potentially multiple calls (per element) to the 
   Characters procedure 
*/ 
DEFINE VARIABLE currentFieldValue AS CHAR NO-UNDO.

/* keep the values of the current policy and table being imported from the xml file */
DEFINE VARIABLE currentGUID       AS CHARACTER NO-UNDO.
DEFINE VARIABLE currentTableName  AS CHARACTER NO-UNDO.
DEFINE VARIABLE currentOwner      AS CHARACTER NO-UNDO.

/* remember if we are processing db or dataset */
DEFINE VARIABLE cMode             AS CHARACTER NO-UNDO INIT "".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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

&IF DEFINED(EXCLUDE-Characters) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Characters Procedure 
PROCEDURE Characters :
/*------------------------------------------------------------------------------
  Purpose:     Callback for the sax-parser 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER charData AS MEMPTR. 
  DEFINE INPUT PARAMETER numChars AS INTEGER. 

  /* get the text value of the field (hFld was set to the correct field 
     in StartElement 
  */ 
  ASSIGN currentFieldValue =  
          currentFieldValue + GET-STRING(charData, 1, GET-SIZE(charData)). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cleanup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cleanup Procedure 
PROCEDURE cleanup :
/*------------------------------------------------------------------------------
  Purpose:     Clean up stuff when procedure is done
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE workAuditPolicy.
EMPTY TEMP-TABLE workAuditFilePolicy.
EMPTY TEMP-TABLE workAuditFieldPolicy.
EMPTY TEMP-TABLE workAuditEventPolicy.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copy-changes-to-dset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copy-changes-to-dset Procedure 
PROCEDURE copy-changes-to-dset :
/*------------------------------------------------------------------------------
  Purpose:     Fill the dataset specified with the records loaded in import-xml-fill-dset.
               It's the caller's responsibility to reject the changes if an error occurs.
               If import-xml-fill-dset doesn't returned duplicate policies or caller 
               specified that it should override existing policies, then import-xml-fill-dset
               automatically fill the dataset with the records loaded, and this procedure
               should not be called.
  
  Parameters:  INPUT-OUTPUT  dataset      - dataset where to copy the records into
               OUTPUT        perrorMsg    - any error message
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsAudPolicy.
DEFINE OUTPUT PARAMETER perrorMsg     AS CHAR NO-UNDO.

    /* make sure caller is not mixing modes */
    IF cMode = "" THEN DO:
        ASSIGN pErrorMsg = "ERROR: Invalid state. Can't save changes.".
        RETURN.
    END.
    ELSE IF cMode <> "dataset" THEN DO:
        ASSIGN pErrorMsg = "ERROR: Previous call was not for dataset mode: " + cMode.
        RETURN.
    END.
    
    /* first see if there are any duplicate policies and delete them */
    FOR EACH workAuditPolicy.
        FIND FIRST ttAuditPolicy 
            WHERE ttAuditPolicy._Audit-policy-name = workAuditPolicy._Audit-policy-name NO-ERROR.
        IF AVAILABLE ttAuditPolicy THEN DO:
            /* remove all the records for this GUID */
            
            /* audit-file */
            FOR EACH ttAuditFilePolicy 
                WHERE ttAuditFilePolicy._Audit-policy-guid = ttAuditPolicy._Audit-policy-guid:
                DELETE ttAuditFilePolicy .
            END.

            /* audit-field */
            FOR EACH ttAuditFieldPolicy 
                WHERE ttAuditFieldPolicy._Audit-policy-guid = ttAuditPolicy._Audit-policy-guid:
                DELETE ttAuditFieldPolicy .
            END.

            /* audit-event */
            FOR EACH ttAuditEventPolicy 
                WHERE ttAuditEventPolicy._Audit-policy-guid = ttAuditPolicy._Audit-policy-guid:
                DELETE ttAuditEventPolicy .
            END.

            /* delete the policy record */
            DELETE ttAuditPolicy.
        END.
    END. /* for each ttAuditPolicy */

    /* now copy the records from the local temp-tables into the dataset */

    /* audit-policy */
    FOR EACH workAuditPolicy.
        CREATE ttAuditPolicy.
        BUFFER-COPY workAuditPolicy TO ttAuditPolicy NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pErrorMsg = ERROR-STATUS:GET-MESSAGE(1).
            RETURN.
        END.

        /* remember this was imported so that we generate an audit event on import of
           policies
        */
        ttAuditPolicy._imported = YES.
    END.

    /* audit-file */
    FOR EACH workAuditFilePolicy.
        CREATE ttAuditFilePolicy.
        BUFFER-COPY workAuditFilePolicy TO ttAuditFilePolicy NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pErrorMsg = ERROR-STATUS:GET-MESSAGE(1).
            RETURN.
        END.
    END.
    
    /* audit-field */
    FOR EACH workAuditFieldPolicy.
        CREATE ttAuditFieldPolicy.
        BUFFER-COPY workAuditFieldPolicy TO ttAuditFieldPolicy NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pErrorMsg = ERROR-STATUS:GET-MESSAGE(1).
            RETURN.
        END.
    END.
    
    /* audit-event */
    FOR EACH workAuditEventPolicy.
        CREATE ttAuditEventPolicy.
        BUFFER-COPY workAuditEventPolicy TO ttAuditEventPolicy NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pErrorMsg = ERROR-STATUS:GET-MESSAGE(1).
            RETURN.
        END.
    END.

    /* restore mode and clean up before returning */
    ASSIGN cMode = "".

    RUN cleanup.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dynamic-delete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dynamic-delete Procedure 
PROCEDURE dynamic-delete :
/*------------------------------------------------------------------------------
  Purpose:     Delete the records of a given table.
               
  Parameters:  INPUT pcTableName - name of the table. should reference logical db name
                                   (i.e. db-name.table-name) if more than one db connected
                                   with same table name. 
               INPUT pcWhere     - where clause or empty string
               INPUT plWait      - if set to YES, wait if a lock can't be acquired,
                                   otherwise returns an error
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcTableName AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcWhere     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER plWait      AS LOGICAL   NO-UNDO.

DEFINE VARIABLE hQuery  AS HANDLE  NO-UNDO.
DEFINE VARIABLE hBuffer AS HANDLE  NO-UNDO.
DEFINE VARIABLE ret     AS LOGICAL NO-UNDO.
DEFINE VARIABLE cError  AS CHAR    NO-UNDO INIT "".

    /* try to create a buffer for the table. pcTableName should be
       db-name.table-name
    */
    CREATE BUFFER hBuffer FOR TABLE pcTableName NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        RETURN ERROR-STATUS:GET-MESSAGE(1).
    END.

    CREATE QUERY hQuery.
    hQuery:ADD-BUFFER(hBuffer).
    
    /* builds a query using the table name and where clause specified. */
    ret = hQuery:QUERY-PREPARE("FOR EACH ":U + pcTableName + " " + pcWhere) NO-ERROR.
    IF NOT ret THEN DO:
        DELETE OBJECT hQuery.
        DELETE OBJECT hBuffer.
        RETURN "Could not prepare query for " + pcTableName.
    END.

    /* opens query */
    hQuery:QUERY-OPEN.
    /* check if we should wait or not for a lock */
    IF plWait THEN
       hQuery:GET-FIRST(EXCLUSIVE-LOCK) NO-ERROR.
    ELSE
       hQuery:GET-FIRST(EXCLUSIVE-LOCK, NO-WAIT) NO-ERROR.


    /* loop through the result-set and delete the records */
    DO WHILE NOT hQuery:QUERY-OFF-END.
        /* record was locked, return error */
        IF hBuffer:LOCKED THEN DO:
            ASSIGN cError = "Could not delete record in table " + pcTableName + " because it is locked by another user".
            LEAVE.
        END.
        
        hBuffer:BUFFER-DELETE().
        hQuery:GET-NEXT(EXCLUSIVE-LOCK) NO-ERROR.
    END.

    hQuery:QUERY-CLOSE.

    DELETE OBJECT hQuery.
    DELETE OBJECT hBuffer.

    RETURN cError.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-EndElement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EndElement Procedure 
PROCEDURE EndElement :
/*------------------------------------------------------------------------------
  Purpose:     Callback for the sax-parser 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER namespaceURI AS CHARACTER. 
DEFINE INPUT PARAMETER localName AS CHARACTER. 
DEFINE INPUT PARAMETER qName as CHARACTER.

DEFINE VARIABLE iValue AS INTEGER NO-UNDO.
DEFINE VARIABLE lValue AS LOGICAL NO-UNDO.


    IF localName = "Policies" THEN 
        iProcessingState = {&DONE-POLICIES}. 
      ELSE IF localName = "Policy" THEN 
        iProcessingState = {&DONE-POLICY}. 
      ELSE IF localName = "policy-properties" THEN 
          iProcessingState = {&DONE-PROPERTIES}. 
      ELSE IF localName = "audit-table" THEN 
           iProcessingState = {&DONE-TABLE}.
      ELSE IF localName = "audit-field" THEN 
        iProcessingState = {&DONE-FIELDS}. 
      ELSE IF localName = "audit-event" THEN 
        iProcessingState = {&DONE-EVENT}. 
      ELSE IF iProcessingState = {&GETTING-PROPERTIES} OR 
           iProcessingState = {&GETTING-TABLE} OR 
           iProcessingState = {&GETTING-FIELDS} OR 
           iProcessingState = {&GETTING-EVENT} THEN  DO:
          
          /* validate the element value */
          CASE iProcessingState:
              WHEN {&GETTING-PROPERTIES} THEN DO:
                  IF hFld:NAME = "_Audit-data-security-level":U THEN DO:
                     iValue = integer(currentFieldValue) NO-ERROR.
                     IF ERROR-STATUS:ERROR OR iValue = ? OR iValue < 0 OR iValue > 2 THEN
                        RETURN ERROR "Invalid _Audit-data-security-level" + {&LINENUM}.
                  END.
                  ELSE IF hFld:NAME = "_Audit-custom-detail-level":U THEN DO:
                     iValue = integer(currentFieldValue) NO-ERROR.
                     IF ERROR-STATUS:ERROR OR iValue = ? OR iValue < 0 OR iValue > 1 THEN
                        RETURN ERROR "Invalid _Audit-custom-detail-level value" + {&LINENUM}.
                  END.
                  ELSE IF hFld:NAME = "_Audit-policy-active":U THEN DO:
                     lValue = LOGICAL(currentFieldValue) NO-ERROR.

                     IF lValue = ? THEN
                        RETURN ERROR "Invalid _Audit-policy-active value" + {&LINENUM}.
                     
                  END.
              END.
              WHEN {&GETTING-TABLE} THEN DO:
                  IF hFld:NAME = "_Audit-create-level":U THEN DO:
                     iValue = integer(currentFieldValue) NO-ERROR.
                      
                      IF ERROR-STATUS:ERROR OR iValue = ? OR iValue < 0 OR (iValue > 2 AND iValue NE 12) THEN
                         RETURN ERROR "Invalid _Audit-create-level value" + {&LINENUM}.
                  END.
                  ELSE IF hFld:NAME = "_Audit-update-level":U THEN DO:
                      iValue = integer(currentFieldValue) NO-ERROR.
                      IF ERROR-STATUS:ERROR OR iValue = ? OR iValue < 0 OR 
                         (iValue > 3 AND iValue NE 12 AND iValue NE 13) THEN
                         RETURN ERROR "Invalid _Audit-update-level value" + {&LINENUM}.
                  END.
                  ELSE IF hFld:NAME = "_Audit-delete-level":U THEN DO:
                      iValue = integer(currentFieldValue) NO-ERROR.
                      IF ERROR-STATUS:ERROR OR iValue = ? OR iValue < 0 OR 
                         (iValue > 2 AND iValue NE 12) THEN
                         RETURN ERROR "Invalid _Audit-delete-level value" + {&LINENUM}.
                  END.
                  ELSE IF hFld:NAME = "_Create-event-id":U OR
                      hFld:NAME = "_Update-event-id":U OR
                      hFld:NAME = "_Delete-event-id":U THEN DO:

                      iValue = integer(currentFieldValue) NO-ERROR.

                      IF ERROR-STATUS:ERROR THEN
                         RETURN ERROR "Invalid " +  hFld:NAME + " value" + {&LINENUM}.
                  END.


              END.
              WHEN {&GETTING-FIELDS} THEN DO:

                  IF hFld:NAME = "_Audit-create-level":U THEN DO:
                      iValue = integer(currentFieldValue) NO-ERROR.
                      IF ERROR-STATUS:ERROR OR iValue = ? OR iValue < -1 OR 
                         (iValue > 2 AND iValue NE 12) THEN
                         RETURN ERROR "Invalid _Audit-create-level value" + {&LINENUM}.
                  END.
                  ELSE IF hFld:NAME = "_Audit-update-level":U THEN DO:
                      iValue = integer(currentFieldValue) NO-ERROR.
                      IF ERROR-STATUS:ERROR OR iValue = ? OR iValue < -1 OR 
                         (iValue > 3 AND iValue NE 12 AND iValue NE 13) THEN
                         RETURN ERROR "Invalid _Audit-update-level value" + {&LINENUM}.
                  END.
                  ELSE IF hFld:NAME = "_Audit-delete-level":U THEN DO:
                      iValue = integer(currentFieldValue) NO-ERROR.
                      IF ERROR-STATUS:ERROR OR iValue = ? OR iValue < -1 OR 
                         (iValue > 2 AND iValue NE 12)THEN
                         RETURN ERROR "Invalid _Audit-delete-level value" + {&LINENUM}.
                  END.
                  ELSE IF hFld:NAME = "_Audit-identifying-field":U THEN DO:
                      iValue = integer(currentFieldValue) NO-ERROR.
                      IF ERROR-STATUS:ERROR OR iValue = ? OR iValue < 0 THEN
                         RETURN ERROR "Invalid _Audit-identifying-field value" + {&LINENUM}.
                  END.

              END.
              WHEN {&GETTING-EVENT} THEN DO:
                  IF hFld:NAME = "_Event-level":U THEN DO:
                      iValue = integer(currentFieldValue) NO-ERROR.
                      IF ERROR-STATUS:ERROR OR iValue = ? OR iValue < 0 OR iValue > 2 THEN
                         RETURN ERROR "Invalid _Event-level value" + {&LINENUM}.
                  END.
              END.

          END CASE.

        hFld:BUFFER-VALUE = currentFieldValue. 
      END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Error) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Error Procedure 
PROCEDURE Error :
/*------------------------------------------------------------------------------
  Purpose:     Callback for the sax-parser 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER errMESSAGE AS CHARACTER.

   RETURN errMESSAGE 
            + "(Line " + STRING(SELF:LOCATOR-LINE-NUMBER) 
            + ", Col " + STRING(SELF:LOCATOR-COLUMN-NUMBER) 
            + ")". 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-FatalError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FatalError Procedure 
PROCEDURE FatalError :
/*------------------------------------------------------------------------------
  Purpose:     Callback for the sax-parser 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER errMessage AS CHARACTER. 

  /* RETURN ERROR in an error handler implicitly calls SELF:STOP-PARSING(), 
     sets SELF:PARSE-STATUS to SAX-PARSER-ERROR, and raises the Progress 
     ERROR condition */ 
  RETURN ERROR errMessage 
            + "(Line " + STRING(SELF:LOCATOR-LINE-NUMBER) 
            + ", Col " + STRING(SELF:LOCATOR-COLUMN-NUMBER) 
            + ")". 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-import-xml-db) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE import-xml-db Procedure 
PROCEDURE import-xml-db :
/*------------------------------------------------------------------------------
  Purpose:     Imports a xml file containing audit polices into a given database.
               The database name passed is the logical name of a connected database.
               If the XML file contains policies which already exist in the database,
               then this procedure will not update the database, and return a 
               comma-separated list of existing policies, if ploverride is set to NO. 
               The caller procedure can then ask for confirmation and call
               save-changes-to-db. If ploverride is set to YES, this procedure will
               automatically override all existing policies and will not return anything in
               pcDupList. Any errors cause the import operation to be backed out, and 
               perrorMsg is set.
               
  Parameters:  INPUT  pxmlFileName - the name of the xml file
               INPUT  pcDbName     - the logical name of the database where to import
                                     the policies into
               INPUT  plWait       - wait if a lock on a record can't be acquired
               INPUT  ploverride   - override existing policies
               OUTPUT pcDupList    - comma-separated list of policies which already exist
                                     in the given database and are also in the xml file
               OUTPUT perrorMsg    - any error message
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pxmlFileName  AS CHAR    NO-UNDO.
DEFINE INPUT  PARAMETER pcDbName      AS CHAR    NO-UNDO.
DEFINE INPUT  PARAMETER plWait        AS LOGICAL NO-UNDO.
DEFINE INPUT  PARAMETER ploverride    AS LOGICAL NO-UNDO.
DEFINE OUTPUT PARAMETER pcDupList     AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER pErrorMsg     AS CHAR    NO-UNDO.

DEFINE VARIABLE hBuffer AS HANDLE  NO-UNDO.
DEFINE VARIABLE cTable  AS CHAR    NO-UNDO.
DEFINE VARIABLE lRet    AS LOGICAL NO-UNDO INITIAL NO.

    /* make sure database is connected */
    IF NOT CONNECTED(pcDbName) THEN DO:
        ASSIGN pErrorMsg = "Database " + pcDbName + " is not connected".
        RETURN.
    END.

    /* we will try to check if the file exists */
    FILE-INFO:FILE-NAME = pxmlFileName.
    IF FILE-INFO:FILE-TYPE EQ ? THEN DO:
        /* file doesn't exist */
        ASSIGN  pErrorMsg = "Could not find file " + pxmlFileName.
        RETURN.
    END.
    FILE-INFO:FILE-NAME = ?.

    {auditing/include/_xmlsec.i
          &INPUT=pxmlFileName
          &mode="valid"
          &ret=lRet
          }

    IF NOT lRet THEN DO:
        ASSIGN pErrorMsg = "The file " + pxmlFileName + " has changed since it was exported or " +
                           "it does not contain the seal information.".

        RETURN.
    END.

    /* wrap a DO ON ERROR around parseXMLFile because if SAX-PARSE fails,
       we would return to the caller right away.
     */
    DO ON ERROR UNDO, LEAVE.
        /* parse the xml and load the policy(ies) into the local temp-tables */
        RUN parseXMLFile (INPUT pxmlFileName).
    END.

    /* check if parseXMLFile failed */
    ASSIGN perrorMsg = RETURN-VALUE.

    /* check for errors */
    IF perrorMsg = "":U THEN DO:

        /* remember that we are processing this into a database and not a dataset */
        ASSIGN cMode = "db":U.

        /* check if caller wants us to override existing policies */
        IF NOT ploverride THEN DO:

            /* check if there are duplicates*/
            ASSIGN cTable = pcDbName + "._aud-audit-policy":U
                   pcDupList = "".

            /* create a buffer for the table in the database */
            CREATE BUFFER hBuffer FOR TABLE cTable NO-ERROR.
            /* can't create buffer - set error message and return */
            IF ERROR-STATUS:ERROR THEN DO:
                ASSIGN pErrorMsg = ERROR-STATUS:GET-MESSAGE(1).
                RETURN.
            END.
            
            /* look for existing policies. workAuditPolicy is a local temp-table which
               contains all the policies loaded from the xml file
            */
            FOR EACH workAuditPolicy.
                /* try to find a matching policy name */
                hbuffer:FIND-FIRST ("where _Audit-policy-name = " + QUOTER(workAuditPolicy._Audit-policy-name),NO-LOCK) NO-ERROR.
                IF hBuffer:AVAILABLE THEN DO:
                    /* add it to the list */
                    IF pcDupList = "" THEN
                       pcDupList = workAuditPolicy._Audit-policy-name.
                    ELSE
                       pcDupList = pcDupList + ","  + workAuditPolicy._Audit-policy-name.
                END.
            END.
        
            /* if list of duplicate policies is not empty, return now */
            IF pcDupList <> "" THEN DO:
                DELETE OBJECT hBuffer.
                RETURN.
            END.
        END.
    
        IF VALID-HANDLE(hBuffer) THEN
           DELETE OBJECT hBuffer.

        /* if we got here, we are supposed to save the changes, so go ahead and save them */
        RUN save-changes-to-db (INPUT pcDbName,
                                INPUT plWait,
                                OUTPUT perrorMsg).

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-import-xml-fill-dset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE import-xml-fill-dset Procedure 
PROCEDURE import-xml-fill-dset :
/*------------------------------------------------------------------------------
  Purpose:     Imports a XML file containing audit polices into a given dataset.

               If the XML file contains policies which already exist in the dataset,
               then this procedure will not update the dataset, and return a 
               comma-separated list of existing policies, if ploverride is set to NO. 
               The caller procedure can then ask for confirmation and call
               save-changes-to-db. If ploverride is set to YES, this procedure will
               automatically override all existing policies and will not return anything in
               pcDupList. Any errors are returned in perrorMsg. Is the caller's responsibility
               to reject the changes if errors occur.
               
  Parameters:  INPUT         pxmlFileName - the name of the xml file
               INPUT         ploverride   - override existing policies
               INPUT-OUTPUT  dataset      - dataset where to import the policies into
               OUTPUT pcDupList           - comma-separated list of policies which already
                                            exist in the given database and are also in 
                                            the xml file
               OUTPUT perrorMsg           - any error message
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER pxmlFileName  AS CHAR    NO-UNDO.
DEFINE INPUT        PARAMETER ploverride    AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsAudPolicy.
DEFINE OUTPUT       PARAMETER pcDupList     AS CHAR    NO-UNDO.
DEFINE OUTPUT       PARAMETER pErrorMsg     AS CHAR    NO-UNDO.

DEFINE VARIABLE cError  AS CHAR     NO-UNDO.
DEFINE VARIABLE lRet    AS LOGICAL  NO-UNDO.

    /* we will try to check if the file exists */
    FILE-INFO:FILE-NAME = pxmlFileName.
    IF FILE-INFO:FILE-TYPE EQ ? THEN DO:
        /* file doesn't exist */
        ASSIGN  pErrorMsg = "Could not find file " + pxmlFileName.
        RETURN.
    END.
    FILE-INFO:FILE-NAME = ?.

    {auditing/include/_xmlsec.i
          &INPUT=pxmlFileName
          &mode="valid"
          &ret=lRet
          }

    IF NOT lRet THEN DO:
        ASSIGN pErrorMsg = "The file " + pxmlFileName + " has changed since it was exported or " +
                           "it does not contain the seal information.".

        RETURN.
    END.

    /* wrap a DO ON ERROR around parseXMLFile because if SAX-PARSE fails,
       we would return to the caller right away.
     */
    DO ON ERROR UNDO, LEAVE.
        /* parse the xml and load the policy(ies) into the local temp-tables */
        RUN parseXMLFile (INPUT pxmlFileName).
    END.

    /* check if parseXMLFile failed */
    ASSIGN perrorMsg = RETURN-VALUE.

    /* check for errors */
    IF perrorMsg = "":U THEN DO:

        /* remember that we are processing this into a dataset and not a database */
        ASSIGN cMode = "dataset":U.

        /* check if caller wants us to override existing policies */
        IF NOT ploverride THEN DO:

            /*check if there are duplicates*/
            ASSIGN pcDupList = "".
            
            /* look for existing policies. workAuditPolicy is a local temp-table which
               contains all the policies loaded from the xml file
            */
            FOR EACH workAuditPolicy.
                /* try to find a matching policy name */
                FIND FIRST ttAuditPolicy 
                    WHERE ttAuditPolicy._Audit-policy-name = workAuditPolicy._Audit-policy-name NO-ERROR.
                IF AVAILABLE ttAuditPolicy THEN DO:
                    /* add it to the list */
                    IF pcDupList = "":U THEN
                       pcDupList = ttAuditPolicy._Audit-policy-name.
                    ELSE
                       pcDupList = pcDupList + "," + ttAuditPolicy._Audit-policy-name.
                END.
            END.
        
            /* if there are any conflicts return so caller can decide what to do*/
            IF pcDupList <> "" THEN DO:
                RETURN.
            END.
        END.

        /* if we got here, we are supposed to copy the changes, so go ahead and copy them */
        RUN copy-changes-to-dset (INPUT-OUTPUT DATASET dsAudPolicy,
                                  OUTPUT pErrorMsg).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parseXMLFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE parseXMLFile Procedure 
PROCEDURE parseXMLFile :
/*------------------------------------------------------------------------------
  Purpose:     Initial phase. Parse the xml file and load policies into local
               temp-table. Called by import-xml-db and import-xml-fill-dset.
               
  Parameters:  INPUT  pxmlFileName - name of the xml file
               
  Notes:       Caller should check RETURN-VALUE for error messages
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pxmlFileName  AS CHAR NO-UNDO.
DEFINE VARIABLE hParser   AS HANDLE NO-UNDO.

DEFINE VARIABLE cerrorMsg AS CHAR   NO-UNDO.

    CREATE SAX-READER hParser NO-ERROR.
    IF ERROR-STATUS:ERROR THEN  DO:
        cErrorMsg =  "Error creating SAX-READER object:" + ERROR-STATUS:GET-MESSAGE(1).
    END.
    ELSE DO:
    
        /* get the handle of each temp-table. Used in StartElement */
        ASSIGN hBuf-AuditPolicy      = BUFFER workAuditPolicy:HANDLE
               hBuf-AuditFilePolicy  = BUFFER workAuditFilePolicy:HANDLE
               hBuf-AuditFieldPolicy = BUFFER workAuditFieldPolicy:HANDLE
               hBuf-AuditEventPolicy = BUFFER workAuditEventPolicy:HANDLE. 
    
        /* if we are calling more than once, empty the temp-table */
        RUN cleanup.
    
        /* give the SAX-READER the handle to this procedure */ 
        hParser:HANDLER = THIS-PROCEDURE.

        hParser:SET-INPUT-SOURCE("file",  pxmlFileName).

        hParser:VALIDATION-ENABLED = NO.

        hParser:SAX-PARSE() NO-ERROR.

        IF ERROR-STATUS:ERROR THEN 
        DO: 
          IF ERROR-STATUS:NUM-MESSAGES > 0 THEN 
            /* unable to begin the parse */ 
            cErrorMsg = ERROR-STATUS:GET-MESSAGE(1). 
          ELSE 
            /* error detected in a callback */ 
            cErrorMsg = RETURN-VALUE. 
        END. 

        IF hParser:PARSE-STATUS = SAX-UNINITIALIZED THEN
           ASSIGN  cerrorMsg = cErrorMsg + CHR(10) + "UNINITIALIZED".    
        IF hParser:PARSE-STATUS = SAX-PARSER-ERROR THEN
           ASSIGN  cerrorMsg = cErrorMsg + CHR(10) + "PARSER-ERROR".
    
        DELETE OBJECT hParser. 
    
        /* if there were no error messages, check if we had anything to import
           at all
        */
        IF cerrorMsg = "" THEN DO:
            FIND FIRST workAuditPolicy NO-ERROR.
            IF NOT AVAILABLE workAuditPolicy THEN
               cErrorMsg = "XML file does not contains any policies.".
        END.

        /* don't need the buffers anymore */
        ASSIGN hBuf-AuditPolicy = ?
               hBuf-AuditFilePolicy = ?
               hBuf-AuditFieldPolicy = ?
               hBuf-AuditEventPolicy = ?. 
    END.

    RETURN cerrorMsg.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refresh-db-cache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresh-db-cache Procedure 
PROCEDURE refresh-db-cache :
/*------------------------------------------------------------------------------
  Purpose:     This procedure calls the method which refreshes the database
               cache with the newly loaded policy settings. This should only be 
               called after a successful call to import-xml-db or 
               save-changes-to-db has been made. It's up to the caller
               to decide if the cache should be refreshed or not.
               See import-xml-db and save-changes-to-db for more details.
               
  Parameters:  INPUT  pcDbName     - the logical name of the database to have its
                                      cache refreshed
               OUTPUT perrorMsg    - any error message.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcDbName      AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER perrorMsg     AS CHAR    NO-UNDO.

    /* make sure db is connected */
    IF NOT CONNECTED(pcDbName) THEN DO:
        ASSIGN pErrorMsg = "Database " + pcDbName + " not connected".
        RETURN.
    END.

    AUDIT-POLICY:REFRESH-AUDIT-POLICY(pcDbName).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-save-changes-to-db) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE save-changes-to-db Procedure 
PROCEDURE save-changes-to-db :
/*------------------------------------------------------------------------------
  Purpose:     Save the policies previously loaded by import-xml-db into the 
               database specified. This should ONLY be called if import-xml-db returned 
               a list of duplicate policies. If import-xml-db doesn't returned duplicate 
               policies or caller specified that it should override existing policies,
               then import-xml-db automatically saves the changes into the database,
               and this procedure should not be called.
               
  Parameters:  INPUT  pcDbName     - the logical name of the database where to copy
                                     the records into
               INPUT  plWait       - wait if a lock on a record can't be acquired
               OUTPUT perrorMsg    - any error message. Any error message causes the
                                     update to be backed out.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcDbName      AS CHAR    NO-UNDO.
DEFINE INPUT  PARAMETER plWait        AS LOGICAL NO-UNDO.
DEFINE OUTPUT PARAMETER perrorMsg     AS CHAR    NO-UNDO.

DEFINE VARIABLE hBuffer AS HANDLE NO-UNDO.
DEFINE VARIABLE cTable  AS CHAR   NO-UNDO.
DEFINE VARIABLE cGUID   AS CHAR   NO-UNDO.
DEFINE VARIABLE cWhere  AS CHAR   NO-UNDO.

DEFINE VARIABLE hBufferWrk  AS HANDLE NO-UNDO.
DEFINE VARIABLE cTableWrk  AS CHAR   NO-UNDO.
DEFINE VARIABLE cWhereWrk  AS CHAR   NO-UNDO.

DEFINE VARIABLE hBufferAudEvent AS HANDLE NO-UNDO.
DEFINE VARIABLE cTableAudEvent  AS CHAR   NO-UNDO.
DEFINE VARIABLE cIds            AS CHAR   NO-UNDO.
DEFINE VARIABLE newAppCtx       AS LOGICAL NO-UNDO INIT NO.
DEFINE VARIABLE phDbName        AS CHAR   NO-UNDO.

    /* make sure db is connected */
    IF NOT CONNECTED(pcDbName) THEN DO:
        ASSIGN pErrorMsg = "Database " + pcDbName + " not connected".
        RETURN.
    END.

    /* check if caller is mixing modes */
    IF cMode = "" THEN DO:
        ASSIGN pErrorMsg = "ERROR: Invalid state. Can't save changes.".
        RETURN.
    END.
    ELSE IF cMode <> "db" THEN DO:
        ASSIGN pErrorMsg = "ERROR: Previous call was not for database mode: " + cMode.
        RETURN.
    END.

    /*OUTPUT TO dump.LOG.
        FOR EACH workAuditPolicy.
            EXPORT workAuditPolicy.
        END.

        FOR EACH workAuditFilePolicy.
            EXPORT workAuditFilePolicy.
        END.

        FOR EACH workAuditFieldPolicy.
            EXPORT workAuditFieldPolicy.
        END.

        FOR EACH workAuditEventPolicy.
            EXPORT workAuditEventPolicy.
        END.

    OUTPUT CLOSE.
    */

    /* try to get a buffer for the _aud-event table so we can validate
       the event id's in the file-policy and event-policy tables
    */
    ASSIGN cTableAudEvent = pcDbName + "._aud-event":U.

    CREATE BUFFER hBufferAudEvent FOR TABLE cTableAudEvent NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN pErrorMsg = ERROR-STATUS:GET-MESSAGE(1).
        RETURN.
    END.

    /* first, let's process the audit-policy table */
    ASSIGN cTable = pcDbName + "._aud-audit-policy":U.

    CREATE BUFFER hBuffer FOR TABLE cTable NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN pErrorMsg = ERROR-STATUS:GET-MESSAGE(1).
        RETURN.
    END.

    /* auditing - start a new application context so that one can report
       all the records that are loaded as a group.
    */
    IF AUDIT-CONTROL:APPL-CONTEXT-ID = ? THEN DO:
       ASSIGN newAppCtx = YES.
       AUDIT-CONTROL:SET-APPL-CONTEXT("Import Audit Policies", "XML", "").
    END.

    main-trans:
    DO TRANSACTION ON ERROR UNDO, LEAVE:

        /* first delete policies that already exist */
        FOR EACH workAuditPolicy.

            /* try to lock the policy record, so if another user tries to run
               this again, they will have to wait or it will fail
            */
            ASSIGN cWhere = "where _Audit-policy-name = " + QUOTER(workAuditPolicy._Audit-policy-name).

            /* if caller doesn't want to wait, try to get the lock and return error if 
               we can't get it
            */
            IF NOT plWait THEN DO:
                hbuffer:FIND-FIRST (cWhere,EXCLUSIVE-LOCK, NO-WAIT) NO-ERROR.
                IF hBuffer:LOCKED THEN DO:
                    ASSIGN pErrorMsg = "Policy " + workAuditPolicy._Audit-policy-name 
                        + " (database " +  pcDbName + ") is locked by another user". 
                    UNDO main-trans, LEAVE main-trans.
                END.
            END.
            ELSE
                hbuffer:FIND-FIRST (cWhere, EXCLUSIVE-LOCK) NO-ERROR.

            IF hBuffer:AVAILABLE THEN DO:
                /* now let's delete all the children records */
                
                /* audit file policy */
                ASSIGN cTableWrk = pcDbName + "._aud-file-policy":U
                       cGUID = hBuffer::_Audit-policy-guid
                       cWhereWrk = "where _Audit-policy-guid = " + QUOTER(cGUID).

                /* deletes all audit-file records for the current policy */
                RUN dynamic-delete (INPUT cTableWrk, 
                                    INPUT cWhereWrk,
                                    INPUT plWait).

                IF RETURN-VALUE <> "" THEN DO:
                    ASSIGN pErrorMsg = RETURN-VALUE.
                    UNDO main-trans, LEAVE main-trans.
                END.

                /* audit field policy */
                ASSIGN cTableWrk = pcDbName + "._aud-field-policy":U.

                /* deletes all audit-field records for the current policy */
                RUN dynamic-delete (INPUT cTableWrk, 
                                    INPUT cWhereWrk,
                                    INPUT plWait).

                IF RETURN-VALUE <> "" THEN DO:
                    ASSIGN pErrorMsg = RETURN-VALUE.
                    UNDO main-trans, LEAVE main-trans.
                END.

                /* audit event policy */
                ASSIGN cTableWrk = pcDbName + "._aud-event-policy":U.

                /* deletes all audit-event records for the current policy */
                RUN dynamic-delete (INPUT cTableWrk, 
                                    INPUT cWhereWrk,
                                    INPUT plWait).

                IF RETURN-VALUE <> "" THEN DO:
                    ASSIGN pErrorMsg = RETURN-VALUE.
                    UNDO main-trans, LEAVE main-trans.
                END.

                /* now let's delete the policy itself */
                hBuffer:BUFFER-DELETE().
            END.
        END.

        /* now let's load eveything. Start with the audit-policy table */
        ASSIGN cTable = pcDbName + "._aud-audit-policy":U.

        CREATE BUFFER hBufferWrk FOR TABLE cTable NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            ASSIGN pErrorMsg = ERROR-STATUS:GET-MESSAGE(1).
            UNDO, LEAVE.
        END.
        
        FOR EACH workAuditPolicy.
            /* make sure the GUID value is unique */
            hBufferWrk:FIND-FIRST("where _Audit-policy-guid = " + QUOTER(workAuditPolicy._Audit-policy-guid)) NO-ERROR.

            IF hBufferWrk:AVAILABLE THEN DO:
               ASSIGN pErrorMsg = "Found another policy with GUID " + _Audit-policy-guid.
               UNDO main-trans, LEAVE main-trans.
            END.

            hBufferWrk:BUFFER-CREATE().
            hbufferWrk:BUFFER-COPY(BUFFER workAuditPolicy:HANDLE).
        END.

        DELETE OBJECT hBufferWrk.

        /* audit file policy */
        ASSIGN cTable = pcDbName + "._aud-file-policy":U.

        CREATE BUFFER hBufferWrk FOR TABLE cTable NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            ASSIGN pErrorMsg = ERROR-STATUS:GET-MESSAGE(1).
            UNDO, LEAVE.
        END.
        
        FOR EACH workAuditFilePolicy.

            RUN auditing/_get-def-eventids.p (INPUT workAuditFilePolicy._File-name, OUTPUT cIds).

            /* check if some of the events don't apply to this table (only for meta schema tables */
            IF workAuditFilePolicy._File-name BEGINS "_"  THEN DO:

                /* cIds will contain a comma-separated list of default event-ids based on the table
                   name. The order is create,update,delete event id.
                   If a given entry is "0", the event does not apply (for instance, create on _Db,
                   so if the value in the xml file was different than 0, we will silently reset it
                   to zero (just so we don't record the value since it won't have any effect
                   anyways.
                */
                IF ENTRY(1,cIds) = "0" AND workAuditFilePolicy._Create-event-id <> 0 THEN
                   ASSIGN workAuditFilePolicy._Create-event-id = 0.

                IF NUM-ENTRIES(cIds) > 1 AND ENTRY(2,cIds) = "0" AND workAuditFilePolicy._Update-event-id <> 0 THEN
                   ASSIGN workAuditFilePolicy._Update-event-id = 0.

                IF NUM-ENTRIES(cIds) > 2 AND ENTRY(3,cIds) = "0" AND workAuditFilePolicy._Delete-event-id <> 0 THEN
                   ASSIGN workAuditFilePolicy._Delete-event-id = 0.

            END.

            /* check the create event id value */
            hBufferAudEvent:FIND-FIRST("where _Event-id = " + STRING(workAuditFilePolicy._Create-event-id)) NO-ERROR.

            IF NOT hBufferAudEvent:AVAILABLE THEN DO:

                /* if default event it is zero, than it doesn't apply. */
               IF ENTRY(1,cIds) <> "0" THEN DO:
                   ASSIGN pErrorMsg = "Invalid create event id " + STRING(workAuditFilePolicy._Create-event-id)
                         + " (table " + workAuditFilePolicy._File-name + "/" + workAuditFilePolicy._Owner + ")".
    
                   UNDO main-trans, LEAVE main-trans.
               END.
            END. 
            
            /* check the update event id value */

            hBufferAudEvent:FIND-FIRST("where _Event-id = " + STRING(workAuditFilePolicy._Update-event-id)) NO-ERROR.

            IF NOT hBufferAudEvent:AVAILABLE THEN DO:
                /* if default event it is zero, than it doesn't apply. */
               IF ENTRY(2,cIds) <> "0" THEN DO:
                   ASSIGN pErrorMsg = "Invalid update event id " + STRING(workAuditFilePolicy._Update-event-id)
                         + " (table " + workAuditFilePolicy._File-name + "/" + workAuditFilePolicy._Owner + ")".
    
                   UNDO main-trans, LEAVE main-trans.
               END.
            END. 
            
            /* check the delete event id value */

            hBufferAudEvent:FIND-FIRST("where _Event-id = " + STRING(workAuditFilePolicy._Delete-event-id)) NO-ERROR.

            IF NOT hBufferAudEvent:AVAILABLE THEN DO:
                /* if default event it is zero, than it doesn't apply. */
               IF ENTRY(3,cIds) <> "0" THEN DO:
                   ASSIGN pErrorMsg = "Invalid delete event id " + STRING(workAuditFilePolicy._Delete-event-id)
                         + " (table " + workAuditFilePolicy._File-name + "/" + workAuditFilePolicy._Owner + ")".
    
                   UNDO main-trans, LEAVE main-trans.
               END.
            END.

            hBufferWrk:BUFFER-CREATE().
            /* dont' support read events for now, so don't copy _Read-event-id
               so we don't overwrite the default value
            */
            hbufferWrk:BUFFER-COPY(BUFFER workAuditFilePolicy:HANDLE, "_Read-event-id").
        END.

        DELETE OBJECT hBufferWrk.

        /* audit field policy */
        ASSIGN cTable = pcDbName + "._aud-field-policy":U.

        CREATE BUFFER hBufferWrk FOR TABLE cTable NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            ASSIGN pErrorMsg = ERROR-STATUS:GET-MESSAGE(1).
            UNDO, LEAVE.
        END.
        
        FOR EACH workAuditFieldPolicy.
            hBufferWrk:BUFFER-CREATE().
            hbufferWrk:BUFFER-COPY(BUFFER workAuditFieldPolicy:HANDLE).
        END.

        DELETE OBJECT hBufferWrk.

        /* audit event policy */
        ASSIGN cTable = pcDbName + "._aud-event-policy":U.

        CREATE BUFFER hBufferWrk FOR TABLE cTable NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            ASSIGN pErrorMsg = ERROR-STATUS:GET-MESSAGE(1).
            UNDO, LEAVE.
        END.
        
        FOR EACH workAuditEventPolicy.
            /* check the create event id value */
            hBufferAudEvent:FIND-FIRST("where _Event-id = " + STRING(workAuditEventPolicy._Event-id)) NO-ERROR.

            IF NOT hBufferAudEvent:AVAILABLE THEN DO:
               ASSIGN pErrorMsg = "Invalid event id " + STRING(workAuditEventPolicy._Event-id)
                     + " (GUID " + workAuditEventPolicy._Audit-policy-GUID + ")".

               UNDO main-trans, LEAVE main-trans.
            END. /* check the update event id value */

            hBufferWrk:BUFFER-CREATE().
            hbufferWrk:BUFFER-COPY(BUFFER workAuditEventPolicy:HANDLE).
        END.

        DELETE OBJECT hBufferWrk.

    END.

    /* we are done, if no errors occurred, restore cMode and clean up before returning */
    IF pErrorMsg = "" THEN DO:

       /* need to log audit event for load of policies */

       /* need the physical db name */
       phDbName = PDBNAME(pcDbName).
       
       FOR EACH workAuditPolicy NO-LOCK.
          /* add Data Admin as the utility name - even if someone else calls this procedure,
             this is still part of the Administration code provided by Progress.
             
             If you customize this for your own application, make sure you change this to
             something else so that you know which method was called to import the XML file -
             your custom code or the one that comes with OpenEdge.
          */
          AUDIT-CONTROL:LOG-AUDIT-EVENT(10304, 
                                        "Data Administration." + workAuditPolicy._audit-policy-name /* util-name.policy-name */, 
                                        phDbName + ",XML":U /* detail */).
       END.

       ASSIGN cMode = "".
       RUN cleanup NO-ERROR.
    END.

    /* for auditing - clear the application context, if we have set one */
    IF newAppCtx THEN
       AUDIT-CONTROL:CLEAR-APPL-CONTEXT.

    /* delete buffer objects */
    IF VALID-HANDLE (hBuffer) THEN
       DELETE OBJECT hBuffer.

    IF VALID-HANDLE(hBufferWrk) THEN
       DELETE OBJECT hBufferWrk.

    IF VALID-HANDLE (hBufferAudEvent) THEN
       DELETE OBJECT hBufferAudEvent.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-StartElement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE StartElement Procedure 
PROCEDURE StartElement :
/*------------------------------------------------------------------------------
  Purpose:     Callback for the sax-parser 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER namespaceURI AS CHARACTER. 
DEFINE INPUT PARAMETER localName AS CHARACTER. 
DEFINE INPUT PARAMETER qName AS CHARACTER. 
DEFINE INPUT PARAMETER attributes AS HANDLE. 
  
DEFINE VARIABLE iValue AS INTEGER NO-UNDO.

  /* start of the document */
  IF qName = "Policies" THEN 
    iProcessingState = {&GETTING-POLICIES}. 
  ELSE IF qName = "Policy" THEN /* new policy */
  DO: 

    IF iProcessingState <> {&GETTING-POLICIES} AND 
       iProcessingState <> {&DONE-POLICY} THEN
       RETURN ERROR "Invalid XML document" + {&LINENUM}.

    /* starting a new policy, so create the record */ 
    CREATE workAuditPolicy. 
     
    /*get the fields that are in the XML doc as attributes*/ 
    ASSIGN currentGUID =  attributes:GET-VALUE-BY-QNAME("GUID")
           workAuditPolicy._Audit-policy-guid = currentGUID   
           workAuditPolicy._Audit-policy-name = attributes:GET-VALUE-BY-QNAME("Name"). 
                       
    /* check if GUID is valid */
    IF currentGUID = "" OR currentGUID = ? THEN
        RETURN ERROR "Policy GUID missing" + {&LINENUM}.

    /* check if name is vlid */
    IF  workAuditPolicy._Audit-policy-name = "" OR 
        workAuditPolicy._Audit-policy-name = "" THEN
        RETURN ERROR "Policy Name missing" + {&LINENUM}.

    iProcessingState = {&GETTING-POLICY}. 
  END. 
  ELSE IF qName = "policy-properties" THEN  /* properties of the policy */
  DO: 
      IF iProcessingState <> {&GETTING-POLICY} THEN
         RETURN ERROR "Invalid XML document" + {&LINENUM}.

      iProcessingState = {&GETTING-PROPERTIES}. 
  END.
  ELSE IF qName = "audit-table" THEN  /* new table settings */
  DO:

      IF iProcessingState <> {&DONE-PROPERTIES} AND 
         iProcessingState <> {&DONE-TABLE} THEN
         RETURN ERROR "Invalid XML document" + {&LINENUM}.

      /* starting a new table setting, so create the record */ 
      CREATE workAuditFilePolicy. 

      /*get the fields that are in the XML doc as attributes*/ 
      ASSIGN currentTableName =  attributes:GET-VALUE-BY-QNAME("Name")
             currentOwner =  attributes:GET-VALUE-BY-QNAME("Owner")
             workAuditFilePolicy._Audit-policy-guid = currentGUID
             workAuditFilePolicy._File-name = currentTableName   
             workAuditFilePolicy._Owner = currentOwner. 

      /* validate table name */
      IF currentTableName = ""  OR currentTableName = ? THEN
         RETURN ERROR "Table name missing" + {&LINENUM}.

      /* validate owner name */
      IF currentOwner = ""  OR currentOwner = ? THEN
         RETURN ERROR "SQL Owner missing" + {&LINENUM}.

      /* make sure we don't allow audit data tables */
      IF currentTableName = "_aud-audit-data":U OR  currentTableName = "_aud-audit-data-value":U THEN
          RETURN ERROR "Cannot audit table " + currentTableName + {&LINENUM}. 

      iProcessingState = {&GETTING-TABLE}. 
  END.
  ELSE IF qName = "audit-field" THEN  /* new field settings */
  DO: 
      IF iProcessingState <> {&DONE-FIELDS} AND 
         iProcessingState <> {&GETTING-TABLE} THEN
         RETURN ERROR "Invalid XML document" + {&LINENUM}.

      /* starting a new field setting, so create the record */ 
      CREATE workAuditFieldPolicy. 

      /*get the fields that are in the XML doc as attributes*/ 
      ASSIGN workAuditFieldPolicy._Audit-policy-guid = currentGUID
             workAuditFieldPolicy._File-name = currentTableName   
             workAuditFieldPolicy._Owner = currentOwner
             workAuditFieldPolicy._Field-Name = attributes:GET-VALUE-BY-QNAME("Name").

      /* validate field name */
      IF workAuditFieldPolicy._Field-Name = ""  OR workAuditFieldPolicy._Field-Name = ? THEN
         RETURN ERROR "Field name missing" + {&LINENUM}.

      iProcessingState = {&GETTING-FIELDS}. 
  END.
  ELSE IF qName = "audit-event" THEN /* new event setting */
  DO: 
      IF iProcessingState <> {&DONE-TABLE} AND 
         iProcessingState <> {&DONE-PROPERTIES} AND 
         iProcessingState <> {&DONE-EVENT} THEN
         RETURN ERROR "Invalid XML document" + {&LINENUM}.

      /* starting a new event setting, so create the record */ 
      CREATE workAuditEventPolicy. 

      /*get the fields that are in the XML doc as attributes*/ 
      ASSIGN workAuditEventPolicy._Audit-policy-guid = currentGUID
             iValue = integer(attributes:GET-VALUE-BY-QNAME("Event-id")) NO-ERROR.

      IF ERROR-STATUS:ERROR THEN
          RETURN ERROR "Invalid event id" + {&LINENUM}.

      IF iValue < 1  OR iValue = ? THEN
         RETURN ERROR "Event id missing" + {&LINENUM}.

      ASSIGN workAuditEventPolicy._Event-id = iValue
             iProcessingState = {&GETTING-EVENT}. 
  END.
  ELSE IF iProcessingState = {&GETTING-PROPERTIES} THEN /* reading policy's properties */
  DO: 
      /* get a handle to the field whose name corresponds to the element name */ 
      hFld = hBuf-AuditPolicy:BUFFER-FIELD(qName) NO-ERROR. 
      IF NOT VALID-HANDLE (hFld) THEN
         RETURN ERROR "Unknown tag " + qName + {&LINENUM}.

      /* re-init the variable in which we accumulate the field value */ 
      currentFieldValue = "". 
  END.
  ELSE IF iProcessingState = {&GETTING-TABLE} THEN /* reading table settings */
  DO: 
      /* get a handle to the field whose name corresponds to the element name */ 
      hFld = hBuf-AuditFilePolicy:BUFFER-FIELD(qName) NO-ERROR. 
      IF NOT VALID-HANDLE (hFld) THEN
         RETURN ERROR "Unknown tag " + qName + {&LINENUM}.

      /* re-init the variable in which we accumulate the field value */ 
      currentFieldValue = "". 
  END.
  ELSE IF iProcessingState = {&GETTING-FIELDS} THEN /* reading field settings */
  DO: 
      /* get a handle to the field whose name corresponds to the element name */ 
      hFld = hBuf-AuditFieldPolicy:BUFFER-FIELD(qName) NO-ERROR. 
      IF NOT VALID-HANDLE (hFld) THEN
         RETURN ERROR "Unknown tag " + qName + {&LINENUM}.

      /* re-init the variable in which we accumulate the field value */ 
      currentFieldValue = "". 
  END.
  ELSE IF iProcessingState = {&GETTING-EVENT} THEN /* reading event settings */
  DO: 
      /* get a handle to the field whose name corresponds to the element name */ 
      hFld = hBuf-AuditEventPolicy:BUFFER-FIELD(qName) NO-ERROR. 
      IF NOT VALID-HANDLE (hFld) THEN
         RETURN ERROR "Unknown tag " + qName + {&LINENUM}.

      /* re-init the variable in which we accumulate the field value */ 
      currentFieldValue = "". 
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-warning) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE warning Procedure 
PROCEDURE warning :
/*------------------------------------------------------------------------------
  Purpose:     Callback for the sax-parser 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER errMESSAGE AS CHARACTER.

    /*MESSAGE "warning: " errMESSAGE.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

