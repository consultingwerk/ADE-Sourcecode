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
    File        : _get-field-list.p
    Purpose     : Stores the list of fields on a given table/database into a 
                  temp-table which is returned to the caller as an output
                  temp-table. The caller specifies the table name which is
                  then searched in all connected databases.


    Syntax      :

    Description :

    Author(s)   : Fernando de Souza
    Created     : Feb 23,2005
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

{auditing/ttdefs/_audfieldtt.i}

/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER pcTableInfo AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttField.
    
DEFINE VARIABLE iCnt     AS INTEGER NO-UNDO.
DEFINE VARIABLE hFieldTT AS HANDLE  NO-UNDO.

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

ASSIGN hFieldTT = TEMP-TABLE ttField:HANDLE.

/* build temp-table with tables from connected dbs */
DO iCnt = 1 to NUM-DBS:
    RUN buildFieldList (LDBNAME(iCnt)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buildFieldList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildFieldList Procedure 
PROCEDURE buildFieldList :
/*------------------------------------------------------------------------------
  Purpose:     Update temp-table with tables/fields from database passed in
               cDbName
  Parameters:  input database name
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER cDbName AS CHARACTER.

DEFINE VARIABLE cTable            AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cFields           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hQuery            AS HANDLE       NO-UNDO.
DEFINE VARIABLE hBufferFile       AS HANDLE       NO-UNDO.
DEFINE VARIABLE hBufferField      AS HANDLE       NO-UNDO.
DEFINE VARIABLE hBufferTT         AS HANDLE       NO-UNDO.
DEFINE VARIABLE iFound            AS LOGICAL      NO-UNDO.
DEFINE VARIABLE icheckDup         AS LOGICAL      NO-UNDO INIT NO.
DEFINE VARIABLE currTable         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE ctemp             AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cTableNameToFind  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTableOwnerToFind AS CHARACTER NO-UNDO.

    ASSIGN cTable = cDbName + "._File":U
           cFields = cDbName + "._Field":U
           hBufferTT = hFieldTT:DEFAULT-BUFFER-HANDLE
           cTableNameToFind = ENTRY(1,pcTableInfo)
           cTableOwnerToFind = ENTRY(2,pcTableInfo).

    CREATE QUERY hQuery.
    CREATE BUFFER hBufferFile FOR TABLE cTable. 
    CREATE BUFFER hBufferField FOR TABLE cFields. 
    hQuery:ADD-BUFFER(hBufferFile).
    hQuery:ADD-BUFFER(hBufferField).

    /* only consider tables (not views) and don't bother with virtual system tables 
    */
    hQuery:QUERY-PREPARE('FOR EACH ':U + cTable + ' FIELDS(_file-number _file-name _tbl-type _Owner) NO-LOCK':U
                         + ' WHERE (_file._tbl-type = "T" OR _file._tbl-type = "S") AND ':U
                         + ' _file._file-number > -16385 AND _File-name = ':U + QUOTER(cTableNameToFind)
                         + ' AND _Owner = ':U + QUOTER(cTableOwnerToFind) + ', EACH ':U + cFields 
                         + ' FIELDS(_field-name _Desc) OF ':U + cTable + ' NO-LOCK':U).
    hQuery:QUERY-OPEN.

    REPEAT:
        IF NOT hQuery:GET-NEXT THEN LEAVE.

        /* keep track of the current table+owner combination we are working on */
        ASSIGN ctemp = hBufferFile::_File-name + "," + hBufferFile::_Owner.

        IF currtable <> ctemp THEN DO:

            /* this is the first occurance of this table. Check if it already exists, and don't bother
               adding fields from this table
            */
            ASSIGN iFound = hBufferTT:FIND-FIRST("where _File-name = '":U + hBufferFile::_File-name + "' AND
                                 _Owner = '":U + hBufferFile::_Owner + "'") NO-ERROR .
    
            IF (iFound) THEN NEXT.
            /* this must be a new table, so reassign currtable so we add its fields */
            ASSIGN currtable = ctemp.
        END.

        hBufferTT:BUFFER-CREATE().

        /* copy the data into the temp-table */
        ASSIGN
            hBufferTT::_File-name = hBufferFile::_File-name
            hBufferTT::_Owner = hBufferFile::_Owner
            hBufferTT::_Field-name = hBufferField::_Field-name
            hBufferTT::_Desc = hBufferField::_Desc.
    END.

    hQuery:QUERY-CLOSE.
    DELETE OBJECT hQuery.
    DELETE OBJECT hBufferFile.
    DELETE OBJECT hBufferField.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

