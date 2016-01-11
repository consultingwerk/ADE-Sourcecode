&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
/* Procedure Description
"Super Procedure for Custom Layout Selection Viewer"
*/
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
  File: rycstlovsupr.p

  Description:  Custom Layout Selection Viewer

  Purpose:      Provides the UI that allows developers to specify a different custom layout
                for the current object in the AppBuilder

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   02/14/2003  Author:     

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

&scop object-name       rycstlovsupr.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

{adeuib/sharvars.i}
{adeuib/uniwidg.i}
{adeuib/layout.i}

&GLOBAL-DEFINE Default-Layout "Default Layout":U

DEFINE VARIABLE gcFields       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcHandles      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE     NO-UNDO.
DEFINE VARIABLE cCodeList      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cListItems     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gpRowid        AS ROWID      NO-UNDO.

DEFINE VARIABLE hCurObject     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hcType         AS HANDLE     NO-UNDO.
DEFINE VARIABLE hEdDescription AS HANDLE     NO-UNDO.
DEFINE VARIABLE hResultCode    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRCLookup      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRemoveButton  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hAddButton     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hrsLayoutDiff  AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-WidgetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD WidgetHandle Procedure 
FUNCTION WidgetHandle RETURNS HANDLE
  ( pcWidgetName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Compile into: 
   Allow: Basic,Browse,DB-Fields
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 16.33
         WIDTH              = 71.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    /* RUN initializeObject. */  /* Commented out by migration progress */
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addResultCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addResultCode Procedure 
PROCEDURE addResultCode :
/*------------------------------------------------------------------------------
  Purpose:     Runs the ry/obj/rynewrcodd.w dialog to add a new result
               code for the current object
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cNewCode                         AS CHARACTER  NO-UNDO.

  cNewCode = DYNAMIC-FUNCTION("getDataValue":U IN hRCLookup).
  
  FIND ryc_customization_result WHERE ryc_customization_result.customization_result_obj =
            DECIMAL(cNewCode) NO-LOCK NO-ERROR.
  
  IF AVAILABLE ryc_customization_result THEN DO:
    cNewCode = ryc_customization_result.customization_result_code.
    IF LOOKUP(cNewCode, cCodeList) > 0 THEN DO:
      MESSAGE cNewCode "layout has already been defined for" hCurObject:SCREEN-VALUE + ".":U
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY.
    END.

    ASSIGN cListItems = cListItems + "|":U + ryc_customization_result.customization_result_code +
                                     "|":U + ryc_customization_result.customization_result_code
           cCodeList  = cCodeList + ",":U + ryc_customization_result.customization_result_code.

    ASSIGN hResultCode:LIST-ITEM-PAIRS = cListItems
           hResultCode:SCREEN-VALUE    = cNewCode.
  
    RUN DisplayCodes.

    DYNAMIC-FUNCTION("setDataValue":U IN hRCLookup, "":U).
    {set DataModified TRUE}.
  END.
  ELSE
    MESSAGE "You have indicated an invalid Result Code."
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
  hAddButton:SENSITIVE = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DisplayCodes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayCodes Procedure 
PROCEDURE DisplayCodes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FIND ryc_customization_result NO-LOCK
      WHERE ryc_customization_result.customization_result_code = hResultCode:SCREEN-VALUE NO-ERROR.

  IF NOT AVAILABLE ryc_customization_result THEN DO:
    IF hResultCode:SCREEN-VALUE = {&Default-Layout} THEN
      ASSIGN hEdDescription:SCREEN-VALUE = 'The default or "Master" layout'
             hcType:SCREEN-VALUE = "<None>":U
             hRemoveButton:SENSITIVE = FALSE.
  END.
  ELSE DO:
    FIND ryc_customization_type OF ryc_customization_result.
    hEdDescription:SCREEN-VALUE = ryc_customization_result.customization_result_desc.
    hcType:SCREEN-VALUE = ryc_customization_type.customization_type_desc.
    hRemoveButton:SENSITIVE = TRUE.
  END.

  IF SELF = hResultCode THEN
  {set DataModified TRUE TARGET-PROCEDURE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-InitializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeObject Procedure 
PROCEDURE InitializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cProfileData     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTempName        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hLookupContainer AS HANDLE     NO-UNDO.
DEFINE VARIABLE rRowid           AS ROWID      NO-UNDO.

ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                                      INPUT "RepositoryDesignManager":U).
  RUN SUPER.

  {get AllFieldNames   gcFields}.
  {get AllFieldHandles gcHandles}.

  FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.
  FIND _U WHERE _U._HANDLE = _h_win NO-ERROR.
  IF AVAILABLE _P THEN
    ASSIGN cObjectName = _P._SAVE-AS-FILE
           gpRowid     = ROWID(_P).

  IF NOT AVAILABLE _U THEN
    /* This should never happen */
    MESSAGE "Unable to locate information about the current object."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.

  /* Build list of currently defined result codes */
  cListItems = "Default Layout|Default Layout":U.
  cCodeList  = {&Default-Layout}
    .
  FOR EACH _L WHERE _L._u-recid = RECID(_U) AND
                    _L._LO-NAME NE "Master Layout":U:
    FIND ryc_customization_result WHERE 
        ryc_customization_result.customization_result_code = _L._LO-NAME NO-LOCK.
    ASSIGN cListItems = cListItems + "|":U + ryc_customization_result.customization_result_code +
                                     "|":U + ryc_customization_result.customization_result_code
           cCodeList  = cCodeList + ",":U + ryc_customization_result.customization_result_code.
  END.  /* For each defined layout */

  hCurObject     = WidgetHandle("cCurObj":U).
  hResultCode    = WidgetHandle("cResultCode":U).
  hEdDescription = WidgetHandle("cRCDescription":U).
  hcType         = WidgetHandle("cRCType":U).
  hRCLookup      = WidgetHandle("<LOCAL>":U).
  hRemoveButton  = WidgetHandle("buRemove":U).
  hAddButton     = WidgetHandle("buAdd":U).
  hrsLayoutDiff  = WidgetHandle("rsLayoutDiff":U).

  IF _P.object_filename NE ? THEN
    hCurObject:SCREEN-VALUE = _P.object_filename + 
                            " (":U + _P.object_type_code + ")":U.
  ELSE DO:
    cTempName = "Untitled":U + IF R-INDEX(_h_win:TITLE,":":U) > 0 THEN
                    ":":U +  SUBSTRING(_h_win:TITLE , R-INDEX(_h_win:TITLE,":":U) + 1, -1, "CHARACTER":U)
                    ELSE "":U.
    hCurObject:SCREEN-VALUE = "<":U + cTempName + "> (":U + _P.object_type_code + ")":U.
  END. /* Else an untitled object */

  hResultCode:LIST-ITEM-PAIRS = cListItems.

  IF _U._LAYOUT-NAME NE "Master Layout":U THEN DO:
    FIND ryc_customization_result WHERE 
         ryc_customization_result.customization_result_code = _U._LAYOUT-NAME NO-LOCK.
    FIND ryc_customization_type OF ryc_customization_result.
    hResultCode:SCREEN-VALUE = ryc_customization_result.customization_result_code.
    hEdDescription:SCREEN-VALUE = ryc_customization_result.customization_result_desc.
    hcType:SCREEN-VALUE = ryc_customization_type.customization_type_desc.
    hrsLayoutDiff:RADIO-BUTTONS = "Store changes from default layout,no," +
                                  "Store changes from layout " + _U._LAYOUT-NAME + ",yes".

    /* Determine setting of hrsLayoutDiff */
    ASSIGN rRowid  = ?
           cProfileData = "".
    RUN getProfileData IN gshProfileManager (INPUT "General":U,
                                             INPUT "Preference":U,
                                             INPUT "CustomizeFromDefault":U,
                                             INPUT NO,
                                             INPUT-OUTPUT rRowid,
                                             OUTPUT cProfileData).
    IF cProfileData = "Yes":U OR cProfileData = "" OR cProfileData = ? THEN
      hrsLayoutDiff:SCREEN-VALUE = "NO".
    ELSE hrsLayoutDiff:SCREEN-VALUE = "YES".
  END. /* If not working on the Master layout */

  ELSE DO: /* Currently we are looking at the master layout */
    hResultCode:SCREEN-VALUE = {&Default-Layout}.
    hEdDescription:SCREEN-VALUE = 'The default or "Master" layout'.
    hcType:SCREEN-VALUE = "<None>":U.
    hRemoveButton:SENSITIVE = FALSE.
    hrsLayoutDiff:SCREEN-VALUE = "NO".
    hrsLayoutDiff:HIDDEN = YES.
  END.



  hAddButton:SENSITIVE = FALSE.
  hLookupContainer = DYNAMIC-FUNCTION("getContainerSource":U IN hRCLookup).
  SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "LookupComplete":U IN hLookupContainer.

  RUN EnableButton IN hRCLookup.
  RUN EnableField IN hRCLookup.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-LookupComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LookupComplete Procedure 
PROCEDURE LookupComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcnames    AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcValues   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcNewKey   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcNewValue AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcOldValue AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plWhere    AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER pHandle    AS HANDLE     NO-UNDO.

  hAddButton:SENSITIVE = TRUE.
  APPLY "ENTRY" TO hAddButton.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeResultCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeResultCode Procedure 
PROCEDURE removeResultCode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ans          AS LOGICAL                             NO-UNDO.
  DEFINE VARIABLE cCode        AS CHARACTER                           NO-UNDO.
  DEFINE VARIABLE iPos         AS INTEGER                             NO-UNDO.
  DEFINE VARIABLE cLayoutStack AS CHARACTER                           NO-UNDO.
  DEFINE VARIABLE cOldBase     AS CHARACTER                           NO-UNDO.

  DEFINE BUFFER d_U FOR _U.

  cCode = hResultCode:SCREEN-VALUE.

  IF cCode = {&Default-Layout} THEN DO:
    MESSAGE "You may not remove the Default Layout."
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN.
  END.  /* If the Default Layout */

  MESSAGE "Removing result code" hResultCode:SCREEN-VALUE 
          "layout for" hCurObject:SCREEN-VALUE + ".":U
    VIEW-AS ALERT-BOX WARNING BUTTONS OK-CANCEL UPDATE ans.
  IF ans THEN DO:
    /* Remove cCode from both cListItems and cCodeList */
    /* Default Layout is always first */
    cListItems = REPLACE(cListItems, "|":U + cCode, "":U).
    cCodeList = REPLACE (cCodeList, ",":U + cCode, "":U).

    hResultCode:LIST-ITEM-PAIRS = cListItems.
    hResultCode:SCREEN-VALUE = {&Default-Layout}.
    RUN DisplayCodes.

    /* Find what this layout was based on */
    cOldBase = "Master Layout".
    FIND FIRST d_U WHERE d_U._WINDOW-HANDLE = _h_win NO-ERROR.
    IF AVAILABLE d_U THEN DO:
      FIND FIRST _L WHERE _L._u-recid = RECID(d_U) AND _L._LO-NAME = cCode NO-ERROR.
      IF AVAILABLE _L THEN cOldBase = _L._BASE-LAYOUT.
    END. /* If available d_U */

    /* Now switch all layouts based on the deleted on to the old base */
    FOR EACH d_U WHERE d_U._WINDOW-HANDLE = _h_win:
      FOR EACH _L WHERE _L._u-recid = RECID(d_U) AND _L._BASE-LAYOUT = cCode:
        _L._BASE-LAYOUT = cOldBase.
      END.
    END.

    /* Remove any _L's for this result code */
    FOR EACH d_U WHERE d_U._WINDOW-HANDLE = _h_win:
      FIND _L WHERE _L._u-recid = RECID(d_U) AND _L._LO-NAME = cCode NO-ERROR.
      IF AVAILABLE _L THEN DELETE _L.
    END.

    /* Update the layout stack */
    FIND _P WHERE ROWID(_P) = gpRowid NO-ERROR.
    IF AVAILABLE _P AND NUM-ENTRIES(_P.layout_stack) > 1 THEN DO:
      cLayoutStack = _P.layout_stack.
      _P.layout_stack = "Master Layout":U.
      DO iPos = 1 TO NUM-ENTRIES(cLayoutStack) - 1:
        _P.layout_stack = ENTRY(iPos, cLayoutStack) + ",":U + _P.layout_stack.
      END.
    END.  /* If available _P */

    /* Remove the layout from the repository if it exists */
    RUN removeObject IN ghRepositoryDesignManager (cObjectName, cCode).

    {set DataModified TRUE}.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-UpdateRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UpdateRecord Procedure 
PROCEDURE UpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     We now have to Update the AppBuilder's internals
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAddCodes                           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCode                               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurCode                            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDelCodes                           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCode                               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hProcedure                          AS HANDLE     NO-UNDO.

  DEFINE BUFFER x_U FOR _U.
  DEFINE BUFFER m_U FOR _U.
  DEFINE BUFFER x_L FOR _L.
  DEFINE BUFFER m_L FOR _L.

  /* Get the _P and top level _U of the object being editted */
  FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.
  FIND _U WHERE _U._HANDLE = _h_win NO-ERROR.

  /* First remove any _L's for this object belonging to a layout that was removed */
  FOR EACH _L WHERE _L._u-recid = RECID(_U) AND _L._LO-NAME NE "Master Layout":U:
    IF LOOKUP(_L._LO-NAME, cCodeList) = 0 THEN
      /* We have located a layout belonging to this object that is no-longer in
         the list of desired layouts */
      cDelCodes = cDelCodes + ",":U + _L._LO-NAME.
  END.  /* Looping through window _L's */
  cDelCodes = LEFT-TRIM(cDelCodes, ",":U).

  IF cDelCodes NE "":U THEN DO:
    DO iCode = 1 TO NUM-ENTRIES(cDelCodes):
      cCode = ENTRY(iCode, cDelCodes).

      /* Delete entirely any widget that is used only in this layout. 
         This is not an undoable operation. */
      FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _U._HANDLE:
        FOR EACH _L WHERE _L._u-recid = RECID(x_U) AND
                          _L._LO-NAME = cCode:
          IF NOT CAN-FIND(FIRST x_L WHERE x_L._u-recid = _L._u-recid AND
                                          NOT x_L._REMOVE-FROM-LAYOUT AND
                                          x_L._LO-NAME NE _L._LO-NAME) 
          THEN RUN adeuib/_delet_u.p (INPUT _L._u-recid, TRUE /* trash */ ).

          DELETE _L.  /* Always delete this layout record */

        END.  /* FOR EACH _L of this cCode */
      END.  /* FOR EACH x_U of window */
    END.  /* for each code that was deleted */
    
    /* If the current layout was one of the ones we deleted, then make the Default layout
       the new current layout  */
    IF LOOKUP(_U._LAYOUT-NAME, cDelCodes) > 0 THEN DO:
      _U._LAYOUT-NAME = "Master Layout":U.
      FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _U._WINDOW-HANDLE:
        FIND x_L WHERE x_L._u-recid = RECID(x_U) AND 
             x_L._LO-NAME = "Master Layout":U.
        ASSIGN x_U._lo-recid    = RECID(x_L)
               x_U._LAYOUT-NAME = "Master Layout":U.
      END.  /* For each widget of the current layout */
    END. /* If we deleted the current layout */
  END.  /* If any layouts needed deleting */


  /* Now let's handle the case where the user has added a layout */
  DO iCode = 1 TO NUM-ENTRIES(cCodeList):
    cCode = ENTRY(iCode, cCodeList).
    FIND FIRST _L WHERE _L._u-recid = RECID(_U) AND _L._LO-NAME EQ cCode NO-ERROR.
    IF NOT AVAILABLE _L AND cCode NE "Default Layout":U THEN
      cAddCodes = cAddCodes + ",":U + cCode.
  END.  /* Loop through all desired layouts looking for ones that don't exist */
  cAddCodes = LEFT-TRIM(cAddCodes, ",":U).

  IF cAddCodes NE "":U THEN DO:
    /* All of these new layouts will be copies of the current layout */
    cCurCode = _U._LAYOUT-NAME.

    DO iCode = 1 TO NUM-ENTRIES(cAddCodes):
      cCode = ENTRY(iCode, cAddCodes).

      /* Loop though all widgets of the object and add an _L for cCode */
      FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _U._HANDLE,
          EACH x_L WHERE RECID(x_L)         = x_U._lo-recid AND 
               x_L._LO-NAME                 = cCurCode:

        /* Find the master record for reference */
        FIND m_L WHERE m_L._u-recid = RECID(x_U) AND
                       m_L._LO-NAME = '{&Master-Layout}':U.

        /* There can be cases (usually our bugs) where a Layout record 
           can exist for some objects (even though the parent does not
           have a record. So check for a _L record before we create it. */
        FIND _L WHERE _L._LO-NAME eq cCode
                  AND _L._u-recid eq RECID(x_U) NO-ERROR.
        IF NOT AVAILABLE _L THEN DO:                
          CREATE _L.
          ASSIGN _L._LO-NAME          = cCode
                 _L._u-recid          = RECID(x_U).
          IF hrsLayoutDiff:SCREEN-VALUE EQ "YES" THEN
                 _L._BASE-LAYOUT      = cCurCode.
        END.
        /* Assign the rest of the information for this layout. */
        ASSIGN x_U._lo-recid          = RECID(_L)  /* This is making the cCode the new layout */
               x_U._LAYOUT-NAME       = cCode
               _L._BGCOLOR            = x_L._BGCOLOR
               _L._COL                = x_L._COL
               _L._COL-MULT           = m_L._COL-MULT
               _L._CONVERT-3D-COLORS  = x_L._CONVERT-3D-COLORS
               _L._CUSTOM-POSITION    = x_L._CUSTOM-POSITION
               _L._CUSTOM-SIZE        = x_L._CUSTOM-SIZE
               _L._FGCOLOR            = x_L._FGCOLOR
               _L._FONT               = x_L._FONT
               _L._HEIGHT             = x_L._HEIGHT
               _L._LABEL              = x_L._LABEL
               _L._NO-FOCUS           = x_L._NO-FOCUS
               _L._NO-LABELS          = x_L._NO-LABELS
               _L._REMOVE-FROM-LAYOUT = x_L._REMOVE-FROM-LAYOUT
               _L._ROW                = x_L._ROW
               _L._ROW-MULT           = m_L._ROW-MULT
               _L._WIDTH              = x_L._WIDTH
               _L._WIN-TYPE           = YES.  /* We only deal with GUI layouts in Dynamics */

        IF x_U._TYPE = "RECTANGLE" THEN
          ASSIGN _L._EDGE-PIXELS      = x_L._EDGE-PIXELS
                 _L._FILLED           = x_L._FILLED
                 _L._GRAPHIC-EDGE     = x_L._GRAPHIC-EDGE.
        ELSE
          ASSIGN _L._3-D               = x_L._3-D
                 _L._NO-BOX            = x_L._NO-BOX
                 _L._NO-UNDERLINE      = x_L._NO-UNDERLINE
                 _L._SEPARATORS        = x_L._SEPARATORS
                 _L._SEPARATOR-FGCOLOR = x_L._SEPARATOR-FGCOLOR
                 _L._TITLE-BGCOLOR     = x_L._TITLE-BGCOLOR
                 _L._TITLE-FGCOLOR     = x_L._TITLE-FGCOLOR
                 _L._VIRTUAL-HEIGHT    = MAX(x_L._VIRTUAL-HEIGHT, _L._HEIGHT)
                 _L._VIRTUAL-WIDTH     = IF x_L._VIRTUAL-WIDTH = ? THEN _L._WIDTH
                                         ELSE MAX(x_L._VIRTUAL-WIDTH, _L._WIDTH).
      END.  /* FOR EACH x_U and x_L */
    END.  /* Looping through layouts to be added */
  END.  /* If any layouts have been added */
  
  /* If the user is just morphing from one layout to another existing layout */
  cCode = hResultCode:SCREEN-VALUE.
  IF cCode = {&Default-Layout} THEN cCode = "Master Layout":U.
  IF cCode NE _U._LAYOUT-NAME THEN DO:
    ASSIGN _U._LAYOUT-NAME = cCode.
    FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _U._WINDOW-HANDLE:
      FIND x_L WHERE x_L._u-recid = RECID(x_U) AND 
             x_L._LO-NAME = cCode NO-ERROR.
      IF AVAILABLE x_L THEN 
        ASSIGN x_U._lo-recid    = RECID(x_L)
               x_U._LABEL       = x_L._LABEL.
      ASSIGN x_U._LAYOUT-NAME = cCode.
    END.  /* For each widget of the current layout */
  END.  /* If morphing to another layout */

  ASSIGN _cur_win_type   = YES
         _cur_col_mult   = 1
         _cur_row_mult   = 1.
{set DataModified FALSE}.

/* Add the resultCode to thr DPS */
IF VALID-HANDLE(_h_menubar_proc) AND cCode <> "Master Layout":U THEN
   RUN prop_addResultCode IN _h_menubar_proc (cCode).
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-WidgetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION WidgetHandle Procedure 
FUNCTION WidgetHandle RETURNS HANDLE
  ( pcWidgetName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Given a widget name, return its handle
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iFieldPos AS INTEGER    NO-UNDO.

  iFieldPos = LOOKUP(pcWidgetName, gcFields).
  
  RETURN IF iFieldPos > 0 THEN WIDGET-HANDLE(ENTRY(iFieldPos, gcHandles))
         ELSE ?.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

