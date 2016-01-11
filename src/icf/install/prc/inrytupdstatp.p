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
  File: inrytupdstatp.p

  Description:  ryt_update_status update program

  Purpose:      ryt_update_status update program

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/02/2002  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       inrytupdstatp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* object identifying preprocessor */
&glob   AstraProcedure    yes

/* Patch list include */
{install/inc/inttpatchlist.i}

DEFINE INPUT PARAMETER TABLE FOR ttPatchList.
DEFINE VARIABLE iCount  AS INTEGER    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getNextObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNextObj Procedure 
FUNCTION getNextObj RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

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
         HEIGHT             = 16.14
         WIDTH              = 60.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DISABLE TRIGGERS FOR LOAD OF ryt_dbupdate_status.
DISABLE TRIGGERS FOR DUMP OF ryt_dbupdate_status.

FOR EACH ttPatchList 
  BREAK BY ttPatchList.cPatchDB
        BY ttPatchList.cPatchLevel
        BY ttPatchList.iUpdateWhen
        BY ttPatchList.iSeq
  TRANSACTION:

  IF FIRST-OF(ttPatchList.cPatchLevel) THEN
    iCount = 0.

  FIND FIRST ryt_dbupdate_status 
    WHERE ryt_dbupdate_status.update_db_name = ttPatchList.cPatchDB
      AND ryt_dbupdate_status.delta_version  = INTEGER(ttPatchList.cPatchLevel)
      AND ryt_dbupdate_status.file_type      = ttPatchList.cFileType
      AND ryt_dbupdate_status.file_name      = ttPatchList.cFileName
      AND ryt_dbupdate_status.update_when    = ttPatchList.iUpdateWhen
    NO-ERROR.
  IF NOT AVAILABLE(ryt_dbupdate_status) THEN
  DO:
    CREATE ryt_dbupdate_status.
    ASSIGN
      ryt_dbupdate_status.dbupdate_status_obj = getNextObj()
    .
    ASSIGN
      ryt_dbupdate_status.file_type        = ttPatchList.cFileType
      ryt_dbupdate_status.update_db_name   = ttPatchList.cPatchDB            
      ryt_dbupdate_status.delta_version    = INTEGER(ttPatchList.cPatchLevel)
      ryt_dbupdate_status.file_name        = ttPatchList.cFileName           
      ryt_dbupdate_status.update_when      = ttPatchList.iUpdateWhen
    .
  END.

  ASSIGN
    iCount = iCount + 1
    ryt_dbupdate_status.run_sequence       = iCount
    ryt_dbupdate_status.update_completed   = ttPatchList.lApplied
    ryt_dbupdate_status.update_successful  = ttPatchList.lApplied
    ryt_dbupdate_status.return_result      = "":U
    ryt_dbupdate_status.run_date           = TODAY
    ryt_dbupdate_status.run_time           = TIME
    ryt_dbupdate_status.run_by_user_obj    = 0.0
    ryt_dbupdate_status.update_new_db      = ttPatchList.lNewDB
    ryt_dbupdate_status.update_existing_db = ttPatchList.lExistingDB
    ryt_dbupdate_status.rerunnable         = lRerunnable
    ryt_dbupdate_status.update_mandatory   = lUpdateMandatory
  .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getNextObj) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNextObj Procedure 
FUNCTION getNextObj RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dSeqNext    AS DECIMAL  NO-UNDO.

  DEFINE VARIABLE iSeqObj1    AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iSeqObj2    AS INTEGER  NO-UNDO.

  DEFINE VARIABLE iSeqSiteDiv AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iSeqSiteRev AS INTEGER  NO-UNDO.
  
  DEFINE VARIABLE iSessnId    AS INTEGER  NO-UNDO.


  ASSIGN
    iSeqObj1    = NEXT-VALUE(seq_obj1,ICFDB)
    iSeqObj2    = CURRENT-VALUE(seq_obj2,ICFDB)
    iSeqSiteDiv = CURRENT-VALUE(seq_site_division,ICFDB)
    iSeqSiteRev = CURRENT-VALUE(seq_site_reverse,ICFDB)
    iSessnId    = CURRENT-VALUE(seq_session_id,ICFDB)
 .

  IF iSeqObj1 = 0 THEN
    ASSIGN
      iSeqObj2 = NEXT-VALUE(seq_obj2,ICFDB).
                           
  ASSIGN
    dSeqNext = DECIMAL((iSeqObj2 * 1000000000.0) + iSeqObj1)
  .

  IF  iSeqSiteDiv <> 0
  AND iSeqSiteRev <> 0
  THEN
      ASSIGN
          dSeqNext = dSeqNext + (iSeqSiteRev / iSeqSiteDiv).

  RETURN dSeqNext. /* Function return value */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

