&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    Library     : browser.i
    Purpose     : Basic SmartDataBrowser methods for the ADM

    Syntax      : {src/adm2/browser.i}

    Modified    : July 14, 2000 Version 9.1B
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF "{&ADMClass}":U = "":U &THEN
  &GLOB ADMClass browser
&ENDIF
         
/* Make sure that the template compiles successfully by itself 
   (Internal-Tables will be undefined). */
&IF DEFINED(INTERNAL-TABLES) EQ 0 &THEN
  &SCOP EXCLUDE-getRowObject YES
&ENDIF

  /* These are no longer used, but kept for backwards compatibility 
     as typically datAvailable  overrides would use them */
  DEFINE VARIABLE glReposition AS LOGICAL   INIT ?.
  DEFINE VARIABLE cLastEvent   AS CHARACTER.

&IF "{&ADMClass}":U = "browser":U &THEN
  {src/adm2/brsprop.i}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowObject Method-Library 
FUNCTION getRowObject RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 11.1
         WIDTH              = 55.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

  {src/adm2/datavis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

  DEFINE VARIABLE cViewCols     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEnabled      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iCol          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iEntries      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cEntry        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBaseQuery    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hQuery        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cColumns      AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE iTable        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hBuffer       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hColumn       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lResult       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cStripDisp    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStripEnable  AS CHARACTER  NO-UNDO.

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-LOAD-FROM-REPOSITORY} THEN
DO:
  RUN start-super-proc("adm2/browser.p":U).  
  /* prepareEntityFields take care of this if load from repos */ 
  {set BrowseHandle "BROWSE {&BROWSE-NAME}:HANDLE"}.

  /* Subscribe to FilterActive when data links are established. This is used 
    to display filter tick, etc. when a filter is active. */
  RUN modifyListProperty(THIS-PROCEDURE, "ADD":U, 
                      "DataSourceEvents":U,"FilterActive":U).

  /* Subscribe to refreshBrowse. This is published from data sources */
  RUN modifyListProperty(THIS-PROCEDURE, "ADD":U, 
                      "DataSourceEvents":U,"RefreshBrowse":U).

  /* Subscribe to cancelNew. This is published from data sources
     on cancelRow for a new record  */
  RUN modifyListProperty(THIS-PROCEDURE, "ADD":U, 
                      "DataSourceEvents":U,"CancelNew":U).
END.
&ENDIF

ON VALUE-CHANGED OF BROWSE {&BROWSE-NAME} ANYWHERE
  RUN valueChanged IN TARGET-PROCEDURE.

ON 'U10':U OF THIS-PROCEDURE
  RUN valueChanged IN TARGET-PROCEDURE.

/* Exclude DisplayFieldsStatic unless there is a local calculated field 
   (expression) @ localvar.
   Use a static display for these as the expression is difficult to evaluate 
   dynamically. Even a browse:refresh does not work until row-leave has fired, 
   so a save without a leave in an updatable browse would not refresh 
   calculations */
    &IF INDEX("{&FIELDS-IN-QUERY-{&BROWSE-NAME}}":U,"@":U) = 0 &THEN
 &SCOPED-DEFINE EXCLUDE-DisplayFieldsStatic   
    &ENDIF  
     /* this function is not in use, but is kept for backwards compatibility
        in sdb that defines the rowobject include (Dataview SDBs don't )*/
    &IF DEFINED(DATA-FIELD-DEFS) = 0 &THEN
 &SCOPED-DEFINE EXCLUDE-getRowObject   
    &ENDIF  

/* Compile this only is for a static browse */
&IF "{&FIELDS-IN-QUERY-{&BROWSE-NAME}}":U <> "":U &THEN 
    
  cStripDisp = DYNAMIC-FUNCTION("stripCalcs":U, "{&FIELDS-IN-QUERY-{&BROWSE-NAME}}":U).
  iEntries = NUM-ENTRIES(cStripDisp, " ":U).
  DO iCol = 1 TO iEntries:
    ASSIGN
      cEntry    = ENTRY(iCol, cStripDisp, " ":U)
      cViewCols = cViewCols
                + (IF cViewCols NE "":U THEN ",":U ELSE "":U) 
                + (IF cEntry BEGINS 'RowObject.':U
                   THEN ENTRY(2,cEntry,'.':U)
                   ELSE cEntry ).  
  END.
  cStripEnable = DYNAMIC-FUNCTION("stripCalcs":U, "{&ENABLED-FIELDS-IN-QUERY-{&BROWSE-NAME}}":U).
  iEntries = NUM-ENTRIES(cStripEnable, " ":U).
  DO iCol = 1 TO iEntries:
    ASSIGN 
      cEntry   = ENTRY(iCol, cStripEnable, " ":U)
      cEnabled = cEnabled 
               + (IF cEnabled NE "":U THEN ",":U ELSE "":U) 
               + (IF cEntry BEGINS 'RowObject.':U
                  THEN ENTRY(2,cEntry,'.':U)
                  ELSE cEntry).  
  END.
  
  {set DisplayedFields cViewCols}.
  {set EnabledFields cEnabled}.

 /* If there are any enabled fields, set the enabled prop to yes. 
    This is necessary because disableFields and enableFields and also logic 
    that runs these methods are depending of the properties matching 
    the objects true state and the browser is enabled as default from the
    4GL definition. */
  IF cEnabled NE "":U THEN
    {set FieldsEnabled yes}.
&ENDIF

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
  {src/adm2/custom/browsercustom.i}
  /* _ADM-CODE-BLOCK-END */
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-displayFieldsStatic) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFieldsStatic Method-Library 
PROCEDURE displayFieldsStatic :
/*------------------------------------------------------------------------------
  Purpose: Static Display statement compiled for refresh of locally calculated 
           columns.  
  Parameters:  <none>
  Notes:   This is conditionally compiled ONLY if there is a local calculated 
           field in the field list.
         - It creates a temporary rowobject/temp-table record and assigns all 
           values to be able to display them using the generated static 
           {&fields-in-} list, which also has the 
             (<calc expression>) @ <some variable>.     
         - It is called from browser.p DisplayFields if a '<calc>' entry is 
           found in DisplayedFields.      
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER pcColValues AS CHARACTER  NO-UNDO.
   
   DEFINE VARIABLE iValue        AS INTEGER    NO-UNDO.
   DEFINE VARIABLE hField        AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hFrameField   AS HANDLE     NO-UNDO.
   DEFINE VARIABLE cFields       AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cFieldHandles AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cField        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hDataTable    AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hDataSource   AS HANDLE     NO-UNDO.
   DEFINE VARIABLE cTable        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hBuffer       AS HANDLE     NO-UNDO EXTENT 18.
   DEFINE VARIABLE rRowid        AS ROWID      NO-UNDO EXTENT 18.
   DEFINE VARIABLE iTable        AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cTableList    AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hUseBuffer    AS HANDLE     NO-UNDO.
   DEFINE VARIABLE iNumTables    AS INTEGER    NO-UNDO.

   /* No need if no record (pcColvalues = ?) or no focus (will give error) */ 
   IF pcColValues <> ? AND BROWSE {&BROWSE-NAME}:FOCUSED-ROW <> ? THEN
   DO:
     {get FieldHandles cFieldHandles}.
     {get DisplayedFields cFields}.
     ASSIGN
     &IF DEFINED(FIRST-table-in-query-{&Browse-name}) <> 0 &THEN
        hBuffer[1] = BUFFER {&FIRST-table-in-query-{&Browse-name}}:HANDLE
        iNumTables = iNumTables + 1
     &ENDIF
     &IF DEFINED(SECOND-table-in-query-{&Browse-name}) <> 0 &THEN
        hBuffer[2] = BUFFER {&SECOND-table-in-query-{&Browse-name}}:HANDLE
        iNumTables = iNumTables + 1
     &ENDIF
     &IF DEFINED(THIRD-table-in-query-{&Browse-name}) <> 0 &THEN
        hBuffer[3] = BUFFER {&THIRD-table-in-query-{&Browse-name}}:HANDLE
        iNumTables = iNumTables + 1
     &ENDIF
     &IF DEFINED(FOURTH-table-in-query-{&Browse-name}) <> 0 &THEN
        hBuffer[4] = BUFFER {&FOURTH-table-in-query-{&Browse-name}}:HANDLE
        iNumTables = iNumTables + 1
     &ENDIF
     &IF DEFINED(FIFTH-table-in-query-{&Browse-name}) <> 0 &THEN
        hBuffer[5] = BUFFER {&FIFTH-table-in-query-{&Browse-name}}:HANDLE
        iNumTables = iNumTables + 1
     &ENDIF
     &IF DEFINED(SIXTH-table-in-query-{&Browse-name}) <> 0 &THEN
        hBuffer[6] = BUFFER {&SIXTH-table-in-query-{&Browse-name}}:HANDLE
        iNumTables = iNumTables + 1
     &ENDIF
     &IF DEFINED(SEVENTH-table-in-query-{&Browse-name}) <> 0 &THEN
        hBuffer[7] = BUFFER {&SEVENTH-table-in-query-{&Browse-name}}:HANDLE
        iNumTables = iNumTables + 1
     &ENDIF
     &IF DEFINED(EIGHT-table-in-query-{&Browse-name}) <> 0 &THEN
        hBuffer[8] = BUFFER {&EIGHT-table-in-query-{&Browse-name}}:HANDLE
        iNumTables = iNumTables + 1
     &ENDIF
     &IF DEFINED(NINTH-table-in-query-{&Browse-name}) <> 0 &THEN
        hBuffer[9] = BUFFER {&NINTH-table-in-query-{&Browse-name}}:HANDLE
        iNumTables = iNumTables + 1
     &ENDIF
     &IF DEFINED(TENTH-table-in-query-{&Browse-name}) <> 0 &THEN
        hBuffer[10] = BUFFER {&TENTH-table-in-query-{&Browse-name}}:HANDLE
        iNumTables = iNumTables + 1
     &ENDIF
     &IF DEFINED(ELEVENTH-table-in-query-{&Browse-name}) <> 0 &THEN
        hBuffer[11] = BUFFER {&ELEVENTH-table-in-query-{&Browse-name}}:HANDLE
        iNumTables = iNumTables + 1
     &ENDIF
     &IF DEFINED(TWELFTH-table-in-query-{&Browse-name}) <> 0 &THEN
        hBuffer[12] = BUFFER {&TWELFTH-table-in-query-{&Browse-name}}:HANDLE
        iNumTables = iNumTables + 1
     &ENDIF
     &IF DEFINED(THIRTEENTH-table-in-query-{&Browse-name}) <> 0 &THEN
        hBuffer[13] = BUFFER {&THIRTEENTH-table-in-query-{&Browse-name}}:HANDLE
        iNumTables = iNumTables + 1
     &ENDIF
     &IF DEFINED(FOURTEENTH-table-in-query-{&Browse-name}) <> 0 &THEN
        hBuffer[14] = BUFFER {&FOURTEENTH-table-in-query-{&Browse-name}}:HANDLE
        iNumTables = iNumTables + 1
     &ENDIF
     &IF DEFINED(FIFTEENTH-table-in-query-{&Browse-name}) <> 0 &THEN
        hBuffer[15] = BUFFER {&FIFTEENTH-table-in-query-{&Browse-name}}:HANDLE
        iNumTables = iNumTables + 1
     &ENDIF
     &IF DEFINED(SIXTEENTH-table-in-query-{&Browse-name}) <> 0 &THEN
        hBuffer[16] = BUFFER {&SIXTEENTH-table-in-query-{&Browse-name}}:HANDLE
        iNumTables = iNumTables + 1
     &ENDIF
     &IF DEFINED(SEVENTEENTH-table-in-query-{&Browse-name}) <> 0 &THEN
        hBuffer[17] = BUFFER {&SEVENTEENTH-table-in-query-{&Browse-name}}:HANDLE
        iNumTables = iNumTables + 1
     &ENDIF
     &IF DEFINED(EIGHTEENTH-table-in-query-{&Browse-name}) <> 0 &THEN
        hBuffer[18] = BUFFER {&EIGHTEENTH-table-in-query-{&Browse-name}}:HANDLE
        iNumTables = iNumTables + 1
     &ENDIF
     .

     /* initiate create a temporary tt record for each potential table */
     DO iTable = 1 TO iNumTables:
       IF VALID-HANDLE(hBuffer[iTable]) THEN
       DO:
         /* only create if in list of fields (always create the first
            used for unqualifed lists) */
         IF iTable = 1 
         OR INDEX("," + cFields,"," + hBuffer[iTable]:NAME + '.') > 0 THEN
         DO:
           /* There should never be a RowObject record here, but just in case...
              lets keep track of it and reposition to it after */ 
           IF hBuffer[iTable]:AVAIL THEN
             rRowid[iTable] = hBuffer[iTable]:ROWID.
         
           hBuffer[iTable]:BUFFER-CREATE.
         END.
         /* ordinal list used to find array number from name */
         cTableList = cTableList 
                    + (IF iTable = 1 THEN '' ELSE ',')
                    + hBuffer[iTable]:NAME.
       END.
     END.  /* do itable = 1 to iNumTables */

     DO iValue = 2 TO NUM-ENTRIES(pcColValues,CHR(1)):
       cField = ENTRY(iValue - 1,cFields).
       IF NUM-ENTRIES(cField,'.') > 1 THEN
       DO:
         ASSIGN
           cTable     = ENTRY(1,cField,'.':U) 
           cField     = ENTRY(2,cField,'.':U) 
           hUSEBuffer = hBuffer[LOOKUP(cTable,cTableList)].
       END.
       ELSE 
         hUseBuffer = hBuffer[1].

       IF cField <> '<Calc>':U THEN
       DO:
         ASSIGN 
           hFrameField = WIDGET-HANDLE(ENTRY(iValue - 1,cFieldHandles))
           hField = hUseBuffer:BUFFER-FIELD(cField)
           hField:BUFFER-VALUE = IF pcColValues NE ? 
                                 THEN RIGHT-TRIM(ENTRY(iValue, pcColValues, CHR(1)))
                                 ELSE IF hField:DATA-TYPE NE "LOGICAL":U 
                                 THEN "":U
                                 ELSE ?.
       END.
     END.
     DISPLAY {&FIELDS-IN-QUERY-{&BROWSE-NAME}} WITH BROWSE {&BROWSE-NAME}.
     
     /* deelte temporary tt records and repos if necessary */
     DO iTable = 1 TO iNumTables:
       IF VALID-HANDLE(hBuffer[iTable]) THEN
       DO:
         hBuffer[iTable]:BUFFER-DELETE.
         IF rRowid[iTable] <> ? THEN
           hBuffer[iTable]:FIND-BY-ROWID(rRowid[iTable]) NO-ERROR.
       END.
     END.  /* do itable = 1 to inumtables */
   END. /* pcColValues <> ? */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowObject Method-Library 
FUNCTION getRowObject RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle to the Browser's temp-table definition.
    Notes:  Allow to examine the temp-table definition,
            the temp-table is not normally used at runtime.
            Used internally.
------------------------------------------------------------------------------*/

  RETURN BUFFER RowObject:HANDLE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

