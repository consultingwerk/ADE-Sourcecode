&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*------------------------------------------------------------------------

  File:  

  Description: from DATA.W - Template For SmartData objects in the ADM

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Modified:     February 24, 1999
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

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
&Scoped-define INTERNAL-TABLES gsm_menu_structure_item gsm_menu_item

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  child_menu_structure_obj menu_item_obj menu_item_sequence~
 menu_structure_obj
&Scoped-define ENABLED-FIELDS-IN-gsm_menu_structure_item ~
child_menu_structure_obj menu_item_obj menu_item_sequence ~
menu_structure_obj 
&Scoped-Define DATA-FIELDS  child_menu_structure_obj menu_item_obj menu_item_sequence~
 menu_structure_item_obj menu_structure_obj item_control_type~
 item_toolbar_label menu_item_label menu_item_description~
 menu_item_reference
&Scoped-define DATA-FIELDS-IN-gsm_menu_structure_item ~
child_menu_structure_obj menu_item_obj menu_item_sequence ~
menu_structure_item_obj menu_structure_obj 
&Scoped-define DATA-FIELDS-IN-gsm_menu_item item_control_type ~
item_toolbar_label menu_item_label menu_item_description ~
menu_item_reference 
&Scoped-Define MANDATORY-FIELDS  menu_item_obj menu_item_sequence menu_structure_obj
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gsmitfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsm_menu_structure_item NO-LOCK, ~
      FIRST gsm_menu_item WHERE gsm_menu_item.menu_item_obj = gsm_menu_structure_item.menu_item_obj NO-LOCK ~
    BY gsm_menu_structure_item.menu_structure_obj ~
       BY gsm_menu_structure_item.menu_item_sequence INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsm_menu_structure_item NO-LOCK, ~
      FIRST gsm_menu_item WHERE gsm_menu_item.menu_item_obj = gsm_menu_structure_item.menu_item_obj NO-LOCK ~
    BY gsm_menu_structure_item.menu_structure_obj ~
       BY gsm_menu_structure_item.menu_item_sequence INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsm_menu_structure_item ~
gsm_menu_item
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsm_menu_structure_item
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main gsm_menu_item


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsm_menu_structure_item, 
      gsm_menu_item SCROLLING.
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
         HEIGHT             = 1.48
         WIDTH              = 64.4.
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
     _TblList          = "icfdb.gsm_menu_structure_item,icfdb.gsm_menu_item WHERE icfdb.gsm_menu_structure_item ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _OrdList          = "icfdb.gsm_menu_structure_item.menu_structure_obj|yes,icfdb.gsm_menu_structure_item.menu_item_sequence|yes"
     _JoinCode[2]      = "icfdb.gsm_menu_item.menu_item_obj = icfdb.gsm_menu_structure_item.menu_item_obj"
     _FldNameList[1]   > icfdb.gsm_menu_structure_item.child_menu_structure_obj
"child_menu_structure_obj" "child_menu_structure_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes
     _FldNameList[2]   > icfdb.gsm_menu_structure_item.menu_item_obj
"menu_item_obj" "menu_item_obj" ? ? "decimal" ? ? ? ? ? ? yes ? yes 33.6 yes
     _FldNameList[3]   > icfdb.gsm_menu_structure_item.menu_item_sequence
"menu_item_sequence" "menu_item_sequence" ? ? "integer" ? ? ? ? ? ? yes ? yes 14 yes
     _FldNameList[4]   > icfdb.gsm_menu_structure_item.menu_structure_item_obj
"menu_structure_item_obj" "menu_structure_item_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 33.6 yes
     _FldNameList[5]   > icfdb.gsm_menu_structure_item.menu_structure_obj
"menu_structure_obj" "menu_structure_obj" ? ? "decimal" ? ? ? ? ? ? yes ? yes 33.6 yes
     _FldNameList[6]   > icfdb.gsm_menu_item.item_control_type
"item_control_type" "item_control_type" ? ? "character" ? ? ? ? ? ? no ? no 11.2 yes
     _FldNameList[7]   > icfdb.gsm_menu_item.item_toolbar_label
"item_toolbar_label" "item_toolbar_label" ? ? "character" ? ? ? ? ? ? no ? no 28 yes
     _FldNameList[8]   > icfdb.gsm_menu_item.menu_item_label
"menu_item_label" "menu_item_label" ? ? "character" ? ? ? ? ? ? no ? no 28 yes
     _FldNameList[9]   > icfdb.gsm_menu_item.menu_item_description
"menu_item_description" "menu_item_description" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
     _FldNameList[10]   > icfdb.gsm_menu_item.menu_item_reference
"menu_item_reference" "menu_item_reference" ? ? "character" ? ? ? ? ? ? no ? no 20.6 yes
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
  Purpose:    Resequence the menu_item_sequence field so that
              there are no duplicate sequence conflicts. 
  Parameters:  <none>
  Notes:      Also renumbers all sequences so that they start from
              1 and are all incremented by 1. 
------------------------------------------------------------------------------*/
DEFINE BUFFER BUFgsm_menu_structure_item FOR gsm_menu_structure_item.

DEFINE VARIABLE iIncrement   AS INTEGER    NO-UNDO.
DEFINE VARIABLE lInsertAfter AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lFound       AS LOGICAL    NO-UNDO.

ASSIGN iIncrement = {&UPPER_LIMIT}
       miInsertAfter = 0.

FOR EACH rowObjUpd WHERE CAN-DO("A,C,U":U, rowObjUpd.RowMod):
  /* If the sequence or the band has not been changed (i.e.only the item or subband changed, 
     return. No resequencing is necesssary*/
  IF rowObjUpd.RowMod = "U" AND LOOKUP('menu_item_sequence':U,RowObjUpd.ChangedFields) = 0 
                            AND LOOKUP('menu_structure_obj':U,RowObjUpd.ChangedFields) = 0 THEN 
    RETURN.

  IF rowObjUpd.RowMod = "U":U THEN
  DO:
      /* For updates, determine whether the sequence is being increased or decreased */
      /* If it's being decreased, it will be inserted before the specified sequence */
     FIND BUFgsm_menu_structure_item 
          WHERE ROWID(BUFgsm_menu_structure_item) = TO-ROWID(ENTRY(1,RowObjUpd.RowIDent)) NO-LOCK.
     IF AVAILABLE(BUFgsm_menu_structure_item) THEN
        lInsertAfter =  IF RowObjUpd.menu_item_sequence > BUFgsm_menu_structure_item.MENU_item_sequence  
                        THEN YES
                        ELSE NO.
  END.
 /* Assign each sequence number to a number greater than the upper limit. 
    This will avoid any index conflicts */
  FOR EACH BUFgsm_menu_structure_item 
      WHERE BUFgsm_menu_structure_item.menu_structure_obj = RowObjUpd.menu_structure_obj
         AND BUFgsm_menu_structure_item.menu_item_sequence < {&UPPER_LIMIT} 
          AND  ROWID(BUFgsm_menu_structure_item) <> TO-ROWID(ENTRY(1,RowObjUpd.RowIDent)) EXCLUSIVE-LOCK
           BY BUFgsm_menu_structure_item.menu_item_sequence :
    

    IF NOT lFound THEN DO:
      IF lInsertAfter AND BUFgsm_menu_structure_item.menu_item_sequence > RowObjUpd.menu_item_sequence THEN 
        ASSIGN lFound          = TRUE
               miInsertAfter   = iIncrement + 1.
      ELSE IF NOT lInsertAfter AND BUFgsm_menu_structure_item.menu_item_sequence >= RowObjUpd.menu_item_sequence THEN
        ASSIGN lFound          = TRUE
               miInsertAfter   = iIncrement + 1.
    END.

    ASSIGN iIncrement                                    = iIncrement + 1
           BUFgsm_menu_structure_item.menu_item_sequence = iIncrement
           miLastUpper                                   = iIncrement.
    
  END. /* End for each Buffer */
    

END.
RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPlaceholder dTables  _DB-REQUIRED
PROCEDURE checkPlaceholder :
/*------------------------------------------------------------------------------
  Purpose:     Verifies that the band is not used in band object associations
  Parameters:  pdMenuStructure  menu_structure_obj of the modifies band item.
  
  Notes:       This procedure is recursively called which checks whether the band
               and any of it's ancestore bands is used in band objects. If it is,
               the band item is rejected.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pdMenuStructure AS DECIMAL    NO-UNDO.

DEFINE BUFFER BUFgsm_menu_structure_item FOR gsm_menu_structure_item. 

IF CAN-FIND(FIRST gsm_object_menu_structure
            WHERE gsm_object_menu_structure.menu_structure_obj = pdMenuStructure) THEN
   RETURN "ADM-ERROR":U.
ELSE DO:
  FOR EACH BUFgsm_menu_structure_item NO-LOCK
      WHERE BUFgsm_menu_structure_item.child_menu_structure_obj = pdMenuStructure:
    RUN checkPlaceHolder(BUFgsm_menu_structure_item.menu_structure_obj).
    IF RETURN-VALUE = "ADM-ERROR":U THEN
       RETURN RETURN-VALUE.
  END.
END.
RETURN RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkRecursionDown dTables  _DB-REQUIRED
PROCEDURE checkRecursionDown :
/*------------------------------------------------------------------------------
  Purpose:     Recursively called procedure which determines whether there
               exists a recursive relationship. This performs the recursion
               in an downward approach. It checks the band of the child menu structure
  Parameters:  pdMenuStructure   menu_structure_obj 
               pdChild           child_menu_structure_obj
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pdMenuStructure  AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER pdChild AS DECIMAL    NO-UNDO.

DEFINE BUFFER BUFgsm_menu_structure_item FOR gsm_menu_structure_item.

FOR EACH  BUFgsm_menu_structure_item 
    WHERE BUFgsm_menu_structure_item.MENU_structure_obj = pdChild NO-LOCK:

    IF BUFgsm_menu_structure_item.child_menu_structure_obj = pdMenuStructure THEN
       RETURN "ADM-ERROR":U.
    ELSE IF BUFgsm_menu_structure_item.child_menu_structure_obj > 0 THEN
    DO:
       RUN checkRecursionDown(pdMenuStructure,
                              BUFgsm_menu_structure_item.child_menu_structure_obj).
       RETURN RETURN-VALUE.
    END.

END.

RETURN RETURN-VALUE.


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
DEFINE BUFFER BUFgsm_menu_structure_item FOR gsm_menu_structure_item.

DEFINE VARIABLE iIncrement   AS INTEGER    NO-UNDO.
DEFINE VARIABLE iNewSequence AS INTEGER    NO-UNDO.

FOR EACH rowObjUpd WHERE CAN-DO("A,C,U":U, rowObjUpd.RowMod):
  /* If the sequence or the band has not been changed (i.e.only the item or subband changed, 
     return. No resequencing is necesssary*/
  IF rowObjUpd.RowMod = "U" AND LOOKUP('menu_item_sequence':U,RowObjUpd.ChangedFields) = 0 
                            AND LOOKUP('menu_structure_obj':U,RowObjUpd.ChangedFields) = 0 THEN 
    RETURN.


  /* Reassign changed sequence number to last number + 1 to avoid duplicate */
  FOR EACH BUFgsm_menu_structure_item 
      WHERE  ROWID(BUFgsm_menu_structure_item) = TO-ROWID(ENTRY(1,RowObjUpd.RowIDent)) EXCLUSIVE-LOCK:
    ASSIGN BUFgsm_menu_structure_item.menu_item_sequence = miLastUpper + 1.
  END.

  /* Reaasign menu sequences to values greater than assigned sequence */
  iIncrement = 0.

  FOR EACH BUFgsm_menu_structure_item 
      WHERE BUFgsm_menu_structure_item.menu_structure_obj = RowObjUpd.menu_structure_obj
        AND  BUFgsm_menu_structure_item.menu_item_sequence > {&UPPER_LIMIT} EXCLUSIVE-LOCK
         BY BUFgsm_menu_structure_item.menu_item_sequence :

    /* Remove any fields that have the menu_item ObjectID set to null */
    IF BUFgsm_menu_structure_item.menu_item_obj = 0 THEN
    DO:
      DELETE  BUFgsm_menu_structure_item.
      NEXT.
    END.
    
    ASSIGN iIncrement = iIncrement + 1 .

    /* Skip an increment to reserve for the inserted sequence */
    IF BUFgsm_menu_structure_item.menu_item_sequence = miInsertAfter THEN
      ASSIGN iNewSequence = iIncrement
             iIncrement   = iIncrement + 1 .
             


    IF BUFgsm_menu_structure_item.menu_item_sequence = miLastUpper + 1 THEN
       ASSIGN 
         BUFgsm_menu_structure_item.menu_item_sequence = (IF iNewSequence = 0
                                                         THEN iIncrement
                                                         ELSE iNewSequence)
         rowObjUpd.menu_item_sequence                  =  BUFgsm_menu_structure_item.menu_item_sequence.
    ELSE
      BUFgsm_menu_structure_item.menu_item_sequence = iIncrement.
 
  END.

END. /* END FOR EACVH RowObjUpd */

/* Resequence items */
FOR EACH rowObjUpd WHERE rowObjUpd.RowMod = "D":
  FOR EACH BUFgsm_menu_structure_item 
      WHERE BUFgsm_menu_structure_item.menu_structure_obj = RowObjUpd.menu_structure_obj
        AND  BUFgsm_menu_structure_item.menu_item_sequence > RowObjUpd.menu_item_sequence EXCLUSIVE-LOCK
         BY BUFgsm_menu_structure_item.menu_item_sequence :
  
    ASSIGN BUFgsm_menu_structure_item.menu_item_sequence = BUFgsm_menu_structure_item.menu_item_sequence - 1.

  END.
END.

ERROR-STATUS:ERROR = NO.
RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preTransactionValidate dTables  _DB-REQUIRED
PROCEDURE preTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:    Check for band circular referencess. Also check that if a placeholder
              is added to a band, there must not be any placeholders on any ancestor
              bands.
  Parameters: 
  Notes:      This validation ensures that there are no circular references. That 
              is, it ensures that a band, or a child band does point to a child band 
              that references an ancestor band
------------------------------------------------------------------------------*/
DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.
    

FOR EACH rowObjUpd WHERE CAN-DO("A,C,U":U, rowObjUpd.RowMod):
    
  
  /* Ensure the menu structure is valid */
  IF rowObjUpd.menu_structure_obj > 0 THEN
  DO:
     IF NOT CAN-FIND(FIRST gsm_menu_structure
                     WHERE gsm_menu_structure.menu_structure_obj = rowObjUpd.menu_structure_obj)  THEN
     ASSIGN
        cValueList   = STRING(RowObjUpd.menu_structure_obj)
        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                      {af/sup2/aferrortxt.i 'AF' '5' 'gsm_menu_structure_item' '' "'menu_structure_obj, '" cValueList }.
  END.

   /* Ensure the menu item is valid */
  IF rowObjUpd.menu_item_obj > 0 THEN
  DO:
     IF NOT CAN-FIND(FIRST gsm_menu_item
                     WHERE gsm_menu_item.menu_item_obj = rowObjUpd.menu_item_obj)  THEN
     ASSIGN
        cValueList   = STRING(RowObjUpd.menu_item_obj)
        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                      {af/sup2/aferrortxt.i 'AF' '5' 'gsm_menu_item_item' '' "'menu_item_obj, '" cValueList }.
  END. 

  /* Ensure the child menu structure is valid */
 IF rowObjUpd.child_menu_structure_obj > 0 THEN
 DO:
     IF NOT CAN-FIND(FIRST gsm_menu_structure
                     WHERE gsm_menu_structure.menu_structure_obj = rowObjUpd.child_menu_structure_obj)  THEN
     ASSIGN
        cValueList   = STRING(RowObjUpd.child_menu_structure_obj)
        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                      {af/sup2/aferrortxt.i 'AF' '5' 'gsm_menu_structure_item' '' "'child_menu_structure_obj, '" cValueList }.
 END. 
 IF cMessageList > "" THEN
 DO:
   ERROR-STATUS:ERROR = NO.
   RETURN cMessageList. 
 END.
END.

FOR EACH rowObjUpd WHERE CAN-DO("A,C,U":U, rowObjUpd.RowMod):
    /* Ensure that only 'Label' type items can have a child menu*/
  IF RowObjUpd.Menu_item_obj > 0  AND RowObjUpd.child_menu_structure_obj > 0 THEN
  DO:
    FIND FIRST gsm_menu_item 
         WHERE gsm_menu_item.menu_item_obj =  RowObjUpd.Menu_item_obj NO-LOCK NO-ERROR.
    IF AVAILABLE gsm_menu_item AND gsm_menu_item.item_control_type <> "Label":U THEN
    DO:
      cMessageList = "You can only specify a child Subband/Submenu with an item that is of type 'Label' ".
      ERROR-STATUS:ERROR = NO.
      RETURN cMessageList.
    END.
  END.

  /* Ensure that menuBars cannot have separators */
 IF RowObjUpd.Menu_item_obj > 0   THEN
  DO:
    FIND FIRST gsm_menu_item 
         WHERE gsm_menu_item.menu_item_obj =  RowObjUpd.Menu_item_obj NO-LOCK NO-ERROR.
    IF AVAILABLE gsm_menu_item AND gsm_menu_item.ITEM_control_type = "Separator":U  THEN
    DO:
      FIND FIRST gsm_menu_structure
           WHERE gsm_menu_structure.MENU_structure_obj = RowObjUpd.MENU_structure_obj NO-LOCK NO-ERROR.
      IF AVAILABLE gsm_menu_structure AND gsm_menu_structure.menu_structure_type = "MenuBar":U THEN
      DO:
        cMessageList = "You can not add a separator to a band of type 'MenuBar' ".
        ERROR-STATUS:ERROR = NO.
        RETURN cMessageList.
      END.
    END.
  END.

  IF rowObjUpd.child_menu_structure_obj > 0 THEN
  DO:
    /* Check that there are no circular references*/
    RUN checkRecursionDown (rowObjUpd.menu_structure_obj,
                            rowObjUpd.child_menu_structure_obj).
    IF RETURN-VALUE = "ADM-ERROR":U THEN
    DO:
      cMessageList = "You have specified a circular reference of bands. Please specify another Submenu/SubBand.". 
      ERROR-STATUS:ERROR = NO.
      RETURN cMessageList.
    END.
  END.
    /* Check that all ancestor bands do not also have a placeholder */
  IF RowObject.ITEM_control_type = "placeholder":U THEN
  DO:
    RUN checkPlaceholder(RowObjUpd.menu_structure_obj).
    IF RETURN-VALUE = "ADM-ERROR":U THEN
    DO:
      cMessageList = "You have specified a placeholder, however this band or it's parent band is associated with a band object.". 
      ERROR-STATUS:ERROR = NO.
      RETURN cMessageList.
    END.

  END.

END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RowObjectValidate dTables  _DB-REQUIRED
PROCEDURE RowObjectValidate :
/*------------------------------------------------------------------------------
  Purpose:     Validate on client side.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.
  
     /* Ensure that child bands are not equal to the current band*/
  IF RowObject.menu_structure_obj = RowObject.child_menu_structure_obj  THEN
    ASSIGN
      cMessageList = 'A child band can not be equal to the selected band'.

  IF RowObject.menu_structure_obj = 0 OR RowObject.menu_structure_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_menu_structure_item' 'menu_structure_obj' "'Menu Structure Obj'"}.
    
  IF RowObject.menu_item_obj = 0 OR RowObject.menu_item_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_menu_structure_item' 'menu_item_obj' "'Menu Item Obj'"}.
  
  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

