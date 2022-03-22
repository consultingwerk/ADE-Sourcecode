&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _rdsmar.p

Description:
    Reads the contents of a _ADM-CREATE-OBJECTS code procedure and creates
    (and realizes) all smartobjects.

Note:
    Called from _cdsuckr.p when it finds a "adm-create-objects" method.
    The object

Input Parameters:
    pu-recid: RECID of the associatied Window/Dialog _U.

Output Parameters:
   <None>

Author: Wm. T. Wood

Date Created:  March 1995

Modified:
  gfs 12/4/95 - [95-11-29-007] If no 'CASE', initial  page was not read.  
  wtw 6/20/96 - [96-06-18-016] All SmO's set to "Param as Var".
  hd  9/9/99  - run _realizeSmart PERSISTENT instead of _undsmar 
---------------------------------------------------------------------------- */
DEFINE INPUT PARAMETER pu-recid AS RECID NO-UNDO.

{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/layout.i}       /* multi-layout information                          */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/links.i}        /* Link TEMP-TABLE definition                        */
{adeuib/name-rec.i}     /* Name indirection table                            */
{adeuib/sharvars.i}     /* Shared variables                                  */
{adecomm/adefext.i}     /* UIB Preprocessors                                 */

DEFINE SHARED VAR OCX-Tab-Info   AS CHARACTER NO-UNDO.
DEFINE VARIABLE old-adm    AS LOGICAL  NO-UNDO.

DEFINE VARIABLE hRealizeSmart  AS HANDLE     NO-UNDO.
DEFINE VARIABLE move-method    AS CHARACTER  NO-UNDO.

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
         HEIGHT             = 8.91
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* *********************** Local  Definitions  ************************ */

DEFINE VARIABLE cr-source  AS CHAR     NO-UNDO.
DEFINE VARIABLE file-name  AS CHAR     NO-UNDO.
DEFINE VARIABLE fr-name    AS CHAR     NO-UNDO.
DEFINE VARIABLE i          AS INT      NO-UNDO.
DEFINE VARIABLE u-handles  AS CHAR     NO-UNDO.

DEFINE BUFFER anchor_U FOR _U.

/* Temp-Table to store links before they are processed into items. */
DEFINE TEMP-TABLE tt-link 
  FIELD dst AS CHAR
  FIELD src AS CHAR
  FIELD typ AS CHAR   
  INDEX src IS PRIMARY src
  .

/* Standard End-of-line character */
&Scoped-define EOL &IF "{&WINDOW-SYSTEM}" <> "OSF/Motif" &THEN "~r" + &ENDIF CHR(10)

/* If we ever get to the END PROCEDURE, then we have come too far. */
&Scoped-define ERROR-CONDITION (_inp_line[1] eq "END" AND _inp_line[2] eq "PROCEDURE." AND _inp_line[3] eq "")

/* Use this to turn debugging on after each line that is read in. 
   (i.e. rename no-DEBUG  to DEBUG) */
&Scoped-define no-debug message _inp_line[1] _inp_line[2] _inp_line[3] _inp_line[4] _inp_line[5] .

DEFINE SHARED  STREAM    _P_QS.
DEFINE SHARED  VARIABLE  _inp_line  AS  CHAR    EXTENT 100 NO-UNDO.
/* We use the 100 extent value in process-page, so if its changed here,
   it must be changed later in this code. -jep */

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.

/* ***************************  Main Block  *************************** */

/* Get the current procedure file */
FIND _P WHERE _P._u-recid eq pu-recid.
old-adm = _P._adm-version < "ADM2":U.

/* Look for the start of the case statement */
CASE-BLOCK:
REPEAT:
  _inp_line = "".
  IMPORT STREAM _P_QS _inp_line. {&debug}
  /* It is actually OK to get the "END PROCEDURE." if we never have read
     in anything.  If there are no SmartObjects in the procedure, then
     adm-create-objects will be empty. */
  IF {&ERROR-CONDITION} THEN DO:
     RETURN.
  END.

  /* Look for the start of the CASE statement */
  IF _inp_line[1] eq "CASE" and (_inp_line[2] eq "adm-current-page:" OR
                                 _inp_line[2] eq "currentPage:")
  THEN DO:
    RUN process-pages.
    IF RETURN-VALUE eq "Error":U THEN RETURN.
    IF OCX-Tab-Info NE ? THEN RUN process-ocx-tabs.
    LEAVE CASE-BLOCK.
  END.
  ELSE IF _inp_line[1] eq "IF":U AND
           (_inp_line[2] eq "adm-current-page":U OR
            _inp_line[2] eq "currentPage:") AND
          _inp_line[4] eq "0":U THEN 
    LEAVE CASE-BLOCK.
END. /* CASE-BLOCK: repeat... */  

/* Keep reading until the "END PROCEDURE" line, because this is where the 
   intial page might be. */   
READ-TO-END:
REPEAT:
  _inp_line = "".
  IMPORT STREAM _P_QS _inp_line. {&debug}
  /* The Error condition  IS the end condition*/
  IF (_inp_line[1] eq "END" AND _inp_line[2] eq "PROCEDURE." AND 
      _inp_line[3] eq "") THEN LEAVE READ-TO-END.
  
  ELSE IF _inp_line[1] eq "THEN":U AND _inp_line[2] eq "run":U 
                                   AND (_inp_line[3] eq "select-page":U OR
                                        _inp_line[3] eq "selectPage":U) 
  THEN DO:
    ASSIGN _P._page-select = INTEGER(_inp_line[7]) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
      RUN error-msg ("Could not parse selection for startup page.") . 
      _P._page-select = 0.
    END.
  END.
  
END. /* READ-TO-END: REPEAT: */  

 
/* Now that everything has been read-in, convert the temporary links records 
   into permanent ones. */
FOR EACH tt-link BREAK BY src:
  IF FIRST-OF (src) THEN DO:
    /* Determine the SOURCE (which can be THIS-PROCEDURE).  We do this
       once for each source instead of doing it for each record individually. */
    IF tt-link.src eq "THIS-PROCEDURE"
    THEN cr-source = STRING(RECID(_P)).
    ELSE DO:
      FIND _NAME-REC WHERE _NAME-REC._wNAME eq tt-link.src.
      cr-source = STRING(_NAME-REC._wRECID).           
    END.
  END. /* IF FIRST-OF... */
  
  /* Create the link record. */
  CREATE _admlinks.
  ASSIGN _admlinks._P-recid     = RECID(_P)
         _admlinks._link-source = cr-source
         _admlinks._link-type   = tt-link.typ 
         .
    
  /* Determine the TARGET (which can be THIS-PROCEDURE) */
  IF tt-link.dst eq "THIS-PROCEDURE"
  THEN _admlinks._link-dest = STRING(RECID(_P)).
  ELSE DO:
    FIND _NAME-REC WHERE _NAME-REC._wNAME eq tt-link.dst.
   _admlinks._link-dest = STRING(_NAME-REC._wRECID).           
  END.
END. /* FOR EACH tt-link... */

/* 
From 9.1A we realize the SmartObjects AFTER the links has been created 
because initializeObject shall be able to find links also at design time.
hRealizeSmart is started when the first SO is found in process-pages
*/        
IF VALID-HANDLE(hRealizeSmart) THEN
DO:
  /* If -E return to European format */
  SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
  FOR EACH _U WHERE _U._WINDOW-HANDLE =  _P._WINDOW-HANDLE
              AND   _U._TYPE          = "SmartObject":U
              /* sort datasources first. since some design time objects benefit 
                 from datasource info at design startup (dynbrowser, dynfilter),
                 (currently keeping the old name sort as second sort
                  just in case someone has changed names for design time 
                  behavior........) */
              BY IF _U._subtype = 'SmartDataObject':U 
                 OR _U._subtype = 'SmartBusinessObject':U 
                THEN '':U 
                ELSE _U._Name : /* keep the name sort */ 
    RUN initializeSMO IN hRealizeSmart(RECID(_U)).
    /* visualize the folder correctly */
    IF _U._subtype = "SmartFolder":U 
    AND _p._page-current > 0 THEN 
    DO:
      FIND _S  WHERE RECID(_S) = _U._x-recid NO-ERROR.
      IF AVAIL _S AND VALID-HANDLE(_S._handle) THEN
        RUN showCurrentPage IN _S._handle (_P._page-current) NO-ERROR. 
    END.
  END.
  DELETE PROCEDURE hRealizeSmart.
  SESSION:NUMERIC-FORMAT = "AMERICAN":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-determineTabPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE determineTabPosition Procedure 
PROCEDURE determineTabPosition :
/*------------------------------------------------------------------------------
  Purpose:     Set the Tab-Oder of a new object
  Parameters:  pURecid      - Recid of object needing a tab position
               pAnchorRecid - Recid of object it is anchored to<none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pURecid      AS RECID      NO-UNDO.
  DEFINE INPUT  PARAMETER pAnchorRecid AS RECID      NO-UNDO.
  
  DEFINE VARIABLE iPage     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE this-tab  AS INTEGER    NO-UNDO.
    
  DEFINE BUFFER t_U      FOR _U.
  DEFINE BUFFER anchor_U FOR _U.
  DEFINE BUFFER t_S      FOR _S.

  FIND t_U WHERE RECID(t_U) = pURecid.
  FIND t_S WHERE RECID(t_S) = t_U._x-recid NO-ERROR.

  IF AVAILABLE t_S THEN iPage = t_S._page-number.
  ELSE iPage = 0.

  /* IF this was aready established on a previous page.  Note: the pages are
     processed in order and page 0 is repeated for each page case */
  IF iPage = 0 AND t_U._TAB-ORDER > 0 THEN RETURN.

  FIND anchor_U WHERE RECID(anchor_U) = pAnchorRecid.

  this-tab = anchor_U._TAB-ORDER + IF move-method = "AFTER":U THEN 1 ELSE 0.
  BackWard-Search:
  FOR EACH anchor_U WHERE anchor_U._PARENT-RECID = t_U._PARENT-RECID AND
                          anchor_U._TAB-ORDER >= this-tab
            BY anchor_U._TAB-ORDER DESCENDING:
    FIND t_S WHERE RECID(t_S) = anchor_U._x-recid NO-ERROR.
    IF ((AVAILABLE t_S AND t_S._page-number NE iPage) OR
        (NOT AVAILABLE t_S AND iPage NE 0)) AND move-method = "AFTER":U THEN DO:
      this-tab = anchor_U._TAB-ORDER + 1.
      LEAVE BackWard-Search.
    END.
     anchor_U._TAB-ORDER = anchor_U._TAB-ORDER + 1.
  END.
  t_U._TAB-ORDER = this-tab.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-error-msg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE error-msg Procedure 
PROCEDURE error-msg :
/*------------------------------------------------------------------------------
  Purpose:     Report an error to the user 
  Parameters:  pMsg -- the message to report.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pMsg AS CHAR NO-UNDO.

  MESSAGE "SmartObjects could not be processed." {&SKP} pMsg + " ({&FILE-NAME})"
          VIEW-AS ALERT-BOX ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-process-ocx-tabs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-ocx-tabs Procedure 
PROCEDURE process-ocx-tabs :
/*------------------------------------------------------------------------------
  Purpose:     IF any OCX's exist that have their tab order anchored to
               a SMO, now is the time to insert the OCX's into the Tab
               Order.                 
               
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE move-method AS CHARACTER NO-UNDO.
  DEFINE VARIABLE this-tab    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE widget-name AS CHARACTER NO-UNDO.

  /* Now that all smart-objects are know, insert any OCX's into the tab order
     that are anchored to SMO's */
  IF OCX-Tab-Info NE ? THEN DO:
    DO i = 1 TO NUM-ENTRIES(OCX-Tab-Info,CHR(4)):
      /* First find move-method */
      move-method = ENTRY(3,ENTRY(i, OCX-Tab-Info, CHR(4))).
      /* If move-method is BEFORE then SMO is before OCX, else if it is AFTER then
         OCX comes before SMO - _U is the OCX anchor_U is the SMO     */
      FIND _U WHERE RECID(_U) = INTEGER(ENTRY(2, ENTRY(i, OCX-Tab-Info, CHR(4)))).
      widget-name = ENTRY(1, ENTRY(i, OCX-Tab-Info, CHR(4))).
      IF NUM-ENTRIES(widget-name,".":U) = 1 THEN
        FIND anchor_U WHERE anchor_U._NAME = widget-name
                        AND anchor_U._PARENT-RECID = _U._PARENT-RECID.
      ELSE IF NUM-ENTRIES(widget-name,".":U) = 2 THEN
        FIND anchor_U WHERE anchor_U._TABLE = ENTRY(1, widget-name, ".":U) AND
                            anchor_U._NAME  = ENTRY(2, widget-name, ".":U) AND
                            anchor_U._PARENT-RECID = _U._PARENT-RECID.
      ELSE IF NUM-ENTRIES(widget-name,".":U) = 3 THEN
        FIND anchor_U WHERE anchor_U._DBNAME = ENTRY(1, widget-name, ".":U) AND
                            anchor_U._TABLE  = ENTRY(2, widget-name, ".":U) AND
                            anchor_U._NAME   = ENTRY(3, widget-name, ".":U) AND
                            anchor_U._PARENT-RECID = _U._PARENT-RECID.
       
      /* Isert OCX relative to SMO */
      this-tab = anchor_U._TAB-ORDER + IF move-method = "BEFORE":U THEN 1 ELSE 0.
      FOR EACH anchor_U WHERE anchor_U._PARENT-RECID = _U._PARENT-RECID AND
                              anchor_U._TAB-ORDER >= this-tab
                     BY anchor_U._TAB-ORDER DESCENDING:
        anchor_U._TAB-ORDER = anchor_U._TAB-ORDER + 1.
      END.
      _U._TAB-ORDER = this-tab.
    END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-process-pages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-pages Procedure 
PROCEDURE process-pages :
/* -----------------------------------------------------------------
   process-pages
   
   Repeat the MAIN-REPEAT block for each page in the case statement.
   This will have only been called after the "CASE adm-current-page"
   was found.
   ----------------------------------------------------------------- */ 
  DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE page-no     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE var-name    AS CHAR      NO-UNDO.
  DEFINE VARIABLE cur-lo      AS CHAR      NO-UNDO.
  DEFINE VARIABLE this-tab    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE widget-name AS CHARACTER NO-UNDO.
  DEFINE VARIABLE icount      AS INTEGER   NO-UNDO.
  
  /* There are two ways that we deal with tab-order:  Implicit and Explicit  */
  /* For Implicit tab order we don't do anything to adjust the tab-order,    */
  /* except that we acknowledge the fact that the SMO's were written out in  */
  /* order of their tab orders so we must preserve that tab order so that we */
  /* can write the .w in the same sequence.  To do this, we build a comma    */
  /* delimited sequence of the recids of each SMO.  Then if no adjustTabOrder*/
  /* functions have not been found (indicating explicit tab ordering), we    */
  /* insert all of the SMO's before the widget in the window that is just    */
  /* after the first SMO (usually a folder).                                 */
  DEFINE VARIABLE anchor-rec   AS RECID                    NO-UNDO.
  DEFINE VARIABLE tabSequence  AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE implicitTabs AS LOGICAL INITIAL TRUE     NO-UNDO.
  DEFINE VARIABLE smoCol       AS DECIMAL INITIAL 99999.99 NO-UNDO.
  DEFINE VARIABLE smoRow       AS DECIMAL INITIAL 99999.99 NO-UNDO.


  MAIN-REPEAT:
  REPEAT:
    _inp_line = "".
    IMPORT STREAM _P_QS _inp_line. {&debug}
    /* Error condition */
    IF {&ERROR-CONDITION} THEN DO:
     RUN error-msg ("END PROCEDURE found while processing page" +
                    STRING(page-no) + ".").
     RETURN "Error":U.
    END.
    
    /* We stop processing when we reach the END CASE. */
    IF _inp_line[1] eq "END" and _inp_line[2] eq "CASE." THEN LEAVE MAIN-REPEAT.
    
    /* Look for a new page number.  If the page number is "?" then copy to the current page. */
    IF _inp_line[1] eq "WHEN" and _inp_line[3] eq "THEN" THEN DO:
      IF _inp_line[2] eq ? THEN page-no = _P._page-current.
      ELSE DO:
        ASSIGN page-no = INTEGER(_inp_line[2]) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
          RUN error-msg ("Could not interpret page number " + _inp_line[2] + ".") . 
          RETURN.     
        END.
       END.
     END.
      
    /* Look for all the next new object */
    IF _inp_line[1] eq "RUN" AND (_inp_line[2] eq "init-object" OR
       _inp_line[2] eq "constructObject") THEN DO:
      /* Reset variables. */
      ASSIGN var-name  = "":U
             file-name = "":U.
      
      /* First read in the objects's file name. */
      _inp_line = "".
      IMPORT STREAM _P_QS _inp_line. {&debug}
      IF _inp_line[1] eq "&IF" and _inp_line[2] eq "DEFINED(UIB_is_Running)"
      THEN DO:
        _inp_line = "".
         IMPORT STREAM _P_QS _inp_line. /* Skip over the &IF */
      END.
      IF _inp_line[1] eq "INPUT" THEN DO:
        /* Strip quotes off the file-name 'string'. Strip off DB-AWARE flag if there ENTRY(1,..,CHR(3)).
           Also, under Windows, change the directory slashes to backslashes. */
        file-name = _inp_line[2].
        /* If the next input element is not a comma, then the file name
           contains spaces. So process the name for spaces until we find
           a comma, then we can stop. -jep Bug fix 97-08-13-001. */
        IF NOT _inp_line[3] BEGINS ",":U THEN
        get-name-block:
        DO icount = 3 TO 100:
          IF _inp_line[icount] BEGINS ",":U THEN LEAVE get-name-block.
          file-name = file-name + " ":U + _inp_line[icount].
        END.
        /* File name may contain filenameCHR(3)DB-AWARE. We only want
           the file name. -jep */
        file-name = ENTRY(1, ENTRY(2, file-name, "'":U), CHR(3)).
        &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
        file-name = REPLACE(file-name, "/", "~\").
        &ENDIF
      END.
      ELSE DO:
        RUN error-msg ("Expected INPUT <file name> in " +
                       IF old-adm THEN "init-object." ELSE "constructObject.") . 
        RETURN.     
      END.
  
      /* The next two lines could be the Parameterized variable. */
      _inp_line = "".
      IMPORT STREAM _P_QS _inp_line. {&debug}
      IF _inp_line[1] eq "&ELSE" and _inp_line[2] eq ""
      THEN DO:
        _inp_line = "".
        IMPORT STREAM _P_QS _inp_line. /* Skip over the &ELSE */
        var-name = _inp_line[2]. 
        /* Skip over the next line and read one more. */
        _inp_line = "".
        IMPORT STREAM _P_QS _inp_line. /* Should be  &ENDIF*/
        _inp_line = "".
        IMPORT STREAM _P_QS _inp_line. {&debug}
      END.
      
      /* The next line should be the frame, or the window.  */
      IF _inp_line[1] ne "INPUT" THEN DO:
        RUN error-msg ("Expected INPUT <parent handle> in " +
                        IF old-adm THEN "init-object." ELSE "constructObject.") . 
        RETURN.     
      END.
      ELSE DO:
        IF _inp_line[2] eq "FRAME" THEN DO: 
          /* Get the frame name out of "name:HANDLE". This will be "?" if we
             are reading to the default frame.  */
          fr-name = ENTRY(1, _inp_line[3], ":":U) . 
          IF fr-name NE "?" THEN DO:
            FIND _NAME-REC WHERE _NAME-REC._wNAME eq fr-name
                           AND CAN-DO("DIALOG-BOX,FRAME", _NAME-REC._wTYPE) NO-ERROR.
          END.
          /* Find a valid frame. Otherwise use the default frame or window. */
          IF AVAILABLE _NAME-REC THEN FIND parent_U WHERE RECID(parent_U) = _NAME-REC._wRECID.
          ELSE IF VALID-HANDLE (_h_frame) THEN FIND parent_U WHERE parent_U._HANDLE = _h_frame.
          ELSE FIND parent_U WHERE parent_U._HANDLE eq _P._WINDOW-HANDLE.         
        END. 
        ELSE /* The window is the parent */
          FIND parent_U WHERE parent_U._HANDLE eq _P._WINDOW-HANDLE.

        /* At this point we can create the _U records -- the code read in is for the Master Layout. */
        cur-lo = "Master Layout":U.
        FIND parent_L WHERE parent_L._u-recid eq RECID(parent_U)
                        AND parent_L._LO-NAME eq cur-lo.
        
        /* Create a Universal Widget Record and populate it as much as possible. */
        CREATE _U.
        CREATE _S.
        CREATE _L.
        CREATE _NAME-REC.
        ASSIGN /* TYPE-specific settings */
             _U._TYPE          = "SmartObject"
              /* Set a default TYPE. Later, we will ask the object itself to
                 to override this value. */
             _U._SUBTYPE       = _U._TYPE 
             _U._x-recid       = RECID(_S)
             _S._file-name     = file-name
             _S._var-name      = var-name
             _S._page-number   = page-no
             /* SmartObject Handles are NEVER displayed or enabled */
             _U._ENABLE        = NO
             _U._DISPLAY       = NO
             /* Standard Settings for Universal and Field records */
             { adeuib/std_ul.i &SECTION = "DRAW-SETUP" }
             _NAME-REC._wTYPE  = _U._TYPE
             _NAME-REC._wRECID = RECID(_U)
             _NAME-REC._wFRAME = ?   /* names must be unique across frames */
             tabSequence = tabSequence + ",":U + STRING(ROWID(_U)).
      END.
  
      /* The next line(s) should be the settings. (of the form):
            INPUT 'variable = value
                   variable = value':U 
      */ 
      _inp_line = "".
      IMPORT STREAM _P_QS UNFORMATTED _inp_line[1]. {&debug}
      ASSIGN _inp_line[1] = TRIM(_inp_line[1])
             i = INDEX(_inp_line[1], "'").
      IF i eq 0 OR TRIM(ENTRY(1,_inp_line[1]," ")) eq "INPUT" 
      THEN DO:
        _inp_line[1] = SUBSTRING(_inp_line[1], i + 1, -1, "CHARACTER":U).
        RUN process-settings.
      END.
      ELSE DO:
        RUN error-msg ("Expected INPUT <settings> in " + 
                       IF old-adm THEN "init-object." ELSE "constructObject."). 
        RETURN.     
      END.
  
      /* The next line should be the variable name */ 
      _inp_line = "".
      IMPORT STREAM _P_QS _inp_line. {&debug}
      IF _inp_line[1] eq "OUTPUT":U THEN DO:
        _NAME-REC._wNAME  = _inp_line[2].
        VALIDATE _NAME-REC.
        /* Make sure the name doesn't exist already */
        RUN adeshar/_bstname.p (_NAME-REC._wNAME, ?, "", 0, _P._WINDOW-HANDLE, OUTPUT _U._NAME).
      END.
      ELSE DO:
        RUN error-msg ("Expected OUTPUT <object-name> in " +
                       IF old-adm THEN "init-object." ELSE "constructObject.") . 
        RETURN.     
      END.
  
      /* The next line could be the position information. If there
         is no position specified, then use 1,1.  */ 
      _inp_line = "".
      IMPORT STREAM _P_QS _inp_line. {&debug}
      IF _inp_line[1] eq "RUN" AND 
         (_inp_line[2] eq "set-position" OR _inp_line[2] eq "repositionObject") THEN DO:
        /* Get row and columns */
        ASSIGN _L._ROW = DECIMAL(_inp_line[6])
               _L._COL = DECIMAL(_inp_line[8]) NO-ERROR.
        IF ERROR-STATUS:ERROR 
        THEN RUN error-msg ("Could not parse position for SmartObject.") .
        ELSE IF _L._ROW <= smoRow THEN DO:
          ASSIGN smoRow = _L._ROW
                 smoCol = IF _L._COL < smoCOL THEN _L._COL ELSE smoCOL.
        END. 
      END.
      /* Objects without a UIB visualization still need a position in the UIB.
         The line is "/* Position in {&UIB_SHORT_NAME}: ( row , col ) */" -- don't worry if
         it can't be parsed. */
      ELSE IF _inp_line[2] eq "Position" AND (_inp_line[4] eq "{&UIB_SHORT_NAME}:"
                                           OR _inp_line[4] eq "UIB:") THEN DO:
        /* Get row and columns */
        ASSIGN _L._ROW = DECIMAL(_inp_line[6])
               _L._COL = DECIMAL(_inp_line[8]) NO-ERROR.
      END.
      
      /* The next line could be the size information (or END).  */ 
      _inp_line = "".
      IMPORT STREAM _P_QS _inp_line. {&debug}
      IF _inp_line[1] eq "RUN" AND
         (_inp_line[2] eq "set-size" OR _inp_line[2] eq "resizeObject") THEN DO:
        /* Get row and columns */
        ASSIGN _L._HEIGHT = DECIMAL(_inp_line[6])
               _L._WIDTH  = DECIMAL(_inp_line[8]) NO-ERROR.
        IF ERROR-STATUS:ERROR 
        THEN RUN error-msg ("Could not parse size for SmartObject.") . 
      END.
      /* Objects without a UIB visualization still need a position in the UIB.
         The line is "/* Size in UIB: ( row , col ) */" -- don't worry if
         it can't be parsed. */
      ELSE IF _inp_line[2] eq "Size" AND (_inp_line[4] eq "{&UIB_SHORT_NAME}:" OR
                                          _inp_line[4] eq "UIB:") THEN DO:
        /* Get row and columns */
        ASSIGN _L._HEIGHT = DECIMAL(_inp_line[6])
               _L._WIDTH  = DECIMAL(_inp_line[8]) NO-ERROR.
      END.
      /* Check the position if it was not set */
      IF (_L._ROW eq ?) OR (_L._ROW < 1.0) THEN _L._ROW = 1.0 .
      IF (_L._COL eq ?) OR (_L._COL < 1.0) THEN _L._COL = 1.0 .
      
      /* Create multiple layout records if necessary */
      {adeuib/crt_mult.i}
      
      /* Now get the _L for the current layout instead of the master layout */       
      FIND _L WHERE RECID(_L) = _U._lo-recid.
      
      IF NOT VALID-HANDLE(hRealizeSmart)  THEN 
        RUN adeuib/_realizesmart.p PERSISTENT SET hRealizeSmart.  
      
      RUN realizeSMO IN hRealizeSmart(RECID(_U),NO /* dont't intialize */).
    END. /* init-object */
    
    /* Look for link information.  The line is of the form:
       1   2        3  4              5 6           7 8           9 10          11
       RUN add-link IN adm-broker-hdl ( source-name , 'link-type':U , target-name ). 
     NOTE: At one point in early development we did not have the adm-broker-hdl.
           That line had the form: 
       1   2        3  4           5       6           7 8     9           10
       RUN add-link IN source-name (INPUT  'link-type' , INPUT target-name ).  */
    ELSE IF _inp_line[1] eq "RUN" AND
         (_inp_line[2] eq "add-link" OR _inp_line[2] eq "addLink") THEN DO:   
      /* Debug - MESSAGE "add-link" _inp_line[6] _inp_line[8] _inp_line[10]. */
  
      /* Store the link information in a temp-table until we have read in all
         the links.  Then we can search for the source and targets. */
      CREATE tt-link.    
      ASSIGN tt-link.src = _inp_line[IF old-adm THEN 6 ELSE 4]
             tt-link.typ = _inp_line[IF old-adm THEN 8 ELSE 6]
             tt-link.dst = _inp_line[IF old-adm THEN 10 ELSE 8].
      /* Strip quotes off the 'link-type':U */
      tt-link.typ = ENTRY (2, tt-link.typ, "'") .
  
    END. /* add-link */
    
    /* Look for tab order information.  The line is of the form:
       1   2                3  4              5 6        7
       RUN adjust-tab-order IN adm-broker-hdl ( smo-name ,  
       
       Next line is has anchor name and 'BEFORE' or 'AFTER'      */
    ELSE IF _inp_line[1] eq "RUN" AND
         (_inp_line[2] eq "adjust-tab-order":U OR _inp_line[2] eq "adjustTabOrder":U)
    THEN DO:
      implicitTabs = FALSE.
      /* Get the _U record of the SMO */
      FIND _NAME-REC WHERE _NAME-REC._wNAME eq _inp_line[IF old-adm THEN 6 ELSE 4].   
      FIND _U WHERE RECID(_U) = _NAME-REC._wRECID.
      
      /* Read the next line to get the anchor name and move-method */
      _inp_line = "".
      IMPORT STREAM _P_QS _inp_line. {&debug}

      /* See what we are dealing with:  Choices are a frame, a regular widget or
         another smo */
      IF _inp_line[1] = "FRAME":U THEN DO:  /* A Frame */
        FIND FIRST anchor_U WHERE anchor_U._WINDOW-HANDLE = _P._WINDOW-HANDLE AND
                                  anchor_U._NAME = ENTRY(1, _inp_line[2], ":":U) AND
                                  anchor_U._TYPE = "FRAME":U AND
                                  anchor_U._PARENT-RECID = _U._PARENT-RECID.
        IF _inp_line[3] = "IN":U AND _inp_line[4] = "FRAME":U THEN
          move-method = IF _inp_line[7] BEGINS "'BEFORE'":U 
                           THEN "BEFORE":U ELSE "AFTER":U.
        ELSE
          move-method = IF _inp_line[4] BEGINS "'BEFORE'":U
                           THEN "BEFORE":U ELSE "AFTER":U.
      END. /* A frame */

      ELSE IF NUM-ENTRIES(_inp_line[1], ":":U) = 2 THEN DO:  /* A Widget */
        widget-name = ENTRY(1, _inp_line[1], ":":U).
        IF NUM-ENTRIES(widget-name,".":U) = 1 THEN
          FIND FIRST anchor_U WHERE anchor_U._WINDOW-HANDLE = _P._WINDOW-HANDLE AND
                                    anchor_U._NAME = widget-name AND
                                    anchor_U._TYPE NE "FRAME":U AND
                                    anchor_U._PARENT-RECID = _U._PARENT-RECID.
        ELSE IF NUM-ENTRIES(widget-name,".":U) = 2 THEN
          FIND FIRST anchor_U WHERE anchor_U._WINDOW-HANDLE = _P._WINDOW-HANDLE AND
                                    anchor_U._TABLE = ENTRY(1, widget-name, ".":U) AND
                                    anchor_U._NAME  = ENTRY(2, widget-name, ".":U) AND
                                    anchor_U._TYPE NE "FRAME":U AND
                                    anchor_U._PARENT-RECID = _U._PARENT-RECID.
        ELSE IF NUM-ENTRIES(widget-name,".":U) = 3 THEN
          FIND FIRST anchor_U WHERE anchor_U._WINDOW-HANDLE = _P._WINDOW-HANDLE AND
                                    anchor_U._DBNAME = ENTRY(1, widget-name, ".":U) AND
                                    anchor_U._TABLE  = ENTRY(2, widget-name, ".":U) AND
                                    anchor_U._NAME   = ENTRY(3, widget-name, ".":U) AND
                                    anchor_U._TYPE NE "FRAME":U AND
                                    anchor_U._PARENT-RECID = _U._PARENT-RECID.
        IF _inp_line[2] = "IN":U AND _inp_line[3] = "FRAME":U THEN
          move-method = IF _inp_line[6] BEGINS "'BEFORE'":U 
                           THEN "BEFORE":U ELSE "AFTER":U.
        ELSE
          move-method = IF _inp_line[3] BEGINS "'BEFORE'":U
                           THEN "BEFORE":U ELSE "AFTER":U.
      END.
      ELSE DO:  /* Another smo */
        FIND _NAME-REC WHERE _NAME-REC._wNAME eq _inp_line[1].   
        FIND anchor_U WHERE RECID(anchor_U) = _NAME-REC._wRECID.
        move-method = IF _inp_line[3] BEGINS "'BEFORE'":U 
                         THEN "BEFORE":U ELSE "AFTER":U.
      END.  /* Another smo */
      IF AVAILABLE _U AND AVAILABLE anchor_U THEN DO:
        /* We're all set, lets adjust the tabs */
        IF _U._TAB-ORDER = 0 AND anchor_U._TAB-ORDER = 0 AND move-method = "AFTER":U THEN
          anchor_U._TAB-ORDER = 1.
        RUN determineTabPosition(INPUT RECID(_U), INPUT RECID(anchor_U)).
      END.  /* If we have both _U and an anchor_U */
    END.  /* Adjusting the tab order */   
  END. /* MAIN-REPEAT: REPEAT:... */
  
  IF implicitTabs THEN DO:
    ASSIGN tabSequence = LEFT-TRIM(tabSequence,",":U)
           icount      = NUM-ENTRIES(TabSequence)
           anchor-rec  = ?.
    IF icount > 0 THEN DO:  /* We have at least one SMO */
      FIND _U WHERE ROWID(_U) = TO-ROWID(ENTRY(1,tabSequence)).
      FIND-WIDGET-AFTER:
      FOR EACH anchor_U WHERE anchor_U._PARENT-RECID = _U._PARENT-RECID AND
                              anchor_U._TYPE NE "SmartObject":U
                            BY anchor_U._TAB-ORDER:
        FIND _L WHERE RECID(_L) = _U._lo-recid AND
                      _L._LO-NAME = "Master Layout".
        IF _L._ROW > smoROW OR 
          (_L._ROW = smoRow AND _L._COL > smoCOL) THEN DO:
          /* Have found the anchor */
          ASSIGN anchor-rec = RECID(anchor_U)
                 this-tab   = anchor_U._TAB-ORDER.
          LEAVE FIND-WIDGET-AFTER.
        END.
        this-tab = anchor_U._TAB-ORDER + 1.  /* This will be the last object (+1)
                                                if all are after the first SMO    */
      END.  /* Find-widget-after: FOR EACH */
      IF anchor-rec NE ? THEN DO:
        /* Move bottom stuff out in tab order */
        FOR EACH anchor_U WHERE anchor_U._PARENT-RECID = _U._PARENT-RECID AND
                                anchor_U._TAB-ORDER >= this-tab
                       BY anchor_U._TAB-ORDER DESCENDING:
          anchor_U._TAB-ORDER = anchor_U._TAB-ORDER + icount.
        END.  /* For each anchor: move then down */
      END.  /* We found an anchor */
      /* Now find the SMO's and set there TABs starting with this-tab */
      DO i = 1 TO icount:
        FIND _U WHERE ROWID(_U) = TO-ROWID(ENTRY(i,tabSequence)).
        ASSIGN _U._TAB-ORDER = this-tab
               this-tab      = this-tab + 1.
      END.  /* DO i = 1 to icount */
    END.  /* At least one SMO */       
  END.  /* If implicit tabs */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-process-settings) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-settings Procedure 
PROCEDURE process-settings :
/*------------------------------------------------------------------------------
  Purpose:     Continue reading the import stream to read in SmartObject
               Settings. The settings are of a form:
                  'attribute = value,
                   attribute = value,
                   attribute =':U + 'value' + ',
                   attribute = value':U ).
               We need to parse the input stream appending all the attributes
               together.  The easiest way to do this is to:
                 * remove all ':U + ' and ' + ' strings
                 
               
  Parameters:  <none>
  Notes:       This procedure assumes that:
                 _S points to the current SmartObject record
                 _inp_line[1] contains the start of these settings
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i-quote    AS INTEGER NO-UNDO.
  DEFINE VARIABLE i-start    AS INTEGER NO-UNDO.
  DEFINE VARIABLE i-tilde    AS INTEGER NO-UNDO.
  
  i-start = 1.
  
  Settings-Loop:
  REPEAT:
    /* Remove the plus signs. */
    _inp_line[1] = REPLACE (REPLACE (_inp_line[1], "':U + '":U, "":U),
                            "' + '":U, "":U).
 
    /* Find the next quote (that does not follow a tilde). This is the quote that
       ends the current string. */
    ASSIGN i-quote = INDEX (_inp_line[1], "'":U, i-start) 
           i-tilde = INDEX (_inp_line[1], "~~'":U, i-start).
    DO WHILE i-quote > 0 AND i-tilde > 0 AND i-quote eq i-tilde + 1:
      ASSIGN i-quote = INDEX (_inp_line[1], "'":U, i-quote + 1) 
             i-tilde = INDEX (_inp_line[1], "~~'":U, i-tilde + 1).
    END.

    /* Append the rest of the string to the settings. */
    _S._settings = _S._settings + 
                   (IF i-quote eq 0 
                    THEN SUBSTRING(_inp_line[1], i-start, -1, "CHARACTER":U) 
                         + CHR(10)
                    ELSE SUBSTRING(_inp_line[1], i-start, i-quote - 1, 
                                   "CHARACTER":U)).
    /* If there was a quote, then we are DONE. */
    IF i-quote ne 0 THEN DO:
      /* We prefaced all single-quotes in the settings with
         a tilda when we did the save.  So remove these. */
      _S._settings = REPLACE (_S._settings, "~~'":U, "'":U).
      LEAVE Settings-Loop.
    END.
    ELSE DO:
      /* Get the next line and continue processing. */
      IMPORT STREAM _P_QS UNFORMATTED _inp_line[1]. {&debug}
      ASSIGN _inp_line[1] = TRIM(_inp_line[1])
             i-start      = 1.
    END.
  END. /* Settings-Loop: REPEAT:... */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-realize-smo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE realize-smo Procedure 
PROCEDURE realize-smo :
/*------------------------------------------------------------------------------
  Purpose:     If there is a valid _U and _S record, and it hasn't been realized, 
               then recreate the widget  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Debugging:
   * MESSAGE "Realize" _U._NAME _L._ROW _L._COL _S._FILE-NAME _S._Settings. */
  IF AVAILABLE (_U) AND AVAILABLE (_S) AND NOT VALID-HANDLE (_S._HANDLE) THEN 
    RUN adeuib/_undsmar.p (RECID(_U)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

