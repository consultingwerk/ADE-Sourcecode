&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:   File: _locases.p

  Description:
     The procedure is called from _gen4gl.p and produces an internal procedure
     with a single "CASE" statement that produces run-time layout changes to the
     current layout at run-time based on the "Layout Name" that is passed as an
     INPUT parameter.

  Input Parameters:
      pLayout-var : the name of the variable used in the .w file to store the
                    value (string) for the active layout.  This variable 
                    equals the "{&WINDOW-NAME}-layout".

  Output Parameters:
      <none>

  Author: D. Ross Hunter

  Created: 5/12/93

  Modified:
    wood 9/27/95 Added "Special" type "_LAYOUT-CASES" to the procedure
    wood 6/28/96 Remove NO-BOX, NO-LABELS, NO-UNDERLINE support 
                 (because it did not work Bug # 96-06-24-033)
    tsm 06/11/99 Added support for editable combo-box (height can be modified)
    tsm 06/15/99 Added support for separator-fgcolor for browse widget
----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pLayout-var AS CHAR NO-UNDO.

/* ======================================================================== */
/*                       SHARED VARIABLES Definitions                       */
/* ======================================================================== */
{adeuib/uniwidg.i}           /* Universal widget TEMP-TABLE definitions     */
{adeuib/layout.i}            /* Definitions of the layout records           */
{adeuib/sharvars.i}          /* UIB shared variables                        */

/* FUNCTION PROTOTYPE */
FUNCTION db-fld-name RETURNS CHARACTER
  (INPUT rec-type AS CHARACTER, INPUT rec-recid AS RECID) IN _h_func_lib.

&SCOPED-DEFINE BGC           1
&SCOPED-DEFINE COL           2
&SCOPED-DEFINE CONV-3D       3
&SCOPED-DEFINE EDGE-P        4
&SCOPED-DEFINE FGC           5
&SCOPED-DEFINE FILLED        6
&SCOPED-DEFINE FOCUS         7
&SCOPED-DEFINE FONT          8
&SCOPED-DEFINE GRAPHIC       9
&SCOPED-DEFINE GROUP-BOX     10
&SCOPED-DEFINE HEIGHT        11
&SCOPED-DEFINE REMOVE        12
&SCOPED-DEFINE ROUNDED       13
&SCOPED-DEFINE ROW           14
&SCOPED-DEFINE SEPS          15
&SCOPED-DEFINE SFGC          16
&SCOPED-DEFINE TTL-BGC       17
&SCOPED-DEFINE TTL-FGC       18
&SCOPED-DEFINE V-HGT         19
&SCOPED-DEFINE V-WDT         20
&SCOPED-DEFINE WIDTH         21


/* ************************ Local Definitions ************************* */

DEFINE VARIABLE fram_exp   AS CHARACTER NO-UNDO.
DEFINE VARIABLE f_e_len    AS INTEGER NO-UNDO.
DEFINE VARIABLE differ     AS LOGICAL NO-UNDO.
DEFINE VARIABLE first-lo   AS LOGICAL INITIAL TRUE NO-UNDO. 
DEFINE VARIABLE l_assign   AS LOGICAL NO-UNDO.
DEFINE VARIABLE l_set-pos  AS LOGICAL NO-UNDO.
DEFINE VARIABLE l_set-size AS LOGICAL NO-UNDO.
DEFINE VARIABLE tol        AS DECIMAL INITIAL .03 NO-UNDO.
DEFINE VARIABLE w_NAME     AS CHARACTER NO-UNDO.
DEFINE VARIABLE w_n_len    AS INTEGER NO-UNDO.
DEFINE VARIABLE wrttn      AS LOGICAL  EXTENT 21 NO-UNDO.

/* Define a temp-table to store the recids of containers that we hid prior
   to changing their geometry. */
DEFINE TEMP-TABLE tt
  FIELD _order AS INTEGER
  FIELD _name AS CHAR
  FIELD _u-recid AS RECID 
  FIELD _code AS CHARACTER
  INDEX _order IS PRIMARY _order _name.
  .

DEFINE SHARED STREAM P_4GL.
DEFINE BUFFER w_U FOR _U.
DEFINE BUFFER f_U FOR _U.
DEFINE BUFFER f_L FOR _L.
DEFINE BUFFER m_L FOR _L.
DEFINE BUFFER put_L FOR _L.

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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

FIND w_U WHERE w_U._HANDLE = _h_win.     /* w_U is the _U record for the    */
                                         /* current window                  */
PUT STREAM P_4GL UNFORMATTED SKIP (1)
  "~&ANALYZE-SUSPEND _UIB-CODE-BLOCK  _PROCEDURE " pLayout-var + "s _LAYOUT-CASES":U SKIP
  "PROCEDURE " + pLayout-var + "s:"                                       SKIP
  "  DEFINE INPUT PARAMETER layout AS CHARACTER                     NO-UNDO."
                                                                          SKIP
  "  DEFINE VARIABLE lbl-hndl AS WIDGET-HANDLE                      NO-UNDO."
                                                                          SKIP
  "  DEFINE VARIABLE widg-pos AS DECIMAL                            NO-UNDO."
                                                                          SKIP (1)
  "  /* Copy the name of the active layout into a variable accessible to   */" 
  SKIP 
  "  /* the rest of this file.                                             */" 
  SKIP
  "  " + pLayout-var + " = layout."                                       SKIP (1)
  "  CASE layout:"                                                        SKIP.

/* First put out Master Layout case  - only put out things that are changed in 
   some other layout                                                               */
PUT STREAM P_4GL UNFORMATTED
        "    WHEN ~"Master Layout~" THEN DO:"                             SKIP.

Master-WIDGET-BLOCK:      
FOR EACH m_L WHERE m_L._LO-NAME = "Master Layout",
    EACH  _U WHERE RECID(_U) = m_L._U-recid AND _U._WINDOW-HANDLE = _h_win 
               AND _U._STATUS NE "DELETED":U       
       BY IF _U._TYPE = "WINDOW":U THEN 1 ELSE
          IF CAN-DO("DIALOG-BOX,FRAME":U,_U._TYPE) THEN 2 ELSE 3
       BY _U._NAME:
  /* Special Cases where we don't write out the layout information because the
     widgets don't really exist. (i.e. "Text" widgets and design-windows) */       
  IF (_U._TYPE = "TEXT":U ) OR
     (_U._TYPE = "WINDOW":U AND _U._SUBTYPE EQ "Design-Window":U)
  THEN NEXT Master-WIDGET-BLOCK.
  
  /* Force tolerance on everything */
  FOR EACH _L WHERE _L._LO-NAME NE "Master Layout" AND
                    _L._u-recid = m_L._u-recid:

    IF CAN-DO("WINDOW,DIALOG-BOX":U,_U._TYPE) THEN 
      ASSIGN _L._ROW = m_L._ROW
             _L._COL = m_L._COL.
             
    IF _U._TYPE = "COMBO-BOX":U AND _U._SUBTYPE NE "SIMPLE":U THEN
      ASSIGN _L._HEIGHT  = 1
             m_L._HEIGHT = 1.
    
    IF _L._COL < m_L._COL + tol AND _L._COL > m_L._COL - tol THEN
                                            _L._COL           = m_L._COL.
    IF _L._HEIGHT < m_L._HEIGHT + tol AND _L._HEIGHT > m_L._HEIGHT - tol THEN
                                            _L._HEIGHT        = m_L._HEIGHT.
    IF _L._ROW < m_L._ROW + tol AND _L._ROW > m_L._ROW - tol THEN
                                            _L._ROW           = m_L._ROW.
    IF _L._VIRTUAL-HEIGHT < m_L._VIRTUAL-HEIGHT + tol AND
       _L._VIRTUAL-HEIGHT > m_L._VIRTUAL-HEIGHT - tol THEN
                                           _L._VIRTUAL-HEIGHT = m_L._VIRTUAL-HEIGHT.
    IF _L._VIRTUAL-WIDTH < m_L._VIRTUAL-WIDTH + tol AND
       _L._VIRTUAL-WIDTH > m_L._VIRTUAL-WIDTH - tol THEN
                                           _L._VIRTUAL-WIDTH  = m_L._VIRTUAL-WIDTH.
    IF _L._WIDTH < m_L._WIDTH + tol AND _L._WIDTH > m_L._WIDTH - tol THEN 
                                           _L._WIDTH          = m_L._WIDTH.
    IF NOT _L._WIN-TYPE THEN DO:
      ASSIGN _L._BGCOLOR           = m_L._BGCOLOR
             _L._FGCOLOR           = m_L._FGCOLOR
             _L._SEPARATOR-FGCOLOR = m_L._SEPARATOR-FGCOLOR
             _L._TITLE-BGCOLOR     = m_L._TITLE-BGCOLOR
             _L._TITLE-FGCOLOR     = m_L._TITLE-FGCOLOR
             _L._FONT              = m_L._FONT.
      /* Set Minimum sizes for TTY widgets NEEDS TO BE IMPROVED FOR 7.3B */
      IF CAN-DO("RECTANGLE,BUTTON,COMBO-BOX,FILL-IN,TEXT",_U._TYPE) THEN DO:
        IF _L._HEIGHT < 1 OR _L._WIDTH < 1 THEN  RUN adjust-size (1, 1).
      END.
      ELSE IF _U._TYPE = "EDITOR":U AND NOT _U._SCROLLBAR-V THEN DO:
        IF _L._HEIGHT < 1 OR _L._WIDTH < 3 THEN  RUN adjust-size (1, 3).
      END.
      ELSE IF CAN-DO("RADIO-SET,SELECTION-LIST,EDITOR",_U._TYPE) THEN DO:
        IF _L._HEIGHT < 3 OR _L._WIDTH < 3 THEN  RUN adjust-size (3, 3).
      END.
      ELSE IF _U._TYPE = "TOGGLE-BOX" THEN DO:
        IF _L._HEIGHT < 1 OR _L._WIDTH < 3 THEN  RUN adjust-size (1, 3).
      END.
      ELSE IF _U._TYPE = "SLIDER" THEN DO:
        FIND _F WHERE RECID(_F) = _U._x-recid.
        IF _F._HORIZONTAL AND (_L._HEIGHT < 2 OR _L._WIDTH < 7) THEN
            RUN adjust-size (2, 7).
        IF NOT _F._HORIZONTAL AND (_L._HEIGHT < 3 OR _L._WIDTH < 9) THEN
            RUN adjust-size (3, 9).
      END.  /* Slider */
    END.  /* TTY Mode */
  END. /* FOR EACH _L */

  /* Skip image info for Character representations */
  IF _U._TYPE = "IMAGE" AND NOT m_L._WIN-TYPE THEN NEXT Master-WIDGET-BLOCK.
  
  ASSIGN differ   = FALSE
         wrttn    = FALSE
         l_assign = FALSE.
  
  FOR EACH _L WHERE _L._LO-NAME NE "Master Layout" AND
                    _L._u-recid = m_L._u-recid:
    IF _L._BGCOLOR NE m_L._BGCOLOR           OR _L._COL NE m_L._COL               OR
       _L._CONVERT-3D-COLORS NE m_L._CONVERT-3D-COLORS OR
       _L._EDGE-PIXELS NE m_L._EDGE-PIXELS   OR _L._FGCOLOR NE m_L._FGCOLOR       OR
       _L._FILLED NE m_L._FILLED             OR _L._FONT NE m_L._FONT             OR
       _L._GRAPHIC-EDGE NE m_L._GRAPHIC-EDGE OR _L._NO-FOCUS NE m_L._NO-FOCUS     OR
       _L._HEIGHT NE m_L._HEIGHT                                                  OR
       _L._REMOVE-FROM-LAYOUT NE m_L._REMOVE-FROM-LAYOUT                          OR
       _L._ROW NE m_L._ROW                   OR _L._SEPARATORS NE m_L._SEPARATORS OR
       _L._GROUP-BOX NE m_L._GROUP-BOX       OR _L._ROUNDED NE m_L._ROUNDED OR
       _L._SEPARATOR-FGCOLOR NE m_L._SEPARATOR-FGCOLOR OR
       _L._TITLE-BGCOLOR NE m_L._TITLE-BGCOLOR OR
       _L._TITLE-FGCOLOR NE m_L._TITLE-FGCOLOR OR
       _L._VIRTUAL-HEIGHT NE m_L._VIRTUAL-HEIGHT OR
       _L._VIRTUAL-WIDTH NE m_L._VIRTUAL-WIDTH OR
       _L._WIDTH NE m_L._WIDTH THEN DO:

      IF NOT differ THEN DO:  /* First difference found for this widget - define */
                              /* widget name etc.                                */

        /* Build frame expression ("IN FRAME myframe"). This is not necessary
           on true handles (i.e. Windows, OCX's and SmartObjects), or on
           true frames (i.e. Frame or Dialog-boxes). */

        IF CAN-DO("WINDOW,FRAME,DIALOG-BOX,SmartObjects,{&WT-CONTROL}",_U._TYPE)
        THEN ASSIGN fram_exp = ""
                    f_e_len  = 0.
        ELSE DO:
          FIND f_U WHERE RECID(f_U) = _U._parent-recid.
          FIND f_L WHERE f_L._u-recid = RECID(f_U) AND 
                         f_L._LO-NAME = "Master Layout".
          ASSIGN fram_exp = " IN FRAME " + f_U._NAME + " "
                 f_e_len  = LENGTH(fram_exp).
        END.

        /*
         * SmartObjects are changed using internal methods Set-Size and
         * Set-Position.  All other widgets can have there widget properties
         * accessed directly.
         *
         * The VBX control is a runtime widget that will be defined
         * on non-wondows paltforms but not created. That is, there
         * will be a variable for the container, but the create container
         * statement will only occur on MS-WINDOWS. Protect the assign
         * statement.
         */

        IF _U._TYPE ne "SmartObject":U THEN DO:
          /* Build widget reference string */
          FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
          ASSIGN w_NAME = "         " +
                         IF CAN-DO("DIALOG-BOX,FRAME":U, _U._TYPE) THEN ("FRAME " + _U._NAME)
                         ELSE (IF (_U._DBNAME eq ? OR
                           (AVAILABLE _F AND _F._DISPOSITION EQ "LIKE":U)) THEN _U._NAME
                            ELSE db-fld-name("_U":U, RECID(_U)))
               w_n_len = LENGTH(w_NAME)
               differ  = TRUE.
          /* Start an ASSIGN statement. */
          l_assign = TRUE.
          IF _U._TYPE = "{&WT-CONTROL}" 
          THEN PUT STREAM P_4GL UNFORMATTED SKIP 
               "      IF VALID-HANDLE(" _U._NAME ") THEN ASSIGN".
          ELSE PUT STREAM P_4GL UNFORMATTED SKIP 
               "      ASSIGN".
        END. /* IF not a SmartObject */
      END.  /* First difference found for this widget */
      
      /* Now write out the Master Layout stuff that differs from the widget if
         not already written.  */             
      FIND put_L WHERE RECID(put_L) eq RECID(m_L).
      IF _U._TYPE eq "SmartObject" 
      THEN RUN put-SmO-differences.
      ELSE RUN put-differences.
    END.  /* If a difference has been found */    
  END.  /* FOR EACH _L of the current m_L */
  
  /* Finish any assign statement. */
  IF l_assign THEN PUT STREAM P_4GL UNFORMATTED
    (IF put_L._WIN-TYPE THEN ".":U ELSE " NO-ERROR.":U)  SKIP(1).
 
END.  /* Master-Widget-Block */
/* If we have created any temp-table records for containers, put out
   those values. */
RUN finish-container-info.

PUT STREAM P_4GL UNFORMATTED "    END.  /* Master Layout Layout Case */" SKIP (1).

  
Alternate-Widget-BLOCK:  
FOR EACH _LAYOUT WHERE _LAYOUT._LO-NAME NE "Master Layout":
  IF CAN-FIND(_L WHERE _L._u-recid = RECID(w_U) AND
                       _L._LO-NAME = _LAYOUT._LO-NAME) THEN
  DO:   /* This layout applies to this  window */
    
    CHKBLOCK:
    FOR EACH m_L WHERE m_L._LO-NAME = "Master Layout",
        EACH _U WHERE RECID(_U) = m_L._U-recid AND _U._WINDOW-HANDLE = _h_win 
                  AND _U._STATUS NE "DELETED":U:
      /* See if this layout differs from the Master layout                    */
      ASSIGN differ = FALSE
             l_assign = FALSE.
      
      FIND _L WHERE _L._LO-NAME = _LAYOUT._LO-NAME AND
                    _L._u-recid = m_L._u-recid.
                    
      /* Special Cases where we don't write out the layout information because the
         widgets don't really exist. (i.e. "TTY" images and design-windows) */       
      IF (_U._TYPE = "IMAGE":U AND NOT _L._WIN-TYPE) OR
         (_U._TYPE = "WINDOW":U AND _U._SUBTYPE EQ "Design-Window":U)
      THEN NEXT CHKBLOCK.
              
      IF (_L._BGCOLOR NE m_L._BGCOLOR AND _L._WIN-TYPE)                               OR
         _L._COL NE m_L._COL                  OR _L._EDGE-PIXELS NE m_L._EDGE-PIXELS  OR
         _L._CONVERT-3D-COLORS NE m_L._CONVERT-3D-COLORS OR
         (_L._FGCOLOR NE m_L._FGCOLOR AND _L._WIN-TYPE)                               OR
         _L._FILLED NE m_L._FILLED               OR 
         (_L._FONT NE m_L._FONT AND _L._WIN-TYPE)                                     OR
         _L._GRAPHIC-EDGE NE m_L._GRAPHIC-EDGE   OR _L._NO-FOCUS NE m_L._NO-FOCUS     OR
         _L._HEIGHT NE m_L._HEIGHT AND
                    (NOT CAN-DO("WINDOW",_U._TYPE) OR _L._WIN-TYPE)         OR
         _L._REMOVE-FROM-LAYOUT NE m_L._REMOVE-FROM-LAYOUT OR
         _L._ROW NE m_L._ROW                     OR _L._SEPARATORS NE m_L._SEPARATORS OR
         _L._GROUP-BOX NE m_L._GROUP-BOX         OR _L._ROUNDED NE m_L._ROUNDED OR
         (_L._SEPARATOR-FGCOLOR NE m_L._SEPARATOR-FGCOLOR AND _L._WIN-TYPE) OR
         (_L._TITLE-BGCOLOR NE m_L._TITLE-BGCOLOR AND _L._WIN-TYPE) OR
         (_L._TITLE-FGCOLOR NE m_L._TITLE-FGCOLOR AND _L._WIN-TYPE) OR
         (_L._VIRTUAL-HEIGHT NE m_L._VIRTUAL-HEIGHT AND
                                        (_U._TYPE NE "WINDOW" OR _L._WIN-TYPE))       OR
         (_L._VIRTUAL-WIDTH NE m_L._VIRTUAL-WIDTH AND
                                        (_U._TYPE NE "WINDOW" OR _L._WIN-TYPE))       OR
          _L._WIDTH NE m_L._WIDTH AND (_U._TYPE NE "WINDOW" OR _L._WIN-TYPE) THEN DO:
         differ = TRUE.
         LEAVE CHKBLOCK.
      END.  /* A difference has been found */
    END.  /* CHKBLOCK */

    IF differ THEN DO:
      PUT STREAM P_4GL UNFORMATTED
        "    WHEN ~"" + _LAYOUT._LO-NAME + "~":U THEN DO:"                      SKIP.

      WIDGET-BLOCK:      
      FOR EACH m_L WHERE m_L._LO-NAME = "Master Layout",
          EACH  _U WHERE RECID(_U) = m_L._U-recid AND _U._WINDOW-HANDLE = _h_win
                     AND _U._STATUS NE "DELETED":U
               BY IF _U._TYPE = "WINDOW" THEN 1 ELSE
                  IF CAN-DO("DIALOG-BOX,FRAME",_U._TYPE) THEN 2 ELSE 3
               BY _U._NAME:
        IF _U._TYPE = "TEXT" THEN NEXT WIDGET-BLOCK.  /* Can't modify text */
        FIND _L WHERE _L._LO-NAME = _LAYOUT._LO-NAME AND
                      _L._u-recid = m_L._u-recid.
        ASSIGN wrttn  = FALSE.
              
        /* Special Cases where we don't write out the layout information because the
           widgets don't really exist. (i.e. "TTY" images and design-windows) */            
        IF (_U._TYPE = "IMAGE":U AND NOT _L._WIN-TYPE) OR
           (_U._TYPE = "WINDOW":U AND _U._SUBTYPE EQ "Design-Window":U)
        THEN NEXT WIDGET-BLOCK.

/*MESSAGE "WIDGET-NAME:" _U._NAME                                       SKIP
 *         "BGCOLOR:"     (_L._BGCOLOR NE m_L._BGCOLOR AND _L._WIN-TYPE) SKIP
 *         "COL:"          _L._COL NE m_L._COL                           SKIP
 *         "CONVERT-3D:"   _L._CONVERT-3D-COLORS NE m_L._CONVERT-3D-COLORS SKIP
 *         "EDGE-PIXELS:"  _L._EDGE-PIXELS NE m_L._EDGE-PIXELS           SKIP
 *         "FGCOLOR:"     (_L._FGCOLOR NE m_L._FGCOLOR AND _L._WIN-TYPE) SKIP
 *         "FILLED:"       _L._FILLED NE m_L._FILLED                     SKIP
 *         "FONT:"         _L._FONT NE m_L._FONT                         SKIP
 *         "GRAPHIC-EDGE:" _L._GRAPHIC-EDGE NE m_L._GRAPHIC-EDGE         SKIP
 *         "HEIGHT:"       _L._HEIGHT NE m_L._HEIGHT                     SKIP
 *         "NO-FOCUS:"     _L._NO-FOCUS NE m_L._NO-FOCUS                 SKIP
 *         "REMOVE-FROM-LAYOUT:" _L._REMOVE-FROM-LAYOUT                  SKIP
 *         "ROW:"          _L._ROW NE m_L._ROW                           SKIP
 *         "SEPARATORS:"   _L._SEPARATORS NE m_L._SEPARATORS             SKIP
 *         "SEPARATOR-FGCOLOR:" _L._SEPARATOR-FGCOLOR NE m_L._SEPARATOR-FGCOLOR SKIP
 *         "TITLE-BGC:"    (_L._TITLE-BGCOLOR NE m_L._TITLE-BGCOLOR AND _L._WIN-TYPE) SKIP
 *         "TITLE-FGC:"    (_L._TITLE-FGCOLOR NE m_L._TITLE-FGCOLOR AND _L._WIN-TYPE) SKIP
 *         "VIR-HEIGHT:"   _L._VIRTUAL-HEIGHT NE m_L._VIRTUAL-HEIGHT     SKIP
 *         "VIR-WIDTH:"    _L._VIRTUAL-WIDTH NE m_L._VIRTUAL-WIDTH       SKIP
 *         "WIDTH:"        _L._WIDTH NE m_L._WIDTH                       SKIP
 *         "WIDGET-BLOCK:"  _U._NAME VIEW-AS ALERT-BOX. */
        
        IF (_L._BGCOLOR NE m_L._BGCOLOR AND _L._WIN-TYPE)                             OR
            _L._CONVERT-3D-COLORS NE m_L._CONVERT-3D-COLORS OR
            _L._COL NE m_L._COL               OR _L._EDGE-PIXELS NE m_L._EDGE-PIXELS  OR
           (_L._FGCOLOR NE m_L._FGCOLOR AND _L._WIN-TYPE)                             OR
            _L._FILLED NE m_L._FILLED             OR  _L._NO-FOCUS NE m_L._NO-FOCUS   OR
           (_L._FONT NE m_L._FONT AND _L._WIN-TYPE)                                   OR
            _L._GRAPHIC-EDGE NE m_L._GRAPHIC-EDGE OR
            _L._HEIGHT NE m_L._HEIGHT AND
                       (NOT CAN-DO("WINDOW",_U._TYPE) OR _L._WIN-TYPE)      OR
            _L._REMOVE-FROM-LAYOUT NE m_L._REMOVE-FROM-LAYOUT                         OR
            _L._ROW NE m_L._ROW                   OR _L._SEPARATORS NE m_L._SEPARATORS OR
            _L._GROUP-BOX NE m_L._GROUP-BOX       OR _L._ROUNDED NE m_L._ROUNDED OR
           (_L._SEPARATOR-FGCOLOR NE m_L._SEPARATOR-FGCOLOR AND _L._WIN-TYPE)         OR
           (_L._TITLE-BGCOLOR NE m_L._TITLE-BGCOLOR AND _L._WIN-TYPE)                 OR
           (_L._TITLE-FGCOLOR NE m_L._TITLE-FGCOLOR AND _L._WIN-TYPE)                 OR
           (_L._VIRTUAL-HEIGHT NE m_L._VIRTUAL-HEIGHT AND
                                         (_U._TYPE NE "WINDOW" OR _L._WIN-TYPE))      OR
           (_L._VIRTUAL-WIDTH NE m_L._VIRTUAL-WIDTH AND
                                         (_U._TYPE NE "WINDOW" OR _L._WIN-TYPE))      OR
            _L._WIDTH NE m_L._WIDTH AND (_U._TYPE NE "WINDOW" OR _L._WIN-TYPE) THEN DO:


         /* Build frame expression ("IN FRAME myframe"). This is not necessary
           on true handles (i.e. Windows, VBX's and SmartObjects), or on
           true frames (i.e. Frame or Dialog-boxes). */

          IF CAN-DO("WINDOW,FRAME,DIALOG-BOX,SmartObjects,{&WT-CONTROL}",_U._TYPE) THEN
            ASSIGN fram_exp = ""
                   f_e_len  = 0.
          ELSE DO:
            FIND f_U WHERE RECID(f_U) = _U._parent-recid.
            FIND f_L WHERE f_L._u-recid = RECID(f_U) AND 
                           f_L._LO-NAME = _LAYOUT._LO-NAME.
            ASSIGN fram_exp = " IN FRAME " + f_U._NAME + " "
                   f_e_len  = LENGTH(fram_exp).
          END.

          /*
           * SmartObjects are changed using internal methods Set-Size and
           * Set-Position.  All other widgets can have there widget properties
           * accessed directly.
           *
           * The VBX control is a runtime widget that will be defined
           * on non-wondows paltforms but not created. That is, there
           * will be a variable for the container, but the create container
           * statement will only occur on MS-WINDOWS. Protect the assign
           * statement.
           */

          IF _U._TYPE ne "SmartObject" THEN DO:
            FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
            /* Build widget reference string */
            ASSIGN w_NAME  = "         " +
                           IF CAN-DO("DIALOG-BOX,FRAME":U, _U._TYPE) THEN ("FRAME " + _U._NAME)
                           ELSE (IF (_U._DBNAME eq ? OR
                                  (AVAILABLE _F AND _F._DISPOSITION EQ "LIKE":U))
                                 THEN _U._NAME
                                 ELSE db-fld-name("_U":U, RECID(_U)))
                 w_n_len = LENGTH(w_NAME)
                 differ  = TRUE.

            /* Start an ASSIGN statement. */
            l_assign = TRUE.
            
            IF _U._TYPE = "{&WT-CONTROL}" 
            THEN PUT STREAM P_4GL UNFORMATTED SKIP 
                 "      IF VALID-HANDLE(" _U._NAME ") THEN ASSIGN".
            ELSE PUT STREAM P_4GL UNFORMATTED SKIP 
                 "      ASSIGN".
          END. /* IF not a SmartObject */
      
          /* Now write out the Alternate Layout stuff that differs from the `
             widget if not already written.  */             
          FIND put_L WHERE RECID(put_L) eq RECID(_L).
          IF _U._TYPE eq "SmartObject"
          THEN RUN put-SmO-differences.
          ELSE RUN put-differences.
 
          /* Finish any assign statement. */
          IF l_assign THEN
            PUT STREAM P_4GL UNFORMATTED
                (IF put_L._WIN-TYPE THEN "." ELSE " NO-ERROR.") SKIP(1).

        END.  /* If this widget has a change */
      END. /* FOR EACH m_L */
      /* If we have created any temp-table records for containers, put out
         those values. */
      RUN finish-container-info.
      
      PUT STREAM P_4GL UNFORMATTED "    END.  /* " _LAYOUT._LO-NAME
                       " Layout Case */"                                  SKIP (1).
    END.  /* This layout differs from the master */
  END.  /* Have a set of layout records for this layout */
END. /* For each _LAYOUT definition */
  
PUT STREAM P_4GL UNFORMATTED "  END CASE." SKIP
                             "END PROCEDURE.  /* " pLayout-var + "s */"   SKIP
                             "~&ANALYZE-RESUME"                           SKIP (1).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-adjust-size) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adjust-size Procedure 
PROCEDURE adjust-size :
/*------------------------------------------------------------------------------
  Purpose:     Reset the height/width of the object to its minimum size
  Notes:       This works on the current _U record.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER min-hgt  AS INTEGER                               NO-UNDO.
  DEFINE INPUT PARAMETER min-wdth AS INTEGER                               NO-UNDO.
  
  MESSAGE _U._TYPE _U._NAME "is too small for character mode realization." SKIP
          "Increasing its size to" MAX(_L._HEIGHT,min-hgt) "BY"
                                   MAX(_L._WIDTH,min-wdth) "for character mode only."
          VIEW-AS ALERT-BOX.
  ASSIGN _L._HEIGHT = MAX(_L._HEIGHT,min-hgt)
         _L._WIDTH  = MAX(_L._WIDTH,min-wdth).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-finish-container-info) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE finish-container-info Procedure 
PROCEDURE finish-container-info :
/*------------------------------------------------------------------------------
  Purpose:     Go through all the temp-table records containing code for 
               containers and output these. Then destroy the tt records.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
  FOR EACH tt:
  
    /* If there is any code, output it. */
    IF tt._code ne "":U
    THEN PUT STREAM P_4GL UNFORMATTED 
               SKIP 
               "      ASSIGN" tt._code (IF put_L._WIN-TYPE THEN ".":U
                                        ELSE " NO-ERROR.":U)
               SKIP (1).
  
    /* Now delete the record. */
    DELETE tt.
    
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-geometry-diff) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geometry-diff Procedure 
PROCEDURE geometry-diff :
/*------------------------------------------------------------------------------
  Purpose:     There is a geometry difference on the current object 
  Parameters:  pl_hidden -- The current state of the flag.
  
  Notes:       uses variables 
                  w_NAME == the widget name (including leading spaces)
                  frame_exp == IN FRAME xxx expression
                  f_e_len/w_n_len == lenght
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER pl_hidden AS LOGICAL NO-UNDO.
  
  IF NOT pl_hidden THEN DO:
    /* HIDE the object and set the flag that says we did. */
    pl_hidden = YES.

    /*
     * FRAMES, DIALOG-BOXES, and WINDOWS need have their return to "HIDDEN = no"
     * deferred until after all their contents have been resized. We store
     * the list of these containers that need to have their size redone in
     * a temp-table. This temp-table also stores the information needed to 
     * set the virtual-size.
     */
    IF CAN-DO ('WINDOW,FRAME,DIALOG-BOX':U, _U._TYPE) THEN DO:
      CREATE tt.
      ASSIGN tt._u-recid = RECID(_U)
             tt._name    = _U._NAME
             tt._order   = LOOKUP (_U._TYPE, "FRAME,DIALOG-BOX,WINDOW":U)
             .
      PUT STREAM P_4GL UNFORMATTED SKIP
          "         ~&IF '~{~&WINDOW-SYSTEM}' NE 'TTY':U ~&THEN":U SKIP
          w_NAME + ":HIDDEN":U + fram_exp + FILL(" ":U,52 - f_e_len - w_n_len) +
                   "= yes ~&ENDIF":U.
    END.
    ELSE
      PUT STREAM P_4GL UNFORMATTED SKIP
         w_NAME + ":HIDDEN":U + fram_exp + FILL(" ":U,52 - f_e_len - w_n_len) +
                 "= yes":U.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-put-differences) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE put-differences Procedure 
PROCEDURE put-differences :
/* ---------------------------------------------------------------------------
 * Put_Differences -- write out all the differences between the master layout
 *  and the current layout for standard widgets. 
 *  The buffer "put_L" will point to either the Master or the Alternate
 *  layout depending on how this is called.
 * --------------------------------------------------------------------------- */
 
  /* If we are going to change the geometry, then hide the object first. */
  DEFINE VARIABLE l_geometry-diff AS LOGICAL NO-UNDO.
  
  /* --- BGCOLOR -------------------------------------------------------------- */
  IF _L._BGCOLOR NE m_L._BGCOLOR AND put_L._WIN-TYPE AND NOT wrttn[{&BGC}] THEN DO:
    PUT STREAM P_4GL UNFORMATTED SKIP
                     w_NAME + ":BGCOLOR" + fram_exp +
                     FILL(" ",51 - f_e_len - w_n_len) + "= "
                     put_L._BGCOLOR.
    wrttn[{&BGC}] = TRUE.
  END.


  /* --- COL ------------------------------------------------------------------ */
  IF _L._COL NE m_L._COL AND (put_L._WIN-TYPE OR _U._TYPE NE "WINDOW") AND
     NOT wrttn[{&COL}] THEN DO:
    RUN geometry-diff (INPUT-OUTPUT l_geometry-diff).
    IF CAN-DO("COMBO-BOX,FILL-IN",_U._TYPE) THEN DO:
      IF NOT put_L._NO-LABELS AND NOT f_L._NO-LABELS THEN
        PUT STREAM P_4GL UNFORMATTED SKIP
          "         widg-pos = " + TRIM(w_NAME) + ":COL" + fram_exp.
    END.
    IF _U._LAYOUT-UNIT THEN
      PUT STREAM P_4GL UNFORMATTED SKIP
            w_NAME + ":COL" + fram_exp +
                     FILL(" ",55 - f_e_len - w_n_len) + "= "
                     IF put_L._WIN-TYPE THEN MAX(ROUND(put_L._COL,2),1)
                                      ELSE INTEGER(put_L._COL).
    ELSE
      PUT STREAM P_4GL UNFORMATTED SKIP
            w_NAME + ":X" + fram_exp +
                     FILL(" ",57 - f_e_len - w_n_len) + "= " 
                     INTEGER((put_L._COL - 1) * SESSION:PIXELS-PER-COL).
         
    /* IF a COMBO-BOX or FILL-IN then move the label too            */
    IF CAN-DO("COMBO-BOX,FILL-IN",_U._TYPE) THEN DO:
      IF NOT put_L._NO-LABELS AND NOT f_L._NO-LABELS THEN
             PUT STREAM P_4GL UNFORMATTED SKIP
               "         lbl-hndl = " +
                           TRIM(w_NAME) + ":SIDE-LABEL-HANDLE" + fram_exp SKIP
               "         lbl-hndl:COL = lbl-hndl:COL + " + TRIM(w_NAME) +
                                           ":COL":U + fram_exp + " - widg-pos":U.
    END.
    wrttn[{&COL}] = TRUE.
  END.  /* If has a new column */   


  /* --- CONVERT-3D-COLORS ---------------------------------------------------- */
  IF _L._CONVERT-3D-COLORS NE m_L._CONVERT-3D-COLORS AND NOT wrttn[{&CONV-3D}] THEN DO:
    PUT STREAM P_4GL UNFORMATTED
         SKIP w_NAME + ":CONVERT-3D-COLORS" + fram_exp +
                     FILL(" ",41 - f_e_len - w_n_len) + "= "
                     put_L._CONVERT-3D-COLORS.
    wrttn[{&CONV-3D}] = TRUE.
  END.


  /* --- EDGE-PIXELS ---------------------------------------------------------- */
  IF _L._EDGE-PIXELS NE m_L._EDGE-PIXELS AND NOT wrttn[{&EDGE-P}] THEN DO:
    PUT STREAM P_4GL UNFORMATTED
         SKIP w_NAME + ":EDGE-PIXELS" + fram_exp +
                     FILL(" ",47 - f_e_len - w_n_len) + "= "
                     put_L._EDGE-PIXELS.
    wrttn[{&EDGE-P}] = TRUE.
  END.


  /* --- FGCOLOR -------------------------------------------------------------- */
  IF _L._FGCOLOR NE m_L._FGCOLOR AND put_L._WIN-TYPE AND NOT wrttn[{&FGC}] THEN DO:
    PUT STREAM P_4GL UNFORMATTED SKIP
         w_NAME + ":FGCOLOR" + fram_exp +
                  FILL(" ",51 - f_e_len - w_n_len) + "= "
                  put_L._FGCOLOR.
    wrttn[{&FGC}] = TRUE.
  END.


  /* --- FILLED --------------------------------------------------------------- */
  IF (_L._FILLED NE m_L._FILLED) AND NOT wrttn[{&FILLED}] THEN DO:
    PUT STREAM P_4GL UNFORMATTED SKIP
         w_NAME + ":FILLED" + fram_exp +
                  FILL(" ",52 - f_e_len - w_n_len) + "= "
                  put_L._FILLED.
    wrttn[{&FILLED}] = TRUE.
  END.


  /* --- FONT ----------------------------------------------------------------- */
  IF _L._FONT NE m_L._FONT AND put_L._WIN-TYPE AND NOT wrttn[{&FONT}] THEN DO:
    PUT STREAM P_4GL UNFORMATTED SKIP
            w_NAME + ":FONT" + fram_exp +
                     FILL(" ",54 - f_e_len - w_n_len) + "= "
                     put_L._FONT.
    wrttn[{&FONT}] = TRUE.
  END.


  /* --- GRAPHIC-EDGE --------------------------------------------------------- */
  IF (_L._GRAPHIC-EDGE NE m_L._GRAPHIC-EDGE) AND NOT put_L._WIN-TYPE 
     AND NOT wrttn[{&GRAPHIC}] THEN DO:
    PUT STREAM P_4GL UNFORMATTED SKIP
                w_NAME + ":GRAPHIC-EDGE" + fram_exp +
                         FILL(" ",45 - f_e_len - w_n_len) + "= "
                         put_L._GRAPHIC-EDGE.
    wrttn[{&GRAPHIC}] = TRUE.
  END.


  /* --- GROUP-BOX ------------------------------------------------------------- */
  IF (_L._GROUP-BOX NE m_L._GROUP-BOX) AND NOT wrttn[{&GROUP-BOX}] THEN DO:
    PUT STREAM P_4GL UNFORMATTED SKIP
         w_NAME + ":GROUP-BOX" + fram_exp +
                  FILL(" ",49 - f_e_len - w_n_len) + "= "
                  put_L._GROUP-BOX.
    wrttn[{&GROUP-BOX}] = TRUE.
  END.


  /* --- HEIGHT --------------------------------------------------------------- */
  IF _L._HEIGHT NE m_L._HEIGHT 
     AND  NOT wrttn[{&HEIGHT}] THEN DO:
    RUN geometry-diff (INPUT-OUTPUT l_geometry-diff).
    IF _U._LAYOUT-UNIT THEN DO:
      PUT STREAM P_4GL UNFORMATTED SKIP "" +
            (IF _U._TYPE NE "WINDOW":U THEN "" ELSE
              "         ~&IF '~{~&WINDOW-SYSTEM}' NE 'TTY' ~&THEN":U + CHR(10))
            w_NAME + ":HEIGHT":U + fram_exp +
                        FILL(" ":U,52 - f_e_len - w_n_len) + "= ":U
                      (IF put_L._WIN-TYPE THEN TRUNCATE(put_L._HEIGHT,2)
                                          ELSE INTEGER(put_L._HEIGHT))
            (IF _U._TYPE NE "WINDOW":U THEN "" ELSE " ~&ENDIF":U).
      IF _U._TYPE = "DIALOG-BOX":U THEN
        PUT STREAM P_4GL UNFORMATTED SKIP
          "               + " TRIM(w_NAME) + ":BORDER-TOP + ":U
                              TRIM(w_NAME) + ":BORDER-BOTTOM":U.
    END.
    ELSE
      PUT STREAM P_4GL UNFORMATTED SKIP "" +
            (IF _U._TYPE NE "WINDOW":U THEN "" ELSE
              "         ~&IF '~{~&WINDOW-SYSTEM}' NE 'TTY':U ~&THEN":U) SKIP
            w_NAME + ":HEIGHT-PIXELS":U + fram_exp +
                        FILL(" ":U,45 - f_e_len - w_n_len) + "= ":U
                       INTEGER(put_L._HEIGHT * SESSION:PIXELS-PER-ROW)
            (IF _U._TYPE NE "WINDOW":U THEN "" ELSE " ~&ENDIF":U).

    wrttn[{&HEIGHT}] = TRUE.
  END.  /* If has a different HEIGHT */


  /* --- NO-FOCUS ------------------------------------------------------------- */
  IF _L._NO-FOCUS NE m_L._NO-FOCUS AND NOT wrttn[{&FOCUS}] THEN DO:
    PUT STREAM P_4GL UNFORMATTED
         SKIP w_NAME + ":NO-FOCUS" + fram_exp +
                     FILL(" ",50 - f_e_len - w_n_len) + "= "
                     put_L._NO-FOCUS.
    wrttn[{&FOCUS}] = TRUE.
  END.


  /* --- REMOVE-FROM-LAYOUT --------------------------------------------------- */
  /* This is output LAST -- look at the bottom of the procedure                 */
 

  /* --- ROUNDED -------------------------------------------------------------- */
  IF (_L._ROUNDED NE m_L._ROUNDED) AND NOT wrttn[{&ROUNDED}] THEN DO:
    PUT STREAM P_4GL UNFORMATTED SKIP
         w_NAME + ":ROUNDED" + fram_exp +
                  FILL(" ",51 - f_e_len - w_n_len) + "= "
                  put_L._ROUNDED.
    wrttn[{&ROUNDED}] = TRUE.
  END.


  /* --- ROW ------------------------------------------------------------------ */
  IF _L._ROW NE m_L._ROW AND (put_L._WIN-TYPE OR _U._TYPE NE "WINDOW") 
     AND NOT wrttn[{&ROW}] THEN DO:
    RUN geometry-diff (INPUT-OUTPUT l_geometry-diff).
    IF CAN-DO("COMBO-BOX,FILL-IN",_U._TYPE) THEN DO:
      IF NOT put_L._NO-LABELS AND NOT f_L._NO-LABELS THEN
        PUT STREAM P_4GL UNFORMATTED SKIP
          "         widg-pos = " + TRIM(w_NAME) + ":ROW" + fram_exp.
    END.
    IF _U._LAYOUT-UNIT THEN
      PUT STREAM P_4GL UNFORMATTED SKIP
              w_NAME + ":ROW" + fram_exp +
                     FILL(" ",55 - f_e_len - w_n_len) + "= "
                      IF put_L._WIN-TYPE THEN MAX(ROUND(put_L._ROW,2),1)
                                       ELSE INTEGER(put_L._ROW).
    ELSE
      PUT STREAM P_4GL UNFORMATTED SKIP
             w_NAME + ":Y" + fram_exp +
                     FILL(" ",57 - f_e_len - w_n_len) + "= " 
                     INTEGER((put_L._ROW - 1) * SESSION:PIXELS-PER-ROW).
         
     /* IF a COMBO-BOX or FILL-IN then move the label too            */
     IF CAN-DO("COMBO-BOX,FILL-IN",_U._TYPE) THEN DO:
       IF NOT put_L._NO-LABELS AND NOT f_L._NO-LABELS THEN
         PUT STREAM P_4GL UNFORMATTED SKIP
               "         lbl-hndl = " +
                           TRIM(w_NAME) + ":SIDE-LABEL-HANDLE" + fram_exp SKIP
               "         lbl-hndl:ROW = lbl-hndl:ROW + " + TRIM(w_NAME) +
                                           ":ROW":U + fram_exp + " - widg-pos":U.
    END.
    wrttn[{&ROW}] = TRUE.
  END.  /* IF ROW is different */


  /* --- SEPARATORS ----------------------------------------------------------- */
  IF (_L._SEPARATORS NE m_L._SEPARATORS) AND NOT wrttn[{&SEPS}] THEN DO:
    PUT STREAM P_4GL UNFORMATTED
         SKIP w_NAME + ":SEPARATORS" + fram_exp +
                     FILL(" ",48 - f_e_len - w_n_len) + "= "
                     put_L._SEPARATORS.
    wrttn[{&SEPS}] = TRUE.
  END.

  /* --- SEPARATOR-FGCOLOR ----------------------------------------------------- */
  IF _L._SEPARATOR-FGCOLOR NE m_L._SEPARATOR-FGCOLOR AND put_L._WIN-TYPE AND NOT wrttn[{&SFGC}] THEN DO:
    PUT STREAM P_4GL UNFORMATTED SKIP
         w_NAME + ":SEPARATOR-FGCOLOR" + fram_exp +
                  FILL(" ",41 - f_e_len - w_n_len) + "= "
                  put_L._SEPARATOR-FGCOLOR.
    wrttn[{&SFGC}] = TRUE.
  END.

  /* --- TITLE-BGCOLOR -------------------------------------------------------- */
  IF _L._TITLE-BGCOLOR NE m_L._TITLE-BGCOLOR AND put_L._WIN-TYPE AND
     NOT wrttn[{&TTL-BGC}] THEN DO:
    PUT STREAM P_4GL
         UNFORMATTED SKIP w_NAME + ":TITLE-BGCOLOR" + fram_exp +
                     FILL(" ",45 - f_e_len - w_n_len) + "= "
                     put_L._TITLE-BGCOLOR.
    wrttn[{&TTL-BGC}] = TRUE.
  END.


  /* --- TITLE-FGCOLOR -------------------------------------------------------- */
  IF _L._TITLE-FGCOLOR NE m_L._TITLE-FGCOLOR AND put_L._WIN-TYPE AND
     NOT wrttn[{&TTL-FGC}] THEN DO:
    PUT STREAM P_4GL
         UNFORMATTED SKIP w_NAME + ":TITLE-FGCOLOR" + fram_exp +
                     FILL(" ",45 - f_e_len - w_n_len) + "= "
                     put_L._TITLE-FGCOLOR.
    wrttn[{&TTL-FGC}] = TRUE.
  END.
    
  /* --- VIRTUAL-HEIGHT ------------------------------------------------------- */
  IF _L._VIRTUAL-HEIGHT NE m_L._VIRTUAL-HEIGHT AND
     (put_L._WIN-TYPE OR _U._TYPE NE "WINDOW") AND NOT wrttn[{&V-HGT}] THEN DO:
    RUN geometry-diff (INPUT-OUTPUT l_geometry-diff).
    IF _U._LAYOUT-UNIT THEN
      tt._code = tt._code + CHR(10)
               + (IF _U._TYPE NE "WINDOW":U THEN "" ELSE
                   "         ~&IF '~{~&WINDOW-SYSTEM}' NE 'TTY':U ~&THEN":U) + CHR(10)
               + w_NAME + ":VIRTUAL-HEIGHT":U
               + FILL(" ":U,44 - w_n_len) + "= ":U
               + LEFT-TRIM (STRING(IF put_L._WIN-TYPE 
                                   THEN TRUNCATE(put_L._VIRTUAL-HEIGHT,2)
                                   ELSE INTEGER(put_L._VIRTUAL-HEIGHT),
                                   ">>9.99":U)) 
               + (IF _U._TYPE NE "WINDOW":U THEN (CHR(10) + FILL(" ":U,20) + 
                    "WHEN ":U + TRIM(w_NAME) + ":SCROLLABLE":U) ELSE "":U)
               + (IF _U._TYPE NE "WINDOW":U THEN "" ELSE " ~&ENDIF":U).
    ELSE
      tt._code = tt._code + CHR(10) 
               + (IF _U._TYPE NE "WINDOW":U THEN "" ELSE
                   "         ~&IF '~{~&WINDOW-SYSTEM}' NE 'TTY':U ~&THEN":U) + CHR(10)
               + w_NAME + ":VIRTUAL-HEIGHT-PIXELS":U
               + FILL(" ":U,37 - w_n_len) + "= ":U
               + LEFT-TRIM (STRING(INTEGER(put_L._VIRTUAL-HEIGHT * SESSION:PIXELS-PER-ROW),
                                   ">>>>9":U))
               + (IF _U._TYPE NE "WINDOW":U THEN (CHR(10) + FILL(" ":U,20) + 
                    "WHEN ":U + TRIM(w_NAME) + ":SCROLLABLE":U) ELSE "":U)
               + (IF _U._TYPE NE "WINDOW":U THEN "" ELSE " ~&ENDIF":U).

    /* Store this for later display in the temp-table. */
    wrttn[{&V-HGT}] = TRUE.
  END.  /* IF Virtual-HEIGHT is different */


  /* --- VIRTUAL-WIDTH -------------------------------------------------------- */
  IF _L._VIRTUAL-WIDTH NE m_L._VIRTUAL-WIDTH AND
     (put_L._WIN-TYPE OR _U._TYPE NE "WINDOW") AND NOT wrttn[{&V-WDT}] THEN DO:
    RUN geometry-diff (INPUT-OUTPUT l_geometry-diff).
    IF _U._LAYOUT-UNIT THEN
      tt._code = tt._code + CHR(10) 
               + (IF _U._TYPE NE "WINDOW":U THEN "" ELSE
                   "         ~&IF '~{~&WINDOW-SYSTEM}' NE 'TTY':U ~&THEN":U) + CHR(10)
               + w_NAME + ":VIRTUAL-WIDTH":U
               + FILL(" ",45 - w_n_len) + "= "
               + LEFT-TRIM (STRING(IF put_L._WIN-TYPE 
                                   THEN TRUNCATE(put_L._VIRTUAL-WIDTH,2)
                                   ELSE INTEGER(put_L._VIRTUAL-WIDTH),
                                   ">>9.99":U))
               + (IF _U._TYPE NE "WINDOW":U THEN (CHR(10) + FILL(" ",20) + 
                    "WHEN ":U + TRIM(w_NAME) + ":SCROLLABLE":U) ELSE "":U)
               + (IF _U._TYPE NE "WINDOW":U THEN "" ELSE " ~&ENDIF":U).
    ELSE
      tt._code = tt._code + CHR(10) 
               + (IF _U._TYPE NE "WINDOW":U THEN "" ELSE
                   "         ~&IF '~{~&WINDOW-SYSTEM}' NE 'TTY':U ~&THEN":U) + CHR(10)
               + w_NAME + ":VIRTUAL-WIDTH-PIXELS":U
               + FILL(" ":U,38 - w_n_len) + "= ":U
               + LEFT-TRIM (STRING(INTEGER(put_L._VIRTUAL-WIDTH * SESSION:PIXELS-PER-ROW),
                                   ">>>>9":U))
               + (IF _U._TYPE NE "WINDOW":U THEN (CHR(10) + FILL(" ":U,20) + 
                    "WHEN ":U + TRIM(w_NAME) + ":SCROLLABLE":U) ELSE "":U)
               + (IF _U._TYPE NE "WINDOW":U THEN "" ELSE " ~&ENDIF":U).
    wrttn[{&V-WDT}] = TRUE.
  END.  /* IF Virtual-WIDTH is different */


  /* --- WIDTH ---------------------------------------------------------------- */
  IF _L._WIDTH NE m_L._WIDTH AND NOT wrttn[{&WIDTH}] THEN DO:
    RUN geometry-diff (INPUT-OUTPUT l_geometry-diff).
    IF _U._LAYOUT-UNIT THEN DO:
      PUT STREAM P_4GL UNFORMATTED SKIP "" +
              (IF _U._TYPE NE "WINDOW":U THEN "" ELSE
                "         ~&IF '~{~&WINDOW-SYSTEM}' NE 'TTY':U ~&THEN":U) SKIP
              w_NAME + ":WIDTH":U + fram_exp +
                       FILL(" ",53 - f_e_len - w_n_len) + "= "
                       IF put_L._WIN-TYPE THEN TRUNCATE(put_L._WIDTH,2)
                                       ELSE INTEGER(put_L._WIDTH)
              (IF _U._TYPE NE "WINDOW":U THEN "" ELSE " ~&ENDIF":U).
      IF _U._TYPE = "DIALOG-BOX":U THEN
        PUT STREAM P_4GL UNFORMATTED SKIP
          "               + " TRIM(w_NAME) + ":BORDER-LEFT + ":U
                              TRIM(w_NAME) + ":BORDER-RIGHT":U.
    END.
    ELSE
      PUT STREAM P_4GL UNFORMATTED SKIP "" +
              (IF _U._TYPE NE "WINDOW":U THEN "" ELSE
                "         ~&IF '~{~&WINDOW-SYSTEM}' NE 'TTY':U ~&THEN":U) SKIP
              w_NAME + ":WIDTH-PIXELS":U + fram_exp +
                       FILL(" ":U,46 - f_e_len - w_n_len) + "= ":U
                       INTEGER(put_L._WIDTH * SESSION:PIXELS-PER-COLUMN)
              (IF _U._TYPE NE "WINDOW":U THEN "" ELSE " ~&ENDIF":U).
    wrttn[{&WIDTH}] = TRUE.
  END.  /* If has a different WIDTH */
  
  /* --- REMOVE-FROM-LAYOUT --------------------------------------------------- */
  /* This is output LAST because we may have already hidden the object if there */
  /* was a geometry difference.                                                 */
  IF l_geometry-diff THEN DO:
    /* Should this object be actually removed from this layout? */  
    IF put_L._REMOVE-FROM-LAYOUT THEN wrttn[{&REMOVE}] = yes.
    ELSE DO:
      /* For FRAMES, DIALOGS, etc, we will delay restiring the object. */
      IF AVAILABLE(tt) AND tt._u-recid eq RECID(_U)
      THEN tt._code = tt._code + CHR(10) +
                "         ~&IF '~{~&WINDOW-SYSTEM}' NE 'TTY':U ~&THEN":U + CHR(10)
                    + w_NAME + ":HIDDEN" + fram_exp 
                    + FILL(" ",52 - f_e_len - w_n_len) + "= no ~&ENDIF":U.
      ELSE PUT STREAM P_4GL UNFORMATTED SKIP
              w_NAME + ":HIDDEN":U + fram_exp +
                       FILL(" ",52 - f_e_len - w_n_len) + "= no":U.
    END.
  END.
      
  IF (_L._REMOVE-FROM-LAYOUT NE m_L._REMOVE-FROM-LAYOUT) AND NOT wrttn[{&REMOVE}] 
  THEN DO:
    PUT STREAM P_4GL UNFORMATTED SKIP
         w_NAME + ":HIDDEN" + fram_exp +
                     FILL(" ",52 - f_e_len - w_n_len) + "= "
                     put_L._REMOVE-FROM-LAYOUT.
    wrttn[{&REMOVE}] = TRUE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-put-SmO-differences) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE put-SmO-differences Procedure 
PROCEDURE put-SmO-differences :
/*------------------------------------------------------------------------------
  Purpose:     For the current _U record. Check the _L and m_L records
               and put any differences in geometry out.
               This is only for SmartObjects.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Get the associated _S record, and see if the object is resizable. */
  FIND _S WHERE RECID(_S) eq _U._x-recid.
  IF NOT VALID-HANDLE (_S._HANDLE) 
  THEN ASSIGN
         l_set-size = NO
         l_set-pos  = NO.
  ELSE ASSIGN 
         l_set-size = CAN-DO (_S._HANDLE:INTERNAL-ENTRIES, 'set-size':U) OR
                      CAN-DO (_S._HANDLE:INTERNAL-ENTRIES, 'resizeObject':U)
         l_set-pos  = CAN-DO (_S._HANDLE:INTERNAL-ENTRIES, 'set-position':U) OR
                      CAN-DO (_S._HANDLE:INTERNAL-ENTRIES, 'repositionObject':U).
              
  /* Use set-position and set-size to modify a smartobject */
  IF (_L._COL NE m_L._COL AND NOT wrttn[{&COL}]) OR 
     (_L._ROW ne m_L._ROW AND NOT wrttn[{&ROW}]) 
  THEN DO:
    FIND _P WHERE _P._WINDOW-HANDLE = _U._WINDOW-HANDLE.
    PUT STREAM P_4GL UNFORMATTED SKIP 
       "      ":U
       IF l_set-pos
       THEN "RUN " + (IF _P._adm-version < "ADM2"
                      THEN "set-position" ELSE "repositionObject") +
                     " IN " + _U._NAME +
            " ( "  + LEFT-TRIM(STRING(put_L._ROW, ">>>>9.99":U)) +
            " , "  + LEFT-TRIM(STRING(put_L._COL, ">>>>9.99":U)) +
            " ) NO-ERROR." 
       ELSE "/* set-position in " + _U._NAME +
            " ( " + LEFT-TRIM(STRING(put_L._ROW, ">>>>9.99":U)) +
            " , " + LEFT-TRIM(STRING(put_L._COL, ">>>>9.99":U)) +
            " ) */":U
       SKIP.
    IF (_L._COL ne m_L._COL) THEN wrttn[{&COL}] = YES.
    IF (_L._ROW ne m_L._ROW) THEN wrttn[{&ROW}] = YES.
    l_assign = FALSE.  /* Prevent unwanted "NO-ERROR." */
  END.
  IF (_L._WIDTH  NE m_L._WIDTH  AND NOT wrttn[{&WIDTH}]) OR 
     (_L._HEIGHT ne m_L._HEIGHT AND NOT wrttn[{&HEIGHT}]) 
  THEN DO:
    FIND _P WHERE _P._WINDOW-HANDLE = _U._WINDOW-HANDLE.
    PUT STREAM P_4GL UNFORMATTED SKIP 
       "      ":U
       IF l_set-size
       THEN "RUN " + (IF _P._adm-version < "ADM2"
                      THEN "set-size" ELSE "resizeObject") +
                     " IN " + _U._NAME +
            " ( "  +  LEFT-TRIM(STRING(put_L._HEIGHT, ">>>>9.99":U)) +
            " , "  +  LEFT-TRIM(STRING(put_L._WIDTH, ">>>>9.99":U)) +
            " ) NO-ERROR."
       ELSE "/* set-size in " + _U._NAME +
            " ( " + LEFT-TRIM(STRING(put_L._HEIGHT, ">>>>9.99":U)) +
            " , " + LEFT-TRIM(STRING(put_L._WIDTH, ">>>>9.99":U)) +
            " ) */":U
       SKIP.
    IF (_L._WIDTH  ne m_L._WIDTH)  THEN wrttn[{&WIDTH}]  = YES.
    IF (_L._HEIGHT ne m_L._HEIGHT) THEN wrttn[{&HEIGHT}] = YES.
    l_assign = FALSE.  /* Prevent unwanted "NO-ERROR." */
  END.
  
  /* Is the SmartObject removed from the layout? */
  IF (_L._REMOVE-FROM-LAYOUT NE m_L._REMOVE-FROM-LAYOUT) AND NOT wrttn[{&REMOVE}] 
  THEN DO:
    PUT STREAM P_4GL UNFORMATTED SKIP 
       "      RUN dispatch IN " _U._NAME
       " ('" + (IF put_L._REMOVE-FROM-LAYOUT THEN "hide" ELSE "view") +
       "':U) NO-ERROR.".
    wrttn[{&REMOVE}] = TRUE.
    l_assign = FALSE.  /* Prevent unwanted "NO-ERROR." */
  END.
  
  /* Skip a line before the next widget is dealt with. */
  PUT STREAM P_4GL UNFORMATTED SKIP (1).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

