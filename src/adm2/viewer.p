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

    Modified    : June 23, 2000 Version 9.1B
    Modified    : 10/25/2001      Mark Davies (MIP)
                  Field security - disabling of fields caused a problem
                  when trying to resolve an entry in the secured field list.
                  Added check to make sure that the list has that number
                  of entries in the list before attempting to retrieve it.
    Modofied    : 10/25/2001      Mark Davies (MIP)
                  Add security for Dynamic Combos and Dynamic Lookups.
    Modofied    : 10/26/2001      Mark Davies (MIP)
                  The widget names and value being sent to the combo and
                  lookup query builder is using a ',' comma as separator
                  and this causes problems for -E 'European numeric formats.
    Modified    : 11/14/2001       Mark Davies (MIP)
                  Added OR cSecuredFields = "":U when checking for security
                  to display and enable fields for NON Dynamics applications.
    Modified    : 11/14/2001        Mark Davies (MIP)
                  1. Renamed property 'DisplayFieldsSecurity' to 'FieldSecurity'
                  2. Fixed IZ#2947 - FieldSecurity implementation incorrect in enabledFields.
    Modified    : 11/16/2001        Mark Davies (MIP)
                  Changed AllFieldHandles to conaint the PROCEDURE handle
                  of an SDF and not the FRAME handle.
    Modified    : 11/17/2001        Mark Davies (MIP)
                  Added 'CAN-QUERY' in initializeObject to check if the
                  TABLE attribute can be queried of the current widget 
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (  )  FORWARD.

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
         HEIGHT             = 15.19
         WIDTH              = 46.4.
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

      RUN SUPER.
      IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.
      
      /* Note: SUPER (datavis.p) verifies that UpdateTarget is present. */
      {get UpdateTarget cTarget}.
      hUpdateTarget = WIDGET-HANDLE(cTarget).
      /* If we're a GroupAssign-Target, then our Source has already done 
         the add; otherwise we invoke addRow in the UpdateTarget.*/           



      IF VALID-HANDLE(hUpdateTarget) THEN
      DO:
       {get DisplayedFields cFields}.
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

      RUN SUPER.
      IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.
      
      /* Note: SUPER (datavis.p) verifies that UpdateTarget is present. */
      {get UpdateTarget cTarget}.
      hUpdateTarget = WIDGET-HANDLE(cTarget).
      /* If we're a GroupAssign-Target, then our Source has already done 
         the add; otherwise we invoke addRow in the UpdateTarget.*/           



      IF VALID-HANDLE(hUpdateTarget) THEN
      DO:
       {get DisplayedFields cFields}.
        ghTargetProcedure = TARGET-PROCEDURE.
        cColValues = DYNAMIC-FUNCTION("copyRow":U IN hUpdateTarget, cFields). 
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
        {get EnabledHandles cEnableFields}.
        {get EnabledObjHdls cEnableObjects}.
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
         END.  /* END DO NOT HIDDEN */
      END.     /* END DO iField     */
      
      /* Disable no db fields */
      DO iField = 1 TO NUM-ENTRIES(cEnableObjects):
         hField = WIDGET-HANDLE(ENTRY(iField, cEnableObjects)).
         /* "Frame Field" May be a SmartObject procedure handle */
         IF hField:TYPE = "PROCEDURE":U THEN
           RUN disableField IN hField NO-ERROR.
         ELSE IF NOT hField:HIDDEN THEN /* Skip fields hidden for multi-layout */
         DO:
           IF hField:TYPE = "EDITOR":U THEN /* Editors must be sensitive, not R-O*/
             hField:READ-ONLY = yes.  
           ELSE hField:SENSITIVE = no.     
         END.  /* END DO NOT HIDDEN */
      END.     /* END DO iField     */
      
      {set fieldsEnabled no}.
  END.
  
  RUN SUPER(pcFieldType).

  PUBLISH 'disableFields':U FROM TARGET-PROCEDURE 
      (pcFieldType). /* In case there's a GroupAssign */
  
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
  DEFINE VARIABLE cNewRecord    AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE iSecuredEntry AS INTEGER   NO-UNDO.
  
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
  DEFINE VARIABLE hDataSource   AS WIDGET-HANDLE  NO-UNDO.
  DEFINE VARIABLE cRowUserProp  AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE iPropLoop     AS INTEGER        NO-UNDO.

  {get FieldHandles cFieldHandles}.
  {get AllFieldHandles cAllFieldHandles}.
  {get FieldSecurity cSecuredFields}.
  
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
        {set DataValue cValue hFrameField}.
      ELSE DO:
        IF (iFieldPos <> 0 AND
            NUM-ENTRIES(cSecuredFields) >= iFieldPos AND
            ENTRY(iFieldPos,cSecuredFields) = "Hidden":U) THEN
          {set Secured TRUE hFrameField}.
      END.
      
      {set DataModified no hFrameField}.
      
      /* Set Static SDF Values for Dynamic Combo */
      IF VALID-HANDLE(hFrameField) AND
         LOOKUP("getDataValue":U,hFrameField:INTERNAL-ENTRIES) > 0 THEN DO:
        cFieldName = DYNAMIC-FUNCTION("getFieldName":U IN hFrameField).
      
        IF cWidgetNames = "":U THEN
          ASSIGN cWidgetNames  = cFieldName
                 cWidgetValues = cValue.   
        ELSE
          ASSIGN cWidgetNames  = cWidgetNames + CHR(3) + cFieldName
                 cWidgetValues = cWidgetValues + CHR(3) + cValue.
      END.
    END.
    ELSE DO:
      /* Check Security for hidden fields */
      IF (iFieldPos <> 0 AND
          NUM-ENTRIES(cSecuredFields) >= iFieldPos AND
          ENTRY(iFieldPos,cSecuredFields) <> "Hidden":U) OR
          iFieldPos = 0 OR 
          cSecuredFields = "":U THEN
        hFrameField:SCREEN-VALUE = 
          IF pcColValues NE ? THEN   /* If the value of the field is not ? */
             /* and it is not a logical field, use the value */
            (IF hFrameField:DATA-TYPE NE "LOGICAL":U 
             OR hFrameField:TYPE = "RADIO-SET":U THEN cValue  
             ELSE
               /* otherwise we have to take the entry on the appropriate side of the "/" 
                  in the field's FORMAT attribute */
               (IF cValue = "yes":U THEN ENTRY(1,hFrameField:FORMAT,"/":U) 
                ELSE ENTRY(2,hFrameField:FORMAT,"/":U)))
          ELSE 
            (IF hFrameField:DATA-TYPE NE "LOGICAL":U OR hFrameField:TYPE = "RADIO-SET":U THEN "":U 
             ELSE ENTRY(2,hFrameField:FORMAT,"/":U)). 
              /* For Combos and Selection lists */
      
      hFrameField:MODIFIED = no.       /* This will be checked by update code. */
      
      IF cWidgetNames = "":U THEN
        ASSIGN cWidgetNames  = hFrameField:NAME
               cWidgetValues = hFrameField:SCREEN-VALUE.   
      ELSE
        ASSIGN cWidgetNames  = cWidgetNames + CHR(3) +  hFrameField:NAME        
               cWidgetValues = cWidgetValues + CHR(3) + hFrameField:SCREEN-VALUE.
      
    END.
  END.

    {get NewRecord cNewRecord}. 

    RUN displayObjects IN TARGET-PROCEDURE NO-ERROR.

  {get DataSource hDataSource}.
  IF VALID-HANDLE(hDataSource)
  THEN DO:
    cRowUserProp = {fnarg columnValue 'RowUserProp':U hDataSource} NO-ERROR.
    DO iPropLoop = 1 TO NUM-ENTRIES(cRowUserProp,CHR(4)):
      IF ENTRY( 1 , ENTRY( iPropLoop , cRowUserProp , CHR(4) ) , CHR(3) ) = 'gsmcmauto':U
      THEN MESSAGE
          ENTRY( 2 , ENTRY( iPropLoop , cRowUserProp , CHR(4) ) , CHR(3) )
          VIEW-AS ALERT-BOX INFORMATION TITLE "Comment(s) for Record".
    END.
  END.

  /* Clear out lookup/combo query temp-table */
  EMPTY TEMP-TABLE ttLookup.   
  EMPTY TEMP-TABLE ttDCombo.
  
  /* get lookup queries for specific data value and redisplay data */
  PUBLISH "getLookupQuery":U FROM TARGET-PROCEDURE (INPUT-OUTPUT TABLE ttLookup).
  PUBLISH "getComboQuery":U FROM TARGET-PROCEDURE (INPUT-OUTPUT TABLE ttDCombo).
  
  IF VALID-HANDLE(gshAstraAppserver) AND 
    (CAN-FIND(FIRST ttLookup) OR
     CAN-FIND(FIRST ttDCombo)) THEN
    RUN adm2/lookupqp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttLookup,
                                                  INPUT-OUTPUT TABLE ttDCombo,
                                                  INPUT cWidgetNames,
                                                  INPUT cWidgetValues).
  /* display Lookup query/Combo results */          
  PUBLISH "displayLookup":U FROM TARGET-PROCEDURE (INPUT TABLE ttLookup).
  PUBLISH "displayCombo":U  FROM TARGET-PROCEDURE (INPUT TABLE ttDCombo).
  
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
  
  
  /* Field Security Check */
  DEFINE VARIABLE cAllFieldHandles AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSecuredFields   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iFieldPos        AS INTEGER   NO-UNDO.

  {get FieldsEnabled lEnabled}.
  {get GroupAssignSource hGASource}.
  {get AllFieldHandles cAllFieldHandles}.
  /* Get Secured Fields */
  {get FieldSecurity cSecuredFields}.
  
  /* Check the record state in the GA source to avoid timing problems
     when this method is called from queryPosition.
     The NewRecord value is not even propagated to GroupAssign-Target(s). */
  IF VALID-HANDLE(hGASource) THEN
  DO:
    {get RecordState cState hGASource}.
    {get NewRecord cNewRecord hGASource}.
    {get UpdateTarget cUpdateTarget hGaSource}.
  END.
  ELSE
  DO:
    {get RecordState cState}.
    {get NewRecord cNewRecord}.
    {get UpdateTarget cUpdateTarget}.
  END.
  
  IF  (NOT lEnabled) 
  AND (cUpdateTarget NE "":U) 
  AND (cState = "RecordAvailable":U OR cNewRecord NE "No":U) THEN     
  DO:  
    {get EnabledHandles cEnableFields}.
    {get EnabledObjHdls cEnableObjects}.
    DO iField = 1 TO NUM-ENTRIES(cEnableFields):
       hField = WIDGET-HANDLE(ENTRY(iField, cEnableFields)).
      
       iFieldPos = LOOKUP(STRING(hField),cAllFieldHandles).
      
      /* "Frame Field" May be a SmartObject procedure handle */
      IF hField:TYPE = "PROCEDURE":U THEN DO:
        IF ((iFieldPos <> 0 AND
           NUM-ENTRIES(cSecuredFields) >= iFieldPos AND
           ENTRY(iFieldPos,cSecuredFields) = "":U) OR
           iFieldPos = 0) OR 
          cSecuredFields = "":U THEN /* Check Security */
          RUN enableField IN hField NO-ERROR.
        ELSE
          RUN disableField IN hField NO-ERROR.
       END.
       ELSE IF NOT hField:HIDDEN THEN /* Skip fields hidden for multi-layout */
       DO:
         /* Check Security */
         IF (iFieldPos <> 0 AND
          NUM-ENTRIES(cSecuredFields) >= iFieldPos AND
          ENTRY(iFieldPos,cSecuredFields) = "":U) OR
          iFieldPos = 0 OR 
          cSecuredFields = "":U THEN DO:
           hField:SENSITIVE = YES.
           IF hField:TYPE = "EDITOR":U THEN /* Ed's must be sensitive, not R-O*/
             hField:READ-ONLY = NO.     
         END.
       END.
    END.
     /* Enable no db fields */
    DO iField = 1 TO NUM-ENTRIES(cEnableObjects):
       hField = WIDGET-HANDLE(ENTRY(iField, cEnableObjects)).
       
       iFieldPos = 0.
       iFieldPos = LOOKUP(STRING(hField),cAllFieldHandles).
    
         /* "Frame Field" May be a SmartObject procedure handle */
       IF hField:TYPE = "PROCEDURE":U AND          
          ((iFieldPos <> 0 AND
          NUM-ENTRIES(cSecuredFields) >= iFieldPos AND
          ENTRY(iFieldPos,cSecuredFields) = "":U) OR
          iFieldPos = 0) OR 
          cSecuredFields = "":U THEN /* Check Security */
         RUN enableField IN hField NO-ERROR.
       ELSE IF NOT hField:HIDDEN THEN /* Skip fields hidden for multi-layout */
       DO:
         /* Check Security */
         IF (iFieldPos <> 0 AND
          NUM-ENTRIES(cSecuredFields) >= iFieldPos AND
          ENTRY(iFieldPos,cSecuredFields) = "":U) OR
          iFieldPos = 0 OR 
          cSecuredFields = "":U THEN DO:
           hField:SENSITIVE = yes.
           IF hField:TYPE = "EDITOR":U THEN /* Ed's must be sensitive, not R-O*/
             hField:READ-ONLY = no.     
         END.
       END.
    END.

    /* If the list of enabled field handles isn't set, it may because this
       object hasn't been fully initialized yet. So don't set the enabled
       flag because we may be through here again. */
    IF cEnableFields NE "":U THEN
      {set FieldsEnabled yes}.
  END.
  ELSE /* Ensure that SDF fields is disabled if no record available */
  IF (NOT lEnabled) AND (cUpdateTarget NE "":U) AND (cState = "NoRecordAvailable":U) THEN
  DO:
    {get EnabledHandles cEnableFields}.
    {get EnabledObjHdls cEnableObjects}.
    DO iField = 1 TO NUM-ENTRIES(cEnableFields):
       hField = WIDGET-HANDLE(ENTRY(iField, cEnableFields)).
       
       iFieldPos = 0.
       iFieldPos = LOOKUP(STRING(hField),cAllFieldHandles).
       
       /* "Frame Field" May be a SmartObject procedure handle */
       IF hField:TYPE = "PROCEDURE":U THEN
         RUN disableField IN hField NO-ERROR.
       ELSE IF NOT hField:HIDDEN THEN /* Skip fields hidden for multi-layout */
       DO:
         IF hField:TYPE = "EDITOR":U THEN /* Editors must be sensitive, not R-O*/
           hField:READ-ONLY = yes.  
         ELSE hField:SENSITIVE = no.     
       END.  /* END DO NOT HIDDEN */
    END.     /* END DO iField     */
    
    DO iField = 1 TO NUM-ENTRIES(cEnableObjects):
       hField = WIDGET-HANDLE(ENTRY(iField, cEnableObjects)).
       
       iFieldPos = 0.
       iFieldPos = LOOKUP(STRING(hField),cAllFieldHandles).
       
       /* "Frame Field" May be a SmartObject procedure handle */
       IF hField:TYPE = "PROCEDURE":U THEN
         RUN disableField IN hField NO-ERROR.
       ELSE IF NOT hField:HIDDEN THEN /* Skip fields hidden for multi-layout */
       DO:
         IF hField:TYPE = "EDITOR":U THEN /* Editors must be sensitive, not R-O*/
           hField:READ-ONLY = yes.  
         ELSE hField:SENSITIVE = no.     
       END.  /* END DO NOT HIDDEN */
    END.     /* END DO iField     */
  END. 
  RUN SUPER.

  PUBLISH 'enableFields':U FROM TARGET-PROCEDURE.  /* In case of GroupAssign */
  
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
 DEFINE VARIABLE lGaEnabled         AS LOGICAL   NO-UNDO.
 DEFINE VARIABLE iField             AS INTEGER   NO-UNDO.
 DEFINE VARIABLE cFieldName         AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cTableName         AS CHARACTER NO-UNDO.
 DEFINE VARIABLE hFrameProc         AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cUIBMode           AS CHARACTER NO-UNDO.
 DEFINE VARIABLE iSDFLoop           AS INTEGER   NO-UNDO.
 DEFINE VARIABLE cContainerTargets  AS CHARACTER NO-UNDO.
 DEFINE VARIABLE hSDFHandle         AS HANDLE    NO-UNDO.
 DEFINE VARIABLE hSDFFrameHandle    AS HANDLE    NO-UNDO.

 RUN SUPER.            /* Invoke the standard behavior first. */
  IF RETURN-VALUE = "ADM-ERROR":U
    THEN RETURN "ADM-ERROR":U.      
  
  {get UpdateTarget cTarget}.
  hUpdateTarget = WIDGET-HANDLE(cTarget).
  
  /* Initialize the list of handles of the frame fields that are for
     database fields, for displayFields and update-record to use. 
     Also set a similar list of the field names for update-record to use. 
     Also a list of Enabled Field handles for enable/disableFields,
       and a list of any fields to be enabled for Create. */
  /*   Note: CreateFields not yet supported. 
  IF VALID-HANDLE(hUpdateTarget) THEN
    {get CreateFields cCreateFields hUpdateTarget}.  
  */ 
  {get ContainerHandle hContainerHandle}.
  {get EnabledFields cEnabledFields}.
  {get DisplayedFields cDisplayedFields}.

  cContainerTargets = DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, "Container-Target":U) NO-ERROR.

  ASSIGN hFrameField = hContainerHandle  
         hFrameField = hFrameField:FIRST-CHILD    /* Field Group */
         hFrameField = hFrameField:FIRST-CHILD.   /* First actual field. */
         
  /* A "Frame Field" may in fact be a SmartObject procedure handle. Check this
     and retrieve the object's FieldName property. */

  /* Initialise the variables to an empty CSV list.
   * We need to be absolutely sure that the order of the lists of handles
   * matches the order of the DisplayedField and EnabledField properties,
   * so we initialise a string with the correct number of entries, and
   * we will make sure that the handle matches the column name.             */
  ASSIGN cEnabledHandles = FILL(",":U, NUM-ENTRIES(cEnabledFields)   - 1)
         cFieldHandles   = FILL(",":U, NUM-ENTRIES(cDisplayedFields) - 1)
         .
  DO WHILE VALID-HANDLE(hFrameField):
    /* Check for existance of SDFs */
    IF hFrameField:TYPE = "FRAME":U AND 
       cContainerTargets <> "":U THEN DO:
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
          hSDFFrameHandle = DYNAMIC-FUNCTION("getSDFFrameHandle":U IN hSDFHandle) NO-ERROR.
        IF hFrameField = hSDFFrameHandle THEN DO:
          hFrameProc = hSDFHandle.
          LEAVE SDF_LOOP.
        END.
      END.
      IF VALID-HANDLE(hFrameProc) THEN
        ASSIGN cFieldName = DYNAMIC-FUNCTION('getFieldName' IN hFrameProc) NO-ERROR.
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

        ASSIGN cFieldName = (IF cTableName NE "RowObject":U THEN cTableName + ".":U ELSE "":U) + hFrameField:NAME.
    END.    /* not a SDF */

    IF cFieldName                           NE ? AND
       LOOKUP(cFieldName, cDisplayedFields) NE 0 THEN
    DO:
        /* Displayed Fields */
        ENTRY(LOOKUP(cFieldName, cDisplayedFields), cFieldHandles) = (IF hFrameProc EQ ? THEN STRING(hFrameField) ELSE STRING(hFrameProc)).

        /* Enabled Fields */
        IF LOOKUP(cFieldName, cEnabledFields) NE 0 THEN
            ENTRY(LOOKUP(cFieldName, cEnabledFields), cEnabledHandles) = (IF hFrameProc EQ ? THEN STRING(hFrameField) ELSE STRING(hFrameProc)).
    END.    /* END DO IF LOOKUP */
    hFrameField = hFrameField:NEXT-SIBLING.
  END.      /* END DO WHILE     */

  /* Strip out any invalid handles. */
  ASSIGN cEnabledHandles = TRIM(cEnabledHandles, ",":U)
         cFieldHandles   = TRIM(cFieldHandles, ",":U)
         .
  {set EnabledHandles cEnabledHandles}.
  {set CreateHandles cCreateHandles}.
  {set FieldHandles cFieldHandles}.
  {get UIBMode cUIBMode}.
  
  IF NOT (cUIBMode BEGINS 'Design':U) THEN
    RUN dataAvailable IN TARGET-PROCEDURE (?). /* See if there's a rec waiting. */
  
  /* Is this a GaTarget, if so get SaveSOurce and FieldsEnabled from the 
     GA source so we can find out whether we should be enabled (further down) */
  {get GroupAssignSource hGASOurce}.
  IF VALID-HANDLE(hGaSource) THEN
  DO:
    {get SaveSource lSaveSource hGASource}.
    {get FieldsEnabled lGaEnabled hGaSource}.
  END.
  ELSE
    {get SaveSource lSaveSource}.
  
  /* If we have NO tableio-source (?) or a Tableio-Source in Save mode 
     OR if groupAssign-source is enabled the target also should be,
    (that would have been the case if this GAtarget had been initialized) */
  
  IF NOT (lSaveSource = FALSE) 
  OR lGaEnabled THEN
    RUN enableFields IN TARGET-PROCEDURE.

  ELSE DO:
    /* If we're not enabling all fields, we must at least set editors to
       be Sensitive so they can be viewed and scrolled. */
    DO iField = 1 TO NUM-ENTRIES(cFieldHandles):
      hFrameField = WIDGET-HANDLE(ENTRY(iField, cFieldHandles)).
      IF hFrameField:TYPE = "EDITOR":U AND
         NOT hFrameField:HIDDEN THEN   /* Skip fields hidden for multi-layout */
           ASSIGN hFrameField:SENSITIVE = YES 
                  hFrameField:READ-ONLY = YES.
    END.       /* END DO iField */
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
    DEFINE VARIABLE lViewerField     AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE hFrame           AS HANDLE    NO-UNDO.
    DEFINE VARIABLE hContainer       AS HANDLE    NO-UNDO.
    DEFINE VARIABLE cDisplayedFields AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lResult          AS LOGICAL   NO-UNDO.
IF NOT VALID-HANDLE(FOCUS) THEN RETURN.
   
    {get DisplayedFields cDisplayedFields}.
    {get ContainerHandle hContainer}.    
    
    /* Ignore the event if it wasn't a viewer field. 
       Note that we assume that an event from a widget in a different
       frame is for a SmartDataField and also is a viewerfield  */
    IF LOOKUP(FOCUS:NAME,cDisplayedFields) NE 0  
    /* SBO viewers is qualified */
    OR LOOKUP(FOCUS:TABLE + '.':U + FOCUS:NAME,cDisplayedFields) NE 0 THEN
      lViewerField = yes.
    ELSE DO:
      ASSIGN hFrame = FOCUS:PARENT       /* Field-Group for the widget */
             hFrame = hFrame:PARENT.     /* and the frame itself       */
      IF hFrame NE hContainer THEN
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

