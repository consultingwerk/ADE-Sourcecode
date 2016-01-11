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

  RUN start-super-proc("adm2/datavis.p":U).

  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
  {src/adm2/custom/dataviscustom.i}
  /* _ADM-CODE-BLOCK-END */

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
  DEFINE VARIABLE hBrwsQry   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNewRecord AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hFirstBuff AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cEnabledObjHdls       AS CHARACTER            NO-UNDO.
  DEFINE VARIABLE iObjectLoop           AS INTEGER              NO-UNDO.
  DEFINE VARIABLE hFrameField           AS HANDLE               NO-UNDO.
  
  &IF "{&ICF-DYNAMIC-VIEWER}":U EQ "YES":U &THEN  
  {get EnabledObjHdls cEnabledObjHdls}.

  DO iObjectLoop = 1 TO NUM-ENTRIES(cEnabledObjHdls):
      ASSIGN hFrameField = WIDGET-HANDLE(ENTRY(iObjectLoop, cEnabledObjHdls)) NO-ERROR. 
      IF VALID-HANDLE(hFrameField) THEN        
      DO:
          FIND ttWidget WHERE
               ttWidget.tWidgetHandle = hFrameField AND
               ttWidget.tVisible      = YES
               NO-ERROR.
          IF AVAILABLE ttWidget THEN
          DO:
              IF ttWidget.tWidgetType = "SmartDataField":U THEN
                  RUN setAttributesInObject IN gshSessionManager ( INPUT ttWidget.tWidgetHandle,
                                                                   INPUT ("DataValue":U + CHR(4) + ttWidget.tInitialValue) ) NO-ERROR.
              ELSE
              IF CAN-SET(ttWidget.tWidgetHandle, "SCREEN-VALUE":U) THEN
                  ASSIGN ttWidget.tWidgetHandle:SCREEN-VALUE = ttWidget.tInitialValue.
          END.  /* avail ttWidget */
      END.  /* valid frame field */
  END.  /* object loop */
  &ELSEIF "{&DISPLAYED-OBJECTS}":U NE "":U &THEN
    DISPLAY {&UNLESS-HIDDEN} {&DISPLAYED-OBJECTS} WITH FRAME {&FRAME-NAME}.
  &ENDIF  

  &IF "{&BROWSE-NAME}":U NE "":U &THEN
     /* This piece of code is here to specifically refresh a browse row for
        the calculated fields */
     {get NewRecord cNewRecord}.
     IF cNewRecord = "No":U THEN  /* Don't do this if we're adding */
     DO WITH FRAME {&FRAME-NAME}:
       hBrwsQry = BROWSE {&BROWSE-NAME}:QUERY. /* Get the query for the browse */
       IF VALID-HANDLE(hBrwsQry) AND  /* Only refresh if the browse query is a */
          hBrwsQry:IS-OPEN THEN 
       DO:
         hFirstBuff = hBrwsQry:GET-BUFFER-HANDLE(1).
         IF VALID-HANDLE(hFirstBuff) AND
            hFirstBuff:AVAILABLE THEN       /* valid handle and open */
           BROWSE {&BROWSE-NAME}:REFRESH() NO-ERROR.
       END.
     END.
  &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

