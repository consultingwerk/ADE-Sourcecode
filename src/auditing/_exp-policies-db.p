&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : _exp-policies-db.p
    Purpose     : Export policies from a connected db to an xml file

    Syntax      :

    Description : The caller passes a comma-separated list of policies
                  or "*" for all, and the name of the xml file to be
                  created along with the logical db name where to read
                  the policies from.

    Author(s)   : Fernando de Souza
    Created     : Mar 03,2005
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE VARIABLE hXMLWriter         AS HANDLE    NO-UNDO.
DEFINE VARIABLE hBufferPolicy      AS HANDLE    NO-UNDO.
DEFINE VARIABLE hBufferFilePolicy  AS HANDLE    NO-UNDO.
DEFINE VARIABLE hBufferFieldPolicy AS HANDLE    NO-UNDO.
DEFINE VARIABLE hBufferEventPolicy AS HANDLE    NO-UNDO.
DEFINE VARIABLE cTable             AS CHARACTER NO-UNDO.
DEFINE VARIABLE hQueryPolicy       AS HANDLE    NO-UNDO.
DEFINE VARIABLE hQueryFilePolicy   AS HANDLE    NO-UNDO.
DEFINE VARIABLE hQueryFieldPolicy  AS HANDLE    NO-UNDO.
DEFINE VARIABLE hQueryEventPolicy  AS HANDLE    NO-UNDO.
DEFINE VARIABLE phDbName           AS CHARACTER NO-UNDO.

/* parameters */
DEFINE INPUT  PARAMETER pcpolicyNames AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER pxmlFileName  AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER pcDbName      AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorMsg    AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-writeXmlData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD writeXmlData Procedure 
FUNCTION writeXmlData RETURNS LOGICAL
  ( hField AS HANDLE /* parameter-definitions */ )  FORWARD.

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

/* make sure db is connected */
IF NOT CONNECTED(pcDbName) THEN DO:
    ASSIGN pcErrorMsg = "Database " + pcDbName + " is not connected".
    RETURN.
END.

/* we will try to check if the file is writeable, in case it already exists */
FILE-INFO:FILE-NAME = pxmlFileName.
IF FILE-INFO:FILE-TYPE NE ? THEN DO:
    /* file exists - check we can write to it */
    IF INDEX(FILE-INFO:FILE-TYPE, "W":U) = 0 THEN DO:
        ASSIGN  pcErrorMsg = "File " + pxmlFileName + " is read-only".
        RETURN.
    END.

END.
FILE-INFO:FILE-NAME = ?.

ASSIGN phDbName = PDBNAME(pcDbName). /* need physical db name for audit event */

/* The bulk of the process if here. We will create buffers for each one of the tables we care about
   (_aud-audit-policy,_aud-file-policy,_aud-field-policy,_aud-event-policy) and then loop through
   the records using dynamic queries, so we are not tied to a specific database alias.
   
   The basic format of the xml file is:
   <policies>
       <policy>
         <policy-properties>
         </policy-properties>
         <audit-table>
             <audit-field>
             </audit-field>
         </audit-table>
         <audit-event>
         </audit-event>
       </policy>
   </policies>
   
   NOTE: Any change to the format of the xml must be propagated to auditing/_exp-policies and 
         auditing/_imp-policies.
*/

/* get buffer for the _aud-audit-policy table */
ASSIGN cTable = pcDbName + "._aud-audit-policy":U.

CREATE BUFFER hBufferPolicy FOR TABLE cTable NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    ASSIGN pcErrorMsg = ERROR-STATUS:GET-MESSAGE(1).
    RETURN.
END.

/* get buffer for the _aud-file-policy table */
ASSIGN cTable = pcDbName + "._aud-file-policy":U.

CREATE BUFFER hBufferFilePolicy FOR TABLE cTable NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    ASSIGN pcErrorMsg = ERROR-STATUS:GET-MESSAGE(1).
    RUN cleanup.
    RETURN.
END.

/* get buffer for the _aud-field-policy table */
ASSIGN cTable = pcDbName + "._aud-field-policy":U.

CREATE BUFFER hBufferFieldPolicy FOR TABLE cTable NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    ASSIGN pcErrorMsg = ERROR-STATUS:GET-MESSAGE(1).
    RUN cleanup.
    RETURN.
END.

/* get buffer for the _aud-event-policy table */
ASSIGN cTable = pcDbName + "._aud-event-policy":U.

CREATE BUFFER hBufferEventPolicy FOR TABLE cTable NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    ASSIGN pcErrorMsg = ERROR-STATUS:GET-MESSAGE(1).
    RUN cleanup.
    RETURN.
END.

/* create query objects so we can query the tables */
CREATE QUERY hQueryPolicy.
hQueryPolicy:SET-BUFFERS(hBufferPolicy).

CREATE QUERY hQueryFilePolicy.
hQueryFilePolicy:SET-BUFFERS(hBufferFilePolicy).

CREATE QUERY hQueryFieldPolicy.
hQueryFieldPolicy:SET-BUFFERS(hBufferFieldPolicy).

CREATE QUERY hQueryEventPolicy.
hQueryEventPolicy:SET-BUFFERS(hBufferEventPolicy).

/* check if there are any policies to be exporte */

/* open the query for the _aud-audit-policy table */
IF pcpolicyNames = "*" THEN
    hQueryPolicy:QUERY-PREPARE("FOR EACH ":U + hBufferPolicy:NAME + " NO-LOCK":U).
ELSE
    hQueryPolicy:QUERY-PREPARE("FOR EACH ":U + hBufferPolicy:NAME 
                               + " WHERE LOOKUP(_Audit-policy-name,":U + QUOTER(pcpolicyNames) + ") > 0 NO-LOCK":U).

hQueryPolicy:QUERY-OPEN.
hQueryPolicy:GET-FIRST().

IF NOT hBufferPolicy:AVAILABLE THEN DO:
    pcErrorMsg = "Could not find any policy to be exported.".
    hQueryPolicy:QUERY-CLOSE.
    RUN cleanup.
    RETURN.
END.

/* create a sax writer object */
CREATE SAX-WRITER hXMLWriter.

/* Want to format this so it is easy to read */
hXMLWriter:FORMATTED = TRUE.

hXMLWriter:SET-OUTPUT-DESTINATION("file", pxmlFileName).

hXMLWriter:START-DOCUMENT().

/* The VALIDATION-ENABLED attribute defaults to TRUE  */
/* The ENCODING           attribute defaults to UTF-8 */
/* The CREATE-FRAGMENT    attribute defaults to FALSE */
/* The STRICT             attribute defaults to TRUE  */

hXMLWriter:WRITE-COMMENT("Generated by PSC").

hXMLWriter:START-ELEMENT("Policies", "").

/* the query for the _aud-audit-policy table was already open before we
   opened the xml file
*/
hQueryPolicy:GET-FIRST().

/* loop through records in the _aud-audit-policy */
DO WHILE NOT hQueryPolicy:QUERY-OFF-END:

    hXMLWriter:START-ELEMENT("Policy", "").
    
    hXMLWriter:INSERT-ATTRIBUTE("GUID", STRING(hBufferPolicy::_Audit-policy-guid)).
    hXMLWriter:INSERT-ATTRIBUTE("Name", STRING(hBufferPolicy::_Audit-policy-name)).


    /* need to log audit event for dump of audit policies */
    /* add Data Admin as the utility name - even if someone else calls this procedure,
       this is still part of the Administration code provided by Progress.

       If you customize this for your own application, make sure you change this to
       something else so that you know which method was called to export the XML file -
       your custom code or the one that comes with OpenEdge.
    */
    AUDIT-CONTROL:LOG-AUDIT-EVENT(10303, 
                                  "Data Administration." + STRING(hBufferPolicy::_Audit-policy-name) /* util-name.policy-name */, 
                                  phDbName + ",XML":U /* detail */).

    hXMLWriter:START-ELEMENT("policy-properties", "").
    
    writeXmlData(hBufferPolicy:BUFFER-FIELD('_Audit-policy-description')).
    writeXmlData(hBufferPolicy:BUFFER-FIELD('_Audit-data-security-level')).
    writeXmlData(hBufferPolicy:BUFFER-FIELD('_Audit-custom-detail-level')).
    writeXmlData(hBufferPolicy:BUFFER-FIELD('_Audit-policy-active')).
    
    hXMLWriter:END-ELEMENT("policy-properties", "").
    
    /* open the query for the _aud-file-policy table */
    hQueryFilePolicy:QUERY-PREPARE("FOR EACH ":U + hBufferFilePolicy:NAME 
                                    + " WHERE " + hBufferFilePolicy:NAME + "._Audit-policy-guid = ":U
                                    + QUOTER(hBufferPolicy::_Audit-policy-guid) + " NO-LOCK":U).

    hQueryFilePolicy:QUERY-OPEN.
    hQueryFilePolicy:GET-FIRST().

    /* loop through records in the _aud-file-policy for the current policy */
    DO WHILE NOT hQueryFilePolicy:QUERY-OFF-END:

        hXMLWriter:START-ELEMENT("audit-table", "").

        hXMLWriter:INSERT-ATTRIBUTE("Name", STRING(hBufferFilePolicy::_File-name)).
        hXMLWriter:INSERT-ATTRIBUTE("Owner", STRING(hBufferFilePolicy::_Owner)).
        
        writeXmlData(hBufferFilePolicy:BUFFER-FIELD('_Audit-create-level')).
        writeXmlData(hBufferFilePolicy:BUFFER-FIELD('_Create-event-id')).
        writeXmlData(hBufferFilePolicy:BUFFER-FIELD('_Audit-update-level')).
        writeXmlData(hBufferFilePolicy:BUFFER-FIELD('_Update-event-id')).
        writeXmlData(hBufferFilePolicy:BUFFER-FIELD('_Audit-delete-level')).
        writeXmlData(hBufferFilePolicy:BUFFER-FIELD('_Delete-event-id')).

        /* open the query for the _aud-field-policy table */
        hQueryFieldPolicy:QUERY-PREPARE("FOR EACH ":U + hBufferFieldPolicy:NAME 
                                        + " WHERE " + hBufferFieldPolicy:NAME + "._Audit-policy-guid = " + QUOTER(hBufferPolicy::_Audit-policy-guid)  
                                        + " AND ":U + hBufferFieldPolicy:NAME + "._File-name = ":U + QUOTER(hBufferFilePolicy::_File-Name) + " AND ":U 
                                        + hBufferFieldPolicy:NAME + "._Owner = ":U + QUOTER(hBufferFilePolicy::_Owner) + " NO-LOCK":U).

        hQueryFieldPolicy:QUERY-OPEN.
        hQueryFieldPolicy:GET-FIRST().

        /* loop through records in the _aud-field-policy for the current policy / table combination */
        DO WHILE NOT hQueryFieldPolicy:QUERY-OFF-END:

            hXMLWriter:START-ELEMENT("audit-field", "").
            
            hXMLWriter:INSERT-ATTRIBUTE("Name", STRING(hBufferFieldPolicy::_Field-name)).
            
            writeXmlData(hBufferFieldPolicy:BUFFER-FIELD('_Audit-create-level')).
            writeXmlData(hBufferFieldPolicy:BUFFER-FIELD('_Audit-update-level')).
            writeXmlData(hBufferFieldPolicy:BUFFER-FIELD('_Audit-delete-level')).
            writeXmlData(hBufferFieldPolicy:BUFFER-FIELD('_Audit-identifying-field')).
            
            hXMLWriter:END-ELEMENT("audit-field", "").

            hQueryFieldPolicy:GET-NEXT().
            
        END.

        hXMLWriter:END-ELEMENT("audit-table", "").

        /* close the query on the _aud-field-policy table */
        hQueryFieldPolicy:QUERY-CLOSE.

        hQueryFilePolicy:GET-NEXT().

    END.
    
    /* close the query on the _aud-file-policy table */
    hQueryFilePolicy:QUERY-CLOSE.

    /* open the query for the _aud-event-policy table */
    hQueryEventPolicy:QUERY-PREPARE("FOR EACH ":U + hBufferEventPolicy:NAME 
                                    + " WHERE " + hBufferEventPolicy:NAME + "._Audit-policy-guid = ":U
                                    + QUOTER(hBufferPolicy::_Audit-policy-guid) + " NO-LOCK":U).

    hQueryEventPolicy:QUERY-OPEN.
    hQueryEventPolicy:GET-FIRST().

    /* loop through records in the _aud-event-policy */
    DO WHILE NOT hQueryEventPolicy:QUERY-OFF-END:

        hXMLWriter:START-ELEMENT("audit-event", "").

        hXMLWriter:INSERT-ATTRIBUTE("Event-id", STRING(hBufferEventPolicy::_Event-id)).
        
        writeXmlData(hBufferEventpolicy:BUFFER-FIELD('_Event-level')).
        writeXmlData(hBufferEventPolicy:BUFFER-FIELD('_Event-criteria')).

        hXMLWriter:END-ELEMENT("audit-event", "").

        hQueryEventPolicy:GET-NEXT().
    
    END.

    /* close the query on the _aud-event table */
    hQueryEventPolicy:QUERY-CLOSE.

    /* end of this policy */
    hXMLWriter:END-ELEMENT("Policy", "").

    /* get next policy */
    hQueryPolicy:GET-NEXT().

END. /* for each ttAuditPolicy */

/* close the query on the _aud-event table */
hQueryPolicy:QUERY-CLOSE.

hXMLWriter:END-ELEMENT("Policies", "").

hXMLWriter:END-DOCUMENT().

DELETE OBJECT hXMLWriter NO-ERROR.

{auditing/include/_xmlsec.i
      &INPUT=pxmlFileName
      &mode="gen"
      }

RUN cleanup.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-cleanup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cleanup Procedure 
PROCEDURE cleanup :
/*------------------------------------------------------------------------------
  Purpose:     Delete objects created dynamically
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF VALID-HANDLE (hQueryPolicy) THEN
       DELETE OBJECT hQueryPolicy.

    IF VALID-HANDLE (hQueryFilePolicy) THEN
       DELETE OBJECT hQueryFilePolicy.

    IF VALID-HANDLE (hQueryFieldPolicy) THEN
       DELETE OBJECT hQueryFieldPolicy.

    IF VALID-HANDLE (hQueryEventPolicy) THEN
       DELETE OBJECT hQueryEventPolicy.

    IF VALID-HANDLE (hBufferPolicy) THEN
       DELETE OBJECT hBufferPolicy.
    
    IF VALID-HANDLE (hBufferFilePolicy) THEN
       DELETE OBJECT hBufferFilePolicy.
    
    IF VALID-HANDLE (hBufferFieldPolicy) THEN
       DELETE OBJECT hBufferFieldPolicy.
    
    IF VALID-HANDLE (hBufferEventPolicy) THEN
       DELETE OBJECT hBufferEventPolicy.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-writeXmlData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION writeXmlData Procedure 
FUNCTION writeXmlData RETURNS LOGICAL
  ( hField AS HANDLE /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Writes data elements to the current xml document 
    Notes:  
------------------------------------------------------------------------------*/

  RETURN hXMLWriter:WRITE-DATA-ELEMENT(hField:NAME , TRIM(hField:STRING-VALUE)).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

