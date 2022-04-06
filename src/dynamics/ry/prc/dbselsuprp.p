&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
/*---------------------------------------------------------------------------------
  File: dbselsuprp.p

  Description:  Super for dbselviewv, db filter viewer

  Purpose:      Super for dbselviewv, db filter viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   02/03/2003  Author:     

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       dbselsuprp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

DEFINE VARIABLE ghComboHandle   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghContainer     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSDO           AS HANDLE     NO-UNDO.

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
         HEIGHT             = 3.38
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buRefreshChoose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buRefreshChoose Procedure 
PROCEDURE buRefreshChoose :
/*------------------------------------------------------------------------------
  Purpose:     Update the SDO with the new filter information, and then refresh
               the browser.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cField AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWhere AS CHARACTER  NO-UNDO.

IF NOT VALID-HANDLE(ghSDO) THEN
    RETURN.

DEFINE VARIABLE cValidDBs AS CHARACTER  NO-UNDO.

  ASSIGN
    cValidDBs = ghComboHandle:LIST-ITEMS
    cValidDBs = LEFT-TRIM(REPLACE(cValidDBs, "<All>":U, "":U), ",":U)
    cField    = "gsc_entity_mnemonic.entity_dbname":U 
    cWhere    = IF ghComboHandle:SCREEN-VALUE = "<All>":U
                THEN "LOOKUP(":U + cField + ", ":U + QUOTER(cValidDBs) + ") <> 0":U
                ELSE cField + " = '":U + ghComboHandle:SCREEN-VALUE + "'":U.

RUN updateAddQueryWhere IN ghSDO (INPUT cWhere, INPUT cField).
DYNAMIC-FUNCTION('openQuery' IN ghSDO).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cHandles AS CHARACTER  NO-UNDO.

{get ContainerSource ghContainer}.
{get allFieldHandles cHandles}.

ASSIGN ghComboHandle   = WIDGET-HANDLE(ENTRY(1, cHandles)) NO-ERROR.

ASSIGN ghSDO = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION('linkHandles' IN ghContainer,'PrimarySDO-TARGET'))) NO-ERROR.

ON "VALUE-CHANGED":U OF ghComboHandle PERSISTENT RUN buRefreshChoose IN THIS-PROCEDURE.

IF VALID-HANDLE(ghSDO) THEN
  {set OpenOnInit FALSE ghSDO}.

RUN SUPER.

/* Now build the database combo */
IF VALID-HANDLE(ghComboHandle) THEN
    RUN populateCombo.

RUN buRefreshChoose IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-populateCombo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateCombo Procedure 
PROCEDURE populateCombo :
/*------------------------------------------------------------------------------
  Purpose:     Build a combo from the databases currently loaded into the system.
  Parameters:  <none>
  Notes:       Note we can not use connected databases to build this list, we need
               to build the database list from the gsc_entity_mnemonic table, as a 
               user may not necessarily be connected to all the databases loaded into
               the Dynamics database.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDBList      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cHandleList  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cExtraParams AS CHARACTER  NO-UNDO.

IF VALID-HANDLE(gshGenManager) 
THEN DO:
    RUN getDBsForImportedEntities IN gshGenManager (INPUT NO,
                                                    OUTPUT cDBList,
                                                    INPUT-OUTPUT cExtraParams) NO-ERROR.

    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
        RETURN.
END.

ASSIGN ghComboHandle:LIST-ITEMS   = "<All>":U + (IF cDBList = "":U THEN "":U ELSE ",":U) + cDBList
       ghComboHandle:SCREEN-VALUE = ghComboHandle:ENTRY(1) NO-ERROR.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

