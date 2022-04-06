&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    Library     : web2/html-map.i
    Purpose     : Standard include file for HTML Mapping objects. This file 
                  is included in every web/template/html-map.w and runs
                  web2/html-map.p as its super procedure.

    Syntax      :
    Description : 
    Author(s)   : D.M.Adams
    Created     : March, 1998
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.                */
/*------------------------------------------------------------------------*/

/* **************************** Shared Definitions ***************************/
&IF "{&ADMClass}":U = "":U &THEN
  &GLOBAL-DEFINE ADMClass html-map
&ENDIF

{src/web/method/cgidefs.i} 

DEFINE STREAM instream.     /* html input file */

DEFINE VARIABLE cBase                AS CHARACTER NO-UNDO. 
DEFINE VARIABLE cDisplayedDataFields AS CHARACTER NO-UNDO. 
DEFINE VARIABLE cEnabledDataFields   AS CHARACTER NO-UNDO. 
DEFINE VARIABLE cEntry               AS CHARACTER NO-UNDO. 
DEFINE VARIABLE cTable               AS CHARACTER NO-UNDO. 
DEFINE VARIABLE gcDataSource         AS CHARACTER NO-UNDO. /* Data Object file */
DEFINE VARIABLE gcDisplayedTables    AS CHARACTER NO-UNDO. /* Names and handles */
DEFINE VARIABLE gcEnabledTables      AS CHARACTER NO-UNDO. /* Names and handles */
DEFINE VARIABLE iCol                 AS INTEGER   NO-UNDO. /* */
DEFINE VARIABLE cProp                AS CHARACTER NO-UNDO. /* */
DEFINE VARIABLE hFrame               AS HANDLE    NO-UNDO. /* */

&IF "{&ADMClass}":U = "html-map":U &THEN
  {src/web2/htmlprop.i}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 14.95
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

{src/web2/admweb.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


RUN start-super-proc("web2/html-map.p":U).

ASSIGN SESSION:APPL-ALERT-BOXES = TRUE.

/* Find Data Object file.(9.1 uses adm-create-objects but this 
  is kept for backwards comptibility) */

&IF DEFINED(DATA-FIELD-DEFS) <> 0 &THEN
  ASSIGN cBase = SUBSTRING(TRIM('{&DATA-FIELD-DEFS}', '"'), 1,
                 R-INDEX(TRIM('{&DATA-FIELD-DEFS}' , '"'), ".":U) - 1, "CHARACTER":U).
  gcDataSource = SEARCH(cBase + ".r":U).
  IF gcDataSource = ? THEN DO:
    gcDataSource = SEARCH(cBase + ".w":U).
    IF gcDataSource = ? THEN DO:
        gcDataSource = SEARCH(cBase + ".p":U).
        IF gcDataSource = ? THEN gcDataSource = "".
    END.      
  END.
  {set DataSourceFile gcDataSource}.
&ENDIF

/* Build a list of displayed SDO fields without the table prefix */
DO iCol = 1 TO NUM-ENTRIES("{&DISPLAYED-FIELDS}":U, " ":U):
  ASSIGN
    cEntry     = ENTRY(iCol, "{&DISPLAYED-FIELDS}":U, " ":U)
    cTable     = ENTRY(1,cEntry,".":U).
  IF cTable eq "RowObject":U THEN
    cDisplayedDataFields = cDisplayedDataFields +
      (IF cDisplayedDataFields NE "":U THEN ",":U ELSE "":U) +
         SUBSTRING(cEntry, R-INDEX(cEntry, ".":U) + 1).  
 
  {set DisplayedDataFields cDisplayedDataFields}.
 
END.

/* Build a list of enabled SDO fields without the table prefix */
DO iCol = 1 TO NUM-ENTRIES("{&ENABLED-FIELDS}":U, " ":U):
  ASSIGN
    cEntry   = ENTRY(iCol, "{&ENABLED-FIELDS}":U, " ":U)
    cTable     = ENTRY(1,cEntry,".":U).
  IF cTable eq "RowObject":U THEN
    cEnabledDataFields = cEnabledDataFields + 
      (IF cEnabledDataFields NE "":U THEN ",":U ELSE "":U) +
         SUBSTRING(cEntry, R-INDEX(cEntry, ".":U) + 1).  

  {set EnabledDataFields cEnabledDataFields}.

END.

&IF DEFINED(FIRST-DISPLAYED-TABLE) &THEN
  gcDisplayedTables = "{&FIRST-DISPLAYED-TABLE},":U +
                      STRING(BUFFER {&FIRST-DISPLAYED-TABLE}:HANDLE).
&ENDIF
&IF DEFINED(SECOND-DISPLAYED-TABLE) &THEN
  gcDisplayedTables = gcDisplayedTables + ",{&SECOND-DISPLAYED-TABLE},":U +
                      STRING(BUFFER {&SECOND-DISPLAYED-TABLE}:HANDLE).
&ENDIF
&IF DEFINED(THIRD-DISPLAYED-TABLE) &THEN
  gcDisplayedTables = gcDisplayedTables + ",{&THIRD-DISPLAYED-TABLE},":U +
                      STRING(BUFFER {&THIRD-DISPLAYED-TABLE}:HANDLE).
&ENDIF
&IF DEFINED(FOURTH-DISPLAYED-TABLE) &THEN
  gcDisplayedTables = gcDisplayedTables + ",{&FOURTH-DISPLAYED-TABLE},":U +
                      STRING(BUFFER {&FOURTH-DISPLAYED-TABLE}:HANDLE).
&ENDIF
&IF DEFINED(FIFTH-DISPLAYED-TABLE) &THEN
  gcDisplayedTables = gcDisplayedTables + ",{&FIFTH-DISPLAYED-TABLE},":U +
                      STRING(BUFFER {&FIFTH-DISPLAYED-TABLE}:HANDLE).
&ENDIF
&IF DEFINED(SIXTH-DISPLAYED-TABLE) &THEN
  gcDisplayedTables = gcDisplayedTables + "{&SIXTH-DISPLAYED-TABLE},":U +
                      STRING(BUFFER {&SIXTH-DISPLAYED-TABLE}:HANDLE).
&ENDIF
&IF DEFINED(SEVENTH-DISPLAYED-TABLE) &THEN
  gcDisplayedTables = gcDisplayedTables + ",{&SEVENTH-DISPLAYED-TABLE},":U +
                      STRING(BUFFER {&SEVENTH-DISPLAYED-TABLE}:HANDLE).
&ENDIF
&IF DEFINED(EIGHTH-DISPLAYED-TABLE) &THEN
  gcDisplayedTables = gcDisplayedTables + ",{&EIGHTH-DISPLAYED-TABLE},":U +
                      STRING(BUFFER {&EIGHTH-DISPLAYED-TABLE}:HANDLE).
&ENDIF
&IF DEFINED(NINTH-DISPLAYED-TABLE) &THEN
  gcDisplayedTables = gcDisplayedTables + ",{&NINTH-DISPLAYED-TABLE},":U +
                      STRING(BUFFER {&NINTH-DISPLAYED-TABLE}:HANDLE).
&ENDIF
&IF DEFINED(TENTH-DISPLAYED-TABLE) &THEN
  gcDisplayedTables = gcDisplayedTables + ",{&TENTH-DISPLAYED-TABLE},":U +
                      STRING(BUFFER {&TENTH-DISPLAYED-TABLE}:HANDLE).
&ENDIF

/* The ab_unmap field is not in the preprosessor */
&IF INDEX('{&DISPLAYED-OBJECTS}','ab_unmap') > 0 &THEN
/* Build comma-separated list of displayed tables and their handles */
  gcDisplayedTables = gcDisplayedTables 
                      + (IF gcDisplayedTables = "":U THEN "":U ELSE ",":U)
                      + "ab_unmap,":U 
                      + STRING(BUFFER ab_unmap:HANDLE).
  FIND FIRST ab_unmap NO-ERROR.
  IF NOT AVAIL ab_unmap THEN
    CREATE ab_unmap. 
&ENDIF

/* Build comma-separated list of enabled tables and their handles */
&IF DEFINED(FIRST-ENABLED-TABLE) &THEN
  gcEnabledTables = "{&FIRST-ENABLED-TABLE},":U +
                     STRING(BUFFER {&FIRST-ENABLED-TABLE}:HANDLE).
&ENDIF
&IF DEFINED(SECOND-ENABLED-TABLE) &THEN
  gcEnabledTables = gcEnabledTables + ",{&SECOND-ENABLED-TABLE},":U +
                     STRING(BUFFER {&SECOND-ENABLED-TABLE}:HANDLE).
&ENDIF
&IF DEFINED(THIRD-ENABLED-TABLE) &THEN
  gcEnabledTables = gcEnabledTables + ",{&THIRD-ENABLED-TABLE},":U +
                     STRING(BUFFER {&THIRD-ENABLED-TABLE}:HANDLE).
&ENDIF
&IF DEFINED(FOURTH-ENABLED-TABLE) &THEN
  gcEnabledTables = gcEnabledTables + ",{&FOURTH-ENABLED-TABLE},":U +
                     STRING(BUFFER {&FOURTH-ENABLED-TABLE}:HANDLE).
&ENDIF
&IF DEFINED(FIFTH-ENABLED-TABLE) &THEN
  gcEnabledTables = gcEnabledTables + ",{&FIFTH-ENABLED-TABLE},":U +
                     STRING(BUFFER {&FIFTH-ENABLED-TABLE}:HANDLE).
&ENDIF
&IF DEFINED(SIXTH-ENABLED-TABLE) &THEN
  gcEnabledTables = gcEnabledTables + "{&SIXTH-ENABLED-TABLE},":U +
                     STRING(BUFFER {&SIXTH-ENABLED-TABLE}:HANDLE).
&ENDIF
&IF DEFINED(SEVENTH-ENABLED-TABLE) &THEN
  gcEnabledTables = gcEnabledTables + ",{&SEVENTH-ENABLED-TABLE},":U +
                     STRING(BUFFER {&SEVENTH-ENABLED-TABLE}:HANDLE).
&ENDIF
&IF DEFINED(EIGHTH-ENABLED-TABLE) &THEN
  gcEnabledTables = gcEnabledTables + ",{&EIGHTH-ENABLED-TABLE},":U +
                     STRING(BUFFER {&EIGHTH-ENABLED-TABLE}:HANDLE).
&ENDIF
&IF DEFINED(NINTH-ENABLED-TABLE) &THEN
  gcEnabledTables = gcEnabledTables + ",{&NINTH-ENABLED-TABLE},":U +
                     STRING(BUFFER {&NINTH-ENABLED-TABLE}:HANDLE).
&ENDIF
&IF DEFINED(TENTH-ENABLED-TABLE) &THEN
  gcEnabledTables = gcEnabledTables + ",{&TENTH-ENABLED-TABLE},":U +
                     STRING(BUFFER {&TENTH-ENABLED-TABLE}:HANDLE).
&ENDIF

/* The ab_unmap field is not in the preprosessor */
&IF (INDEX('{&ENABLED-OBJECTS}','ab_unmap') <> 0) &THEN
/* Build comma-separated list of displayed tables and their handles */
  gcEnabledTables = gcEnabledTables 
                    + (IF gcEnabledTables = "":U THEN "":U ELSE ",":U)
                    + "ab_unmap,":U 
                    + STRING(BUFFER ab_unmap:HANDLE).
  FIND FIRST ab_unmap NO-ERROR.
  IF NOT AVAIL ab_unmap THEN
    CREATE ab_unmap. 
&ENDIF

 

{set DisplayedTables gcDisplayedTables}.
{set EnabledTables   gcEnabledTables}.
cProp = '{&WEB-FILE}':U.
{set WebFile cProp}.
{set ContainerName '{&FRAME-NAME}':U}.
{set QueryName '{&Query-NAME}':U}.

cProp = '{&TABLES-IN-QUERY-{&QUERY-NAME}}':U.
{set QueryTables cProp}.  
cProp =  REPLACE('{&DISPLAYED-FIELDS}':U," ":U,",":U).
{set DisplayedFields  cProp}.
cProp =  REPLACE('{&DISPLAYED-OBJECTS}':U," ":U,",":U).
{set DisplayedObjects cProp}.
cProp =  REPLACE('{&ENABLED-FIELDS}':U," ":U,",":U).
{set EnabledFields cProp}.
cProp =  REPLACE('{&ENABLED-OBJECTS}':U," ":U,",":U).
{set EnabledObjects cProp}.
hFrame = FRAME {&FRAME-NAME}:HANDLE.
{set FrameHandle hFrame}.

/* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
{src/web2/custom/html-mapcustom.i}
/* _ADM-CODE-BLOCK-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


