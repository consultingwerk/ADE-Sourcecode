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
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: ryuichangep.p

  Description:  

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/01/2002  Author:     

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryuichangep.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}
{src/web2/wrap-cgi.i}
 
/* ttUIChange is used for storing UI changes by web request.  This table should
   be purged at the start of each request. */
DEFINE TEMP-TABLE ttContext NO-UNDO
  FIELD propertyName   AS CHARACTER 
  FIELD propertyValue  AS CHARACTER 
  FIELD sessionOnly  AS LOGICAL
  INDEX propertyName   IS PRIMARY UNIQUE propertyName
  INDEX sessionOnly  sessionOnly
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-disableWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD disableWidget Procedure 
FUNCTION disableWidget RETURNS LOGICAL  
  (INPUT cWidgetList AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD enableWidget Procedure 
FUNCTION enableWidget RETURNS LOGICAL
  (INPUT cWidgetList AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPropertyList Procedure 
FUNCTION getPropertyList RETURNS CHARACTER
  ( pcPropertyList AS CHARACTER,
    plSessionOnly AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hideWidget Procedure 
FUNCTION hideWidget RETURNS LOGICAL
  (INPUT cWidgetList AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-highlightWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD highlightWidget Procedure 
FUNCTION highlightWidget RETURNS LOGICAL
  (INPUT cWidgetList AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPropertyList Procedure 
FUNCTION setPropertyList RETURNS LOGICAL
  ( pcPropertyList AS CHARACTER,
    pcPropertyValues AS CHARACTER,
    plSessionOnly AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD showWidget Procedure 
FUNCTION showWidget RETURNS LOGICAL
  (INPUT cWidgetList AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-unHighlightWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD unHighlightWidget Procedure 
FUNCTION unHighlightWidget RETURNS LOGICAL
  (INPUT cWidgetList AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updatePropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updatePropertyList Procedure 
FUNCTION updatePropertyList RETURNS LOGICAL
  ( pcPropertyList AS CHARACTER,
    pcPropertyValues AS CHARACTER )  FORWARD.

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
         HEIGHT             = 16.43
         WIDTH              = 56.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-end-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE end-request Procedure 
PROCEDURE end-request :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN flushToContext.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-flushToContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE flushToContext Procedure 
PROCEDURE flushToContext :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cNames  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValues AS CHARACTER NO-UNDO.

  /* Batch up attributes to be written to the context database. */  
  FOR EACH ttContext WHERE ttContext.sessionOnly = FALSE:
    ASSIGN
    	cNames  = cNames + (IF cNames <> "" THEN ",":U ELSE "") +
    	          ttContext.propertyName
    	cValues = cValues + (IF cValues <> "" THEN CHR(3) ELSE "") +
    	          ttContext.propertyValue.
  END.

  /* Write out properties that need to persist across web requests. */
  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                   cNames, cValues, FALSE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-request Procedure 
PROCEDURE init-request :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  EMPTY TEMP-TABLE ttContext.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-outputUIChanges) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputUIChanges Procedure 
PROCEDURE outputUIChanges :
/*------------------------------------------------------------------------------
  Purpose:     For each supported UI change type, get the list of objects to
               apply the change to, if any
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cChange     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChangeList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cJS         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount1     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount2     AS INTEGER    NO-UNDO.

  /* Process changes for main/body frame */
  ASSIGN
    cChangeList = "enable,disable,highlight,unhighlight,hide,show":U.

  /* cObjList is a comma delimited list of object names/id's */
  DO iCount1 = 1 TO NUM-ENTRIES(cChangeList):
    ASSIGN
      cChange  = ENTRY(iCount1, cChangeList)
      cObjList = DYNAMIC-FUNCTION("getPropertyList":U, cChange + "Widgets":U,YES).

    DO iCount2 = 1 TO NUM-ENTRIES(cObjList):
      cJS = cJS + ENTRY(iCount2, cObjList) + ".":U + cChange + ";":U + CHR(10).
    END. /* objects */
  END. /* change */

  {&OUT}
    '<script>':U SKIP
    cJS SKIP
    '</script>':U SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-disableWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION disableWidget Procedure 
FUNCTION disableWidget RETURNS LOGICAL  
  (INPUT cWidgetList AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION("updatePropertyList":U, "disableWidget":U, cWidgetList, NO).
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION enableWidget Procedure 
FUNCTION enableWidget RETURNS LOGICAL
  (INPUT cWidgetList AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION("updatePropertyList":U, "enableWidget":U, cWidgetList, NO).
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPropertyList Procedure 
FUNCTION getPropertyList RETURNS CHARACTER
  ( pcPropertyList AS CHARACTER,
    plSessionOnly AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cProperty AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturn   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPos      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ix        AS INTEGER    NO-UNDO.

  DO ix = 1 TO NUM-ENTRIES(pcPropertyList):
    ASSIGN
      cProperty = TRIM(ENTRY(ix, pcPropertyList)).

    /* Search for local copy first */
    FIND FIRST ttContext WHERE
      ttContext.propertyName = cProperty NO-ERROR.

    /* Search for copy in context database */
    IF NOT AVAILABLE ttContext THEN DO:
      CREATE ttContext.
      ASSIGN
        ttContext.propertyName  = cProperty.
      ASSIGN
        ttContext.propertyValue = 
            DYNAMIC-FUNCTION("getPropertyList" IN gshSessionManager,
                              cProperty, plSessionOnly).
    END.
    ASSIGN
      cReturn = cReturn + (IF cReturn <> "" THEN CHR(3) ELSE "") + 
                ttContext.propertyValue.
  END.

  RETURN cReturn.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hideWidget Procedure 
FUNCTION hideWidget RETURNS LOGICAL
  (INPUT cWidgetList AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION("updatePropertyList":U, "hideWidget":U, cWidgetList, NO).
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-highlightWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION highlightWidget Procedure 
FUNCTION highlightWidget RETURNS LOGICAL
  (INPUT cWidgetList AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION("updatePropertyList":U, "highlightWidget":U, cWidgetList, NO).
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPropertyList Procedure 
FUNCTION setPropertyList RETURNS LOGICAL
  ( pcPropertyList AS CHARACTER,
    pcPropertyValues AS CHARACTER,
    plSessionOnly AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Keep track of UI change
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cProperty  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPos       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ix         AS INTEGER    NO-UNDO.

  DO ix = 1 TO NUM-ENTRIES(pcPropertyList):
    ASSIGN
      cProperty = TRIM(ENTRY(ix, pcPropertyList))
      cValue    = TRIM(ENTRY(ix, pcPropertyValues, CHR(3))).

    /* Find tt record */
    FIND FIRST ttContext WHERE
      ttContext.propertyName = cProperty NO-ERROR.
    IF NOT AVAILABLE ttContext THEN DO:
      CREATE ttContext.
      ASSIGN 
        ttContext.propertyName = cProperty
        ttContext.sessionOnly  = plSessionOnly.
    END.
    ASSIGN 
      ttContext.propertyValue = cValue.
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION showWidget Procedure 
FUNCTION showWidget RETURNS LOGICAL
  (INPUT cWidgetList AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION("updatePropertyList":U, "showWidget":U, cWidgetList, NO).
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-unHighlightWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION unHighlightWidget Procedure 
FUNCTION unHighlightWidget RETURNS LOGICAL
  (INPUT cWidgetList AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION("updatePropertyList":U, "unHighlightWidget":U, cWidgetList, NO).
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updatePropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updatePropertyList Procedure 
FUNCTION updatePropertyList RETURNS LOGICAL
  ( pcPropertyList AS CHARACTER,
    pcPropertyValues AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cProperty AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPos      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE ix        AS INTEGER    NO-UNDO.

  DO ix = 1 TO NUM-ENTRIES(pcPropertyList):
    ASSIGN
      cProperty = TRIM(ENTRY(ix, pcPropertyList))
      cValue    = TRIM(ENTRY(ix, pcPropertyValues, CHR(3))).

    /* Find tt record */
    FIND FIRST ttContext WHERE
      ttContext.propertyName = cProperty NO-ERROR.
    IF NOT AVAILABLE ttContext THEN DO:
      setPropertyList(cProperty, cValue, FALSE).
      NEXT.
    END.

    /* Add value to list if it's not already there */
    IF LOOKUP(cValue, ttContext.propertyValue, CHR(3)) = 0 THEN
      ASSIGN
        ttContext.propertyValue = 
          (IF ttContext.propertyValue = "" THEN cValue ELSE
            ttContext.propertyValue + CHR(3) + cValue).
  END.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

