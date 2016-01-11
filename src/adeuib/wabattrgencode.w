&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/***********************************************************************
* Copyright (C) 2005-2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS file_list tgl_strip btnGenCode 
&Scoped-Define DISPLAYED-OBJECTS file_list tgl_strip 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnGenCode 
     LABEL "&Generate Code" 
     SIZE 22 BY 1.14.

DEFINE VARIABLE cStatus AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY 1.24 NO-UNDO.

DEFINE VARIABLE file_list AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     LIST-ITEMS "_cr_prop.p","tog-hand.i","tog-disp.i","tog-proc.i","atog-han.i","atog-dis.i","custprop.i","layout.i" 
     SIZE 59.2 BY 5.86 NO-UNDO.

DEFINE VARIABLE tgl_strip AS LOGICAL INITIAL no 
     LABEL "Strip <CR> from Code Blocks":L 
     VIEW-AS TOGGLE-BOX
     SIZE 54.4 BY 1.05 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     file_list AT ROW 2.05 COL 5.8 NO-LABEL
     tgl_strip AT ROW 9.29 COL 5.8
     btnGenCode AT ROW 11 COL 23
     cStatus AT ROW 12.67 COL 5 COLON-ALIGNED NO-LABEL
     "Files to Generate:" VIEW-AS TEXT
          SIZE 33.6 BY .81 AT ROW 1.14 COL 5.8
     "Options:" VIEW-AS TEXT
          SIZE 27.2 BY .81 AT ROW 8.33 COL 5.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 73.6 BY 13.19.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Property Sheet Code Generation"
         HEIGHT             = 13.19
         WIDTH              = 73.6
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.2
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.2
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN cStatus IN FRAME fMain
   NO-DISPLAY NO-ENABLE                                                 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Property Sheet Code Generation */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Property Sheet Code Generation */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnGenCode
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnGenCode wWin
ON CHOOSE OF btnGenCode IN FRAME fMain /* Generate Code */
DO:
  /* Strip <CR> out of code blocks, if desired */
  IF tgl_strip:CHECKED THEN DO:
     DISPLAY "Stripping <CR>'s" @ cStatus WITH FRAME {&FRAME-NAME}.
     FOR EACH abAttribute:
      abAttribute.trigCode   = REPLACE(abAttribute.trigCode,   CHR(13),"").
      abAttribute.attr2UCode = REPLACE(abAttribute.attr2UCode, CHR(13),"").
    END.
  END.
  
  /* Now generate the desired files */
  file_list = file_list:SCREEN-VALUE.
  IF CAN-DO(file_list, "_cr_prop.p") THEN RUN gen_cr_prop  ("_cr_prop.p").
  IF CAN-DO(file_list, "tog-disp.i") THEN RUN gen_tog-disp ("tog-disp.i").
  IF CAN-DO(file_list, "tog-hand.i") THEN RUN gen_tog-hand ("tog-hand.i").
  IF CAN-DO(file_list, "tog-proc.i") THEN RUN gen_tog-proc ("tog-proc.i").
  IF CAN-DO(file_list, "atog-dis.i") THEN RUN gen_atog-disp ("atog-dis.i").
  IF CAN-DO(file_list, "atog-han.i") THEN RUN gen_atog-hand ("atog-han.i").
  IF CAN-DO(file_list, "custprop.i") THEN RUN gen_custprop ("custprop.i").
  IF CAN-DO(file_list, "layout.i")   THEN RUN gen_layout   ("layout.i").
  
  /* Message */
   DISPLAY "" @ cStatus WITH FRAME {&FRAME-NAME}.
  MESSAGE "Done." VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY file_list tgl_strip 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE file_list tgl_strip btnGenCode 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen_atog-disp wWin 
PROCEDURE gen_atog-disp :
/* -----------------------------------------------------------
  Purpose: Generate the .i that creates the Toggle widgets on
           Advanced Property Sheet.
  Parameters:  
           file_name: name of file to generate.   
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER file_name AS CHAR NO-UNDO.

  DISPLAY "Generating " + file_name @ cStatus WITH FRAME {&FRAME-NAME}.
  OUTPUT TO VALUE(file_name).
  
  PUT UNFORMATTED
     '/***********************************************************************'   SKIP
     '* Copyright (C) 2005-2006 by Progress Software Corporation. All rights *'   SKIP
     '* reserved.  Prior versions of this work may contain portions          *'   SKIP
     '* contributed by participants of Possenet.                             *'   SKIP
     '*                                                                      *'   SKIP
     '***********************************************************************/'   SKIP
     "/* -------------------------------------------------------------------"     SKIP (1)
     "FILE: atog-dis.i"                                                           SKIP (1)
     "Description:"                                                               SKIP
     "      Toggle initialization and trigger code to be included in _advprop.w." SKIP (1)
     "Author: D. Ross Hunter "                                                    SKIP (1)
     "Date Generated: " TODAY                                                     SKIP (1)
     "Note: This procedure is generated via the Property Sheet Generator and "    SKIP 
     "      the abAttribute table of the ab database. "                           SKIP 
     "      DO NOT CHANGE THIS FILE WITHOUT UPDATING THE AB DATABASE AND "        SKIP 
     "      USING THE PROPERTY SHEET GENERATOR TO GENERATE THIS CODE "            SKIP (1)
     "------------------------------------------------------------------- */"     SKIP (1).
  
  FOR EACH abAttribute WHERE class = 9 AND NOT PROC BY NAME:
    IF name NE "NO-TITLE" THEN DO:
      PUT UNFORMATTED "  WHEN """ + NAME + """ THEN DO:" SKIP.
      PUT UNFORMATTED
       "    CREATE TOGGLE-BOX h_" + NAME SKIP
       "        ASSIGN FRAME         = FRAME adv-dial:HANDLE" SKIP
       "               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc" SKIP
       "               COLUMN        = IF togcnt <= tog-rows THEN tog-col-1" SKIP
       "                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2" SKIP
       "                               ELSE IF togcnt <= tog-rows * 3 THEN tog-col-3" SKIP
       "                               ELSE tog-col-4" SKIP
       "               LABEL         = """ + ENTRY(1,chrData,"!") + """" SKIP
       "               CHECKED       = " + 
         IF NUM-ENTRIES(chrData,"!") = 2  THEN ENTRY(2,chrData,"!") ELSE
            "IF AVAILABLE _F THEN " + ENTRY(3,chrData,"!") + " ELSE " + 
                                      ENTRY(2,chrData,"!") SKIP
       "               SENSITIVE     = TRUE" SKIP
       "        TRIGGERS:" SKIP
       "          ON VALUE-CHANGED DO:" SKIP
       trigCode SKIP
       "          END." SKIP
       "        END TRIGGERS." SKIP
       "  END." SKIP (1).
    END.   
  END.   
  OUTPUT CLOSE.                               
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen_atog-hand wWin 
PROCEDURE gen_atog-hand :
/* -----------------------------------------------------------
  Purpose: Generate the .i that Defines the handles that will
           be used to create the Toggle widgets on Advanced Property
           Sheet.
  Parameters:  
           file_name: name of file to generate.   
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER file_name AS CHAR NO-UNDO.

  DISPLAY "Generating " + file_name @ cStatus WITH FRAME {&FRAME-NAME}.
  OUTPUT TO VALUE(file_name).
  
  PUT UNFORMATTED
    '/*********************************************************************'     SKIP
    '* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *'     SKIP
    '* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *'     SKIP
    '* below.  All Rights Reserved.                                       *'     SKIP
    '*                                                                    *'     SKIP
    '* The Initial Developer of the Original Code is PSC.  The Original   *'     SKIP
    '* Code is Progress IDE code released to open source December 1, 2000.*'     SKIP
    '*                                                                    *'     SKIP
    '* The contents of this file are subject to the Possenet Public       *'     SKIP
    '* License Version 1.0 (the "License"); you may not use this file     *'     SKIP
    '* except in compliance with the License.  A copy of the License is   *'     SKIP
    '* available as of the date of this notice at                         *'     SKIP
    '* http://www.possenet.org/license.html                               *'     SKIP
    '*                                                                    *'     SKIP
    '* Software distributed under the License is distributed on an "AS IS"*'     SKIP
    '* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*'     SKIP
    '* should refer to the License for the specific language governing    *'     SKIP
    '* rights and limitations under the License.                          *'     SKIP
    '*                                                                    *'     SKIP
    '* Contributors:                                                      *'     SKIP
    '*                                                                    *'     SKIP
    '*********************************************************************/'     SKIP
     "/* -------------------------------------------------------------------"     SKIP (1)
     "FILE: atog-han.i"                                                           SKIP (1)
     "Description:"                                                               SKIP
     "      Toggle handle definitions to be included in _advprop.w."              SKIP (1)
     "Author: D. Ross Hunter "                                                    SKIP (1)
     "Date Generated: " TODAY                                                     SKIP (1)
     "Note: This procedure is generated via the Property Sheet Generator and "    SKIP 
     "      the abAttribute table of the ab database. "                           SKIP 
     "      DO NOT CHANGE THIS FILE WITHOUT UPDATING THE AB DATABASE AND "        SKIP 
     "      USING THE PROPERTY SHEET GENERATOR TO GENERATE THIS CODE "            SKIP (1)
     "------------------------------------------------------------------- */"     SKIP (1).
 
  FOR EACH abAttribute WHERE class = 9 AND NOT PROC BY NAME:
    PUT UNFORMATTED "DEFINE VARIABLE h_" + NAME + FILL(" ",22 - LENGTH(NAME)) +
                  "AS WIDGET-HANDLE NO-UNDO." SKIP.
  END.

  OUTPUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen_cr_prop wWin 
PROCEDURE gen_cr_prop :
/* -----------------------------------------------------------
  Purpose: Generate the .p that will create the _PROP temp 
           table in the UIB.  
  Parameters:  file_name: name of file to generate.   
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER file_name AS CHAR NO-UNDO.
  
  DEFINE VARIABLE widglist AS CHAR NO-UNDO.   

  DISPLAY "Generating " + file_name @ cStatus WITH FRAME {&FRAME-NAME}.
  
  OUTPUT TO VALUE(file_name).
 
  PUT UNFORMATTED
    '/*********************************************************************'     SKIP
    '* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *'     SKIP
    '* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *'     SKIP
    '* below.  All Rights Reserved.                                       *'     SKIP
    '*                                                                    *'     SKIP
    '* The Initial Developer of the Original Code is PSC.  The Original   *'     SKIP
    '* Code is Progress IDE code released to open source December 1, 2000.*'     SKIP
    '*                                                                    *'     SKIP
    '* The contents of this file are subject to the Possenet Public       *'     SKIP
    '* License Version 1.0 (the "License"); you may not use this file     *'     SKIP
    '* except in compliance with the License.  A copy of the License is   *'     SKIP
    '* available as of the date of this notice at                         *'     SKIP
    '* http://www.possenet.org/license.html                               *'     SKIP
    '*                                                                    *'     SKIP
    '* Software distributed under the License is distributed on an "AS IS"*'     SKIP
    '* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*'     SKIP
    '* should refer to the License for the specific language governing    *'     SKIP
    '* rights and limitations under the License.                          *'     SKIP
    '*                                                                    *'     SKIP
    '* Contributors:                                                      *'     SKIP
    '*                                                                    *'     SKIP
    '*********************************************************************/'     SKIP
     "/* -------------------------------------------------------------------"     SKIP (1)
     "FILE: _cr_prop.p"                                                           SKIP (1)
     "Description:"                                                               SKIP
     "      Procedure that is called at the initialization of the UIB to"         SKIP
     "      create and initialize all of the property Temp-Table Records."        SKIP (1)
     "INPUT Parameters:"                                                          SKIP
     "      (None)"                                                               SKIP (1)
     "Author: D. Ross Hunter "                                                    SKIP (1)
     "Date Generated: " TODAY                                                     SKIP (1)
     "Note: This procedure is generated via the Property Sheet Generator and "    SKIP 
     "      the abAttribute table of the ab database. "                           SKIP 
     "      DO NOT CHANGE THIS FILE WITHOUT UPDATING THE AB DATABASE AND "        SKIP 
     "      USING THE PROPERTY SHEET GENERATOR TO GENERATE THIS CODE "            SKIP (1)
     "------------------------------------------------------------------- */"     SKIP (1).

 
  PUT UNFORMATTED
    "~{adeuib/property.i}" SKIP (1).

  FOR EACH abAttribute BY NAME:
    ASSIGN widglist = (IF abAttribute.wind THEN "WINDOW,"         ELSE "") +
                      (IF abAttribute.dial THEN "DIALOG-BOX,"     ELSE "") +
                      (IF abAttribute.frm  THEN "FRAME,"          ELSE "") +
                      (IF abAttribute.brow THEN "BROWSE,"         ELSE "") +
                      (IF abAttribute.butt THEN "BUTTON,"         ELSE "") +
                      (IF abAttribute.comb THEN "COMBO-BOX,"      ELSE "") +
                      (IF abAttribute.edit THEN "EDITOR,"         ELSE "") +
                      (IF abAttribute.fil  THEN "FILL-IN,"        ELSE "").
    ASSIGN widglist = widglist +
                      (IF abAttribute.imag THEN "IMAGE,"          ELSE "") +
                      (IF abAttribute.radi THEN "RADIO-SET,"      ELSE "") +
                      (IF abAttribute.rec  THEN "RECTANGLE,"      ELSE "") +
                      (IF abAttribute.sele THEN "SELECTION-LIST," ELSE "") +
                      (IF abAttribute.slid THEN "SLIDER,"         ELSE "") +
                      (IF abAttribute.togg THEN "TOGGLE-BOX,"     ELSE "") +
                      (IF abAttribute.txt  THEN "TEXT,"           ELSE "") +
                      (IF abAttribute.OCX  THEN "OCX"             ELSE "").
    ASSIGN widglist = TRIM(widglist,","). 
                     
    PUT UNFORMATTED 
                  "CREATE _PROP." SKIP
                  "ASSIGN _PROP._NAME      = """ abAttribute.name """"      SKIP
                  "       _PROP._SQ        = " abAttribute.sq               SKIP
                  "       _PROP._DISP-SEQ  = " abAttribute.displaySeq         SKIP
                  "       _PROP._CLASS     = " abAttribute.class            SKIP
                  "       _PROP._DATA-TYPE = """ abAttribute.dataType """" SKIP
                  "       _PROP._SIZE      = """ abAttribute.widgSize """"  SKIP
                  "       _PROP._ADV       = " abAttribute.adv              SKIP
                  "       _PROP._CUSTOM    = " abAttribute.custom           SKIP
                  "       _PROP._GEOM      = " abAttribute.geom             SKIP
                  "       _PROP._WIDGETS   = """ widglist """."    SKIP (1).
  END.
  OUTPUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen_custprop wWin 
PROCEDURE gen_custprop :
/* -----------------------------------------------------------
  Purpose: Generate the .i that maps between Property/Values
           and the internal UIB Universal Widget Records.
           
           This defines only the mapping for Attributes that
           can be specified in Custom Widget definitions.
           
  Parameters:  
           file_name: name of file to generate.   
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER file_name AS CHAR NO-UNDO.
  
  DEFINE VARIABLE widglist AS CHAR NO-UNDO.   

  DISPLAY "Generating " + file_name @ cStatus WITH FRAME {&FRAME-NAME}.
  OUTPUT TO VALUE(file_name).

  PUT UNFORMATTED 
     '/************************************************************************'     SKIP
     '* Copyright (C) 2000-2006 by Progress Software Corporation.  All rights *'     SKIP
     '* reserved.  Prior versions of this work may contain portions           *'     SKIP
     '* contributed by participants of Possenet.                              *'     SKIP
     '************************************************************************/'     SKIP
    "/* ***************************************************************************" 
    SKIP (1)
    "   File: custprop.i" SKIP
    "   Description:"   SKIP
    "         This is an automatically generated file. It creates an INCLUDE file" SKIP
    "         that maps betweed Property Names (_PROP._NAME) and contents of the " SKIP 
    "         Universal widget record (_U).  The following environment is assumed" SKIP
    "         to exist:" SKIP
    "          _U - the Universal Widget record to modify" SKIP
    "          _F - the Field record (NOT AVAILABLE for container widgetts) " SKIP
    "          _C - a) the _C record associated with _U, for container widgets" SKIP
    "               b) the _C record for the parent container, for field widgets" SKIP
    "          parent_U - the record of the parent container, for field widgets" SKIP
    "          cValue - the character value to assign " SKIP
    "          dValue - the decimal value of cValue (or ?) " SKIP
    "          iValue - the integer value of cValue (or ?) " SKIP
    "          lValue - the logical value of cValue (or ?) " SKIP (1) 
    "          err_text - is assumed to exist as a CHAR variable.  This can" SKIP
    "                     be set internally to flag an invalid value for" SKIP
    "                     an attribute.  A message of the following form" SKIP
    "                     is created.: " SKIP
    "                        Invalid Attribute Value: cValue " SKIP
    "                        err_text  " SKIP(1)         
    "   Author: Bill Wodd "                                                       SKIP (1)
    "   Date Generated: " TODAY                                                   SKIP (1)
    "   Note: This procedure is generated via the Property Sheet Generator and "    SKIP 
    "         the abAttribute table of the ab database. "                           SKIP 
    "         DO NOT CHANGE THIS FILE WITHOUT UPDATING THE AB DATABASE AND "        SKIP 
    "         USING THE PROPERTY SHEET GENERATOR TO GENERATE THIS CODE "            SKIP (1)
    "*************************************************************************** */" SKIP
    SKIP
    .
          
  FOR EACH abAttribute WHERE abAttribute.custom BY abAttribute.name:      
    /* Create line "WHEN "attr":U THEN _F._ATT = lValue" */
    PUT UNFORMATTED 
      "  WHEN ~"" + abAttribute.name + "~":U THEN" + FILL(" ":U, MAX(0,20 - LENGTH(abAttribute.name))) +
      abAttribute.attr2UCode
      SKIP.  
  END.
  
  OUTPUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen_layout wWin 
PROCEDURE gen_layout :
/* -----------------------------------------------------------
  Purpose: Generate _L and _LAYOUT temptable definitions and
           the PREPROCESSOR names to reference the attribute
           array elements in _LAYOUT. 
  Parameters:
           file_name: name of file to generate.   
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER file_name AS CHAR              NO-UNDO.
  DEFINE VARIABLE init-no-lst AS CHAR                   NO-UNDO.
  DEFINE VARIABLE fld-nm      AS CHAR                   NO-UNDO.
  
  ASSIGN init-no-lst = "3-D,CONVERT-3D-COLORS,CUSTOM-POSITION,"
         init-no-lst = init-no-lst + "CUSTOM-SIZE,FILLED,GRAPHIC-EDGE,"
         init-no-lst = init-no-lst + "GROUP-BOX,NO-BOX,NO-FOCUS,"
         init-no-lst = init-no-lst + "NO-LABELS,NO-UNDERLINE,REMOVE-FROM-LAYOUT,"
         init-no-lst = init-no-lst + "ROUNDED,SEPARATORS".

  DISPLAY "Generating " + file_name @ cStatus WITH FRAME {&FRAME-NAME}.
  OUTPUT TO VALUE(file_name).
 
  PUT UNFORMATTED
    '/*********************************************************************'     SKIP
    '* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *'     SKIP
    '* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *'     SKIP
    '* below.  All Rights Reserved.                                       *'     SKIP
    '*                                                                    *'     SKIP
    '* The Initial Developer of the Original Code is PSC.  The Original   *'     SKIP
    '* Code is Progress IDE code released to open source December 1, 2000.*'     SKIP
    '*                                                                    *'     SKIP
    '* The contents of this file are subject to the Possenet Public       *'     SKIP
    '* License Version 1.0 (the "License"); you may not use this file     *'     SKIP
    '* except in compliance with the License.  A copy of the License is   *'     SKIP
    '* available as of the date of this notice at                         *'     SKIP
    '* http://www.possenet.org/license.html                               *'     SKIP
    '*                                                                    *'     SKIP
    '* Software distributed under the License is distributed on an "AS IS"*'     SKIP
    '* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*'     SKIP
    '* should refer to the License for the specific language governing    *'     SKIP
    '* rights and limitations under the License.                          *'     SKIP
    '*                                                                    *'     SKIP
    '* Contributors:                                                      *'     SKIP
    '*                                                                    *'     SKIP
    '*********************************************************************/'     SKIP
     "/* -------------------------------------------------------------------"     SKIP (1)
     "FILE: layout.i"                                                             SKIP (1)
     "Description:"                                                               SKIP
     "      Temp-Table definitions for the UIB Multiple Layout support."          SKIP
     "      2 Temp-Tables are define here: 1) _LAYOUT and 2) _L"                  SKIP
     "      Also preprosessor names are defined for attribute access."            SKIP (1)
     "INPUT Parameters:"                                                          SKIP
     "      ~{1} is ~"NEW~" (or not)"                                             SKIP (1)
     "Author: D. Ross Hunter "                                                    SKIP (1)
     "Date Generated: " TODAY                                                     SKIP (1)
     "Note: This procedure is generated via the Property Sheet Generator and "    SKIP 
     "      the abAttribute table of the ab database. "                           SKIP 
     "      DO NOT CHANGE THIS FILE WITHOUT UPDATING THE AB DATABASE AND "        SKIP 
     "      USING THE PROPERTY SHEET GENERATOR TO GENERATE THIS CODE "            SKIP (1)
     "------------------------------------------------------------------- */"     SKIP (1)
     "/* Preprocessors used with layouts. */"                                     SKIP
     "&GLOBAL-DEFINE Master-Layout Master Layout"                                 SKIP
     "&GLOBAL-DEFINE Standard-Layouts Master Layout,Standard Character,~~"        SKIP
     "Standard MS Windows,Standard Windows 95"                                    SKIP (1).

  PUT UNFORMATTED
     "DEFINE ~{1} SHARED TEMP-TABLE _LAYOUT"                                      SKIP
     "  FIELD _LO-NAME    AS CHAR      LABEL ~"Layout Name~"   FORMAT ~"X(32)~""  SKIP
     "  FIELD _GUI-BASED  AS LOGICAL   INITIAL yes"                               SKIP
     "                       VIEW-AS RADIO-SET HORIZONTAL      RADIO-BUTTONS"     SKIP
     "                       ~"GUI Based~", TRUE, ~"Character Based~", FALSE"     SKIP
     "  FIELD _EXPRESSION AS CHAR      LABEL ~"Run Time Expression~""             SKIP
     "                       VIEW-AS EDITOR SIZE 60 BY 4 SCROLLBAR-VERTICAL"      SKIP
     "  FIELD _COMMENT    AS CHAR      LABEL ~"Comment~""                         SKIP
     "                       VIEW-AS EDITOR SIZE 60 BY 4 SCROLLBAR-VERTICAL"      SKIP
     "  FIELD _ACTIVE     AS LOGICAL   INITIAL no"                                SKIP
     "                       VIEW-AS TOGGLE-BOX"                                  SKIP
     "        INDEX _LO-NAME IS PRIMARY UNIQUE _LO-NAME."                         SKIP (1).
     
  PUT UNFORMATTED
     "DEFINE ~{1} SHARED TEMP-TABLE _L"                                           SKIP
     "  FIELD _LO-NAME            AS CHAR LABEL ~"Layout Name~"" +
                                  "   FORMAT ~"X(32)~""                           SKIP
     "  FIELD _u-recid            AS RECID"                                       SKIP
     "  FIELD _BASE-LAYOUT        AS CHAR LABEL ~"Derived from layout~"    INITIAL ~"Master Layout~":U" SKIP
     "  FIELD _LABEL              AS CHAR LABEL ~"Label~"        FORMAT ~"X(32)~"" SKIP.

     FOR EACH abAttribute WHERE abAttribute.multiLayout BY abAttribute.SQ:
       fld-nm = IF NAME = "COLUMN":U THEN "COL":U ELSE NAME.
       PUT UNFORMATTED
     "  FIELD _" + fld-nm + FILL(" ",19 - LENGTH(fld-nm)) + "AS " + 
                   (IF abAttribute.dataType = "L" THEN "LOG " ELSE
                    IF abAttribute.dataType = "I" THEN "INT " ELSE
                    IF abAttribute.dataType = "C" THEN "CHAR" ELSE
                    IF abAttribute.dataType = "D" THEN "DEC " ELSE
                                               "RECID") +
                    " LABEL """ + ENTRY(1,abAttribute.chrData,"!") + """" +
                    FILL(" ",23 - LENGTH(ENTRY(1,abAttribute.chrData,"!"))) +
                    "INITIAL " + IF CAN-DO(init-no-lst, NAME)
                          THEN "NO" ELSE IF NAME = "EDGE-PIXELS" THEN "1" ELSE "?" 
                                                                                  SKIP.
       IF abAttribute.dataType = "D":U AND NOT CAN-DO("ROW-MULT,COL-MULT",NAME) THEN
         PUT UNFORMATTED FILL(" ":U,36) + "DECIMALS 2" SKIP.
     END.
  PUT UNFORMATTED
     "         INDEX _LO-NAME IS PRIMARY _LO-NAME"                                SKIP
     "         INDEX WIDGET   IS UNIQUE  _u-recid _LO-NAME."                      SKIP (1).
     
  OUTPUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen_tog-disp wWin 
PROCEDURE gen_tog-disp :
/* -----------------------------------------------------------
  Purpose: Generate the .i that creates the Toggle widgets on
           Property Sheet.
  Parameters:  
           file_name: name of file to generate.   
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER file_name AS CHAR NO-UNDO.

  DISPLAY "Generating " + file_name @ cStatus WITH FRAME {&FRAME-NAME}.
  OUTPUT TO VALUE(file_name).
  
  PUT UNFORMATTED
    '/*********************************************************************'     SKIP
    '* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *'     SKIP
    '* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *'     SKIP
    '* below.  All Rights Reserved.                                       *'     SKIP
    '*                                                                    *'     SKIP
    '* The Initial Developer of the Original Code is PSC.  The Original   *'     SKIP
    '* Code is Progress IDE code released to open source December 1, 2000.*'     SKIP
    '*                                                                    *'     SKIP
    '* The contents of this file are subject to the Possenet Public       *'     SKIP
    '* License Version 1.0 (the "License"); you may not use this file     *'     SKIP
    '* except in compliance with the License.  A copy of the License is   *'     SKIP
    '* available as of the date of this notice at                         *'     SKIP
    '* http://www.possenet.org/license.html                               *'     SKIP
    '*                                                                    *'     SKIP
    '* Software distributed under the License is distributed on an "AS IS"*'     SKIP
    '* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*'     SKIP
    '* should refer to the License for the specific language governing    *'     SKIP
    '* rights and limitations under the License.                          *'     SKIP
    '*                                                                    *'     SKIP
    '* Contributors:                                                      *'     SKIP
    '*                                                                    *'     SKIP
    '*********************************************************************/'     SKIP
     "/* -------------------------------------------------------------------"     SKIP (1)
     "FILE: tog-disp.i"                                                           SKIP (1)
     "Description:"                                                               SKIP
     "      Toggle initialization code to be included in _prpobj.p."              SKIP (1)
     "Author: D. Ross Hunter "                                                    SKIP (1)
     "Date Generated: " TODAY                                                     SKIP (1)
     "Note: This procedure is generated via the Property Sheet Generator and "    SKIP 
     "      the abAttribute table of the ab database. "                           SKIP 
     "      DO NOT CHANGE THIS FILE WITHOUT UPDATING THE AB DATABASE AND "        SKIP 
     "      USING THE PROPERTY SHEET GENERATOR TO GENERATE THIS CODE "            SKIP (1)
     "------------------------------------------------------------------- */"     SKIP (1).
  
  FOR EACH abAttribute WHERE class = 1 AND NOT PROC BY NAME:
    IF name NE "NO-TITLE" THEN DO:
      PUT UNFORMATTED "  WHEN """ + NAME + """ THEN DO:" SKIP.
      IF CAN-DO("CANCEL-BTN,DEFAULT-BTN",name) THEN
        PUT UNFORMATTED "    FIND x_U WHERE RECID(x_U) = _U._PARENT-RECID." SKIP
                        "    FIND _C  WHERE RECID(_C)  = x_U._x-recid." SKIP (1).
      PUT UNFORMATTED
       "    CREATE TOGGLE-BOX h_" + NAME SKIP
       "        ASSIGN FRAME         = FRAME prop_sht:HANDLE" SKIP
       "               ROW           = cur-row + ((togcnt - 1) MOD tog-rows) * tog-spc" SKIP
       "               COLUMN        = IF togcnt <= tog-rows THEN 4.5" SKIP
       "                               ELSE IF togcnt <= tog-rows * 2 THEN tog-col-2" SKIP
       "                               ELSE tog-col-3" SKIP
       "               LABEL         = """ + ENTRY(1,chrData,"!") + """" SKIP
       "               CHECKED       = " + 
         IF NUM-ENTRIES(chrData,"!") = 2  THEN ENTRY(2,chrData,"!") ELSE
            "IF AVAILABLE _F THEN " + ENTRY(3,chrData,"!") + " ELSE " + 
                                      ENTRY(2,chrData,"!") SKIP
       "               SENSITIVE     = TRUE" SKIP
       "        TRIGGERS:" SKIP
       "          ON VALUE-CHANGED PERSISTENT RUN " NAME + "_proc." SKIP
       "        END TRIGGERS." SKIP
       "  END." SKIP (1).
    END.   
  END.   
  OUTPUT CLOSE.                               
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen_tog-hand wWin 
PROCEDURE gen_tog-hand :
/* -----------------------------------------------------------
  Purpose: Generate the .i that Defines the handles that will
           be used to create the Toggle widgets on Property Sheet.
  Parameters:  
           file_name: name of file to generate.   
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER file_name AS CHAR NO-UNDO.

  DISPLAY "Generating " + file_name @ cStatus WITH FRAME {&FRAME-NAME}.
  OUTPUT TO VALUE(file_name).
  
  PUT UNFORMATTED
    '/*********************************************************************'     SKIP
    '* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *'     SKIP
    '* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *'     SKIP
    '* below.  All Rights Reserved.                                       *'     SKIP
    '*                                                                    *'     SKIP
    '* The Initial Developer of the Original Code is PSC.  The Original   *'     SKIP
    '* Code is Progress IDE code released to open source December 1, 2000.*'     SKIP
    '*                                                                    *'     SKIP
    '* The contents of this file are subject to the Possenet Public       *'     SKIP
    '* License Version 1.0 (the "License"); you may not use this file     *'     SKIP
    '* except in compliance with the License.  A copy of the License is   *'     SKIP
    '* available as of the date of this notice at                         *'     SKIP
    '* http://www.possenet.org/license.html                               *'     SKIP
    '*                                                                    *'     SKIP
    '* Software distributed under the License is distributed on an "AS IS"*'     SKIP
    '* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*'     SKIP
    '* should refer to the License for the specific language governing    *'     SKIP
    '* rights and limitations under the License.                          *'     SKIP
    '*                                                                    *'     SKIP
    '* Contributors:                                                      *'     SKIP
    '*                                                                    *'     SKIP
    '*********************************************************************/'     SKIP
     "/* -------------------------------------------------------------------"     SKIP (1)
     "FILE: tog-hand.i"                                                           SKIP (1)
     "Description:"                                                               SKIP
     "      Toggle handle definitions to be included in _proprty.p."              SKIP (1)
     "Author: D. Ross Hunter "                                                    SKIP (1)
     "Date Generated: " TODAY                                                     SKIP (1)
     "Note: This procedure is generated via the Property Sheet Generator and "    SKIP 
     "      the abAttribute table of the ab database. "                           SKIP 
     "      DO NOT CHANGE THIS FILE WITHOUT UPDATING THE AB DATABASE AND "        SKIP 
     "      USING THE PROPERTY SHEET GENERATOR TO GENERATE THIS CODE "            SKIP (1)
     "------------------------------------------------------------------- */"     SKIP (1).
 
  FOR EACH abAttribute WHERE class = 1 AND NOT PROC BY NAME:
    PUT UNFORMATTED "DEFINE VARIABLE h_" + NAME + FILL(" ",20 - LENGTH(NAME)) +
                  "AS WIDGET-HANDLE NO-UNDO." SKIP.
  END.

  OUTPUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen_tog-proc wWin 
PROCEDURE gen_tog-proc :
/* -----------------------------------------------------------
  Purpose: Generate the .i that contains the VALUE-CHANGED 
           procedures for the 
           the Toggle widgets on Property Sheet.
  Parameters:  
           file_name: name of file to generate.   
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER file_name AS CHAR NO-UNDO.

  DISPLAY "Generating " + file_name @ cStatus WITH FRAME {&FRAME-NAME}.
  OUTPUT TO VALUE(file_name).
  
  PUT UNFORMATTED
     '/************************************************************************'     SKIP
     '* Copyright (C) 2000-2006 by Progress Software Corporation.  All rights *'     SKIP
     '* reserved.  Prior versions of this work may contain portions           *'     SKIP
     '* contributed by participants of Possenet.                              *'     SKIP
     '************************************************************************/'     SKIP
     "/* -------------------------------------------------------------------"     SKIP (1)
     "FILE: tog-proc.i"                                                           SKIP (1)
     "Description:"                                                               SKIP
     "      Internal Procedures for toggle trigger code to be included in"        SKIP 
     "      _prpobj.p."                                                           SKIP (1)
     "Author: Tammy St.Pierre Hall "                                              SKIP (1)
     "Date Generated: " TODAY                                                     SKIP (1)
     "Note: This procedure is generated via the Property Sheet Generator and "    SKIP 
     "      the abAttribute table of the ab database. "                           SKIP 
     "      DO NOT CHANGE THIS FILE WITHOUT UPDATING THE AB DATABASE AND "        SKIP 
     "      USING THE PROPERTY SHEET GENERATOR TO GENERATE THIS CODE "            SKIP (1)
     "------------------------------------------------------------------- */"     SKIP (1).
  
  FOR EACH abAttribute WHERE class = 1 AND NOT PROC BY NAME:
    IF name NE "NO-TITLE" THEN DO:
      PUT UNFORMATTED "PROCEDURE " NAME + "_proc:" SKIP
      trigCode SKIP
      "END." SKIP(1).
    END.   
  END.   
  OUTPUT CLOSE.                               
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

