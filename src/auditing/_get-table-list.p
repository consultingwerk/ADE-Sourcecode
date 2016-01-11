&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/  
/* Copyright (c) 1984-2005,2008 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : _get-table-list.p
    Purpose     : Stores the list of tables on a given database into a 
                  temp-table which is returned to the caller as an output
                  temp-table. The caller specifies the logical db name.

    Syntax      :

    Description :

    Author(s)   : Fernando de Souza
    Created     : Feb 23,2005
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{auditing/ttdefs/_audfilett.i}

DEFINE INPUT  PARAMETER pcDbName AS CHARACTER.
DEFINE OUTPUT PARAMETER TABLE FOR ttFile.

DEFINE VARIABLE iCnt    AS INTEGER NO-UNDO.
DEFINE VARIABLE hFileTT AS HANDLE  NO-UNDO.

&SCOPED-DEFINE  INVALID_SCHEMA_TABLES "_sec-db-policy,_sec-obj-policy,_sec-pwd-policy":U

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

ASSIGN hFileTT = TEMP-TABLE ttFile:HANDLE.

RUN buildTableList (INPUT pcDbName,
                    INPUT-OUTPUT TABLE-HANDLE hFileTT).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buildTableList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildTableList Procedure 
PROCEDURE buildTableList :
/*------------------------------------------------------------------------------
  Purpose:     Update temp-table with tables for passed in database
  Parameters:  input database name
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER ipDb AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE hFileTT.

DEFINE VARIABLE cTable                      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hQuery                      AS HANDLE       NO-UNDO.
DEFINE VARIABLE hBuffer                     AS HANDLE       NO-UNDO.
DEFINE VARIABLE hBufferTT                   AS HANDLE       NO-UNDO.

    ASSIGN cTable = ipDb + "._File":U
           hBufferTT = hFileTT:DEFAULT-BUFFER-HANDLE.

    CREATE QUERY hQuery.
    CREATE BUFFER hBuffer FOR TABLE cTable NO-ERROR.
    
    IF NOT VALID-HANDLE (hBuffer) THEN
        RETURN.

    hQuery:ADD-BUFFER(hBuffer).
    
    /* only add tables (don't add views) and don't add virtual system tables either,
      which are the tables where file-Number is <= -16385
    */
    hQuery:QUERY-PREPARE('FOR EACH ' + cTable + ' FIELDS(_File-number _File-name _Owner _Tbl-type _Hidden)
                          NO-LOCK WHERE (_file._tbl-type = "T" OR 
                         _file._tbl-type = "S") AND _file._file-number > -16385').
    hQuery:QUERY-OPEN.

    REPEAT:
         IF NOT hQuery:GET-NEXT THEN LEAVE.

         /* don't add auditing data tables to the list */
         IF hBuffer::_File-name = "_aud-audit-data":U OR
            hBuffer::_File-name = "_aud-audit-data-value":U THEN NEXT.

         /* filter these security schema tables out (hidden) */
         IF  hBuffer::_Hidden AND CAN-DO({&INVALID_SCHEMA_TABLES},hBuffer::_File-name) THEN
              NEXT.

         hBufferTT:BUFFER-CREATE().
        
         /* copy the data into the temp-table */
         ASSIGN
             hBufferTT::_db-name = ipDb
             hBufferTT::_File-Name = hBuffer::_File-name
             hBufferTT::_Owner = hBuffer::_Owner
             hBufferTT::_Hidden = hBuffer::_Hidden.
    END.

    hQuery:QUERY-CLOSE.
    DELETE OBJECT hQuery.
    DELETE OBJECT hBuffer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

