&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gscemrddbp.p

  Description:  Entity Mnemonic Import DB Read Procedure

  Purpose:      Procedure to get the list of connected database and invokes a procedure to
                get the tables for those databases.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000020   UserRef:    posse
                Date:   23/04/2001  Author:     Tammy St Pierre

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gscemrddbp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{afglobals.i}

DEFINE TEMP-TABLE ttTable           NO-UNDO
    FIELD cDatabase      AS CHARACTER
    FIELD cTable         AS CHARACTER
    FIELD cDumpName      AS CHARACTER
    FIELD cDescription   AS CHARACTER
    FIELD lImport        AS LOGICAL
    .
DEFINE INPUT  PARAMETER plDisplayRepository         AS LOGICAL          NO-UNDO.
DEFINE OUTPUT PARAMETER pcDBList                    AS CHARACTER        NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttTable.

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
         HEIGHT             = 6.81
         WIDTH              = 63.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE cLogicalName    AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cSchemaName     AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cTableName      AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cFileName       AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cWhere          AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE iDb             AS INTEGER                          NO-UNDO.
DEFINE VARIABLE hQuery          AS HANDLE                           NO-UNDO.
DEFINE VARIABLE hDbBuffer       AS HANDLE                           NO-UNDO.
DEFINE VARIABLE hFileBuffer     AS HANDLE                           NO-UNDO.
DEFINE VARIABLE hFieldDesc      AS HANDLE                           NO-UNDO.
DEFINE VARIABLE hFieldFileName  AS HANDLE                           NO-UNDO.
DEFINE VARIABLE hFieldDumpName  AS HANDLE                           NO-UNDO.
DEFINE VARIABLE hObjApi         AS HANDLE                           NO-UNDO.

EMPTY TEMP-TABLE ttTable.

/* Databases */
DO iDb = 1 TO NUM-DBS:
    ASSIGN cLogicalName = LDBNAME(iDb).

/*     /* Ignore DataServer DB's for the time being.     */
/*      * The code caters for DataServers, though.   */  */
/*     IF DBTYPE(cLogicalName) <> "PROGRESS":U THEN      */
/*         NEXT.                                         */
    
    /* Skip Repository DBs unless explicitly specified. */
    IF NOT plDisplayRepository AND
       ( cLogicalName EQ "ICFDB":U   OR
         cLogicalName EQ "RTB":U     OR
         cLogicalName EQ "RVDB":U    OR
         cLogicalName EQ "TEMP-DB":U    ) THEN
        NEXT.

    ASSIGN pcDBList    = pcDBList + (IF NUM-ENTRIES(pcDBList) EQ 0 THEN "":U ELSE ",":U) + cLogicalName
           cSchemaName = SDBNAME(cLogicalName)
           .
    
    IF cSchemaName EQ cLogicalName THEN
        ASSIGN cTableName = cLogicalName + "._Db":U
               cFileName  = cLogicalName + "._File":U
               cWhere     = "FOR EACH ":U + cTableName + " NO-LOCK, ":U
                          + " EACH " + cFileName + " WHERE ":U
                          +  cFileName + "._Db-recid = RECID(_Db) AND ":U
                          +  (IF DBVERSION(cLogicalName) <> '8'
                              THEN cFileName + "._Owner    = 'Pub'      AND ":U
                              ELSE '')
                          +  cFileName + "._Hidden   = FALSE ":U
                          + " NO-LOCK ":U.
    ELSE
        ASSIGN cTableName = cSchemaName + "._Db":U                                      
               cFileName  = cSchemaName + "._File":U                   
               cWhere     = " FOR EACH ":U + cTableName + " WHERE ":U
                          +   cTableName + "._Db-Name = '" + cLogicalName + "' ":U
                          + " NO-LOCK, ":U
                          + " EACH " + cFileName + " WHERE ":U
                          +  cFileName + "._Db-recid = RECID(_Db) AND ":U
                          +  cFileName + "._Owner    = '_Foreign' AND ":U
                          +  cFileName + "._Hidden   = FALSE ":U
                          + " NO-LOCK ":U.

    CREATE BUFFER hDbBuffer         FOR TABLE cTableName.
    CREATE BUFFER hFileBuffer       FOR TABLE cFileName.
    CREATE QUERY hQuery.

    ASSIGN hFieldDesc      = hFileBuffer:BUFFER-FIELD("_Desc":U)
           hFieldFileName  = hFileBuffer:BUFFER-FIELD("_File-name":U)
           hFieldDumpName  = hFileBuffer:BUFFER-FIELD("_Dump-name":U)
           .
    hQuery:SET-BUFFERS(hDbBuffer, hFileBuffer).
    hQuery:QUERY-PREPARE(cWhere).
    hQuery:QUERY-OPEN().

    hQuery:GET-FIRST(NO-LOCK).

    DO WHILE hDbBuffer:AVAILABLE:
        CREATE ttTable.
        ASSIGN ttTable.cDatabase    = cLogicalName
               ttTable.cTable       = hFieldFileName:BUFFER-VALUE
               ttTable.cDescription = hFieldDesc:BUFFER-VALUE
               ttTable.cDumpName    = hFieldDumpName:BUFFER-VALUE
               .
        hQuery:GET-NEXT(NO-LOCK).
    END.    /* avail db buffer */

    hQuery:QUERY-CLOSE().

    DELETE OBJECT hQuery NO-ERROR.
    ASSIGN hQuery = ?.

    DELETE OBJECT hDbBuffer NO-ERROR.
    ASSIGN hDbBuffer = ?.

    DELETE OBJECT hFileBuffer NO-ERROR.
    ASSIGN hFileBuffer = ?.
END.  /* do iDb */

RETURN.
/** -- EOF -- **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


