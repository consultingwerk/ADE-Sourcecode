&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 

/***********************************************************************
*Copyright (C) 2005 by Progress Software Corporation.                  *
*All rights reserved.  Prior versions of this work may contain portions*
*contributed by participants of Possenet.                              *
***********************************************************************/

/*----------------------------------------------------------------------------

File: _adm-crt.p

Description:
    Generate the code needed in an adm-create-objects procedure.
    
Input Parameters:
    p_Urecid  - recid of the current window
    p_status - status of SmartObjects to export (eg. NORMAL, EXPORT)
    
Output Parameters:
    p_Code - code to return.
 
NOTES:
  If we are exporting SmartObjects, the following notes apply.
     a) we only note links if BOTH objects are being exported.
     b) we note the FRAME as "FRAME ?" if we are exporting a smartObject
        but not its parent [even if the parent is the Window.]
     c) items exported on the CURRENT page are exported as being on
        page "?".  These will be pasted on the current page.    
    
Author: Wm.T.Wood

Date Created: March, 1995

Modified on 2/26/96 by gfs - commented out 2/26/96 fix - not ready yet
            2/22/96 by gfs - added to generated code to get value of adm-current-page
            3/12/98 by slk - ADM1 and ADM2 syntax
      RUN get-attribute-list IN x_S._HANDLE (OUTPUT x_S._settings) NO-ERROR.
   to x_S._settings = DYNAMIC-FUNCTION("instancePropertyList":U IN x_S._HANDLE,"":U) NO-ERROR.
            3/1/99  by slk - Assign Tab Order w/in Exported items ONLY
            8/2/99 by tsm - When tab order code is generated, check to make
                            sure that the widget is not no-tab-stop and that
                            it is not a no-focus button
            8/2/00 by hd    sort data-link objects top-down and before others                
            5/17/01 by jep  IZ 1224 : generate correct update links for ADM1.
----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER     p_Urecid  AS RECID      NO-UNDO.
DEFINE INPUT  PARAMETER     p_status  AS CHAR       NO-UNDO.
DEFINE OUTPUT PARAMETER     p_code    AS CHAR       NO-UNDO.

{adeuib/uniwidg.i}           /* Definition of Universal Widget TEMP-TABLE    */
{adeuib/layout.i}            /* Layout */
{adeuib/links.i}             /* Link table definiton                         */
{adeuib/pre_proc.i}          /* Necessary preprocessor defs                  */
{adeuib/sharvars.i}          /* UIB Shared variables                         */
{adecomm/adefext.i}          /* UIB Preprocessors                            */

/* Define the handle of the BROKER. */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VARIABLE widget-name   AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE admVersion    AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE cTranslatable AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE iSort          AS INTEGER    NO-UNDO.

/* Sort DataLinks in tree order */
DEFINE TEMP-TABLE tDataTree
    FIELD DataObject   AS RECID 
    FIELD ParentObject AS RECID
    FIELD Pos          AS DEC 
    FIELD SortWeight   AS INT 
    INDEX DataObject DataObject
    INDEX ParentObject ParentObject Pos.

/* FUNCTION PROTOTYPE */
FUNCTION db-fld-name RETURNS CHARACTER
  (INPUT rec-type AS CHARACTER, INPUT rec-recid AS RECID) IN _h_func_lib.

DEFINE BUFFER xx_F  FOR _F.

/* Standard End-of-line character - adjusted in 7.3A to be just chr(10) */
&Scoped-define EOL CHR(10)

DEFINE VAR  x_U-link-code  AS CHAR       NO-UNDO.
DEFINE VAR  code-links     AS CHAR       NO-UNDO.
DEFINE VAR  cTemp          AS CHAR       NO-UNDO.
DEFINE VAR  c_Precid       AS CHAR       NO-UNDO.
DEFINE VAR  file-name      AS CHAR       NO-UNDO.
DEFINE VAR  init-pages     AS CHAR       NO-UNDO.
DEFINE VAR  is-db-aware    AS LOGICAL    NO-UNDO.
DEFINE VAR  i-tab-ord      AS INTEGER    NO-UNDO.
DEFINE VAR  l_smos         AS LOGICAL    NO-UNDO.
DEFINE VAR  i              AS INTEGER    NO-UNDO.
DEFINE VAR  move-method    AS CHARACTER  NO-UNDO.
DEFINE VAR  old-adm        AS LOGICAL    NO-UNDO.
DEFINE VAR  settings       AS CHAR       NO-UNDO.
DEFINE VAR  tmp-settings   AS CHAR       NO-UNDO.
DEFINE VAR  tab-order-code AS CHARACTER  NO-UNDO.
DEFINE VAR  this-page      AS INTEGER    NO-UNDO.   
DEFINE VAR  ver-broker     AS DECIMAL    NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER x_U      FOR _U.
DEFINE BUFFER x_S      FOR _S.
DEFINE BUFFER xx_U     FOR _U.
DEFINE BUFFER xx_S     FOR _S.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-brokerVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD brokerVersion Procedure 
FUNCTION brokerVersion RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructObjectsDef) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD constructObjectsDef Procedure 
FUNCTION constructObjectsDef RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createDataTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createDataTree Procedure 
FUNCTION createDataTree RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-currentPageDef) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD currentPageDef Procedure 
FUNCTION currentPageDef RETURNS CHARACTER
  ( plOld AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTabOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTabOrder Procedure 
FUNCTION setTabOrder RETURNS LOGICAL
  ( piPage AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sortDataLinkTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD sortDataLinkTree Procedure 
FUNCTION sortDataLinkTree RETURNS LOGICAL
  (prParent AS RECID)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Compile into: 
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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Get the current procedure. */
FIND _U WHERE RECID(_U) eq p_Urecid.
FIND _P WHERE _P._u-recid eq p_Urecid.
/* We will use the STRING of the Procedure RECID. */
c_Precid = STRING(RECID(_P)).

/* Are there any objects at all. */
ASSIGN l_smos = CAN-FIND (FIRST x_U WHERE x_U._WINDOW-HANDLE eq _U._HANDLE
                                AND x_U._TYPE eq "SmartObject"
                                AND x_U._STATUS eq p_Status)
       old-adm = _P._adm-version < "ADM2":U.

/* Write out a variable to hold the page number (if necessary). */
IF l_smos OR (p_status eq "NORMAL":U AND _P._page-select ne 0) THEN   
  p_code  = currentPageDef(old-adm).
  
IF l_smos THEN
DO:
  /* Get the current version of the broker. */
  ver-broker = IF NOT old-adm THEN 0 ELSE brokerVersion() .
    
  /* Write out all the page information. */
  ASSIGN 
    this-page = ?
    p_code    = p_code + (IF old-adm THEN "  CASE adm-current-page: "
                                     ELSE "  CASE currentPage: ") 
                       + {&EOL}.

  /* assign all the constructObject statments to p_code 
   (Moved here because of space problems, no structural clean up attempted) */
  constructObjectsDef().    
   
  /* End the current page and then end the CASE statement. */   
  IF this-page ne ?
  THEN p_code = p_code +
                (IF init-pages eq "" THEN "" ELSE {&EOL} +
                 "       /* Initialize other pages that this page requires. */" + {&EOL} +
                (IF old-adm THEN
                 "       RUN init-pages IN THIS-PROCEDURE ('"
                 ELSE
                 "       RUN initPages ('") + init-pages +
                            "':U) NO-ERROR." + {&EOL}
                ) +                 
                code-links + {&EOL} +
                "       /* Adjust the tab order of the smart objects. */" +
                tab-order-code + {&EOL} +
                "    END. /* Page " + STRING(this-page) + " */".
   p_code = p_code + {&EOL} + {&EOL} +
            "  END CASE." + {&EOL}.
END. /* IF CAN-FIND <any objects>... */
  
       
/* Select the first page -- NOTE that the condition here must match the
   one above that defined "adm-current-page". */
IF p_status eq "NORMAL":U AND _P._page-select ne 0 
THEN p_code = p_code + 
     "  /* Select a Startup page. */" + {&EOL} +
       (IF old-adm THEN "  IF adm-current-page eq 0 "
                   ELSE "  IF currentPage eq 0")      + {&EOL} +
     "  THEN RUN " + (IF old-adm THEN "select-page" ELSE "selectPage") +
        " IN THIS-PROCEDURE ( " + 
                          STRING(_P._page-select) + " )." + {&EOL} .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-brokerVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION brokerVersion Procedure 
FUNCTION brokerVersion RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Broker version should only be called for old-adm.  
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE dVersion AS DECIMAL NO-UNDO.
 
 IF VALID-HANDLE (adm-broker-hdl) THEN 
 DO:
   RUN get-attribute IN adm-broker-hdl ('TYPE':U) NO-ERROR.
   IF ERROR-STATUS:ERROR OR RETURN-VALUE ne 'ADM-Broker':U THEN 
      adm-broker-hdl = ?.
   ELSE DO:
      /* The version should be ADM1.1 or greater for Translation support */
      RUN get-attribute IN adm-broker-hdl ('VERSION':U).
      dVersion = DECIMAL(LEFT-TRIM(RETURN-VALUE, "ADM":U)) NO-ERROR.
   END.
 END.
 RETURN dVersion. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructObjectsDef) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION constructObjectsDef Procedure 
FUNCTION constructObjectsDef RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Adds all run constructObject statments and addlink to the p_code 
    Notes:  This was moved here because of space problems. 
------------------------------------------------------------------------------*/    
  DEFINE VAR  l_set-position AS LOGICAL    NO-UNDO.
  DEFINE VAR  l_set-size     AS LOGICAL    NO-UNDO.
  DEFINE VAR  iPos           AS INTEGER    NO-UNDO.

  /* Create and sort the tDataTree records for each object */ 
  createDataTree().
    
  FOR EACH tDataTree,        
      EACH x_U WHERE RECID(x_U)  = tDataTree.DataObject
               AND   x_U._STATUS = p_status, 
      EACH x_S WHERE RECID(x_S) = x_U._x-recid
      BREAK BY x_S._page-number
            BY tDataTree.SortWeight:
   
    /* Start a new CASE for the new page. */
    IF FIRST-OF (x_S._page-number) THEN DO:
      /* End the previous CASE statement (if there was one), and start a new one. */
      IF this-page ne ?
      THEN p_code = p_code +
                (IF init-pages eq "" THEN "" ELSE {&EOL} +
                 "       /* Initialize other pages that this page requires. */" + {&EOL} +
                (IF old-adm THEN
                 "       RUN init-pages IN THIS-PROCEDURE ('"
                 ELSE
                 "       RUN initPages ('") + init-pages +
                            "':U) NO-ERROR." + {&EOL}
                ) +
                code-links + {&EOL} +
                (IF tab-order-code NE "":U THEN
                   "       /* Adjust the tab order of the smart objects. */" +
                   tab-order-code + {&EOL} 
                   ELSE "":U) +
                "    END. /* Page " + STRING(this-page) + " */".

      /* When exporting, note the page number as "?" so that we will paste onto
         the current page. */
      ASSIGN this-page = x_S._page-number
             cTemp  = IF p_Status eq "EXPORT" AND
                         x_S._page-number eq _P._page-current
                      THEN "?" ELSE STRING(this-page)
             p_code = p_code + {&EOL} +
                      "    WHEN " + cTemp + " THEN DO:"
             /* Reset the variables we maintain for code and dependent pages. */
             init-pages = ""
             code-links = ""
             tab-order-code = "":U.
      setTabOrder(x_S._page-number).
    END.  /* IF FIRST-OF a page */
    FIND parent_U WHERE RECID(parent_U) eq x_U._parent-recid.
    /* Ask the SmartObject for its current settings (if it is valid).
       Also determine whether or not we can set its size explicitly.  */
    
    IF NOT x_S._valid-object
    THEN ASSIGN l_set-size     = NO
                l_set-position = NO
                settings       = "'':U":U.
    ELSE DO:
      {adeuib/admver.i x_S._HANDLE admVersion}
      IF admVersion LT "ADM2":U THEN DO:
         RUN get-attribute-list IN x_S._HANDLE (OUTPUT x_S._settings) NO-ERROR.
         ASSIGN l_set-position = CAN-DO(x_S._HANDLE:INTERNAL-ENTRIES, "set-position":U)
                l_set-size     = CAN-DO(x_S._HANDLE:INTERNAL-ENTRIES, "set-size":U)
                is-db-aware    = FALSE
                settings       = "":U.
      END. /* If adm1.0 */
      ELSE DO:
         ASSIGN 
            x_S._settings = DYNAMIC-FUNCTION("instancePropertyList":U IN x_S._HANDLE,"":U)
                l_set-position = CAN-DO(x_S._HANDLE:INTERNAL-ENTRIES, "repositionObject":U)
                l_set-size     = CAN-DO(x_S._HANDLE:INTERNAL-ENTRIES, "resizeObject":U)
                is-db-aware    = DYNAMIC-FUNCTION("getDBAware":U IN x_S._HANDLE)
                settings       = "":U.
      END.  /* Else ADM2 or greater */

      /* If the SO is a SmartWindow and if the SmartWindow was specified to be
         explicitly positioned then don't position the SmartWindow using set-position
         as windows are positioned in the screen not the parent SO.  Let the window
         position itself.  See bug number 97-06-24-002.  This whole l_set-position
         thing was introduced in response to bug 97-01-31-056 which was the correct
         fix except for the situation described in 97-06-24-002.                      */
      IF x_U._SUBTYPE = "SmartWindow" THEN l_set-position = NO.

      /* Get the translatable settings, if broker is Version ADM1.1 */
      IF ver-broker >= 1.1 THEN
        RUN broker-get-attribute-list IN adm-broker-hdl
                 (INPUT  x_S._HANDLE, 'ADM-TRANSLATABLE-FORMAT':U,
                  OUTPUT settings).

      IF NOT old-adm THEN
        ASSIGN cTranslatable = DYNAMIC-FUNCTION("getTranslatableProperties":U IN x_S._HANDLE).
    
      /* Have settings been set correctly? This won't have happened if the
         broker is old or if the broker returned a bad list. */
      IF (ver-broker >= 1.1 AND (settings eq "":U OR settings eq ?)) OR
         NOT old-adm AND cTranslatable = "" THEN DO:
        /* Use the untranslated settings.  Add single quotes, after we replace 's
           in the string with ~'. */
        IF x_S._settings eq ? THEN x_S._settings = "":U.
        settings = "'":U + REPLACE (x_S._settings, "'":U, "~~'":U) +
                   "':U":U.
      END. /* If there are no translatable properties */
      ELSE IF cTranslatable NE "":U THEN DO:
        settings = "'":U + REPLACE (x_S._settings, "'":U, "~~'":U) +
                   "':U":U. 
        TRANSLATABLE-CHECK:
        DO i = 1 TO NUM-ENTRIES(cTranslatable):
          IF INDEX(x_S._settings,ENTRY(i,cTranslatable)) > 0 THEN DO:
            settings = DYNAMIC-FUNCTION("instancePropertyList":U IN x_S._HANDLE,
                          "ADM-TRANSLATABLE-FORMAT":U) NO-ERROR.
            LEAVE TRANSLATABLE-CHECK.
          END. /* If we find a translatable setting in x_S._settings */
        END.  /* Search through settings to see if any are translatable */
      END.  /* If there are any translatable properties in this SMO */
      IF NOT old-adm AND INDEX(settings,"ForeignFields") = 0 THEN DO:
        /* Settings doesn't contain ForeignFields - see if it has bee defined */
        ASSIGN tmp-settings = DYNAMIC-FUNCTION("getForeignFields":U IN x_S._HANDLE) NO-ERROR.
        if tmp-settings NE "" AND tmp-settings NE ? THEN DO:
          ASSIGN x_S._settings = x_S._settings + (IF x_S._settings NE "" THEN CHR(3) ELSE "") +
                                 "ForeignFields":U + CHR(4) + tmp-settings
          settings = "'":U + REPLACE (x_S._settings, "'":U, "~~'":U) +
                     "':U":U.
          
        END. /* There are foreigh fields, put them into the _settings field */

      END.  /* If ADM2 (or greater) and ForeignFields isn't in the list */
      ELSE IF NOT old-adm AND    /* if the data link has been removed, remove the foreign field values */
           NOT CAN-FIND(FIRST _admlinks WHERE _admlinks._link-dest eq STRING(RECID(x_U))
                          AND _admlinks._link-type EQ "DATA":U)  THEN
      DO iPos = 1 TO NUM-ENTRIES(settings,CHR(3)):
         IF ENTRY(1,ENTRY(iPos,SETTINGS,CHR(3)),CHR(4))  = "ForeignFields":U THEN
         DO:
            ASSIGN ENTRY(iPos,SETTINGS,CHR(3)) = "ForeignFields":U + CHR(4).
            LEAVE.
         END.
      END.
    END.  /* If a valid smartObject */

    /* Find the _L record to use in setting position and size.  */
    FIND _L WHERE _L._u-recid = RECID(x_U)
              AND _L._LO-NAME = "Master Layout":U.

    /* Now write code.  Make the filename as portable as possible by using
       the backslash in the name.  While we are  at it, indent each line of
       settings.  */
    ASSIGN file-name = REPLACE (x_S._FILE-NAME, "~\":U, "/":U)
           settings  = REPLACE (settings, CHR(10),
                                CHR(10) + "                     ":U).
    
    p_code = p_code + {&EOL} +
    (IF old-adm THEN 
          "       RUN init-object IN THIS-PROCEDURE ("
                ELSE
          "       RUN constructObject (":U )                    + {&EOL} +
                  (IF x_S._var-name NE "" THEN
          "           ~&IF DEFINED(UIB_is_Running) ne 0 ~&THEN" + {&EOL}
                  ELSE "") +
    "             INPUT  '" + file-name  + (IF is-db-aware THEN CHR(3) + "DB-AWARE" ELSE "") +
                                           "':U ,"+ {&EOL} +
                  (IF x_S._var-name NE "" THEN
    "           ~&ELSE" + {&EOL} +
    "             INPUT " + x_S._var-name + 
                      (IF is-db-aware THEN " + CHR(3) + ~"DB-AWARE~":U" ELSE "") +
                       " ,"+ {&EOL} +
    "           ~&ENDIF" + {&EOL}
                  ELSE "") +
    "             INPUT  " +
                    /* Put out "FRAME ?" instead of frame or window name if
                       we are exporting the SmartObject but not its Parent.
                       This signals an IMPORT that we should parent the
                       SmartObject to the current container. */
                    (IF parent_U._STATUS ne x_U._STATUS THEN "FRAME ?"
                     ELSE (IF parent_U._TYPE eq "WINDOW":U
                           THEN "~{&WINDOW-NAME}"
                           ELSE "FRAME " + parent_U._NAME  + ":HANDLE")) + 
                    " ,"+ {&EOL} +
    "             INPUT  " + settings + " ," + {&EOL} +
    "             OUTPUT " + x_U._NAME + " )."+ {&EOL} .
    /* Add Position for SmartObjects.  Non-visual objects still need
       a position in the UIB.  */
    p_code = p_code +
             (IF l_set-position
              THEN
      "       RUN " + (IF old-adm THEN "set-position" ELSE "repositionObject") +
                       " IN ":U + x_U._NAME +
                  " ( " + LEFT-TRIM(STRING(_L._ROW,">>>>9.99":U)) +
                  " , " + LEFT-TRIM(STRING(_L._COL,">>>>9.99":U)) +
                  " ) NO-ERROR.":U
              ELSE
      "       /* Position in {&UIB_SHORT_NAME}: ":U +
                  " ( " + LEFT-TRIM(STRING(_L._ROW,">>>>9.99":U)) +
                  " , " + LEFT-TRIM(STRING(_L._COL,">>>>9.99":U)) +
                  " ) */":U ) +
              {&EOL} +   
             (IF l_set-size THEN
      "       RUN " + (IF old-adm THEN "set-size" ELSE "resizeObject") +
                       " IN ":U + x_U._NAME +
                  " ( " + LEFT-TRIM(STRING(_L._HEIGHT,">>>>9.99":U)) +
                  " , " + LEFT-TRIM(STRING(_L._WIDTH,">>>>9.99":U)) +
                  " ) NO-ERROR.":U
              ELSE
      "       /* Size in " + (IF _P._file-version BEGINS "UIB":U
                              THEN "UIB: ":U ELSE "{&UIB_SHORT_NAME}: ":U) + 
                  " ( " + LEFT-TRIM(STRING(_L._HEIGHT,">>>>9.99":U)) + 
                  " , " + LEFT-TRIM(STRING(_L._WIDTH,">>>>9.99":U)) + 
                  " ) */":U ) +
              {&EOL} .

    /* See if any links need to be created (and if these links go to any
       other pages that will need to be intialized first - i.e. where the
       source is on another page).  First check links to other SmartObjects.
       Sort this list in a deterministic way to ensure no "diff" issues
       between saves. */
    x_U-link-code = "":U.
    /* Where is this object the TARGET of another SmartObject SOURCE ... 
       (Except that the rule is reversed for the new adm and UPDATE links) */
    /* IZ 1224 : Added parentheses to the "AND portion" of "NOT old-adm" to prevent
       picking up additional link records due to faulty logic. - jep 05/17/01 */

    FOR EACH _admlinks WHERE
             (old-adm AND
                  _admlinks._link-dest eq STRING(RECID(x_U))) OR
             (NOT old-adm AND
                ( (_admlinks._link-dest eq STRING(RECID(x_U)) AND
                     _admlinks._link-type NE "UPDATE":U) OR
                  (_admlinks._link-source eq STRING(RECID(x_U)) AND
                     _admlinks._link-type EQ "UPDATE":U) ) ) ,
        EACH xx_U WHERE RECID(xx_U) eq INTEGER (IF (old-adm OR _admlinks._link-type NE "UPDATE":U)
                                                THEN _admlinks._link-source ELSE _admlinks._link-dest)
                    AND xx_U._STATUS eq p_status
      BY xx_U._NAME BY _admlinks._link-type:

      /* Is this on another page that will need to be initialized? */
      FIND xx_S WHERE RECID(xx_S) eq xx_U._x-recid.
      IF (xx_S._page-number ne 0) AND (xx_S._page-number ne this-page)
      THEN DO:
        cTemp = STRING(xx_S._page-number).
        IF init-pages = ""                    THEN init-pages = cTemp.
        ELSE IF NOT CAN-DO(init-pages, cTemp) THEN init-pages = init-pages + "," + cTemp.
      END.
      /* Add the link. */
      /* IZ 1224 : New adm reverses the order of UPDATE links from old-adm. - jep 05/17/01 */
      IF old-adm THEN
      DO:
        /* IZ 1224 : xx_U is source object and x_U is target object. - jep 05/17/01 */
        x_U-link-code = x_U-link-code +
            "       RUN add-link IN adm-broker-hdl ( " +
                             (xx_U._NAME + " , '" + 
                              _admlinks._link-type + "':U , " +
                              x_U._NAME)
                              + " )." + {&EOL}.
      END.
      ELSE /* new adm */
      DO:
        /* IZ 1224 : For non-UPDATE links, xx_U is source object and x_U is target object
           (same as old-adm). The rule is reversed for UPDATE links in new adm. - jep 05/17/01 */
        x_U-link-code = x_U-link-code +
            "       RUN addLink ( "  +
                             (IF _admlinks._link-type NE "UPDATE":U
                              THEN xx_U._NAME + " , '" + 
                                   _admlinks._link-type + "':U , " +
                                   x_U._NAME
                              ELSE x_U._NAME + " , '" + 
                                   _admlinks._link-type + "':U , " +
                                   xx_U._NAME)
                              + " )." + {&EOL}.
      END.
    END. /* For each link where x_U is the TARGET of another SmartObject. */

    /* Now export links where the THIS-PROCEDURE is the SOURCE of this SmartObject. */
    FOR EACH _admlinks WHERE _admlinks._link-dest eq STRING(RECID(x_U))
                         AND _admlinks._link-source eq c_Precid
        BY _admlinks._link-type:
     /* Add the link. */
     x_U-link-code = x_U-link-code +
         (IF old-adm THEN
         "       RUN add-link IN adm-broker-hdl ( THIS-PROCEDURE , '"
         ELSE
         "       RUN addLink ( THIS-PROCEDURE , '") +
                         _admlinks._link-type + "':U , " +
                         x_U._NAME  + " )." +
                         {&EOL}.
    END. /* For each link where THIS-PROCEDURE is the source */

    /* Now export links where THIS-PROCEDURE is the TARGET of this SmartObject.*/
    FOR EACH _admlinks WHERE _admlinks._link-source eq STRING(RECID(x_U))
                         AND _admlinks._link-dest   eq c_Precid
        BY _admlinks._link-type:
      /* Add the link. */
      x_U-link-code = x_U-link-code +
      (IF old-adm THEN
      "       RUN add-link IN adm-broker-hdl ( "
      ELSE
      "       RUN addLink ( ") +
                         x_U._NAME + " , '" +
                         _admlinks._link-type + "':U , THIS-PROCEDURE )." +
                 {&EOL}.
    END. /* For each link where THIS-PROCEDURE is the Target for this object. */

    /* Was there any link code for this particular SmartObject. */
    IF x_U-link-code ne "":U
    THEN code-links = code-links + {&EOL} +
      "       /* Links to " + x_U._SUBTYPE + " " + x_U._NAME + ". */" + {&EOL} +
      x_U-link-code.

  END.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createDataTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createDataTree Procedure 
FUNCTION createDataTree RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  create DataTree records
    Notes:  ALl objects with participating in data links will be sorted 
            BEFORE any other objects. 
            They will be sorted from data-source in link order 
            (This will not work for DataSources on other pages because the 
             pagenumber is sorted above this sort)   
------------------------------------------------------------------------------*/
FOR EACH _admlinks WHERE _admlinks._P-recid   = RECID(_P)
                   AND   _admlinks._link-type = 'Data':U:        
    
  /* Ensure there's a tdataTree for each link where source <> this-procedure */
  IF _admlinks._link-source <> STRING(_admlinks._P-recid) THEN
  DO:
    FIND tDataTree WHERE tDataTree.DataObject = INT(_admlinks._link-source) NO-ERROR.
    IF NOT AVAIL tDataTree THEN
    DO:
      FIND X_U WHERE RECID(X_u) = INT(_admlinks._link-source) NO-ERROR.
      CREATE tDataTree.  
      ASSIGN
        tDataTree.DataObject  = INT(_admlinks._link-source)
                                 /* secondary sort */
        tDataTree.Pos         = IF AVAILABLE(X_u) AND VALID-HANDLE(x_U._HANDLE) 
                                THEN X_U._Handle:ROW 
                                ELSE 0. 
    END.
  END.

  /* Ensure there's a tdataTree for each link where target <> this-procedure */
  IF _admlinks._link-dest <> STRING(_admlinks._P-recid) THEN
  DO:
    FIND tDataTree WHERE tDataTree.DataObject = INT(_admlinks._link-dest) NO-ERROR.
    IF NOT AVAIL tDataTree THEN
    DO:
      CREATE tDataTree.  
      ASSIGN
        tDataTree.DataObject   = INT(_admlinks._link-dest).
    END.
    FIND X_U WHERE RECID(X_u) = INT(_admlinks._link-dest) NO-ERROR.
    ASSIGN    
        tDataTree.ParentObject = IF _admlinks._link-source <> STRING(_admlinks._P-recid)
                                 THEN INT(_admlinks._link-source)
                                 ELSE ?
        tDataTree.Pos          = IF AVAILABLE(X_u) AND VALID-HANDLE(x_U._HANDLE) 
                                 THEN X_U._Handle:ROW 
                                 ELSE 0.                                       
  END.
END. /* for each _admlinks */

/* Sort the tree(s) top-down starting on objects with no data-source */ 
sortDataLinkTree(?).

/* Now sort all the object that does not participate in a data link */
FOR EACH x_U     WHERE x_U._WINDOW-HANDLE EQ _U._HANDLE
                 AND   x_U._TYPE eq "SmartObject"
                 AND   x_U._STATUS eq  'normal', /*       p_Status,*/
        EACH x_S WHERE RECID(x_S) eq x_U._x-recid
        BY x_s._Page-number
        /* let's also ensure that non-linked dataobjects are before others */ 
        BY (IF can-do('SmartDataObject,SmartBusinessObject',X_u._subtype)
            THEN 1 
            ELSE 2)
        BY x_U._tab-order:
  
  FIND tDataTree WHERE tDataTree.DataObject = recid(x_U) NO-ERROR.
  
  IF NOT AVAILABLE tDataTree THEN
  DO:
    CREATE tDataTree.
    ASSIGN 
      iSort = iSort + 1
      tDataTree.DataObject = recid(x_U)
      tDataTree.SortWeight = iSort.           
  END.
END.

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-currentPageDef) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION currentPageDef Procedure 
FUNCTION currentPageDef RETURNS CHARACTER
  ( plOld AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose: assign currentpage on top of code block  
    Notes:  
------------------------------------------------------------------------------*/
IF NOT plOld THEN 
 RETURN  
  "  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO." + {&EOL} + {&EOL} +
  "  ASSIGN currentPage = getCurrentPage()." + {&EOL} + {&EOL}.
ELSE  
 RETURN 
  "  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO." + {&EOL} + {&EOL} +
  "  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U)." + {&EOL} +
  "  ASSIGN adm-current-page = INTEGER(RETURN-VALUE)." + {&EOL} + {&EOL}.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTabOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTabOrder Procedure 
FUNCTION setTabOrder RETURNS LOGICAL
  ( piPage AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: To write code to set the tab order for a particular page. 
    Notes:
------------------------------------------------------------------------------*/
  DEFINE BUFFER t_U   FOR _U.
  DEFINE BUFFER t_S   FOR _S.
  DEFINE BUFFER xxx_S FOR _S.

  /* Temporarily make non-visible SO's negative tab-order */
  FOR EACH t_U WHERE t_U._WINDOW-HANDLE eq _U._HANDLE
                   AND t_U._TYPE eq "SmartObject"
                   AND t_U._STATUS eq p_Status,
          EACH t_S WHERE RECID(t_S) eq t_U._x-recid AND
                         (t_S._page-number = piPage) AND
                         NOT t_S._VISUAL:
     IF t_U._TAB-ORDER > 0 THEN t_U._TAB-ORDER = (0 - t_U._TAB-ORDER).
  END.                    

  /* Temporarily make non-exported SO's negative tab-order */
  IF p_Status = "EXPORT":U THEN DO:
     /* Now restore the non-exported SO's tab-orders */
     FOR EACH t_U WHERE t_U._WINDOW-HANDLE eq _U._HANDLE
                      AND t_U._TYPE eq "SmartObject"
                      AND t_U._STATUS <> "EXPORT":U,
             EACH t_S WHERE RECID(t_S) eq t_U._x-recid AND
                            (t_S._page-number = piPage):
        IF t_U._TAB-ORDER > 0 THEN t_U._TAB-ORDER = (0 - t_U._TAB-ORDER).
     END.                    
  END. /* If Export */

  tab-order-code = "".
  
  FOR EACH t_U WHERE t_U._WINDOW-HANDLE eq _U._HANDLE
                 AND t_U._TYPE eq "SmartObject"
                 AND t_U._STATUS eq p_Status,
        EACH t_S WHERE RECID(t_S) eq t_U._x-recid AND
                    (t_S._page-number = piPage) AND
                     t_S._VISUAL
        BY t_U._tab-order:
     IF t_U._tab-order > 1 THEN DO:  /* This is not first, move after something */
       FIND-LAST:
       DO PRESELECT EACH xx_U WHERE
                    xx_U._WINDOW-HANDLE eq _U._HANDLE AND
                    xx_U._PARENT-RECID eq t_U._PARENT-RECID AND
                    RECID(xx_U) NE xx_U._PARENT-RECID AND
                    LOOKUP(xx_U._TYPE,"RECTANGLE,OCX,TEXT,IMAGE,QUERY,LABEL") = 0 AND
                    xx_U._SUBTYPE ne "TEXT" AND xx_U._TAB-ORDER > 0 AND
                    xx_U._STATUS EQ p_Status
               BY xx_U._TAB-ORDER:

          /* Find the last object of the preselected objects that has a tab order 
             less than the t_U object and is on page 0 or piPage */
          FIND LAST xx_U WHERE xx_U._WINDOW-HANDLE eq _U._HANDLE AND
                               xx_U._PARENT-RECID eq t_U._PARENT-RECID AND
                               xx_U._TYPE ne "{&WT-CONTROL}" AND
                               xx_U._TAB-ORDER < t_U._TAB-ORDER NO-ERROR.
          DO WHILE AVAILABLE xx_U:
            FIND xxx_S WHERE RECID(xxx_S) EQ xx_U._x-recid NO-ERROR.
            IF NOT AVAILABLE xxx_S /* not smart */ OR 
              xxx_S._page-number = 0 OR xxx_S._page-number = piPage THEN
              LEAVE FIND-LAST.
            ELSE
              FIND PREV xx_U WHERE xx_U._WINDOW-HANDLE eq _U._HANDLE AND
                                   xx_U._PARENT-RECID eq t_U._PARENT-RECID AND
                                   xx_U._TYPE ne "{&WT-CONTROL}" AND
                                   xx_U._TAB-ORDER < t_U._TAB-ORDER NO-ERROR.
          END. /* Do while available xx_U */
       END. /* End preselect */
       IF AVAILABLE xx_U THEN DO:
         ASSIGN move-method = "AFTER":U
                i-tab-ord = xx_U._tab-order.
         FIND FIRST xx_S WHERE RECID(xx_S) eq xx_U._x-recid AND
                         (xx_S._page-number = piPage) NO-ERROR.
       END.  /* IF AVAIABLE xx_U */
     END.  /* Not first in the tab order */
     IF t_U._tab-order = 1 OR NOT AVAILABLE xx_U THEN DO:  /* move before something */
       FIND-FIRST:
       DO PRESELECT EACH xx_U WHERE
                    xx_U._WINDOW-HANDLE eq _U._HANDLE AND
                    xx_U._PARENT-RECID eq t_U._PARENT-RECID AND
                    RECID(xx_U) NE xx_U._PARENT-RECID AND
                    LOOKUP(xx_U._TYPE,"RECTANGLE,OCX,TEXT,IMAGE,QUERY,LABEL") = 0 AND
                    xx_U._SUBTYPE ne "TEXT" AND
                    xx_U._STATUS EQ p_Status
               BY xx_U._TAB-ORDER:
          FIND FIRST xx_U WHERE xx_U._WINDOW-HANDLE eq _U._HANDLE AND
                                xx_U._PARENT-RECID eq t_U._PARENT-RECID AND
                                xx_U._TYPE ne "SmartObject":U AND
                                xx_U._TYPE ne "{&WT-CONTROL}" AND
                                xx_U._TAB-ORDER > 1 NO-ERROR.
          DO WHILE AVAILABLE xx_U:
            FIND xxx_S WHERE RECID(xxx_S) EQ xx_U._x-recid NO-ERROR.
            IF NOT AVAILABLE xxx_S /* not smart */ OR 
              xxx_S._page-number = piPage THEN
              LEAVE FIND-FIRST.
            ELSE
              FIND NEXT xx_U WHERE xx_U._WINDOW-HANDLE eq _U._HANDLE AND
                                   xx_U._PARENT-RECID eq t_U._PARENT-RECID AND
                                   xx_U._TYPE ne "{&WT-CONTROL}" AND
                                   xx_U._TAB-ORDER < t_U._TAB-ORDER NO-ERROR.
          END. /* Do while available xx_U */
       END. /* End preselect */
       IF AVAILABLE xx_U THEN DO:
         ASSIGN move-method = "BEFORE":U
                i-tab-ord = xx_U._TAB-ORDER.
          FIND FIRST xx_S WHERE RECID(xx_S) eq xx_U._x-recid AND
                          (xx_S._page-number = piPage) NO-ERROR.
       END.  /* If available xx_U */
     END.  /* If this is first in the tab order */

     /* At this point if we have an xx_U record. It is the anchor that t_U
        will move before or after.  We now set h-tab-object to its handle. */
     IF AVAILABLE xx_U AND NOT xx_U._NO-TAB-STOP THEN DO:
       FIND _L WHERE _L._u-recid = RECID(xx_U)
           AND _L._LO-NAME = "Master Layout":U.
       IF NOT _L._NO-FOCUS THEN DO:
         tab-order-code = tab-order-code + {&EOL} +
           (IF old-adm THEN 
           "       RUN adjust-tab-order IN adm-broker-hdl ( "
           ELSE
           "       RUN adjustTabOrder ( ") + t_U._NAME + " ,":U.

         /* Is the anchor another smart object? */
         IF xx_U._TYPE = "SmartObject":U THEN
           tab-order-code = tab-order-code + {&EOL} +
           "             " + xx_U._NAME + " , '":U + move-method + "':U ).":U .
         ELSE DO: /* it is a normal widget */
           FIND xx_F WHERE RECID(xx_F) = xx_U._x-recid NO-ERROR.
           widget-name = (IF xx_U._DBNAME = ? OR (AVAILABLE xx_F AND
                                                  xx_F._DISPOSITION = "LIKE":U) THEN 
                          (IF xx_U._TYPE = "FRAME":U THEN "FRAME " ELSE "") + xx_U._NAME
                          ELSE db-fld-name("_U":U, RECID(xx_U))).
           FIND parent_U WHERE RECID(parent_U) = xx_U._PARENT-RECID.
           tab-order-code = tab-order-code + {&EOL} +
           "             " + widget-name + ":HANDLE" +
                   (IF parent_U._TYPE = "FRAME" THEN 
                   (IF xx_U._TYPE = "FRAME" THEN "" ELSE " IN FRAME " + parent_U._NAME)
                                                ELSE "") + " , '" + move-method + "':U ).":U.      
         END.  /* If a normal widget */    
       END.  /* if not no-focus button */
     END.  /* If we find an object to anchor this smartobject to */
  END.  /* For each t_U smartobject */
  
  /* Now restore the non-visible SO's tab-orders */
  FOR EACH t_U WHERE t_U._WINDOW-HANDLE eq _U._HANDLE
                   AND t_U._TYPE eq "SmartObject"
                   AND t_U._STATUS eq p_Status,
          EACH t_S WHERE RECID(t_S) eq t_U._x-recid AND
                     (t_S._page-number = piPage) AND
                     NOT t_S._VISUAL:
     IF t_U._TAB-ORDER < 0 THEN t_U._TAB-ORDER = (0 - t_U._TAB-ORDER).
  END.                    

  IF p_Status = "EXPORT":U THEN DO:
     /* Now restore the non-exported SO's tab-orders */
     FOR EACH t_U WHERE t_U._WINDOW-HANDLE eq _U._HANDLE
                      AND t_U._TYPE eq "SmartObject"
                      AND t_U._STATUS <> "EXPORT":U,
             EACH t_S WHERE RECID(t_S) eq t_U._x-recid AND
                        (t_S._page-number = piPage) :
        IF t_U._TAB-ORDER < 0 THEN t_U._TAB-ORDER = (0 - t_U._TAB-ORDER).
     END.                    
  END. /* If Export */
  
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sortDataLinkTree) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION sortDataLinkTree Procedure 
FUNCTION sortDataLinkTree RETURNS LOGICAL
  (prParent AS RECID) :
/*------------------------------------------------------------------------------
  Purpose: Sort one level of objects with datalinks. 
    Notes: The assumption is that the only ONE dataSource is allowed.             
------------------------------------------------------------------------------*/
 DEFINE BUFFER bTree FOR tDataTree.
  /* bTree.Pos is second field in parent index so any objects on same level 
    is sorted on position (row) */
 FOR EACH bTree WHERE bTree.ParentObject = prParent:

   ASSIGN iSort            = iSort + 1. 
          bTree.SortWeight = iSort. 
   /* Note:  ALL children of the SDO will be sorted before siblings */ 
   sortDataLinkTree(bTree.DataObject).
 END.
 
 RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

