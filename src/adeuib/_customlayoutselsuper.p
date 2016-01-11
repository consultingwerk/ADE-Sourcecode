&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
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
  File: _customlayoutselsuper.p

  Description:  Custom Layout Selection Viewer - ADEUIB portion

  Purpose:      Provides the UI that allows developers to specify a different custom layout
                for the current object in the AppBuilder

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   02/14/2003  Author:  pjudge

  Update Notes: Code taken from dynamics/ry/obj/rycstlovsupr.p since we don't want
                any ADEUIB code included in Dynamics.

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

&scop object-name       _customlayoutselsuper.p
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

&GLOBAL-DEFINE Default-Layout Default Layout
&global-define Master-Layout Master Layout

DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE     NO-UNDO.
DEFINE VARIABLE gpRowid        AS ROWID      NO-UNDO.
define variable gcObjectName as character no-undo.

DEFINE VARIABLE ghCurObject     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghcType         AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghEdDescription AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghResultCode    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghRemoveButton  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghAddButton     AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghRCLookup      AS HANDLE     NO-UNDO.
define variable ghrsLayoutDiff  as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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
    define variable cButtonPressed as character no-undo.
    define variable cValues as character no-undo.
    define variable cCode as character no-undo.
    define variable cListItems as character no-undo.
    define variable cCodeList as character no-undo.

    ghRepositoryDesignManager = {fnarg getManagerHandle 'RepositoryDesignManager':U}.
    
    RUN SUPER.

  FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.
  FIND _U WHERE _U._HANDLE = _h_win NO-ERROR.
  IF AVAILABLE _P THEN
    ASSIGN gcObjectName = _P._SAVE-AS-FILE
           gpRowid     = ROWID(_P).
    
    IF NOT AVAILABLE _U THEN
        run showMessages in gshSessionManager ({errortxt.i 'AF' '39' '?' '?' '"object"' '"Unable to locate information about the current object."'},
                                               'Warn':u,
                                               '&OK',
                                               '&OK',
                                               '&OK',
                                               '',
                                               Yes,
                                               {fn getContainerSource},
                                               cButtonPressed).

  /* Build list of currently defined result codes */
  cListItems = "{&Default-Layout}|{&Default-Layout}":U.
  cCodeList  = '{&Default-Layout}':u.
  
  FOR EACH _L WHERE _L._u-recid = RECID(_U) AND
                    _L._LO-NAME NE "{&Master-Layout}":U:
    run getRecordDetail in gshGenManager (" FOR EACH ryc_customization_result WHERE ":u
                                          + " ryc_customization_result.customization_result_code = ":u
                                          + quoter(_L._LO-NAME)
                                          + "  NO-LOCK ":u,
                                          output cValues).
    assign cCode = entry(lookup('ryc_customization_result.customization_result_code':u, cValues, chr(3)) + 1, cValues, chr(3))
           cListItems = cListItems + "|":U + cCode + "|":U + cCode
           cCodeList  = cCodeList + ",":U + cCode.
  END.  /* For each defined layout */

  {set CodeList cCodeList}.
  {set ListItems cListItems}.

    ghRCLookup = {fnarg WidgetHandle '<LOCAL>':U}.
    ghAddButton = {fnarg WidgetHandle 'buAdd':U}.    
    ghRemoveButton = {fnarg WidgetHandle 'buRemove':U}.
    ghCurObject = {fnarg WidgetHandle 'cCurObj'}.
    ghcType = {fnarg WidgetHandle 'cRCType':U}.
    ghEdDescription = {fnarg WidgetHandle 'cRCDescription':U}.
    ghResultCode = {fnarg WidgetHandle 'cResultCode':U}.
    ghrsLayoutDiff = {fnarg WidgetHandle 'rsLayoutDiff':U}.

  IF _P.object_filename NE ? THEN
    ghCurObject:SCREEN-VALUE = _P.object_filename + 
                            " (":U + _P.object_type_code + ")":U.
  ELSE DO:
    cTempName = "Untitled":U + IF R-INDEX(_h_win:TITLE,":":U) > 0 THEN
                    ":":U +  SUBSTRING(_h_win:TITLE , R-INDEX(_h_win:TITLE,":":U) + 1, -1, "CHARACTER":U)
                    ELSE "":U.
    ghCurObject:SCREEN-VALUE = "<":U + cTempName + "> (":U + _P.object_type_code + ")":U.
  END. /* Else an untitled object */

  ghResultCode:LIST-ITEM-PAIRS = cListItems.

  IF _U._LAYOUT-NAME NE "{&Master-Layout}":U THEN DO:
        run getRecordDetail in gshGenManager (" FOR EACH ryc_customization_result WHERE ":u
                                          + " ryc_customization_result.customization_result_code = ":u
                                          + quoter(_U._LAYOUT-NAME)
                                          + "  NO-LOCK, ":u
                                          + " FIRST ryc_customization_type OF ryc_customization_result NO-LOCK":U,
                                          output cValues).

    ghResultCode:SCREEN-VALUE = entry(lookup('ryc_customization_result.customization_result_code':u, cValues, chr(3)) + 1, cValues, chr(3)).
    ghEdDescription:SCREEN-VALUE = entry(lookup('ryc_customization_result.customization_result_desc':u, cValues, chr(3)) + 1, cValues, chr(3)).
    ghcType:SCREEN-VALUE = entry(lookup('ryc_customization_type.customization_type_desc':u, cValues, chr(3)) + 1, cValues, chr(3)).
    ghrsLayoutDiff:RADIO-BUTTONS = "Store changes from default layout,no," +
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
        ghrsLayoutDiff:SCREEN-VALUE = "NO".
    ELSE
        ghrsLayoutDiff:SCREEN-VALUE = "YES".
  END. /* If not working on the {&Master-Layout} */

  ELSE DO: /* Currently we are looking at the master layout */
    ghResultCode:SCREEN-VALUE = '{&Default-Layout}'.
    ghEdDescription:SCREEN-VALUE = 'The default or "Master" layout'.
    ghcType:SCREEN-VALUE = "<None>":U.
    ghRemoveButton:SENSITIVE = FALSE.
    ghrsLayoutDiff:SCREEN-VALUE = "NO".
    ghrsLayoutDiff:HIDDEN = YES.
  END.

  ghAddButton:SENSITIVE = FALSE.
  hLookupContainer = DYNAMIC-FUNCTION("getContainerSource":U IN ghRCLookup).
  SUBSCRIBE PROCEDURE target-PROCEDURE TO "LookupComplete":U IN hLookupContainer.

  RUN EnableButton IN ghRCLookup.
  RUN EnableField IN ghRCLookup.

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
  DEFINE VARIABLE ans          AS character NO-UNDO.
  DEFINE VARIABLE cCode        AS CHARACTER                           NO-UNDO.
  DEFINE VARIABLE iPos         AS INTEGER                             NO-UNDO.
    DEFINE VARIABLE cLayoutStack AS CHARACTER                           NO-UNDO.
    DEFINE VARIABLE cOldBase     AS CHARACTER                           NO-UNDO.
    define variable cButtonPressed as character no-undo.
    define variable cCodeList as character no-undo.
    define variable cListItems as character no-undo.
    
    DEFINE BUFFER d_U FOR _U.

    cCode = ghResultCode:SCREEN-VALUE.
    
    IF cCode = '{&Default-Layout}' THEN DO:
        run showMessages in gshSessionManager ("You may not remove the Default Layout.",
                                               'ERR':u,
                                               '&OK',
                                               '&OK',
                                               '&OK',
                                               '',
                                               Yes,
                                               {fn getContainerSource},
                                               output cButtonPressed).
        RETURN.
    END.  /* If the Default Layout */
    
    run askQuestion in gshSessionManager ('Would you like to remove result code ' + ghResultCode:SCREEN-VALUE + ' layout for ' + ghCurObject:SCREEN-VALUE + '?',
                                          '&Yes,&No',
                                          '&No',
                                          '&No',
                                          '':u,
                                          '':u,
                                          '':u,
                                          input-output ans,
                                          output cButtonPressed).
                                              
  IF cButtonPressed eq '&Yes':u THEN DO:
    /* Remove cCode from both cListItems and cCodeList */
    {get CodeList cCodeList}.
    {get ListItems cListItems}.
    
    /* Default Layout is always first */
    cListItems = REPLACE(cListItems, "|":U + cCode, "":U).
    cCodeList = REPLACE (cCodeList, ",":U + cCode, "":U).
    
    {set CodeList cCodeList}.
    {set ListItems cListItems}.

    ghResultCode:LIST-ITEM-PAIRS = cListItems.
    ghResultCode:SCREEN-VALUE = '{&Default-Layout}':u.
    RUN DisplayCodes in target-procedure.

    /* Find what this layout was based on */
    cOldBase = "{&Master-Layout}".
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
      _P.layout_stack = "{&Master-Layout}":U.
      DO iPos = 1 TO NUM-ENTRIES(cLayoutStack) - 1:
        _P.layout_stack = ENTRY(iPos, cLayoutStack) + ",":U + _P.layout_stack.
      END.
    END.  /* If available _P */

    /* Remove the layout from the repository if it exists */
    /* Only delete if the object actually exists in the DB */
    if dynamic-function('customObjectExists':u in ghRepositoryDesignManager, gcObjectName, cCode) then
    do:
        RUN removeObject IN ghRepositoryDesignManager (gcObjectName, cCode) no-error.
        if return-value ne '':u or error-status:error then
            run showMessages in gshSessionManager (return-value ,
                                                   'ERR':u,
                                                   '&OK',
                                                   '&OK',
                                                   '&OK',
                                                   'Error removing object',
                                                   Yes,
                                                   {fn getContainerSource},
                                                   output cButtonPressed).
    end.    /* remove object */
    
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
  define variable cCodeList as character no-undo.

  DEFINE BUFFER x_U FOR _U.
  DEFINE BUFFER m_U FOR _U.
  DEFINE BUFFER x_L FOR _L.
  DEFINE BUFFER m_L FOR _L.

  /* Get the _P and top level _U of the object being editted */
  FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.
  FIND _U WHERE _U._HANDLE = _h_win NO-ERROR.
  
  {get CodeList cCodeList}.

  /* First remove any _L's for this object belonging to a layout that was removed */
  FOR EACH _L WHERE _L._u-recid = RECID(_U) AND _L._LO-NAME NE "{&Master-Layout}":U:
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
      _U._LAYOUT-NAME = "{&Master-Layout}":U.
      FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _U._WINDOW-HANDLE:
        FIND x_L WHERE x_L._u-recid = RECID(x_U) AND 
             x_L._LO-NAME = "{&Master-Layout}":U.
        ASSIGN x_U._lo-recid    = RECID(x_L)
               x_U._LAYOUT-NAME = "{&Master-Layout}":U.
      END.  /* For each widget of the current layout */
    END. /* If we deleted the current layout */
  END.  /* If any layouts needed deleting */


  /* Now let's handle the case where the user has added a layout */
  DO iCode = 1 TO NUM-ENTRIES(cCodeList):
    cCode = ENTRY(iCode, cCodeList).
    FIND FIRST _L WHERE _L._u-recid = RECID(_U) AND _L._LO-NAME EQ cCode NO-ERROR.
    IF NOT AVAILABLE _L AND cCode NE "{&default-layout}":U THEN
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
          IF ghrsLayoutDiff:SCREEN-VALUE EQ "YES" THEN
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
  cCode = ghResultCode:SCREEN-VALUE.
  IF cCode = '{&Default-Layout}':u THEN cCode = "{&Master-Layout}":U.
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
IF VALID-HANDLE(_h_menubar_proc) AND cCode <> "{&Master-Layout}":U THEN
   RUN prop_addResultCode IN _h_menubar_proc (cCode).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

