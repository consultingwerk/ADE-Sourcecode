/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:   File: _genmult.p

  Description:
     The procedure is called from _gen4gl.p and produces a "CASE" statement
     that produces run-time layout changes to the Master Layout to achieve
     multiple layouts.

  Input Parameters:
      pLayout-var : the name of the variable used in the .w file to store the
                    value (string) for the active layout.  This variable 
                    equals the "{&WINDOW-NAME}-layout".  The name of the 
                    layout procedure will be "{&WINDOW-NAME}-layouts". That
                    is, the layout variable plus S.


  Output Parameters:
      <none>

  Author: D. Ross Hunter

  Created: 5/12/93

  Modified: 
    wood 9/28/95 Add input parameter   
    wood 6/24/96 Change behavior for SmartObjects.    
    wood 6/28/96 Remove NO-BOX, NO-LABELS, NO-UNDERLINE support 
                 (because it did not work Bug # 96-06-24-033)
    tsm  6/15/99 Added support for separator-fgcolor

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pLayout-var AS CHAR NO-UNDO.

/* ======================================================================== */
/*                       SHARED VARIABLES Definitions                       */
/* ======================================================================== */
{adeuib/uniwidg.i}           /* Universal widget TEMP-TABLE definitions     */
{adeuib/layout.i}            /* Definitions of the layout records           */
{adeuib/sharvars.i}          /* UIB shared variables                        */
DEFINE SHARED STREAM P_4GL.
DEFINE BUFFER w_U FOR _U.
DEFINE BUFFER f_U FOR _U.
DEFINE BUFFER f_L FOR _L.
DEFINE BUFFER m_L FOR _L.

DEFINE VARIABLE fram_exp        AS CHARACTER NO-UNDO.
DEFINE VARIABLE f_e_len         AS INTEGER   NO-UNDO.    
DEFINE VARIABLE lo_list         AS CHARACTER NO-UNDO INIT "Master Layout":U.
DEFINE VARIABLE lo_com          AS CHARACTER NO-UNDO.
DEFINE VARIABLE lo_exp          AS CHARACTER NO-UNDO.
DEFINE VARIABLE differ          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE first-lo        AS LOGICAL   NO-UNDO INIT TRUE.  
DEFINE VARIABLE isa-SmartObject AS LOGICAL   NO-UNDO.
DEFINE VARIABLE position        AS INTEGER   NO-UNDO.
DEFINE VARIABLE w_NAME          AS CHARACTER NO-UNDO.
DEFINE VARIABLE w_n_len         AS INTEGER   NO-UNDO.

/* Find the current procedure and its window. (w_U is the _U record for the
   window).  */
FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
FIND w_U WHERE w_U._HANDLE = _h_win.    

/* See if this is a SmartObject. */
RUN adeuib/_isa.p (INTEGER(RECID(_P)), "SmartObject":U, OUTPUT isa-SmartObject). 
                                        
PUT STREAM P_4GL UNFORMATTED SKIP (1)
  "/* _MULTI-LAYOUT-RUN-TIME-ADJUSTMENTS */"                             SKIP (1).
  
FOR EACH _LAYOUT WHERE _LAYOUT._LO-NAME NE "Master Layout":
  IF CAN-FIND(_L WHERE _L._u-recid = RECID(w_U) AND
                       _L._LO-NAME = _LAYOUT._LO-NAME) THEN
  DO:   /* This layout applies to this  window */
    /* First output the header information that needs to be read back in */
    ASSIGN lo_exp = REPLACE(REPLACE(_LAYOUT._EXPRESSION,CHR(13),""),
                            CHR(10),CHR(10) + FILL(" ",16))
           lo_com = REPLACE(REPLACE(_LAYOUT._COMMENT,CHR(13),""),
                            CHR(10),CHR(10) + FILL(" ",16)).  
                            
    /* Add the layout name to the list */
    lo_list = lo_list + ",":U + _LAYOUT._LO-NAME.
    
    /* Reformat the lo_com if necessary */
    IF LENGTH(lo_com) > 54 THEN DO:
      ASSIGN position = 0.
      DO WHILE LENGTH(lo_com) - position > 54:
        ASSIGN position = position +
                          R-INDEX(SUBSTRING(lo_com, position + 1, 54)," ")
               lo_com   = SUBSTRING(lo_com, 1, position - 1) +
                          CHR(10) + FILL(" ",16) +
                          SUBSTRING(lo_com, position)
               position = position + 17.
      END.
    END.
    PUT STREAM P_4GL UNFORMATTED
      "/* LAYOUT-NAME: ~"" + _LAYOUT._LO-NAME + "~""                          SKIP
      "   LAYOUT-TYPE: " + IF _LAYOUT._GUI-BASED THEN "GUI" ELSE "CHARACTER"  SKIP
      "   EXPRESSION:  " + lo_exp                                             SKIP
      "   COMMENT:     " + lo_com                                             SKIP
      FILL(" ",72) + "*/"                                                     SKIP.
      
    /* See if this layout differs from the Master layout                    */
    differ = FALSE.
    
    CHKBLOCK:
    FOR EACH m_L WHERE m_L._LO-NAME = "{&Master-Layout}":U,
        EACH _U WHERE RECID(_U) = m_L._U-recid AND _U._WINDOW-HANDLE = _h_win
             BY IF _U._TYPE = "WINDOW" THEN 1 ELSE
                IF CAN-DO("DIALOG-BOX,FRAME",_U._TYPE) THEN 2 ELSE 3
             BY _U._NAME:
      FIND _L WHERE _L._LO-NAME = _LAYOUT._LO-NAME AND
                    _L._u-recid = m_L._u-recid.
      IF _L._BGCOLOR NE m_L._BGCOLOR             OR _L._COL NE m_L._COL               OR
         _L._CONVERT-3D-COLORS NE m_L._CONVERT-3D-COLORS OR
         _L._EDGE-PIXELS NE m_L._EDGE-PIXELS     OR _L._FGCOLOR NE m_L._FGCOLOR       OR
         _L._FILLED NE m_L._FILLED               OR _L._FONT NE m_L._FONT             OR
         _L._GRAPHIC-EDGE NE m_L._GRAPHIC-EDGE   OR _L._HEIGHT NE m_L._HEIGHT         OR
         _L._REMOVE-FROM-LAYOUT                  OR _L._NO-FOCUS NE m_L._NO-FOCUS     OR
         _L._ROW NE m_L._ROW                     OR _L._SEPARATORS NE m_L._SEPARATORS OR
         _L._GROUP-BOX NE m_L._GROUP-BOX         OR _L._ROUNDED NE m_L._ROUNDED       OR
         _L._SEPARATOR-FGCOLOR NE m_L._SEPARATOR-FGCOLOR OR
         _L._TITLE-BGCOLOR NE m_L._TITLE-BGCOLOR OR
         _L._TITLE-FGCOLOR NE m_L._TITLE-FGCOLOR OR
         _L._VIRTUAL-HEIGHT NE m_L._VIRTUAL-HEIGHT OR
         _L._VIRTUAL-WIDTH NE m_L._VIRTUAL-WIDTH OR _L._WIDTH NE m_L._WIDTH THEN DO:
         differ = TRUE.
         LEAVE CHKBLOCK.
      END.  /* A difference has been found */
    END.  /* CHKBLOCK */

    IF differ AND lo_exp ne "":U THEN DO:              
      /* Write out the setting of the basic layout as follows:
             IF expression THEN
                RUN layout-cases (INPUT '<layout-name>').
             ELSE IF expresssion...
         For SmartObjects, however, don't go to the master layout directly. Just
         set the Default-Layout attribute.
             IF expression THEN
                RUN set-attribute-list ('Default-Layout=<layout-name>').
             ELSE IF expresssion...
       */
      PUT STREAM P_4GL UNFORMATTED  
         (IF NOT first-lo THEN "ELSE IF " ELSE "IF ") lo_exp " THEN " SKIP
         "  "
         (IF isa-SmartObject
                  THEN (IF _P._adm-version < "ADM2"
                           THEN "RUN set-attribute-list ('Default-Layout=":U
                           ELSE "DYNAMIC-FUNCTION('setDefaultLayout':U, '":U )
                  ELSE "RUN " + pLayout-Var + "s (INPUT '" )
         + _LAYOUT._LO-NAME + "':U) NO-ERROR."
          SKIP(1).
      first-lo = FALSE.
    END.  /* This layout differs from the master */
  END.  /* Have a set of layout records for this layout */
END. /* For each _LAYOUT definition */    

/* Now write out the layout-options and the default layout for SmartObjects. */
IF isa-smartObject THEN DO:
  IF _P._adm-version < "ADM2" THEN
    PUT STREAM P_4GL UNFORMATTED   
       SUBSTITUTE ("RUN set-attribute-list ('Layout-Options=~"&1~"':U).",
                   lo_list)
       SKIP(1).
  ELSE
    PUT STREAM P_4GL UNFORMATTED   
       SUBSTITUTE ("DYNAMIC-FUNCTION('setLayoutOptions':U, ~"&1~":U).",
                   lo_list)
       SKIP(1).
END.
PUT STREAM P_4GL UNFORMATTED "/* END-OF-LAYOUT-DEFINITIONS */"  SKIP (1).
