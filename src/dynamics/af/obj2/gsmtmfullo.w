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
  File: gsmtmfullo.w

  Description:  ToolbarMenu SDO

  Purpose:      For specifying the toolbar and menubar structure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/28/2001  Author:     Don Bulua

  Update Notes: Created from Template rysttasdoo.w

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

&scop object-name       gsmtmfullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{af/sup2/afglobals.i}

/*&glob DATA-LOGIC-PROCEDURE src/adm2/template/logic.p*/

&SCOPED-DEFINE UPPER_LIMIT 900000
DEFINE VARIABLE miInsertAfter AS INTEGER    NO-UNDO.
DEFINE VARIABLE miLastUpper   AS INTEGER    NO-UNDO.

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
&Scoped-define INTERNAL-TABLES gsm_toolbar_menu_structure ~
gsm_menu_structure

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  object_obj menu_structure_sequence menu_structure_obj~
 menu_structure_alignment menu_structure_row menu_structure_spacing~
 insert_rule
&Scoped-define ENABLED-FIELDS-IN-gsm_toolbar_menu_structure object_obj ~
menu_structure_sequence menu_structure_obj menu_structure_alignment ~
menu_structure_row menu_structure_spacing insert_rule 
&Scoped-Define DATA-FIELDS  toolbar_menu_structure_obj object_obj menu_structure_sequence~
 menu_structure_obj menu_structure_alignment menu_structure_row~
 menu_structure_spacing insert_rule menu_structure_code menu_structure_type~
 menu_structure_description
&Scoped-define DATA-FIELDS-IN-gsm_toolbar_menu_structure ~
toolbar_menu_structure_obj object_obj menu_structure_sequence ~
menu_structure_obj menu_structure_alignment menu_structure_row ~
menu_structure_spacing insert_rule 
&Scoped-define DATA-FIELDS-IN-gsm_menu_structure menu_structure_code ~
menu_structure_type menu_structure_description 
&Scoped-Define MANDATORY-FIELDS  toolbar_menu_structure_obj object_obj menu_structure_sequence~
 menu_structure_obj
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gsmtmfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsm_toolbar_menu_structure NO-LOCK, ~
      FIRST gsm_menu_structure WHERE gsm_menu_structure.menu_structure_obj = gsm_toolbar_menu_structure.menu_structure_obj NO-LOCK ~
    BY gsm_toolbar_menu_structure.object_obj ~
       BY gsm_toolbar_menu_structure.menu_structure_sequence INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsm_toolbar_menu_structure NO-LOCK, ~
      FIRST gsm_menu_structure WHERE gsm_menu_structure.menu_structure_obj = gsm_toolbar_menu_structure.menu_structure_obj NO-LOCK ~
    BY gsm_toolbar_menu_structure.object_obj ~
       BY gsm_toolbar_menu_structure.menu_structure_sequence INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsm_toolbar_menu_structure ~
gsm_menu_structure
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsm_toolbar_menu_structure
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main gsm_menu_structure


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsm_toolbar_menu_structure, 
      gsm_menu_structure SCROLLING.
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
         HEIGHT             = 1.62
         WIDTH              = 51.6.
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
     _TblList          = "icfdb.gsm_toolbar_menu_structure,icfdb.gsm_menu_structure WHERE icfdb.gsm_toolbar_menu_structure ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _OrdList          = "icfdb.gsm_toolbar_menu_structure.object_obj|yes,icfdb.gsm_toolbar_menu_structure.menu_structure_sequence|yes"
     _JoinCode[2]      = "icfdb.gsm_menu_structure.menu_structure_obj = icfdb.gsm_toolbar_menu_structure.menu_structure_obj"
     _FldNameList[1]   > icfdb.gsm_toolbar_menu_structure.toolbar_menu_structure_obj
"toolbar_menu_structure_obj" "toolbar_menu_structure_obj" ? ? "decimal" ? ? ? ? ? ? no ? yes 33.6 yes
     _FldNameList[2]   > icfdb.gsm_toolbar_menu_structure.object_obj
"object_obj" "object_obj" ? ? "decimal" ? ? ? ? ? ? yes ? yes 33.6 yes
     _FldNameList[3]   > icfdb.gsm_toolbar_menu_structure.menu_structure_sequence
"menu_structure_sequence" "menu_structure_sequence" "Band Sequence" ? "integer" ? ? ? ? ? ? yes ? yes 21.4 yes
     _FldNameList[4]   > icfdb.gsm_toolbar_menu_structure.menu_structure_obj
"menu_structure_obj" "menu_structure_obj" ? ? "decimal" ? ? ? ? ? ? yes ? yes 33.6 yes
     _FldNameList[5]   > icfdb.gsm_toolbar_menu_structure.menu_structure_alignment
"menu_structure_alignment" "menu_structure_alignment" "Band Alignment" ? "character" ? ? ? ? ? ? yes ? no 14.6 yes
     _FldNameList[6]   > icfdb.gsm_toolbar_menu_structure.menu_structure_row
"menu_structure_row" "menu_structure_row" "Band Row" ? "integer" ? ? ? ? ? ? yes ? no 9 yes
     _FldNameList[7]   > icfdb.gsm_toolbar_menu_structure.menu_structure_spacing
"menu_structure_spacing" "menu_structure_spacing" "Band Spacing" ? "integer" ? ? ? ? ? ? yes ? no 13 yes
     _FldNameList[8]   > icfdb.gsm_toolbar_menu_structure.insert_rule
"insert_rule" "insert_rule" ? ? "logical" ? ? ? ? ? ? yes ? no 21.2 yes
     _FldNameList[9]   > icfdb.gsm_menu_structure.menu_structure_code
"menu_structure_code" "menu_structure_code" ? ? "character" ? ? ? ? ? ? no ? no 28 yes
     _FldNameList[10]   > icfdb.gsm_menu_structure.menu_structure_type
"menu_structure_type" "menu_structure_type" ? ? "character" ? ? ? ? ? ? no ? no 18.2 yes
     _FldNameList[11]   > icfdb.gsm_menu_structure.menu_structure_description
"menu_structure_description" "menu_structure_description" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beginTransactionValidate dTables  _DB-REQUIRED
PROCEDURE beginTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:    Resequence the menu_structure_sequence field so that
              there are no duplicate sequence conflicts. 
  Parameters:  <none>
  Notes:      Also renumbers all sequences so that they start from
              1 and are all incremented by 1. 
------------------------------------------------------------------------------*/
DEFINE BUFFER BUFgsm_toolbar_menu_structure FOR gsm_toolbar_menu_structure.

DEFINE VARIABLE iIncrement   AS INTEGER    NO-UNDO.
DEFINE VARIABLE lInsertAfter AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lFound       AS LOGICAL    NO-UNDO.

ASSIGN iIncrement    = {&UPPER_LIMIT}
       miInsertAfter = 0.

FOR EACH rowObjUpd WHERE CAN-DO("A,C,U":U, rowObjUpd.RowMod):
  
  /* If menu type is menubar, set to zero */
  FIND gsm_menu_structure 
       WHERE gsm_menu_structure.menu_structure_obj = RowObjUpd.menu_structure_obj NO-LOCK NO-ERROR.
  IF AVAILABLE gsm_menu_structure AND gsm_menu_structure.menu_structure_type = "MenuBar":U THEN 
  DO:
     ASSIGN RowObjUpd.menu_structure_sequence = 0
            RowObjUpd.ChangedFields           = IF LOOKUP("menu_structure_sequence":U,RowObjUpd.ChangedFields) = 0
                                                THEN RowObjUpd.ChangedFields + "," + "menu_structure_sequence":U
                                                ELSE RowObjUpd.ChangedFields.
     RETURN "".
  END.

  IF rowObjUpd.RowMod = "U":U THEN
  DO:
      /* For updates, determine whether the sequence is being increased or decreased */
      /* If it's being decreased, it will be inserted before the specified sequence */
     FIND BUFgsm_toolbar_menu_structure 
          WHERE ROWID(BUFgsm_toolbar_menu_structure) = TO-ROWID(ENTRY(1,RowObjUpd.RowIDent)) NO-LOCK.
     IF AVAILABLE(BUFgsm_toolbar_menu_structure) THEN
        lInsertAfter =  IF RowObjUpd.menu_structure_sequence > BUFgsm_toolbar_menu_structure.menu_structure_sequence  
                        THEN YES
                        ELSE NO.
  END.


 /* Assign each sequence number to a number greater than the upper limit. 
    This will avoid any index conflicts */
  Band-Loop:
  FOR EACH BUFgsm_toolbar_menu_structure 
      WHERE  BUFgsm_toolbar_menu_structure.object_obj        = RowObjUpd.object_obj
         AND BUFgsm_toolbar_menu_structure.menu_structure_sequence < {&UPPER_LIMIT} 
          AND  ROWID(BUFgsm_toolbar_menu_structure) <> TO-ROWID(ENTRY(1,RowObjUpd.RowIDent)) EXCLUSIVE-LOCK
           BY BUFgsm_toolbar_menu_structure.menu_structure_sequence:

    FIND gsm_menu_structure 
       WHERE gsm_menu_structure.menu_structure_obj = BUFgsm_toolbar_menu_structure.menu_structure_obj NO-LOCK NO-ERROR.
    IF AVAILABLE gsm_menu_structure AND gsm_menu_structure.menu_structure_type = "MenuBar":U THEN 
    DO:
       ASSIGN BUFgsm_toolbar_menu_structure.menu_structure_sequence = 0.
       NEXT Band-Loop.
    END.

    IF NOT lFound THEN DO:
      IF lInsertAfter AND BUFgsm_toolbar_menu_structure.menu_structure_sequence > RowObjUpd.menu_structure_sequence THEN 
        ASSIGN lFound          = TRUE
               miInsertAfter   = iIncrement + 1.
      ELSE IF NOT lInsertAfter AND BUFgsm_toolbar_menu_structure.menu_structure_sequence >= RowObjUpd.menu_structure_sequence THEN
        ASSIGN lFound          = TRUE
               miInsertAfter   = iIncrement + 1.
    END.

    ASSIGN iIncrement                                    = iIncrement + 1
           BUFgsm_toolbar_menu_structure.menu_structure_sequence = iIncrement
           miLastUpper                                   = iIncrement.
  END. /* End for each Buffer */

    

END.

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
  Purpose:    This procedure resequences all sequence numbers in ascending sequential order 
  Parameters:  <none>
  Notes:       This procedure is used in conjunction with beginTransactionValidate
------------------------------------------------------------------------------*/
DEFINE BUFFER BUFgsm_toolbar_menu_structure FOR gsm_toolbar_menu_structure.

DEFINE VARIABLE iIncrement   AS INTEGER    NO-UNDO.
DEFINE VARIABLE iNewSequence AS INTEGER    NO-UNDO.

FOR EACH rowObjUpd WHERE CAN-DO("A,C,U":U, rowObjUpd.RowMod):
  /* If the sequence or the band has not been changed (i.e.only the item or subband changed, 
     return. No resequencing is necesssary*/

  /* Reassign changed sequence number to last number + 1 to avoid duplicate */
  FOR EACH BUFgsm_toolbar_menu_structure 
      WHERE  ROWID(BUFgsm_toolbar_menu_structure) = TO-ROWID(ENTRY(1,RowObjUpd.RowIDent)) EXCLUSIVE-LOCK:

    FIND gsm_menu_structure 
       WHERE gsm_menu_structure.menu_structure_obj = BUFgsm_toolbar_menu_structure.menu_structure_obj NO-LOCK NO-ERROR.
    IF AVAILABLE gsm_menu_structure AND gsm_menu_structure.menu_structure_type = "MenuBar":U THEN 
      .
    ELSE
      ASSIGN BUFgsm_toolbar_menu_structure.menu_structure_sequence = miLastUpper + 1.
  END.

  /* Reaasign menu sequences to values greater than assigned sequence */
  iIncrement = 0.

  FOR EACH BUFgsm_toolbar_menu_structure 
      WHERE  BUFgsm_toolbar_menu_structure.object_obj         = RowObjUpd.object_obj
        AND  BUFgsm_toolbar_menu_structure.menu_structure_sequence > {&UPPER_LIMIT} EXCLUSIVE-LOCK
         BY BUFgsm_toolbar_menu_structure.menu_structure_sequence :
    
    ASSIGN iIncrement = iIncrement + 1 .

    /* Skip an increment to reserve for the inserted sequence */
    IF BUFgsm_toolbar_menu_structure.menu_structure_sequence = miInsertAfter THEN
      ASSIGN iNewSequence = iIncrement
             iIncrement   = iIncrement + 1 .
             

    IF BUFgsm_toolbar_menu_structure.menu_structure_sequence = miLastUpper + 1 THEN 
    DO:
      ASSIGN
       BUFgsm_toolbar_menu_structure.menu_structure_sequence = (IF iNewSequence = 0
                                                               THEN iIncrement
                                                               ELSE iNewSequence)
       RowObjUpd.MENU_structure_sequence  =  BUFgsm_toolbar_menu_structure.menu_structure_sequence.
    END.
    ELSE
      BUFgsm_toolbar_menu_structure.menu_structure_sequence = iIncrement.

  END. /* End For Loop */

END.
RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preTransactionValidate dTables  _DB-REQUIRED
PROCEDURE preTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:   Check the key is unique. Check that only 1 menubar is added per toolbar
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.

  FOR EACH RowObjUpd WHERE CAN-DO('A,C,U':U,RowObjUpd.RowMod): 
     /* Verify that a band is not used twice using the same sequence in the toolbar */
    IF (RowObjUpd.RowMod = 'U':U AND
      CAN-FIND(FIRST gsm_toolbar_menu_structure
        WHERE gsm_toolbar_menu_structure.OBJECT_obj = RowObjUpd.OBJECT_obj
          AND gsm_toolbar_menu_structure.menu_structure_sequence = RowObjUpd.MENU_Structure_sequence
          AND gsm_toolbar_menu_structure.MENU_Structure_obj = RowObjUpd.MENU_Structure_obj 
          AND ROWID(gsm_toolbar_menu_structure) <> TO-ROWID(ENTRY(1,RowObjUpd.RowIDent))))
    OR (RowObjUpd.RowMod <> 'U':U AND
      CAN-FIND(FIRST gsm_toolbar_menu_structure
       WHERE gsm_toolbar_menu_structure.OBJECT_obj = RowObjUpd.OBJECT_obj
          AND gsm_toolbar_menu_structure.menu_structure_sequence = RowObjUpd.MENU_Structure_sequence
          AND gsm_toolbar_menu_structure.MENU_Structure_obj = RowObjUpd.MENU_Structure_obj ))
    THEN DO:
      FIND FIRST gsm_menu_structure 
           WHERE gsm_menu_structure.Menu_structure_obj = RowObjUpd.MENU_structure_obj NO-LOCK NO-ERROR.
      IF AVAILABLE gsm_menu_structure THEN
        ASSIGN cValueList = gsm_menu_structure.menu_Structure_code + "," + string(RowObjUpd.menu_Structure_sequence).
      
        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                      {af/sup2/aferrortxt.i 'AF' '8' 'gsm_toolbar_menu_structure' '' '"the specified band and sequence:"' cValueList }.
      ERROR-STATUS:ERROR = NO.

      RETURN cMessageList.
    END.

    IF RowObjUpd.RowMod = 'A':U OR RowObjUpd.RowMod = 'C':U THEN
    DO:
      FIND FIRST gsm_menu_structure 
           WHERE gsm_menu_structure.menu_structure_obj = RowObjUpd.menu_structure_obj NO-LOCK NO-ERROR.
      IF AVAILABLE gsm_menu_structure AND gsm_menu_structure.menu_structure_type = "MenuBar":U THEN
      DO:
        FOR EACH gsm_toolbar_menu_structure NO-LOCK
             WHERE  gsm_toolbar_menu_structure.object_obj = RowObjUpd.object_obj,
              FIRST gsm_menu_structure NO-LOCK
              WHERE gsm_menu_structure.menu_structure_obj= gsm_toolbar_menu_structure.menu_structure_obj 
                AND gsm_menu_structure.menu_structure_type = "MenuBar":U:
          
          cMessageList = "Only one band of type 'Menubar' may exist for a toolbar/menu.".
          ERROR-STATUS:ERROR = NO.
          RETURN cMessageList.
        END.
      END.
    END.
    ELSE IF RowObjUpd.RowMod = 'U':U  THEN
    DO:
      FIND FIRST gsm_menu_structure 
           WHERE gsm_menu_structure.menu_structure_obj = RowObjUpd.menu_structure_obj NO-LOCK NO-ERROR.
      IF AVAILABLE gsm_menu_structure AND gsm_menu_structure.menu_structure_type = "MenuBar":U THEN
      DO:
        FOR EACH gsm_toolbar_menu_structure NO-LOCK
             WHERE gsm_toolbar_menu_structure.object_obj = RowObjUpd.object_obj
               AND ROWID(gsm_toolbar_menu_structure) <> TO-ROWID(ENTRY(1,RowObjUpd.RowIDent)),
              FIRST gsm_menu_structure NO-LOCK
              WHERE gsm_menu_structure.menu_structure_obj= gsm_toolbar_menu_structure.menu_structure_obj 
                AND gsm_menu_structure.menu_structure_type = "MenuBar":U:
          
          cMessageList = "Only one band of type 'Menubar' may exist for a toolbar/menu.".
          ERROR-STATUS:ERROR = NO.
          RETURN cMessageList.
        END.
      END.
    END.
      
  END.

  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.

 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RowObjectValidate dTables 
PROCEDURE RowObjectValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.

  IF RowObject.menu_structure_obj = 0 OR RowObject.menu_structure_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_toolbar_menu_structure' 'menu_structure_obj' "'Band Code Object'"}.

  IF RowObject.object_obj = 0 OR RowObject.object_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_toolbar_menu_structure' 'object_obj' "'SmartToolbar Object '"}.

  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

