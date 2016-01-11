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
/* Copyright (C) 2007 by Progress Software Corporation. All rights
   reserved. Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: _contbldrprop.p

  Description:  Wrapper: Launch new Container Builder

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/29/2002  Author:     Chris Koster

  Update Notes: Created from Template rytemprocp.p
                Created from Template rycblnchrp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       _contbldrprop.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

DEFINE VARIABLE ghContainerBuilder  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghWindowHandle      AS HANDLE     NO-UNDO.
DEFINE VARIABLE glVisible           AS LOGICAL    NO-UNDO.

&SCOPED-DEFINE RYOBJECT-FIELDS-ONLY  YES
&SCOPED-DEFINE EXCLUDE_U             YES
&SCOPED-DEFINE EXCLUDE_C             YES
&SCOPED-DEFINE EXCLUDE_F             YES
&SCOPED-DEFINE EXCLUDE_M             YES
&SCOPED-DEFINE EXCLUDE_Q             YES
&SCOPED-DEFINE EXCLUDE_S             YES
&SCOPED-DEFINE EXCLUDE_TT            YES
&SCOPED-DEFINE EXCLUDE_UF            YES
&SCOPED-DEFINE EXCLUDE_vbx2ocx       YES
&SCOPED-DEFINE EXCLUDE_PDP           YES
&SCOPED-DEFINE EXCLUDE_RyObject      YES

{adeuib/uniwidg.i}   /* Needed for _P definition */

&UNDEFINE EXCLUDE_RyObject
&UNDEFINE EXCLUDE_PDP
&UNDEFINE EXCLUDE_vbx2ocx
&UNDEFINE EXCLUDE_UF
&UNDEFINE EXCLUDE_TT
&UNDEFINE EXCLUDE_S
&UNDEFINE EXCLUDE_Q
&UNDEFINE EXCLUDE_M
&UNDEFINE EXCLUDE_F
&UNDEFINE EXCLUDE_C
&UNDEFINE EXCLUDE_U
&UNDEFINE RYOBJECT-FIELDS-ONLY

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getPRecid) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPRecid Procedure 
FUNCTION getPRecid RETURNS RECID
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isModified Procedure 
FUNCTION isModified RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isSaved) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isSaved Procedure 
FUNCTION isSaved RETURNS LOGICAL
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
         HEIGHT             = 12.91
         WIDTH              = 42.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
  DEFINE INPUT  PARAMETER pPrecid AS RECID      NO-UNDO.
  DEFINE BUFFER local_P FOR _P.

  FIND local_P WHERE RECID(local_P) = pPrecid NO-ERROR.

  /* If we are adding a new record, we do not have a filename. In that case,
     show the container builder to allow for immediate data entry */
  IF local_P.object_filename = "":U OR
     local_P.object_filename = ?    THEN
    RUN viewObject.
  
  SUBSCRIBE TO "closePropSheet":U IN THIS-PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */ 
&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure
PROCEDURE initializeObject:
/*------------------------------------------------------------------------------
    Purpose:
    Parameters: <none>
    Notes:
------------------------------------------------------------------------------*/
    define buffer lb_P for _P.

    find lb_P where recid(lb_P) = pPrecid.
    
    /* This procedure may have been started by dynamics/ry/prc/rycblnchrp.p,
       which acts as a wrapper for this procedure. In that case, we want to 
       kill the wrapper and replace its reference in the _P table with
       a reference to this procedure. */
    if lb_P.design_hpropsheet ne target-procedure and
       valid-handle(lb_P.design_hpropsheet) then
        delete procedure lb_P.design_hpropsheet .
    
    lb_P.design_hpropsheet = target-procedure.
END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-closePropSheet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE closePropSheet Procedure 
PROCEDURE closePropSheet :
/*------------------------------------------------------------------------------
  Purpose:  To close the property sheet when the design stub window is closed.
  
  Parameters:  <none>
  
  Notes:  closePropSheet published when the design stub window is closed, AFTER
          the prompt to save and the actual saving has taken place. It is therefore
          save to exit the property sheet as saving / cancelling would be complete.
------------------------------------------------------------------------------*/
  RUN exitObject.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-exitObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject Procedure 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  To pass exit object on to the Container Builder
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF VALID-HANDLE(ghContainerBuilder) THEN
    RUN myExitObject IN ghContainerBuilder.
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideObject Procedure 
PROCEDURE hideObject :
/*------------------------------------------------------------------------------
  Purpose:  Pass the hide object onto the Container Builder     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  IF VALID-HANDLE(ghContainerBuilder) THEN
    RUN hideObject IN ghContainerBuilder.
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveObject Procedure 
PROCEDURE saveObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER pcSaveFile    AS CHARACTER  NO-UNDO.
  DEFINE       OUTPUT PARAMETER plUserCancel  AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE lContinue AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lChanges  AS LOGICAL    NO-UNDO.

  IF VALID-HANDLE(ghContainerBuilder) THEN
  DO:
    ASSIGN
        ERROR-STATUS:ERROR = FALSE
        pcSaveFile         = DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerBuilder, "ObjectFilename":U).
  
    RUN checkIfSaved IN ghContainerBuilder (INPUT  FALSE,     /* Prompt   */
                                            INPUT  TRUE,      /* Autosave */
                                            OUTPUT lChanges,
                                            OUTPUT lContinue) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
      lContinue = FALSE.
  END.

  plUserCancel = NOT lContinue.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateTitle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateTitle Procedure 
PROCEDURE updateTitle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTitle  AS CHARACTER  NO-UNDO.

  IF Local_P._WINDOW-HANDLE:TITLE MATCHES "*Untitled:*":U THEN
    ASSIGN
        cTitle = Local_P._WINDOW-HANDLE:TITLE
        cTitle = TRIM(ENTRY(1, cTitle, "-":U)) + " - ":U + DYNAMIC-FUNCTION("getUserProperty":U IN ghContainerBuilder, "ObjectFilename":U)

        Local_P._WINDOW-HANDLE:TITLE = cTitle.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject Procedure 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:  Pass viewObject on to the Container Builder
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRunContainerType AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectFilename   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunAttribute     AS CHARACTER  NO-UNDO.

  IF NOT VALID-HANDLE(ghContainerBuilder) THEN
  DO:
    RUN clearClientCache IN gshRepositoryManager.

    ASSIGN
        cObjectFilename = (IF local_P.object_filename = ? THEN "":U ELSE local_P.object_filename)
        cRunAttribute   = "AppBuilder":U
                        + CHR(3) + STRING(local_P.product_module_code)
                        + CHR(3) + STRING(local_P.object_type_code).
  
    IF VALID-HANDLE(gshSessionManager) THEN
      RUN launchContainer IN gshSessionManager (INPUT  "rycntpshtw":U,          /* object filename if physical/logical names unknown */
                                                INPUT  "":U,                    /* physical object name (with path and extension) if known */
                                                INPUT  "rycntpshtw":U,          /* logical object name if applicable and known */
                                                INPUT  NO,                      /* run once only flag YES/NO */
                                                INPUT  "":U,                    /* instance attributes to pass to container */
                                                INPUT  "":U,                    /* child data key if applicable */
                                                INPUT  cRunAttribute,           /* run attribute if required to post into container run */
                                                INPUT  "":U,                    /* container mode, e.g. modify, view, add or copy */
                                                INPUT  Local_P._WINDOW-HANDLE,  /* parent (caller) window handle if known (container window handle) */
                                                INPUT  ?,                       /* parent (caller) procedure handle if known (container procedure handle) */
                                                INPUT  ?,                       /* parent (caller) object handle if known (handle at end of toolbar link, e.g. browser) */
                                                OUTPUT ghContainerBuilder,      /* procedure handle of object run/running */
                                                OUTPUT cRunContainerType).      /* procedure type (e.g ADM1, Astra1, ADM2, ICF, "") */

    RUN loadContainer IN ghContainerBuilder (INPUT cObjectFilename).

    SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "updateTitle":U IN ghContainerBuilder.
  END.
  ELSE  
    RUN viewObject IN ghContainerBuilder.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getPRecid) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPRecid Procedure 
FUNCTION getPRecid RETURNS RECID
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Return the AppBuilder design window _P recid for this Property Sheet.
    Notes:  
------------------------------------------------------------------------------*/
  RETURN pPrecid.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isModified Procedure 
FUNCTION isModified RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Check the Container Builder to see if there were modifications
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lContinue AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lChanges  AS LOGICAL    NO-UNDO.

  IF VALID-HANDLE(ghContainerBuilder) THEN
  DO:
    RUN checkIfSaved IN ghContainerBuilder (INPUT  FALSE,
                                            INPUT  FALSE,
                                            OUTPUT lChanges,
                                            OUTPUT lContinue).
  
    IF NOT lChanges AND PROGRAM-NAME(2) BEGINS "wind-close":U THEN
      RUN exitObject.
  END.

  RETURN lChanges.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isSaved) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isSaved Procedure 
FUNCTION isSaved RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Check the Container Builder to see if all changes are saved
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lContinue AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lChanges  AS LOGICAL    NO-UNDO.

  IF VALID-HANDLE(ghContainerBuilder) THEN
    RUN checkIfSaved IN ghContainerBuilder (INPUT  FALSE,
                                            INPUT  FALSE,
                                            OUTPUT lChanges,
                                            OUTPUT lContinue).

  RETURN NOT lChanges.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

