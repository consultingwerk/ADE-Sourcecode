&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
    File        : viewer.p
    Purpose     : Super procedure for PDO SmartViewer objects

    Syntax      : adm2/viewer.p
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Tell viewattr.i that this is the Super procedure. */
   &SCOP ADMSuper viewer.p

  {src/adm2/custom/viewerexclcustom.i}
  
  /* Combo temp-table */
  {src/adm2/ttcombo.i}

  /* Lookup temp-table */
  {src/adm2/ttlookup.i}
  /* Dynamic Combo temp-table */
  {src/adm2/ttdcombo.i}
  
  /* NOTE: IN 9.1B beta, this is needed to provide SBO routines
     with the proper calling procedure. */
  DEFINE VARIABLE ghTargetProcedure AS HANDLE NO-UNDO.

  /* Create copies of the lookup and combo temp tables */
  DEFINE TEMP-TABLE ttLookupCopy LIKE ttLookup.
  DEFINE TEMP-TABLE ttDComboCopy LIKE ttDCombo.

  /* Global handle for SDF Cacghe Manager */
  DEFINE VARIABLE ghSDFCacheManager   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE glIsDynamicsRunning AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getKeepChildPositions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getKeepChildPositions Procedure 
FUNCTION getKeepChildPositions RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeepChildPositions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setKeepChildPositions Procedure 
FUNCTION setKeepChildPositions RETURNS LOGICAL
        ( INPUT plKeepChildPositions AS LOGICAL) FORWARD.

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
         HEIGHT             = 17.91
         WIDTH              = 56.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  /* Clear out lookup/combo query temp-table */
  EMPTY TEMP-TABLE ttLookup.   
  EMPTY TEMP-TABLE ttDCombo.

  glIsDynamicsRunning = DYNAMIC-FUNCTION("isICFRunning":U IN TARGET-PROCEDURE) = YES NO-ERROR.
  /* Get handle to SDF Cache Manager */
  IF glIsDynamicsRunning THEN
    ghSDFCacheManager = DYNAMIC-FUNCTION("getManagerHandle":U IN TARGET-PROCEDURE, INPUT "SDFCacheManager":U) NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord Procedure 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Gets initial values, enables fields, and allows entry of
               values for a new record.     
  Parameters:  <none>
  Notes:       addRow creates the RowObject temp-table record  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hUpdateTarget      AS HANDLE    NO-UNDO.
   DEFINE VARIABLE cTarget            AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cFields            AS CHARACTER NO-UNDO.
   DEFINE VARIABLE hSource            AS HANDLE    NO-UNDO.
   DEFINE VARIABLE cColValues         AS CHARACTER NO-UNDO.
   DEFINE VARIABLE hGaSource          AS HANDLE    NO-UNDO.
   DEFINE VARIABLE cUpdateNames       AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE iV                 AS INTEGER    NO-UNDO.

      RUN SUPER.

      IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.
      
      /* Note: SUPER (datavis.p) verifies that UpdateTarget is present. */
      {get UpdateTarget cTarget}.
      hUpdateTarget = WIDGET-HANDLE(cTarget).
      /* If we're a GroupAssign-Target, then our Source has already done 
         the add; otherwise we invoke addRow in the UpdateTarget.*/           

      IF VALID-HANDLE(hUpdateTarget) THEN
      DO:
        /* 'getUpdateTargetNames' is overriden to include the UpdateTargetNames */
        /* of all GA-related components. Here we *only* want the value of */
        /* THIS (TARGET-PROCEDURE) object. This really should be implemented */
        /* as 2 different properties... */
        &SCOPED-DEFINE xpUpdateTargetNames
        {get UpdateTargetNames cUpdateNames}.
        &UNDEFINE xpUpdateTargetNames
        
        {get DisplayedFields cFields}.
        IF cUpdateNames > "" AND NUM-ENTRIES(cUpdateNames) = 1 THEN
        DO iV = 1 TO NUM-ENTRIES(cFields):
          IF index(entry(iV,cFields), '.':U) = 0 THEN
            entry(iV,cFields) = cUpdateNames + '.':U + entry(iV,cFields) .
        END.

        ghTargetProcedure = TARGET-PROCEDURE.
        cColValues = DYNAMIC-FUNCTION("addRow":U IN hUpdateTarget, cFields). 
        ghTargetProcedure = ?.
        RUN displayFields IN TARGET-PROCEDURE(cColValues). 
      END.
      ELSE DO:
        {get GroupAssignSource hGaSource}.
        IF VALID-HANDLE(hGaSource) THEN
           RUN DisplayRecord IN TARGET-PROCEDURE. 
      END.

      PUBLISH 'addRecord':U FROM TARGET-PROCEDURE.  /* In case of GroupAssign */
      
      IF VALID-HANDLE(hUpdateTarget) THEN
        RUN applyEntry IN TARGET-PROCEDURE (?).
      
      /* For dynamic combos who are a parent to another dynamic combo
         we need to force a valueChange to ensure that the child combos
         are refreshed */
      FOR EACH  ttDCombo
          WHERE ttDCombo.hViewer = TARGET-PROCEDURE
          NO-LOCK:
        RUN valueChanged IN ttDCombo.hWidget.
      END.
      PUBLISH 'updateState':U FROM TARGET-PROCEDURE ('update').
    RETURN.
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord Procedure 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     Cancels the add, copy or update operation for the current row.
  Parameters:  <none>
  Notes:       cancelRecord in datavis.p (invoked by RUN SUPER) actually 
               cancels the update and for an add or copy, deletes the temp-table 
               record.   
------------------------------------------------------------------------------*/
  RUN SUPER.

  IF RETURN-VALUE EQ "ADM-ERROR":U THEN RETURN "ADM-ERROR":U. 
  
  PUBLISH 'cancelRecord':U FROM TARGET-PROCEDURE.   /* In case GroupAssign */

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecord Procedure 
PROCEDURE copyRecord :
/*------------------------------------------------------------------------------
  Purpose:     Copy a row    
  Parameters:  <none>
  Notes:       copyRow creates the RowObject temp-table record  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hUpdateTarget      AS HANDLE    NO-UNDO.
   DEFINE VARIABLE cTarget            AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cFields            AS CHARACTER NO-UNDO.
   DEFINE VARIABLE hSource            AS HANDLE    NO-UNDO.
   DEFINE VARIABLE cColValues         AS CHARACTER NO-UNDO.
   DEFINE VARIABLE hGaSource          AS HANDLE    NO-UNDO.
   DEFINE VARIABLE cUpdateNames       AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE iV                 AS INTEGER    NO-UNDO.

      RUN SUPER.
      IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.

      /* Note: SUPER (datavis.p) verifies that UpdateTarget is present. */
      {get UpdateTarget cTarget}.
      hUpdateTarget = WIDGET-HANDLE(cTarget).
      /* If we're a GroupAssign-Target, then our Source has already done 
         the add; otherwise we invoke addRow in the UpdateTarget.*/           
      IF VALID-HANDLE(hUpdateTarget) THEN
      DO:
        &SCOPED-DEFINE xpUpdateTargetNames
        {get UpdateTargetNames cUpdateNames}.
        &UNDEFINE xpUpdateTargetNames
        
        {get DisplayedFields cFields}.
        IF NUM-ENTRIES(cUpdateNames) = 1 
        THEN DO iV = 1 TO NUM-ENTRIES(cFields):
          IF index(entry(iV,cFields), '.':U) = 0 THEN
             entry(iV,cFields) = cUpdateNames + '.':U + entry(iV,cFields) .
        END.

        ghTargetProcedure = TARGET-PROCEDURE.
        cColValues = DYNAMIC-FUNCTION("copyRow":U IN hUpdateTarget, cFields). 
        IF cColValues = ? THEN
        do:
          {set NewRecord "NO"}.
          {fn showDataMessages}.
          RETURN "ADM-ERROR":U.
        END.

        ghTargetProcedure = ?.
        RUN displayFields IN TARGET-PROCEDURE(cColValues). 
      END.
      ELSE DO:
        {get GroupAssignSource hGaSource}.
        IF VALID-HANDLE(hGaSource) THEN
           RUN DisplayRecord IN TARGET-PROCEDURE. 
      END.

      PUBLISH 'copyRecord':U FROM TARGET-PROCEDURE.  /* In case of GroupAssign */
      
      IF VALID-HANDLE(hUpdateTarget) THEN
        RUN applyEntry IN TARGET-PROCEDURE (?).

      PUBLISH 'updateState':U FROM TARGET-PROCEDURE ('update').
      
    RETURN.
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Added this override procedure to remove any Dynamic Lookup and
               Dynamic Combo temp-table records for the viewer being destroyed.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  FOR EACH  ttDCombo
      WHERE ttDCombo.hViewer = TARGET-PROCEDURE
      EXCLUSIVE-LOCK:
    DELETE ttDCombo.
  END.

  FOR EACH ttLookup
      WHERE ttLookup.hViewer = TARGET-PROCEDURE
      EXCLUSIVE-LOCK:
  DELETE ttLookup.
  END.
  
  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFields Procedure 
PROCEDURE disableFields :
/*------------------------------------------------------------------------------
  Purpose:     Disables fields in the ENABLED-FIELDS list (AppBuilder generated
               preprocessor).
  Parameters:  INPUT pcFieldType AS CHARACTER -- 'All' or 'Create'
  Notes:       At present at least, this takes an argument which may be
               "All" or "Create" to allow, e.g., cancelRecord to disable just
               ADM-CREATE-FIELDS.
               "Create" is currently not supported. 
               When a frame field is a SmartObject itself (for example, a 
               SmartField), disableField is run in the SmartObject to disable
               it.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcFieldType AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cEnableFields  AS CHARACTER NO-UNDO. /* Field handles. */
  DEFINE VARIABLE cEnableObjects AS CHARACTER NO-UNDO. /* Object handles */
  DEFINE VARIABLE iField         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hField         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lEnabled       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cObjectsToDisable AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hPopup         AS HANDLE     NO-UNDO.

  {get FieldsEnabled lEnabled}.
  
  IF lEnabled THEN
  DO:  
      /* CreateFields not yet supported
       IF pcFieldType = "Create":U THEN     /* Disable just Create-only fields */
        {get CreateHandles cEnableFields}.
      ELSE 
      */
      IF pcFieldType = "All":U THEN
      DO:
        &SCOPED-DEFINE xp-assign
        {get EnabledHandles cEnableFields}
        {get EnabledObjHdls cEnableObjects}
        {get EnabledObjFldsToDisable cObjectsToDisable}.
        &UNDEFINE xp-assign
        /* {get CreateHandles cCreateFields}.
           IF cCreateFields NE "":U THEN
             cEnableFields = cEnableFields + ",":U + cCreateFields.*/
      END. /* pcfieldtype =  'all' */
      
      DO iField = 1 TO NUM-ENTRIES(cEnableFields):
         hField = WIDGET-HANDLE(ENTRY(iField, cEnableFields)).
         /* "Frame Field" May be a SmartObject procedure handle */
         IF hField:TYPE = "PROCEDURE":U THEN
           RUN disableField IN hField NO-ERROR.
         ELSE IF NOT hField:HIDDEN THEN /* Skip fields hidden for multi-layout */
         DO:
           IF hField:TYPE = "EDITOR":U THEN /* Editors must be sensitive, not R-O*/
             hField:READ-ONLY = yes.  
           ELSE hField:SENSITIVE = no.     
           hPopup = {fnarg popupHandle hField}.
           IF VALID-HANDLE(hPopup) THEN
             hPopup:SENSITIVE = NO.
         END.  /* END DO NOT HIDDEN */
      END.     /* END DO iField     */
      
      /* Disable no db fields */
      IF cObjectsToDisable <> '(none)':U THEN
      DO iField = 1 TO NUM-ENTRIES(cEnableObjects):
         hField = WIDGET-HANDLE(ENTRY(iField, cEnableObjects)).
         IF hField:TYPE = "PROCEDURE":U THEN 
           cName = {fn getFieldName hField} NO-ERROR.
         ELSE 
           cName = hField:NAME.  
          
         IF cObjectsToDisable = '(All)':U OR CAN-DO(cObjectsToDisable,cName) THEN
         DO:
           /* "Frame Field" May be a SmartObject procedure handle */
           IF hField:TYPE = "PROCEDURE":U THEN
             RUN disableField IN hField NO-ERROR.
           ELSE IF NOT hField:HIDDEN THEN /* Skip fields hidden for multi-layout */
           DO:
             IF hField:TYPE = "EDITOR":U THEN /* Editors must be sensitive, not R-O*/
               hField:READ-ONLY = yes.  
             ELSE hField:SENSITIVE = no.     
             hPopup = {fnarg popupHandle hField}.
             IF VALID-HANDLE(hPopup) THEN
               hPopup:SENSITIVE = NO.
           END.  /* END DO NOT HIDDEN */
         END.
      END.     /* END DO iField     */
      
      {set fieldsEnabled no}.
  END.
  
  RUN SUPER(pcFieldType).
   
  /* In case there's a GroupAssign */
  PUBLISH 'disableFields':U FROM TARGET-PROCEDURE (pcFieldType).
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields Procedure 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     "Displays" the current row values by moving them to the frame's
               screen-values.
  Parameters:  INPUT pcColValues AS CHARACTER -- CHR(1) - delimited list of the
               BUFFER-VALUEs of the requested columns; the first entry in the
               list is the RowIdent code.
  Notes:       When a frame field is a SmartObject (for example, a
               SmartField), setDataValue is invoked in the SmartObject to set 
               its value.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE hFrameField   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iValue        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iColCount     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cFieldHandles AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowIdent     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValue        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iSecuredEntry AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hGASource     AS HANDLE     NO-UNDO.
  
   /* Used for Dynamic Combos */
  DEFINE VARIABLE cWidgetNames  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWidgetValues AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName    AS CHARACTER  NO-UNDO.

  /* Field Security Check */
  DEFINE VARIABLE cAllFieldHandles AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSecuredFields   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iFieldPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hFrameHandle     AS HANDLE    NO-UNDO.

  /* Used for RowUserProp - Row User Property functions */
  DEFINE VARIABLE cDataSourceNames   AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE cRowUserProp       AS CHARACTER      NO-UNDO.                                                             
  DEFINE VARIABLE cRowUserPropName   AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE cQualifier         AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE cUpdateTargetNames AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE hDataSource        AS WIDGET-HANDLE  NO-UNDO.
  DEFINE VARIABLE iPropLoop          AS INTEGER        NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get FieldHandles cFieldHandles}
  {get AllFieldHandles cAllFieldHandles}
  {get FieldSecurity cSecuredFields}
  {get DataSource hDataSource}
  {get GroupAssignSource hGASource}.
  &UNDEFINE xp-assign
  iColCount = NUM-ENTRIES(cFieldHandles). 
  /* Save off the row number, which is always the first value returned. */
  cRowIdent = ENTRY(1, pcColValues, CHR(1)).

  {set RowIdent cRowIdent}.
  IF cFieldHandles NE "":U THEN
  DO iValue = 1 TO iColCount:
    cValue = RIGHT-TRIM(ENTRY(iValue + 1, pcColValues, CHR(1))).
    /* A "Frame Field" may be a SmartObject procedure handle. */
    hFrameField = WIDGET-HANDLE(ENTRY(iValue,cFieldHandles)).
   
    iFieldPos = LOOKUP(STRING(hFrameField),cAllFieldHandles).
    IF hFrameField:TYPE = "PROCEDURE":U THEN
    DO:
      /* Make sure that we do not set the value of the data field here 
        for Dynamic Combos - this takes care of the flashing problems */
      IF LOOKUP("dynamicCombo":U,hFrameField:INTERNAL-ENTRIES) = 0 THEN 
      DO:
        {set DataValue cValue hFrameField}.

          /* If the SDF is hidden by security, hide it */
        IF (iFieldPos <> 0 
        AND NUM-ENTRIES(cSecuredFields)    >= iFieldPos 
        AND ENTRY(iFieldPos,cSecuredFields) = "Hidden":U) THEN
          RUN hideObject IN hFrameField NO-ERROR.
      END.
      ELSE DO:
        IF (iFieldPos <> 0 
        AND NUM-ENTRIES(cSecuredFields) >= iFieldPos 
        AND ENTRY(iFieldPos,cSecuredFields) = "Hidden":U) THEN 
        DO:
          {set Secured TRUE hFrameField}.
          RUN hideObject IN hFrameField NO-ERROR.
        END.
      END.

      {set DataModified no hFrameField}.
      
      /* Set Static SDF Values for Dynamic Combo */
      IF VALID-HANDLE(hFrameField) THEN
      DO:
        cFieldName = '':U.
        {get FieldName cFieldName hFrameField} NO-ERROR.

        IF cFieldName NE '':U THEN
        DO:
          IF cWidgetNames = "":U THEN
            ASSIGN cWidgetNames  = cFieldName
                   cWidgetValues = IF cValue = ? OR cValue = "?":U THEN "":U ELSE cValue.
          ELSE
            ASSIGN cWidgetNames  = cWidgetNames + CHR(3) + cFieldName
                   cWidgetValues = cWidgetValues + CHR(3) + (IF cValue = ? OR cValue = "?":U THEN "":U ELSE cValue).
        END.  /* if cFieldName not blank */
      END.  /* if valid sdf */
    END.
    ELSE DO:
      /* reset selection list */
      IF hFrameField:TYPE = "SELECTION-LIST":U THEN
        hFrameField:SCREEN-VALUE = "":U.

      /* Check Security for hidden fields */
      IF (iFieldPos <> 0 AND
          NUM-ENTRIES(cSecuredFields) >= iFieldPos AND
          ENTRY(iFieldPos,cSecuredFields) <> "Hidden":U) OR
          iFieldPos = 0 OR 
          cSecuredFields = "":U THEN DO:

        IF hFrameField:TYPE = "COMBO-BOX":U THEN DO:
          IF cValue = "":U THEN
             hFrameField:SCREEN-VALUE = " ":U NO-ERROR.
          ELSE
            hFrameField:SCREEN-VALUE = cValue.
        END.
        ELSE
          hFrameField:SCREEN-VALUE = 
            IF pcColValues NE ? THEN   /* If the value of the field is not ? */
               /* and it is not a logical field, use the value */
              (IF hFrameField:DATA-TYPE NE "LOGICAL":U 
               OR hFrameField:TYPE = "RADIO-SET":U THEN 
                 (IF hFrameField:TYPE = "COMBO-BOX":U AND cValue = "":U /* iz 5269 */
                     THEN " ":U ELSE cValue)
               ELSE
                 /* otherwise we have to take the entry on the appropriate side of the "/" 
                    in the field's FORMAT attribute */
                 (IF hFrameField:TYPE = "FILL-IN":U AND cValue = "?":U THEN cValue 
                  ELSE IF cValue = "yes":U THEN ENTRY(1,hFrameField:FORMAT,"/":U)
                  ELSE ENTRY(2,hFrameField:FORMAT,"/":U)))
            ELSE 
              (IF hFrameField:DATA-TYPE NE "LOGICAL":U OR hFrameField:TYPE = "RADIO-SET":U THEN "":U 
               ELSE ENTRY(2,hFrameField:FORMAT,"/":U)). 
      END.
              /* For Combos and Selection lists */
      
      hFrameField:MODIFIED = no.       /* This will be checked by update code. */
      
      IF cWidgetNames = "":U THEN
        ASSIGN cWidgetNames  = hFrameField:NAME
               cWidgetValues = IF hFrameField:SCREEN-VALUE = ? OR hFrameField:SCREEN-VALUE = "?":U THEN "":U ELSE hFrameField:SCREEN-VALUE.
      ELSE
        ASSIGN cWidgetNames  = cWidgetNames + CHR(3) +  hFrameField:NAME        
               cWidgetValues = cWidgetValues + CHR(3) + (IF hFrameField:SCREEN-VALUE = ? OR hFrameField:SCREEN-VALUE = "?":U THEN "":U ELSE hFrameField:SCREEN-VALUE).
      
    END.
  END.

  IF {fn getUseRepository} THEN 
  DO:     
    IF VALID-HANDLE(hDataSource) AND NOT VALID-HANDLE(hGASource) THEN 
    DO:
      IF {fnarg instanceOf 'SBO':U hDataSource} THEN
      DO:
        &SCOPED-DEFINE xp-assign
        {get DataSourceNames cDataSourceNames}
        {get UpdateTargetNames cUpdateTargetNames}.
        &UNDEFINE xp-assign
        IF NUM-ENTRIES(cDataSourceNames) = 1 THEN
          cQualifier = cDataSourceNames.
        ELSE IF NUM-ENTRIES(cUpdateTargetNames) = 1 THEN
          cQualifier = cUpdateTargetNames.
      END.  /* if datasource is SBO */
      cRowUserPropName = IF cQualifier > '':U THEN cQualifier + '.RowUserProp':U
                         ELSE 'RowUserProp':U.
      cRowUserProp = {fnarg columnValue cRowUserPropName hDataSource} NO-ERROR.
      DO iPropLoop = 1 TO NUM-ENTRIES(cRowUserProp,CHR(4)):
        IF ENTRY( 1 , ENTRY( iPropLoop , cRowUserProp , CHR(4) ) , CHR(3) ) = 'gsmcmauto':U THEN 
          MESSAGE ENTRY( 2 , ENTRY( iPropLoop , cRowUserProp , CHR(4) ) , CHR(3) )
          VIEW-AS ALERT-BOX INFORMATION TITLE "Comment(s) for Record".
      END.
    END.
    
    /* get lookup queries for specific data value and redisplay data */
    PUBLISH "getLookupQuery":U FROM TARGET-PROCEDURE (INPUT-OUTPUT TABLE ttLookup).
    PUBLISH "getComboQuery":U FROM TARGET-PROCEDURE (INPUT-OUTPUT TABLE ttDCombo).
    
    IF CAN-FIND(FIRST ttLookup WHERE ttLookup.hViewer = TARGET-PROCEDURE) THEN
      RUN stripLookupFields IN TARGET-PROCEDURE NO-ERROR.

    IF VALID-HANDLE(gshAstraAppserver) THEN 
    DO:
      IF (CAN-FIND(FIRST ttLookup WHERE ttLookup.hViewer = TARGET-PROCEDURE 
                                  AND   ttLookup.lRefreshQuery = TRUE) 
          OR
          CAN-FIND(FIRST ttDCombo WHERE ttDCombo.hViewer = TARGET-PROCEDURE)) THEN 
      DO:
        
        /* create copies and pass those to the server. This will at least 
           reduce data over to the AppServer if there are other lookups or 
           combo records for other viewers */
        FOR EACH ttLookup WHERE ttLookup.hViewer = TARGET-PROCEDURE:
          CREATE ttLookupCopy.
          BUFFER-COPY ttLookup TO ttLookupCopy.
          DELETE ttLookup.
        END.
        /* now move the combo records */
        FOR EACH ttDCombo WHERE ttDCombo.hViewer = TARGET-PROCEDURE:
          CREATE ttDComboCopy.
          BUFFER-COPY ttDCombo TO ttDComboCopy.
          DELETE ttDCombo.
        END.

        /* If the SDF Cache manager is running, get the data from there */
        IF VALID-HANDLE(ghSDFCacheManager) THEN
          RUN retrieveSDFCache IN ghSDFCacheManager (INPUT-OUTPUT TABLE ttLookupCopy,
                                                     INPUT-OUTPUT TABLE ttDComboCopy,
                                                     INPUT cWidgetNames,
                                                     INPUT cWidgetValues,
                                                     INPUT TARGET-PROCEDURE).
        ELSE /* Get data from server */
          RUN adm2/lookupqp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttLookupCopy,
                                                    INPUT-OUTPUT TABLE ttDComboCopy,
                                                    INPUT cWidgetNames,
                                                    INPUT cWidgetValues,
                                                    INPUT TARGET-PROCEDURE).
        
        /* Now we need to move the records back to the original temp-tables.
           First move the lookup records */
        FOR EACH ttLookupCopy:
          CREATE ttLookup.
          BUFFER-COPY ttLookupCopy TO ttLookup.
        END.
          /* now move the combo records */
        FOR EACH ttDComboCopy:
          CREATE ttDCombo.
          BUFFER-COPY ttDComboCopy TO ttDCombo.
        END.
      
        /* Now clear the temp-tables */
        EMPTY TEMP-TABLE ttLookupCopy.
        EMPTY TEMP-TABLE ttDComboCopy.
        
      END. /* can-find lookup with refresh or combo for this viewer */  
    END. /* valid-handle(gshAstraAppsrver) */
    
    /* Display Lookup query/Combo results */    
    PUBLISH "displayLookup":U FROM TARGET-PROCEDURE (INPUT TABLE ttLookup).
    PUBLISH "displayCombo":U  FROM TARGET-PROCEDURE (INPUT TABLE ttDCombo).
    
  END.

  RUN updateTitle IN TARGET-PROCEDURE.

  RUN rowDisplay IN TARGET-PROCEDURE NO-ERROR. /* Custom display checks. */

  RETURN.
 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields Procedure 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Enables fields in the ENABLED-FIELDS list (AppBuilder generated
               preprocessor.
  Parameters:  <none>
  Notes:       When the frame field is a SmartObject (for example, a 
               SmartField), enableField is run in the SmartObject.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEnableFields  AS CHARACTER NO-UNDO.  /* Field handles. */
  DEFINE VARIABLE cEnableObjects AS CHARACTER NO-UNDO. /* Object handles */
  DEFINE VARIABLE iField         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hField         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lEnabled       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cState         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cNewRecord     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUpdateTarget  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hGASource      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hFrameHandle   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hPopup         AS HANDLE     NO-UNDO.
  
  /* Field Security Check */
  DEFINE VARIABLE cAllFieldHandles AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSecuredFields   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iFieldPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cObjectsToDisable AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cName            AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get FieldsEnabled lEnabled}
  {get GroupAssignSource hGASource}
  {get AllFieldHandles cAllFieldHandles}
  /* Get Secured Fields */
  {get FieldSecurity cSecuredFields}.
  &UNDEFINE xp-assign
  
  /* Check the record state in the GA source to avoid timing problems
     when this method is called from queryPosition.
     The NewRecord value is not even propagated to GroupAssign-Target(s). */
  IF VALID-HANDLE(hGASource) THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get RecordState cState hGASource}
    {get NewRecord cNewRecord hGASource}
    {get UpdateTarget cUpdateTarget hGaSource}.
    &UNDEFINE xp-assign
  END.
  ELSE
  DO:
    &SCOPED-DEFINE xp-assign
    {get RecordState cState}
    {get NewRecord cNewRecord}
    {get UpdateTarget cUpdateTarget}.
    &UNDEFINE xp-assign
  END.
  
  IF  (NOT lEnabled) 
  AND (cUpdateTarget NE "":U) 
  AND (cState = "RecordAvailable":U OR cNewRecord NE "No":U) THEN     
  DO:  
    &SCOPED-DEFINE xp-assign
    {get EnabledHandles cEnableFields}
    {get EnabledObjHdls cEnableObjects}
    {get EnabledObjFldsToDisable cObjectsToDisable}.
    &UNDEFINE xp-assign
    DO iField = 1 TO NUM-ENTRIES(cEnableFields):
      ASSIGN 
        hField    = WIDGET-HANDLE(ENTRY(iField, cEnableFields))      
        iFieldPos = LOOKUP(STRING(hField),cAllFieldHandles).
      
      IF VALID-HANDLE(hField) THEN 
      DO:
        /* "Frame Field" May be a SmartObject procedure handle */
        IF hField:TYPE = "PROCEDURE":U THEN 
        DO:
          IF ((iFieldPos <> 0 
               AND NUM-ENTRIES(cSecuredFields) >= iFieldPos 
               AND ENTRY(iFieldPos,cSecuredFields) = "":U) 
              OR iFieldPos = 0) 
             OR cSecuredFields = "":U THEN 
            /* Check Security */
            RUN enableField IN hField NO-ERROR.
          ELSE DO:  
            IF ENTRY(iFieldPos,cSecuredFields) = "Hidden":U THEN
              RUN hideObject IN hField NO-ERROR.
            ELSE 
              RUN disableField IN hField NO-ERROR.
          END.  /* else do - secured */
        END.  /* If Handle type is PROCEDURE */
        ELSE IF NOT hField:HIDDEN THEN /* Skip fields hidden for multi-layout */
        DO:
           /* Check Security */
          IF ((iFieldPos <> 0 
               AND NUM-ENTRIES(cSecuredFields) >= iFieldPos
               AND ENTRY(iFieldPos,cSecuredFields) = "":U) 
              OR iFieldPos = 0) 
             OR cSecuredFields = "":U THEN 
          DO:
            hField:SENSITIVE = YES.
            IF hField:TYPE = "EDITOR":U THEN /* Ed's must be sensitive, not R-O*/
              hField:READ-ONLY = NO.     
            /* don't enable if read-only (can-query is ok as only fields can 
               have popups) */
            IF CAN-QUERY(hField,'read-only':U) AND NOT hField:READ-ONLY THEN
            DO:
              hPopup = {fnarg popupHandle hField}.
              IF VALID-HANDLE(hPopup) THEN
                hPopup:SENSITIVE = YES.
            END.
         END.  /* IF security check succeeds */
        END.  /* If the field is not hidden */
      END.  /* If hField is a valid handle */
    END.  /* Looping through the fields */
    /* Enable no db fields */
    IF cObjectsToDisable <> '(none)':U THEN
    DO iField = 1 TO NUM-ENTRIES(cEnableObjects):
      hField = WIDGET-HANDLE(ENTRY(iField, cEnableObjects)).      
      IF hField:TYPE = "PROCEDURE":U THEN 
        cName = {fn getFieldName hField} NO-ERROR.
      ELSE 
        cName = hField:NAME.  
      IF cObjectsToDisable = '(All)':U OR CAN-DO(cObjectsToDisable,cName) THEN
      DO:      
        iFieldPos = 0.
        iFieldPos = LOOKUP(STRING(hField),cAllFieldHandles).     
        IF VALID-HANDLE(hField) THEN DO:  
          /* "Frame Field" May be a SmartObject procedure handle */
          IF hField:TYPE = "PROCEDURE":U THEN 
          DO:          
            IF ((iFieldPos <> 0 
                 AND NUM-ENTRIES(cSecuredFields) >= iFieldPos 
                 AND ENTRY(iFieldPos,cSecuredFields) = "":U) 
                OR iFieldPos = 0) 
               OR cSecuredFields = "":U THEN /* Check Security */
              RUN enableField IN hField NO-ERROR.
            ELSE DO:
              IF ENTRY(iFieldPos,cSecuredFields) = "Hidden":U THEN
                RUN hideObject IN hField NO-ERROR.
              ELSE 
                RUN disableField IN hField NO-ERROR.
            END.
          END.
          ELSE IF NOT hField:HIDDEN THEN /* Skip fields hidden for multi-layout */
          DO:
            /* Check Security */
            IF ((iFieldPos <> 0 
                 AND NUM-ENTRIES(cSecuredFields) >= iFieldPos 
                 AND ENTRY(iFieldPos,cSecuredFields) = "":U) 
                OR iFieldPos = 0) 
               OR cSecuredFields = "":U THEN 
            DO:
              hField:SENSITIVE = YES.
              IF hField:TYPE = "EDITOR":U THEN /* Ed's must be sensitive, not R-O*/
                hField:READ-ONLY = NO.
             /* don't enable if read-only (can-query is ok as only fields can 
                have popups) */
              IF CAN-QUERY(hField,'read-only':U) AND NOT hField:READ-ONLY THEN
              DO:
                hPopup = {fnarg popupHandle hField}.
                IF VALID-HANDLE(hPopup) THEN
                  hPopup:SENSITIVE = YES.
              END.
            END.  /* If security check succeeds */
          END.  /* If the field isn't hidden */
        END.  /* IF it is a valid field */
      END.
    END.  /* Do for all enabled objects */

    /* If the list of enabled field handles isn't set, it may because this
       object hasn't been fully initialized yet. So don't set the enabled
       flag because we may be through here again. */
    IF cEnableFields NE "":U THEN
      {set FieldsEnabled yes}.
  END.
  ELSE /* Ensure that SDF fields is disabled if no record available */
  IF (NOT lEnabled) AND (cUpdateTarget NE "":U) AND (cState = "NoRecordAvailable":U) THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get EnabledHandles cEnableFields}
    {get EnabledObjHdls cEnableObjects}
    {get EnabledObjFldsToDisable cObjectsToDisable}.
    &UNDEFINE xp-assign
    DO iField = 1 TO NUM-ENTRIES(cEnableFields):
      ASSIGN
        hField    = WIDGET-HANDLE(ENTRY(iField, cEnableFields))       
        iFieldPos = 0
        iFieldPos = LOOKUP(STRING(hField),cAllFieldHandles).
       
      IF VALID-HANDLE(hField) THEN 
      DO:
        /* "Frame Field" May be a SmartObject procedure handle */
        IF hField:TYPE = "PROCEDURE":U THEN
          RUN disableField IN hField NO-ERROR.
        ELSE IF NOT hField:HIDDEN THEN /* Skip fields hidden for multi-layout */
        DO:
          IF hField:TYPE = "EDITOR":U THEN /* Editors must be sensitive, not R-O*/
            hField:READ-ONLY = yes.  
          ELSE 
            hField:SENSITIVE = NO.     
          hPopup = {fnarg popupHandle hField}.
          IF VALID-HANDLE(hPopup) THEN
            hPopup:SENSITIVE = NO.
        END.  /* END DO NOT HIDDEN */
      END.  /* If hField is valid */
    END.     /* END DO iField     */
    
    IF cObjectsToDisable <> '(none)':U THEN
    DO iField = 1 TO NUM-ENTRIES(cEnableObjects):
      hField = WIDGET-HANDLE(ENTRY(iField, cEnableObjects)).
      IF hField:TYPE = "PROCEDURE":U THEN 
        cName = {fn getFieldName hField} NO-ERROR.
      ELSE 
        cName = hField:NAME.  
      IF cObjectsToDisable = '(All)':U OR CAN-DO(cObjectsToDisable,cName) THEN
      DO:   
        ASSIGN 
          iFieldPos = 0
          iFieldPos = LOOKUP(STRING(hField),cAllFieldHandles).
        
        IF VALID-HANDLE(hField) THEN 
        DO:
          /* "Frame Field" May be a SmartObject procedure handle */
          IF hField:TYPE = "PROCEDURE":U THEN
            RUN disableField IN hField NO-ERROR.
          ELSE IF NOT hField:HIDDEN THEN /* Skip fields hidden for multi-layout */
          DO:
            IF hField:TYPE = "EDITOR":U THEN /* Editors must be sensitive, not R-O*/
              hField:READ-ONLY = YES.  
            ELSE 
              hField:SENSITIVE = NO.   
            hPopup = {fnarg popupHandle hField}.
            IF VALID-HANDLE(hPopup) THEN
              hPopup:SENSITIVE = NO.
          END.  /* END DO NOT HIDDEN */
        END.  /* If a valid handle */
      END.
    END.  /* END DO iField     */
  END.  /* Disbling SDF if not data available */ 
  RUN SUPER.

  PUBLISH 'enableFields':U FROM TARGET-PROCEDURE.  /* In case of GroupAssign */
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fieldModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fieldModified Procedure 
PROCEDURE fieldModified :
/*------------------------------------------------------------------------------
  Purpose: Run whenever a field is modified. 
           Sets DataModified  to true unless the ModifyFields property is 
           specifed to ignore this field. 
 Paramter: Handle of the field whose value has changed 
    Notes: The passed field must be in the list of EnabledFields or 
           EnabledObjFlds.
         - Called from valueChanged or SDF's setDataModified or Client APIs that
           changes widget values.       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER phField AS HANDLE     NO-UNDO.

    DEFINE VARIABLE lSetModified     AS LOGICAL    NO-UNDO.
    
    DEFINE VARIABLE cEnabledHandles  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cEnabledFields   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cEnabledObjHdls  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cEnabledObjFlds  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iFld             AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cName            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cModifyFields    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hUpdateTarget    AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cUpdatableCols   AS CHARACTER  NO-UNDO.    
    DEFINE VARIABLE lResult          AS LOGICAL    NO-UNDO.    
    DEFINE VARIABLE hGASource        AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hUpdateSource    AS HANDLE     NO-UNDO.

    IF NOT VALID-HANDLE(phField) THEN 
      RETURN.
    
    /* if modified is set already just return */ 
    {get DataModified lResult}.
    IF lResult THEN 
      RETURN.
    
    /* Return if the object's not enabled for input.*/
    {get FieldsEnabled lResult}. 
    IF NOT lResult THEN 
      RETURN.

    {get ModifyFields cModifyFields}.
    
    /* Return if no fields should set DataModified.*/ 
    IF cModifyFields = '(None)':U THEN
      RETURN.
    
    /* If for some reason ModifyFields is not set, set default = (all) */ 
    IF cModifyFields = '':U OR cModifyFields = ? THEN
      cModifyFields = '(All)':U.
    
    {get EnabledHandles cEnabledHandles}.

    iFld = LOOKUP(STRING(phField),cEnabledHandles).
    IF iFld > 0 THEN 
    DO:
      /* One of the EnabledFields has changed so (All) or (EnabledFields) 
         should set DataModified */
      IF cModifyFields = '(All)':U OR cModifyFields = '(EnabledFields)':U THEN
        lSetModified = TRUE.
      ELSE DO:
        /* get the name of the EnabledField */ 
        {get EnabledFields cEnabledFields}.
        cName = ENTRY(iFld,cEnabledFields).
        /* if (updatable) check if the name is updatable in the updateTarget */
        IF cModifyFields = '(Updatable)':U THEN
        DO:
          /* The UpdateTarget is only linked as the upper GA source, so find the
             real UpdateSource by looping up the GroupAssignSource link chain. */         
          hGASource = TARGET-PROCEDURE. 
          DO WHILE VALID-HANDLE(hGASource):
            hUpdateSource = hGASource.
            {get GroupAssignSource hGASource hUpdateSource}.
          END.
          {get UpdateTarget hUpdateTarget hUpdateSource}.
          IF VALID-HANDLE(hUpdateTarget) THEN
          DO:
            {get UpdatableColumns cUpdatableCols hUpdateTarget}.
            IF LOOKUP(cName,cUpdatableCols) > 0 THEN
              lSetModified = TRUE.
          END.
        END. /* if ModifyFields (Updatable) */
        /* Check if ModifyFields has a list of fields that includes this name */
        ELSE IF LOOKUP(cName,cModifyFields) > 0 THEN
          lSetModified = TRUE.
      END. /* else - NOT '(all)' or '(EnabledFields)' */
    END. /* ifld > 0 (lookup(phField,EnabledHandles) */
    ELSE DO: /* field not found in enabledHandles */
      {get EnabledObjHdls cEnabledObjHdls}.
      iFld = LOOKUP(STRING(phField),cEnabledObjHdls).
      IF iFld > 0 THEN
      DO:
        /* '(All)' means that also local fields should set DataModified*/
        IF cModifyFields = '(All)':U THEN
          lSetModified = TRUE.
         /* else check if the property has a list of objects to modify */    
        ELSE DO:
          {get EnabledObjFlds cEnabledObjFlds}.
          cName = ENTRY(iFld,cEnabledObjFlds).
          IF LOOKUP(cName,cModifyFields) > 0 THEN
            lSetModified = TRUE.
        END.
      END. /* ifld > 0 (lookup(phField,EnabledObjHdls) */
    END. /* else (field not found in enabledHandles) */
    
    IF lSetModified THEN 
      {set DataModified yes}.
   
  RETURN. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Initialization code specific to SmartDataViewers. 
  Parameters:  <none>
  Notes:       Reads through list of enabled and displayed fields and
               gets their handles to store in FieldHandles and EnabledHandles
               properties.
------------------------------------------------------------------------------*/

 DEFINE VARIABLE hFrameField        AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cFieldHandles      AS CHARACTER NO-UNDO INIT "":U.
 DEFINE VARIABLE cEnabledHandles    AS CHARACTER NO-UNDO INIT "":U.
 DEFINE VARIABLE cEnabledFields     AS CHARACTER NO-UNDO INIT "":U.
 DEFINE VARIABLE cDisplayedFields   AS CHARACTER NO-UNDO INIT "":U.
 DEFINE VARIABLE cCreateHandles     AS CHARACTER NO-UNDO INIT "":U.
 DEFINE VARIABLE hUpdateTarget      AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cTarget            AS CHARACTER NO-UNDO.
 DEFINE VARIABLE hContainerHandle   AS HANDLE    NO-UNDO.
 DEFINE VARIABLE lSaveSource        AS LOGICAL   NO-UNDO.
 DEFINE VARIABLE hGaSource          AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cGaMode            AS CHARACTER NO-UNDO.
 DEFINE VARIABLE iField             AS INTEGER   NO-UNDO.
 DEFINE VARIABLE cFieldName         AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cTableName         AS CHARACTER NO-UNDO.
 DEFINE VARIABLE hFrameProc         AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cUIBMode           AS CHARACTER NO-UNDO.
 DEFINE VARIABLE iSDFLoop           AS INTEGER   NO-UNDO.
 DEFINE VARIABLE cContainerTargets  AS CHARACTER NO-UNDO.
 DEFINE VARIABLE hSDFHandle         AS HANDLE    NO-UNDO.
 DEFINE VARIABLE hSDFFrameHandle    AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cNewRecord         AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cUpdateTargetNames AS CHARACTER  NO-UNDO.

 RUN SUPER.            /* Invoke the standard behavior first. */

 IF RETURN-VALUE = "ADM-ERROR":U
    THEN RETURN "ADM-ERROR":U.      

 &SCOPED-DEFINE xp-assign
 {get EnabledFields cEnabledFields}
 {get UIBMode cUIBMode}.
 &UNDEFINE xp-assign

 /* UIBmode gives errors because handles for SDFs is not added */ 
 IF (cUIBMode BEGINS 'Design':U) THEN
 DO:
   /* If there are NO enabled fields, don't let the viewer be an */
   /* Update-Source or TableIO-Target. */
   IF cEnabledFields = "":U THEN
   DO:
       RUN modifyListProperty IN TARGET-PROCEDURE
           (TARGET-PROCEDURE, "REMOVE":U,"SupportedLinks":U,"Update-Source":U).
       RUN modifyListProperty IN TARGET-PROCEDURE
           (TARGET-PROCEDURE, "REMOVE":U,"SupportedLinks":U,"TableIO-Target":U).
   END.   /* END DO cEnabled "" */

   RETURN.
 END.

 &SCOPED-DEFINE xp-assign
 {get UpdateTarget cTarget}
  
  /* Initialize the list of handles of the frame fields that are for
     database fields, for displayFields and update-record to use. 
     Also set a similar list of the field names for update-record to use. 
     Also a list of Enabled Field handles for enable/disableFields,
       and a list of any fields to be enabled for Create. */
  /*   Note: CreateFields not yet supported. 
  hUpdateTarget = WIDGET-HANDLE(cTarget).
  IF VALID-HANDLE(hUpdateTarget) THEN
    {get CreateFields cCreateFields hUpdateTarget}.  
  */ 
  {get ContainerHandle hContainerHandle}
  {get DisplayedFields cDisplayedFields}
  {get UpdateTargetNames cUpdateTargetNames}.
  &UNDEFINE xp-assign

  cContainerTargets = DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, "Container-Target":U) NO-ERROR.

  ASSIGN hFrameField = hContainerHandle  
         hFrameField = hFrameField:FIRST-CHILD    /* Field Group */
         hFrameField = hFrameField:FIRST-CHILD.   /* First actual field. */
         
  /* A "Frame Field" may in fact be a SmartObject procedure handle. Check this
     and retrieve the object's FieldName property. */

  /* Initialise the variables to an empty CSV list.
     We need to be absolutely sure that the order of the lists of handles
     matches the order of the DisplayedField and EnabledField properties,
     so we initialise a string with the correct number of entries, and
     we will make sure that the handle matches the column name.             */
  ASSIGN cEnabledHandles = FILL(",":U, NUM-ENTRIES(cEnabledFields)   - 1)
         cFieldHandles   = FILL(",":U, NUM-ENTRIES(cDisplayedFields) - 1)
         .
 
  DO WHILE VALID-HANDLE(hFrameField):
    /* Check for existance of SDFs */
    IF  hFrameField:TYPE = "FRAME":U AND cContainerTargets <> "":U THEN 
    DO:
      /* To move away from reading the procedure handle from the 
         frame's PRIVATE-DATA we are checking that the FRAME we
         are reading is indeed that of an SDF and that the handle
         of this FRAME is one of the SDF's found from the Container 
         Target list. This checks that we are assigning the handle 
         of the current frame's procedure handle and not any other
         SDF's that might be on the viewer. */
      SDF_LOOP:
      DO iSDFLoop = 1 TO NUM-ENTRIES(cContainerTargets):
        hSDFHandle = WIDGET-HANDLE(ENTRY(iSDFLoop,cContainerTargets)).
        IF VALID-HANDLE(hSDFHandle) THEN
          hSDFFrameHandle = DYNAMIC-FUNCTION("getContainerHandle":U IN hSDFHandle) NO-ERROR.
        IF hFrameField = hSDFFrameHandle THEN DO:
          hFrameProc = hSDFHandle.
          LEAVE SDF_LOOP.
        END.
      END.
      /* We rely on the fact that FieldName becomes unknown if this is a 
         SmartFrame (unsupported) to avoid it messing up the list */ 
      IF VALID-HANDLE(hFrameProc) THEN
        ASSIGN cFieldName = DYNAMIC-FUNCTION('getFieldName' IN hFrameProc) NO-ERROR.
      ELSE 
        cFieldName = ?.
    END.
    ELSE  
    DO:
        ASSIGN hFrameProc = ?.   /* Signal no SMo here */
        /* As of 9.1B, the DisplayedFields can be qualified by
         * the SDO Objectname if it's not just RowObject. */

        /* In 9.1C, when a widget is dynamic, the :TABLE attribute is not set
         * for widgets on a frame. The table name should thus be stored in the
         * private-data of the widget in the format "TableName,<table-name>"    */
        IF hFrameField:DYNAMIC THEN
        DO:
            IF LOOKUP("TableName":U, hFrameField:PRIVATE-DATA) > 0 THEN
                ASSIGN cTableName = ENTRY(LOOKUP("TableName":U, hFrameField:PRIVATE-DATA) + 1, hFrameField:PRIVATE-DATA).
        END.    /* dynamic widget */
        ELSE DO:
          IF CAN-QUERY(hFrameField,"TABLE":U) THEN
            ASSIGN cTableName = hFrameField:TABLE.
        END.

        /* Dynamic viewers built on SBOs will have a blank table name, since the SDO instance-name will
         * be part of the field's name.                                                                */
        ASSIGN cFieldName = (IF NOT CAN-DO("RowObject,":U, cTableName) THEN 
                               cTableName + ".":U ELSE "":U) + hFrameField:NAME.
    END.    /* not a SDF */

    IF cFieldName NE ? AND LOOKUP(cFieldName, cDisplayedFields) NE 0 THEN
    DO:
      /* Displayed Fields */
      ENTRY(LOOKUP(cFieldName, cDisplayedFields), cFieldHandles) = (IF hFrameProc EQ ? THEN 
        STRING(hFrameField) ELSE STRING(hFrameProc)).

      /* Enabled Fields */
      iField = LOOKUP(cFieldName, cEnabledFields).
      IF iField > 0 THEN
      DO:
        IF INDEX(cFieldName, '.':U) > 0 THEN 
        DO:   /* remove enabled DB fields that do not have an UpdateTarget */
          cTarget = ENTRY(1, cFieldName, '.':U).
          IF NOT LOOKUP(cTarget, cUpdateTargetNames) > 0 THEN
            ASSIGN
              cEnabledFields = DYNAMIC-FUNCTION ('deleteEntry':U IN TARGET-PROCEDURE, iField, cEnabledFields, ",":U) 
              cEnabledHandles = DYNAMIC-FUNCTION ('deleteEntry':U IN TARGET-PROCEDURE, iField, cEnabledHandles, ",":U). 
          ELSE
            ENTRY(iField, cEnabledHandles) = (IF hFrameProc EQ ? THEN 
                                                STRING(hFrameField) 
                                              ELSE 
                                                STRING(hFrameProc)).
        END.
        ELSE
          ENTRY(iField, cEnabledHandles) = (IF hFrameProc EQ ? THEN 
                                              STRING(hFrameField) 
                                            ELSE 
                                              STRING(hFrameProc)).
      END.
    END.    /* END DO IF LOOKUP */
    hFrameField = hFrameField:NEXT-SIBLING.
  END.      /* END DO WHILE     */
  
  /* After invalid handles have been stripped, set the properties */
  &SCOPED-DEFINE xp-assign
  {set EnabledFields cEnabledFields}
  {set EnabledHandles cEnabledHandles}
  {set CreateHandles cCreateHandles}
  {set FieldHandles cFieldHandles}
  {get GroupAssignSource hGASOurce}.
  &UNDEFINE xp-assign

  RUN dataAvailable IN TARGET-PROCEDURE (?). /* See if there's a rec waiting. */
  
  /* Is this a GaTarget, if so get SaveSOurce, FieldsEnabled and NewRecord from the 
     GA source so we can find out whether we should be enabled (further down) or 
     display the current record 
     (if the GASource is in "Add" or "Copy" mode already */
  IF VALID-HANDLE(hGaSource) THEN
  DO:
    {get ObjectMode cGaMode hGaSource}.
    /* The NewRecord is only set at the tableioTarget yet, 
        so check through a potential GroupAssingSource link chain. */ 
    DO WHILE VALID-HANDLE(hGASource):
      &SCOPED-DEFINE xp-assign
      {get NewRecord cNewRecord hGASource}
      {get GroupAssignSource hGASource hGASource}.
      &UNDEFINE xp-assign
    END.
    /* synchronize the NewRecord value with our GA-Source */
    {set NewRecord cNewRecord}.

    IF cNewRecord <> "NO":U THEN
      RUN displayRecord IN TARGET-PROCEDURE.
  END.
  ELSE
    {get SaveSource lSaveSource}.
  
  /* If we have NO tableio-source (?) or a Tableio-Source in Save mode 
     OR if our groupAssign-source is not in view mode the target also should be,
    (that would have been the case if this GAtarget had been initialized) */  
  IF (cGaMode > '':U AND cGaMode <> "view":U)
  OR NOT (lSaveSource = FALSE) THEN
    RUN enableFields IN TARGET-PROCEDURE.
  
  ELSE 
  DO:
    {set FieldsEnabled YES}.
    RUN disableFields IN TARGET-PROCEDURE ('ALL':U).
  END.         /* END ELSE DO IF not enableFields */
      

  /* Ensure only has entries for this viewer */
  EMPTY TEMP-TABLE ttComboData.
  
  /* gather all master combo queries */
  PUBLISH "getComboQuery":U FROM TARGET-PROCEDURE (INPUT-OUTPUT TABLE ttComboData).  

  /* build combo list-item pairs */
  IF VALID-HANDLE(gshAstraAppserver) AND CAN-FIND(FIRST ttComboData) THEN
    RUN adm2/cobuildp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttComboData).
  
  /* populate all master combos */          
  PUBLISH "buildCombo":U FROM TARGET-PROCEDURE (INPUT TABLE ttComboData).
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkState Procedure 
PROCEDURE linkState :
/*------------------------------------------------------------------------------
  Purpose:     Receives messages when a GroupAssignTarget becomes
               "active" (normally when it's viewed) or "inactive" (Hidden).
  Parameters:  pcState AS CHARACTER -- 'active'/'inactive'
               The event is republished up the groupAssignSource and
               the DataSource     
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState  AS CHARACTER NO-UNDO.
  
  PUBLISH 'linkState':U FROM TARGET-PROCEDURE (pcState). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkStateHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkStateHandler Procedure 
PROCEDURE linkStateHandler :
/*------------------------------------------------------------------------------
  Purpose: Override to synchronize GATargets 
  Parameters: pcstate -
                add,remove,inactive,active
              phObject - object to link to 
              pcLink   - Linkname (data-source)      
  Notes:   The SDO only calls this with 'inactive' when all data targets
           that have a GaSOurce is hidden, using the getGroupAssingHidden
           read-only property.    
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phObject  AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcLink    AS CHARACTER  NO-UNDO.
 
  DEFINE VARIABLE cTargets AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTarget  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iTarget  AS INTEGER    NO-UNDO.

  IF pcLink = 'DataSource':U AND pcState ='Add':U THEN
  DO:
     /* Some DataSources do not yet support this property     */
     /* (ie SBO, passThru links thru containers etc.).        */
     /* Must be reviewed for complete solution                */
     {set FetchAutoComment TRUE phObject} NO-ERROR.
  END.
  
  RUN SUPER(pcState,phObject,pcLink).
  
  IF CAN-DO('ACTIVE,INACTIVE':U,pcState) AND pcLink = 'DataSource':U THEN
  DO:
    {get GroupAssignTarget cTargets}.

    DO iTarget = 1 TO NUM-ENTRIES(cTargets):
      hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)).
      RUN LinkStateHandler IN hTarget(pcState,phObject,pcLink).
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-locateWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE locateWidget Procedure 
PROCEDURE locateWidget :
/*------------------------------------------------------------------------------
  Purpose:     Locates a widget and retuns its handle and the handle of its
               TARGET-PROCEDURE
  Parameters:  pcWidget AS CHARACTER
               phWidget AS HANDLE
               phTarget AS HANDLE
  Notes:       Contains code to locate a widget specific to viewers's when 
               the qualifier is 'Browse'
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcWidget AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER phWidget AS HANDLE     NO-UNDO.
DEFINE OUTPUT PARAMETER phTarget AS HANDLE     NO-UNDO.

DEFINE VARIABLE cDataTargets  AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cField        AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cObjectType   AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cQualifier    AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE hDataSource   AS HANDLE     NO-UNDO. 
DEFINE VARIABLE hDataTarget   AS HANDLE     NO-UNDO. 
DEFINE VARIABLE iDataTargets  AS INTEGER    NO-UNDO.
DEFINE VARIABLE lBrowsed      AS LOGICAL    NO-UNDO. 

  IF NUM-ENTRIES(pcWidget, '.':U) > 1 AND ENTRY(1, pcWidget, '.':U) = 'Browse':U THEN
  DO:
    cField = DYNAMIC-FUNCTION('deleteEntry':U IN TARGET-PROCEDURE,
                               INPUT 1,
                               INPUT pcWidget,
                               INPUT '.':U). 
    {get DataSource hDataSource}.
    IF VALID-HANDLE(hDataSource) THEN
    DO:
      {get DataQueryBrowsed lBrowsed hDataSource}.
      /* If the qualifier is Browse and the data source does not have a
         browser data target, then there is no need to search further. */
      IF cQualifier BEGINS 'Browse':U AND NOT lBrowsed THEN RETURN.

      {get DataTarget cDataTargets hDataSource}.
      DO iDataTargets = 1 TO NUM-ENTRIES(cDataTargets):
        ASSIGN hDataTarget = WIDGET-HANDLE(ENTRY(iDataTargets, cDataTargets)) NO-ERROR.
        IF VALID-HANDLE(hDataTarget) AND hDataTarget NE TARGET-PROCEDURE THEN
        DO:
         {get ObjectType cObjectType hDataTarget}.
         IF cObjectType = 'SmartDataBrowser':U THEN
           ASSIGN 
             phWidget = DYNAMIC-FUNCTION('internalWidgetHandle':U IN hDataTarget,
                                          INPUT cField, INPUT 'DATA':U)
             phTarget = hDataTarget NO-ERROR.
           IF phWidget NE ? THEN RETURN.
        END.  /* if valid data target */
      END.  /* do iLoop to number data targets */
    END.  /* if valid data source */
  END.  /* if browser qualifier */
  ELSE RUN SUPER (INPUT pcWidget, OUTPUT phWidget, OUTPUT phTarget).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-stripLookupFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE stripLookupFields Procedure 
PROCEDURE stripLookupFields :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will check all the lookups in the current viewer
               and try to get the displayed fields and linked field values from
               it's data source before attempting to fetch the data from the 
               query on the server.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iDataLoop            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cField               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataSource          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTablesInQ           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSources         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMappedFields        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWidgetName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cViewerLinkedWidgets AS CHARACTER  NO-UNDO.
  {get DataSource hDataSource}.
  
  /* If we don't have a valid Data Source then leave */
  IF NOT VALID-HANDLE(hDataSource) THEN
    RETURN.

  /* Get a list of tables in the Data Source */
  cTablesInQ = DYNAMIC-FUNCTION("getTables":U IN hDataSource) NO-ERROR.
  
  cDataSources = "":U.
  /* Check if our Data Source is an SBO */
  IF cTablesInQ = ? OR
     cTablesInQ = "?":U THEN DO:
    DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.
    {get ContainerSource hContainer}.
    cDataSources = DYNAMIC-FUNCTION("getContainedDataObjects":U IN hDataSource).
  END.
  ELSE
    cDataSources = STRING(hDataSource).

  DO iDataLoop = 1 TO NUM-ENTRIES(cDataSources):
    hDataSource = WIDGET-HANDLE(ENTRY(iDataLoop,cDataSources)).
    IF NOT VALID-HANDLE(hDataSource) THEN
      NEXT.
    
    /* Get a list of tables in the Data Source */
    cTablesInQ = DYNAMIC-FUNCTION("getTables":U IN hDataSource) NO-ERROR.
    /* We need to do this to ensure that we do not think that the
     fields available in the data source is available for our 
     lookup since the data source might be the exact same table
     as the table the lookup is using - e.g. Object type maint with
     a lookup on object type of extends_object_type_obj would result
     in the lookup thinking it's got the object type of the extends_objec_type
     lookup */

    FOR EACH  ttLookup
        WHERE ttLookup.hViewer = TARGET-PROCEDURE
        EXCLUSIVE-LOCK: /* This is for the sake of consistency */
      
      ASSIGN ttLookup.lRefreshQuery    = FALSE
             ttLookup.cFoundDataValues = "":U.
      
      /* First check if we have the MappedField property specified */
      cMappedFields = DYNAMIC-FUNCTION("getMappedFields":U IN ttLookup.hWidget) NO-ERROR.
      
      IF ERROR-STATUS:ERROR OR 
         cMappedFields = ? OR
         cMappedFields = "?":U THEN
        cMappedFields = "":U NO-ERROR.
      IF cMappedFields <> "":U THEN
      DO:
        /* The field list has the following order:
           1. Key Field,
           2. Displayed Field,
           3. Linked Fields */
        /* The MappedFields propery will also always include the displayed field
           and is marked as <Displayed Field> */
        
        /* Let's first set the value of the KeyField */
        cValue = DYNAMIC-FUNCTION("getDataValue":U IN ttLookup.hWidget) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          cValue = "":U.
        ttLookup.cFoundDataValues = cValue.

        /* Now we will get the displayed field's value */
        cField = ENTRY(LOOKUP("<Displayed Field>",cMappedFields) - 1,cMappedFields) NO-ERROR.
        IF ERROR-STATUS:ERROR OR
           cField = "":U OR
           cField = ?    OR
           cField = "?" THEN
          ASSIGN cField = "":U
                 cValue = ?.
        IF cField <> "":U THEN
          cValue = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hDataSource,cField)) NO-ERROR.
        
        /* The field could not be found in the Data Source */
        IF cValue = ? THEN
        DO:
          ttLookup.lRefreshQuery = TRUE.
          RETURN.
        END.
        
        /* Add the displayed field's value */
        ttLookup.cFoundDataValues = ttLookup.cFoundDataValues +
                                    CHR(1) + cValue.
        /* First check if we need to get more data - possible linked fields */
        IF NUM-ENTRIES(RIGHT-TRIM(ttLookup.cFieldList,",":U)) <= 2 THEN 
        DO:
          ttLookup.lRefreshQuery = FALSE.
          RETURN.
        END.
        
        cViewerLinkedWidgets = DYNAMIC-FUNCTION("getViewerLinkedWidgets":U IN ttLookup.hWidget) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          cViewerLinkedWidgets = "":U.

        /* If we don't have linked widgets but we have more than just 2 fields
           in the field list then our data is corrupt - rather get out here 
           and let the normal process continue as normal */
        IF cViewerLinkedWidgets = "":U THEN
        DO:
          ttLookup.lRefreshQuery = TRUE.
          RETURN.
        END.
        /* We are working on the assumtion that ViewerLinkedFields and
           ViewerLinkedWidgets are in the same order */
        DO iLoop = 3 TO NUM-ENTRIES(ttLookup.cFieldList):
          cWidgetName = ENTRY(iLoop - 2,cViewerLinkedWidgets) NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
          DO:
            ttLookup.lRefreshQuery = TRUE.
            RETURN.
          END.
          /* Get the Data Source field */
          cField = ENTRY(LOOKUP(cWidgetName,cMappedFields) - 1,cMappedFields) NO-ERROR.
          IF ERROR-STATUS:ERROR OR
             cField = "":U OR 
             cField = "?":U OR 
             cField = ? THEN
          DO:
            ttLookup.lRefreshQuery = TRUE.
            RETURN.
          END.
          /* Get the Data Source field value */
          IF cField <> "":U THEN
            cValue = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hDataSource,cField)) NO-ERROR.

          /* The field could not be found in the Data Source */
          IF cValue = ? THEN
          DO:
            ttLookup.lRefreshQuery = TRUE.
            RETURN.
          END.
          /* Add the field's value */
          ttLookup.cFoundDataValues = ttLookup.cFoundDataValues +
                                      CHR(1) + cValue.
        END.
      END. /* MappedFields specified */
      ELSE
      DO:
        /* If we do not have mapped fields specified - do the asumption */
        cFieldName = IF NUM-ENTRIES(ttLookup.cWidgetName,".":U) > 1 THEN ENTRY(2,ttLookup.cWidgetName,".":U) ELSE ttLookup.cWidgetName.
        FIELD_LOOP:
        DO iLoop = 1 TO NUM-ENTRIES(ttLookup.cFieldList):
          ASSIGN cField = ENTRY(iLoop,ttLookup.cFieldList).
          IF cField = "":U THEN
            NEXT FIELD_LOOP.
          IF NUM-ENTRIES(cField,".":U) > 1 THEN DO:
            IF ENTRY(1,cField,".":U) = ENTRY(1,cTablesInQ) AND 
               NUM-ENTRIES(cDataSources) = 1 THEN DO:
              ttLookup.lRefreshQuery = TRUE.
              RETURN.
            END.
          END.
    
          /* Check if the field we are looking for is infact from the table used 
             in the lookup */
          IF NUM-ENTRIES(cField,".":U) > 1 AND iDataLoop = 1 THEN DO:
            IF DYNAMIC-FUNCTION("columnTable":U IN hDataSource,ENTRY(2,cField,".")) = ENTRY(1,cTablesInQ) AND
               cFieldName <> ENTRY(2,cField,".") AND
               NUM-ENTRIES(cDataSources) = iDataLoop THEN DO:
              ttLookup.lRefreshQuery = TRUE.
              RETURN.
            END.
          END.
    
          /* First try to get the value of the field with the table name joined */
          cValue = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hDataSource,cField)) NO-ERROR.
          /* If the failed, then try to get the value for the field name only */
          IF ERROR-STATUS:ERROR OR 
             cValue = ? OR cValue = "?":U THEN DO:
            cField = IF NUM-ENTRIES(cField,".":U) > 1 THEN ENTRY(2,cField,".":U) ELSE cField.
            cValue = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hDataSource,cField)) NO-ERROR.
          END.
          IF cValue = ? OR cValue = "?":U THEN
            ASSIGN cValue = "":U
                   ttLookup.lRefreshQuery = TRUE.
          ttLookup.cFoundDataValues = ttLookup.cFoundDataValues +
                                      (IF iLoop = 1 THEN "":U ELSE CHR(1)) +
                                      cValue.
        END. /* iLoop */
      END. /* Not MappedFields */
    END. /* FOR EACH  ttLookup */
  END. /* iDataLoop */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState Procedure 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     Receives state messages for updates
  Parameters:  pcState AS CHARACTER -- update state: 
               'UpdateBegin',
               'UpdateComplete'
               'Update' 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState  AS CHARACTER NO-UNDO.

  CASE pcState:
    WHEN 'UpdateBegin':U THEN 
    DO:
      RUN enableFields IN TARGET-PROCEDURE.
      PUBLISH 'updateState':U FROM TARGET-PROCEDURE 
        /* In case enable fails for some reason.*/
        (IF RETURN-VALUE = "ADM-ERROR":U THEN 'UpdateComplete':U
           ELSE 'Update':U).   /* Tell others (Data Object, Nav Panel) */
    END.
    OTHERWISE RUN SUPER(INPUT pcState).  /* Let datavis deal with it. */
  END CASE.
  
  RETURN.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-valueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valueChanged Procedure 
PROCEDURE valueChanged :
/*------------------------------------------------------------------------------
     Purpose:  Value-changed of frame anywhere event     
  Parameters:  
       Notes: Static objects can reach this also by applying U10 event to run it.     
-----------------------------------------------------------------------------*/
  IF NOT VALID-HANDLE(FOCUS) THEN 
    RETURN.    
   
  RUN fieldModified IN TARGET-PROCEDURE(FOCUS).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewRecord Procedure 
PROCEDURE viewRecord :
/*------------------------------------------------------------------------------
  Purpose:  Set object in viewMode    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN disableFields IN TARGET-PROCEDURE.
  PUBLISH 'updateState':U FROM TARGET-PROCEDURE ("view").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getKeepChildPositions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getKeepChildPositions Procedure 
FUNCTION getKeepChildPositions RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lKeepChildPositions             AS LOGICAL          NO-UNDO.

    {get KeepChildPositions lKeepChildPositions}.

    RETURN lKeepChildPositions.
END FUNCTION.   /* getKeepChildPositions */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Needed by SBO routines to provide the actual caller object handle.
    Notes:  
------------------------------------------------------------------------------*/

  RETURN ghTargetProcedure.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeepChildPositions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setKeepChildPositions Procedure 
FUNCTION setKeepChildPositions RETURNS LOGICAL
        ( INPUT plKeepChildPositions AS LOGICAL):
/*------------------------------------------------------------------------------
  Purpose:  
        Notes:
------------------------------------------------------------------------------*/
    {set KeepChildPositions plKeepChildPositions}.
    RETURN TRUE.
END FUNCTION.   /* setKeepChildPositions */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

