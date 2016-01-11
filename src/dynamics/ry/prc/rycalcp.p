&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
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
  File: rycalcp.p

  Description:  Returns temp table of calculated fields and their entities 

  ACCESS_LEVEL=PRIVATE

  Purpose:      Returns a temp table of calculated fields and their 
                entities for use by the AppBuilder calculated field selector.  
                This procedure is for AppBuilder use only and should not be 
                invoked by application code.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   06/02/2004  Author:     

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rycalcp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

DEFINE TEMP-TABLE ttCalcEntity NO-UNDO
  FIELD tCalculatedField AS CHARACTER
  FIELD tEntity          AS CHARACTER 
  FIELD tInstanceName    AS CHARACTER.

DEFINE OUTPUT PARAMETER TABLE FOR ttCalcEntity.

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
         HEIGHT             = 9.05
         WIDTH              = 63.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE cCalcClassList    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEntityClassList  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iNumClass         AS INTEGER    NO-UNDO.

DEFINE BUFFER bContainer      FOR ryc_smartobject.
DEFINE BUFFER bContainerClass FOR gsc_object_type.

  ASSIGN
    cCalcClassList   = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                                        INPUT 'CalculatedField':U)
    cEntityClassList = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                                        INPUT 'Entity':U).
  
  DO iNumClass = 1 TO NUM-ENTRIES(cCalcClassList):
    FIND gsc_object_type WHERE gsc_object_type.OBJECT_type_code = ENTRY(iNumClass,cCalcClassList) NO-LOCK NO-ERROR.
    IF AVAILABLE gsc_object_type THEN
    DO:
      FOR EACH ryc_smartobject WHERE ryc_smartobject.OBJECT_type_obj = gsc_object_type.OBJECT_type_obj NO-LOCK:
        FOR EACH ryc_object_instance WHERE ryc_object_instance.smartobject_obj = ryc_smartobject.smartobject_obj NO-LOCK:
          FIND bContainer WHERE bContainer.smartobject_obj = ryc_object_instance.container_smartobject_obj NO-LOCK NO-ERROR.
          IF AVAILABLE bContainer THEN 
          DO:
            FIND bContainerClass WHERE bContainerClass.OBJECT_type_obj = bContainer.OBJECT_type_obj NO-LOCK NO-ERROR.
            IF AVAILABLE bContainerClass AND LOOKUP(bContainerClass.OBJECT_type_code, cEntityClassList) > 0 THEN
            DO:
              CREATE ttCalcEntity.
              ASSIGN
                ttCalcEntity.tCalculatedField = ryc_smartobject.OBJECT_filename
                ttCalcEntity.tEntity          = bContainer.OBJECT_filename
                ttCalcEntity.tInstanceName    = ryc_object_instance.instance_name.
            END.  /* if avail entity container */
          END.  /* if avail container */
        END.  /* for each instance */
      END.  /* for each calc field */ 
    END.  /* if avail object type */ 
  END.  /* do i to number calc field classes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


