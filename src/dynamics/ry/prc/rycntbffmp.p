&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/* Procedure Description
"Dynamic Viewer for rycntbffmv"
*/
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
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
/* Copyright (C) 2005 by Progress Software Corporation.  All rights 
   reserved.  Prior versions of this work may contain portions 
   contributed by participants of Possenet
*/
/*---------------------------------------------------------------------------------
  File: ry/prc/rycntbffmp.p rycntbffmv

  Description:  CB Foreign Field Mapping Viewer

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   12/11/2002  Author:     

  Update Notes: Created from Template viewv

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rycntbffmp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-DynamicSmartDataViewer yes

{src/adm2/globals.i}

DEFINE VARIABLE gcSourceFieldList   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTargetFieldList   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdInitialHeight     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdInitialWidth      AS DECIMAL    NO-UNDO.

/* Viewer fields */
DEFINE VARIABLE ghSourceFieldLabel  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTargetFieldLabel  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghMappedFieldLabel  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSeSourceFields    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSeTargetFields    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSeMappedFields    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBuUnMap           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghBuMap             AS HANDLE     NO-UNDO.

/* Additional required handles */
DEFINE VARIABLE gcSourceListItems   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTargetListItems   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSourceLabel       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTargetLabel       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdObjectInstanceObj AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdSmartObjectObj    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE glRefresh           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE ghContainerSource   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghParentContainer   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghEdForeignFields   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghObjectInstance    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSmartLink         AS HANDLE     NO-UNDO.
define variable ghAttributeValue    as handle     no-undo.
DEFINE VARIABLE ghFrame             AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/ryemptysdo.i"



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-updateForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateForeignFields Procedure 
FUNCTION updateForeignFields RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Data Source: "ry/obj/ryemptysdo.w"
   Allow: Basic,Browse,DB-Fields
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 17
         WIDTH              = 44.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    /* RUN initializeObject. */
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN SUPER.

  IF VALID-HANDLE(ghObjectInstance) THEN DELETE OBJECT ghObjectInstance.
  IF VALID-HANDLE(ghSmartLink)      THEN DELETE OBJECT ghSmartLink.
  IF VALID-HANDLE(ghAttributeValue) THEN DELETE OBJECT ghAttributeValue.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldHandles AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldNames   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hGridV        AS HANDLE     NO-UNDO.
  
  {get ContainerSource ghContainerSource}.
  {get ContainerSource ghParentContainer ghContainerSource}.

  ON "F5":U ANYWHERE PERSISTENT RUN refreshLists IN TARGET-PROCEDURE.
  
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "instanceSelected":U IN ghParentContainer.
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "instanceUpdated":U  IN ghParentContainer.

  RUN SUPER.

  ASSIGN
      ghFrame            = {fn getContainerHandle}

      cFieldHandles      = {fn getAllFieldHandles}
      cFieldNames        = {fn getAllFieldNames}

      ghObjectInstance   = WIDGET-HANDLE({fnarg getUserProperty 'ttObjectInstance' ghParentContainer})
      ghSmartLink        = WIDGET-HANDLE({fnarg getUserProperty 'ttSmartLink'      ghParentContainer})
      ghAttributeValue   = WIDGET-HANDLE({fnarg getUserProperty 'ttAttributeValue' ghParentContainer})

      ghSourceFieldLabel = WIDGET-HANDLE(ENTRY(LOOKUP("TEXT-1":U,         cFieldNames), cFieldHandles))
      ghTargetFieldLabel = WIDGET-HANDLE(ENTRY(LOOKUP("TEXT-2":U,         cFieldNames), cFieldHandles))
      ghMappedFieldLabel = WIDGET-HANDLE(ENTRY(LOOKUP("TEXT-3":U,         cFieldNames), cFieldHandles))
      ghSeSourceFields   = WIDGET-HANDLE(ENTRY(LOOKUP("seSourceFields":U, cFieldNames), cFieldHandles))
      ghSeTargetFields   = WIDGET-HANDLE(ENTRY(LOOKUP("seTargetFields":U, cFieldNames), cFieldHandles))
      ghSeMappedFields   = WIDGET-HANDLE(ENTRY(LOOKUP("seMappedFields":U, cFieldNames), cFieldHandles))
      ghBuUnMap          = WIDGET-HANDLE(ENTRY(LOOKUP("buUnMap":U,        cFieldNames), cFieldHandles))
      ghBuMap            = WIDGET-HANDLE(ENTRY(LOOKUP("buMap":U,          cFieldNames), cFieldHandles))

      hGridV             = {fnarg linkHandles 'gridv-SOURCE' ghParentContainer}
      ghEdForeignFields  = WIDGET-HANDLE(ENTRY(LOOKUP("edForeignFields":U, {fn getAllFieldNames hGridV}), {fn getAllFieldHandles hGridV}))

      gcSourceLabel      = ghSourceFieldLabel:SCREEN-VALUE
      gcTargetLabel      = ghTargetFieldLabel:SCREEN-VALUE

      ghSeSourceFields:DELIMITER = CHR(10)
      ghSeTargetFields:DELIMITER = CHR(10)
      ghSeMappedFields:DELIMITER = CHR(10).

  /* Localize the buffers to this procedure */
  CREATE BUFFER ghObjectInstance FOR TABLE ghObjectInstance.
  CREATE BUFFER ghSmartLink      FOR TABLE ghSmartLink.
  CREATE BUFFER ghAttributeValue FOR TABLE ghAttributeValue.

  RUN resizeObject    IN TARGET-PROCEDURE (INPUT gdInitialHeight, INPUT gdInitialWidth).
  RUN trgValueChanged IN TARGET-PROCEDURE (INPUT "seSourceFields":U).
  RUN trgValueChanged IN TARGET-PROCEDURE (INPUT "seMappedFields":U).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-instanceSelected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE instanceSelected Procedure 
PROCEDURE instanceSelected :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdObjectInstanceObj  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE cSourceObjectFilename AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargetObjectFilename AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSourceInstanceName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargetInstanceName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueToRemove        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSourceObjType        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargetObjType        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRemovedEntry         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUpdateForeignFields  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSuccess              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iCounter              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSourceObject         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTargetObject         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTables               AS CHARACTER  NO-UNDO.
  define variable cAttributeValue       as character  no-undo.
  define variable lSourceDbAware        as logical    no-undo.
  define variable lTargetDbAware        as logical    no-undo.
  
  ghSmartLink:FIND-FIRST("WHERE d_target_object_instance_obj  = ":U + QUOTER(pdObjectInstanceObj)
                        + " AND d_source_object_instance_obj <> 0":U
                        + " AND c_action                     <> 'D'":U
                        + " AND c_link_name                   = 'Data'":U) NO-ERROR.

  ghObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = ":U + QUOTER(ghSmartLink:BUFFER-FIELD("d_source_object_instance_obj":U):BUFFER-VALUE)) NO-ERROR.

  IF ghObjectInstance:AVAILABLE THEN
    ASSIGN
        cSourceObjectFilename = ghObjectInstance:BUFFER-FIELD("c_smartobject_filename":U):BUFFER-VALUE
        cSourceInstanceName   = ghObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE.

  ghObjectInstance:FIND-FIRST("WHERE d_object_instance_obj = ":U + QUOTER(ghSmartLink:BUFFER-FIELD("d_target_object_instance_obj":U):BUFFER-VALUE)) NO-ERROR.

  IF ghObjectInstance:AVAILABLE THEN
    ASSIGN
        cTargetObjectFilename = ghObjectInstance:BUFFER-FIELD("c_smartobject_filename":U):BUFFER-VALUE
        cTargetInstanceName   = ghObjectInstance:BUFFER-FIELD("c_instance_name":U):BUFFER-VALUE
        cForeignFields        = ghObjectInstance:BUFFER-FIELD("c_foreign_fields":U):BUFFER-VALUE
        dSmartObjectObj       = ghObjectInstance:BUFFER-FIELD("d_smartobject_obj":U):BUFFER-VALUE.

  ASSIGN
      ghSourceFieldLabel:FORMAT       = "x(256)":U
      ghTargetFieldLabel:FORMAT       = "x(256)":U
      ghSourceFieldLabel:SCREEN-VALUE = gcSourceLabel + " ":U + cSourceInstanceName
      ghTargetFieldLabel:SCREEN-VALUE = gcTargetLabel + " ":U + cTargetInstanceName.
  
  IF (pdObjectInstanceObj <> gdObjectInstanceObj OR
      dSmartObjectObj     <> gdSmartObjectObj)   OR glRefresh THEN
  DO:
    ASSIGN
        ghSeSourceFields:LIST-ITEMS = "":U
        ghSeTargetFields:LIST-ITEMS = "":U.
            
    /* Start the source data object */
    IF cSourceObjectFilename <> "":U AND cSourceObjectFilename <> ? THEN
    do:
      RUN startDataObject IN gshRepositoryManager (INPUT cSourceObjectFilename, OUTPUT hSourceObject) no-error.
      /* no error handling, since we may pass in a non-data object, and that will
         throw an expected error.
       */
      if valid-handle(hSourceObject) then
      do:
          {get DbAware lSourceDbAware hSourceObject}.
          /* We need to push the BusinessEntity and DataTable into the 
	         (empty) master DataView.
	       */
          if not lSourceDbAware then
          do:
              /* Destroy the DataView, so that we can set the pertinent information. */
              {fn destroyView hSourceObject}.
              
              ghAttributeValue:find-first(' where ':U
                  + 'ttAttributeValue.d_object_instance_obj = ':u
                  + quoter(ghSmartLink:buffer-field('d_source_object_instance_obj':u):buffer-value)
                  + ' and ':u
                  + 'ttAttributeValue.c_attribute_label = "BusinessEntity" ' ) no-error.
              if ghAttributeValue:available then
                  cAttributeValue = ghAttributeValue:buffer-field('c_character_value':u):buffer-value.
              else
                  cAttributeValue = '':u.
              {set BusinessEntity cAttributeValue hSourceObject}.
              
              ghAttributeValue:find-first(' where ':U
                  + 'ttAttributeValue.d_object_instance_obj = ':u
                  + quoter(ghSmartLink:buffer-field('d_source_object_instance_obj':u):buffer-value)
                  + ' and ':u
                  + 'ttAttributeValue.c_attribute_label = "DataTable" ' ) no-error.
              if ghAttributeValue:available then
                  cAttributeValue = ghAttributeValue:buffer-field('c_character_value':u):buffer-value.                   
              else
                  cAttributeValue = '':u.
              {set DataTable cAttributeValue hSourceObject}.
              
              /* Now construct the DataView again. */
              run createObjects in hSourceObject.
          end.    /* dataview */
      end.    /* valid source object */          
    end.    /* source object */
    ELSE
      assign lSourceDbAware = yes
             gcSourceListItems = "":U.
    
    /* Start the target data object */
    IF cTargetObjectFilename <> "":U AND cTargetObjectFilename <> ? THEN
    do:
      RUN startDataObject IN gshRepositoryManager (INPUT cTargetObjectFilename, OUTPUT hTargetObject) no-error.
      /* no error handling, since we may pass in a non-data object, and that will
         throw an expected error.
       */
      if valid-handle(hTargetObject) then
      do:          
          {get DbAware lTargetDbAware hTargetObject}.
          /* We need to push the BusinessEntity and DataTable into the 
	         (empty) master DataView.
	       */
          if not lTargetDbAware then
          do:
              /* Destroy the DataView, so that we can set the pertinent information. */
              {fn destroyView hTargetObject}.
              
              ghAttributeValue:find-first(' where ':U
                  + 'ttAttributeValue.d_object_instance_obj = ':u
                  + quoter(ghSmartLink:buffer-field('d_target_object_instance_obj':u):buffer-value)
                  + ' and ':u
                  + 'ttAttributeValue.c_attribute_label = "BusinessEntity" ' ) no-error.
              if ghAttributeValue:available then
                  cAttributeValue = ghAttributeValue:buffer-field('c_character_value':u):buffer-value.                   
              else
                  cAttributeValue = '':u.          
              {set BusinessEntity cAttributeValue hTargetObject}.
    
              ghAttributeValue:find-first(' where ':U
                  + 'ttAttributeValue.d_object_instance_obj = ':u
                  + quoter(ghSmartLink:buffer-field('d_target_object_instance_obj':u):buffer-value)
                  + ' and ':u
                  + 'ttAttributeValue.c_attribute_label = "DataTable" ' ) no-error.
              if ghAttributeValue:available then
                  cAttributeValue = ghAttributeValue:buffer-field('c_character_value':u):buffer-value.                   
              else
                  cAttributeValue = '':u.          
              {set DataTable cAttributeValue hTargetObject}.
              
              /* Now construct the DataView again. */
              run createObjects in hTargetObject.
          end.    /* dataview */
      end.    /* valid target obejct */
    end.    /* target object */
    ELSE
      assign lTargetDbAware = yes
             gcTargetListItems = "":U.
   
    IF VALID-HANDLE(hTargetObject) THEN
    DO:        
      cTargetObjType = {fn getObjectType hTargetObject}.      
      cTables  = {fn getTables hTargetObject} NO-ERROR.
      
      /* The code below is taken from adecomm/_mfldmap.p (which is the AB's 
         ForeignField mapper). 
       */
             
      /* Populates the Target selection list 
	   * Target will most likely be a SmartDataObject
	   */
      IF cTargetObjType = "SmartBusinessObject":U THEN
        RUN adecomm/_getdlst.p (INPUT ghSeTargetFields:HANDLE,
                                INPUT hTargetObject,
                                INPUT FALSE,
                                INPUT "2":U,
                                INPUT ?,
                                OUTPUT lSuccess).
      ELSE
      DO:
        IF lTargetDbAware THEN
            RUN adecomm/_mfldlst.p (INPUT  ghSeTargetFields:HANDLE,
                                    INPUT  cTables,
                                    INPUT  "":U,
                                    INPUT  TRUE,
                                           /* if db qualifier then ensure that fields 
	                                          of target includes this else qualify 
	                                          with table */
                                    INPUT  IF INDEX(".":U,cTables) > 0 
                                           THEN "3":U
                                           ELSE "2":U,
                                    INPUT  2, /* expand EACH array element */
                                    INPUT  "":U,
                                    OUTPUT lSuccess).
        ELSE  /* not really needed just to make it clearer */
            lSuccess = no.
      END.    /* not SmartBusinessObject */

      IF NOT lSuccess AND cTargetObjType = "SmartDataObject":U THEN
      DO:
         /* We have a DataView  */
         /* OR   */ 
         /* We have an SDO but we did not succeed in building a field list.
          * Assume that this is an SDO built against a temp-table.
	      * (NOTE: Although the above procedure should be able to handle 
	      *  this case, there currently does not appear to be a way to get
          *  the information needed for the p_TT parameter here.  Note also that
          *  the above function always tries to get the field information 
          *  from a database table, which should not be necessary for an SDO
          *  that queries a temp-table). [1/12/2000 tomn]
          */
              
          /* dbaware is set for SDO above. dest_TBlList is set for dbaware above. 
	         If not dbaware ensure that only DataTable columns can be picked.  */
          IF NOT lTargetDbAware THEN
            cTables = {fn getDataTable hTargetObject}.
          
          RUN adecomm/_getdlst.p (INPUT ghSeTargetFields:HANDLE,
                                  INPUT hTargetObject,
                                  INPUT FALSE,
                                  INPUT "2|" + cTables,
                                  INPUT ?,
                                  OUTPUT lSuccess).
      END.    /* no success for SmartDataObject */

      RUN destroyObject IN hTargetObject.
      gcTargetListItems = ghSeTargetFields:LIST-ITEMS.
    END.    /* Valid target object handle */
  
    IF VALID-HANDLE(hSourceObject) THEN
    DO:
      cSourceObjType = {fn getObjectType hSourceObject}.
      cTables  = {fn getTables hSourceObject} NO-ERROR.
      
      /* The code below is taken from adecomm/_mfldmap.p (which is the AB's 
         ForeignField mapper).
       */             
      IF cSourceObjType eq "SmartDataObject":U THEN
      DO:
          /* dbaware is set for SDO above. CTables is set for dbaware above. 
	         If not dbaware ensure that only DataTable columns can be picked.  */
          IF NOT lSourceDbAware THEN
            cTables = {fn getDataTable hSourceObject}.
          
          RUN adecomm/_getdlst.p (INPUT ghSeSourceFields:HANDLE,
                                  INPUT hSourceObject,
                                  INPUT FALSE,                                  
                                  INPUT IF lSourceDbAware THEN "1"  /* no qualifier for source */
                                        ELSE "2|" + cTables,                                  
                                  INPUT ?,
                                  OUTPUT lSuccess).
      END.    /* no success for SmartDataObject */
      ELSE
      IF cSourceObjType eq "SmartBusinessObject":U THEN
        RUN adecomm/_getdlst.p (INPUT ghSeSourceFields:HANDLE,
                                INPUT hSourceObject,
                                INPUT no,
                                INPUT "2":u,
                                INPUT ?,
                                OUTPUT lSuccess).
      ELSE
      DO:
          cTables = {fn getTables hSourceObject} no-error.
          
          RUN adecomm/_mfldlst.p (INPUT ghSeSourceFields:HANDLE,
                                  INPUT cTables,
                                  INPUT '':u,
                                  INPUT yes,
                                  INPUT '1':u,
                                  INPUT 2, /* expand EACH array element */
                                  INPUT "",
                                  OUTPUT lSuccess).
      END.    /* none of the above */
      
      RUN destroyObject IN hSourceObject.      
      gcSourceListItems = ghSeSourceFields:LIST-ITEMS.
    END.    /* valid source object */
  END. /* (pdObjectInstanceObj <> gdObjectInstanceObj OR dSmartObjectObj <> gdSmartObjectObj) OR glRefresh  */
  
  /* --------------------------------------------------- End of borrowed code --------------------------------------------------- */
  ASSIGN
      ghSeMappedFields:LIST-ITEMS = "":U
      ghSeSourceFields:LIST-ITEMS = gcSourceListItems
      ghSeTargetFields:LIST-ITEMS = gcTargetListItems.

  DO iCounter = 1 TO NUM-ENTRIES(cForeignFields) BY 2:
    /* Remove the entry in the Source list */
    IF NUM-ENTRIES(cForeignFields) >= iCounter + 1 THEN
      RUN removeSLEntry IN TARGET-PROCEDURE (INPUT  ghSeSourceFields,
                                             INPUT  ENTRY(iCounter + 1, cForeignFields),
                                             OUTPUT cRemovedEntry).

    /* Remove the entry in the Target list */
    cValueToRemove = ENTRY(iCounter, cForeignFields).

    RUN removeSLEntry IN TARGET-PROCEDURE (INPUT  ghSeTargetFields,
                                           INPUT  cValueToRemove,
                                           OUTPUT cRemovedEntry).

    ghSeMappedFields:ADD-LAST((IF cRemovedEntry = "":U THEN cValueToRemove ELSE cRemovedEntry) + ",":U + (IF NUM-ENTRIES(cForeignFields) >= iCounter + 1 THEN ENTRY(iCounter + 1, cForeignFields) ELSE "":U)).

    IF cRemovedEntry <> cValueToRemove AND cRemovedEntry <> "":U THEN
    DO:
      IF INDEX(cValueToRemove, ".":U) = 0 THEN
      /* A message statement was used here becuase the showMessages causes and input blocking statement error because of the way it is integrated into
         the container builder */
        MESSAGE "The value to remove from the target list ('" + cValueToRemove + "') was not qualified with a table name. A search was done using only "
                 + "the field name, but multiple matching entries were found. The first entry matching '" + cValueToRemove + "' found in the list was used "
                 + "for the foreign field mapping." + CHR(10) + CHR(10)
                 + "If this is incorrect, unmap the field and map the correct one to ensure the correct table name is prefixed to the mapped field."
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK TITLE "Table prefix not specified" .

      lUpdateForeignFields = TRUE.
    END.
  END.

  IF lUpdateForeignFields THEN
    {fn updateForeignFields}.

  RUN trgValueChanged IN TARGET-PROCEDURE (INPUT "seSourceFields":U).
  RUN trgValueChanged IN TARGET-PROCEDURE (INPUT "seMappedFields":U).

  ASSIGN
      gdObjectInstanceObj = pdObjectInstanceObj
      gdSmartObjectObj    = dSmartObjectObj
      glRefresh           = FALSE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-instanceUpdated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE instanceUpdated Procedure 
PROCEDURE instanceUpdated :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdObjectInstanceObj  AS DECIMAL    NO-UNDO.

  RUN instanceSelected IN TARGET-PROCEDURE (INPUT pdObjectInstanceObj).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshLists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshLists Procedure 
PROCEDURE refreshLists :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  glRefresh = TRUE.

  RUN instanceSelected IN TARGET-PROCEDURE (INPUT gdObjectInstanceObj).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeSLEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeSLEntry Procedure 
PROCEDURE removeSLEntry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phSelectionList   AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcValueToRemove   AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRemovedEntry    AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cMessage  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuccess  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iLookup   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iItem     AS INTEGER    NO-UNDO.

  iLookup = phSelectionList:LOOKUP(pcValueToRemove).

  IF iLookup <> 0 THEN
    ASSIGN
        pcRemovedEntry = pcValueToRemove
        lSuccess       = phSelectionList:DELETE(iLookup)
        iCount         = iCount + 1.
  ELSE
    IF INDEX(pcValueToRemove, ".":U) = 0 THEN
    DO:
      DO iItem = 1 TO NUM-ENTRIES(phSelectionList:LIST-ITEMS, phSelectionList:DELIMITER):

        ASSIGN
            cEntry = ENTRY(iItem, phSelectionList:LIST-ITEMS, phSelectionList:DELIMITER)
            cEntry = (IF NUM-ENTRIES(cEntry, ".":U) > 1 THEN ENTRY(2, cEntry, ".":U) ELSE cEntry).

        IF cEntry = pcValueToRemove THEN
        DO:
          iCount = iCount + 1.

          IF iCount = 1 THEN
            ASSIGN
                pcRemovedEntry = ENTRY(iItem, phSelectionList:LIST-ITEMS, phSelectionList:DELIMITER)
                lSuccess       = phSelectionList:DELETE(iItem).
        END.
      END.
    END.

  RETURN.   /* Function return value. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight AS DECIMAL    NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth  AS DECIMAL    NO-UNDO.

  DEFINE VARIABLE lResizedObjects   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dFrameHeight      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dFrameWidth       AS DECIMAL    NO-UNDO.

  ASSIGN    
      gdInitialHeight = pdHeight
      gdInitialWidth  = pdWidth.

  /* If the frame handle is not valid, the object has not been initialized yet */
  IF NOT VALID-HANDLE(ghFrame) THEN
    RETURN.

  ASSIGN
      ghFrame:HIDDEN = TRUE
      dFrameHeight   = ghFrame:HEIGHT-CHARS
      dFrameWidth    = ghFrame:WIDTH-CHARS.
  
  /* If the height OR width of the frame was made smaller */
  IF pdHeight < dFrameHeight OR
     pdWidth  < dFrameWidth  THEN
  DO:
    /* Just in case the window was made longer or wider, allow for the new length or width */
    IF pdHeight > dFrameHeight THEN ghFrame:HEIGHT-CHARS = pdHeight NO-ERROR.
    IF pdWidth  > dFrameWidth  THEN ghFrame:WIDTH-CHARS  = pdWidth  NO-ERROR.

    lResizedObjects = TRUE.

    RUN resizeViewerObjects IN TARGET-PROCEDURE (INPUT pdHeight, INPUT pdWidth).
  END.

  ASSIGN    
      ghFrame:HEIGHT-CHARS         = pdHeight
      ghFrame:WIDTH-CHARS          = pdWidth
      ghFrame:SCROLLABLE           = TRUE
      ghFrame:VIRTUAL-HEIGHT-CHARS = pdHeight
      ghFrame:VIRTUAL-WIDTH-CHARS  = pdWidth
      ghFrame:SCROLLABLE           = FALSE NO-ERROR.

  IF NOT lResizedObjects THEN
    RUN resizeViewerObjects IN TARGET-PROCEDURE (INPUT pdHeight, INPUT pdWidth).

  ghFrame:HIDDEN = FALSE NO-ERROR.

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeViewerObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeViewerObjects Procedure 
PROCEDURE resizeViewerObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight AS DECIMAL  NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth  AS DECIMAL  NO-UNDO.

  DEFINE VARIABLE dDifference AS DECIMAL    NO-UNDO.

  ASSIGN
      /* Set the WIDTH-CHARS of the objects */
      ghSourceFieldLabel:WIDTH-CHARS = (pdWidth - ghBuMap:WIDTH-CHARS - 5.25) / 2 /* Wider Target: (pdWidth - ghBuMap:WIDTH-CHARS - 2.50) / 3  */
      ghTargetFieldLabel:WIDTH-CHARS = ghSourceFieldLabel:WIDTH-CHARS             /* Wider Target: (2 * ghSourceFieldLabel:WIDTH-CHARS) - 0.25 */
      ghSeSourceFields:WIDTH-CHARS   = ghSourceFieldLabel:WIDTH-CHARS
      ghSeTargetFields:WIDTH-CHARS   = ghTargetFieldLabel:WIDTH-CHARS
      ghSeMappedFields:WIDTH-CHARS   = pdWidth - ghBuUnMap:WIDTH-CHARS - 4.00
      
      /* Set the COLUMN of the objects */
      ghTargetFieldLabel:COLUMN      = ghSourceFieldLabel:COLUMN + ghSourceFieldLabel:WIDTH-CHARS + 2.25 + ghBuMap:WIDTH-CHARS
      ghSeTargetFields:COLUMN        = ghTargetFieldLabel:COLUMN
      ghBuUnMap:COLUMN               = pdWidth - ghBuUnMap:WIDTH-CHARS
      ghBuMap:COLUMN                 = ghSourceFieldLabel:COLUMN + ghSourceFieldLabel:WIDTH-CHARS + 1.00
      
      /* Set the HEIGHT-CHARS of the objects */
      ghSeSourceFields:HEIGHT-CHARS  = (pdHeight - (2 * ghSourceFieldLabel:HEIGHT-CHARS)) * 0.75
      dDifference                    = ghSeSourceFields:HEIGHT-CHARS - ghSeTargetFields:HEIGHT-CHARS
      ghSeTargetFields:HEIGHT-CHARS  = ghSeSourceFields:HEIGHT-CHARS
      ghSeMappedFields:HEIGHT-CHARS  = pdHeight - (ghSeMappedFields:ROW + dDifference) + 1.00
      
      /* Set the ROW of the objects */
      ghMappedFieldLabel:ROW         = ghMappedFieldLabel:ROW + dDifference
      ghSeMappedFields:ROW           = ghSeMappedFields:ROW   + dDifference
      ghBuUnMap:ROW                  = ghBuUnMap:ROW          + dDifference NO-ERROR.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trgButtonChoose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgButtonChoose Procedure 
PROCEDURE trgButtonChoose :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcEventParameter AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cSourceFieldValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargetFieldValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMappedFieldValue AS CHARACTER  NO-UNDO.

  CASE pcEventParameter:
    WHEN "buMap":U THEN
    DO:
      /* Remove the entry in the Source list */
      RUN removeSLEntry IN TARGET-PROCEDURE (INPUT  ghSeSourceFields,
                                             INPUT  ghSeSourceFields:SCREEN-VALUE,
                                             OUTPUT cSourceFieldValue).

      /* Remove the entry in the Target list */
      RUN removeSLEntry IN TARGET-PROCEDURE (INPUT  ghSeTargetFields,
                                             INPUT  ghSeTargetFields:SCREEN-VALUE,
                                             OUTPUT cTargetFieldValue).

      ghSeMappedFields:ADD-LAST(cTargetFieldValue + ",":U + cSourceFieldValue).

      ghBuMap:SENSITIVE = FALSE.

      {fn updateForeignFields}.
    END.

    WHEN "buUnMap":U THEN
    DO:
      /* Remove the entry in the Source list */
      RUN removeSLEntry IN TARGET-PROCEDURE (INPUT  ghSeMappedFields,
                                             INPUT  ghSeMappedFields:SCREEN-VALUE,
                                             OUTPUT cMappedFieldValue).

      ghSeSourceFields:ADD-LAST(ENTRY(2, cMappedFieldValue)).
      ghSeTargetFields:ADD-LAST(ENTRY(1, cMappedFieldValue)).

      ghBuUnMap:SENSITIVE = FALSE.
      
      {fn updateForeignFields}.
    END.

  END CASE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trgMouseSelectDblclick) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgMouseSelectDblclick Procedure 
PROCEDURE trgMouseSelectDblclick :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE pcEventParameter  AS CHARACTER  NO-UNDO.
MESSAGE pcEventParameter.
  CASE pcEventParameter:
    WHEN "seMappedFields":U THEN
      APPLY "CHOOSE":U TO ghBuUnMap.
  END CASE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trgValueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trgValueChanged Procedure 
PROCEDURE trgValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcEventParameter AS CHARACTER  NO-UNDO.

  CASE pcEventParameter:
    WHEN "seSourceFields":U OR
    WHEN "seTargetFields":U THEN
    DO:
      IF (ghSeSourceFields:SCREEN-VALUE <> "":U AND 
          ghSeSourceFields:SCREEN-VALUE <> ?)   AND 
         (ghSeTargetFields:SCREEN-VALUE <> "":U AND
          ghSeTargetFields:SCREEN-VALUE <> ?)   THEN
        ghBuMap:SENSITIVE = TRUE.
      ELSE
        ghBuMap:SENSITIVE = FALSE.
    END.

    WHEN "seMappedFields":U THEN
    DO:
      IF ghSeMappedFields:SCREEN-VALUE <> "":U AND 
         ghSeMappedFields:SCREEN-VALUE <> ?    THEN
        ghBuUnMap:SENSITIVE = TRUE.
      ELSE
        ghBuUnMap:SENSITIVE = FALSE.
    END.
  END CASE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-updateForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateForeignFields Procedure 
FUNCTION updateForeignFields RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFFields  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry    AS INTEGER    NO-UNDO.

  DO iEntry = 1 TO NUM-ENTRIES(ghSeMappedFields:LIST-ITEMS, ghSeMappedFields:DELIMITER):
    cFFields = cFFields + (IF cFFields = "":U THEN "":U ELSE ",":U)
             + ENTRY(iEntry, ghSeMappedFields:LIST-ITEMS, ghSeMappedFields:DELIMITER).
  END.

  ghEdForeignFields:SCREEN-VALUE = ghSeMappedFields:LIST-ITEMS /*cFFields*/ .

  APPLY "VALUE-CHANGED":U TO ghEdForeignFields.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

