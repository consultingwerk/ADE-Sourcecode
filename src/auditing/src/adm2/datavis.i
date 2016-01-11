&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    Library     : datavis.i
    Purpose     : Basic Data Visualization object methods for the ADM

    Syntax      : {src/adm2/datavis.i}

    Description :

    Modified    : May 19, 1999 Version 9.1A
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF "{&ADMClass}":U = "":U &THEN
  &GLOB ADMClass datavis
&ENDIF

&IF "{&ADMClass}":U = "datavis":U &THEN
  {src/adm2/dvisprop.i}
&ENDIF

&IF DEFINED(UNLESS-OBJECTS-HIDDEN) = 0 &THEN
   &SCOP UNLESS-OBJECTS-HIDDEN {&UNLESS-HIDDEN}
   &IF "{&UNLESS-OBJECTS-HIDDEN}":U = "":U &THEN
     &SCOP UNLESS-OBJECTS-HIDDEN UNLESS-HIDDEN
   &ENDIF
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
         HEIGHT             = 8
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* If this object is also a SmartContainer, then we must include containr
   in the chain of basic includes. New for 9.1A */
&IF DEFINED(ADM-CONTAINER) NE 0 &THEN
  {src/adm2/containr.i}
&ELSE
  {src/adm2/visual.i}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */
&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  IF NOT {&ADM-LOAD-FROM-REPOSITORY} THEN
  DO:
    RUN start-super-proc("adm2/datavis.p":U).

    RUN modifyListProperty (THIS-PROCEDURE, 'ADD':U,
      "SupportedLinks":U, "Toolbar-Target":U).
  END.  /* if not adm-load-from-repos */

  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
  {src/adm2/custom/dataviscustom.i}
  /* _ADM-CODE-BLOCK-END */
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-displayObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayObjects Method-Library 
PROCEDURE displayObjects :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is run during initialization to display initial
               values for non-database-related fields, and is also run from
               displayFields in case those values change with each new record.
  Parameters:  <none>
  Notes:       This procedure is in the include file rather than the super 
               procedure because it is easiest to display the fields in the
               DISPLAYED-OBJECTS list from the object itself. 
------------------------------------------------------------------------------*/
  &IF "{&DISPLAYED-OBJECTS}":U NE "":U &THEN
    DISPLAY {&UNLESS-OBJECTS-HIDDEN} {&DISPLAYED-OBJECTS} WITH FRAME {&FRAME-NAME}.

    /* Now check if we've translated any FILL-INs VIEW-AS TEXT, and reapply *
     * those translations if necessary. */
    DEFINE VARIABLE cObjectsAndTranslations AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iCnt          AS INTEGER   NO-UNDO.
    DEFINE VARIABLE hWidgetHandle AS HANDLE    NO-UNDO.
    DEFINE VARIABLE cTranslation  AS CHARACTER NO-UNDO.

    ASSIGN cObjectsAndTranslations = {fnarg getUserProperty "'TranslatedObjectHandlesAndValues'" TARGET-PROCEDURE} NO-ERROR.

    IF  cObjectsAndTranslations <> "":U 
    AND cObjectsAndTranslations <> ? THEN
        DO iCnt = 1 TO NUM-ENTRIES(cObjectsAndTranslations, CHR(27)):
            ASSIGN cTranslation  = ENTRY(iCnt, cObjectsAndTranslations, CHR(27))
                   hWidgetHandle = WIDGET-HANDLE(ENTRY(1, cTranslation, CHR(2)))
                   cTranslation  = ENTRY(2, cTranslation, CHR(2))
                   NO-ERROR.
            IF NOT ERROR-STATUS:ERROR THEN
                ASSIGN hWidgetHandle:SCREEN-VALUE = cTranslation NO-ERROR.
        END.
  &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

