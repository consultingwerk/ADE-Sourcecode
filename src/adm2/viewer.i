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
/*-------------------------------------------------------------------------
    File        : viewer.i  
    Purpose     : Basic SmartDataViewer methods for the ADM
  
    Syntax      : {src/adm2/viewer.i}

    Description :
  
    Modified    :  May 18, 2000 -- version 9.1B
-------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&IF "{&ADMClass}":U = "":U &THEN
  &GLOB ADMClass viewer
&ENDIF

&IF "{&ADMClass}":U = "viewer":U &THEN
  {src/adm2/viewprop.i}
&ENDIF

/* Exclude the static props procedure for a dynamic data object */ 
&IF "{&DISPLAYED-FIELDS}":U = "":U AND "{&ENABLED-FIELDS}":U = "":U &THEN
   &SCOPED-DEFINE EXCLUDE-adm-initviewerprops  
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

  {src/adm2/datavis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */
    DEFINE VARIABLE cViewCols AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cEnabled  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iCol      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iEntries  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cEntry    AS CHARACTER NO-UNDO.

    /* Capture update keystrokes and signal the start of an update, so that
     * checkModified can work and to control the state of Panels. */
    ON VALUE-CHANGED OF FRAME {&FRAME-NAME} ANYWHERE
        RUN valueChanged IN THIS-PROCEDURE.

    /* Application code that defines vbalue-changed should run valueChanged
     * as above, but for backwards compatibility we also support 
     * VALUE-CHANGED triggers that APPLY 'U10' TO THIS-PROCECURE.*/
    ON 'U10':U OF THIS-PROCEDURE
        RUN valueChanged IN THIS-PROCEDURE.

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
   IF NOT {&ADM-LOAD-FROM-REPOSITORY} THEN
      RUN start-super-proc("adm2/viewer.p":U).

   &IF DEFINED(EXCLUDE-adm-initviewerprops) = 0 &THEN
      RUN adm-initviewerprops IN TARGET-PROCEDURE.
   &ENDIF

   /* Ensure that the viewer is disabled if it is an update-target without
      tableio-source (? will enable ).
      This is inconsistent with the browser (and datavis behavior), but 
      backwards compatible */
   {set SaveSource NO}. 
    


   /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
   {src/adm2/custom/viewercustom.i}
   /* _ADM-CODE-BLOCK-END */

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-adm-initViewerProps) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-initViewerProps Method-Library 
PROCEDURE adm-initViewerProps :
/*------------------------------------------------------------------------------
  Purpose: Transform the appbuilder generated viewer preprocessors into 
           adm properties  
  Notes:  This procedure is conditionally compiled in static viewers only. 
          (An exclude-  preprocessor is defined if displayed-fields and 
          enabled-fields is blank)           
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE hFrame            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDisplayedFields  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldHandles     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledFields    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledHandles   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iDispEntries      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEnabledEntries   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFieldName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTable            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLookup           AS INTEGER    NO-UNDO.
  
  ASSIGN 
    hFrame           = FRAME {&FRAME-NAME}:HANDLE 
    hField           = hFrame:FIRST-CHILD:FIRST-CHILD
    cDisplayedFields = REPLACE("{&DISPLAYED-FIELDS}":U," ",",")
    cEnabledFields   = REPLACE("{&ENABLED-FIELDS}":U," ",",")
  /* The order of the lists of handles must match the order of the 
     DisplayedField and EnabledField properties, so initialise with the 
     correct number of entries here*/
    cEnabledHandles = FILL(",":U, NUM-ENTRIES(cEnabledFields)   - 1)
    cFieldHandles   = FILL(",":U, NUM-ENTRIES(cDisplayedFields) - 1)
    .

  DO WHILE VALID-HANDLE(hField): 
    ASSIGN
      cFieldName = hField:NAME 
      cTable     = (IF CAN-QUERY(hField,"TABLE":U) THEN hField:TABLE ELSE '')
      /* The adm-datafield-mapping allows a local field to be mapped to the
         datafield. Format: <localfield>,<temptablename.datafieldname>
        (used for local LONGCHAR - SDO CLOB field mapping) */
      iLookup = LOOKUP(cFieldName,"{&ADM-DATAFIELD-MAPPING}":U)
    .
    /* if mapped then find the datafield name, that is used in DisplayedFields 
       and EnabledFields  */ 
    IF iLookup > 0 THEN
      cFieldName = ENTRY(iLookup + 1,"{&ADM-DATAFIELD-MAPPING}":U). 
    ELSE IF cTable > '' THEN
      cFieldName = cTable + "." + cFieldName.
    
    IF cFieldName > '' THEN
    DO:
      /* Displayed Fields */ 
      iLookup = LOOKUP(cFieldName, cDisplayedFields).
      IF iLookup > 0 THEN
        ENTRY(iLookup,cFieldHandles) = STRING(hField).
    
      /* Enabled Fields */
      iLookup = LOOKUP(cFieldName, cEnabledFields).
      IF iLookup > 0 THEN
        ENTRY(iLookup, cEnabledHandles) = STRING(hField).
    END.

    hField = hField:NEXT-SIBLING.
  END. /* do while */   
  
  /* Remove RowObject qualifer (keep SDO qualifers for SBO viewers */ 
  ASSIGN
    cDisplayedFields = LEFT-TRIM(REPLACE("," + cDisplayedFields,",RowObject.":U,","),",")
    cEnabledFields   = LEFT-TRIM(REPLACE("," + cEnabledFields,",RowObject.":U,","),",").

    /* Store the properties */
  &SCOPED-DEFINE xp-assign
  {set DisplayedFields cDisplayedFields}
  {set FieldHandles cFieldHandles}
  {set EnabledFields cEnabledFields}
  {set EnabledHandles cEnabledHandles}
  .
  &UNDEFINE xp-assign

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

