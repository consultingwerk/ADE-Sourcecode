&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" dTables _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" dTables _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartDataObjectWizard" dTables _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* SmartDataObject Wizard
Welcome to the SmartDataObject Wizard! During the next few steps, the wizard will lead you through creating a SmartDataObject. You will define the query that you will use to retrieve data from your database(s) and define a set of field values to make available to visualization objects. Press Next to proceed.
adm2/support/_wizqry.w,adm2/support/_wizfld.w 
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rysttasdoo.w

  Description:  Template Astra 2 SmartDataObject Template

  Purpose:      Template Astra 2 SmartDataObject Template

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6180   UserRef:    
                Date:   28/06/2000  Author:     Anthony Swindells

  Update Notes: V9 Templates

--------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

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

&scop object-name       gsmomfullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{af/sup2/afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataObject
&Scoped-define DB-AWARE yes

&Scoped-define ADM-SUPPORTED-LINKS Data-Source,Data-Target,Navigation-Target,Update-Target,Commit-Target,Filter-Target


/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF


&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gsm_object_menu_structure ryc_smartobject ~
gsm_menu_structure

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  object_obj menu_structure_obj instance_attribute_obj menu_item_obj~
 insert_submenu menu_structure_sequence dummy_field
&Scoped-define ENABLED-FIELDS-IN-gsm_object_menu_structure object_obj ~
menu_structure_obj instance_attribute_obj menu_item_obj insert_submenu ~
menu_structure_sequence 
&Scoped-Define DATA-FIELDS  object_filename object_description container_object menu_structure_code~
 menu_structure_type object_obj menu_structure_obj instance_attribute_obj~
 object_menu_structure_obj menu_item_obj insert_submenu~
 menu_structure_sequence dummy_field
&Scoped-define DATA-FIELDS-IN-gsm_object_menu_structure object_obj ~
menu_structure_obj instance_attribute_obj object_menu_structure_obj ~
menu_item_obj insert_submenu menu_structure_sequence 
&Scoped-define DATA-FIELDS-IN-ryc_smartobject object_filename ~
object_description container_object 
&Scoped-define DATA-FIELDS-IN-gsm_menu_structure menu_structure_code ~
menu_structure_type 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gsmomfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsm_object_menu_structure NO-LOCK, ~
      FIRST ryc_smartobject WHERE ASDB.ryc_smartobject.smartobject_obj = ASDB.gsm_object_menu_structure.object_obj NO-LOCK, ~
      FIRST gsm_menu_structure WHERE ASDB.gsm_menu_structure.menu_structure_obj = ASDB.gsm_object_menu_structure.menu_structure_obj NO-LOCK ~
    BY gsm_object_menu_structure.menu_structure_obj ~
       BY gsm_object_menu_structure.object_obj ~
        BY gsm_object_menu_structure.instance_attribute_obj INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsm_object_menu_structure NO-LOCK, ~
      FIRST ryc_smartobject WHERE ASDB.ryc_smartobject.smartobject_obj = ASDB.gsm_object_menu_structure.object_obj NO-LOCK, ~
      FIRST gsm_menu_structure WHERE ASDB.gsm_menu_structure.menu_structure_obj = ASDB.gsm_object_menu_structure.menu_structure_obj NO-LOCK ~
    BY gsm_object_menu_structure.menu_structure_obj ~
       BY gsm_object_menu_structure.object_obj ~
        BY gsm_object_menu_structure.instance_attribute_obj INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsm_object_menu_structure ~
ryc_smartobject gsm_menu_structure
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsm_object_menu_structure
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main ryc_smartobject
&Scoped-define THIRD-TABLE-IN-QUERY-Query-Main gsm_menu_structure


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsm_object_menu_structure, 
      ryc_smartobject
    FIELDS(ryc_smartobject.object_filename
      ryc_smartobject.object_description
      ryc_smartobject.container_object), 
      gsm_menu_structure
    FIELDS(gsm_menu_structure.menu_structure_code
      gsm_menu_structure.menu_structure_type) SCROLLING.
&ANALYZE-RESUME
{&DB-REQUIRED-END}


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataObject
   Allow: Query
   Frames: 0
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE APPSERVER DB-AWARE
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
  CREATE WINDOW dTables ASSIGN
         HEIGHT             = 1.76
         WIDTH              = 63.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB dTables 
/* ************************* Included-Libraries *********************** */

{src/adm2/data.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW dTables
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for SmartDataObject Query-Main
     _TblList          = "icfdb.gsm_object_menu_structure,icfdb.ryc_smartobject WHERE icfdb.gsm_object_menu_structure ...,icfdb.gsm_menu_structure WHERE icfdb.gsm_object_menu_structure ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED, FIRST USED, FIRST USED"
     _OrdList          = "asdb.gsm_object_menu_structure.menu_structure_obj|yes,asdb.gsm_object_menu_structure.object_obj|yes,asdb.gsm_object_menu_structure.instance_attribute_obj|yes"
     _JoinCode[2]      = "ASDB.ryc_smartobject.smartobject_obj = ASDB.gsm_object_menu_structure.object_obj"
     _JoinCode[3]      = "ASDB.gsm_menu_structure.menu_structure_obj = ASDB.gsm_object_menu_structure.menu_structure_obj"
     _FldNameList[1]   > icfdb.ryc_smartobject.object_filename
"object_filename" "object_filename" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
     _FldNameList[2]   > icfdb.ryc_smartobject.object_description
"object_description" "object_description" ? ? "character" ? ? ? ? ? ? no ? no 70 yes
     _FldNameList[3]   > icfdb.ryc_smartobject.container_object
"container_object" "container_object" ? ? "logical" ? ? ? ? ? ? no ? no 15.8 yes
     _FldNameList[4]   > icfdb.gsm_menu_structure.menu_structure_code
"menu_structure_code" "menu_structure_code" ? ? "character" ? ? ? ? ? ? no ? no 20 yes
     _FldNameList[5]   > icfdb.gsm_menu_structure.menu_structure_type
"menu_structure_type" "menu_structure_type" ? ? "character" ? ? ? ? ? ? no ? no 18.2 yes
     _FldNameList[6]   > icfdb.gsm_object_menu_structure.object_obj
"object_obj" "object_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes
     _FldNameList[7]   > icfdb.gsm_object_menu_structure.menu_structure_obj
"menu_structure_obj" "menu_structure_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes
     _FldNameList[8]   > icfdb.gsm_object_menu_structure.instance_attribute_obj
"instance_attribute_obj" "instance_attribute_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes
     _FldNameList[9]   > icfdb.gsm_object_menu_structure.object_menu_structure_obj
"object_menu_structure_obj" "object_menu_structure_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 33.6 yes
     _FldNameList[10]   > icfdb.gsm_object_menu_structure.menu_item_obj
"menu_item_obj" "menu_item_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes
     _FldNameList[11]   > icfdb.gsm_object_menu_structure.insert_submenu
"insert_submenu" "insert_submenu" ? ? "logical" ? ? ? ? ? ? yes ? no 19 yes
     _FldNameList[12]   > icfdb.gsm_object_menu_structure.menu_structure_sequence
"menu_structure_sequence" "menu_structure_sequence" ? ? "integer" ? ? ? ? ? ? yes ? no 21.4 yes
     _FldNameList[13]   > "_<CALC>"
"RowObject.object_description" "dummy_field" ? "x(8)" "character" ? ? ? ? ? ? yes ? no 8 no
     _Design-Parent    is WINDOW dTables @ ( 1.14 , 2.6 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK dTables 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPlaceHolder dTables  _DB-REQUIRED
PROCEDURE checkPlaceHolder :
/*------------------------------------------------------------------------------
  Purpose:     Recursively called procedure which determines whether there
               exists a circular reference. This procedure checks that the band being
               merged, does not contain any placeholder items on that band, or on any 
               of it's child bands. 
  Parameters:  pdMenuStructure   Band being associated with an object
  
  Notes:       Called from preTransactionValidate
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pdMenuStructure  AS DECIMAL    NO-UNDO.

DEFINE BUFFER BUFgsm_menu_structure_item FOR gsm_menu_structure_item.
DEFINE BUFFER BUFgsm_menu_item           FOR gsm_menu_item.

FOR EACH BUFgsm_menu_structure_item  
    WHERE BUFgsm_menu_structure_item.MENU_structure_obj = pdMenuStructure NO-LOCK:
    FIND  BUFgsm_menu_item 
      WHERE BUFgsm_menu_structure_item.MENU_item_obj = BUFgsm_menu_item.MENU_item_obj NO-LOCK NO-ERROR.

    IF AVAILABLE  BUFgsm_menu_item AND BUFgsm_menu_item.ITEM_control_type = "placeholder":U THEN
      RETURN "ADM-ERROR":U.
    ELSE IF BUFgsm_menu_structure_item.child_menu_structure > 0 THEN
    DO:
       RUN checkPlaceholder(BUFgsm_menu_structure_item.child_menu_structure).
       RETURN RETURN-VALUE.
    END.

END.

RETURN RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkSequence dTables  _DB-REQUIRED
PROCEDURE checkSequence :
/*------------------------------------------------------------------------------
  Purpose:    Check that the specified sequence number does not already exist.
              If it does, resequence all existing sequences so there is no
              duplicate
  Parameters:  phBuffer    Buffer of RowObjUpd
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phBuffer   AS HANDLE  NO-UNDO .
DEFINE OUTPUT PARAMETER pcmessage AS CHARACTER  NO-UNDO.

DEFINE VARIABLE dObjectObj        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dMenuStructureObj AS DECIMAL    NO-UNDO.
DEFINE VARIABLE iSequence         AS INTEGER    NO-UNDO.
DEFINE VARIABLE cMessage          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iPrevSeq          AS INTEGER    NO-UNDO.

ASSIGN 
   dObjectObj        = phBuffer:BUFFER-FIELD("object_obj":U):BUFFER-VALUE
   iSequence         = phBuffer:BUFFER-FIELD("menu_structure_sequence":U):BUFFER-VALUE 
   iPrevSeq          = iSequence
   dMenuStructureObj = phBuffer:BUFFER-FIELD("menu_structure_obj":U):BUFFER-VALUE 
   NO-ERROR.

IF CAN-FIND (FIRST gsm_object_menu_structure NO-LOCK 
             WHERE Object_obj = dObjectObj  
               AND menu_structure_obj <>  dMenuStructureObj
               AND menu_structure_sequence   = iSequence ) THEN 
DO:
   FOR EACH gsm_object_menu_structure
      WHERE Object_obj = dObjectObj  
        AND menu_structure_obj <>  dMenuStructureObj
        AND menu_structure_sequence >= iSequence
         BY menu_structure_sequence:
  
      IF menu_structure_sequence = iPrevSeq THEN
         ASSIGN menu_structure_sequence = menu_structure_sequence + 1
                iPrevSeq                = menu_structure_sequence.
      ELSE
         RETURN.

   END.
END.
   
   



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DATA.CALCULATE dTables  DATA.CALCULATE _DB-REQUIRED
PROCEDURE DATA.CALCULATE :
/*------------------------------------------------------------------------------
  Purpose:     Calculate all the Calculated Expressions found in the
               SmartDataObject.
  Parameters:  <none>
------------------------------------------------------------------------------*/
      ASSIGN 
         rowObject.dummy_field = (RowObject.object_description)
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable dTables  _DB-REQUIRED
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cForeignFields AS CHARACTER  NO-UNDO.

  cForeignFields = DYNAMIC-FUNCTION('getForeignFields' IN THIS-PROCEDURE).

  IF NUM-ENTRIES(cForeignFields) = 2 AND entry(2,cForeignFields) = 'smartobject_obj':U  THEN
    DYNAMIC-FUNCTION('setQuerySort' IN THIS-PROCEDURE,
                    'BY gsm_object_menu_structure.object_obj' +
                   ' BY gsm_object_menu_structure.menu_structure_sequence'). 

  RUN SUPER( INPUT pcRelative).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI dTables  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endTransactionValidate dTables  _DB-REQUIRED
PROCEDURE endTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  FOR EACH RowObjUpd WHERE CAN-DO('A,C,U':U,RowObjUpd.RowMod): 

     /* Check that the Sequence is valid  */
     RUN checkSequence IN THIS-PROCEDURE (INPUT TEMP-TABLE RowObjUpd:DEFAULT-BUFFER-HANDLE,OUTPUT cMessageList).
     IF cMessageList > ""  
     THEN DO:
        ERROR-STATUS:ERROR = NO.
        RETURN cMessageList.
     END.

END.

ERROR-STATUS:ERROR = NO.
RETURN cMessageList.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preTransactionValidate dTables  _DB-REQUIRED
PROCEDURE preTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to validate RowObjUpd records server-side
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.

FOR EACH RowObjUpd WHERE CAN-DO('A,C,U':U,RowObjUpd.RowMod): 

  IF (RowObjUpd.RowMod = 'U':U 
  AND CAN-FIND(FIRST gsm_object_menu_structure
               WHERE gsm_object_menu_structure.menu_structure_obj     = rowObjUpd.menu_structure_obj
                 AND gsm_object_menu_structure.object_obj             = rowObjUpd.object_obj
                 AND gsm_object_menu_structure.instance_attribute_obj = rowObjUpd.instance_attribute_obj
                 AND ROWID(gsm_object_menu_structure)                <> TO-ROWID(ENTRY(1,RowObjUpd.RowIDent))))
  OR (RowObjUpd.RowMod <> 'U':U 
  AND CAN-FIND(FIRST gsm_object_menu_structure
               WHERE gsm_object_menu_structure.menu_structure_obj = rowObjUpd.menu_structure_obj
                 AND gsm_object_menu_structure.object_obj = rowObjUpd.object_obj
                 AND gsm_object_menu_structure.instance_attribute_obj = rowObjUpd.instance_attribute_obj))
  THEN
      ASSIGN cValueList   = STRING(RowObjUpd.menu_structure_obj) + ', ' + STRING(RowObjUpd.object_obj) + ', ' + STRING(RowObjUpd.instance_attribute_obj)
             cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) 
                          + {af/sup2/aferrortxt.i 'AF' '8' 'gsm_object_menu_structure' '' "'menu_structure_obj, object_obj, instance_attribute_obj, '" cValueList }.

END.

FOR EACH RowObjUpd WHERE CAN-DO('A,C,U':U,RowObjUpd.RowMod): 

  /* Check that the placeholder exists within an existing band */

  IF  RowObjUpd.MENU_item_obj > 0 
  AND NOT CAN-FIND(FIRST gsm_menu_structure_item 
                   WHERE gsm_menu_structure_item.MENU_item_obj = RowObjUpd.MENU_item_obj) 
  THEN DO:
      ASSIGN cMessageList = "The specified placeholder item cannot be found within any band".
      ERROR-STATUS:ERROR = NO.
      RETURN cMessageList.
  END.
  
  /* Check that the merged band, or children bands do not contain any placeholders*/

  RUN checkPlaceholder (RowObjUpd.MENU_structure_obj).

  IF RETURN-VALUE = "ADM-ERROR":U 
  THEN DO:
     cMessageList = "You cannot merge this band because this band or it's child bands contain a placeholder".
     ERROR-STATUS:ERROR = NO.
     RETURN cMessageList.
  END.

END.

ERROR-STATUS:ERROR = NO.
RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowObjectValidate dTables 
PROCEDURE rowObjectValidate :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to validate RowObject record client-side
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.

  IF RowObject.menu_structure_type = "MenuBar":U THEN 
  DO:
     cMessageList =  "You cannot create an object/band association for bands that are of type 'Menubar'".
     ERROR-STATUS:ERROR = NO.
     RETURN cMessageList.
  END.

  IF RowObject.menu_structure_obj = 0 OR RowObject.menu_structure_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_object_menu_structure' 'menu_structure_obj' "'Menu Structure Obj'"}.

  IF RowObject.object_obj = 0 OR RowObject.object_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_object_menu_structure' 'object_obj' "'Object Obj'"}.

  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

