/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* -------------------------------------------------------------------

FILE: layout.i

Description:
      Temp-Table definitions for the UIB Multiple Layout support.
      2 Temp-Tables are define here: 1) _LAYOUT and 2) _L
      Also preprosessor names are defined for attribute access.

INPUT Parameters:
      {1} is "NEW" (or not)

Author: D. Ross Hunter 

Date Generated: 07/05/05

Note: This procedure is generated via the Property Sheet Generator and 
      the abAttribute table of the ab database. 
      DO NOT CHANGE THIS FILE WITHOUT UPDATING THE AB DATABASE AND 
      USING THE PROPERTY SHEET GENERATOR TO GENERATE THIS CODE 

------------------------------------------------------------------- */

/* Preprocessors used with layouts. */
&GLOBAL-DEFINE Master-Layout Master Layout
&GLOBAL-DEFINE Standard-Layouts Master Layout,Standard Character,~
Standard MS Windows,Standard Windows 95

DEFINE {1} SHARED TEMP-TABLE _LAYOUT
  FIELD _LO-NAME    AS CHAR      LABEL "Layout Name"   FORMAT "X(32)"
  FIELD _GUI-BASED  AS LOGICAL   INITIAL yes
                       VIEW-AS RADIO-SET HORIZONTAL      RADIO-BUTTONS
                       "GUI Based", TRUE, "Character Based", FALSE
  FIELD _EXPRESSION AS CHAR      LABEL "Run Time Expression"
                       VIEW-AS EDITOR SIZE 60 BY 4 SCROLLBAR-VERTICAL
  FIELD _COMMENT    AS CHAR      LABEL "Comment"
                       VIEW-AS EDITOR SIZE 60 BY 4 SCROLLBAR-VERTICAL
  FIELD _ACTIVE     AS LOGICAL   INITIAL no
                       VIEW-AS TOGGLE-BOX
        INDEX _LO-NAME IS PRIMARY UNIQUE _LO-NAME.

DEFINE {1} SHARED TEMP-TABLE _L
  FIELD _LO-NAME            AS CHAR LABEL "Layout Name"   FORMAT "X(32)"
  FIELD _u-recid            AS RECID
  FIELD _BASE-LAYOUT        AS CHAR LABEL "Derived from layout"    INITIAL "Master Layout":U
  FIELD _LABEL              AS CHAR LABEL "Label"        FORMAT "X(32)"
  FIELD _3-D                AS LOG  LABEL "3-D"                    INITIAL NO
  FIELD _BGCOLOR            AS INT  LABEL "Background Color"       INITIAL ?
  FIELD _COL-MULT           AS DEC  LABEL ""                       INITIAL ?
  FIELD _COL                AS DEC  LABEL "Column"                 INITIAL ?
                                    DECIMALS 2
  FIELD _CONVERT-3D-COLORS  AS LOG  LABEL "Convert-3D-Colors"      INITIAL NO
  FIELD _CUSTOM-POSITION    AS LOG  LABEL "Custom Position"        INITIAL NO
  FIELD _CUSTOM-SIZE        AS LOG  LABEL "Custom Size"            INITIAL NO
  FIELD _EDGE-PIXELS        AS INT  LABEL "Edge-Pixels"            INITIAL 1
  FIELD _FGCOLOR            AS INT  LABEL "Foreground Color"       INITIAL ?
  FIELD _FILLED             AS LOG  LABEL "Filled"                 INITIAL NO
  FIELD _FONT               AS INT  LABEL "Font"                   INITIAL ?
  FIELD _GRAPHIC-EDGE       AS LOG  LABEL "Graphic-Edge"           INITIAL NO
  FIELD _GROUP-BOX          AS LOG  LABEL "Group-Box"              INITIAL NO
  FIELD _HEIGHT             AS DEC  LABEL "Height-Characters"      INITIAL ?
                                    DECIMALS 2
  FIELD _NO-BOX             AS LOG  LABEL "No-Box"                 INITIAL NO
  FIELD _NO-FOCUS           AS LOG  LABEL "No-Focus"               INITIAL NO
  FIELD _NO-LABELS          AS LOG  LABEL "No-Labels"              INITIAL NO
  FIELD _NO-UNDERLINE       AS LOG  LABEL "No-Underline"           INITIAL NO
  FIELD _REMOVE-FROM-LAYOUT AS LOG  LABEL "Remove from Layout"     INITIAL NO
  FIELD _ROUNDED            AS LOG  LABEL "Rounded"                INITIAL NO
  FIELD _ROW                AS DEC  LABEL "Row"                    INITIAL ?
                                    DECIMALS 2
  FIELD _ROW-MULT           AS DEC  LABEL ""                       INITIAL ?
  FIELD _SEPARATOR-FGCOLOR  AS INT  LABEL "Separator FGColor"      INITIAL ?
  FIELD _SEPARATORS         AS LOG  LABEL "Separators"             INITIAL NO
  FIELD _TITLE-BGCOLOR      AS INT  LABEL "Title Background Color" INITIAL ?
  FIELD _TITLE-FGCOLOR      AS INT  LABEL "Title Foreground Color" INITIAL ?
  FIELD _VIRTUAL-HEIGHT     AS DEC  LABEL "Virtual-Height"         INITIAL ?
                                    DECIMALS 2
  FIELD _VIRTUAL-WIDTH      AS DEC  LABEL "Virtual-Width"          INITIAL ?
                                    DECIMALS 2
  FIELD _WIDTH              AS DEC  LABEL "Width"                  INITIAL ?
                                    DECIMALS 2
  FIELD _WIN-TYPE           AS LOG  LABEL ""                       INITIAL ?
         INDEX _LO-NAME IS PRIMARY _LO-NAME
         INDEX WIDGET   IS UNIQUE  _u-recid _LO-NAME.

