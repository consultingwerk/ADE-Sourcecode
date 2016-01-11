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

  DEFINE VARIABLE cViewCols AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cEnabled  AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE iCol      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iEntries  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cEntry    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lResult   AS LOGICAL   NO-UNDO.
  
  RUN start-super-proc("adm2/viewer.p":U).

  /* Capture update keystrokes and signal the start of an update, so that
     checkModified can work and to control the state of Panels. */
  ON VALUE-CHANGED OF FRAME {&FRAME-NAME} ANYWHERE 
    APPLY 'U10':U TO THIS-PROCEDURE.

  /* Make the trigger indirect so that if application code also puts a
     VALUE-CHANGED trigger on some field it can APPLY 'U10' TO THIS-PROCECURE.*/
  ON 'U10':U OF THIS-PROCEDURE
  DO:
    /* Ignore the event if it wasn't a viewer field. 
       Note that the code assumes that an event from a widget in a different
       frame is for a SmartDataField, representing an SDO field. */
    DEFINE VARIABLE lViewerField AS LOGICAL NO-UNDO INIT no.
    DEFINE VARIABLE hFrame       AS HANDLE  NO-UNDO.

    IF LOOKUP(FOCUS:TABLE + ".":U + FOCUS:NAME, "{&DISPLAYED-FIELDS}":U, " ":U) NE 0
    THEN lViewerField = yes.
    ELSE DO:
      ASSIGN hFrame = FOCUS:PARENT       /* Field-Group for the widget */
             hFrame = hFrame:PARENT.     /* and the frame itself       */
      IF hFrame NE FRAME {&FRAME-NAME}:HANDLE THEN
        lViewerField = yes.
    END.
    IF lViewerField THEN 
    DO:
      {get FieldsEnabled lResult}.  /* Only if the object's enable for input.*/
      IF lResult THEN DO:
        {get DataModified lResult}.
        IF NOT lResult THEN           /* Don't send the event more than once. */
          {set DataModified yes}.
      END.   /* END DO IF Fields are Enabled */
    END.     /* END DO IF it's a RowObject field */
  END.       /* END DO ON ANY */

  /* As of 9.1B, the fields can be qualified by the SDO ObjectName rather
     than just RowObject. In that case keep the SDO ObjectName qualifier. */
  iEntries = NUM-ENTRIES("{&DISPLAYED-FIELDS}":U, " ":U).
  DO iCol = 1 TO iEntries:
    cEntry = ENTRY(iCol, "{&DISPLAYED-FIELDS}":U, " ":U).
    cViewCols = cViewCols + (IF cViewCols NE "":U THEN ",":U ELSE "":U) +
      IF ENTRY(1, cEntry, ".":U) NE "RowObject":U THEN cEntry 
      ELSE 
        SUBSTR(cEntry, R-INDEX(cEntry, ".":U) + 1).  /* Remove table */
  END.
  iEntries = NUM-ENTRIES("{&ENABLED-FIELDS}":U, " ":U).
  DO iCol = 1 TO iEntries:
    cEntry = ENTRY(iCol, "{&ENABLED-FIELDS}":U, " ":U).
    cEnabled = cEnabled + (IF cEnabled NE "":U THEN ",":U ELSE "":U) +
      IF ENTRY(1, cEntry, ".":U) NE "RowObject":U THEN cEntry 
      ELSE
        SUBSTR(cEntry, R-INDEX(cEntry, ".":U) + 1).  /* Remove table */
  END.

  {set DisplayedFields cViewCols}.
  {set EnabledFields cEnabled}.
  
  /* Ensure that the viewer is disabled if it is an update-target without
     tableio-source (? will enable ) */
  {set SaveSource NO}. 
  
  /* If there *are* no enabled fields, don't let the viewer be an 
     Update-Source or TableIO-Target. NOTE: This in principle belongs
     in datavis.i because it's generic but EnabledFields has just been set. */
  IF cEnabled = "":U THEN
  DO:
    RUN modifyListProperty(THIS-PROCEDURE, "REMOVE":U, "SupportedLinks":U,
      "Update-Source":U).
    RUN modifyListProperty(THIS-PROCEDURE, "REMOVE":U, "SupportedLinks":U,
      "TableIO-Target":U).
  END.   /* END DO cEnabled "" */

  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
  {src/adm2/custom/viewercustom.i}
  /* _ADM-CODE-BLOCK-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


