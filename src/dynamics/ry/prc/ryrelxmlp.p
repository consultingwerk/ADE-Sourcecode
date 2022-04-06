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
/*---------------------------------------------------------------------------------
  File: ryrelxmlp.p

  Description:  Relationship XML Import

  Purpose:      Imports relationships defined an XML file into to the Dynamics repository

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   06/22/2002  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */
&scop object-name       ryrelxmlp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

{src/adm2/globals.i}

/* Replace control character function call */
{af/sup2/afxmlreplctrl.i}

/* ttNode table and manipulation include */
{af/sup2/afttnode.i}


DEFINE VARIABLE giRecNo       AS INTEGER    NO-UNDO.
DEFINE VARIABLE ghXMLHlpr           AS HANDLE    NO-UNDO.

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO


DEFINE TEMP-TABLE ttTable NO-UNDO RCODE-INFORMATION
  FIELD cTableName      AS CHARACTER  FORMAT "X(30)" LABEL "Table Name"
  FIELD cTableDB        AS CHARACTER  FORMAT "X(5)"  LABEL "DBName"
  FIELD cEntityMnemonic AS CHARACTER
  INDEX pudx IS UNIQUE PRIMARY
    cTableDB
    cTableName
  .

DEFINE TEMP-TABLE ttRelate NO-UNDO RCODE-INFORMATION
  FIELD iSeq                     AS INTEGER
  FIELD relationship_obj         AS DECIMAL DECIMALS 9
  FIELD relationship_reference   AS CHARACTER FORMAT "X(30)"   LABEL "Reference"
  FIELD relationship_description AS CHARACTER LABEL "Description"
  FIELD parent_entity            AS CHARACTER FORMAT "X(30)"   LABEL "Parent"
  FIELD child_entity             AS CHARACTER FORMAT "X(30)"   LABEL "Child"
  FIELD primary_relationship     AS CHARACTER FORMAT "X(3)"    LABEL "Pri"
  FIELD identifying_relationship AS CHARACTER FORMAT "X(3)"    LABEL "ID"
  FIELD nulls_allowed            AS CHARACTER FORMAT "X(3)"    LABEL "Nulls"
  FIELD cardinality              AS CHARACTER FORMAT "X(4)"    LABEL "Card."
  FIELD update_parent_allowed    AS CHARACTER FORMAT "X(3)"    LABEL "Par"
  FIELD parent_delete_action     AS CHARACTER FORMAT "X"       LABEL "PD"
  FIELD parent_insert_action     AS CHARACTER FORMAT "X"       LABEL "PI"
  FIELD parent_update_action     AS CHARACTER FORMAT "X"       LABEL "PU"
  FIELD parent_verb_phrase       AS CHARACTER FORMAT "X(30)"   LABEL "Parent Verb Phrase"
  FIELD child_delete_action      AS CHARACTER FORMAT "X"       LABEL "CD"
  FIELD child_insert_action      AS CHARACTER FORMAT "X"       LABEL "CI"
  FIELD child_update_action      AS CHARACTER FORMAT "X"       LABEL "CU"
  FIELD child_verb_phrase        AS CHARACTER FORMAT "X(30)"   LABEL "Child Verb Phrase"
  FIELD model_external_reference AS CHARACTER INITIAL ?
  FIELD ParentDBName             AS CHARACTER
  FIELD ChildDBName              AS CHARACTER
  FIELD JoinFields               AS CHARACTER FORMAT "X(70)"   LABEL "Join Fields"
  FIELD DataError                AS CHARACTER FORMAT "X(128)"  LABEL "Data Error"
  INDEX pudx IS UNIQUE PRIMARY
    iSeq
  INDEX dx 
    ParentDBName
    parent_entity
    ChildDBName
    child_entity
  INDEX udxModelRef IS UNIQUE
    model_external_reference
  INDEX dxChild
    ParentDBName
    child_entity
  INDEX udxRelRef IS UNIQUE
    relationship_reference
  .

DEFINE TEMP-TABLE ttRelateImport NO-UNDO LIKE ttRelate.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-mergeTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD mergeTables Procedure 
FUNCTION mergeTables RETURNS LOGICAL
  ( INPUT phSourceBuff AS HANDLE,
    INPUT phTargetBuff AS HANDLE,
    INPUT pcFieldList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainEntityMnemonic) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD obtainEntityMnemonic Procedure 
FUNCTION obtainEntityMnemonic RETURNS CHARACTER
  ( INPUT pcDBName AS CHARACTER,
    INPUT pcTable  AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parseJoinString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD parseJoinString Procedure 
FUNCTION parseJoinString RETURNS CHARACTER
  (INPUT pcJoinString AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-verifyJoinField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD verifyJoinField Procedure 
FUNCTION verifyJoinField RETURNS CHARACTER
  ( INPUT pcFieldName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD writeRecord Procedure 
FUNCTION writeRecord RETURNS LOGICAL
  ()  FORWARD.

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
         HEIGHT             = 24.57
         WIDTH              = 63.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-applyData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyData Procedure 
PROCEDURE applyData :
/*------------------------------------------------------------------------------
  Purpose:     Loop through the bttRelate table and add all the relationships
               to the repository.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttRelate               FOR ttRelate.
  DEFINE BUFFER bryc_relationship       FOR ryc_relationship.
  DEFINE BUFFER bryc_relationship_field FOR ryc_relationship_field.

  DEFINE VARIABLE hSource           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTarget           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSourceField      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTargetField      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeq              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cParentField      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lError            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cMessage          AS CHARACTER  NO-UNDO.
  
  IF CAN-FIND(FIRST bttRelate WHERE bttRelate.DataError <> "":U) THEN
  DO:
    cMessage = {af/sup2/aferrortxt.i 'ICF' '4' '?' '?'}.
    lError = YES.
  END.

  IF NOT lError THEN
  tran-block:
  DO TRANSACTION ON ERROR UNDO, LEAVE:
    /* Loop through the relationships */
    FOR EACH bttRelate:
      /* If the obj is not unknown, we've found this record before. */
      IF bttRelate.relationship_obj <> ? THEN
      DO:
        /* Find the database record. */
        FIND bryc_relationship
          WHERE bryc_relationship.relationship_obj = bttRelate.relationship_obj
          NO-ERROR.

        /* Now whack all the relationship fields */
        FOR EACH bryc_relationship_field
          WHERE bryc_relationship_field.relationship_obj = bryc_relationship.relationship_obj:
          DELETE bryc_relationship_field.
        END. /* FOR EACH bryc_relationship_field */
      END.   /* IF bttRelate.relationship_obj <> ? */
       
      IF NOT AVAILABLE(bryc_relationship) THEN
        CREATE bryc_relationship.


      /* If the relationship reference has not yet been set, do it now. */
      IF bttRelate.relationship_reference = ? THEN
        ASSIGN bryc_relationship.relationship_reference = DYNAMIC-FUNCTION("getNextSequenceValue":U IN gshGenManager,
                                                          INPUT 0.0,
                                                          INPUT "RYCRE":U,
                                                          INPUT "REL"
                                                          ).
      ELSE
        bryc_relationship.relationship_reference = bttRelate.relationship_reference.

      IF bttRelate.model_external_reference = "":U AND
         bryc_relationship.model_external_reference = "":U THEN
        bryc_relationship.model_external_reference = bryc_relationship.relationship_reference.
      ELSE IF bttRelate.model_external_reference <> "":U THEN
        bryc_relationship.model_external_reference = bttRelate.model_external_reference.
      
      ASSIGN
        bryc_relationship.relationship_description  = bttRelate.relationship_description
        bryc_relationship.parent_entity             = bttRelate.parent_entity           
        bryc_relationship.child_entity              = bttRelate.child_entity            
        bryc_relationship.primary_relationship      = (IF bttRelate.primary_relationship = "YES":U THEN YES ELSE NO)  
        bryc_relationship.identifying_relationship  = (IF bttRelate.identifying_relationship = "YES":U THEN YES ELSE NO)
        bryc_relationship.nulls_allowed             = (IF bttRelate.nulls_allowed  = "YES":U THEN YES ELSE NO)         
        bryc_relationship.cardinality               = bttRelate.cardinality             
        bryc_relationship.update_parent_allowed     = (IF bttRelate.update_parent_allowed = "YES":U THEN YES ELSE NO)  
        bryc_relationship.parent_delete_action      = bttRelate.parent_delete_action    
        bryc_relationship.parent_insert_action      = bttRelate.parent_insert_action    
        bryc_relationship.parent_update_action      = bttRelate.parent_update_action    
        bryc_relationship.parent_verb_phrase        = bttRelate.parent_verb_phrase      
        bryc_relationship.child_delete_action       = bttRelate.child_delete_action     
        bryc_relationship.child_insert_action       = bttRelate.child_insert_action     
        bryc_relationship.child_update_action       = bttRelate.child_update_action     
        bryc_relationship.child_verb_phrase         = bttRelate.child_verb_phrase       
      .

      VALIDATE bryc_relationship.

      /* Now add all the fields in the join field list to the database */
      ASSIGN
        iCount = 1
        iSeq   = 0.
      REPEAT WHILE iCount < NUM-ENTRIES(bttRelate.JoinFields):
        cParentField = ENTRY(iCount + 1,bttRelate.JoinFields).
        cChildField  = ENTRY(iCount,bttRelate.JoinFields).
        IF NUM-ENTRIES(cParentField,".":U) <> 2 THEN
        DO:
          lError = YES.
          cMessage = {af/sup2/aferrortxt.i 'ICF' '5' '?' '?' 'Parent' cParentField}.
          UNDO tran-block, LEAVE tran-block.
        END.
        IF NUM-ENTRIES(cChildField,".":U) <> 2 THEN
        DO:
          lError = YES.
          cMessage = {af/sup2/aferrortxt.i 'ICF' '5' '?' '?' 'Child' cChildField}.
          UNDO tran-block, LEAVE tran-block.
        END.
        CREATE bryc_relationship_field.
        ASSIGN
          iSeq = iSeq + 1
          bryc_relationship_field.relationship_obj = bryc_relationship.relationship_obj
          bryc_relationship_field.join_sequence = iSeq
          bryc_relationship_field.parent_table_name = ENTRY(1,cParentField,".":U)
          bryc_relationship_field.parent_field_name = ENTRY(2,cParentField,".":U)
          bryc_relationship_field.child_table_name = ENTRY(1,cChildField,".":U)
          bryc_relationship_field.child_field_name = ENTRY(2,cChildField,".":U)
          .
        iCount = iCount + 2.
      END.

    END.     /* FOR EACH bttRelate */
  END.       /* DO TRANSACTION */

  IF lError THEN
    RETURN cMessage.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRelationshipXML) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRelationshipXML Procedure 
PROCEDURE loadRelationshipXML :
/*------------------------------------------------------------------------------
  Purpose:     This procedure parses the ICFSETUP.XML file for the pages and 
               and information that it needs to run the utility.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFileName  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hRootNode     AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hTableNode    AS HANDLE   NO-UNDO.
  DEFINE VARIABLE lSuccess      AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE iCount        AS INTEGER  NO-UNDO.
  DEFINE VARIABLE hXDoc         AS HANDLE   NO-UNDO.
  DEFINE VARIABLE mXMLDoc       AS MEMPTR.
  DEFINE VARIABLE cRetVal       AS CHARACTER  NO-UNDO.
  SET-SIZE(mXMLDoc) = 0.

  DEFINE BUFFER bttTable             FOR ttTable.

  EMPTY TEMP-TABLE ttRelate.
  IF NOT TRANSACTION THEN EMPTY TEMP-TABLE ttTable. ELSE FOR EACH ttTable: DELETE ttTable. END.
    
  /* Load the XML document */
  hXDoc = DYNAMIC-FUNCTION("loadXMLDoc":U IN ghXMLHlpr,
                           pcFileName,
                           mXMLDoc,
                           OUTPUT cRetVal).


  /* Create two node references */
  CREATE X-NODEREF hRootNode.

  /* Set the root node */
  lSuccess = hXDoc:GET-DOCUMENT-ELEMENT(hRootNode).

  /* If we're not successful we have an invalid XML file */
  IF NOT lSuccess THEN
    RETURN "DCUSTARTUPERR: COULD NOT PARSE CONFIG FILE":U.

  CREATE X-NODEREF hTableNode.
  
  /* Iterate through the root node's children */
  REPEAT iCount = 1 TO hRootNode:NUM-CHILDREN:
    /* Set the current Session Node */
    lSuccess = hRootNode:GET-CHILD(hTableNode,iCount).

    IF NOT lSuccess THEN
      NEXT.

    /* If the node is blank, skip it */
    IF hTableNode:SUBTYPE = "TEXT":U AND
       hTableNode:NODE-VALUE = CHR(10) THEN
      NEXT.

    /* If the name of this node is "table" and the TableName attribute exists,
       we need to import the data */  
    IF hTableNode:NAME = "table":U   AND
       CAN-DO(hTableNode:ATTRIBUTE-NAMES,"TableName":U) AND
       CAN-DO(hTableNode:ATTRIBUTE-NAMES,"DBName":U) THEN
    DO:

      /* First add a table to the ttTable record if it doesn't exist */
      FIND bttTable 
        WHERE bttTable.cTableDB = hTableNode:GET-ATTRIBUTE("DBName":U)
          AND bttTable.cTableName = hTableNode:GET-ATTRIBUTE("TableName":U)
        NO-ERROR.
      IF NOT AVAILABLE(bttTable) THEN
      DO:
        CREATE bttTable.
        ASSIGN
          bttTable.cTableName = hTableNode:GET-ATTRIBUTE("TableName":U)
          bttTable.cTableDB = hTableNode:GET-ATTRIBUTE("DBName":U)
          .

      END.

      EMPTY TEMP-TABLE ttNode.
      RUN recurseNodes(hTableNode,hTableNode:GET-ATTRIBUTE("TableName":U)).
    END.
  END.
   
  /* Make sure that ttNode is empty */
  EMPTY TEMP-TABLE ttNode.
  

  /* Delete the objects */
  DELETE OBJECT hRootNode.
  hRootNode = ?.
  DELETE OBJECT hTableNode.
  hTableNode = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mergeDBData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mergeDBData Procedure 
PROCEDURE mergeDBData :
/*------------------------------------------------------------------------------
  Purpose:     Merge repository relationships with the temp-table.
  Parameters:  <none>
  Notes:       
       This procedure attempts to find a corresponding record in the database 
       that we can use to obtain other information that is not on the ttRelate
       table.. 
       
       Relationship records are found in the repository as follows:
       
       1) Use the relationship_reference. This may have been set in the XML 
          file
      
       2) Use model_external_reference. This is something that comes from 
          the CASE tool that may already exist in the user's repository.
          
       3) See if we can figure it out using the join information. 
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttRelate               FOR ttRelate.
  DEFINE BUFFER bryc_relationship       FOR ryc_relationship.
  DEFINE BUFFER bryc_relationship_field FOR ryc_relationship_field.

  DEFINE VARIABLE oRelObj                AS DECIMAL DECIMALS 9    NO-UNDO.
  DEFINE VARIABLE lMatch                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCount                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSeq                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cEntry                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentField           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChildField            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBFieldList           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMergeFieldList        AS CHARACTER  NO-UNDO.
  cMergeFieldList =
  "relationship_reference,relationship_description,model_external_reference,primary_relationship,update_parent_allowed,parent_verb_phrase,child_verb_phrase":U.

  /* Loop through all the data in ttRelate that don't have errors */
  FOR EACH bttRelate:
    IF bttRelate.DataError <> "":U THEN
      NEXT.

    /* Now try and find an ryc_relationship with the relationship_reference */
    IF bttRelate.relationship_reference <> ? THEN
    DO:
      FIND bryc_relationship NO-LOCK
        WHERE bryc_relationship.relationship_reference = bttRelate.relationship_reference
        NO-ERROR.
    END.

    /* If we don't have a bryc_relationship, see if we can find a relationship
       using the model_external_reference. */
    IF NOT AVAILABLE(bryc_relationship) AND
       bttRelate.model_external_reference <> ? THEN
    DO:
      FIND bryc_relationship NO-LOCK
        WHERE bryc_relationship.model_external_reference = bttRelate.model_external_reference
        NO-ERROR.
    END.

    /* Now see if we can find a relationship using the relationship join information */
    IF NOT AVAILABLE(bryc_relationship) THEN
    DO:
      oRelObj = 0.0.
      FOR EACH bryc_relationship NO-LOCK
        WHERE bryc_relationship.parent_entity = bttRelate.parent_entity
          AND bryc_relationship.child_entity = bttRelate.child_entity:
        lMatch = YES.
        cDBFieldList = "":U.
        FOR EACH bryc_relationship_field NO-LOCK
          WHERE bryc_relationship_field.relationship_obj = bryc_relationship.relationship_obj:
          
          /* Now we need to see if the parent *and* child fields are in the
             can-do list. If any of them are not, we don't have a match. */
          IF bryc_relationship_field.parent_table_name <> "":U THEN
            cParentField = bryc_relationship_field.parent_table_name + ".":U 
                         + bryc_relationship_field.parent_field_name.
          ELSE
            cParentField = bryc_relationship_field.parent_field_name.
          
          IF bryc_relationship_field.child_table_name <> "":U THEN
            cChildField = bryc_relationship_field.child_table_name + ".":U 
                         + bryc_relationship_field.child_field_name.
          ELSE
            cChildField = bryc_relationship_field.child_field_name.

          cDBFieldList = cDBFieldList + (IF cDBFieldList = "":U THEN "":U ELSE ",":U)
                       + cParentField + ",":U + cChildField.

          IF NOT CAN-DO(bttRelate.JoinFields,cParentField) OR
             NOT CAN-DO(bttRelate.JoinFields,cChildField) THEN
          DO:
            lMatch = NO.
            LEAVE.
          END.
        END.

        /* Now we know all the fields in the database are in the join field
           list. Let's make sure that the opposite is true */
        DO iCount = 1 TO NUM-ENTRIES(bttRelate.JoinFields):
          cEntry = ENTRY(iCount,bttRelate.JoinFields).
          IF NOT CAN-DO(cDBFieldList,cEntry) THEN
          DO:
            lMatch = NO.
            LEAVE.
          END.
        END.

        /* If we still have a match, we can set the obj */
        IF lMatch THEN
        DO:
          oRelObj = bryc_relationship.relationship_obj.
          LEAVE.
        END.

      END. /* FOR EACH bryc_relationship */

      IF oRelObj <> 0.0 THEN
      DO:
        FIND bryc_relationship NO-LOCK
          WHERE bryc_relationship.relationship_obj = oRelObj
          NO-ERROR.
      END.

    END. /* IF NOT AVAILABLE(bryc_relationship) */

    /* If we don't have a relationship at this point, it doesn't exist in 
       the repository */
    IF NOT AVAILABLE(bryc_relationship) THEN 
      NEXT.

    ASSIGN
      bttRelate.relationship_obj = bryc_relationship.relationship_obj
    .
    mergeTables(INPUT BUFFER bryc_relationship:HANDLE, 
                INPUT BUFFER bttRelate:HANDLE,
                cMergeFieldList).

  END. /* FOR EACH bttRelate: */
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "Relationship Import Plip".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainRelationTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtainRelationTables Procedure 
PROCEDURE obtainRelationTables :
/*------------------------------------------------------------------------------
  Purpose:     Returns a handle to the temp-tables that contain the parsed
               data. This is for test purposes.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER phTable    AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phRelation AS HANDLE     NO-UNDO.

  phTable    = TEMP-TABLE ttTable:HANDLE.
  phRelation = TEMP-TABLE ttRelate:HANDLE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Start the XML helper API */
RUN startProcedure IN THIS-PROCEDURE ("ONCE|af/app/afxmlhlprp.p":U, 
                                      OUTPUT ghXMLHlpr).

{ry/app/ryplipsetu.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareDataForLoad) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareDataForLoad Procedure 
PROCEDURE prepareDataForLoad :
/*------------------------------------------------------------------------------
  Purpose:     This procedure scans the data in the ttRelate table and massages
               it so that it is in the format expected in the applyDataToDb
               procedure.
  Parameters:  <none>
  Notes:       
    This procedure prepares each record for import by cleaning up all the
    fields and copying the data into the ttRelateImport table with all the
    information that needs to be there in the repository.
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttRelate       FOR ttRelate.
  DEFINE BUFFER bttRelateImport FOR ttRelateImport.
  DEFINE BUFFER bDup      FOR ttRelate.
  DEFINE BUFFER bttTable  FOR ttTable.

  DEFINE VARIABLE cEntityMnemonic  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataErr         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRIFieldList     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMergeFieldList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCheckFieldList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hBuffer          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cField           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDupErr          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cJoinList        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cChangedFields   AS CHARACTER  NO-UNDO.
  cRIFieldList = "parent_delete_action,parent_insert_action,parent_update_action,child_delete_action,child_insert_action,child_update_action":U.
  cMergeFieldList =
  "relationship_reference,relationship_description,parent_entity,child_entity,primary_relationship,identifying_relationship,nulls_allowed,cardinality,update_parent_allowed,parent_delete_action,parent_insert_action,parent_update_action,parent_verb_phrase,child_delete_action,child_insert_action,child_update_action,child_verb_phrase,model_external_reference":U.
  cCheckFieldList = "parent_entity,child_entity,primary_relationship,identifying_relationship,nulls_allowed,cardinality,update_parent_allowed,parent_delete_action,parent_insert_action,parent_update_action,child_delete_action,child_insert_action,child_update_action,model_external_reference":U.
  
  /* First we need to clean up the data in the current table.
     Some of the data in the target database may need to be in a 
     different format to what it is in the temp-tables. We need to sort
     that out first. */

  hBuffer = BUFFER bttRelate:HANDLE.
  FOR EACH bttRelate:
    cDataErr = "":U.

    /* Let's find the entity mnemonic for the parent entity */
    cEntityMnemonic = obtainEntityMnemonic(bttRelate.ParentDBName, bttRelate.parent_entity).
    IF cEntityMnemonic <> ? THEN
      bttRelate.parent_entity = cEntityMnemonic.
    ELSE
      cDataErr = cDataErr + (IF cDataErr = "":U THEN "":U ELSE ",":U)
               + "Parent Entity not on file".

    /* Now find the entity mnemonic for the child entity */
    cEntityMnemonic = obtainEntityMnemonic(bttRelate.ChildDBName, bttRelate.child_entity).
    IF cEntityMnemonic <> ? THEN
      bttRelate.child_entity = cEntityMnemonic.
    ELSE
      cDataErr = cDataErr + (IF cDataErr = "":U THEN "":U ELSE ",":U)
               + "Child Entity not on file".

    /* Sort out cardinality. By default, ERWin dumps the cardinality out
       as "", "Z", "P", or n. We need to convert that to what we expect 
       in the framework */
    CASE bttRelate.cardinality:
      WHEN "":U THEN
        bttRelate.cardinality = "01M":U.
      WHEN "Z":U THEN
        bttRelate.cardinality = "01":U.
      WHEN "P":U THEN
        bttRelate.cardinality = "1M":U.
      /* If none of these cases was satisfied, leave it as it is. */
    END.

    /* Now make sure that all the referential integrity rules have the
       appropriate values in them. */
    DO iCount = 1 TO NUM-ENTRIES(cRIFieldList):
      cField = ENTRY(iCount, cRIFieldList).
      CASE STRING(hBuffer:BUFFER-FIELD(cField):BUFFER-VALUE):
        WHEN "SET NULL":U THEN
          hBuffer:BUFFER-FIELD(cField):BUFFER-VALUE = "S":U.
        WHEN "CASCADE":U THEN
          hBuffer:BUFFER-FIELD(cField):BUFFER-VALUE = "C":U.
        WHEN "RESTRICT":U THEN
          hBuffer:BUFFER-FIELD(cField):BUFFER-VALUE = "R":U.
        WHEN "NONE":U THEN
          hBuffer:BUFFER-FIELD(cField):BUFFER-VALUE = "N":U.
      END.
      IF NOT CAN-DO("S,C,R,N":U, hBuffer:BUFFER-FIELD(cField):BUFFER-VALUE) THEN
        cDataErr = cDataErr + (IF cDataErr = "":U THEN "":U ELSE ",":U)
                 + "Invalid RI in " + hBuffer:BUFFER-FIELD(cField):NAME.
    END.

    /* Now we need to clean up the join fields. The following function
       call takes the existing join fields field and converts it to 
       a comma-separated list of field pairs. */
    cJoinList = parseJoinString(bttRelate.JoinFields).
    IF cJoinList = ? THEN
      cDataErr = cDataErr + (IF cDataErr = "":U THEN "":U ELSE ",":U)
               + "Invalid join field list".
    ELSE
    DO:
      bttRelate.JoinFields = cJoinList.
      FIND FIRST bDup 
        WHERE bDup.ParentDBName  = bttRelate.ParentDBName
          AND bDup.parent_entity = bttRelate.parent_entity
          AND bDup.ChildDBName   = bttRelate.ChildDBName
          AND bDup.child_entity  = bttRelate.child_entity
          AND bDup.JoinFields    = bttRelate.JoinFields
          AND bDup.iSeq          <> bttRelate.iSeq
        NO-ERROR.
      IF AVAILABLE(bDup) THEN
      DO:
        lDupErr = YES.
        /* If either the model ref or the relation ref are unknown on either table
           the data could be munged. So now we need to try and merge the data. */
        IF (bDup.model_external_reference = ? OR
            bttRelate.model_external_reference = ?) AND
           (bDup.relationship_reference = ? OR
            bttRelate.relationship_reference = ?) THEN
        DO:
          BUFFER-COMPARE bttRelate 
            EXCEPT iSeq
            TO bDup SAVE cChangedFields.

          lDupErr = NO.
          /* If there is no difference between the records, delete the duplicate */
          IF cChangedFields = "":U OR
             cChangedFields = ? THEN
            DELETE bDup.

          /* If any of the fields in the clash list are there, we can't do the 
             compare. */
          ELSE  /* Now we have to merge these records together */
          DO:
            do-loop:
            DO iCount = 1 TO NUM-ENTRIES(cChangedFields):
              IF CAN-DO(cCheckFieldList, ENTRY(iCount, cChangedFields)) THEN
              DO:
                cDataErr = cDataErr + (IF cDataErr = "":U THEN "":U ELSE ",":U)
                         + "Duplicate Relationship".
                lDupErr = YES.
                LEAVE do-loop.
              END.
            END.
            IF NOT lDupErr THEN
            DO:
              EMPTY TEMP-TABLE ttRelateImport.
              CREATE bttRelateImport.
              BUFFER-COPY bDup TO bttRelateImport.
              mergeTables(INPUT BUFFER bttRelate:HANDLE, INPUT BUFFER bttRelateImport:HANDLE, cMergeFieldList).
              DELETE bDup.
              BUFFER-COPY bttRelateImport TO bttRelate.
              DELETE bttRelateImport.
            END.
          END. /* ELSE on IF cChangedFields = "":U OR cChangedFields = ? */
        END. /* IF (bDup.model_external_reference = ? OR bttRelate.model ... */
        IF lDupErr THEN
           ASSIGN
             bDup.DataError = bDup.DataError + (IF bDup.DataError = "":U THEN "":U ELSE ",":U)
                            + "Duplicate Relationship"
             cDataErr = cDataErr + (IF cDataErr = "":U THEN "":U ELSE ",":U)
                      + "Duplicate Relationship"
           .
      END. /* IF AVAILABLE(bDup) */
    END.
    
    bttRelate.DataError = cDataErr.

  END. /* FOR EACH bttRelate: */

  RUN mergeDBData.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-recurseNodes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recurseNodes Procedure 
PROCEDURE recurseNodes :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is responsible for constructing the attributes
               into the node table to prepare them for the write into the
               appropriate tables.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phParent      AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcStack       AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hNode       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lSuccess    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLevel      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTest       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRecordType AS CHARACTER  NO-UNDO.

  /* Set the node to look at the next child */
  CREATE X-NODEREF hNode.

  /* Iterate through the children */
  REPEAT iCount = 1 TO phParent:NUM-CHILDREN:
    
    /* Set the node to the child node */
    lSuccess = phParent:GET-CHILD(hNode,iCount).
    IF NOT lSuccess THEN
      NEXT.

    /* If the text has nothing in it, skip it */
    IF hNode:SUBTYPE = "TEXT":U THEN
    DO:
      cTest = REPLACE(hNode:NODE-VALUE, CHR(10), "":U).
      cTest = REPLACE(cTest, CHR(13), "":U).
      cTest = TRIM(cTest).
      IF cTest = "" THEN
        NEXT.
    END.

    /* Set a node value for this node */
    IF hNode:SUBTYPE = "TEXT":U THEN
      setNode(ENTRY(1,pcStack),hNode:NODE-VALUE,NUM-ENTRIES(pcStack),YES).

    /* Go down lower if need be */
    RUN recurseNodes(hNode,hNode:NAME + ",":U + pcStack).

    
    /* If this is level 2 on the stack, we can write out this data
       to the appropriate files */
    IF NUM-ENTRIES(pcStack) = 1  THEN
      writeRecord().

  END.

  DELETE OBJECT hNode.
  hNode = ?.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-mergeTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION mergeTables Procedure 
FUNCTION mergeTables RETURNS LOGICAL
  ( INPUT phSourceBuff AS HANDLE,
    INPUT phTargetBuff AS HANDLE,
    INPUT pcFieldList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: This functions takes two buffers and attempts to merge the contents 
           of the buffers together. The  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCount       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSourceField AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTargetField AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cEntry       AS CHARACTER  NO-UNDO.


  /* Loop through all the fields in the field list */
  DO iCount = 1 TO NUM-ENTRIES(pcFieldList):
    cEntry = ENTRY(iCount,pcFieldList).
    hSourceField = phSourceBuff:BUFFER-FIELD(cEntry) NO-ERROR.
    ERROR-STATUS:ERROR = NO.
    hTargetField = phTargetBuff:BUFFER-FIELD(cEntry) NO-ERROR.
    ERROR-STATUS:ERROR = NO.

    IF NOT VALID-HANDLE(hSourceField) OR
       NOT VALID-HANDLE(hTargetField) THEN
      NEXT.

    /* If the source buffer has a value and the target buffer is either
       blank or unknown, copy the value from the source buffer to the target
       buffer */
    IF hTargetField:BUFFER-VALUE = ? OR
       hTargetField:BUFFER-VALUE = "":U THEN
      hTargetField:BUFFER-VALUE = hSourceField:BUFFER-VALUE.

  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainEntityMnemonic) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION obtainEntityMnemonic Procedure 
FUNCTION obtainEntityMnemonic RETURNS CHARACTER
  ( INPUT pcDBName AS CHARACTER,
    INPUT pcTable  AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:   Retrieves the entity mnemonic for a database/table combination from
             the entity mnemonic table (if necessary) and makes it available
             in the ttTable record. The return value comes from the ttTable 
             record.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttTable             FOR ttTable.
  DEFINE BUFFER bgsc_entity_mnemonic FOR gsc_entity_mnemonic.

  DO TRANSACTION:
    FIND FIRST bttTable 
      WHERE bttTable.cTableDB   = pcDBName
        AND bttTable.cTableName = pcTable
      NO-ERROR.
  
    IF NOT AVAILABLE(bttTable) THEN
    DO:
      CREATE bttTable.
      ASSIGN
        bttTable.cTableDB   = pcDBName
        bttTable.cTableName = pcTable
        .
    END.
  
    /* If the entity mnemonic on the bttTable record is "" we have
       not looked for this entity before. */
    IF bttTable.cEntityMnemonic = "":U THEN
    DO:
      FOR EACH bgsc_entity_mnemonic NO-LOCK
        WHERE bgsc_entity_mnemonic.entity_mnemonic_description = pcTable:
        IF bgsc_entity_mnemonic.entity_dbname = bttTable.cTableDB THEN
          ASSIGN
            bttTable.cEntityMnemonic = bgsc_entity_mnemonic.entity_mnemonic
          .
      END.
      IF bttTable.cEntityMnemonic = "":U THEN
        bttTable.cEntityMnemonic = ?.
    END.
  
    RETURN bttTable.cEntityMnemonic.   /* Function return value. */
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parseJoinString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION parseJoinString Procedure 
FUNCTION parseJoinString RETURNS CHARACTER
  (INPUT pcJoinString AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Takes the contents of the join string and strips it down to a 
            comma separated list of fields.
    Notes: 
    
    The join string that comes is either in the form 
    "child_table.field = parent_table.field and child_table.field = parent_table.field"
    or 
    "child_table.field,parent_table.field,child_table.field,parent_table.field"
    
    The latter is the form that we will return the value in. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCurrString AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRetVal     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLeftOver   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.

  /* If the string is in field pair format, parse it accordingly. */
  IF NUM-ENTRIES(pcJoinString) > 1 AND
     NUM-ENTRIES(pcJoinString) MODULO 2 = 0 THEN
     cLeftOver = pcJoinString.
  ELSE /* We're dealing with a table.field = table.field and ... string */
  DO:
    /* Get rid of all the carriage returns and line-feeds. */
    cLeftOver = TRIM(REPLACE(pcJoinString,CHR(13),"":U)).
    cLeftOver = TRIM(REPLACE(cLeftOver,CHR(10),"":U)).
    
    /* Replace all " AND " with commas - table.field = table.field,table.field... */
    cLeftOver = TRIM(REPLACE(cLeftOver," AND ":U,",":U)).
    
    /* Replace all " " with "" - table.field=table.field,table.field... */
    cLeftOver = TRIM(REPLACE(cLeftOver," ":U,"":U)).
    
    /* Replace all "=" with "," - table.field,table.field,table.field... */
    cLeftOver = TRIM(REPLACE(cLeftOver,"=":U,",":U)).


  END.
  
  cRetVal = "":U.
  IF NUM-ENTRIES(cLeftOver) > 1 AND
     NUM-ENTRIES(cLeftOver) MODULO 2 = 0 THEN
  /* Loop through all the fields in the string */
  DO iCount = 1 TO NUM-ENTRIES(cLeftOver):
    /* obtain the current entry and verify that it is a valid
       field in a connected database */
    ASSIGN
      cCurrString = ENTRY(iCount,cLeftOver)
      cField   = verifyJoinField(cCurrString)
    .

    /* If the field has the unknown value in it, we could not verify the 
       field's existence. Return the ? value and the join string will
       be marked as invalid */
    IF cField = ? THEN
      RETURN ?.

    /* Add the retrieved field to the return value */
    ASSIGN
      cRetVal = cRetVal + (IF cRetVal = "":U THEN "":U ELSE ",":U)
              + cField
    .
  END.

  IF cRetVal = "":U THEN
    RETURN ?.
  ELSE
    RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-verifyJoinField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION verifyJoinField Procedure 
FUNCTION verifyJoinField RETURNS CHARACTER
  ( INPUT pcFieldName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Verifies that a field name actually contains the name of a field
            in a form that we can use, and returns the string in the form
            table.field
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRetVal     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTableName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTable      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuffer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField      AS HANDLE     NO-UNDO.


  /* Fields must be in the form table.field or db.table.field. 
     The following code verifies this and breaks up the string into its
     components. */
  CASE NUM-ENTRIES(pcFieldName,".":U):
    WHEN 2 THEN
      ASSIGN
        cTableName = ENTRY(1,pcFieldName,".":U)
        cFieldName = ENTRY(2,pcFieldName,".":U)
      .
    WHEN 3 THEN
      ASSIGN
        cDBName = ENTRY(1,pcFieldName,".":U)
        cTableName = ENTRY(2,pcFieldName,".":U)
        cFieldName = ENTRY(3,pcFieldName,".":U)
      .
    OTHERWISE
      RETURN ?.
  END.

  IF cDBName <> "":U THEN
    cTable = cDBName + ".":U + cTableName.
  ELSE
    cTable = cTableName.

  /* Now we create the buffer for _field */
  ERROR-STATUS:ERROR = NO.
  CREATE BUFFER hBuffer FOR TABLE cTable NO-ERROR.
  IF ERROR-STATUS:ERROR OR
     ERROR-STATUS:NUM-MESSAGES > 0 THEN
    RETURN ?.

  ERROR-STATUS:ERROR = NO.
  hField = hBuffer:BUFFER-FIELD(cFieldName) NO-ERROR.

  DELETE OBJECT hBuffer.
  ASSIGN
    hBuffer = ?
  .

  IF ERROR-STATUS:ERROR OR
     ERROR-STATUS:NUM-MESSAGES > 0 THEN
    cRetVal = ?.
  ELSE
    cRetVal = cTableName + ".":U + cFieldName.

  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION writeRecord Procedure 
FUNCTION writeRecord RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose:   Creates a buffer record and populates the contents with the
             data contained in the ttNodes table.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSessType   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hKeyField   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPageNo     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCurrField  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hBuffer    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iPageNo     AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttRelate       FOR ttRelate.
  DEFINE BUFFER bttRelateImport FOR ttRelateImport.

  /* Empty the ttRelateImport table that we use for importing the record. */
  EMPTY TEMP-TABLE ttRelateImport.

  /* Go into a transaction */
  DO TRANSACTION:
    /* Create a record */
    CREATE bttRelateImport.
    hBuffer = BUFFER bttRelateImport:HANDLE.

    /* Loop through all the records in the ttNode table.*/
    FOR EACH ttNode:

      /* Get the handle to a field in the TEMP-TABLE that has 
         the name of this node. If we find
         it we set its value */
      hCurrField = hBuffer:BUFFER-FIELD(ttNode.cNode) NO-ERROR.
      ERROR-STATUS:ERROR = NO.
      IF VALID-HANDLE(hCurrField) THEN
        hCurrField:BUFFER-VALUE = ttNode.cValue.
    END.

    IF bttRelateImport.model_external_reference = "":U THEN
       bttRelateImport.model_external_reference = ?.

    IF bttRelateImport.relationship_reference = "":U THEN
       bttRelateImport.relationship_reference = ?.

    /* Now take the record that we created above and see if we can find
       a corresponding record in the ttRelate table */

    /* First try and find it on model_external_reference - The unique ID from the modelling
       tool. */
    IF bttRelateImport.model_external_reference <> ? THEN
      FIND bttRelate 
        WHERE bttRelate.model_external_reference = bttRelateImport.model_external_reference
        NO-ERROR.

    /* Now try and find it using the relationship_reference */
    IF NOT AVAILABLE(bttRelate) AND
      bttRelateImport.relationship_reference <> ? THEN
    DO:
      FIND bttRelate    
        WHERE bttRelate.relationship_reference = bttRelateImport.relationship_reference
        NO-ERROR.
    END.

    /* If we still don't have a record here, we need to create it */
    IF NOT AVAILABLE(bttRelate) THEN
    DO:
      CREATE bttRelate.
      ASSIGN
        giRecNo                          = giRecNo + 1
        bttRelate.iSeq                   = giRecNo
        bttRelate.model_external_reference                = bttRelateImport.model_external_reference
        bttRelate.relationship_reference = bttRelateImport.relationship_reference
        bttRelate.ParentDBName           = bttRelateImport.ParentDBName
        bttRelate.parent_entity          = bttRelateImport.parent_entity
        bttRelate.ChildDBName            = bttRelateImport.ChildDBName
        bttRelate.child_entity           = bttRelateImport.child_entity
        bttRelate.JoinFields             = bttRelateImport.JoinFields
        .
    END.

    ASSIGN
      bttRelate.relationship_description = bttRelateImport.relationship_description 
      bttRelate.primary_relationship     = bttRelateImport.primary_relationship     
      bttRelate.identifying_relationship = bttRelateImport.identifying_relationship 
      bttRelate.nulls_allowed            = bttRelateImport.nulls_allowed            
      bttRelate.cardinality              = bttRelateImport.cardinality              
      bttRelate.update_parent_allowed    = bttRelateImport.update_parent_allowed    
      bttRelate.parent_delete_action     = bttRelateImport.parent_delete_action     
      bttRelate.parent_insert_action     = bttRelateImport.parent_insert_action     
      bttRelate.parent_update_action     = bttRelateImport.parent_update_action     
      bttRelate.child_delete_action      = bttRelateImport.child_delete_action      
      bttRelate.child_insert_action      = bttRelateImport.child_insert_action      
      bttRelate.child_update_action      = bttRelateImport.child_update_action      
      .
    IF bttRelateImport.parent_verb_phrase <> "":U THEN
      bttRelate.parent_verb_phrase       = bttRelateImport.parent_verb_phrase.
    IF bttRelateImport.child_verb_phrase <> "":U THEN
      bttRelate.child_verb_phrase        = bttRelateImport.child_verb_phrase.        

  END.

  EMPTY TEMP-TABLE ttNode.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

