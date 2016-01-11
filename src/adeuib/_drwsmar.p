&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _drwsmar.p

Description:
   Draw a smartObject into the current window or frame.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author:  Wm.T.Wood

Date Created: 1995

Modified by GFS on 03/13/95 - Added routine to construct new object name from
                              it's filename.
            SLK on 02/13/98 - Support for >ADM1
            JEP on 05/24/01 - IZ 1318 SmartSelect on SDV built from SBO blanks
                              all fields. Added procedure Get_Field_Name to
                              determine if data field should get prefix of
                              source object. Example: "dorder.SalesRep"
            JEP on 10/01/01 - IZ 1611 <Local> field support for SmartDataFields.
----------------------------------------------------------------------------*/
{src/adm2/globals.i}
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}
{adeuib/custwidg.i}
  
{ adeuib/advice.i }   /* Include File containing controls for the Advisor */
{ adeuib/uibhlp.i }   /* Include File containing HELP file Context ID's */

DEFINE VAR cnt               AS INTEGER    NO-UNDO.
DEFINE VAR cur-lo            AS CHAR       NO-UNDO.
DEFINE VAR FILE-NAME         AS CHAR       NO-UNDO.
DEFINE VAR Name              AS CHAR       NO-UNDO.
DEFINE VAR datafield         AS HANDLE     NO-UNDO.
DEFINE VARIABLE cSavName     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSavClass    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNotFoundMsg AS CHAR       NO-UNDO.
DEFINE VARIABLE cFieldName   AS CHAR       NO-UNDO.
DEFINE VARIABLE cColumnTable AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hDevManager  AS HANDLE     NO-UNDO.
DEFINE VARIABLE pError       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hSDO         AS HANDLE     NO-UNDO.
DEFINE VARIABLE lEditOnDrop  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cNewClass    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNewObject   AS CHARACTER  NO-UNDO.

/* Variables used for adm version */
{adeuib/vsookver.i}

&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.
DEFINE BUFFER x_U      FOR _U.
DEFINE BUFFER x_L      FOR _L.

/* Define the minimum size of a widget. If the user clicks smaller than this
   then use the default size.  */
&Scoped-define min-height-chars 0.2
&Scoped-define min-cols 0.4

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
         HEIGHT             = 9.91
         WIDTH              = 49.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Before we do anything, make sure that the file is good. */
file-name = _object_draw.
           
/* Get the current Procedure, and the layout of the current window. */
FIND _P WHERE _P._WINDOW-HANDLE eq _h_win.
RUN adecomm/_relfile.p (file-name,
                        VALID-HANDLE(_p._tv-proc), /* check remote if preferences is set */
                        "":U, /* no message here */ 
                        OUTPUT file-name).

IF file-name eq ? THEN 
DO:
  file-name = _object_draw. 
  /* Try looking for r-code (i.e. replace end with .r) */
  cnt = NUM-ENTRIES (file-name,".":U).
  CASE cnt :
    WHEN 0 THEN
      file-name = ?.
    WHEN 1 THEN  /* eg. "src/folder" becomes "src/folder.r" */
      file-name = file-name + ".r". 
    OTHERWISE 
      ENTRY(cnt, file-name, ".":U) = "r".
  END CASE.
   
  /* Error message for missing SmartObject */                        
  cNotFoundMsg = "The SmartObject could not be drawn in the UIB." + CHR(10) +
                 "The object's master file '" + _object_draw + "'" + CHR(10) +
                 "could not be found&1.". /*&1 = URL address*/  

   RUN adecomm/_relfile.p (file-name,
                           VALID-HANDLE(_p._tv-proc), /* check remote if preferences is set */
                           "MESSAGE:" + cNotFoundMsg, 
                           OUTPUT file-name).
   IF file-name = ? THEN
     RETURN "Error":U.
END. /* file-name = ? (not found) */. 

/* Clean up file name to remove the current directory. */
IF _object_draw BEGINS "./" OR _object_draw BEGINS ".~\" THEN 
  _object_draw = SUBSTRING(_object_draw, 3, -1, "CHARACTER").

/* Capture the name and other identifying characterists of the field being replaced */
IF _h_cur_widg NE _h_frame THEN DO:  /* Only do this when dropping onto a Field */
  FIND _U WHERE _U._HANDLE = _h_cur_widg NO-ERROR.
  IF AVAILABLE _U THEN
  DO:
    ASSIGN cSavName   = _U._NAME
           cSavClass  = _U._CLASS-NAME.
    IF  _palette_custom_choice <> ? THEN
    DO:
      FIND _custom WHERE RECID(_custom) = _palette_custom_choice.
      ASSIGN _U._OBJECT-NAME = _custom._object_name
             _U._CLASS-NAME  = _custom._object_type_code.  
    END.
    ELSE IF _palette_choice <> ? THEN
    DO:
      FIND _palette_item WHERE RECID(_palette_item) = _palette_choice.
      ASSIGN _U._OBJECT-NAME = _palette_item._object_name
             _u._CLASS-NAME  = _palette_item._object_class.  
    END.
    ASSIGN cNewClass  = _U._CLASS-NAME
           cNewObject = _U._OBJECT-NAME.
  END.  
          
END.

FIND _U WHERE _U._HANDLE = _h_win.
cur-lo = _U._LAYOUT-NAME.

/* Get the RECIDs of the parent frame (or window). */
/* Ensure object is not inadvertantly dropped onto the window instead of the frame 
   If user double-clicks object from dialog, the h_frame can be ?, so check all
   frames. If frame is at position 0,0 assume object is to be dropped onto that frame.
*/
IF NOT VALID-HANDLE(_h_frame) AND _frmX = 0 AND _frmy = 0 THEN
DO:
  FRAME_LOOP:
  FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _U._WINDOW-HANDLE
                 AND x_U._TYPE = "FRAME":U:
     IF VALID-HANDLE( X_U._HANDLE) 
         AND X_U._HANDLE:X = 0 AND X_U._HANDLE:Y = 0 
     THEN DO:     
       FIND parent_U WHERE parent_U._HANDLE eq X_U._HANDLE.
       LEAVE FRAME_LOOP.
     END.        
  END.    
END.
IF NOT AVAIL parent_U THEN
DO:
   IF VALID-HANDLE(_h_frame) THEN 
      FIND parent_U WHERE parent_U._HANDLE eq _h_frame.
   ELSE 
      FIND parent_U WHERE parent_U._HANDLE eq _h_win.
END.
FIND parent_L WHERE RECID(parent_L)  eq parent_U._lo-recid.    

/* Get the current Procedure, and the layout of the current window. */
FIND _U WHERE RECID(_U) eq _P._u-recid.
cur-lo = _U._LAYOUT-NAME.

/* Create a Universal Widget Record and populate it as much as possible. */
CREATE _U.
CREATE _S.
CREATE _L.

/* Find a valid name for this type of widget */
RUN Get_Start_Name (OUTPUT name).
RUN adeshar/_bstname.p (INPUT  name, name, ?, ?,  parent_U._WINDOW-HANDLE, 
                        OUTPUT name).

ASSIGN /* TYPE-specific settings */
       /* If dynamics is running and this is a dynamic viewer and cSavClass is populated above 
          because a SmartObject (SDF) has been dropped onto a field, then the saved name 
          above needs to be used to set the universal widget name.  This saved name could be
          the datafield name when the SmartObject has been dropped onto a datafield or it
          could be the name of a local fillin that the SmartObject was dropped onto. */                     
       _U._NAME          = IF _DynamicsIsRunning AND VALID-HANDLE(gshRepositoryManager) THEN
                             (IF DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, _P.object_type_code, "DynView":U)
                                 AND cSavClass NE "":U THEN cSavName ELSE NAME)
                           ELSE NAME
       _U._CLASS-NAME    = cNewClass                    
       _U._OBJECT-NAME   = cNewObject
       _U._TYPE          = "SmartObject"
       _U._SUBTYPE       = _next_draw
       _U._x-recid       = RECID(_S)
       _S._FILE-NAME     = _object_draw    
       _S._page-number   = IF _P._page-current eq ? THEN 0 ELSE _P._page-current
       /* SmartObject Handles are NEVER displayed or enabled */
       _U._ENABLE        = no
       _U._DISPLAY       = no
       _U._LAYOUT-NAME   = cur-lo
       /* Standard Settings for Universal and Field records */
       { adeuib/std_ul.i &SECTION = "DRAW-SETUP" }
       .

/* Assign width and height based on area drawn by user.
  (NOTE: this won't normally be used by a SmartObject unless it supports
   a 'set-size' method.) */
ASSIGN _L._HEIGHT = (_second_corner_y - _frmy + 1) / SESSION:PIXELS-PER-ROW /
                        _cur_row_mult
       _L._WIDTH = (_second_corner_x - _frmx + 1) / SESSION:PIXELS-PER-COL /
                        _cur_col_mult .
IF (_L._WIDTH < {&min-cols}) AND (_L._HEIGHT < {&min-height-chars})
THEN ASSIGN _L._WIDTH  = ?  /* Use default */
            _L._HEIGHT = ?. /* Use default */

/* If drawing a SmartDataField to replace an existing RowObject field we
   need to store the repalced fields handle because it is stored in
   _h_cur_widg and will be changed in _undsmar.p                          */
datafield = _h_cur_widg.

/* Make sure the SmartDataField is drawn at the same row, column and
   tab Order as the RowObject field was that it is replacing */
IF _next_draw = "SmartDataField":U THEN DO:
  FIND x_U WHERE x_U._HANDLE = datafield.
  FIND x_L WHERE RECID(x_L) = x_U._lo-recid.
  ASSIGN _L._COL       = x_L._COL
         _L._ROW       = x_L._ROW
         _U._TAB-ORDER = x_U._TAB-ORDER.
END.  /* if SmartDataField */

/* Create the widget based on the contents of the Universal Widget record */
RUN adeuib/_undsmar.p (RECID(_U)).

/* If dealing with a SmartDataField, store the field name in the property */
IF VALID-HANDLE(_S._HANDLE) THEN 
DO:
  /* SmartDatafield (currently keeping the old signature check) */
  IF _next_draw eq 'SmartDataField':u and
    ( {fn getObjectType _S._HANDLE} = 'SmartDataField':U 
      OR _S._HANDLE:GET-SIGNATURE("setFieldName":U) > '' )THEN
  DO:
    FIND x_U WHERE x_U._HANDLE = datafield.
    
    /* don't qualify if buffer = RowObject (SDO viewer) */
    ASSIGN
      cFieldName = IF x_U._BUFFER = "RowObject":U  OR x_U._TABLE = ?
                   THEN x_U._NAME
                   ELSE x_U._TABLE + "." + x_U._NAME.

    /* _U._TABLE should only be set for an SDF of a dynamic viewer,
       this determines whether the object name is enabled in the
       AppBuilder main window.  It should not be enabled for SDFs on
       datafields on dynamic viewers because the object name must
       match the fieldName attribute value. */
    IF _DynamicsIsRunning AND VALID-HANDLE(gshRepositoryManager) THEN
      IF DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, _P.object_type_code, "DynView":U) THEN
        _U._TABLE = x_U._TABLE.

    DYNAMIC-FUNCTION("setFieldName" IN _S._HANDLE, cFieldName).
    DYNAMIC-FUNCTION("setDisplayField" IN _S._HANDLE, x_U._DISPLAY).
    DYNAMIC-FUNCTION("setEnableField" IN _S._HANDLE, x_U._ENABLE).

    IF x_U._TABLE = ? THEN
      DYNAMIC-FUNCTION("setLocalField" IN _S._HANDLE, TRUE).
    
    /* Mark this as a container of a SDF */
    X_U._SUBTYPE = "CONTAINS SDF - " + _U._NAME.     
    RUN adeuib/_delet_u.p (INPUT RECID(x_U), INPUT FALSE /* Don't Trash _U */).
  END.  /* SetFieldName is a valid function */


  lEditOnDrop = FALSE.
  IF _custom_draw NE ? THEN DO:
    /* Find the _custom record and see if "EDIT-ON-DROP" is an attribute */
    FIND FIRST _custom WHERE _custom._name = _custom_draw NO-ERROR.
    IF AVAILABLE _custom THEN 
      ASSIGN lEditOnDrop = (LOOKUP("EDIT-ON-DROP":U, _custom._attr, CHR(10)) > 0).
  END. /* If _custom_draw ne ? */
  ELSE IF _next_draw NE ? THEN DO:
    /* Find the _palette_item record and see if "EDIT-ON-DROP" is an attribute */
    FIND FIRST _palette_item WHERE _palette_item._name = _next_draw NO-ERROR.
    IF AVAILABLE _palette_item THEN
      ASSIGN lEditOnDrop = (LOOKUP("EDIT-ON-DROP":U, _palette_item._attr, CHR(10)) > 0).
  END.  /* if _next_draw is not ? */

  IF lEditOnDrop THEN 
    RUN adeuib/_edtsmar.p (INTEGER(RECID(_U))).

END. /* If the SO to be drawn is current running */
  
/* Note that undsmar.p might have failed (for example, if the SmartObject
   file was not found).*/
IF RETURN-VALUE ne "Error" AND AVAILABLE (_U) THEN DO:
  /* FOR EACH layout other than the current layout,
     populate _L records for them */
  {adeuib/multi_l.i}

  /* PAGE-SOURCES should probably go on page 0. */
  RUN check_page_source.
    
  /* Now the fun part... Hook up the links between the objects 
     We currently skip it for the tree-view, mostly to avoid problems 
     with a remote SDO
     In Dynamics, the objects are also abstractly started and run out
     of context. They are constructed on a window in af/cod2/afpropwin.p
     which will set the PRIVATE-DATA of the window to the specified value
     to indicate it is just for the GenericPropSheet. The window will
     be hidden, which means the property will never be affected or changed
     or cause any unforseen errors */
  IF NOT VALID-HANDLE(_P._tv-proc) AND
     _h_win:PRIVATE-DATA <> "DynamicsGenericPropSheet":U THEN
    RUN adeuib/_advslnk.p (RECID(_U)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-check_page_source) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check_page_source Procedure 
PROCEDURE check_page_source :
/*------------------------------------------------------------------------------
  Purpose:     Check to see if the new SmartObject is a Page-Source being drawn
               on a page other than 0.  Is so, ask the user if they want to move
               it to page 0.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR choice    AS CHAR NO-UNDO.
  DEFINE VAR returnValue    AS CHAR NO-UNDO.

  /* Determine admVersion */
  {adeuib/admver.i _S._HANDLE admVersion}.

  /* Note that PAGE-SOURCES should probably go on page 0. */     
  IF admVersion LT "ADM2":U THEN DO:
     RUN get-attribute IN _S._HANDLE ('Supported-Links':U) NO-ERROR.
     ASSIGN returnValue = RETURN-VALUE.
  END. /* ADM1 */
  ELSE DO:
     returnValue = dynamic-function("getSupportedLinks" IN _S._HANDLE) NO-ERROR.
  END. /* > ADM1 */

  IF CAN-DO(returnValue, "Page-Source":U) THEN DO:  
    /* Tell the Page-Source to show the current design page. */
    IF _P._page-current ne ? THEN 
      RUN show-current-page IN _S._HANDLE (_P._page-current) NO-ERROR. 
    /* Suggest that page-sources should be on page 0. */
    IF ({&NA-Not-On-0-drwsmar} eq NO) AND _S._page-number ne 0
      THEN DO:
      choice = "Cancel". /* Show the default choice. */
      RUN adeuib/_advisor.w (
          /* Text */        "This " + (IF _U._SUBTYPE eq "" THEN _U._TYPE 
                                       ELSE _U._SUBTYPE) +
                            " is a Page-Source.  Normally, this type of " +
                            "paging control is placed on the main background " +
                            "page (i.e. page 0).  However, you have placed it " +
                            "on page " + 
                            TRIM(STRING(_S._page-number, ">,>>>,>>9.":U)) ,
          /* Options */     INPUT "Change. Automatically move it to page 0.,0," +
                                  "Cancel. Leave it on this page.,Cancel",
          /* Toggle Box */  INPUT TRUE,
          /* Help Tool  */  INPUT "AB",
          /* Context    */  INPUT {&Advisor_Page_Source_on_0},
          /* Choice     */  INPUT-OUTPUT choice,
          /* Never Again */ OUTPUT {&NA-Not-On-0-drwsmar} ).
      /* Note that Page 0 is always shown, so we don't need to view or hide the
         object even though its page is changing. */
      IF choice eq "0" THEN _S._page-number = 0.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Get_Field_Name) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Get_Field_Name Procedure 
PROCEDURE Get_Field_Name :
/*------------------------------------------------------------------------------
  Purpose:     Returns appropriate field name for a Data Field.
  Parameters:  phField - Handle to object whose name is being determined.
               pPrecid - Procedure (_P) recid of object.
               pName   - Returned name of object in question. If the object is
                         a Data Field from an SBO, pName gets prefixed with the
                         SBO's object name along with ".".
                              Example: "dorder.SalesRep"
  Notes: The only condition currently where the parent object name is added
         is for SBO Data Fields.
  Fixes: jep    05/24/01 IZ 1318 SmartSelect on SDV built from SBO blanks all fields.
  Fixes: jep    10/01/01 IZ 1611 <Local> field support for SmartDataFields.
------------------------------------------------------------------------------*/

DEFINE INPUT        PARAMETER phField AS HANDLE     NO-UNDO.
DEFINE INPUT        PARAMETER pPrecid AS RECID      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pName   AS CHARACTER  NO-UNDO.

DEFINE BUFFER DataField_U  FOR _U.
DEFINE BUFFER DataField_TT FOR _TT.

DEFINE VARIABLE lSboObj AS LOGICAL NO-UNDO.

DO ON ERROR UNDO, LEAVE
   ON STOP  UNDO, LEAVE:
       ASSIGN lSboObj = NO.
       FIND DataField_U WHERE DataField_U._HANDLE = phField NO-LOCK NO-ERROR.
       IF NOT AVAILABLE DataField_U THEN RETURN.

       /* Determine if our object is a Data Field (e.g., an SDO RowObject field or
          SBO field). Since Data Field objects are managed using the _P object's temp
          tables, we can check for that first. It could be a user-defined temp-table,
          so we need to check its table type as well. "D" types are Data Fields, "T"
          types are user defined temp-tables. Here we want "D" types. */
       IF DataField_U._DBNAME = "Temp-Tables":u THEN
       DO:
         /* Starting In 9.1B with SBOs, a Viewer can have fields which are qualified
            by the SBO's ObjectName. _U._TABLE and _TT._NAME hold these values and we
            use them to see if the _TT is for a Data Source object. -jep */
         FIND FIRST DataField_TT WHERE DataField_TT._P-RECID = pPrecid
                                   AND DataField_TT._NAME    = DataField_U._TABLE NO-LOCK NO-ERROR.
         /* It's an SBO Data Field if temp-table type is "D" and the temp-table's name is not
            RowObject (which would indicate an SDV Data Field -- we don't qualify those). */
         IF AVAILABLE DataField_TT THEN
            ASSIGN lSboObj = (DataField_TT._TABLE-TYPE = "D":U AND DataField_TT._NAME <> "RowObject":u).
         ELSE /* Not an SBO data field. No need to prefix. */
            ASSIGN lSboObj = NO.

         IF lSboObj THEN
            ASSIGN pName = DataField_TT._NAME + "." + pName.
            
       END. /* IF Temp-Table THEN */
END. /* DO */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Get_Start_Name) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Get_Start_Name Procedure 
PROCEDURE Get_Start_Name :
/*------------------------------------------------------------------------------
  Purpose:     Takes _object_draw and makes an object name for it 
  Parameters:  name (OUTPUT) - the suggested name of the object.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER name AS CHARACTER NO-UNDO.
  
  DEFINE VAR ch         AS CHAR NO-UNDO.
  DEFINE VAR cnt        AS INTEGER NO-UNDO.
  DEFINE VAR ipos       AS INTEGER NO-UNDO.
  DEFINE VAR itest      AS INTEGER NO-UNDO.
  DEFINE VAR valid-name AS CHAR NO-UNDO.
  
  ASSIGN name = TRIM(_object_draw).
  
  /* Get the file name out of the whole string.  NOTE that progress allows
     both / and \ characters for directory delimeters, and that "." can appear
     in many places.  We want:
        "C:\DLC\BIN.WIN\objects\p-nav"    to become "h_p-nav" */
  
  /* First strip off the directory by finding the last / or \ */
  ASSIGN ipos  = R-INDEX(name,"/")
         itest = R-INDEX(name,"~\").
         
  /* Which is bigger, ipos or itest? Strip everything before the larger. */
  IF itest > ipos THEN ipos = itest.
  IF ipos > 0     THEN name = SUBSTRING(name, ipos + 1, -1, "CHARACTER").
  
  /* Now strip everything up to the file extension.  This handles the case
     of long unix names with multiple "."'s (eg. file.test.w) */
  name = ENTRY(1, name, ".").
  
  /* Make sure all the characters in the name are valid. */
  ASSIGN valid-name = ""
         cnt = LENGTH (name, "CHARACTER":U).
  DO ipos = 1 TO cnt:
    ch = SUBSTRING(name, ipos, 1, "CHARACTER":U).
    IF ch = " ":U THEN ch = "_". /* Replace spaces. */
    IF INDEX ("#$%&-_0123456789ETAONRISHDLFCMUGYPWBVKXJQZ":U, ch) > 0
    THEN valid-name = valid-name + ch.
  END. /* DO ipos.. */
  /* Remove any leading or trailing "funny characters. */
  valid-name = TRIM(valid-name, "_-":U).
  /* Worry about a really long name exceeding 32 character. NOTE that we
     will prepend a "h_". */
  IF LENGTH(valid-name, "RAW":u) > 30 
  THEN valid-name = SUBSTRING(valid-name, 1, 30, "FIXED":U).
  /* Is the name blank? */
  IF valid-name eq "":U THEN valid-name = "smo":U.
 
  /* Return the name. */
  ASSIGN name = "h_" + valid-name.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

