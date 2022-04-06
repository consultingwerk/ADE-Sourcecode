/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_build.p
Author:       R. Ryan/F. Chang
Created:      4/94 
Updated:      4/96 DRH
		12/96 SLK OPSYS for Win95, TOOLTIP
		12/96 SLK added handling EXTENT for toggle-box(TB),
		combo-box(CB), radio-set(RS), selection-list(SE), 
		editor, slider(SL)
		03/97 SLK Removed FONT-TABLE:NUM-ENTRIES = 255
			Bug#97-03-06-079
		      SLK Properties dialog doesn't come up
			Bug#97-03-07-070
	              SLK Beeps when image or rectangle is selected.
			Since we now can attach tooltips and they can 
			are translatable, the images and rectangles
			should not beep.
	       05/99 TSM Added support for various Intl Numeric Formats
	              (in addition to American and European) by using session
	              set-numeric-format method to set the format back to the 
	              user's setting after setting it to American
Purpose:      Builds *.rc files 
Background:   This is one of the main routines in the Translation
              Manager.  _build.p is called by _res.w and, if successful,
              builds an .rc file for each procedure in the XL_Procedure
              table.
Notes:        This program has undergone continuous evolution from its
              inception as a consulting project at MARCAM in Atlanta.
              Originally, it was a method to visualize every frame in
              every procedure.  From there, it grew to what it is today:
              a facsimile of a real procedure, less logic/data/triggers
              and internal procedure.  The intent for an .rc file is to
              allow a translator to see what a translation will look 
              like in context.  Here's how it works:
              
                1. _res.w does something like this:
                   for each xl_procedure:
                      run adetran/pm/_build.p (arguments).
                    END.  
                    
                2. _build.p calls the 'analyzer' and creates an analyze
                  data file for input into _build.p.
                  
                3. _build.p then reads the analyzer output as input and
                   places this information into some temp-tables (for
                   frames and field-level widgets).  If there is no name
                   for a frame/widget, then _build.p ASSIGNs one.
                   
                4. After all the data has been read, the temp-tables are
                   joined together, then an .rc file is generated. Some
                   notes on how this works:
                   
                     - Text in frames/forms is turned into a fill-in widget
                       with a view-as text attribute.
                     - A window is created for the .rc file that is the size
                       of the largest frame in the original procedure.  If the
                       .rc file has several frames that overlap at different
                       x,y coordinates, then the window is the maximum of length
                       and width of the combination of frames.  
                     - Two run-time attributes are created for every widget:
                       object:selectable = TRUE and object:resizable = TRUE. 
                       Even though we don't allow the object to be resized, these
                       attributes give the translator the visual cue that the object
                       that is selected is being translated.
                     - A 'selection' trigger is constructed for every side-label so
                       that the side-label is equated with the corresponding fill-in,
                       combo-box, etc. widget.
                     - A 'choose' trigger is constructed for every menu-item which
                       brings up the properties window.  Note: this only applies to
                       children menu widgets - not the parent.
                     - A 'mouse-select-dblclick' trigger is constructed for the remaining
                       widgets which brings up the properties window. 
                     - A 'resize' trigger is constructed for every widget that might have
                       been resized (when resized, it rubber-bands back to its original
                       size).
                     - _build.p evaluates whether or not the project manager wants images
                       included in buttons/images.  If so, these images are loaded in
                       the main-block.
                                          
                5. If no analyze file is available -or- when an .rc file
                   can't be generated, _build.p returns a value of false
                   to the calling procedure (pm/_res.w) that no resource
                   file was generated.
Procedures:  As each line of analyzer input is read, it's type is evaluated and then
             an internal procedure for each type is read to pick up the remaining fields
             and populate the temp-table.  Once the temp-table is populated, 'BuildProcedure'
             is run.
                                                               
Includes:     pm/_build.i
Called by:    pm/_res.w 
PARAMETERs:   pResourceFile (input/char)   The full-path name of original procedure
              ProcedureFile (input/char)   Same as above
              uUseImages (input/char)      Flag for determining if images should be included
              tDispType (input/char)       Display type (G=Graphical, C=Character)
              FileCreate (output/logical)  Was a resource file generated?
*/


&SCOPED-DEFINE DefWinWidth  40
&SCOPED-DEFINE DefWinHeight 3

DEFINE INPUT  PARAMETER pResourceFile AS CHARACTER            NO-UNDO.
DEFINE INPUT  PARAMETER ProcedureFile AS CHARACTER            NO-UNDO.
DEFINE INPUT  PARAMETER tUseImages    AS CHARACTER            NO-UNDO.
DEFINE INPUT  PARAMETER tDispType     AS CHARACTER            NO-UNDO.
DEFINE OUTPUT PARAMETER FileCreated   AS LOGICAL              NO-UNDO.

DEFINE SHARED VARIABLE  _RCWarnings   AS LOGICAL              NO-UNDO.
DEFINE SHARED VARIABLE  hMain         AS HANDLE               NO-UNDO.    

DEFINE VARIABLE AnalyzeFile   AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE AlignFlds     AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE BtnImg        AS CHARACTER                    NO-UNDO.  
DEFINE VARIABLE CheckFile     AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE Cntr          AS INTEGER                      NO-UNDO.
DEFINE VARIABLE ColorsFonts   AS CHARACTER                    NO-UNDO.  
DEFINE VARIABLE CR            AS CHARACTER                    NO-UNDO. 
DEFINE VARIABLE CurFrame      AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE DataType      AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE EnableAll     AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE FirstField    AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE Flds          AS CHARACTER                    NO-UNDO. 
DEFINE VARIABLE FrameCnt      AS INTEGER                      NO-UNDO. 
DEFINE VARIABLE FrameTrigs    AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE i             AS INTEGER                      NO-UNDO.
DEFINE VARIABLE i-fill        AS INTEGER                      NO-UNDO.          
DEFINE VARIABLE INIFile       AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE InputLine     AS CHARACTER EXTENT 200         NO-UNDO.
DEFINE VARIABLE MaxHeight     AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE MaxWidth      AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE MenuName      AS CHARACTER                    NO-UNDO. 
DEFINE VARIABLE num-dec       AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE num-sep       AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE ObjectCnt     AS INTEGER                      NO-UNDO.
DEFINE VARIABLE opqry         AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE parname       AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE PopMenu       AS CHARACTER                    NO-UNDO.    
DEFINE VARIABLE ResourceFile  AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE tBadFile      AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE tCalPos       AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE tChar         AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE tDispFrm      AS CHARACTER EXTENT 20          NO-UNDO. 
DEFINE VARIABLE TextLiteral   AS INTEGER                      NO-UNDO.
DEFINE VARIABLE tformat       AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE tMenu         AS CHARACTER                    NO-UNDO. 
DEFINE VARIABLE tMenuBar      AS CHARACTER FORMAT "X(11)"     NO-UNDO.
DEFINE VARIABLE tSameName     AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE tscreen       AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE ttmpen        AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE ttmpfntclr    AS CHARACTER                    NO-UNDO.    
DEFINE VARIABLE ttmpqry       AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE ttmpsiz       AS CHARACTER                    NO-UNDO.    
DEFINE VARIABLE ttmptbl       AS CHARACTER                    NO-UNDO. 
DEFINE VARIABLE twidth        AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE tWidthSav     AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE txt           AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE xAdjust       AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE yAdjust       AS DECIMAL                      NO-UNDO.

DEFINE VARIABLE frameIsEmpty  AS LOGICAL                      NO-UNDO.

&IF LOOKUP("{&OPSYS}","MSDOS,WIN32":U) > 0 &THEN
    &SCOPED-DEFINE SLASH ~~~\
&ELSE
    &SCOPED-DEFINE SLASH /
&ENDIF

ASSIGN CR            = chr(10)
       i             = R-INDEX(pResourceFile,".":U).
IF i > 1 THEN ASSIGN pResourceFile = SUBSTRING(pResourceFile, 1, i - 1, "CHARACTER":U).
                           
ASSIGN AnalyzeFile   = pResourceFile + ".a":U
       ResourceFile  = pResourceFile + ".rc":U
       num-dec       = SESSION:NUMERIC-DECIMAL-POINT
       num-sep       = SESSION:NUMERIC-SEPARATOR
       SESSION:NUMERIC-FORMAT = "AMERICAN":U.

/* Include file contains temp table definitions */
{adetran/pm/_build.i}
DEFINE BUFFER b_tpfield FOR _tpfield.
DEFINE BUFFER _xtpf     FOR _tpfield.

/* Start the analyzer.  This output from the analyzer becomes the input
   to the resource procedure.  The resultant procedure is the resource file  */
IF _RCWarnings THEN
  ANALYZE VALUE(ProcedureFile) "dummy.p" OUTPUT VALUE(AnalyzeFile) ALL NO-ERROR.
ELSE
  ANALYZE VALUE(ProcedureFile) "dummy.p" OUTPUT VALUE(AnalyzeFile) ALL.


FILE-INFO:filename = AnalyzeFile.
IF FILE-INFO:full-pathname = ? THEN RETURN.

/* Start Reading the analyzer output as input; output to temp file  */                  
ASSIGN tBadFile  = FALSE
       tCalPos   = FALSE
       tWidthSav = 0.

INPUT FROM VALUE(AnalyzeFile).
ReadAnalyzerFile: 
DO WHILE TRUE:
  IMPORT InputLine[1] NO-ERROR.
      
  IF ERROR-STATUS:ERROR THEN LEAVE ReadAnalyzerFile.
  IF InputLine[1] BEGINS "_ANALYZER_BEGIN":U THEN
  AnalyzerLoop:
  REPEAT ON END-KEY UNDO AnalyzerLoop, LEAVE AnalyzerLoop:
    InputLine = "".
    IMPORT InputLine.
    Cntr = Cntr + 1.
    IF LOOKUP(InputLine[1],"BU,CB,ED,IM,RC,RS,SE,SL,TB,VT":U) > 0 AND
       CAN-FIND(FIRST _tpfield WHERE _tpfield._widget = InputLine[2] AND
                                     _tpfield._type NE InputLine[1]) THEN
        InputLine[2] = InputLine[2] + STRING(CNTR).
        
    CASE InputLine[1]:
      WHEN "BT":U THEN RUN ReadBkgrndLiteral.
      WHEN "BE":U THEN RUN ReadBkgrndExpr.
      WHEN "BK":U THEN RUN ReadBkgrndSKIP.
      WHEN "BP":U THEN RUN ReadBkgrndSpace.
      WHEN "BR":U THEN RUN ReadBkgrndRectangle.
      WHEN "BI":U THEN RUN ReadBkgrndImage.
      WHEN "BW":U THEN RUN ReadBrowser.
      WHEN "BC":U THEN RUN ReadBrwCol.
      WHEN "BU":U THEN RUN ReadButton.
      WHEN "CB":U THEN RUN ReadComboBox.
      WHEN "ED":U THEN RUN ReadEditor.
      WHEN "FF":U THEN RUN ReadFillin.
      WHEN "FR":U THEN RUN ReadFrame.
      WHEN "HT":U THEN RUN ReadHeaderLiteral.
      WHEN "HE":U THEN RUN ReadHeaderExpr.
      WHEN "HK":U THEN RUN ReadHeaderSKIP.
      WHEN "HP":U THEN RUN ReadHeaderSpace.
      WHEN "IM":U THEN DO: 
          IF tDispType <> "c":U THEN RUN ReadImage.
      END.
      WHEN "LI":U THEN RUN ReadLiteral.
      WHEN "MC":U THEN RUN ReadMenuCascade.
      WHEN "MI":U THEN RUN ReadMenuItem.
      WHEN "ML":U or WHEN "MS":U THEN RUN ReadMenuStatic.
      WHEN "MU":U THEN RUN ReadSubMenu.
      WHEN "MR":U THEN RUN ReadOnlyMenu.
      WHEN "RC":U THEN RUN ReadRectangle.
      WHEN "RS":U THEN RUN ReadRadioSet.
      WHEN "SE":U THEN RUN ReadSelectionList.
      WHEN "SL":U THEN RUN ReadSlider.
      WHEN "TB":U THEN RUN ReadToggleBox.
      WHEN "VT":U THEN RUN ReadVariableText.
    END CASE.
  END.       
END.
INPUT CLOSE.                 

OS-DELETE VALUE(AnalyzeFile).
OS-DELETE VALUE("dummy.p":U).  

IF tBadFile THEN FileCreated = FALSE. 
            ELSE RUN BuildProcedure.      
   

/* End of main code block ....   */
SESSION:SET-NUMERIC-FORMAT(num-sep, num-dec).
RETURN.


/* ****************************************************************************
                        Internal Procedures 
   **************************************************************************** */
PROCEDURE BuildProcedure:
  DEFINE VARIABLE browse-lines  AS INTEGER                       NO-UNDO.
  DEFINE VARIABLE col-pos       AS DECIMAL                       NO-UNDO.
  DEFINE VARIABLE fld-data-type AS CHARACTER                     NO-UNDO.
  DEFINE VARIABLE frame-bytes   AS INTEGER                       NO-UNDO.  
  DEFINE VARIABLE frame-lines   AS INTEGER                       NO-UNDO.
  DEFINE VARIABLE i             AS INTEGER                       NO-UNDO.
  DEFINE VARIABLE label-width   AS DECIMAL                       NO-UNDO.
  DEFINE VARIABLE Period-put    AS LOGICAL                       NO-UNDO.

  OUTPUT TO VALUE(ResourceFile).

  PUT UNFORMATTED
    '/* ':U ResourceFile ' generated for TRANMAN II on ':U today
                              ' at ':U STRING(time,"hh:mm":U) ' */':U SKIP(1)
    'DEFINE SHARED VARIABLE hMain      AS HANDLE        NO-UNDO.':U SKIP
    'DEFINE SHARED VARIABLE hProps     AS HANDLE        NO-UNDO.':U SKIP
    'DEFINE SHARED VARIABLE MainWindow AS WIDGET-HANDLE NO-UNDO.':U SKIP
    'DEFINE SHARED VARIABLE CurWin     AS WIDGET-HANDLE NO-UNDO.':U SKIP
    'DEFINE SHARED VARIABLE CurObj     AS WIDGET-HANDLE NO-UNDO.':U SKIP
    'DEFINE SHARED VARIABLE pFileName  AS CHARACTER     NO-UNDO.':U SKIP
    'DEFINE SHARED VARIABLE tDispType  AS CHARACTER     NO-UNDO.':U SKIP
    'DEFINE        VARIABLE TranWindow AS WIDGET-HANDLE NO-UNDO.':U SKIP
    'DEFINE        VARIABLE TM_lResult AS LOGICAL       NO-UNDO.':U SKIP (1)
    '/* Objects and Frames ... */':U    SKIP.

  /* MenuBar and PopUpMenu */
  IF (MenuName <> "":U) OR (PopMenu <> "":U) THEN DO:

    /* Bug# 97-09-15-005 Two Menubars are redefined in a rc file 
     * Given the analyzer output, we can not tell which MU records are MENU
     * types vs. SUB-MENU types unless we check to see the MU record
     * is defined as a SUB-MENU within another MU record 
     * 
     * "MU" "mybar2" "trans\r-menu.p"
     * ? ? 7 ? ? ? "y" "n" 
     * "MC" "" ""
     * "File2" ? "n" "myfile2" 
     * "MU" "mybar" "trans\r-menu.p"
     * ? ? 7 ? ? ? "y" "n" 
     * "MI" "" ""
     * "Cancel" ? "c1" "n" "n" ? ? 
     * "MU" "myfile2" "trans\r-menu.p"
     * ? ? 7 ? ? ? "n" "n" 
     * "MI" "" ""
     * "Delete" ? "e1" "n" "n" ? ? 
     *
     * In the above analyzer output is from a .p file
     *   DEFINE SUB-MENU myfile2
     *      MENU-ITEM e1 LABEL "Delete".
     *   DEFINE MENU mybar2 MENUBAR
     *      SUB-MENU myfile2 LABEL "File2"
     *   DEFINE MENU mybar  MENUBAR
     *      MENU-ITEM c1 LABEL "Cancel".
     *
     * Bug# 97-05-07-001 Vistrans ignores window menu popups 
     * Given the analyzer output, we are assuming that if you can not find
     * the related widget, we will try to attach to the window if it ends
     * with -WIN
     */
    FOR EACH _tpfield WHERE _tpfield._type = "MU":U 
                        AND _tpfield._format = "SUB-MENU":U
                      NO-LOCK
                      BY _tpfield._seq-num DESCENDING:
        FIND FIRST b_tpfield WHERE b_tpfield._seq-num <> _tpfield._seq-num
                               AND b_tpfield._widget = _tpfield._widget
        NO-ERROR.
        IF NOT AVAILABLE b_tpfield THEN
        ASSIGN _tpfield._format = "MENU":U
               _tpfield._name   = "MENUBAR":U. 
    END. /* each _tpfield */
    

    FOR EACH _tpfield WHERE _tpfield._type = "MU":U NO-LOCK
                      BY _tpfield._seq-num DESCENDING:
      PUT UNFORMATTED 'DEFINE ':U + CAPS(_tpfield._format)  + " ":U +
                      CAPS(_tpfield._widget) + " ":U + _tpfield._name.

      Create-Items:
      FOR EACH _xtpf WHERE CAN-DO("MU,MC,MI,ML":U,_xtpf._type) AND
                           _xtpf._seq-num > _tpfield._seq-num  NO-LOCK
                     BY _xtpf._seq-num.
        CASE _xtpf._type:
          WHEN "MU":U THEN LEAVE Create-Items.             
          WHEN "MC":U THEN PUT UNFORMATTED CR + '   ':U + CAPS(_xtpf._format) +
                               ' ':U + CAPS(_xtpf._widget) + '    ':U + 'LABEL ':U +
                               '"':U + _xtpf._label + '"':U.
          WHEN "MI":U THEN PUT UNFORMATTED CR + '   ':U + CAPS(_xtpf._format) +
                               ' ':U + CAPS(_xtpf._widget) + '     ':U +
                               'LABEL ':U + '"':U + _xtpf._label + '"':U.
          WHEN "ML":U THEN PUT UNFORMATTED CR + '    RULE':U.
        END CASE.
      END. /* For each MU, MC, MI or ML of _tpfield -- Create-Items */

      PUT UNFORMATTED '.':U + CR + CR.
    END. /* FOR EACH */
  END.  /* There is a menuBar or a popup menu */


  /* Browser */                      
  FOR EACH _tpbrw BY _tpbrw._fldseq:
    browse-lines = 0.
    Column-Loop: 
    FOR EACH _tpbrwfld WHERE _tpbrwfld._brwname = _tpbrw._brwname
             BREAK BY _tpbrwfld._brwname:      
      FIND _tpfield WHERE _tpfield._seq-num = _tpbrwfld._fldseq NO-ERROR.
      IF NOT AVAILABLE _tpfield THEN NEXT.
                                      
      IF FIRST-OF(_tpbrwfld._brwname) THEN DO:  /* First field of _tbbrw */ 
        ASSIGN ttmptbl = 'DEFINE TEMP-TABLE ':U + _tpbrw._brwname + 
                         STRING(_tpbrw._fldseq) + CR                 
               ttmpqry = 'DEFINE QUERY ':U +  _tpbrw._brwname + ' FOR ':U + 
                         _tpbrw._brwname + STRING(_tpbrw._fldseq) +
                         ' SCROLLING.':U + CR + CR +
                         'DEFINE BROWSE ':U + _tpbrw._brwname +
                         ' QUERY ':U + _tpbrw._brwname + ' NO-LOCK':U + CR +
                         '  DISPLAY ':U + CR
               ttmpen  = '  ENABLE ':U + _tpbrwfld._brwfld +
                         STRING(_tpbrwfld._fldseq) + CR
               ttmpsiz = ' SIZE ':U + STRING(_tpbrw._brww) +  ' BY ':U + 
                         STRING(MAXIMUM(3,_tpbrw._brwh)). 
      END.  /* If first field of  _tbbrw */

      CASE _tpfield._data-type:
          WHEN  1 THEN fld-data-type = "CHARACTER":U.
          WHEN  2 THEN fld-data-type = "DATE":U.
          WHEN  3 THEN fld-data-type = "LOGICAL":U.
          WHEN  4 THEN fld-data-type = "INTEGER":U.
          WHEN  5 THEN fld-data-type = "DECIMAL":U.
          WHEN 34 THEN fld-data-type = "DATETIME":U.
          WHEN 40 THEN fld-data-type = "DATETIME-TZ":U.
             OTHERWISE fld-data-type = "CHARACTER":U.
      END CASE.

      ASSIGN browse-lines = browse-lines + 1
             ttmptbl = ttmptbl + '  FIELD ':U + _tpbrwfld._brwfld +
                       STRING(_tpbrwfld._fldseq) + ' AS ':U +
                       fld-data-type +
                       ' FORMAT "':U + _tpfield._format +
                       '" COLUMN-LABEL "':U + _tpfield._label + '"':U +
                       (IF LAST-OF(_tpbrwfld._brwname) OR browse-lines = 40
                       THEN '.':U + CR + CR ELSE CR)
             ttmpqry = ttmpqry + '     ':U + _tpbrwfld._brwfld +
                                 STRING(_tpbrwfld._fldseq) + CR.

      IF LAST-OF(_tpbrwfld._brwname) OR browse-lines = 40 THEN DO:
        /* Find _tpfield of browse itself */
        FIND _tpfield WHERE _tpfield._seq-num = _tpbrw._fldseq NO-ERROR.
        IF AVAILABLE _tpfield THEN
        ASSIGN ttmpfntclr = IF tDispType = "c":U THEN
                              ' FONT 2 BGCOLOR 7 FGCOLOR 14':U
                            ELSE /* GUI */
                              ((IF _tpfield._fgcolor <> ? THEN
                                  ' FGCOLOR ':U + STRING(_tpfield._fgcolor) ELSE '':U) +
                               (IF _tpfield._bgcolor <> ? THEN
                                  ' BGCOLOR ':U + STRING(_tpfield._bgcolor) ELSE '':U) +
                               (IF _tpfield._font <> ? THEN
                                  ' FONT ':U + STRING(_tpfield._font) ELSE '':U)).
        ASSIGN ttmpfntclr = ttmpfntclr + 
          (IF _tpfield._fld-title <> "":U AND _tpfield._fld-title <> ? THEN
             ' TITLE "':U + _tpfield._fld-title + '" ':U
           ELSE
             '':U).
        ASSIGN ttmpqry = ttmpqry + ttmpen + '    WITH':U + ttmpfntclr + 
			ttmpsiz  .
        IF tDispType <> "c":U THEN
	ASSIGN ttmpqry = ttmpqry  +
                        (IF _tpfield._tooltip <> '':U AND _tpfield._tooltip <> ? THEN
                        ' TOOLTIP "':U + _tpfield._tooltip + '"':U ELSE '':U).
        ASSIGN ttmpqry = ttmpqry + '.':U + CR + CR.
      END.  /* If have done the last browse column */
      IF browse-lines = 40 THEN LEAVE Column-Loop.
    END.  /* FOR EACH browse field */

    IF CAN-FIND(FIRST _tpbrwfld WHERE _tpbrwfld._brwname = _tpbrw._brwname) THEN
      opqry = opqry + '  OPEN QUERY ':U + _tpbrw._brwname + ' FOR EACH ':U +
                _tpbrw._brwname + STRING(_tpbrw._fldseq) + ' NO-LOCK.':U + CR.

    PUT UNFORMATTED ttmptbl ttmpqry.
  END. /* FOR EACH browser */


  /* PUT OUT VARIABLE DEFINITIONS: Make sure not to put out the same one twice  */
  /*                               because it may occur in more than one frame. */
  FrameCnt   = 0.

  Definition-Loop:
  FOR EACH _frame, EACH _tpfield WHERE _frame._frame = _tpfield._frame 
         BREAK BY _frame._frame:

    IF FIRST-OF(_frame._frame) THEN
      ASSIGN FrameCnt             = FrameCnt + 1
             ObjectCnt            = 1
             tDispFrm[FrameCnt]   = '  DISPLAY ':U.

    CASE _tpfield._data-type:
        WHEN  1 THEN fld-data-type = "CHARACTER":U.
        WHEN  2 THEN fld-data-type = "DATE":U.
        WHEN  3 THEN fld-data-type = "LOGICAL":U.
        WHEN  4 THEN fld-data-type = "INTEGER":U.
        WHEN  5 THEN fld-data-type = "DECIMAL":U.
        WHEN 34 THEN fld-data-type = "DATETIME":U.
        WHEN 40 THEN fld-data-type = "DATETIME-TZ":U.
           OTHERWISE fld-data-type = "CHARACTER":U.
    END CASE.

    ASSIGN DataType            = fld-data-type
           ColorsFonts         = IF tDispType = "c":U AND 
				    _tpfield._type = "RC":U THEN
                                   ' BGCOLOR 7 FGCOLOR 14':U
                                 ELSE IF tDispType = "c":U THEN
                                   ' FONT 2 BGCOLOR 7 FGCOLOR 14':U
                                 ELSE /* GUI */
                                 ((IF _tpfield._fgcolor <> ? THEN
                                     ' FGCOLOR ':U + STRING(_tpfield._fgcolor) ELSE '') +
                                  (IF _tpfield._bgcolor <> ? THEN
                                     ' BGCOLOR ':U + STRING(_tpfield._bgcolor) ELSE '') +
                                  (IF _tpfield._font <> ? THEN
                                     ' FONT ':U + STRING(_tpfield._font) ELSE '')).
    
    /* Determine if an object is used in multiple frames */
    tSameName = FALSE.                 
    IF CAN-FIND(FIRST b_tpfield WHERE b_tpfield._widget = _tpfield._widget AND
                      b_tpfield._seq-num  <> _tpfield._seq-num AND 
                      b_tpfield._frame < _tpfield._frame)
      THEN tSameName = TRUE.
    IF NOT tSameName AND CAN-FIND(FIRST b_tpfield
                         WHERE b_tpfield._widget = _tpfield._widget AND
                               (b_tpfield._table <> _tpfield._table OR
                                b_tpfield._format <> _tpfield._format)) THEN
      ASSIGN _tpfield._widget = (IF _tpfield._table NE ? THEN _tpfield._table
                                                         ELSE "tbl":U) + "-":U
                                + _tpfield._widget + STRING(_tpfield._seq-num).

    /* Now that the name has been doctored save FirstField if not already done */
    IF (FirstField = "") AND LOOKUP(_tpfield._type,"BW,BC,IM,RC,LI":U) = 0
      THEN FirstField = _tpfield._widget. 

    IF tDispType = "c":U AND CAN-DO("BU,FF,CB,TB":U,_tpfield._type) THEN DO:
      ASSIGN tWidth = _tpfield._width.
      RUN DispFlds(INPUT _tpfield._type,
                   INPUT _tpfield._label,
                   INPUT _tpfield._initial,
                   INPUT-OUTPUT twidth,
                   OUTPUT tFormat,
                   OUTPUT tScreen).
    END.  /* If need to do character representation */

    CASE _tpfield._type:
      WHEN "BU":U THEN DO:   /* Buttons */ 
        IF tDispType = "c":U THEN DO:                           
          ASSIGN tDispFrm[FrameCnt] = tDispFrm[FrameCnt] + _tpfield._widget +
                                      IF ObjectCnt MOD 5 = 0
                                      THEN CR + '          ':U ELSE " ":U
                 ObjectCnt          = ObjectCnt + 1.
          IF NOT tSameName THEN
            ASSIGN Flds = 'DEFINE VARIABLE ':U +  _tpfield._widget + 
                          ' AS CHARACTER FORMAT "':U + tformat + '"':U + CR +
                          '  INITIAL "':U +  tscreen + '" VIEW-AS TEXT ':U + CR +
                          '  SIZE ':U + STRING(twidth) + ' BY ':U + 
                          STRING(_tpfield._height) + CR + '  FONT 2 NO-UNDO.':U.                         
        END. /* If character mode */
        ELSE DO: /* GUI */
          IF NOT tSameName THEN DO:
            ASSIGN Flds = 'DEFINE BUTTON ':U + _tpfield._widget + CR + 
                          '  SIZE ':U + STRING(_tpfield._width) + ' BY ':U + 
                          STRING(_tpfield._height) + CR +
                          (IF _tpfield._tooltip <> '':U AND _tpfield._tooltip <> ? THEN 
                           ' TOOLTIP "':U + _tpfield._tooltip + '"':U ELSE '':U) + 
                          '  LABEL "':U + _tpfield._label + '"':U + 
                          (IF ColorsFonts <> '':U THEN CR + ' ':U +
                           ColorsFonts ELSE '':U) + '.':U.
                                
            IF (_tpfield._image-up <> ?) and (tUseImages begins "y":U)  THEN
              BtnImg = BtnImg + '  TM_lResult = ':U + _tpfield._widget +
                                ':LOAD-IMAGE-UP("':U + _tpfield._image-up + 
                                '") NO-ERROR.':U + CR.
          END.  /* IF NOT tSameName */
        END.  /* ELSE GUI */
        IF NOT tSameName THEN PUT UNFORMATTED Flds SKIP(1).
      END.  /* CASE Button (BU) */
  
      WHEN "IM":U THEN DO:  /* Images */
        IF NOT tSameName THEN DO:
          Flds = 'DEFINE IMAGE ':U + _tpfield._widget + CR + 
                 (IF _tpfield._image-up <> ? and  tUseImages begins "y":U THEN 
                 '  FILE "':U + _tpfield._image-up + '"':U + CR ELSE '':U) + 
                 '  SIZE ':U + STRING(_tpfield._width) + ' BY ':U + STRING(_tpfield._height). 
          IF tDispType <> "c":U THEN
		Flds = Flds + 
                          (IF _tpfield._tooltip <> '':U AND _tpfield._tooltip <> ? THEN 
                           ' TOOLTIP "':U + _tpfield._tooltip + '"':U ELSE '':U).
	  Flds = Flds + (IF ColorsFonts <> '':U THEN CR + ' ':U + ColorsFonts ELSE '':U) + '.':U.          
          IF tDispType <> "c":U THEN PUT UNFORMATTED Flds SKIP(1).
        END.  /* IF not tsameName */
      END.  /* Images */
    
      WHEN "LI":U THEN DO:  /* Literal Text */
        IF tDispType = "c":U THEN DO:
          ASSIGN tDispFrm[FrameCnt] = tDispFrm[FrameCnt] + _tpfield._widget +
                                      IF ObjectCnt MOD 5 = 0
                                      THEN CR + '          ':U ELSE " ":U
                 ObjectCnt          = ObjectCnt + 1.
          IF NOT tSameName THEN 
            Flds = 'DEFINE VARIABLE ':U + _tpfield._widget + 
                   ' AS CHARACTER FORMAT ':U + '"':U + 'X(':U +
                   STRING(LENGTH(_tpfield._label)) + ')"':U + CR + 
                   '  INITIAL "':U + REPLACE(_tpfield._label, '"':U, '~~~"':U) + '"':U + CR +
                   '  VIEW-AS TEXT':U + CR +          
                   '  SIZE ':U + STRING(FONT-TABLE:GET-TEXT-WIDTH-CHARS(_tpfield._label,2)) +
                   ' BY ':U + STRING(_tpfield._height) + CR +
                   '  FONT 2 NO-UNDO.':U.
        END. /* If character mode */                     
        ELSE DO: /* GUI mode */
          IF NOT tSameName THEN           
            Flds = 'DEFINE VARIABLE ':U + _tpfield._widget + 
                   ' AS CHARACTER FORMAT "x(256)" INITIAL "':U +
                    REPLACE(_tpfield._label, '"':U, '~~~"':U) + '"':U + CR +
                   '  VIEW-AS TEXT':U + CR +          
                   '  SIZE ':U + STRING(_tpfield._width) + ' BY ':U + STRING(_tpfield._height) + 
                          (IF _tpfield._tooltip <> '':U AND _tpfield._tooltip <> ? THEN 
                           ' TOOLTIP "':U + _tpfield._tooltip + '"':U ELSE '':U) + 
                   ColorsFonts + '.':U.
        END.  /* GUI mode */
        IF NOT tSameName THEN PUT UNFORMATTED Flds SKIP(1).
      END.  /* CASE Literal Text */

      WHEN "RC":U THEN DO: /* Rectangle */
        IF NOT tSameName THEN DO:
          Flds = 'DEFINE RECTANGLE ':U + _tpfield._widget + CR + 
                 '  SIZE ':U + STRING(_tpfield._width) + ' BY ':U + STRING(_tpfield._height). 
          IF tdispType <> "c":U THEN
          Flds = Flds + 
                          (IF _tpfield._tooltip <> '':U AND _tpfield._tooltip <> ? THEN 
                           ' TOOLTIP "':U + _tpfield._tooltip + '"':U ELSE '':U) . 
	  Flds = Flds + 
                 (IF _tpfield._edge-pixels > 0 THEN ' EDGE-PIXELS ':U +
                 STRING(_tpfield._edge-pixels) ELSE '':U) +
                 (IF _tpfield._no-fill THEN ' NO-FILL':U ELSE '':U) +
                 (IF ColorsFonts <> '':U THEN CR + ' ':U + ColorsFonts ELSE '':U) + '.':U.
          PUT UNFORMATTED Flds SKIP(1).
        END.  /* If not tSameName */
      END.  /* Rectangles */

      WHEN "CB":U  THEN DO:  /* Combo-boxes */
        IF tDispType = "c":U THEN DO:
          ASSIGN tDispFrm[FrameCnt] = tDispFrm[FrameCnt] + _tpfield._widget +
                                      IF ObjectCnt MOD 5 = 0
                                      THEN CR + '          ':U ELSE " ":U
                 ObjectCnt          = ObjectCnt + 1.
          IF NOT tSameName THEN
            Flds = 'DEFINE VARIABLE ':U + _tpfield._widget + 
                   ' AS CHARACTER FORMAT ':U + '"':U + tformat + '"':U + CR +
                   '  INITIAL ':U  + '"':U + tscreen + '"':U + CR +
                   (IF _tpfield._label <> ? THEN
                      (IF NOT _frame._side-labels THEN '  COLUMN-LABEL "':U
                                                  ELSE '  LABEL "':U) +
                       _tpfield._label + '"':U ELSE ' ':U) + ' VIEW-AS TEXT ':U + CR + 
                   '  SIZE ':U + STRING(_tpfield._width) + ' BY ':U +
                   STRING(_tpfield._height - .2) + CR + '  FONT 2 NO-UNDO.':U.
        END.  /* If character mode */
        ELSE DO: /* GUI */
          IF NOT tSameName THEN
            Flds = 'DEFINE VARIABLE ':U + _tpfield._widget + ' AS ':U + DataType +
                   (IF _tpfield._format <> ?
                     THEN ' FORMAT "':U + _tpfield._format + '"':U ELSE '':U) +
                   ' VIEW-AS COMBO-BOX':U + CR +
                   (IF _tpfield._sort THEN '  SORT':U ELSE ' ':U) + 
                   (IF _tpfield._inner-lines > 0 THEN ' INNER-LINES ':U +
                   STRING(_tpfield._inner-lines) + CR ELSE '':U).

            IF (_tpfield._list-items <> "":U and _tpfield._list-items <> ?) THEN
            DO:
              Flds = Flds + 
                (IF _tpfield._list-item-pairs THEN
                   '  LIST-ITEM-PAIRS ':U
                 ELSE
                   '  LIST-ITEMS ':U) +
                _tpfield._list-items.
            END.

            Flds = Flds + CR +
                   (IF _tpfield._style = "dl":U THEN
                      '  DROP-DOWN-LIST ':U
                    ELSE
                      '  SIMPLE ':U) + CR +
                   '  SIZE ':U + STRING(_tpfield._width) + ' BY ':U + STRING(_tpfield._height) +
                          (IF _tpfield._tooltip <> '':U AND _tpfield._tooltip <> ? THEN 
                           ' TOOLTIP "':U + _tpfield._tooltip + '"':U ELSE '':U) + 
                   (IF _tpfield._label <> ? THEN
                      (IF NOT _frame._side-labels THEN '  COLUMN-LABEL "':U
                                                  ELSE '  LABEL "':U) +
                   _tpfield._label + '"':U + CR ELSE '':U) + ' ':U + ColorsFonts + '.':U.
        END. /* GUI mode */      
        IF NOT tSameName THEN PUT UNFORMATTED Flds SKIP(1).
      END.  /* CASE Combo-Box */  

      WHEN "ED":U  THEN DO:  /* Editor */
        IF NOT tSameName THEN DO:
          Flds = 'DEFINE VARIABLE ':U + _tpfield._widget + 
                 ' AS CHARACTER VIEW-AS EDITOR':U + CR +
                 '  SIZE ':U + STRING(_tpfield._width) + ' BY ':U + STRING(_tpfield._height - .2) + CR . 
	  IF tDispType <> "c":U THEN
	  Flds = Flds + 
                          (IF _tpfield._tooltip <> '':U AND _tpfield._tooltip <> ? THEN 
                           ' TOOLTIP "':U + _tpfield._tooltip + '"':U ELSE '':U) . 
	  Flds = Flds + 
                 (IF _tpfield._scrollbar-h THEN '  SCROLLBAR-HORIZONTAL':U ELSE ' ':U) +
                 (IF _tpfield._scrollbar-v THEN ' SCROLLBAR-VERTICAL':U ELSE '':U) +
                 (IF _tpfield._label <> ? 
                    THEN '  LABEL "':U + _tpfield._label + '"':U + CR 
                    ELSE '':U) + ColorsFonts + '.':U.
          PUT UNFORMATTED Flds SKIP(1).
        END.  /* If NOT tSameName */
      END. /* CASE Editor */

      WHEN "FF":U  THEN DO:  /* Fill-in Field */
        IF tDispType = "c":U THEN DO:
          ASSIGN tDispFrm[FrameCnt] = tDispFrm[FrameCnt] + _tpfield._widget +
                                      IF ObjectCnt MOD 5 = 0
                                      THEN CR + '          ':U ELSE " ":U
                 ObjectCnt          = ObjectCnt + 1.
           IF NOT tSameName THEN
             Flds = 'DEFINE VARIABLE ':U + _tpfield._widget + 
                    ' AS CHARACTER FORMAT "':U + tformat + '"':U + CR +
                    '  INITIAL "':U + tscreen + '"':U + CR +
                    (IF _tpfield._label <> ? THEN
                      (IF NOT _frame._side-labels THEN '  COLUMN-LABEL "':U
                                                  ELSE '  LABEL "':U) +
                       _tpfield._label + '"':U ELSE ' ':U) + ' VIEW-AS TEXT ':U + CR +
                    '  SIZE ':U + STRING(_tpfield._width) + ' BY ':U +
                    STRING(_tpfield._height - .2) + ' FONT 2 NO-UNDO.':U.
        END.  /* If character mode */
        ELSE DO: /* GUI */
          IF NOT tSameName THEN
            Flds = 'DEFINE VARIABLE ':U + _tpfield._widget + ' AS ':U + DataType +
                   (IF _tpfield._format <> ? 
                       THEN ' FORMAT "':U + _tpfield._format + '"':U ELSE '':U) +
                   ' VIEW-AS FILL-IN':U + CR +
                   '  SIZE ':U + STRING(_tpfield._width) + ' BY ':U +
                   STRING(_tpfield._height) + CR +
                          (IF _tpfield._tooltip <> '':U AND _tpfield._tooltip <> ? THEN 
                           ' TOOLTIP "':U + _tpfield._tooltip + '"':U ELSE '':U) + 
                   (IF _tpfield._label <> ? THEN
                      (IF NOT _frame._side-labels THEN '  COLUMN-LABEL "':U
                                                  ELSE '  LABEL "':U) +
                      _tpfield._label + '"':U ELSE ' ':U) + ColorsFonts + '.':U.
        END.      
        IF NOT tSameName THEN  PUT UNFORMATTED Flds SKIP(1).
      END. /* CASE Fill-in Field */ 

      WHEN "RS":U  THEN DO:  /* Radio-Sets */
        IF NOT tSameName THEN DO:                         
          Flds = 'DEFINE VARIABLE ':U + _tpfield._widget + ' AS ':U + CAPS(Datatype) +
                 (IF _tpfield._format <> ? and _tpfield._format <> "":U
                      THEN ' FORMAT "':U + _tpfield._format + '"':U ELSE '':U) +
                 ' VIEW-AS RADIO-SET':U + 
                 (IF _tpfield._orientation = "v":U THEN ' VERTICAL':U ELSE ' HORIZONTAL':U) +
                 (IF _tpfield._expand THEN ' EXPAND':U ELSE '':U) + CR +
                 (IF _tpfield._list-items <> "":U and _tpfield._list-items <> "":U
                 THEN '  RADIO-BUTTONS ':U + _tpfield._list-items + CR ELSE '':U) +
                 '  SIZE ':U + STRING(_tpfield._width) + ' BY ':U + STRING(_tpfield._height) . 
	IF tDispType <> "c":U THEN
	Flds = Flds + 
                          (IF _tpfield._tooltip <> '':U AND _tpfield._tooltip <> ? THEN 
                           ' TOOLTIP "':U + _tpfield._tooltip + '"':U ELSE '':U) . 
	Flds = Flds + 
                 (IF tDispType = "c":U THEN ' FONT 2 NO-UNDO':U 
                 ELSE IF ColorsFonts <> '':U THEN CR + ColorsFonts ELSE '':U) + '.':U.
          PUT UNFORMATTED Flds SKIP(1).
        END.  /* If not tSameName */
      END.  /* CASE Radio-sets */
    
      WHEN "SE":U  THEN DO:  /* Selection Lists */                             
        IF NOT tSameName THEN DO:
          Flds = 'DEFINE VARIABLE ':U + _tpfield._widget + ' AS CHARACTER ':U +
                 ' VIEW-AS SELECTION-LIST':U + CR +
                 (IF _tpfield._multiple THEN '  MULTIPLE':U  ELSE ' ':U) + 
                 (IF _tpfield._sort THEN ' SORT':U ELSE '':U) + 
                 (IF _tpfield._scrollbar-h THEN ' SCROLLBAR-HORIZONTAL':U ELSE '':U) +
                 (IF _tpfield._scrollbar-v THEN ' SCROLLBAR-VERTICAL':U ELSE '':U).

          IF (_tpfield._list-items <> "":U AND  _tpfield._list-items <> ?) THEN
          DO:
            Flds = Flds +
              (IF _tpfield._list-item-pairs THEN
                 ' LIST-ITEM-PAIRS ':U
               ELSE
                 ' LIST-ITEMS ':U) +
              _tpfield._list-items.
          END.

          Flds = Flds + CR +
            '  SIZE ':U + STRING(_tpfield._width) + ' BY ':U +
            STRING(_tpfield._height) + CR .
	    IF tDispType <> "c":U THEN
	      Flds = Flds +
              (IF _tpfield._tooltip <> '':U AND _tpfield._tooltip <> ? THEN 
               ' TOOLTIP "':U + _tpfield._tooltip + '"':U ELSE '':U). 
	    Flds = Flds + 
            (IF _tpfield._label <> ? THEN
             '  LABEL "':U + _tpfield._label + '"':U ELSE ' ':U) +  
            (IF tDispType = "c":U THEN ' FONT 2 NO-UNDO.':U ELSE ColorsFonts + '.':U).

          PUT UNFORMATTED Flds SKIP(1).
        END.  /* IF NOT tSameName */
      END.  /* CASE: Selection List */
    
      WHEN "SL":U  THEN DO:  /* Slider */
        IF NOT tSameName THEN DO:
          Flds = 'DEFINE VARIABLE ':U + _tpfield._widget + ' AS INTEGER':U +
                 ' VIEW-AS SLIDER':U + CR +
                 '  MIN-VALUE ':U + STRING(_tpfield._min-value) + ' MAX-VALUE ':U +
                 STRING(_tpfield._max-value) +
                 (IF _tpfield._orientation = "v":U
                     THEN ' VERTICAL':U ELSE ' HORIZONTAL':U) + CR +
                 '  SIZE ':U + STRING(_tpfield._width) + ' BY ':U +
                 STRING(_tpfield._height).
          IF tDispType <> "c":U THEN
	  Flds = Flds + 
                          (IF _tpfield._tooltip <> '':U AND _tpfield._tooltip <> ? THEN 
                           ' TOOLTIP "':U + _tpfield._tooltip + '"':U ELSE '':U) . 
	  Flds = Flds + 
                 (IF _tpfield._label <> ?
                     THEN ' LABEL "':U + _tpfield._label + '"':U  ELSE '':U) +  
                 (IF tDispType = "c":U THEN ' FONT 2 NO-UNDO.':U ELSE ColorsFonts + '.':U).
          PUT UNFORMATTED Flds SKIP(1).
        END.  /* If NOT tSameName */
      END. /* CASE Slider */

      WHEN "TB":U  THEN DO:  /* Toggle Box */ 
        IF tDispType = "c":U THEN DO: 
          ASSIGN tDispFrm[FrameCnt] = tDispFrm[FrameCnt] + _tpfield._widget +
                                      IF ObjectCnt MOD 5 = 0
                                      THEN CR + '          ':U ELSE " ":U
                 ObjectCnt          = ObjectCnt + 1.
          IF NOT tSameName THEN
            Flds = 'DEFINE VARIABLE ':U + _tpfield._widget +
                   ' AS CHARACTER FORMAT ':U + '"':U + tformat + '"':U + CR +
                   '  INITIAL ':U + '"':U + tscreen + '"':U + CR +
                   '  VIEW-AS TEXT':U + CR +
                   '  SIZE ':U + STRING(twidth) + ' BY ':U + STRING(_tpfield._height - .2)  + CR +
                   '  FONT 2 NO-UNDO.':U.
        END.  /* Character Mode */
        ELSE DO: /* GUI  MODE */
          IF NOT tSameName THEN
            Flds = 'DEFINE VARIABLE ':U + _tpfield._widget + ' AS LOGICAL':U +
                   (IF _tpfield._label <> ?
                   THEN ' LABEL "':U + _tpfield._label + '"':U ELSE '':U) +
                   ' VIEW-AS TOGGLE-BOX':U + CR +
                   '  SIZE ':U + STRING(_tpfield._width) + ' BY ':U + 
                   STRING(_tpfield._height)  +
                   (IF _tpfield._tooltip <> '':U AND _tpfield._tooltip <> ? THEN 
                   ' TOOLTIP "':U + _tpfield._tooltip + '"':U ELSE '':U) + 
                   ColorsFonts + '.':U.
        END.  /* GUI Mode */
        IF NOT tSameName THEN PUT UNFORMATTED Flds SKIP(1).
      END.  /* CASE: Toggles */ 
    END.  /* Case statement on _tpfield._type */
  END.  /* For each _frame, _tpfield of frame -- Definition Loop */

  /* PUT OUT FRAME DEFINITIONS */
  FrameCnt   = 0.
  FOR EACH _frame BREAK BY _frame._frame:   

    IF FIRST-OF(_frame._frame) THEN DO:     

      FIND FIRST _tpfield WHERE _frame._frame = _tpfield._frame NO-ERROR.
      ASSIGN frameIsEmpty = IF AVAILABLE _tpfield THEN NO ELSE YES.

      IF NOT frameIsEmpty OR (_frame._title <> ? AND _frame._title <> "":U) THEN
      DO:
         ASSIGN
           frame-lines = 1   /* Check FrameFlds every 10 lines to avoid 4096 limit */
           frame-bytes = SEEK(OUTPUT)
           FrameCnt    = FrameCnt + 1
           EnableAll   = EnableAll + '  ENABLE ALL WITH FRAME ':U + _frame._frame +
                                     ' IN WINDOW TranWindow.':U + CR.
         PUT UNFORMATTED  'DEFINE FRAME ':U + _frame._frame + CR.
      END.
    END.  /* IF first-of frame */                             

    IF frame-lines MOD 10 = 0 THEN DO:  /* Time for a check */
      IF SEEK(OUTPUT) > frame-bytes + 2500 THEN DO:
        /* Getting big - break it up */
        ASSIGN frame-bytes = SEEK(OUTPUT).
        IF (NOT frameIsEmpty OR (_frame._title <> ? AND _frame._title <> "":U)) THEN
        PUT UNFORMATTED '.':U + CR + CR +
           '/* Frame is approaching 4096 byte limit.  Break it up */':U + CR +
           'DEFINE FRAME ':U + _tpfield._frame + CR.
      END.
    END.                                                            
    frame-lines = frame-lines + 1.

    IF (NOT frameIsEmpty OR (_frame._title <> ? AND _frame._title <> "":U)) AND
       tDispType = "c":U THEN /* Character mode display */
      ASSIGN ColorsFonts = ' FONT 2 BGCOLOR 7 FGCOLOR 14':U.

    FOR EACH _tpfield WHERE _frame._frame = _tpfield._frame:
    IF frame-lines MOD 10 = 0 THEN DO:  /* Time for a check */
      IF SEEK(OUTPUT) > frame-bytes + 2500 THEN DO:
        /* Getting big - break it up */
        ASSIGN frame-bytes = SEEK(OUTPUT).
        PUT UNFORMATTED '.':U + CR + CR +
           '/* Frame is approaching 4096 byte limit.  Break it up */':U + CR +
           'DEFINE FRAME ':U + _tpfield._frame + CR.
      END.
    END.                                                            
    frame-lines = frame-lines + 1.

    IF tDispType = "c":U THEN DO: /* Character mode display */
      ASSIGN AlignFlds   = IF CAN-DO("FF,CB":U,_tpfield._type) AND _tpfield._no-label
                           AND _frame._side-labels
                           THEN ' COLON-ALIGNED NO-LABEL':U
                           ELSE IF CAN-DO("FF,CB":U,_tpfield._type) AND
                                   NOT _tpfield._no-label AND
                                   _frame._side-labels THEN ' COLON-ALIGNED':U
                           ELSE IF CAN-DO("BU,LI,TB":U,_tpfield._type)
                           THEN ' COLON-ALIGNED NO-LABEL':U
                           ELSE IF _tpfield._no-label AND _tpfield._type NE 'BW':U 
                           THEN ' NO-LABEL':U ELSE '':U.
      IF CAN-DO("BU,FF,CB,TB":U,_tpfield._type) THEN DO:
        ASSIGN tWidth = _tpfield._width.
        RUN DispFlds(INPUT _tpfield._type,
                     INPUT _tpfield._label,
                     INPUT _tpfield._initial,
                     INPUT-OUTPUT twidth,
                     OUTPUT tFormat,
                     OUTPUT tScreen).
      END.  /* If need to do character representation */
    END.  /* IF tDispType = "c" */
    ELSE
      ASSIGN AlignFlds   = (IF CAN-DO("FF,CB":U,_tpfield._type) AND
                                   _tpfield._no-label AND _frame._side-labels
                            THEN ' COLON-ALIGNED NO-LABEL':U
                            ELSE IF CAN-DO("FF,CB":U,_tpfield._type) AND
                                    NOT _tpfield._no-label AND _frame._side-labels
                            THEN ' COLON-ALIGNED':U
                            ELSE IF _tpfield._no-label AND _tpfield._type NE 'BW':U
                            THEN ' NO-LABEL':U ELSE '':U)
             ColorsFonts = (IF _tpfield._fgcolor <> ? THEN
                               ' FGCOLOR ':U + STRING(_tpfield._fgcolor) ELSE '') +
                           (IF _tpfield._bgcolor <> ? THEN
                               ' BGCOLOR ':U + STRING(_tpfield._bgcolor) ELSE '') +
                           (IF _tpfield._font <> ? THEN
                               ' FONT ':U + STRING(_tpfield._font) ELSE '').

    /* Adjust position of fields with side-labels that are colon aligned */
    IF AlignFlds = ' COLON-ALIGNED':U THEN
      ASSIGN _tpfield._x = IF tDispType = "c":U
                             THEN MAX(_tpfield._x - 2,
                                 LENGTH(_tpfield._label, "CHARACTER":U) + 1, 1)
                             ELSE MAX(_tpfield._x - 2 , 1).

    /* Now put things into the frame */
    CASE _tpfield._type:
      WHEN "FF":U THEN DO:   /* Fill-in Field */
       /* Column position is tricky if a down frame and the label is wider than fill-in */
       col-pos = _tpfield._x.
       IF NOT _frame._side-labels AND NOT _tpfield._no-label AND
          _tpfield._data-type = 4 OR _tpfield._data-type = 5 /* Numeric data */ THEN DO:
         DO i = 1 to NUM-ENTRIES(_tpfield._label,"!":U):
           label-width = FONT-TABLE:GET-TEXT-WIDTH-CHARS(ENTRY(i, _tpfield._label, "!":U),
                         _frame._font).
           IF label-width > _tpfield._width THEN
             col-pos = MIN(col-pos, (_tpfield._x - (label-width - _tpfield._width))).
         END.
       END.
       PUT UNFORMATTED '  ':U + _tpfield._widget +
                         (IF _tpfield._literal-value NE "":U AND
                             _tpfield._literal-value NE ?
                          THEN ' VIEW-AS TEXT':U ELSE '':U) +
                   ' AT ROW ':U + STRING(_tpfield._y + IF tDispType = "c":U THEN .2 ELSE 0) +
                   ' COL ':U + STRING(col-pos) +  AlignFlds + CR.
      
      END. /* Case FF */
        
      WHEN  "RS":U THEN   /* Radio-Set */
        PUT UNFORMATTED '  ':U +  _tpfield._widget +
                    ' AT ROW ':U + STRING(_tpfield._y) +
                    ' COL ':U + STRING(_tpfield._x) +  AlignFlds + CR +
/* *** No need, we already defined this...
                    (IF _tpfield._format <> ? and _tpfield._format <> "":U
                       THEN '    FORMAT "':U + _tpfield._format + '"':U ELSE '   ':U) +
                    ' VIEW-AS RADIO-SET':U + 
                    (IF _tpfield._orientation = "v":U THEN ' VERTICAL':U 
                                                      ELSE ' HORIZONTAL':U) +
                    (IF _tpfield._expand THEN ' EXPAND':U + CR ELSE '':U) + CR + 
                    (IF _tpfield._list-items <> "":U and _tpfield._list-items <> "":U
                       THEN '    RADIO-BUTTONS ':U + _tpfield._list-items + CR ELSE '':U) +
                    '    SIZE ':U + STRING(_tpfield._width) + ' BY ':U +
                    STRING(_tpfield._height) + 
*** */
                    (IF tDispType = "c":U THEN ' FONT 2 ':U
                    ELSE IF ColorsFonts <> '':U THEN CR + '   ':U + ColorsFonts
                                                ELSE '':U) + CR.

      WHEN  "TB":U THEN DO:  /* Toggle-Box */
        PUT UNFORMATTED '  ':U +  _tpfield._widget +
                    ' AT ROW ':U + STRING(_tpfield._y + IF tDispType = "c":U THEN .2 ELSE 0) +
                    ' COL ':U + STRING(_tpfield._x) +  AlignFlds + CR +
                    (IF tDispType = 'c':U THEN '    VIEW-AS TEXT ':U
                                        ELSE '    VIEW-AS TOGGLE-BOX':U) + CR +
                    '    SIZE ':U + STRING(_tpfield._width) + ' BY ':U +
                    STRING(_tpfield._height - IF tDispType = "c":U THEN .2 ELSE 0)  +
                    (IF tDispType = "c":U THEN ''
                     ELSE IF _tpfield._label <> ? 
                         THEN ' LABEL "':U + _tpfield._label + '"':U  
                         ELSE '':U) +  
                    (IF tDispType = "c":U THEN ' FONT 2 ':U ELSE ColorsFonts)  + CR.
      END.  /* Case TB */

      WHEN "SL":U THEN  /* Slider */
        PUT UNFORMATTED '  ':U +  _tpfield._widget + ' AT ROW ':U +
                    STRING(_tpfield._y) + ' COL ':U + STRING(_tpfield._x) +
                    AlignFlds + CR + '    VIEW-AS SLIDER':U + CR + '    MIN-VALUE ':U +
                    STRING(_tpfield._min-value) + ' MAX-VALUE ':U +
                    STRING(_tpfield._max-value) +
                    (IF _tpfield._orientation = "v":U THEN ' VERTICAL':U
                                                      ELSE ' HORIZONTAL':U) + CR +
                    '    SIZE ':U + STRING(_tpfield._width) + ' BY ':U +
                    STRING(_tpfield._height)  +     
                    (IF tDispType = "c":U THEN ' ':U 
                    ELSE IF _tpfield._label <> ?
                        THEN ' LABEL "':U + _tpfield._label + '"':U  ELSE '':U) +  
                    (IF tDispType = "c":U THEN ' FONT 2 ':U ELSE ColorsFonts) + CR.
                    
      WHEN "SE":U THEN  /* Selection-List */
        PUT UNFORMATTED '  ':U +  _tpfield._widget +
                    ' AT ROW ':U + STRING(_tpfield._y) +
                    ' COL ':U + STRING(_tpfield._x) +  AlignFlds + CR +
/* *** No need, we already defined this...
                    '    VIEW-AS SELECTION-LIST':U + CR +
                    (IF _tpfield._multiple THEN '    MULTIPLE':U  ELSE '   ':U) + 
                    (IF _tpfield._scrollbar-h THEN ' SCROLLBAR-HORIZONTAL':U ELSE '':U) +
                    (IF _tpfield._scrollbar-v THEN ' SCROLLBAR-VERTICAL':U ELSE '':U) +
                    (IF _tpfield._list-items <> "":U and _tpfield._list-items <> ?
                        THEN ' LIST-ITEMS ':U + _tpfield._list-items + CR ELSE '':U) +
                    '    SIZE ':U + STRING(_tpfield._width) + ' BY ':U +
                    STRING(_tpfield._height) + CR +
*** */
                    (IF tDispType = "c":U THEN '   ':U 
                    ELSE IF _tpfield._label <> ?
                        THEN '    LABEL "':U + _tpfield._label + '"':U + CR 
                        ELSE '':U) +  
                    (IF tDispType = "c":U THEN ' FONT 2 ':U ELSE ColorsFonts) + CR.
                    
      WHEN "ED":U THEN  /* Editor */
        PUT UNFORMATTED '  ':U +  _tpfield._widget +
                    ' AT ROW ':U + STRING(_tpfield._y) +
                    ' COL ':U + STRING(_tpfield._x) +  AlignFlds + CR +
                    '    VIEW-AS EDITOR':U + CR + '    SIZE ':U + STRING(_tpfield._width) + 
                    ' BY ':U + STRING(_tpfield._height) + CR + 
                    (IF _tpfield._scrollbar-h THEN '    SCROLLBAR-HORIZONTAL':U ELSE '   ':U) +
                    (IF _tpfield._scrollbar-v THEN ' SCROLLBAR-VERTICAL':U ELSE '':U) +
                    (IF tDispType = "c":U THEN '':U 
                    ELSE IF _tpfield._label <> ?
                        THEN '  LABEL "':U + _tpfield._label + '"':U + CR + '   ':U
                        ELSE '':U) +  
                    (IF tDispType = "c":U THEN ' FONT 2 ':U ELSE ColorsFonts) + CR.
                    
      WHEN "CB":U THEN DO: /* Combo-Box */
       /* Column position is tricky if a down frame and the label is wider than fill-in */
       col-pos = _tpfield._x.
       IF NOT _frame._side-labels AND NOT _tpfield._no-label AND
          _tpfield._data-type = 4 OR _tpfield._data-type = 5 /* Numeric data */ THEN DO:
         DO i = 1 to NUM-ENTRIES(_tpfield._label,"!":U):
           label-width = FONT-TABLE:GET-TEXT-WIDTH-CHARS(ENTRY(i,_tpfield._label,"!":U),
                         _frame._font).
           IF label-width > _tpfield._width THEN
             col-pos = MIN(col-pos, (_tpfield._x - (label-width - _tpfield._width))).
         END.
       END.
        PUT UNFORMATTED '  ':U +  _tpfield._widget +
                    ' AT ROW ':U + STRING(_tpfield._y + IF tDispType = "c":U THEN .2 ELSE 0) +
                    ' COL ':U + STRING(col-pos) +  AlignFlds + CR .
      END. /* Case CB */
        
      WHEN "BW":U THEN DO: /* A Browse, avoid an empty browse  */
        IF CAN-FIND(FIRST _tpbrwfld WHERE _tpbrwfld._brwname = _tpfield._widget) THEN
          PUT UNFORMATTED '  ':U +  _tpfield._widget +
                          ' AT ROW ':U + STRING(_tpfield._y) +
                          ' COL ':U + STRING(_tpfield._x) +  AlignFlds + CR .
      END. /* Case BW */
      
      OTHERWISE 
        PUT UNFORMATTED (IF _tpfield._type <> "BC":U THEN
                      '  ':U +  _tpfield._widget +
                      ' AT ROW ':U + STRING(_tpfield._y) +
                      ' COL ':U + STRING(_tpfield._x) +  AlignFlds + CR 
                      ELSE "":U).
    END CASE.   /* CASE _tpfield._type */

  END.  /* end FOR EACH _tpfield */

    IF last-of(_frame._frame) THEN DO:

       IF NOT frameIsEmpty THEN
       ASSIGN 
         tDispFrm[FrameCnt]  = tDispFrm[FrameCnt] + CR + '    WITH FRAME ':U +
                               _frame._frame + ".":U  + CR 
                   .
       IF NOT frameIsEmpty 
          OR (_frame._title <> ? AND _frame._title <> "":U) THEN
       DO:
                  
          IF tDispType = "c":U THEN DO:
            ASSIGN _frame._width  = MIN(80,TRUNCATE(_frame._width + 2.5, 0))
                   _frame._height = MIN(23,TRUNCATE(_frame._height + 1,0))
                   MaxWidth  = MAX(MaxWidth,_frame._width)
                   MaxHeight = MAX(MaxHeight,_frame._height).
            PUT UNFORMATTED ' WITH ':U +
                     (IF _down > 0      THEN STRING(_down) + ' DOWN':U ELSE '':U) + 
                     (IF _keep-tab-order THEN ' KEEP-TAB-ORDER':U ELSE '':U) + 
                     (IF _no-attr-space THEN ' NO-ATTR-SPACE':U ELSE '':U)  + 
                     (IF _no-box        THEN ' NO-BOX':U ELSE '':U)  +      
                     (IF _no-hide       THEN ' NO-HIDE':U ELSE '':U)  +
                     (IF _no-labels     THEN ' NO-LABELS':U ELSE '':U)  +
                     (IF _no-underline  THEN ' NO-UNDERLINE':U ELSE '':U)  +
                     (IF _no-validate   THEN ' NO-VALIDATE':U ELSE '':U)  +
                     (IF _overlay       THEN ' OVERLAY':U ELSE '':U)  +
                     (IF _page-bottom   THEN ' PAGE-BOTTOM':U ELSE '':U) +
                     (IF _page-top      THEN ' PAGE-TOP':U ELSE '':U) +
                     (IF _scrollable    THEN ' SCROLLABLE ':U ELSE '':U)  +
                     (IF _side-labels   THEN ' SIDE-LABELS':U ELSE '':U)  +
                     (IF _size-to-fit   THEN ' SIZE-TO-FIT':U ELSE '':U) +
                   /*  (IF _three-d       THEN ' THREE-D':U ELSE '':U) +  */
                     (IF _top-only      THEN ' TOP-ONLY':U ELSE '':U) + 
                     (IF _frame._title <> ?   THEN ' TITLE "':U + _frame._title + '"':U ELSE '':U) +
                     CR + 
                     '   SIZE ':U + STRING(_frame._width) + 
                     ' BY ':U + (IF _frame._height + .25 > 2 THEN 
                                 STRING(_frame._height) 
                               ELSE '2':U) + 
                     ' AT ROW ':U + STRING(_frame._y) + ' COL ':U + STRING(_frame._x) + 
                     ' FONT 2 BGCOLOR 7 FGCOLOR 14':U +
                     '.':U + CR + CR.
          END.  /* if tDispType = "c" */
          ELSE DO:
       ASSIGN yAdjust     = IF _frame._y = 1 THEN 0 ELSE _frame._y
              xAdjust     = IF _frame._x = 1 THEN 0 ELSE _frame._x
              MaxHeight   = MAX(MaxHeight, yAdjust + (_frame._height + .25))
              MaxWidth    = MAX(MaxWidth, xAdjust + (_frame._width + 1)).  
            PUT UNFORMATTED ' WITH ':U +
                       (IF _down > 0      THEN STRING(_down) + ' DOWN':U ELSE '':U) + 
                       (IF _keep-tab-order THEN ' KEEP-TAB-ORDER':U ELSE '':U) + 
                       (IF _no-attr-space THEN ' NO-ATTR-SPACE':U ELSE '':U)  + 
                       (IF _no-box        THEN ' NO-BOX':U ELSE '':U)  +      
                       (IF _no-hide       THEN ' NO-HIDE':U ELSE '':U)  +
                       (IF _no-labels     THEN ' NO-LABELS':U ELSE '':U)  +
                       (IF _no-underline  THEN ' NO-UNDERLINE':U ELSE '':U)  +
                       (IF _no-validate   THEN ' NO-VALIDATE':U ELSE '':U)  +
                       (IF _overlay       THEN ' OVERLAY':U ELSE '':U)  +
                       (IF _page-bottom   THEN ' PAGE-BOTTOM':U ELSE '':U) +
                       (IF _page-top      THEN ' PAGE-TOP':U ELSE '':U) +
                       (IF _scrollable    THEN ' SCROLLABLE':U ELSE '':U)  +
                       (IF _side-labels   THEN ' SIDE-LABELS':U ELSE '':U)  +
                       (IF _size-to-fit   THEN ' SIZE-TO-FIT':U ELSE '':U) +
                       (IF _three-d       THEN ' THREE-D':U ELSE '':U) + 
                       (IF _top-only      THEN ' TOP-ONLY':U ELSE '':U) + 
                       (IF _title <> ?    THEN ' TITLE "':U + _title + '"':U ELSE '':U) +
                       CR + 
                     '   SIZE ':U +  STRING(_frame._width + 1) + 
                     ' BY ':U + (IF _frame._height + .25 > 2 THEN
                                  STRING(_frame._height + .25)
                               ELSE '2':U) +
                     ' AT ROW ':U + STRING(_frame._y) + ' COL ':U + STRING(_frame._x) + 
                     (IF _frame._bgcolor <> ? THEN ' BGCOLOR ':U + STRING(_frame._bgcolor) ELSE '':U) + 
                     (IF _frame._fgcolor <> ? THEN ' FGCOLOR ':U + STRING(_frame._fgcolor) ELSE '':U) +
                     (IF _frame._font > 0 THEN ' FONT ':U + STRING(_frame._font) ELSE '':U) + 
                     '.':U + CR + CR.            
          END.          
         FrameTrigs = FrameTrigs + CR +
                      'ON ENTRY OF FRAME ':U + _frame._widget + ' DO:':U + CR +
                      '  IF VALID-HANDLE(CurObj) AND CAN-QUERY(CurObj,"SELECTED":U) AND':U + CR +
                      '     NOT CurObj:SELECTED THEN':U + CR +
                      '     DO:':U + CR +
                      '        CurObj = SELF.':U + CR +
                      '        RUN Properties IN hprops.':U + CR +
                      '     END.':U + CR +
                      'END.':U + CR + CR +
                      'ON MOUSE-SELECT-DBLCLICK OF FRAME ':U + _frame._widget + ' DO:':U + CR +  
                      '  CurObj = SELF.':U + CR +
                      '  RUN Properties IN hprops.':U + CR +
                      'END.':U + CR .
       
       END.
    END. /* last-of frame */
  END.  /* end FOR EACH _frame */

  /*  Write out DEFINE frame definitions  */  
  PUT UNFORMATTED " ":U SKIP(1).
  
  /* Create Window code */                       
     
  IF maxwidth < {&DefWinWidth} THEN maxwidth = {&DefWinWidth}.
  IF maxheight < {&DefWinHeight} THEN maxheight = {&DefWinHeight}.
  
  /* We want this window to get the application's INI file. So, we must load/use 
     it before the window is created, and unload it before the program ends to 
     prevent a conflict with TM2 */
  IF NOT AVAILABLE xlatedb.XL_Project THEN
    FIND FIRST xlatedb.XL_Project NO-LOCK NO-ERROR.
  IF AVAILABLE xlatedb.XL_Project THEN 
    ASSIGN INIFile = ENTRY(NUM-ENTRIES(xlatedb.XL_Project.SettingsFile,"~\":U),
                           xlatedb.XL_Project.SettingsFile,"~\":U).

  IF INIFile <> "" AND INIFile <> ? THEN
    PUT UNFORMATTED
      '/* Map this window to the applications environment file */':U SKIP
      'FIND FIRST Kit.XL_Project NO-LOCK NO-ERROR.':U SKIP
      'IF AVAILABLE Kit.XL_Project THEN DO:':U SKIP
      '  LOAD Kit.XL_Project.RootDirectory + "\':U + INIFile +
          '" DYNAMIC NO-ERROR.':U SKIP
      '  USE  Kit.XL_Project.RootDirectory + "\':U + INIFile + '".':U SKIP
      'END.  /* We found the project record */':U SKIP(1).
  
  PUT UNFORMATTED
  '/*  Window defined ... */':U SKIP
  'CREATE WINDOW TranWindow ASSIGN':U SKIP
  '       TITLE              = "':U + ProcedureFile + '"':U SKIP 
  '       HEIGHT             = ':U MaxHeight SKIP
  '       WIDTH              = ':U MaxWidth SKIP
  '       MAX-HEIGHT         = ':U MaxHeight SKIP
  '       MAX-WIDTH          = ':U MaxWidth SKIP
  '       VIRTUAL-HEIGHT     = ':U MaxHeight SKIP
  '       VIRTUAL-WIDTH      = ':U MaxWidth SKIP
  '       RESIZE             = TRUE':U SKIP
  '       SCROLL-BARS        = FALSE':U SKIP
  '       MESSAGE-AREA       = FALSE':U SKIP 
  '       STATUS-AREA        = FALSE':U SKIP
  '       BGCOLOR            = ?':U SKIP  
  '       KEEP-FRAME-Z-ORDER = TRUE':U SKIP
  '       FGCOLOR            = ?':U SKIP
  '       THREE-D            = TRUE':U SKIP
  '       SENSITIVE          = TRUE.':U SKIP(1).
  
  IF MenuName <> "" THEN PUT UNFORMATTED MenuName SKIP(1).   
  
  IF PopMenu <> "":U THEN DO: /* Found a popup menu, try to attach it */
    PopMenu = "":U.         /* NOTE: this only works if UIB conventions were followed */
    FOR EACH _tpfield WHERE _tpfield._widget BEGINS "POPUP-MENU-":U AND
                            _tpfield._TYPE = "MU":U:
      FIND FIRST b_tpfield WHERE b_tpfield._widget = 
           SUBSTRING(_tpfield._widget, 12, -1, "CHARACTER":U) NO-ERROR.
      IF AVAILABLE b_tpfield THEN DO:
        IF PopMenu = "":U THEN
          PopMenu = "ASSIGN ":U.
        ELSE PopMenu = PopMenu + CR + "       ":U.
        ASSIGN PopMenu           = PopMenu + b_tpfield._widget +
                                   ':POPUP-MENU IN FRAME ':U + b_tpfield._frame +
                                   ' = MENU ':U + _tpfield._widget + ':HANDLE':U.
      END. /* If we can locate the widget to which it belongs */
      ELSE DO:  /* See if it is  a popup for a frame */
        FIND FIRST _frame WHERE _frame._frame =
           SUBSTRING(_tpfield._widget, 12, -1, "CHARACTER":U) NO-ERROR.
        IF AVAILABLE _frame THEN DO:
          IF PopMenu = "":U THEN
            PopMenu = "ASSIGN FRAME ":U.
          ELSE PopMenu = PopMenu + CR + "       FRAME ":U.
          ASSIGN PopMenu           = PopMenu + _frame._frame +
                                     ':POPUP-MENU ':U +
                                     ' = MENU ':U + _tpfield._widget + ':HANDLE':U.
        END.  /* Was it a frame popup */
        ELSE IF SUBSTRING(_tpfield._widget, 
                          LENGTH(_tpfield._widget) - 3,
                          4,
                          "CHARACTER":U)
                = "-WIN":U THEN      /* See if it is a popup for the window */
        DO:
          
          IF PopMenu = "":U THEN
             ASSIGN PopMenu = 'ASSIGN tranwindow:POPUP-MENU = MENU ':U +
                                _tpfield._widget + ':HANDLE':U.
          ELSE 
             ASSIGN PopMenu = PopMenu + CR + 
                              '       tranwindow:POPUP-MENU = MENU ':U +
                                _tpfield._widget + ':HANDLE':U.
        END.
      END. /* else if try a frame */
    END.  /* For each popup that adheres to UIB naming conventions */
    IF PopMenu NE "":U THEN PUT UNFORMATTED PopMenu + ".":U SKIP(1). 
  END.  /* If we found a popup menu */
  
  PUT UNFORMATTED
  'ASSIGN TM_lResult                    = TranWindow:LOAD-ICON ("adetran/images/trans%")':U SKIP
  '       tDispType                     = "':U + tDispType + '"':U SKIP  
  '       CURRENT-WINDOW                = TranWindow':U SKIP 
  '       THIS-PROCEDURE:CURRENT-WINDOW = TranWindow.':U SKIP(1).
   
       
  /* Sensitize widgets  */
  frame-bytes = SEEK(OUTPUT).
  FOR EACH _frame, EACH _tpfield WHERE _frame._frame = _tpfield._frame AND
           NOT CAN-DO("BW,BC":U,_tpfield._type)
         BREAK BY _frame._frame:

    IF frame-bytes = SEEK(OUTPUT) THEN DO:
      PUT UNFORMATTED 'ASSIGN':U SKIP.
      Period-put = NO.
    END.

    PUT UNFORMATTED '      ':U + _tpfield._widget + ':PRIVATE-DATA IN FRAME ':U +
                    _tpfield._frame +  ' = "':U + _tpfield._type.
    IF CAN-DO("BU,FF,CB":U, _tpfield._type) THEN
      PUT UNFORMATTED CHR(4) + IF _tpfield._label NE ? THEN _tpfield._label ELSE "":U.
    IF _tpfield._type = "CB":U THEN
      PUT UNFORMATTED CHR(4) + REPLACE(_tpfield._list-items, '"':U, "":U).
    IF _tpfield._type = "TB":U THEN
      PUT UNFORMATTED CHR(4) + _tpfield._label + CHR(4) + _tpfield._initial.
    PUT UNFORMATTED '"':U + CR.

    PUT UNFORMATTED '      ':U + _tpfield._widget + ':SELECTABLE':U +
                    ' IN FRAME ':U + _tpfield._frame + ' = TRUE':U + CR +
                    '      ':U + _tpfield._widget + ':RESIZABLE IN FRAME ':U +
                     _tpfield._frame +
                    (IF _tpfield._type = "CB":U THEN ' = FALSE':U
                                                ELSE ' = TRUE':U) + CR +
                    (IF _tpfield._widget MATCHES "TEXT*":U
                        THEN '      ':U + _tpfield._widget + ':SCREEN-VALUE':U +
                             ' IN FRAME ':U +
                             _tpfield._frame + ' = "':U +
                             (IF _tpfield._label <> ? THEN
                             REPLACE(_tpfield._label, '"':U, '~~~"':U) ELSE '':U) +
                             '"':U + CR
                     ELSE '':U).
    IF _tpfield._literal-value NE "":U AND _tpfield._literal-value NE ? AND
       NOT _tpfield._widget MATCHES "TEXT*":U THEN
      PUT UNFORMATTED '      ':U + _tpfield._widget + ':SCREEN-VALUE':U +
                      ' IN FRAME ':U + _tpfield._frame + ' = "':U +
                       REPLACE(_tpfield._literal-value, '"':U, '~~~"':U) + '"':U + CR.
    IF _tpfield._help NE "":U AND _tpfield._help NE ? THEN
      PUT UNFORMATTED '      ':U + _tpfield._widget + ':HELP':U +
                      ' IN FRAME ':U + _tpfield._frame + ' = "':U +
                       REPLACE(_tpfield._help, '"':U, '~~~"':U) + '"':U + CR.

    IF SEEK(OUTPUT) - frame-bytes > 2800 THEN DO:
      PUT UNFORMATTED '    .':U SKIP.
      ASSIGN Period-put = YES
             frame-bytes = SEEK(OUTPUT).
    END.
  END. /* For Each Frame, Non-browse object */
  IF NOT Period-put THEN PUT UNFORMATTED '    .':U SKIP.


  PUT UNFORMATTED SKIP (1).
         
  /* Sensitize side-labels for those widgets that have them */
  FOR EACH _frame, EACH _tpfield WHERE _frame._frame = _tpfield._frame AND
           CAN-DO("CB,FF":U,_tpfield._type)
         BREAK BY _frame._frame:
    PUT UNFORMATTED 'RUN side-label-setup(':U + _tpfield._widget + 
           ':HANDLE IN FRAME ':U + _tpfield._frame + ').':U SKIP.
  END. /* FOR EACH Combo-Box or Fill-In */

            
  /* construct triggers for the new procedure  */  
  PUT UNFORMATTED SKIP (1) '/* Trigger Section ...  */':U SKIP. 
  PUT UNFORMATTED 
    'ON SELECT OF TranWindow ANYWHERE DO:':U SKIP
    '  CurObj = SELF.':U SKIP
    '  IF CAN-QUERY(CurObj,"SELECTED")  THEN CurObj:SELECTED = TRUE.':U SKIP
    '  IF CAN-QUERY(CurObj,"RESIZABLE") THEN CurObj:RESIZABLE = TRUE.':U SKIP
    '  RUN Properties IN hprops.':U SKIP
    'END.':U SKIP(1).
  PUT UNFORMATTED
    'ON START-RESIZE OF TranWindow ANYWHERE DO:':U SKIP
    '  RETURN NO-APPLY.':U SKIP
    'END.':U SKIP(1).
  PUT UNFORMATTED 
    'ON MOUSE-SELECT-DBLCLICK OF TranWindow ANYWHERE DO:':U SKIP
    '  CurObj = SELF.':U SKIP 
    '  IF CurObj:TYPE <> "WINDOW":U THEN DO:':U SKIP 
    '     IF CAN-QUERY(CurObj,"SELECTED")  THEN CurObj:SELECTED = TRUE.':U SKIP
    '     IF CAN-QUERY(CurObj,"RESIZABLE") THEN CurObj:RESIZABLE = TRUE.':U SKIP
    '  END.':U SKIP 
    '  RUN Properties IN hprops.':U SKIP
    'END.':U SKIP (1).
  PUT UNFORMATTED
    'ON HELP OF TranWindow ANYWHERE DO:':U SKIP
    '  MESSAGE "There is no help available for ':U + ProcedureFile + '.".':U SKIP
    'END.':U SKIP(1).
  FOR EACH _tpfield where  
          (_tpfield._type = "MI":U /*  or _tpfield._type = "MU":U */ ) and
          (_tpfield._format <> "MENU":U):  
     IF _tpfield._type = "MU":U THEN
        PUT UNFORMATTED 
        'ON MENU-DROP OF ':U _tpfield._format ' ':U _tpfield._widget ' IN MENU ':U
                     _tpfield._initial ' DO:':U SKIP
        '  CurObj = SELF.':U SKIP 
        '  RUN Properties IN hprops.':U SKIP
        'END.':U SKIP (1).                                     
     ELSE IF _tpfield._type = "MI":U THEN DO:                  
       
       find _tpmnufld where _tpmnufld._fldseq = _tpfield._seq-num.         
       find first b_tpfield where b_tpfield._widget = _tpmnufld._parmnu NO-ERROR.
                
       IF not avail b_tpfield THEN 
          PUT UNFORMATTED 
            'ON CHOOSE OF ':U _tpfield._format ' ':U _tpfield._widget ' IN MENU ':U 
                      _tpfield._initial ' DO:':U SKIP
            '  CurObj = SELF.':U SKIP 
            '  RUN Properties IN hprops.':U SKIP
            'END.':U SKIP (1).          
       ELSE                           
          PUT UNFORMATTED 
            'ON CHOOSE OF ':U _tpfield._format ' ':U _tpfield._widget
                 ' IN SUB-MENU ':U b_tpfield._widget ' DO:':U SKIP
            '  CurObj = SELF.':U SKIP 
            '  RUN Properties IN hprops.':U SKIP
            'END.':U SKIP (1).          
     END.   
  END.   
  
  FOR EACH _frame, each _tpfield where (_frame._frame = _tpfield._frame) and
            (_tpfield._type <> "BC":U):     
      IF _tpfield._type = "BW":U AND
        CAN-FIND(FIRST _tpbrwfld WHERE _tpbrwfld._brwname = _tpfield._widget) THEN
        PUT UNFORMATTED 
          'ON MOUSE-SELECT-DBLCLICK OF ':U _tpfield._widget ' IN FRAME ':U
                 _tpfield._frame ' DO:':U SKIP
          '  DEFINE VARIABLE x         AS INTEGER         NO-UNDO.':U SKIP
          '  DEFINE VARIABLE y         AS INTEGER         NO-UNDO.':U SKIP
          '  DEFINE VARIABLE first-col AS WIDGET-HANDLE   NO-UNDO.':U SKIP
          '  DEFINE VARIABLE next-col  AS WIDGET-HANDLE   NO-UNDO.':U SKIP
          '  DEFINE VARIABLE prev-col  AS WIDGET-HANDLE   NO-UNDO.':U SKIP (1)
          '  ASSIGN first-col = SELF:FIRST-COLUMN':U      SKIP
          '         next-col  = first-col:NEXT-COLUMN':U  SKIP
          '         prev-col  = first-col':U              SKIP
          '         x         = LAST-EVENT:X':U           SKIP
          '         y         = LAST-EVENT:y.':U          SKIP (1)
          '  IF CAN-QUERY(CurObj,"SELECTED":U) THEN':U    SKIP
          '    CurObj:SELECTED = FALSE.':U                SKIP (1)
          '  IF Y < SELF:HEIGHT-PIXELS - (SELF:DOWN * ':U SKIP
          '           FONT-TABLE:GET-TEXT-HEIGHT-PIXELS(SELF:FONT))':U SKIP
          '  THEN DO:':U                                  SKIP
          '    /* determine which column was dblclicked */':U          SKIP
          '    REPEAT WHILE ? <> next-col:':U             SKIP
          '      IF prev-col:X < x AND next-col:X > x THEN LEAVE.':U   SKIP
          '      ASSIGN prev-col = next-col':U            SKIP
          '             next-col = next-col:NEXT-COLUMN.':U            SKIP
          '    END.':U                                    SKIP
          '    CurObj = prev-col.':U                      SKIP
          '  END.':U                                      SKIP
          '  ELSE CurObj = SELF.':U                       SKIP
          '  RUN Properties IN hprops.':U                 SKIP
          'END.':U                                        SKIP (1).      
  END.
  
  PUT UNFORMATTED FrameTrigs SKIP.

  

  /* Now write out main window processing  */
  PUT UNFORMATTED
    'ON ENTRY OF TranWindow DO:':U SKIP
    '  IF VALID-HANDLE(TranWindow) THEN CurWin = TranWindow:HANDLE.':U SKIP
    'END.':U SKIP(1)
    'ON CLOSE OF THIS-PROCEDURE DO:':U SKIP
    '  RUN ShutDown IN hProps(THIS-PROCEDURE).':U SKIP
    '  RUN disable_UI.':U SKIP
    'END.':U SKIP (1)
    'ON WINDOW-CLOSE OF TranWindow DO:':U SKIP
    '  APPLY "CLOSE":U TO THIS-PROCEDURE.':U SKIP
    '  RETURN NO-APPLY.':U SKIP
    'END.':U SKIP (1)
    'ON ENDKEY, END-ERROR OF TranWindow ANYWHERE DO:':U SKIP
    '  APPLY "CLOSE":U TO THIS-PROCEDURE.':U SKIP
    '  RETURN NO-APPLY.':U SKIP
    'END.':U SKIP
    'PAUSE 0 BEFORE-HIDE.':U SKIP(1)

    'MAIN-BLOCK:':U SKIP     
    'DO ON ERROR UNDO main-block, LEAVE main-block':U SKIP
    '   ON END-KEY UNDO main-block, LEAVE main-block:':U SKIP
    '  ASSIGN TranWindow:X      = 30':U SKIP
    '         TranWindow:Y      = 80':U SKIP
    '         TranWindow:PARENT = MainWindow:HANDLE.':U SKIP (1)
    BtnImg
    '  RUN Enable_UI.':U SKIP(1). 
       
    /* Display first item of the combo-boxes if in GUI mode */
    IF tDispType <> "c":U THEN DO:
      FOR EACH _frame, EACH _tpfield WHERE _frame._frame = _tpfield._frame AND
               _tpfield._type = "CB":U
             BREAK BY _frame._frame:
        PUT UNFORMATTED '  IF ':U + _tpfield._widget + ':NUM-ITEMS > 0 THEN':U + CR +
                        '    ':U + _tpfield._widget + ':SCREEN-VALUE IN FRAME ':U +
                         _tpfield._frame + ' = ':U + _tpfield._widget + ':ENTRY(1).':U +
                         CR.
      END. /* FOR EACH Combo-Box or Fill-In */
    END.  /* If GUI MODE */

    /* Insert USE "". into the generated file to return PROGRESS to
     * PROGRESS.INI. This eliminates any conflicts between this
     * program's environment and TRANMAN's.  */
    IF INIFile <> "":U AND INIFile <> ? THEN
      PUT UNFORMATTED
        '  /* Revert to TranMans environment file */':U SKIP
        '  USE "".':U SKIP(1).

    /* INITIALize CurObj to be the first child widget of the window */
    PUT UNFORMATTED
        '  ASSIGN CurObj = ':U + (IF FirstField <> "":U
                           THEN FirstField + ':HANDLE.':U 
                           ELSE 'TranWindow:FIRST-CHILD.':U) SKIP(1).
    
     PUT UNFORMATTED   
    '  IF NOT THIS-PROCEDURE:PERSISTENT THEN WAIT-FOR CLOSE OF THIS-PROCEDURE.':U SKIP
    'END.':U SKIP
    'RETURN.':U SKIP(1)
    
    '/* Internal procedures ... */':U    SKIP  
    'PROCEDURE realize:':U               SKIP
    '  MESSAGE pFileName + " is already open." VIEW-AS ALERT-BOX TITLE "Open".' SKIP
    '  VIEW TranWindow.':U               SKIP 
    '  APPLY "ENTRY" TO TranWindow.':U   SKIP
    'END.':U                             SKIP(1)
    
    'PROCEDURE ADEPersistent:':U SKIP
    '  RETURN "OK".':U           SKIP
    'END.':U                     SKIP (1)

    'PROCEDURE Enable_UI:':U SKIP  
    '  DEFINE VARIABLE FrameGroup AS WIDGET-HANDLE NO-UNDO.':U SKIP
    '  DEFINE VARIABLE FrameCnt   AS INTEGER       NO-UNDO.':U SKIP  
    EnableAll SKIP 
    opqry.
    
    IF tDispType = "c":U THEN do i = 1 to 20:
      IF  tDispFrm[i] <> "":U THEN PUT UNFORMATTED tDispFrm[i]. 
    END.
    ELSE  PUT UNFORMATTED '  View TranWindow.':U SKIP.
    
    PUT UNFORMATTED
    '  RUN menulbl IN hprops(TranWindow).':U             SKIP(1)     
    '  FrameGroup = TranWindow:FIRST-CHILD.':U           SKIP  
    '  DO WHILE FrameGroup NE ?:':U                      SKIP
    '    FrameCnt  = FrameCnt + 1.':U                    SKIP
    '    RUN SetupLbl IN hprops(FrameGroup).':U          SKIP
    '    FrameGroup = FrameGroup:NEXT-SIBLING.':U        SKIP
    '  END.':U                                           SKIP
    '  IF FrameCnt > 1 THEN':U                           SKIP
    '    MESSAGE "Note: there are" FrameCnt "frames in this window."' SKIP
    '            VIEW-AS ALERT-BOX INFORMATION TITLE "Reminder".' SKIP  
    '  APPLY "ENTRY" TO TranWindow.':U                   SKIP
    'END.':U SKIP (1). 
 
    PUT UNFORMATTED
    'PROCEDURE Disable_UI:':U SKIP
    '/* standard disabling procedure */':U SKIP
    '  DELETE WIDGET TranWindow.':U SKIP
    '  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.':U SKIP
    'END.':U SKIP(1).  

    PUT UNFORMATTED
      'PROCEDURE side-label-setup.':U SKIP
      '  DEFINE INPUT PARAMETER ff-handle AS WIDGET-HANDLE NO-UNDO.':U SKIP
      '  DEFINE VARIABLE hSideLbl         AS WIDGET-HANDLE NO-UNDO.':U SKIP (1)
      '  hSideLbl = ff-handle:SIDE-LABEL-HANDLE.':U SKIP
      '  IF VALID-HANDLE(hSideLbl) THEN DO:':U      SKIP
      '    ASSIGN hSideLbl:SENSITIVE  = TRUE':U     SKIP
      '           hSideLbl:SELECTABLE = TRUE':U     SKIP
      '           hSideLbl:RESIZABLE  = TRUE.':U    SKIP
      '    ON SELECTION OF hsidelbl':U              SKIP
      '      PERSISTENT RUN select-fillin IN THIS-PROCEDURE (ff-handle).':U SKIP
      '  END.':U SKIP
      'END.  /* PROCEDURE side-label-setup */':U  SKIP (1).

    PUT UNFORMATTED
      'PROCEDURE select-fillin.':U    SKIP
      '  DEFINE INPUT PARAMETER ff-handle AS WIDGET-HANDLE NO-UNDO.':U SKIP
      '  CurObj = ff-handle.':U       SKIP
      '  RUN Properties IN hprops.':U SKIP
      'END. /* PROCEDURE select-fillin */':U SKIP (1).
   
  OUTPUT close.
  FileCreated = TRUE.
     
END PROCEDURE. /* BuildProcedure */     



PROCEDURE ReadBkgrndLiteral:
END PROCEDURE.

PROCEDURE ReadBkgrndExpr:
END PROCEDURE.

PROCEDURE ReadBkgrndSKIP:
END PROCEDURE.

PROCEDURE ReadBkgrndSpace:
END PROCEDURE.

PROCEDURE ReadBkgrndRectangle:
END PROCEDURE.

PROCEDURE ReadBkgrndImage:
END PROCEDURE.    

PROCEDURE ReadButton:
  CREATE _tpfield.
  RUN ReadCommon.
  ASSIGN _tpfield._label    = TRIM(InputLine[17])
         _tpfield._image-up = InputLine[22]
         _tpfield._no-label = _tpfield._label = ?
         _tpfield._tooltip  = InputLine[40].
  RUN ProcessImageFile.
END PROCEDURE.  /* ReadButton */

PROCEDURE ReadCommon:
  ASSIGN _tpfield._seq-num = Cntr
         _tpfield._frame   = CurFrame
         _tpfield._type    = TRIM(InputLine[1])
         _tpfield._widget  = TRIM(IF InputLine[2] = "":U
                                  THEN 'tCom':U + STRING(Cntr) ELSE InputLine[2])
         _tpfield._name    = InputLine[3].

  IMPORT InputLine.

  /* An exported field will be missing positions 4,5 & 6.
     So, if the fourth field is not "c" or "p" then we
     will assume that EXPORT is used in the code and that
     the remainder of the fields are reduced in position by 3  */
  IF InputLine[4] EQ "c":U OR InputLine[4] EQ "p":U THEN
    ASSIGN _tpfield._position-unit = InputLine[1]
           _tpfield._x             = DECIMAL(InputLine[2])
           _tpfield._y             = DECIMAL(InputLine[3])
           _tpfield._size-unit     = InputLine[4]
           _tpfield._width         = DECIMAL(InputLine[5])
           _tpfield._height        = DECIMAL(InputLine[6])
           _tpfield._color-mode    = InputLine[7]
           _tpfield._fgcolor       = INTEGER(InputLine[8])
           _tpfield._bgcolor       = INTEGER(InputLine[9])
           _tpfield._font          = INTEGER(InputLine[10])
           _tpfield._help          = InputLine[11]
           _tpfield._Table         = IF InputLine[15] = ?  /* A buffer */
                                       THEN InputLine[14] ELSE InputLine[15]
           _tpfield._Initial       = InputLine[16].
  ELSE
    ASSIGN _tpfield._position-unit = InputLine[1]
           _tpfield._x             = DECIMAL(InputLine[2])
           _tpfield._y             = DECIMAL(InputLine[3])
           _tpfield._size-unit     = "c":U
           _tpfield._width         = 0.00
           _tpfield._height        = 0.00
           _tpfield._color-mode    = InputLine[4]
           _tpfield._fgcolor       = INTEGER(InputLine[5])
           _tpfield._bgcolor       = INTEGER(InputLine[6])
           _tpfield._font          = INTEGER(InputLine[7])
           _tpfield._help          = InputLine[8]
           _tpfield._Table         = IF InputLine[12] = ?  /* A buffer */
                                       THEN InputLine[11] ELSE InputLine[12]
           _tpfield._Initial       = InputLine[13].

  IF _size-unit = "p":U /* PIXELS */ THEN
    ASSIGN _width  = _width / SESSION:PIXELS-PER-COLUMN
           _height = _height / SESSION:PIXELS-PER-ROW.
  IF _position-unit = "p":U /* PIXELS */ THEN
    ASSIGN _x = _x / SESSION:PIXELS-PER-COLUMN + 1
           _y = _y / SESSION:PIXELS-PER-ROW + 1.
  IF _x = 0 OR _y = 0 OR _width = ? OR _height = ? OR
     _width = 0 OR _height = 0 THEN tBadFile = TRUE.
END PROCEDURE.  /* ReadCommon */

PROCEDURE ReadBrowser:
  CREATE _tpfield.
  RUN ReadCommon.
  ASSIGN _tpfield._numdown    = INTEGER(InputLine[17])
         _tpfield._separators = InputLine[18] = "y":U
         _tpfield._multiple   = InputLine[19] = "y":U
         _tpfield._numcell    = INTEGER(InputLine[20])
         _tpfield._fld-title  = InputLine[21]
         _tpfield._fld-no-box = InputLine[27] = "y":U
         _tpfield._tooltip    = InputLine[37].

  CREATE _tpbrw.
  ASSIGN _tpbrw._fldseq  = _tpfield._seq-num
         _tpbrw._brwname = _tpfield._widget
         _tpbrw._brww    = _tpfield._width
         _tpbrw._brwh    = _tpfield._height
         _tpbrw._tooltip = InputLine[37].
END PROCEDURE. /* ReadBrowser */

PROCEDURE ReadBrwCol:
  CREATE _tpfield.
  ASSIGN _tpfield._seq-num = Cntr
         _tpfield._frame   = CurFrame
         _tpfield._type    = TRIM(InputLine[1])
         _tpfield._widget  = TRIM(InputLine[2])
         _tpfield._name    = InputLine[2].

  IMPORT InputLine.
  ASSIGN _tpfield._dbname    = InputLine[1]
         _tpfield._tblname   = InputLine[2]
         _tpfield._format    = TRIM(InputLine[4])
         _tpfield._data-type = INTEGER(InputLine[6])
         _tpfield._label     = TRIM(InputLine[7]).

  CREATE _tpbrwfld.
  ASSIGN _tpbrwfld._fldseq   = _tpfield._seq-num
         _tpbrwfld._brwname  = IF AVAILABLE _tpbrw THEN _tpbrw._brwname ELSE "":U
         _tpbrwfld._brwfld   = IF _tpfield._widget = "":U OR _tpfield._widget = ?
                               THEN "xtrns":U
                               ELSE IF INDEX("_1234567890":U,
                                  SUBSTRING(_tpfield._widget,1,1,"CHARACTER":U)) > 0
                               THEN "x":u + _tpfield._widget
                               ELSE _tpfield._widget.
END PROCEDURE. /* ReadBrwCol */

PROCEDURE ReadComboBox:
  DEFINE VARIABLE cTemp AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i     AS INTEGER   NO-UNDO.
 
  CREATE _tpfield.
  RUN ReadCommon.
  ASSIGN _tpfield._label       = TRIM(InputLine[19])
         _tpfield._inner-lines = INTEGER(InputLine[22])
         _tpfield._sort        = InputLine[24] = "y":U
         _tpfield._format      = TRIM(InputLine[28])
         _tpfield._data-type   = INTEGER(InputLine[30])
         _tpfield._no-label    = InputLine[28] = "y":U OR _tpfield._label = ?
         _tpfield._tooltip     = InputLine[32]
         _tpfield._style       = InputLine[23]  /* dl=drop-down-list; si=simple */
         _tpfield._list-item-pairs = InputLine[36] = "y":U
         cTemp = "":U
         i     = 0.
                              
  IF InputLine[27] NE "" AND InputLine[27] NE ? AND
     InputLine[27] NE "0":U THEN   /* Extent exists */
    ASSIGN _tpfield._widget = _tpfield._widget + "-":U + InputLine[27].

  InputLine = CHR(4).  /* Mark extents so we can tell where input data ends */
  IMPORT InputLine.  /* Get up to 100 list-items (50 list-item-pairs) */
  DO i = 1 TO 200 BY 2:  /* Strip out translation attributes (even #'ed entries) */
    IF InputLine[i] = CHR(4) THEN LEAVE.
    cTemp = cTemp + (IF i > 1 THEN ',"':U ELSE '"':U) + InputLine[i] + '"':U.
  END.
  _tpfield._list-items = cTemp.
END PROCEDURE. /* ReadComboBox */

PROCEDURE ReadEditor:
  CREATE _tpfield.
  RUN ReadCommon.
  ASSIGN _tpfield._label        = TRIM(InputLine[19])
         _tpfield._scrollbar-h  = InputLine[23] = "y":U
         _tpfield._scrollbar-v  = InputLine[24] = "y":U
         _tpfield._no-label     = _tpfield._label = ?
         _tpfield._tooltip      = InputLine[32].
  IF InputLine[30] NE "" AND InputLine[30] NE ? AND
     InputLine[30] NE "0":U THEN   /* Extent exists */
    ASSIGN _tpfield._widget = _tpfield._widget + "-":U + InputLine[30].

END PROCEDURE.  /* ReadEditor */

PROCEDURE ReadFillIn:
  CREATE _tpfield.
  RUN ReadCommon.
  ASSIGN _tpfield._literal-value = InputLine[17]
         _tpfield._col-label  = InputLine[19]
         _tpfield._label      = TRIM(InputLine[21])
         _tpfield._data-type  = INTEGER(InputLine[23])
         _tpfield._format     = TRIM(InputLine[24])
         _tpfield._valid-msg  = InputLine[26]
         _tpfield._valid-expr = InputLine[27]
         _tpfield._no-label   = InputLine[28] = "y":U or _tpfield._label = ?
         _tpfield._tooltip    = InputLine[35].

  IF InputLine[29] NE "" AND InputLine[29] NE ? AND
     InputLine[29] NE "0":U THEN   /* Extent exists */
    ASSIGN _tpfield._widget = _tpfield._widget + "-":U + InputLine[29]
           _tpfield._label = REPLACE(_tpfield._label,
                                     "[":U + InputLine[29] + "]":U, "":U).

  /* Cancel this field if the datatype  is greater than 100.  This would
     indicate that the field is a duplicate UIC for input purposes.      */
  IF _tpfield._data-type > 100 THEN DELETE _tpfield.
END PROCEDURE.  /* ReadFillIn */


PROCEDURE ReadFrame:
  /* See if a frame record exisits with this frame name */
  IF CAN-FIND(FIRST _frame WHERE _frame._widget = InputLine[2])
  THEN InputLine[2] = InputLine[2] + STRING(Cntr).
  CREATE _frame.
  ASSIGN _frame._frame_seq-num = Cntr
         _frame._widget        = IF InputLine[2] = "":U THEN 'tFrm':U + STRING(Cntr)
                                 ELSE InputLine[2]
         _frame._frame         = TRIM(_frame._widget)
         CurFrame              = _frame._frame
         _frame._name          = InputLine[3].

  IMPORT InputLine.
  ASSIGN _frame._position-unit    = InputLine[1]
         _frame._x                = DECIMAL(InputLine[2]) / 100
         _frame._y                = DECIMAL(InputLine[3]) / 100
         _frame._down             = INTEGER(InputLine[4])
         _frame._size-unit        = InputLine[5]
         _frame._width            = DECIMAL(InputLine[6]) / 100
         _frame._height           = DECIMAL(InputLine[7]) / 100
         _frame._font             = INTEGER(InputLine[8])
         _frame._title            = InputLine[9]
         _frame._title-color-mode = InputLine[11]
         _frame._title-bgcolor    = IF InputLine[11] = "7":U
                                    THEN INTEGER(InputLine[13])
                                    ELSE IF InputLine[11] = "6":U THEN -1
                                    ELSE ?
         _frame._title-fgcolor    = IF InputLine[15] = "7":U
                                    THEN INTEGER(InputLine[16])
                                    ELSE IF InputLine[15] = "6":U THEN -1
                                    ELSE ?
         _frame._title-font       = INTEGER(InputLine[14])
         _frame._color-mode       = InputLine[15]
         _frame._bgcolor          = IF InputLine[15] = "7":U
                                    THEN INTEGER(InputLine[17])
                                    ELSE IF InputLine[15] = "6":U THEN -1
                                    ELSE ?
         _frame._fgcolor          = IF InputLine[15] = "7":U
                                    THEN INTEGER(InputLine[16])
                                    ELSE IF InputLine[15] = "6":U THEN -1
                                    ELSE ?
         _frame._scrollable       = InputLine[22] = "y":U
         _frame._overlay          = InputLine[23] = "y":U
         _frame._top-only         = InputLine[24] = "y":U
         _frame._no-box           = InputLine[25] = "y":U
         _frame._no-labels        = InputLine[27] = "y":U
         _frame._side-labels      = InputLine[28] = "y":U
         _frame._no-hide          = InputLine[29] = "y":U
         _frame._page-bottom      = InputLine[30] = "y":U
         _frame._page-top         = InputLine[31] = "y":U
         _frame._no-attr-space    = InputLine[32] = "y":U
         _frame._dialog-box       = InputLine[33] = "y":U
         _frame._browse           = InputLine[34] = "y":U
         _frame._iteration-height = DECIMAL(InputLine[35]) / 100
         _frame._header-height    = DECIMAL(InputLine[36]) / 100
         _frame._no-underline     = InputLine[39] = "y":U
         _frame._no-validate      = InputLine[40] = "y":U
         _frame._three-d          = InputLine[41] = "y":U
         _frame._keep-tab-order   = InputLine[42] = "y":U.

  IF _size-unit = "p":U /* PIXELS */ THEN
    ASSIGN _width  = (100 * _width) / SESSION:PIXELS-PER-COLUMN
           _height = (100 * _height) / SESSION:PIXELS-PER-ROW.
  IF _position-unit = "p":U /* PIXELS */ THEN
    ASSIGN _x = _x / SESSION:PIXELS-PER-COLUMN + 1
           _y = _y / SESSION:PIXELS-PER-ROW + 1.

  IF _frame._height < 2 THEN
    ASSIGN _frame._height  = {&DefWinHeight}
           _frame._width   = MAX(_frame._width, {&DefWinWidth})
           _frame._overlay = TRUE
           tCalPos         = TRUE
           _frame._down    = 1.
  IF _frame._x = ? THEN _frame._x = 1.00.
END PROCEDURE.  /* ReadFrame */



PROCEDURE ReadHeaderLiteral:
END PROCEDURE.

PROCEDURE ReadHeaderExpr:
END PROCEDURE.

PROCEDURE ReadHeaderSKIP:
END PROCEDURE.

PROCEDURE ReadHeaderSpace:
END PROCEDURE.

PROCEDURE os-err:
  DEFINE input PARAMETER msg    AS CHARACTER NO-UNDO.
  DEFINE input PARAMETER errnum AS INTEGER   NO-UNDO.

  MESSAGE msg SKIP "OS Error #":U + STRING(errnum)
    VIEW-AS ALERT-BOX error buttons ok.
END PROCEDURE.  /* os-err */

PROCEDURE ProcessImageFile:
  /*  This PROCEDURE ensures that the image file can be 
      located when running the .RC file                  */
  DEFINE VARIABLE DirName  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE BaseName AS CHARACTER NO-UNDO.   
  DEFINE VARIABLE ii       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tmp      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ext      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE os-rc    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE errcode  AS INTEGER   NO-UNDO.
  
  IF LOOKUP(_tpfield._image-up,   /* These are the buyilt in images - no-files */
            "BTN-UP-ARROW,BTN-DOWN-ARROW,BTN-LEFT-ARROW,BTN-RIGHT-ARROW":U) > 0 
  THEN RETURN.
  
  IF NOT AVAILABLE xlatedb.xl_project THEN
    FIND FIRST xlatedb.xl_project NO-LOCK NO-ERROR.
    
  RUN adecomm/_osprefx.p (INPUT _tpfield._image-up, OUTPUT DirName, OUTPUT BaseName). 
  RUN adecomm/_osfext.p  (INPUT BaseName, OUTPUT ext).    
  IF ext EQ "" THEN DO: 
    /* IF the image filename does not have an extention,
       (i.e. implied for portability) then we'll have to
       determine it since we can't copy the file w/o it    */
    ASSIGN ii                  = _tpfield._image-up + ".bmp":U
           FILE-INFO:FILE-NAME = ii.
    IF FILE-INFO:FULL-PATHNAME EQ ? THEN
      ASSIGN _tpfield._image-up = _tpfield._image-up + ".ico":U.
    ELSE 
      ASSIGN _tpfield._image-up = _tpfield._image-up + ".bmp":U.
  END.
  RUN adecomm/_osprefx.p (INPUT _tpfield._image-up, OUTPUT DirName, OUTPUT BaseName).
  DirName = REPLACE(DirName,"/":U,"{&SLASH}":U).
  ASSIGN FILE-INFO:FILE-NAME = REPLACE(_tpfield._image-up,"/":U,"{&SLASH}":U).
  IF  Dirname <> "":U AND DirName NE ".\":U THEN DO:
    IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
      IF FILE-INFO:FILE-NAME <> FILE-INFO:FULL-PATHNAME THEN DO: /* relative pathname */
        FILE-INFO:FILE-NAME = DirName.
        RUN Create_Path(INPUT  xlatedb.xl_project.RootDirectory +
                               "{&SLASH}":U + right-TRIM(DirName,"{&SLASH}":U),
                        OUTPUT errcode).
        IF errcode > 0 THEN 
          RUN os-err ( INPUT "Error creating directory: " +  
                             xlatedb.xl_project.RootDirectory + 
                             "{&SLASH}":U + right-TRIM(DirName,"{&SLASH}":U), 
                       INPUT errcode).
        OS-COPY VALUE(FILE-INFO:FULL-PATHNAME + "{&SLASH}":U + BaseName)
                VALUE(xlatedb.xl_project.RootDirectory + "{&SLASH}":U + DirName + BaseName).
        ASSIGN os-rc = OS-ERROR.
        IF os-rc > 0 THEN
          RUN os-err ( INPUT "Error copying file: " + FILE-INFO:FULL-PATHNAME + 
                        "{&SLASH}":U + BaseName + " to: " +
            xlatedb.xl_project.RootDirectory + "{&SLASH}":U + DirName + BaseName, INPUT os-rc).
        ASSIGN _tpfield._image-up = DirName + BaseName.
      END. /* if relative pathname */  
      ELSE DO: /* full pathname */
        ASSIGN tmp = SUBSTRING(DirName,index(Dirname,"{&SLASH}":U),-1,"CHARACTER":U)
               tmp = RIGHT-TRIM(tmp,"{&SLASH}":U).
        RUN Create_Path(INPUT  xlatedb.xl_project.RootDirectory + tmp, OUTPUT errcode).
        IF errcode > 0 THEN 
          RUN os-err ( INPUT "Error creating directory: " + 
                             xlatedb.xl_project.RootDirectory + tmp, 
                       INPUT os-rc).
        OS-COPY VALUE(_tpfield._image-up) VALUE(xlatedb.xl_project.RootDirectory + tmp).
        ASSIGN os-rc = OS-ERROR.
        IF os-rc > 0 THEN
          RUN os-err ( INPUT "Error copying file: " + _tpfield._image-up + " to: " +
            xlatedb.xl_project.RootDirectory + tmp, INPUT os-rc).
        ASSIGN _tpfield._image-up = LEFT-TRIM(tmp,"{&SLASH}":U) + (IF tmp NE "":U 
                  THEN "{&SLASH}":U ELSE "":U) + basename.
      END.  /* If full pathname */
    END.  /* If pathname not ? */
    ELSE ASSIGN _tpfield._image-up = ?.
  END.  /* If Dirname not blank or current directory */
  ELSE DO:  /* Dirname is either blank or the current directory */
    IF DirName = ".\":U THEN DO:
      OS-COPY VALUE(_tpfield._image-up) VALUE(xlatedb.xl_project.RootDirectory).
      ASSIGN os-rc = OS-ERROR.
      IF os-rc > 0 THEN
        RUN os-err ( INPUT "Error copying file: " + _tpfield._image-up + " to: " +
          xlatedb.xl_project.RootDirectory, INPUT os-rc).
      ASSIGN _tpfield._image-up = BaseName.
    END.
    ELSE DO:
      OS-COPY VALUE(_tpfield._image-up) VALUE(xlatedb.xl_project.RootDirectory).
      ASSIGN os-rc = OS-ERROR.
      IF os-rc > 0 THEN
        RUN os-err ( INPUT "Error copying file: " + _tpfield._image-up + " to: " +
          xlatedb.xl_project.RootDirectory, INPUT os-rc).
      ASSIGN _tpfield._image-up = _tpfield._image-up.              
    END.
  END.
END PROCEDURE.  /* ProcessImageFile */

PROCEDURE Create_Path:
  /* Creates a path (i.e. it's careful to create all the directories down a path) */
  
  DEFINE INPUT  PARAMETER path    AS CHARACTER          NO-UNDO.
  DEFINE OUTPUT PARAMETER errcode AS INTEGER  INITIAL 0 NO-UNDO.

  RUN adecomm/_oscpath.p (INPUT path, OUTPUT errcode).
END PROCEDURE.  /* Create_Path */

PROCEDURE ReadImage:
  CREATE _tpfield.
  RUN ReadCommon.
  ASSIGN _tpfield._image-up = InputLine[17]
         _tpfield._no-label = TRUE 
         _tpfield._tooltip = InputLine[20].
  RUN ProcessImageFile.
END PROCEDURE.  /* RedImge */

PROCEDURE ReadLiteral:  
  /* Manufacture a text variable widget  */
  TextLiteral = TextLiteral + 1. 
  CREATE _tpfield.
  RUN ReadCommon.
  ASSIGN _tpfield._widget    = 'TEXT-':U + TRIM(STRING(TextLiteral))
         _tpfield._label     = TRIM(InputLine[17])
         _tpfield._no-label  = TRUE
         _tpfield._tooltip  = InputLine[19].
END PROCEDURE. /* ReadLiteral */

PROCEDURE ReadOnlyMenu:
END PROCEDURE.

PROCEDURE ReadMenuCascade: 
       /* MC */    
    CREATE _tpfield.             
    ASSIGN _tpfield._seq-num = Cntr
           _tpfield._frame   = "":U
           _tpfield._type    = TRIM(InputLine[1]).
    
    IMPORT InputLine.
    ASSIGN _tpfield._widget  = TRIM(InputLine[4])
           _tpfield._Label   = TRIM(InputLine[1])
           _tpfield._name    = "":U
           _tpfield._format  = "SUB-MENU":U
           _tpfield._initial = tMenu.
END PROCEDURE.  /* ReadMenuCascade */

PROCEDURE ReadMenuItem:   
  CREATE _tpfield.
  ASSIGN _tpfield._seq-num  = Cntr    
         _tpfield._type     = InputLine[1]
         _tpfield._frame    = "":U.
  IMPORT InputLine.
  ASSIGN _tpfield._widget   = TRIM(InputLine[3])
         _tpfield._Label    = TRIM(InputLine[1])
         _tpfield._name     = InputLine[3]
         _tpfield._format   = "MENU-ITEM":U
         _tpfield._initial  = tMenu.                                       
    
  CREATE _tpmnufld.
  ASSIGN _tpmnufld._fldseq  = _tpfield._seq-num
         _tpmnufld._type    = _tpfield._type
         _tpmnufld._parmnu  = parname
         _tpmnufld._mnuname = tMenu
         _tpmnufld._mnufld  = _tpfield._widget.
END PROCEDURE.  /* ReadMenuItem */

PROCEDURE ReadSubMenu:   
  /*  MU */
  CREATE _tpfield.
  ASSIGN _tpfield._seq-num = Cntr
         _tpfield._frame   = "":U
         _tpfield._type    = TRIM(InputLine[1])
         _tpfield._widget  = TRIM(InputLine[2])
         _tpfield._initial = tMenu.
  IMPORT InputLine.  
  IF InputLine[7] = "Y":U THEN tMenuBar = "B":U.
  ELSE IF InputLine[7] = "N":U AND tMenuBar = "":U THEN  tMenuBar = "P":U.
          
  IF MenuName = "":U AND tMenuBar = "B":U THEN
    ASSIGN _tpfield._name    = "MENUBAR":U
           _tpfield._format  = "MENU":U
           MenuName          = 'ASSIGN tranwindow:MENUBAR = MENU ':U +
                                _tpfield._widget + ':HANDLE.':U
           tMenu             = _tpfield._widget
           _tpfield._initial = tMenu.
  ELSE IF tMenuBar = "P":U THEN
    ASSIGN _tpfield._name    = "":U
           _tpfield._format  = "MENU":U
           tMenu             = _tpfield._widget
           _tpfield._initial = tMenu
           PopMenu           = "YES":U.
  ELSE DO:                       
    ASSIGN _tpfield._format  = "SUB-MENU":U
           _tpfield._initial = tMenu
           parname           = _tpfield._widget.          
    CREATE _tpmnufld.
    ASSIGN _tpmnufld._fldseq = _tpfield._seq-num
           _tpmnufld._type    =  _tpfield._type
           _tpmnufld._parmnu  = parname
           _tpmnufld._mnuname = tMenu
           _tpmnufld._mnufld  = _tpfield._widget.       
  END.        
END PROCEDURE. /* RedSubMenu */

PROCEDURE ReadMenuStatic:   
  CREATE _tpfield.
  ASSIGN _tpfield._seq-num = Cntr
         _tpfield._frame   = "":U
         _tpfield._type    = TRIM(InputLine[1])
         _tpfield._widget  = IF _type = "ML":U THEN "RULE":U ELSE "SKIP":U
         _tpfield._initial = tMenu.          
    
  IF MenuName = "":U
  THEN ASSIGN _tpfield._name   = "MENUBAR":U
              _tpfield._format = "MENU":U.
  ELSE ASSIGN _tpfield._format = "SUB-MENU":U.          
     
  CREATE _tpmnufld.
  ASSIGN _tpmnufld._fldseq  = _tpfield._seq-num
         _tpmnufld._type    = _tpfield._type
         _tpmnufld._parmnu  = parname
         _tpmnufld._mnuname = tMenu
         _tpmnufld._mnufld  = _tpfield._widget.           
END PROCEDURE.  /* ReadMenuStatic */


PROCEDURE ReadRectangle:
  CREATE _tpfield.
  RUN ReadCommon.
  ASSIGN _tpfield._edge-pixels = INTEGER(InputLine[17])
         _tpfield._no-fill     = InputLine[18] = "y":U
         _tpfield._no-label    = TRUE
         _tpfield._tooltip     = InputLine[19].
END PROCEDURE.  /* RedRectangle */

PROCEDURE ReadRadioSet:
  DEFINE VARIABLE CurrentFilePos AS INTEGER   NO-UNDO.
  DEFINE VARIABLE scrn-value     AS CHARACTER NO-UNDO.   
  
  CREATE _tpfield.
  RUN ReadCommon.
  ASSIGN _tpfield._col-label     = InputLine[17]  
         _tpfield._label         = TRIM(InputLine[19])
         _tpfield._orientation   = InputLine[21]
         _tpfield._data-type     = INTEGER(InputLine[22])  
         _tpfield._expand        = InputLine[25] = "y":U
         _tpfield._no-label      = _tpfield._label = ?
         _tpfield._tooltip       = InputLine[26]
         scrn-value              = "":U.
  IF InputLine[24] NE "" AND InputLine[24] NE ? AND
     InputLine[24] NE "0":U THEN   /* Extent exists */
    ASSIGN _tpfield._widget = _tpfield._widget + "-":U + InputLine[24].

  ReadAllBtns:
  REPEAT ON ENDKEY UNDO, RETRY:
    IF retry THEN LEAVE ReadAllBtns.
    CurrentFilePos = SEEK(INPUT).

    IMPORT InputLine.
    IF InputLine[1] <> "RB":U THEN LEAVE ReadAllBtns.
    IMPORT InputLine.
    scrn-value = scrn-value + '"':U + InputLine[1] + '",':U + 
                 (IF _data-type = 1 THEN '"':U + InputLine[3] + '",':U
                 ELSE InputLine[3] + ',':U).
  END.
  ASSIGN scrn-value           = right-TRIM(scrn-value,',':u)
         _tpfield._list-items = TRIM(scrn-value).    
  
  /* return pointer to "RS" record  */
  SEEK INPUT TO CurrentFilePos. 
END PROCEDURE.  /* ReadRdioSet */

PROCEDURE ReadSelectionList: 
  DEFINE VARIABLE cTemp AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i     AS INTEGER   NO-UNDO.

  CREATE _tpfield.
  RUN ReadCommon.
  ASSIGN _tpfield._label         = TRIM(InputLine[17])
         _tpfield._multiple      = InputLine[23] = "y":U
         _tpfield._sort          = InputLine[25] = "y":U
         _tpfield._scrollbar-h   = InputLine[27] = "y":U
         _tpfield._scrollbar-v   = InputLine[28] = "y":U
         _tpfield._no-label      = _label = ?
         _tpfield._tooltip       = InputLine[31]
         _tpfield._list-item-pairs = InputLine[35] = "y"
         cTemp = "":U
         i     = 0.

  IF InputLine[30] NE "" AND InputLine[30] NE ? AND
     InputLine[30] NE "0":U THEN   /* Extent exists */
    ASSIGN _tpfield._widget = _tpfield._widget + "-":U + InputLine[30].

  InputLine = CHR(4).  /* Mark extents so we can tell where input data ends */
  IMPORT InputLine.  /* Get up to 100 list-items (50 list-item-pairs) */
  DO i = 1 TO 200 BY 2:  /* Strip out translation attributes (even #'ed entries) */
    IF InputLine[i] = CHR(4) THEN LEAVE.
    cTemp = cTemp + (IF i > 1 THEN ',"':U ELSE '"':U) + InputLine[i] + '"':U.
  END.
  _tpfield._list-items = cTemp.
END PROCEDURE.  /* ReadSelectionList */

PROCEDURE ReadSlider:
  CREATE _tpfield.
  RUN ReadCommon.
  ASSIGN _tpfield._label         = TRIM(InputLine[19])
         _tpfield._min-value     = INTEGER(InputLine[21])
         _tpfield._max-value     = INTEGER(InputLine[22])
         _tpfield._orientation   = InputLine[23]
         _tpfield._no-label      = _label = ?
         _tpfield._tooltip       = InputLine[30].
  IF InputLine[25] NE "" AND InputLine[25] NE ? AND
     InputLine[25] NE "0":U THEN   /* Extent exists */
    ASSIGN _tpfield._widget = _tpfield._widget + "-":U + InputLine[25].

END PROCEDURE.  /* ReadSlider */

PROCEDURE ReadToggleBox:
  CREATE _tpfield.
  RUN ReadCommon.
  ASSIGN _tpfield._label        = TRIM(InputLine[17])
         _tpfield._no-label     = _label = ?
         _tpfield._tooltip      = InputLine[21].   

  IF InputLine[20] NE "" AND InputLine[20] NE ? AND
     InputLine[20] NE "0":U THEN   /* Extent exists */
    ASSIGN _tpfield._widget = _tpfield._widget + "-":U + InputLine[20].
END PROCEDURE.  /* ReadToggleBox */

PROCEDURE ReadVariableText:
/* Why aren't we processing? Label, tooltip etc?
 * label = inputline[21]
 * format = inputline[24]
 * extent = inputline[29]
 * tooltip = inputline[35] ?
 */
END PROCEDURE.

PROCEDURE DispFlds:
/* DispFlds simulates a character display of the Buttons, Toggle Boxes,
   Combo-boxes and Fill-ins                                             */
DEFINE INPUT        PARAMETER pType   AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pLabel  AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pInit   AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pWidth  AS DECIMAL   NO-UNDO.
DEFINE OUTPUT       PARAMETER pformat AS CHARACTER NO-UNDO.
DEFINE OUTPUT       PARAMETER pScreen AS CHARACTER NO-UNDO.

CASE pType:
  WHEN "BU":U THEN DO:   /* Button */
    ASSIGN txt = TRIM(pLabel).
    IF LENGTH(txt, "CHARACTER":U) > (pWidth) - 2 THEN DO:
      IF (pWidth) < 1.5 THEN ASSIGN txt = "<":U.
      ELSE IF (pWidth) < 2.5 THEN ASSIGN txt = "<>":U.
      ELSE ASSIGN txt = "<":U + SUBSTRING(txt,
                                INTEGER((LENGTH(txt, "CHARACTER":U) + 3 - (pWidth)) / 2),
                                INTEGER(pWidth) - 2, "CHARACTER":U) + ">":U.
    END.  /* IF length > width - 2 */
    ELSE DO:  /* Label will fit */
      ASSIGN i-fill  = INTEGER(((pWidth) - LENGTH(txt, "CHARACTER":U) - 2) / 2)
             txt     = "<":U + FILL(" ":U, i-fill) + txt +
                               FILL(" ":U, INTEGER((pWidth) - 2 -
                               i-fill -  LENGTH(txt, "CHARACTER":U))) + ">":U.

    END.  /* Label will fit */
    ASSIGN pWidth     = LENGTH(txt, "CHARACTER":U)
           pFormat    = "X(":U + STRING(LENGTH(txt, "CHARACTER":U)) + ")":U
           pScreen    = txt.
  END.  /* Case BU */

  WHEN "TB":U THEN DO: /* Toggle Box */
   ASSIGN txt      = TRIM(pLabel)
          txt      = (IF CAN-DO("YES,TRUE":U,pInit) THEN "[X]":U  ELSE "[ ]":U) + txt
          pformat  = "X(":U + STRING(LENGTH(txt, "CHARACTER":U)) + ")":U
          pscreen  = txt
          pwidth   = IF pWidth = 0 THEN LENGTH(txt, "CHARACTER":U)
                                   ELSE INTEGER(pwidth).
  END.  /* Toggle Box */

  WHEN "CB":U THEN DO:   /* Combo-box */
    ASSIGN txt = IF pInit = ? THEN "_":U ELSE STRING(pInit)
           txt = IF LENGTH(txt, "CHARACTER":U) >= pWidth - 3
                   THEN SUBSTRING(txt,1, INTEGER(pWidth) - 3, "CHARACTER":U) + "[V]":U
                   ELSE txt + FILL("_":U,INTEGER(pWidth) - 4 - 
                                                 LENGTH(txt, "CHARACTER":U)) + "[V]":U
                 pFormat = "X(":U + STRING((LENGTH(txt, "CHARACTER":U) + 1)) + ")":U
                 pScreen = txt.
  END.  /* CB */

  WHEN "FF":U THEN DO: /* Fill-in Field */
    ASSIGN txt = IF pInit = ? THEN "_":U ELSE STRING(pInit)
           txt = IF LENGTH(txt, "CHARACTER":U) >= pWidth
                  THEN SUBSTRING(txt,1, INTEGER(pWidth), "CHARACTER":U)
                  ELSE txt + FILL("_":U, INTEGER(pWidth) - LENGTH(txt, "CHARACTER":U))
           pformat  = /* IF _F._DATA-TYPE NE "Character":U AND
                              _cur_win_type THEN _F._FORMAT ELSE */
                      "X(":U + STRING(MAX(1,LENGTH(txt,"CHARACTER":U))) + ")":U
           pscreen = txt.
  END.  /* FF */
END CASE.
END PROCEDURE.  /* DispFlds */
