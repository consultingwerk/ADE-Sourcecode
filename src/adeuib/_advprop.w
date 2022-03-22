&Scoped-define WINDOW-NAME    adv-dial
&Scoped-define FRAME-NAME     adv-dial
/************************************************************************
* Copyright (C) 2005-2006 by Progress Software Corporation.  All rights *
* reserved.  Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                              *
************************************************************************/
/*------------------------------------------------------------------------

  File: _advprop.w

  Description: Advanced Property Sheet for the UIB.

  Input Parameters:
      u-recid  - The recid of the current widget
      lbl_wdth - The width of a label for FILL-INS and COMBO-BOXES in CHARACTERS
                 0 for other widgets.

  Output Parameters:
      <none>

  Author: 

  Created: 01/24/94 - 10:13 am

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&SCOPED-DEFINE USE-3D           YES
&GLOBAL-DEFINE WIN95-BTN        YES


/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER u-recid  AS RECID   NO-UNDO.
DEFINE INPUT PARAMETER lbl_wdth AS DECIMAL NO-UNDO.

/* Local Variable Definitions ---                                       */
{adeuib/uniwidg.i}
{adeuib/property.i}
{adecomm/adestds.i}
{adeuib/uibhlp.i}
{adeuib/layout.i}
{adeuib/sharvars.i}
{adeuib/atog-han.i}

DEFINE SHARED VARIABLE v-hgt  AS DECIMAL       NO-UNDO.
DEFINE SHARED VARIABLE v-wdth AS DECIMAL       NO-UNDO.

DEFINE VARIABLE ch            AS CHAR          NO-UNDO.
DEFINE VARIABLE child_handle  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE ctemp         AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h_align       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE frame_name    AS LOGICAL       NO-UNDO.
DEFINE VARIABLE h_help_lbl    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE help-string   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h_id_lbl      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE init-data     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE lbl_pixels    AS INTEGER       NO-UNDO.
DEFINE VARIABLE low-limit     AS INTEGER       NO-UNDO.
DEFINE VARIABLE tmp-handle    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h_row-hgt_lbl AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h_row-hgt     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h_v-hgt_lbl   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h_v-hgt       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h_v-wdth_lbl  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h_v-wdth      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE fld-grp       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE stupid        AS LOGICAL       NO-UNDO.
DEFINE VARIABLE upr-limit     AS INTEGER       NO-UNDO.
DEFINE VARIABLE userNames     AS CHAR          NO-UNDO.

DEFINE VARIABLE col-lbl-adj       AS INTEGER INITIAL 0             NO-UNDO.
DEFINE VARIABLE cur-row           AS DECIMAL DECIMALS 2            NO-UNDO.
DEFINE VARIABLE i                 AS INTEGER                       NO-UNDO.
DEFINE VARIABLE _HEIGHT-P         AS INTEGER LABEL "Height Pixels"     INITIAL ?.
DEFINE VARIABLE _WIDTH-P          AS INTEGER LABEL "Width Pixels"      INITIAL ?.
DEFINE VARIABLE _ROW-HEIGHT-P     AS INTEGER LABEL "Row Height Pixels" INITIAL ?.
DEFINE VARIABLE _VIRTUAL-HEIGHT-P AS INTEGER INITIAL ?.
DEFINE VARIABLE _VIRTUAL-WIDTH-P  AS INTEGER INITIAL ?.
DEFINE VARIABLE _X                AS INTEGER LABEL "X"             INITIAL ?.
DEFINE VARIABLE _Y                AS INTEGER LABEL "Y"             INITIAL ?.
DEFINE VARIABLE sav_row           LIKE _L._ROW               NO-UNDO.
DEFINE VARIABLE sav_col           LIKE _L._COL               NO-UNDO.
DEFINE VARIABLE sav_width         LIKE _L._WIDTH             NO-UNDO.
DEFINE VARIABLE sav_height        LIKE _L._HEIGHT            NO-UNDO.
DEFINE VARIABLE sav_v-height      LIKE _L._VIRTUAL-HEIGHT    NO-UNDO.
DEFINE VARIABLE sav_v-width       LIKE _L._VIRTUAL-WIDTH     NO-UNDO.
DEFINE VARIABLE tmp-strng         AS CHARACTER               NO-UNDO.
DEFINE VARIABLE togcnt            AS INTEGER                 NO-UNDO.
DEFINE VARIABLE tog-col-1         AS DECIMAL DECIMALS 2  INITIAL 3.5   NO-UNDO.
DEFINE VARIABLE tog-col-2         AS DECIMAL DECIMALS 2  INITIAL 26    NO-UNDO.
DEFINE VARIABLE tog-col-3         AS DECIMAL DECIMALS 2  INITIAL 48    NO-UNDO.
DEFINE VARIABLE tog-col-4         AS DECIMAL DECIMALS 2  INITIAL 67    NO-UNDO.
DEFINE VARIABLE tog-rows          AS INTEGER                 NO-UNDO.
DEFINE VARIABLE tog-spc           AS DECIMAL INITIAL .99     NO-UNDO.

DEFINE VARIABLE valid-items  AS CHARACTER            NO-UNDO.
define variable dialogTitle as character no-undo init "Advanced Properties":L. 

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.
DEFINE BUFFER parent_C FOR _C.
DEFINE BUFFER sync_L   FOR _L.

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF
/* New-line character */
&Scoped-define NL CHR(10)




/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn_layout 
     LABEL "Sync With Master...":L 
     SIZE 30 BY 1.125.

DEFINE VARIABLE lbl-dummy  AS CHAR FORMAT "X" LABEL "Custom Lists"          NO-UNDO.
DEFINE VARIABLE h_lbl_lbl  AS HANDLE                                        NO-UNDO. 
DEFINE VARIABLE lbl-dummy2 AS CHAR INITIAL "Generated Code Layout Unit:"    NO-UNDO. 
DEFINE VARIABLE geom-rect  AS CHAR INITIAL " Geometry - Pixels":L35         NO-UNDO.
DEFINE VARIABLE mv-dist    AS DECIMAL                                       NO-UNDO.
DEFINE VARIABLE wh         AS WIDGET-HANDLE                                 NO-UNDO.
       
/* Query definitions                                                    */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME adv-dial
     _U._PRIVATE-DATA VIEW-AS EDITOR SIZE 63 BY 4 SCROLLBAR-VERTICAL 
              {&STDPH_ED4GL_SMALL}  AT ROW 1.13 COL 16 COLON-ALIGN SKIP ({&VM_WID})
     lbl-dummy2 AT 4 NO-LABEL FORMAT "X(28)" VIEW-AS TEXT
     _U._LAYOUT-UNIT  VIEW-AS RADIO-SET HORIZONTAL RADIO-BUTTONS
                                     "Characters",TRUE,"Pixels",FALSE
                               &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                                     SIZE 25 BY 1 NO-LABEL AT 33
                               &ELSE SIZE 28 BY 1 NO-LABEL AT 31 &ENDIF
     frame_name       VIEW-AS TOGGLE-BOX LABEL "~{&&FRAME-NAME}" AT 60
                      SKIP ({&VM_WID})
     lbl-dummy AT 4
     _U._USER-LIST[1]    VIEW-AS TOGGLE-BOX LABEL "~{&&List-1}" 
                                 AT ROW-OF lbl-dummy COLUMN 20
     _U._USER-LIST[2]    VIEW-AS TOGGLE-BOX LABEL "~{&&List-2}" AT 40
     _U._USER-LIST[3]    VIEW-AS TOGGLE-BOX LABEL "~{&&List-3}" AT 60
     _U._USER-LIST[4]    VIEW-AS TOGGLE-BOX LABEL "~{&&List-4}" AT 20
     _U._USER-LIST[5]    VIEW-AS TOGGLE-BOX LABEL "~{&&List-5}" AT 40
     _U._USER-LIST[6]    VIEW-AS TOGGLE-BOX LABEL "~{&&List-6}" AT 60
                      SKIP ({&VM_WIDG})
     geom-rect VIEW-AS TEXT SIZE 80 BY .77 AT 2 BGCOLOR 1 FGCOLOR 15 NO-LABEL
               FORMAT "X(40)"  SKIP ({&VM_WID})
     _X VIEW-AS FILL-IN SIZE 8 BY 1 COLON 11 {&STDPH_FILL}
     _WIDTH-P VIEW-AS FILL-IN SIZE 8 BY 1 COLON 39 {&STDPH_FILL} SKIP ({&VM_WID})
     _Y VIEW-AS FILL-IN SIZE 8 BY 1 COLON 11 {&STDPH_FILL}
     _HEIGHT-P VIEW-AS FILL-IN SIZE 8 BY 1 COLON 39 {&STDPH_FILL} SKIP ({&VM_WIDG})
     " Advanced Settings":L35 VIEW-AS TEXT SIZE 80 BY .77 AT 2 BGCOLOR 1 FGCOLOR 15 
                         SKIP (2.25)
     " Multiple Layouts":L35 VIEW-AS TEXT SIZE 80 BY .77 AT 2 BGCOLOR 1 FGCOLOR 15 
                         SKIP ({&VM_WID})
     _U._LAYOUT-NAME LABEL "Current Layout" VIEW-AS FILL-IN SIZE 31 BY 1
                         FORMAT "X(35)" COLON 16
     btn_layout AT 51
     WITH 
     &if DEFINED(IDE-IS-RUNNING) = 0  &then
          VIEW-AS DIALOG-BOX
          TITLE dialogTitle
     &else
          NO-BOX 
     &endif
         KEEP-TAB-ORDER
         SIDE-LABELS THREE-D
         SIZE 82.01 BY 16.94.

ASSIGN FRAME adv-dial:HIDDEN = TRUE
       fld-grp               = FRAME adv-dial:FIRST-CHILD
       lbl_pixels            = lbl_wdth * SESSION:PIXELS-PER-COLUMN
       lbl-dummy:WIDTH-P     = 1
       h_lbl_lbl             = lbl-dummy:SIDE-LABEL-HANDLE
       lbl-dummy2:HEIGHT     = 1
       lbl-dummy2:X          = h_lbl_lbl:X.

FIND _P WHERE _P._WINDOW-HANDLE EQ _h_win.
FIND _U WHERE RECID(_U) = u-recid.
FIND _L WHERE RECID(_L) = _U._lo-recid.
FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
IF NOT AVAILABLE _F THEN FIND _C WHERE RECID(_C) = _U._x-recid.
FIND parent_U WHERE RECID(parent_U) = _U._parent-recid NO-ERROR.
IF AVAILABLE parent_U THEN DO:
  FIND parent_C WHERE RECID(parent_C) = parent_U._x-recid.
  FIND parent_L WHERE RECID(parent_L) = parent_U._lo-recid.
  IF parent_U._TYPE = "FRAME" AND parent_C._FRAME-BAR:Y > 2 THEN
    col-lbl-adj = parent_C._FRAME-BAR:Y - 1.
END.

ASSIGN dialogTitle = dialogTitle + " for " + _U._TYPE + " " +
                             _U._NAME + IF _U._LAYOUT-NAME NE "Master Layout" THEN
                              " - Layout: " + _U._LAYOUT-NAME ELSE ""
       _HEIGHT-P:SENSITIVE = (_U._TYPE NE "COMBO-BOX" OR (_U._TYPE = "COMBO-BOX" AND _U._SUBTYPE = "SIMPLE"))
       _U._PRIVATE-DATA:RETURN-INSERTED IN FRAME adv-dial = TRUE.


{adeuib/ide/dialoginit.i "FRAME adv-dial:handle"}

&if DEFINED(IDE-IS-RUNNING) = 0  &then
FRAME adv-dial:TITLE = dialogTitle.
&endif

IF _U._TYPE = "FRAME":U THEN DO:
  ASSIGN frame_name:CHECKED = (_P._frame-name-recid = RECID(_U)).
END.
ELSE frame_name:VISIBLE = FALSE.

/* Change the label of the Custom Lists. */
{adeuib/usrlistl.i _U adv-dial}

RUN set_pixels_from_ppus.

/* Add in non-standard advanced attributes at run-time */ 
IF _U._TYPE eq "TEXT":U THEN DO:
  ASSIGN lbl-dummy2:ROW IN FRAME adv-dial           = _U._PRIVATE-DATA:ROW IN FRAME adv-dial
         _U._PRIVATE-DATA:VISIBLE IN FRAME adv-dial = FALSE
         _U._LAYOUT-UNIT:ROW IN FRAME adv-dial      = lbl-dummy2:ROW IN FRAME adv-dial
         lbl-dummy:VISIBLE IN FRAME adv-dial        = FALSE
         _U._USER-LIST[1]:VISIBLE IN FRAME adv-dial = FALSE
         _U._USER-LIST[2]:VISIBLE IN FRAME adv-dial = FALSE
         _U._USER-LIST[3]:VISIBLE IN FRAME adv-dial = FALSE
         _U._USER-LIST[4]:VISIBLE IN FRAME adv-dial = FALSE
         _U._USER-LIST[5]:VISIBLE IN FRAME adv-dial = FALSE
         _U._USER-LIST[6]:VISIBLE IN FRAME adv-dial = FALSE
         btn_layout:VISIBLE IN FRAME adv-dial       = FALSE
         mv-dist = geom-rect:ROW IN FRAME adv-dial - lbl-dummy2:ROW IN FRAME adv-dial 
                   - 1.5 
         wh = FRAME adv-dial:FIRST-CHILD    /* Field Group Handle       */
         wh = wh:FIRST-CHILD.               /* First field level widget */

  DO WHILE wh NE ?:
    IF wh:ROW > lbl-dummy:ROW IN FRAME adv-dial THEN wh:ROW = wh:ROW - mv-dist.
    wh = wh:NEXT-SIBLING.
  END.
END.  /* Make adjustments for TEXT widgets */

/* INITIAL VALUE */
FIND _PROP WHERE _PROP._NAME = "INITIAL-VALUE".
IF CAN-DO(_PROP._WIDGETS,_U._TYPE) THEN DO:
  /* First shrink private-data editor */
  ASSIGN _U._PRIVATE-DATA:ROW IN FRAME adv-dial =
                             _U._PRIVATE-DATA:ROW IN FRAME adv-dial + 1.1
         _U._PRIVATE-DATA:HEIGHT IN FRAME adv-dial =
                             _U._PRIVATE-DATA:HEIGHT IN FRAME adv-dial - 1.1
         tmp-handle = _U._PRIVATE-DATA:SIDE-LABEL-HANDLE IN FRAME adv-dial
         tmp-handle:ROW = tmp-handle:ROW + 1.1.
                             
  CREATE TEXT h_id_lbl ASSIGN FRAME = FRAME adv-dial:HANDLE FORMAT = "X(15)".
  CREATE FILL-IN init-data
       ASSIGN FRAME             = FRAME adv-dial:HANDLE
              ROW               = 1.13
              COLUMN            = _U._PRIVATE-DATA:COLUMN IN FRAME adv-dial
              WIDTH             = _U._PRIVATE-DATA:WIDTH IN FRAME adv-dial
              DATA-TYPE         = IF _F._DATA-TYPE = "LongChar" THEN "CHARACTER":U ELSE _F._DATA-TYPE
              /* Set the format of the field based on what the data-type.  */
              FORMAT            = IF _F._DATA-TYPE EQ "INTEGER":U THEN "->,>>>,>>>,>>9":U ELSE
                                  IF _F._DATA-TYPE EQ "INT64":U   THEN "->,>>>,>>>,>>>,>>>,>>>,>>9":U ELSE
                                  IF _F._DATA-TYPE BEGINS "DE":U  THEN _F._FORMAT ELSE
                                  IF _F._DATA-TYPE BEGINS "DATETIME":U THEN _F._FORMAT ELSE
                                  IF _F._DATA-TYPE BEGINS "DA":U THEN (
                                     IF INDEX(_orig_dte_fmt,"y":U) = 3 THEN "99/99/9999"
                                     ELSE IF INDEX(_orig_dte_fmt,"y":U) = 1 THEN "9999/99/99":U
                                     ELSE "99/9999/99":U) ELSE
                                  IF _F._DATA-TYPE BEGINS "C" OR _F._DATA-TYPE = "LongChar":U THEN "X(256)":U ELSE
                                  IF _F._DATA-TYPE BEGINS "L" THEN "yes/no":U
                                  ELSE "999999"
              BGCOLOR           = std_fillin_bgcolor
              FGCOLOR           = std_fillin_fgcolor
              SIDE-LABEL-HANDLE = h_id_lbl
              SCREEN-VALUE      = IF _F._DATA-TYPE eq "LOGICAL":U AND
                                    CAN-DO("FILL-IN,COMBO-BOX":U,_U._TYPE)
                                  THEN
                                    STRING(CAN-DO("TRUE,YES,":U +
                                            ENTRY(1,_F._FORMAT,"/":U),_F._INITIAL-DATA),
                                                                       "yes/no":U)
                                  ELSE IF _U._TYPE = "TOGGLE-BOX":U THEN
                                     (IF _F._INITIAL-DATA = "yes":U THEN "yes":U
                                                                    ELSE "no":U)
                                  ELSE IF _U._TYPE = "RADIO-SET":U AND
                                      _F._INITIAL-DATA = "" THEN ?                                      
                                  ELSE _F._INITIAL-DATA
              LABEL             = "Initial Value:"
       TRIGGERS:
          ON LEAVE DO:
            /* Special Case: Not modified, then don't check */
            IF SELF:MODIFIED THEN DO:
             
              /* Tell user that we "old" SHARED variables ignore their initial
                 values. */
              IF _U._SHARED AND _F._INITIAL-DATA NE SELF:SCREEN-VALUE AND
                 ((_F._DATA-TYPE = "CHARACTER" AND SELF:SCREEN-VALUE NE "") OR
                  (CAN-DO("INTEGER,DECIMAL,INT64",_F._DATA-TYPE)
                          AND DECIMAL(SELF:SCREEN-VALUE) NE 0) OR
                  (_F._DATA-TYPE = "LOGICAL"
                          AND NOT CAN-DO("NO,FALSE",SELF:SCREEN-VALUE)) OR 
                  (CAN-DO("DATE,RECID",_F._DATA-TYPE) AND SELF:SCREEN-VALUE NE "?"))
              THEN MESSAGE
                 "Shared variables will not retain initial values in the {&UIB_NAME}." 
                    VIEW-AS ALERT-BOX WARNING BUTTONS OK.
                    
              /* Parse the SCREEN-VALUE back into initial value based on type */
              CASE _F._DATA-TYPE:
                WHEN "INTEGER":U   THEN _F._INITIAL-DATA = 
                      TRIM(STRING(INTEGER(SELF:SCREEN-VALUE), "->>>>>>>>>9":U)).
                WHEN "INT64":U   THEN _F._INITIAL-DATA = 
                      TRIM(STRING(INT64(SELF:SCREEN-VALUE), "->>>>>>>>>>>>>>>>>>9":U)).
                WHEN "DECIMAL":U   THEN _F._INITIAL-DATA = 
                      TRIM(STRING(DECIMAL(SELF:SCREEN-VALUE), _F._FORMAT)).
                WHEN "DATE":U   THEN DO:
                      /* Special case: user hits ? - screen-value is blank" */
                      IF TRIM(REPLACE(SELF:SCREEN-VALUE,"/":U,"":U)) eq "":U THEN
                        ASSIGN _F._INITIAL-DATA = "?":U
                               SELF:SCREEN-VALUE = ?.
                      ELSE ASSIGN _F._INITIAL-DATA = SELF:SCREEN-VALUE.
                END. /* WHEN DATE ... */
                /* For logicals, Initial value is YES if the value is the first 
                   value in the format (eg. "male" in "male/female").  */
                WHEN "LOGICAL":U   THEN _F._INITIAL-DATA = 
                      IF CAN-DO("TOGGLE-BOX,RADIO-SET":U,_U._TYPE) THEN SELF:SCREEN-VALUE
                      ELSE STRING (STRING((IF SELF:SCREEN-VALUE = "yes" THEN TRUE ELSE FALSE), _F._FORMAT) eq ENTRY(1, _F._FORMAT, "/":U),
                                   _F._FORMAT).
                OTHERWISE _F._INITIAL-DATA = SELF:SCREEN-VALUE.
              END CASE.
              /* Check if _F._INITIAL-DATA fits _F._FORMAT mask */
              IF CAN-DO("FILL-IN,COMBO-BOX":U,_U._TYPE) THEN DO:
                CASE _F._DATA-TYPE:
                  WHEN "CHARACTER":U THEN DO:
                    CREATE FILL-IN ctemp
                    ASSIGN VISIBLE = NO
                           FORMAT = _F._FORMAT.
                    ASSIGN ctemp:SCREEN-VALUE = _F._INITIAL-DATA NO-ERROR.
                    IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
                      MESSAGE "The string '" + _F._INITIAL-DATA +
                              "' doesn't fit the format mask" SKIP
                              "'" + _F._FORMAT + "'." VIEW-AS ALERT-BOX ERROR.
                      RETURN NO-APPLY.
                    END.
                  END.
                  WHEN "DECIMAL":U THEN DO:
                    CREATE FILL-IN ctemp
                      ASSIGN VISIBLE   = NO
                             DATA-TYPE = "DECIMAL":U
                             FORMAT    = _F._FORMAT.
                    ASSIGN ctemp:SCREEN-VALUE = _F._INITIAL-DATA NO-ERROR.
                    IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
                      MESSAGE "The string '" + _F._INITIAL-DATA +
                              "' doesn't fit the format mask" SKIP
                              "'" + _F._FORMAT + "'." VIEW-AS ALERT-BOX ERROR.
                      RETURN NO-APPLY.
                    END.
                  END.
                  WHEN "INT64":U THEN DO:
                    CREATE FILL-IN ctemp
                      ASSIGN VISIBLE   = NO
                             DATA-TYPE = "INT64":U
                             FORMAT    = _F._FORMAT.
                    ASSIGN ctemp:SCREEN-VALUE = _F._INITIAL-DATA NO-ERROR.
                    IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
                      MESSAGE "The string '" + _F._INITIAL-DATA +
                              "' doesn't fit the format mask" SKIP
                              "'" + _F._FORMAT + "'." VIEW-AS ALERT-BOX ERROR.
                      RETURN NO-APPLY.
                    END.
                  END.
                  WHEN "INTEGER":U THEN DO:
                    CREATE FILL-IN ctemp
                      ASSIGN VISIBLE   = NO
                             DATA-TYPE = "INTEGER"
                             FORMAT    = _F._FORMAT.
                    ASSIGN ctemp:SCREEN-VALUE = _F._INITIAL-DATA NO-ERROR.
                    IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
                      MESSAGE "The string '" + _F._INITIAL-DATA +
                              "' doesn't fit the format mask" SKIP
                              "'" + _F._FORMAT + "'." VIEW-AS ALERT-BOX ERROR.
                      RETURN NO-APPLY.
                    END.
                  END. /* INTEGER */
                END CASE.  /* Data vs Format Check */
              END.  /* if a fill-in or combo-box */

              /* Give warning if the user entered an invalid option for 
                 combo-boxes, radio-sets or selection-lists */
              IF CAN-DO("COMBO-BOX,RADIO-SET,SELECTION-LIST":U, _U._TYPE)
              THEN DO:
                /* Compute the list of valid options, if it hasn't been done
                   yet */
                IF valid-items eq "" THEN RUN make-valid-items.
                IF _U._TYPE = "RADIO-SET":U AND _F._INITIAL-DATA = "?" THEN
                  _F._INITIAL-DATA = "".
                IF _F._INITIAL-DATA NE "" AND
                   LOOKUP(TRIM(_F._INITIAL-DATA), valid-items ,{&NL}) eq 0
                THEN MESSAGE 
                        "You have specified an initial value that does" {&SKP}
                        "not appear in your list of valid"
                        (IF _U._TYPE eq "COMBO-BOX":U THEN "combo-box items."
                         ELSE IF _U._TYPE eq "RADIO-SET":U THEN "radio-buttons."
                         ELSE "items.") SKIP(1)
                         "This situation can lead to a PROGRESS warning" {&SKP}
                         "when running your application."
                         VIEW-AS ALERT-BOX WARNING BUTTONS OK.
              END.
            END. /* IF SELF:MODIFIED ... */
          END. /* ON LEAVE OF... */
        END TRIGGERS.
  ASSIGN h_id_lbl:HEIGHT        = 1
         h_id_lbl:WIDTH         = FONT-TABLE:GET-TEXT-WIDTH-CHARS(init-data:LABEL + 
                                      " ")
         h_id_lbl:ROW           = init-data:ROW
         h_id_lbl:COLUMN        = init-data:COLUMN - h_id_lbl:WIDTH.
         /* Can't change init value in db field */
         IF _U._DBNAME NE ? OR _U._LAYOUT-NAME NE "MASTER LAYOUT" THEN  
            init-data:SENSITIVE = FALSE.
         ELSE 
            ASSIGN
               init-data:SENSITIVE    = TRUE
               fld-grp:FIRST-TAB-ITEM = init-data.

END.  /* Widget has an initial value */

/* HELP */
FIND _PROP WHERE _PROP._NAME = "HELP".
IF CAN-DO(_PROP._WIDGETS,_U._TYPE) THEN DO:
  /* First shrink private-data editor */
  ASSIGN _U._PRIVATE-DATA:ROW IN FRAME adv-dial =
                             _U._PRIVATE-DATA:ROW IN FRAME adv-dial + 1.1
         _U._PRIVATE-DATA:HEIGHT IN FRAME adv-dial =
                             _U._PRIVATE-DATA:HEIGHT IN FRAME adv-dial - 1.1
         tmp-handle = _U._PRIVATE-DATA:SIDE-LABEL-HANDLE IN FRAME adv-dial
         tmp-handle:ROW = tmp-handle:ROW + 1.1.
                             
  CREATE TEXT h_help_lbl ASSIGN FRAME = FRAME adv-dial:HANDLE. 
  CREATE FILL-IN help-string
       ASSIGN FRAME             = FRAME adv-dial:HANDLE
              ROW               = tmp-handle:ROW - 1.1
              COLUMN            = _U._PRIVATE-DATA:COLUMN IN FRAME adv-dial
              WIDTH             = _U._PRIVATE-DATA:WIDTH IN FRAME adv-dial
              FORMAT            = "X(63)"
              SIDE-LABEL-HANDLE = h_help_lbl
              BGCOLOR           = std_fillin_bgcolor
              FGCOLOR           = std_fillin_fgcolor
              SCREEN-VALUE      = (IF _U._HELP ne ? THEN _U._HELP ELSE "")
              LABEL             = "Help:"
         TRIGGERS:
            ON LEAVE DO:
              _U._HELP = SELF:SCREEN-VALUE.
            END.
          END TRIGGERS.
  ASSIGN h_help_lbl:HEIGHT     = 1
         h_help_lbl:WIDTH      = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                      help-string:LABEL + " ")
         h_help_lbl:ROW        = help-string:ROW
         h_help_lbl:COLUMN     = help-string:COLUMN - h_help_lbl:WIDTH
         help-string:SENSITIVE = IF _U._HELP-SOURCE = "D" OR _U._LAYOUT-NAME NE "Master Layout" THEN 
                                 FALSE ELSE TRUE.
         /* If init not there, or its a db inital value, help is 1st in tab order*/
         IF init-data NE ? AND _U._DBNAME EQ ? THEN   
            stupid = help-string:MOVE-AFTER(init-data).
         ELSE 
            fld-grp:FIRST-TAB-ITEM = help-string.

END.  /* Widget has a help string */

/* Virtual Dimensions */
FIND _PROP WHERE _PROP._NAME = "VIRTUAL-WIDTH".
IF CAN-DO(_PROP._WIDGETS,_U._TYPE) THEN DO:
  CREATE TEXT h_v-wdth_lbl ASSIGN FRAME = FRAME adv-dial:HANDLE FORMAT = "X(21)". 
  CREATE FILL-IN h_v-wdth
      ASSIGN FRAME             = FRAME adv-dial:HANDLE
             ROW               = _X:ROW IN FRAME adv-dial 
             COLUMN            = 73
             HEIGHT            = 1
             WIDTH             = 8
             DATA-TYPE         = "INTEGER"
             FORMAT            = ">,>>>,>>9"
             SIDE-LABEL-HANDLE = h_v-wdth_lbl
             BGCOLOR           = std_fillin_bgcolor
             FGCOLOR           = std_fillin_fgcolor
             SCREEN-VALUE      = STRING(_VIRTUAL-WIDTH-P,">,>>>,>>9")
             LABEL             = "Virtual Width Pixels:"
      TRIGGERS:
        ON LEAVE
        DO:     
          DEFINE VARIABLE new-width AS INTEGER   NO-UNDO.
          DEFINE VARIABLE err-msg   AS CHARACTER NO-UNDO INITIAL ?.
          DEFINE VARIABLE toosmall  AS LOGICAL   NO-UNDO INITIAL FALSE.
          
          new-width = INTEGER (SELF:SCREEN-VALUE).

          /* Check new width against the maximum allowed */
          IF new-width > 320 * SESSION:PIXELS-PER-COLUMN THEN
            ASSIGN       
              new-width = 320 * SESSION:PIXELS-PER-COLUMN
              err-msg   = "Largest possible virtual width is " + STRING(new-width) + " pixels.".
              
          /* Check against the requirements of the child widgets */
          RUN width-p_check (INPUT        _U._HANDLE, 
                             INPUT        _L._COL-MULT,
                             INPUT-OUTPUT new-width,
                             OUTPUT       toosmall).
          IF toosmall THEN
            err-msg = "Virtual width in pixels of a " + _U._TYPE + " may not be less than ~n" +
                      "its contents.  Minimum virtual width is " + STRING (new-width) + " pixels.".


          /* Update the record fields, and the PHYSICAL width if necessary */
          ASSIGN _VIRTUAL-WIDTH-P    = new-width   
                 SELF:SCREEN-VALUE   = STRING(new-width)
                 _L._VIRTUAL-WIDTH   = new-width /  SESSION:PIXELS-PER-COLUMN
                 _WIDTH-P            = IF _U._TYPE = "FRAME" AND NOT _C._SCROLLABLE THEN
                                       new-width ELSE
                                       MIN(_WIDTH-P,new-width).

          /* Refresh the physical width fill-in in case we changed it above */
          DISPLAY _WIDTH-P WITH FRAME adv-dial.                
          
          /* Display the error message if we defined one above */
          IF err-msg NE ? THEN DO:
            MESSAGE err-msg VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
            RETURN NO-APPLY.
          END.
           
        END. /* End trigger ON LEAVE */
      END TRIGGERS.                    
      
  ASSIGN h_v-wdth_lbl:HEIGHT  = 1
         h_v-wdth_lbl:WIDTH   = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                     h_v-wdth:LABEL + " ")
         h_v-wdth_lbl:ROW     = h_v-wdth:ROW
         h_v-wdth_lbl:COLUMN  = h_v-wdth:COLUMN - h_v-wdth_lbl:WIDTH
         h_v-wdth:SENSITIVE   = (_U._TYPE = "WINDOW" OR _C._SCROLLABLE).

  CREATE TEXT h_v-hgt_lbl ASSIGN FRAME = FRAME adv-dial:HANDLE FORMAT = "X(22)". 
  CREATE FILL-IN h_v-hgt
      ASSIGN FRAME             = FRAME adv-dial:HANDLE
             ROW               = h_v-wdth:ROW + 1.1
             COLUMN            = h_v-wdth:COLUMN
             HEIGHT            = 1
             WIDTH             = 8
             DATA-TYPE         = "INTEGER"
             FORMAT            = ">,>>>,>>9"
             SIDE-LABEL-HANDLE = h_v-hgt_lbl
             BGCOLOR           = std_fillin_bgcolor
             FGCOLOR           = std_fillin_fgcolor
             SCREEN-VALUE      = STRING(_VIRTUAL-HEIGHT-P,">,>>>,>>9")
             LABEL             = "Virtual Height Pixels:"
      TRIGGERS:
        ON LEAVE DO:
          DEFINE VARIABLE new-height AS INTEGER   NO-UNDO.
          DEFINE VARIABLE err-msg    AS CHARACTER NO-UNDO INITIAL ?.
          DEFINE VARIABLE toosmall   AS LOGICAL   NO-UNDO INITIAL FALSE.
          
          new-height = INTEGER (SELF:SCREEN-VALUE).

          /* Check progress' maximum limit- 320 chars */
          IF new-height > 320 * SESSION:PIXELS-PER-ROW THEN
            ASSIGN
              new-height = 320 * SESSION:PIXELS-PER-ROW
              err-msg    = "Largest possible virtual height is " + STRING (new-height) + " pixels.".
                        
          /* Check new height against the requirements of child widgets */
          RUN height-p_check (INPUT        _U._HANDLE, 
                              INPUT        _L._ROW-MULT,
                              INPUT-OUTPUT new-height,
                              OUTPUT       toosmall).
          IF toosmall THEN 
            err-msg = "Virtual height in pixels of a " + _U._TYPE + " may not be less than ~n" +
                      "its contents.  Minimum virtual height is " + STRING (new-height) + " pixels.".
  
          /* Assign new height to record fields, and update physical height if necessary */
          ASSIGN _VIRTUAL-HEIGHT-P      = new-height
                 SELF:SCREEN-VALUE      = STRING(new-height)
                 _L._VIRTUAL-HEIGHT     = new-height / SESSION:PIXELS-PER-ROW
                 _HEIGHT-P              = IF _U._TYPE = "FRAME" AND NOT _C._SCROLLABLE
                                          THEN new-height
                                          ELSE MIN(_HEIGHT-P,new-height).
          
          /* Display the new value in the fill-in */                                
          DISPLAY _HEIGHT-P WITH FRAME adv-dial.
          
          /* Display the error message if we defined one, and return NO-APPLY */
          IF err-msg NE ? THEN DO:
            MESSAGE err-msg VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
            RETURN NO-APPLY.
          END.
        END.
      END TRIGGERS.
  ASSIGN h_v-hgt_lbl:HEIGHT  = 1
         h_v-hgt_lbl:WIDTH   = FONT-TABLE:GET-TEXT-WIDTH-CHARS(h_v-hgt:LABEL + " ")
         h_v-hgt_lbl:ROW     = h_v-hgt:ROW
         h_v-hgt_lbl:COLUMN  = h_v-hgt:COLUMN - h_v-hgt_lbl:WIDTH
         h_v-hgt:SENSITIVE   = (_U._TYPE = "WINDOW" OR _C._SCROLLABLE).
END.  /* Widget has virtual dimensions */

/* ROW-HEIGHT-P */
FIND _PROP WHERE _PROP._NAME = "ROW-HEIGHT-P".
IF CAN-DO(_PROP._WIDGETS,_U._TYPE) THEN DO:
  CREATE TEXT h_row-hgt_lbl ASSIGN FRAME = FRAME adv-dial:HANDLE FORMAT = "X(18)". 
  CREATE FILL-IN h_row-hgt
      ASSIGN FRAME             = FRAME adv-dial:HANDLE
             ROW               = _X:ROW IN FRAME adv-dial + 2.2
             COLUMN            = _HEIGHT-P:COLUMN
             HEIGHT            = 1
             WIDTH             = 8
             DATA-TYPE         = "INTEGER"
             FORMAT            = ">,>>>,>>9"
             SIDE-LABEL-HANDLE = h_row-hgt_lbl
             BGCOLOR           = std_fillin_bgcolor
             FGCOLOR           = std_fillin_fgcolor
             SCREEN-VALUE      = STRING(_ROW-HEIGHT-P,">,>>>,>>9")
             LABEL             = "Row Height Pixels:"
      TRIGGERS:
        ON LEAVE DO:
          ASSIGN _ROW-HEIGHT-P = INTEGER(SELF:SCREEN-VALUE).
        END. /* End trigger ON LEAVE */
      END TRIGGERS.                    
      
  ASSIGN h_row-hgt_lbl:HEIGHT  = 1
         h_row-hgt_lbl:WIDTH   = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                     h_row-hgt:LABEL + " ")
         h_row-hgt_lbl:ROW     = h_row-hgt:ROW
         h_row-hgt_lbl:COLUMN  = h_row-hgt:COLUMN - h_row-hgt_lbl:WIDTH
         h_row-hgt:SENSITIVE   = _U._LAYOUT-NAME EQ "MASTER LAYOUT".
END.  /* Widget can be aligned */ 

/* ALIGN */
FIND _PROP WHERE _PROP._NAME = "ALIGN".
IF CAN-DO(_PROP._WIDGETS,_U._TYPE) THEN DO:
  DEFINE VAR radio-btns AS CHAR INITIAL "Left-Align,L,Right-Align,R".
  IF CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE) THEN
    radio-btns = "Left-Align,L,Colon-Align,C,Right-Align,R".
       
  CREATE RADIO-SET h_align
    ASSIGN FRAME         = FRAME adv-dial:HANDLE
           ROW           = _X:ROW IN FRAME adv-dial
           COLUMN        = 61
           WIDTH         = 16
           RADIO-BUTTONS = radio-btns
           HEIGHT        = IF SESSION:WINDOW-SYSTEM = "OSF/MOTIF" AND
                             CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE) THEN 3.5
                           ELSE 2.3
           SCREEN-VALUE  = _U._ALIGN
           SENSITIVE     = TRUE
         TRIGGERS:
           ON VALUE-CHANGED PERSISTENT RUN alignment_change.
         END TRIGGERS.                                    
         
  IF _U._LAYOUT-NAME NE "MASTER LAYOUT" THEN
    h_align:SENSITIVE = FALSE.
                              
  IF SESSION:WINDOW-SYSTEM = "OSF/MOTIF" THEN DO:
    ASSIGN FRAME adv-dial:HEIGHT = FRAME adv-dial:HEIGHT + 1.2
           tmp-handle            = FRAME adv-dial:HANDLE
           tmp-handle            = tmp-handle:FIRST-CHILD  /* field group */
           tmp-handle            = tmp-handle:FIRST-CHILD. /* field level widget */
    DO WHILE tmp-handle NE ?:
      IF tmp-handle:ROW > _Y:ROW IN FRAME adv-dial THEN
         tmp-handle:ROW = tmp-handle:ROW + 1.2.
      tmp-handle = tmp-handle:NEXT-SIBLING.
    END.
  END.
END.  /* Widget can be aligned */ 

/* Shrink the dialog */
ASSIGN tmp-handle            = FRAME adv-dial:HANDLE
       tmp-handle            = tmp-handle:FIRST-CHILD  /* field group */
       tmp-handle            = tmp-handle:FIRST-CHILD. /* field level widget */
DO WHILE tmp-handle NE ?:
  IF _U._TYPE = "FRAME":U THEN DO:
    IF tmp-handle = _U._PRIVATE-DATA:HANDLE IN FRAME adv-dial THEN
      tmp-handle:HEIGHT = tmp-handle:HEIGHT - 1.5.
    ELSE IF tmp-handle:ROW > 2.5 THEN
       tmp-handle:ROW = tmp-handle:ROW - (IF tmp-handle:ROW < (_X:ROW + 5) THEN 1.5 ELSE .7).
  END.
  ELSE DO:
    IF tmp-handle:TYPE = "LITERAL":U AND
       tmp-HANDLE:SCREEN-VALUE = " Advanced Settings" THEN DO:
      IF CAN-DO("TEXT,{&WT-CONTROL}":U,_U._TYPE) THEN
        tmp-handle:VISIBLE = FALSE.
      ELSE IF _U._TYPE = "BROWSE":U THEN tmp-handle:ROW = tmp-handle:ROW + 1.1.
    END.
    ELSE IF tmp-handle:ROW > _X:ROW + 3 THEN DO:
      tmp-handle:ROW = tmp-handle:ROW -
            IF CAN-DO("TEXT,{&WT-CONTROL}":U,_U._TYPE) THEN 3
            ELSE IF _U._TYPE = "BROWSE":U THEN (-1.1) ELSE .75.
    END.
  END.
  tmp-handle = tmp-handle:NEXT-SIBLING.
END.
FRAME adv-dial:HEIGHT = FRAME adv-dial:HEIGHT -
            IF CAN-DO("TEXT":U,_U._TYPE) THEN 3
            ELSE IF _U._TYPE = "FRAME":U THEN .8 
            ELSE IF CAN-DO("BROWSE,WINDOW":U,_U._TYPE) THEN  (-1.1) ELSE .75.

IF _U._TYPE = "FRAME":U THEN 
  /* Move frame name toggle to new location with other toggles */
  ASSIGN frame_name:ROW IN FRAME adv-dial    = _X:ROW + 3.5
         frame_name:COLUMN IN FRAME adv-dial = tog-col-1
         frame_name:WIDTH IN FRAME adv-dial  = frame_name:WIDTH + 1.5
         togcnt                              = 1. 

/* Now put advanced toggles in */
TOGGLE-COUNT:
FOR EACH _PROP WHERE CAN-DO(_PROP._WIDGETS,_U._TYPE) AND
                     _PROP._CLASS = 9 BY _PROP._NAME:
  togcnt = togcnt + 1.
END.

ASSIGN cur-row   = _X:ROW + IF _U._TYPE = "BROWSE":U THEN 4.6 ELSE 3.5
       tog-rows  = TRUNCATE((togcnt + 3) / 4,0)
       togcnt    = IF _U._TYPE = "FRAME":U THEN 1 ELSE 0.
       
&IF "{&WINDOW-SYSTEM}" <> "OSF/MOTIF" &THEN
  tog-spc = (IF SESSION:PIXELS-PER-ROW < 25 OR SESSION:HEIGHT-PIXELS > 480
             THEN .88 ELSE .78).
            /* A good formula which almost works and probably could
               with some fine tuning is:
               tog-spc = DECIMAL(FONT-TABLE:GET-TEXT-HEIGHT-PIXELS() + 4) / 
                            DECIMAL(SESSION:PIXELS-PER-ROW). */
&ENDIF
  
TOGGLE-PLACEMENT:
FOR EACH _PROP WHERE CAN-DO(_PROP._WIDGETS,_U._TYPE) AND
               _PROP._CLASS = 9 BY _PROP._NAME:
  togcnt = togcnt + 1.
  /* Fudge for frames to use all 4 columns */
  IF _U._TYPE = "FRAME":U THEN togcnt = (IF togcnt = 6 THEN 7 ELSE
                                        (IF togcnt = 9 THEN 10 ELSE
                                        togcnt)).
  CASE _PROP._NAME:
    {adeuib/atog-dis.i}
  END.
END.
  
/* Desensitize inappropriate toggles for TTY mode                               */
IF NOT _L._WIN-TYPE THEN DO:
  IF h_COLUMN-SEARCHING    NE ? THEN h_COLUMN-SEARCHING:SENSITIVE          = FALSE.
  IF h_box-selectable      NE ? THEN h_box-selectable:SENSITIVE            = FALSE.
  IF h_COLUMN-MOVABLE      NE ? THEN h_COLUMN-MOVABLE:SENSITIVE            = FALSE.
  IF h_COLUMN-RESIZABLE    NE ? THEN h_COLUMN-RESIZABLE:SENSITIVE          = FALSE.
  IF h_row-hgt             NE ? THEN h_row-hgt:SENSITIVE                   = FALSE.
END.
 


/* ***************  Runtime Attributes and UIB Settings  ************** */

/* SETTINGS FOR DIALOG-BOX adv-dial
   VISIBLE,L                                                            */

/* SETTINGS FOR DIALOG-BOX adv-dial
   UNDERLINE                                                            */
ASSIGN 
       FRAME adv-dial:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN cur-layout IN FRAME adv-dial
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */

/* ************************  Control Triggers  ************************ */




/* ***************************  Main Block  *************************** */

/* Restore the current-window if it is an icon.                         */
/* Otherwise the dialog box will be hidden                              */
IF CURRENT-WINDOW:WINDOW-STATE = WINDOW-MINIMIZED 
THEN CURRENT-WINDOW:WINDOW-STATE = WINDOW-NORMAL.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

{adecomm/okbar.i}

ASSIGN FRAME adv-dial:DEFAULT-BUTTON = btn_OK:HANDLE IN FRAME adv-dial.

ON CHOOSE OF btn_help IN FRAME adv-dial OR HELP OF FRAME adv-dial DO:
  DEFINE VARIABLE help-context AS INTEGER NO-UNDO.
  CASE _U._TYPE:
    WHEN "BROWSE"         THEN help-context = {&Adv_Props_BROWSE}.
    WHEN "BUTTON"         THEN help-context = {&Adv_Props_BUTTON}.
    WHEN "COMBO-BOX"      THEN help-context = {&Adv_Props_COMBOBOX}.
    WHEN "DIALOG-BOX"     THEN help-context = {&Adv_Props_DIALOGBOX}.
    WHEN "EDITOR"         THEN help-context = {&Adv_Props_EDITOR}.
    WHEN "FILL-IN"        THEN help-context = {&Adv_Props_FILLIN}.
    WHEN "FRAME"          THEN help-context = {&Adv_Props_FRAME}.
    WHEN "IMAGE"          THEN help-context = {&Adv_Props_IMAGE}.
    WHEN "RADIO-SET"      THEN help-context = {&Adv_Props_RADIOSET}.
    WHEN "RECTANGLE"      THEN help-context = {&Adv_Props_RECTANGLE}.
    WHEN "SELECTION-LIST" THEN help-context = {&Adv_Props_SELECTIONLIST}.
    WHEN "SLIDER"         THEN help-context = {&Adv_Props_SLIDER}.
    WHEN "TEXT"           THEN help-context = {&Adv_Props_TEXT}.
    WHEN "TOGGLE-BOX"     THEN help-context = {&Adv_Props_TOGGLEBOX}.
    WHEN "WINDOW"         THEN help-context = {&Adv_Props_WINDOW}.
    WHEN "OCX"            THEN help-context = {&Adv_Props_VBX}.
  END CASE.
  RUN adecomm/_adehelp.p ( "ab", "CONTEXT", help-context, ? ).
END.

ON VALUE-CHANGED OF frame_name IN FRAME adv-dial DO:
  IF SELF:CHECKED THEN _P._frame-name-recid = RECID(_U).
                  ELSE _P._frame-name-recid = ?.
END.

ON CHOOSE OF btn_layout IN FRAME adv-dial DO:
  run chooseLayout.
  
END.

ON LEAVE OF _HEIGHT-P IN FRAME adv-dial DO:  /* Validate specified height */
  DEFINE VARIABLE new-height AS INTEGER.           
  DEFINE VARIABLE err-msg    AS CHARACTER INITIAL ?.
  DEFINE VARIABLE toosmall   AS LOGICAL   INITIAL FALSE.
  
  new-height = INTEGER(SELF:SCREEN-VALUE). 
  
  /* Check absolute minimum */
  IF new-height <= 0 THEN 
    ASSIGN
      new-height = 1
      err-msg    = "Height in pixels of a " + _U._TYPE + " must be greater than 0.".
                                 
  /* Find upper limit */
  IF CAN-DO ("WINDOW,DIALOG-BOX", _U._TYPE) THEN 
    upr-limit = 320 * SESSION:PIXELS-PER-ROW.
  ELSE    
    upr-limit = v-hgt * SESSION:PIXELS-PER-ROW - (IF INTEGER(_Y:SCREEN-VALUE) NE ? THEN
                                                  INTEGER (_Y:SCREEN-VALUE)
                                                  ELSE
                                                  1).
  IF new-height > upr-limit THEN
    ASSIGN
      new-height = upr-limit
      err-msg    = "Height in pixels must be less than or equal to " + STRING(upr-limit) + ".".

  /* Check child widget requirements for non-scrollable frames AND dialog-boxes.
   * Note that we don't check windows, as the virtual-height is constrained by contained
   * widgets, not the phsyical height. */
  IF (_U._TYPE = "FRAME" AND NOT _C._SCROLLABLE) OR _U._TYPE = "DIALOG-BOX" THEN DO:
      RUN height-p_check (INPUT        _U._HANDLE, 
                          INPUT        _L._ROW-MULT,
                          INPUT-OUTPUT new-height,
                          OUTPUT       toosmall).
      IF toosmall THEN
        err-msg = "Height in pixels of a " + _U._TYPE + " may not be less than~n" +
                  "its contents.  Minimum height is " + STRING(new-height) + " pixels.".
  END.  

  /* Update the virtual dimension if necessary */
  IF (_U._TYPE EQ "FRAME"  AND NOT _C._SCROLLABLE) OR
     (_U._TYPE EQ "FRAME"  AND _C._SCROLLABLE AND new-height > _VIRTUAL-HEIGHT-P) OR 
     (_U._TYPE EQ "WINDOW" AND new-height > _VIRTUAL-HEIGHT-P) THEN 
    ASSIGN
      _VIRTUAL-HEIGHT-P    = new-height           
      h_v-hgt:SCREEN-VALUE = STRING(new-height).

  /* Update the fill-in */
  ASSIGN
    _HEIGHT-P         = new-height
    SELF:SCREEN-VALUE = STRING(new-height).
                           
  IF err-msg NE ? THEN DO:
    MESSAGE err-msg VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN NO-APPLY.
  END.
 
END. /* TRIGGER */

ON LEAVE OF _WIDTH-P IN FRAME adv-dial DO:  /* Validate specified width */
  DEFINE VARIABLE new-width  AS INTEGER.
  DEFINE VARIABLE err-msg    AS CHARACTER INITIAL ?.
  DEFINE VARIABLE toosmall   AS LOGICAL   INITIAL FALSE.
  
  new-width = INTEGER(SELF:SCREEN-VALUE).

  /* Check minima */
  IF new-width <= 0 THEN 
    ASSIGN
      new-width = 1
      err-msg   = "Width in pixels of a " + _U._TYPE + " must be greater than 0.".

  /* Find upper limit */
  IF NOT CAN-DO("WINDOW,DIALOG-BOX,FRAME",_U._TYPE) THEN DO:
    CASE _U._ALIGN:
      WHEN "R" THEN upr-limit = ((v-wdth - 1) * SESSION:PIXELS-PER-COLUMN) -
                                  parent_U._HANDLE:BORDER-LEFT-PIXELS -
                                  parent_U._HANDLE:BORDER-RIGHT-PIXELS -
                                  INTEGER(_X:SCREEN-VALUE) +
                                 _L._WIDTH * SESSION:PIXELS-PER-COLUMN.
      WHEN "C" THEN upr-limit = ((v-wdth - 2) * SESSION:PIXELS-PER-COLUMN) -
                                  parent_U._HANDLE:BORDER-LEFT-PIXELS -
                                  parent_U._HANDLE:BORDER-RIGHT-PIXELS - 
                                  INTEGER(_X:SCREEN-VALUE).
      OTHERWISE upr-limit     = ((v-wdth * SESSION:PIXELS-PER-COLUMN) -
                                  parent_U._HANDLE:BORDER-LEFT-PIXELS -
                                  parent_U._HANDLE:BORDER-RIGHT-PIXELS) - 
                                  INTEGER(_X:SCREEN-VALUE) - lbl_pixels.
    END CASE.
  END.
  ELSE /* widget is a window, dialog-box, or frame */
    upr-limit = (IF _U._TYPE = "FRAME" THEN v-wdth * SESSION:PIXELS-PER-COLUMN
                                       ELSE SESSION:WIDTH-PIXELS) -
                                (IF INTEGER(_X:SCREEN-VALUE) NE ?
                                 THEN INTEGER(_X:SCREEN-VALUE)
                                 ELSE 1).
  
  /* Test the new-width against the upper limit */       
  IF new-width > upr-limit THEN
    ASSIGN
      new-width = upr-limit
      err-msg   = "Width must be less than or equal to " + STRING (upr-limit) + ".".

  /* Check against requirements of contained widgets */  
  IF (_U._TYPE = "FRAME" AND NOT _C._SCROLLABLE) OR 
     _U._TYPE = "DIALOG-BOX" THEN DO:
      RUN width-p_check (INPUT        _U._HANDLE, 
                         INPUT        _L._COL-MULT,
                         INPUT-OUTPUT new-width,
                         OUTPUT       toosmall).
                                     
      IF toosmall THEN
        err-msg = "Width in pixels of a " + _U._TYPE + " may not be less than~n" +
                  "its contents.  Minimum width is " + STRING(new-width) + " pixels.".
  END.

  /* Update the virtual component, if necessary */
  IF (_U._TYPE EQ "FRAME"  AND NOT _C._SCROLLABLE) OR  
     (_U._TYPE EQ "FRAME"  AND _C._SCROLLABLE AND new-width > _VIRTUAL-WIDTH-P) OR 
     (_U._TYPE EQ "WINDOW" AND new-width > _VIRTUAL-WIDTH-P) THEN
    ASSIGN
      _VIRTUAL-WIDTH-P      = new-width
      h_v-wdth:SCREEN-VALUE = STRING(new-width).

  /* Update the fill-in */
  ASSIGN
    _WIDTH-P          = new-width
    SELF:SCREEN-VALUE = STRING (new-width).
                                                       
  IF err-msg NE ? THEN DO:
    MESSAGE err-msg VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN NO-APPLY.
  END.

END. /* TRIGGER */

ON LEAVE OF _X IN FRAME adv-dial DO:  /* Validate specified column */
  ASSIGN _X.
  
  IF NOT CAN-DO("WINDOW,DIALOG-BOX,FRAME",_U._TYPE) THEN DO:
    CASE _U._ALIGN:
      WHEN "R" THEN 
        ASSIGN low-limit = INTEGER(_WIDTH-P:SCREEN-VALUE) + lbl_pixels -
                           SESSION:PIXELS-PER-COLUMN
               upr-limit = ((v-wdth - 1) * SESSION:PIXELS-PER-COLUMN) -
                             parent_U._HANDLE:BORDER-LEFT-PIXELS -
                             parent_U._HANDLE:BORDER-RIGHT-PIXELS.
      WHEN "C" THEN
        ASSIGN low-limit = lbl_pixels - 2 * SESSION:PIXELS-PER-COLUMN
               upr-limit = ((v-wdth - 2) * SESSION:PIXELS-PER-COLUMN) -
                             parent_U._HANDLE:BORDER-LEFT-PIXELS -
                             parent_U._HANDLE:BORDER-RIGHT-PIXELS - 
                             INTEGER(_WIDTH-P:SCREEN-VALUE).
      OTHERWISE
        ASSIGN low-limit = 0
               upr-limit = (((v-wdth * SESSION:PIXELS-PER-COLUMN) -
                              parent_U._HANDLE:BORDER-LEFT-PIXELS -
                              parent_U._HANDLE:BORDER-RIGHT-PIXELS) - 
                              INTEGER(_WIDTH-P:SCREEN-VALUE) - lbl_pixels).
    END CASE.
  END.
  ELSE ASSIGN low-limit = IF _U._TYPE = "DIALOG-BOX" THEN
                           10 - INTEGER(_WIDTH-P:SCREEN-VALUE) ELSE 0
              upr-limit = IF _U._TYPE  = "FRAME"
                          THEN ((v-wdth * SESSION:PIXELS-PER-COLUMN) -
                                  INTEGER(_WIDTH-P:SCREEN-VALUE))
                          ELSE (SESSION:WIDTH-PIXELS - INTEGER(_WIDTH-P:SCREEN-VALUE)).
                         
  IF _X < low-limit THEN DO:
    MESSAGE "X coordinate must be greater than or equal to" STRING(low-limit) + "."
             VIEW-AS ALERT-BOX.
    SELF:SCREEN-VALUE = STRING(low-limit).
    RETURN NO-APPLY.
  END.
  IF _X > upr-limit THEN DO:
    MESSAGE "X coordinate must be less than or equal to" STRING(upr-limit) + "."
             VIEW-AS ALERT-BOX.
    SELF:SCREEN-VALUE = STRING(upr-limit).
    RETURN NO-APPLY.                                    
  END.
   
  ASSIGN _X.
END. /* TRIGGER */


ON LEAVE OF _Y IN FRAME adv-dial DO:  /* Validate specified row */
  ASSIGN _Y.
  low-limit = IF _U._TYPE = "DIALOG-BOX" THEN
                10 - INTEGER(_HEIGHT-P:SCREEN-VALUE) ELSE 0.
  IF _Y < low-limit THEN DO:
    MESSAGE "Y coordinate must be greater than or equal to" STRING(low-limit) + "."
            VIEW-AS ALERT-BOX.
    SELF:SCREEN-VALUE = STRING(low-limit).
    RETURN NO-APPLY.
  END.
  upr-limit = IF CAN-DO("WINDOW,DIALOG-BOX",_U._TYPE) THEN
                (SESSION:HEIGHT-PIXELS - INTEGER(_HEIGHT-P:SCREEN-VALUE))
              ELSE IF _U._TYPE = "FRAME" THEN
                ((v-hgt * SESSION:PIXELS-PER-ROW) - INTEGER(_HEIGHT-P:SCREEN-VALUE))
              ELSE
                (((v-hgt * SESSION:PIXELS-PER-ROW) -
                   parent_U._HANDLE:BORDER-TOP-PIXELS -
                   parent_U._HANDLE:BORDER-BOTTOM-PIXELS -
                   INTEGER(_HEIGHT-P:SCREEN-VALUE)) /
                   IF parent_C._SIDE-LABEL THEN 1 ELSE 2).
  IF _Y > upr-limit THEN DO:
    MESSAGE "Y coordinate must be less than or equal to" STRING(upr-limit) + "."
            VIEW-AS ALERT-BOX.
    SELF:SCREEN-VALUE = STRING(upr-limit).
    RETURN NO-APPLY.
  END.
  ASSIGN _Y.
END. /* TRIGGER */
  
 &scoped-define CANCEL-EVENT U2
{adeuib/ide/dialogstart.i btn_ok btn_cancel dialogTitle}
  
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will slways fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  
  VIEW FRAME {&FRAME-NAME}.            
  
  IF VALID-HANDLE(help-string) THEN DO:
    IF _U._HELP-SOURCE = "D":U THEN
      ASSIGN help-string:SCREEN-VALUE = "?"
             help-string:VISIBLE      = YES.
    ELSE help-string:SCREEN-VALUE = _U._HELP.
  END.
&if DEFINED(IDE-IS-RUNNING) = 0  &then
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
&ELSE
  WAIT-FOR GO OF FRAME {&FRAME-NAME} or "{&CANCEL-EVENT}" of this-procedure.       
  
  if cancelDialog THEN UNDO, LEAVE.  
&endif
  /* Remove trailing whitespace on the PRIVATE-DATA. (Users often hit an
     extra <cr> at the end of this field.  Also, stripping trailing blanks
     is consistent with Progress Fill-In field behavior.) */
  IF _U._PRIVATE-DATA:MODIFIED IN FRAME adv-dial 
  THEN _U._PRIVATE-DATA = RIGHT-TRIM(_U._PRIVATE-DATA:SCREEN-VALUE 
                                     IN FRAME adv-dial).

  IF _L._LO-NAME = "Master Layout" THEN DO:
    /* Before changing _L._ROW, _L._COL or _L._HEIGHT save the existing values so
       that we can find other layouts with the same values so we can change them
       too.                                                                        */
    ASSIGN sav_row      = _L._ROW
           sav_col      = _L._COL
           sav_width    = _L._WIDTH
           sav_height   = _L._HEIGHT
           sav_v-height = _L._VIRTUAL-HEIGHT
           sav_v-width  = _L._VIRTUAL-WIDTH.
  END.
    
  /* Assign other fields */
  ASSIGN _U._LAYOUT-UNIT _U._USER-LIST[1] _U._USER-LIST[2]
         _U._USER-LIST[3] _U._USER-LIST[4] _U._USER-LIST[5]
         _U._USER-LIST[6] _X _Y _WIDTH-P _HEIGHT-P
         _L._ROW    = IF _cur_win_type THEN
                        DECIMAL(((_Y + col-lbl-adj) / SESSION:PIXELS-PER-ROW /
                                  _L._ROW-MULT) + 1)
                      ELSE DECIMAL(_Y + 1 + col-lbl-adj)
         _L._WIDTH  = IF _cur_win_type THEN
                        DECIMAL(_WIDTH-P / SESSION:PIXELS-PER-COLUMN / _L._COL-MULT)
                      ELSE DECIMAL(_WIDTH-P)
         _L._HEIGHT = IF _cur_win_type THEN
                        DECIMAL(_HEIGHT-P / SESSION:PIXELS-PER-ROW / _L._ROW-MULT)
                      ELSE DECIMAL(_HEIGHT-P).

  IF h_row-hgt NE ? THEN
    ASSIGN _C._ROW-HEIGHT = IF _cur_win_type THEN 
                              _ROW-HEIGHT-P / SESSION:PIXELS-PER-ROW / _L._ROW-MULT
                            ELSE _ROW-HEIGHT-P.
 
  IF h_v-wdth NE ? THEN 
    ASSIGN _L._VIRTUAL-WIDTH  = IF _cur_win_type THEN
                                  _VIRTUAL-WIDTH-P / SESSION:PIXELS-PER-COLUMN /
                                                    _L._COL-MULT
                                ELSE _VIRTUAL-WIDTH-P
           _L._VIRTUAL-HEIGHT = IF _cur_win_type THEN
                                  _VIRTUAL-HEIGHT-P / SESSION:PIXELS-PER-ROW /
                                                   _L._ROW-MULT
                                ELSE _VIRTUAL-HEIGHT-P.
                                
  /* Set _L._COL based on alignment and window type */
  CASE _U._ALIGN:
    WHEN "R" THEN _L._COL = IF _cur_win_type THEN 
                        DECIMAL((_X / SESSION:PIXELS-PER-COLUMN / _L._COL-MULT) + 1) +
                              1 - _L._WIDTH 
                        ELSE DECIMAL(_X + 2 - _L._WIDTH).
    WHEN "C" THEN _L._COL = IF _cur_win_type THEN
                        DECIMAL((_X / SESSION:PIXELS-PER-COLUMN / _L._COL-MULT) + 1) + 2
                        ELSE DECIMAL(_X + 3).
    OTHERWISE
      _L._COL = IF CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE) AND parent_C._SIDE-LABELS THEN
                   /* SIDE-LABELS */
                  (IF _cur_win_type THEN
                        (DECIMAL((_X / SESSION:PIXELS-PER-COLUMN / _L._COL-MULT) + 1) +
                                lbl_wdth)
                   ELSE DECIMAL(_X + 1 + lbl_wdth))
                ELSE IF parent_U._TYPE = "FRAME" AND NOT parent_C._SIDE-LABELS AND
                     NOT parent_L._NO-LABELS THEN
                   /* COLUMN LABELS */
                  (IF _cur_win_type THEN 
                        (DECIMAL((_X / SESSION:PIXELS-PER-COLUMN / _L._COL-MULT) + 1) +
                                  MAX(0, lbl_wdth - _L._WIDTH))
                    ELSE DECIMAL(_X + 1 + MAX(0, lbl_wdth - _L._WIDTH)))
                ELSE (IF _cur_win_type THEN
                        DECIMAL((_X / SESSION:PIXELS-PER-COLUMN / _L._COL-MULT) + 1)
                      ELSE DECIMAL(_X + 1)).  
  END. /* CASE */
  IF _L._LO-NAME = "Master Layout" THEN DO:  /* Update other layouts */
    FOR EACH sync_L WHERE sync_L._u-recid = _L._u-recid AND
                          sync_L._LO-NAME NE _L._LO-NAME:
      IF NOT sync_L._CUSTOM-POSITION THEN
        ASSIGN sync_L._ROW = _L._ROW
               sync_L._COL = _L._COL.
               
      IF NOT sync_L._CUSTOM-SIZE THEN
        ASSIGN  sync_L._WIDTH          = _L._WIDTH
                sync_L._HEIGHT         = _L._HEIGHT
                sync_L._VIRTUAL-HEIGHT = _L._VIRTUAL-HEIGHT
                sync_L._VIRTUAL-WIDTH  = _L._VIRTUAL-WIDTH.
    END.
  END.  /* IF changing the master layout */     
END.  /* MAIN-BLOCK */

RUN disable_UI.


/* **********************  Internal Procedures  *********************** */

procedure chooseLayout: 
   &if DEFINED(IDE-IS-RUNNING) <> 0  &then
      dialogService:SetCurrentEvent(this-procedure,"doChooseLayout").
      run runChildDialog in hOEIDEService (dialogService) .
   &else      
      run doChooseLayout.
   &endif 
end procedure.

procedure doChooseLayout:
    FIND _L WHERE RECID(_L) = _U._lo-recid.
    &if DEFINED(IDE-IS-RUNNING) <> 0  &then
    RUN adeuib/ide/_dialog_massync.p (INPUT u-recid, INPUT _L._LO-NAME).
    &else      
    RUN adeuib/_massync.w (INPUT u-recid, INPUT _L._LO-NAME).
    &endif 
    RUN set_pixels_from_ppus.
            
    DISPLAY _U._LAYOUT-NAME _X _Y _WIDTH-P _HEIGHT-P WITH FRAME adv-dial.
    IF h_v-wdth NE ? THEN
        h_v-wdth:SCREEN-VALUE = STRING(_VIRTUAL-WIDTH-P,">,>>>,>>9").
    IF h_v-hgt  NE ? THEN
        h_v-hgt:SCREEN-VALUE = STRING(_VIRTUAL-HEIGHT-P,">,>>>,>>9").
end procedure.

PROCEDURE disable_UI :
/* --------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
   -------------------------------------------------------------------- */
  /* Hide all frames. */
  HIDE FRAME adv-dial.
END PROCEDURE.


PROCEDURE enable_UI :
/* --------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
   -------------------------------------------------------------------- */
  DISPLAY 
        _U._PRIVATE-DATA WHEN _U._TYPE NE "TEXT" lbl-dummy2 _U._LAYOUT-UNIT 
         geom-rect
         _X _Y _WIDTH-P _HEIGHT-P _U._LAYOUT-NAME 
      WITH FRAME adv-dial.
  ASSIGN _U._USER-LIST[1]:CHECKED = _U._USER-LIST[1]
         _U._USER-LIST[2]:CHECKED = _U._USER-LIST[2]
         _U._USER-LIST[3]:CHECKED = _U._USER-LIST[3]
         _U._USER-LIST[4]:CHECKED = _U._USER-LIST[4]
         _U._USER-LIST[5]:CHECKED = _U._USER-LIST[5]
         _U._USER-LIST[6]:CHECKED = _U._USER-LIST[6]
         .
  ENABLE _X _Y _WIDTH-P _HEIGHT-P WITH FRAME adv-dial.
  
  ASSIGN _HEIGHT-P:SENSITIVE  = (_U._TYPE NE "COMBO-BOX" OR (_U._TYPE = "COMBO-BOX" AND _U._SUBTYPE = "SIMPLE"))
         frame_name:SENSITIVE = (_U._TYPE = "FRAME":U).

  RUN sensitivity.
    
END PROCEDURE.

Procedure alignment_change.
  _U._ALIGN = SELF:SCREEN-VALUE.

  RUN set_pixels_from_ppus.
  DISPLAY _X WITH FRAME adv-dial.        
END PROCEDURE.


/* Procedure to check that the height of an object is large enough for its contents
 *
 * sets height to be the minimum value.  Sets changed =TRUE if is changed hgt (i.e. given
 *   hgt was too small).
 */
procedure height-p_check.
  /* Parameters */
  DEFINE INPUT        PARAMETER obj-handle AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT        PARAMETER row-mult   AS DECIMAL       NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER hgt        AS INTEGER       NO-UNDO.
  DEFINE OUTPUT       PARAMETER changed    AS LOGICAL       NO-UNDO INITIAL FALSE.

  /* Local Vars */  
  DEFINE VARIABLE min-height               AS INTEGER       NO-UNDO INIT ?.
     
  child_handle = obj-handle:FIRST-CHILD.

  IF obj-handle:TYPE = "FRAME" THEN   /* Skip field-group widget */
    child_handle = child_handle:FIRST-CHILD.

  DO WHILE VALID-HANDLE(child_handle):
    IF child_handle:TYPE NE "DIALOG-BOX" AND
       child_handle:HEIGHT-P + child_handle:Y > hgt * row-mult
    THEN DO:
      hgt = (child_handle:HEIGHT-P + child_handle:Y) / row-mult.
      
      IF min-height EQ ? THEN
        min-height = hgt.
      ELSE IF hgt > min-height THEN
        min-height = hgt.
    END. 
    
    child_handle = child_handle:NEXT-SIBLING.     
  END.
  
  IF min-height NE ? THEN 
    ASSIGN 
      hgt               = min-height
      changed           = TRUE.

END PROCEDURE.


/* Procedure to check that the width of an object is large enough for its contents.
 *
 * sets wdth to be the minimum value.  Sets changed =TRUE if is changed wdth (i.e. given
 *   wdth was too small).
 */
procedure width-p_check.
  DEFINE INPUT        PARAMETER obj-handle AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT        PARAMETER col-mult   AS DECIMAL       NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER wdth       AS INTEGER       NO-UNDO.
  DEFINE OUTPUT       PARAMETER changed    AS LOGICAL       NO-UNDO INITIAL FALSE.
  
  DEFINE VARIABLE     frame-rect           AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE     min-width            AS INTEGER       NO-UNDO INITIAL ?.
      
  child_handle = obj-handle:FIRST-CHILD.

  IF obj-handle:TYPE = "FRAME" THEN DO:
    FIND _U WHERE _U._HANDLE = obj-handle.
    FIND _C WHERE RECID(_C) = _U._x-recid.
    child_handle = child_handle:FIRST-CHILD.
  END.

  DO WHILE VALID-HANDLE(child_handle):
    IF child_handle:TYPE NE "DIALOG-BOX" AND
       child_handle:WIDTH-P + child_handle:X  > wdth * col-mult
    THEN DO:
      IF child_handle:TYPE = "RECTANGLE" AND obj-handle:TYPE = "FRAME" AND
         child_handle      = _C._FRAME-BAR THEN
        ASSIGN frame-rect              = child_handle
               frame-rect:WIDTH-PIXELS = 1.
      ELSE DO:
        wdth = (child_handle:WIDTH-P + child_handle:X) / col-mult.

        IF min-width EQ ? THEN   /* Keep track of the largest necessary value */
           min-width = wdth.
        ELSE IF wdth > min-width THEN
           min-width = wdth.
      END.
    END. 
    child_handle = child_handle:NEXT-SIBLING.     
  END.
  
  IF min-width NE ? THEN
     ASSIGN
        wdth    = min-width
        changed = TRUE.

  IF VALID-HANDLE(frame-rect) THEN 
     frame-rect:WIDTH-PIXELS = wdth.
     
END PROCEDURE.

PROCEDURE sensitivity.
/* --------------------------------------------------------------------
  Purpose:     Customize sensitivity depending on layout name
  Parameters:  <none>
  Notes:       
   -------------------------------------------------------------------- */
  
  DEF VARIABLE last-tab AS WIDGET-HANDLE                                NO-UNDO.
   
  IF _U._LAYOUT-NAME = "Master Layout" THEN DO:
    ENABLE _U._PRIVATE-DATA  WHEN _U._TYPE NE "TEXT"
           _U._LAYOUT-UNIT WITH FRAME adv-dial.

    ASSIGN _U._USER-LIST[1]:SENSITIVE = (_P.static_object NE NO)
           _U._USER-LIST[2]:SENSITIVE = (_P.static_object NE NO)
           _U._USER-LIST[3]:SENSITIVE = (_P.static_object NE NO)
           _U._USER-LIST[4]:SENSITIVE = (_P.static_object NE NO)
           _U._USER-LIST[5]:SENSITIVE = (_P.static_object NE NO)
           _U._USER-LIST[6]:SENSITIVE = (_P.static_object NE NO)
           .

    /* Establish proper tab order */
    IF help-string NE ? THEN
      stupid = _U._PRIVATE-DATA:MOVE-AFTER(help-string) IN FRAME {&FRAME-NAME}.
    ELSE IF init-data NE ? AND _U._DBNAME EQ ? THEN
      stupid = _U._PRIVATE-DATA:MOVE-AFTER(init-data) IN FRAME {&FRAME-NAME}.
    ELSE fld-grp:FIRST-TAB-ITEM = _U._PRIVATE-DATA:HANDLE IN FRAME {&FRAME-NAME}.

    ASSIGN stupid   = _U._LAYOUT-UNIT:MOVE-AFTER(                        
                        _U._PRIVATE-DATA:HANDLE IN FRAME {&FRAME-NAME})
           stupid   = _U._USER-LIST[1]:MOVE-AFTER(
                        _U._LAYOUT-UNIT:HANDLE IN FRAME {&FRAME-NAME})
           stupid   = _U._USER-LIST[2]:MOVE-AFTER(
                        _U._USER-LIST[1]:HANDLE IN FRAME {&FRAME-NAME})
           stupid   = _U._USER-LIST[3]:MOVE-AFTER(
                        _U._USER-LIST[2]:HANDLE IN FRAME {&FRAME-NAME})
           stupid   = _U._USER-LIST[4]:MOVE-AFTER(
                        _U._USER-LIST[3]:HANDLE IN FRAME {&FRAME-NAME})
           stupid   = _U._USER-LIST[5]:MOVE-AFTER(
                        _U._USER-LIST[4]:HANDLE IN FRAME {&FRAME-NAME})
           stupid   = _U._USER-LIST[6]:MOVE-AFTER(
                        _U._USER-LIST[5]:HANDLE IN FRAME {&FRAME-NAME})
           stupid   = _X:MOVE-AFTER(
                        _U._USER-LIST[6]:HANDLE IN FRAME {&FRAME-NAME})
           stupid   = _Y:MOVE-AFTER(
                        _X:HANDLE IN FRAME {&FRAME-NAME})
           stupid   = _WIDTH-P:MOVE-AFTER(
                        _Y:HANDLE IN FRAME {&FRAME-NAME})
           last-tab = _WIDTH-P:HANDLE.
  END.  /* If Master layout */

  ELSE DO:  /* If custom layout */
    DISABLE _U._PRIVATE-DATA _U._LAYOUT-UNIT _U._USER-LIST[1] _U._USER-LIST[2]
            _U._USER-LIST[3] WITH FRAME adv-dial.
    ASSIGN fld-grp:FIRST-TAB-ITEM = _X:HANDLE IN FRAME {&FRAME-NAME}
           stupid = _Y:MOVE-AFTER(_X:HANDLE IN FRAME {&FRAME-NAME})
           stupid = _WIDTH-P:MOVE-AFTER(_Y:HANDLE IN FRAME {&FRAME-NAME}).                    
  END.  /* If TTY layout */

  IF _U._TYPE NE "COMBO-BOX" THEN
    ASSIGN stupid   = _HEIGHT-P:MOVE-AFTER(_WIDTH-P:HANDLE IN FRAME {&FRAME-NAME})
           last-tab = _HEIGHT-P:HANDLE.
    
  IF _U._TYPE = "DIALOG-BOX" THEN
    ASSIGN _X:SENSITIVE = _C._EXPLICIT_POSITION
           _Y:SENSITIVE = _C._EXPLICIT_POSITION.
           
  IF h_v-wdth NE ? THEN ASSIGN
    stupid = h_v-wdth:MOVE-AFTER(IF _U._TYPE = "COMBO-BOX"
                        THEN _WIDTH-P:HANDLE IN FRAME {&FRAME-NAME}
                        ELSE _HEIGHT-P:HANDLE IN FRAME {&FRAME-NAME})
    stupid = h_v-hgt:MOVE-AFTER(h_v-wdth)
    last-tab = h_v-hgt.

  IF h_row-hgt NE ? THEN DO:
    ASSIGN h_row-hgt:SENSITIVE = (_U._LAYOUT-NAME = "Master Layout":U).
    IF h_row-hgt:SENSITIVE THEN
      ASSIGN stupid = h_row-hgt:MOVE-AFTER(_HEIGHT-P:HANDLE IN FRAME {&FRAME-NAME}).
  END.

  IF h_align NE ? THEN
    ASSIGN stupid   = h_align:MOVE-AFTER(IF _U._TYPE = "COMBO-BOX":U
                       THEN _WIDTH-P:HANDLE IN FRAME {&FRAME-NAME}
                       ELSE IF _U._TYPE = "BROWSE":U
                         THEN h_row-hgt
                         ELSE _HEIGHT-P:HANDLE IN FRAME {&FRAME-NAME})
           last-tab = h_align.
           
  IF _U._TYPE = "FRAME":U THEN 
    ASSIGN stupid   = frame_name:MOVE-AFTER(last-tab)
           last-tab = frame_name:HANDLE.
  IF VALID-HANDLE(h_COLUMN-SEARCHING) THEN
    ASSIGN stupid   = h_COLUMN-SEARCHING:MOVE-AFTER(last-tab)
           last-tab = h_COLUMN-SEARCHING.         
  IF VALID-HANDLE(h_BOX-SELECTABLE) THEN
    ASSIGN stupid   = h_BOX-SELECTABLE:MOVE-AFTER(last-tab)
           last-tab = h_BOX-SELECTABLE.
  IF VALID-HANDLE(h_COLUMN-MOVABLE) THEN
    ASSIGN stupid   = h_COLUMN-MOVABLE:MOVE-AFTER(last-tab)
           last-tab = h_COLUMN-MOVABLE.
  IF VALID-HANDLE(h_COLUMN-RESIZABLE) THEN
    ASSIGN stupid   = h_COLUMN-RESIZABLE:MOVE-AFTER(last-tab)
           last-tab = h_COLUMN-RESIZABLE.
  IF VALID-HANDLE(h_MANUAL-HIGHLIGHT) THEN
    ASSIGN stupid   = h_MANUAL-HIGHLIGHT:MOVE-AFTER(last-tab)
           last-tab = h_MANUAL-HIGHLIGHT.
  IF VALID-HANDLE(h_MOVABLE) THEN
    ASSIGN stupid   = h_MOVABLE:MOVE-AFTER(last-tab)
           last-tab = h_MOVABLE.
  IF VALID-HANDLE(h_PAGE-BOTTOM) THEN
    ASSIGN stupid   = h_PAGE-BOTTOM:MOVE-AFTER(last-tab)
           last-tab = h_PAGE-BOTTOM.
  IF VALID-HANDLE(h_PAGE-TOP) THEN
    ASSIGN stupid   = h_PAGE-TOP:MOVE-AFTER(last-tab)
           last-tab = h_PAGE-TOP.
  IF VALID-HANDLE(h_RESIZABLE) THEN
    ASSIGN stupid   = h_RESIZABLE:MOVE-AFTER(last-tab)
           last-tab = h_RESIZABLE.
  IF VALID-HANDLE(h_SELECTABLE) THEN
    ASSIGN stupid   = h_SELECTABLE:MOVE-AFTER(last-tab)
           last-tab = h_SELECTABLE.
  IF VALID-HANDLE(h_TOP-ONLY) THEN
    ASSIGN stupid   = h_TOP-ONLY:MOVE-AFTER(last-tab)
           last-tab = h_TOP-ONLY.             

  IF NOT _cur_win_type THEN DO:
    DISABLE _U._LAYOUT-UNIT _X _WIDTH-P _Y _HEIGHT-P  WITH FRAME {&FRAME-NAME}.
    IF h_v-wdth NE ? THEN
      ASSIGN h_v-wdth:SENSITIVE = FALSE
             h_v-hgt:SENSITIVE  = FALSE.
  END.     

/*
  IF CAN-DO("WINDOW,DIALOG-BOX",_U._TYPE) THEN
    ASSIGN btn_layout:VISIBLE IN FRAME {&FRAME-NAME} = FALSE.
  ELSE
*/
  btn_layout:SENSITIVE IN FRAME {&FRAME-NAME} = IF _U._LAYOUT-NAME NE "Master Layout":U 
    THEN TRUE ELSE FALSE.
    
  IF _U._LAYOUT-NAME NE "Master Layout":U THEN DO:
    DISABLE _WIDTH-P _HEIGHT-P WITH FRAME adv-dial.
    IF _U._TYPE = "BROWSE":U THEN
      ASSIGN h_row-hgt:SENSITIVE             = FALSE
             h_COLUMN-SEARCHING:SENSITIVE = FALSE
             h_COLUMN-MOVABLE:SENSITIVE      = FALSE
             h_COLUMN-RESIZABLE:SENSITIVE    = FALSE
             h_MOVABLE:SENSITIVE             = FALSE
             h_RESIZABLE:SENSITIVE           = FALSE
             h_SELECTABLE:SENSITIVE          = FALSE.
  END.  /* if not Master Layout */

  
END PROCEDURE.


PROCEDURE set_pixels_from_ppus.
  /* Set the appropriate value of _X , _Y _WIDTH-P, _HEIGHT-P, _VIRTUAL-WIDTH-P, and
     _VIRTUAL-HEIGHT based current window type */
  IF _U._TYPE = "DIALOG-BOX" THEN DO:
    IF _C._EXPLICIT_POSITION THEN
      ASSIGN _X = (_L._COL - 1) * IF _L._WIN-TYPE
                                  THEN SESSION:PIXELS-PER-COLUMN * _L._COL-MULT
                                  ELSE 1
             _Y = (_L._ROW - 1) * (IF _L._WIN-TYPE
                                   THEN SESSION:PIXELS-PER-ROW * _L._ROW-MULT
                                   ELSE 1) - col-lbl-adj.
    ELSE ASSIGN _X = ?
                _Y = ?.
    ASSIGN _WIDTH-P  = IF _L._WIN-TYPE 
                         THEN _L._WIDTH * SESSION:PIXELS-PER-COLUMN * _L._COL-MULT
                         ELSE _L._WIDTH
           _HEIGHT-P = IF _L._WIN-TYPE
                         THEN _L._HEIGHT * SESSION:PIXELS-PER-ROW * _L._ROW-MULT
                         ELSE _L._HEIGHT.
  END.
  ELSE IF NOT _L._WIN-TYPE THEN DO:
    CASE _U._ALIGN:
      WHEN "R":U THEN _X = (_L._COL - 1 + _L._WIDTH - 1).
      WHEN "C":U THEN _X = (_L._COL - 2 - 1).
      OTHERWISE
        _X = IF CAN-DO("FILL-IN,COMBO-BOX":U,_U._TYPE) AND parent_C._SIDE-LABELS THEN
                   /* SIDE-LABELS */ (_L._COL - lbl_wdth - 1)
                ELSE IF parent_U._TYPE = "FRAME" AND NOT parent_C._SIDE-LABELS AND
                     NOT parent_L._NO-LABELS THEN
                   /* COLUMN LABELS */ (_L._COL - MAX(0, lbl_wdth - _L._WIDTH) - 1)
                ELSE (_L._COL - 1).
    END.  /* Case */
    ASSIGN _Y                = _L._ROW - 1 - col-lbl-adj
           _WIDTH-P          = _L._WIDTH
           _HEIGHT-P         = _L._HEIGHT
           _VIRTUAL-WIDTH-P  = _L._VIRTUAL-WIDTH
           _VIRTUAL-HEIGHT-P = _L._VIRTUAL-HEIGHT.
  END.
  ELSE DO:
    CASE _U._ALIGN:
      WHEN "R" THEN _X = (_L._COL - 1 + _L._WIDTH - 1) * SESSION:PIXELS-PER-COLUMN *
                                  _L._COL-MULT.
      WHEN "C" THEN _X = (_L._COL - 2 - 1) * SESSION:PIXELS-PER-COLUMN *
                                  _L._COL-MULT.
      OTHERWISE
        _X = IF CAN-DO("FILL-IN,COMBO-BOX",_U._TYPE) AND parent_C._SIDE-LABELS THEN
                     /* SIDE-LABELS */  (_L._COL - lbl_wdth - 1) * 
                                            SESSION:PIXELS-PER-COLUMN * _L._COL-MULT
                  ELSE IF parent_U._TYPE = "FRAME":U AND NOT parent_C._SIDE-LABELS AND
                       NOT parent_L._NO-LABELS THEN
                     /* COLUMN LABELS */ (_L._COL - MAX(0, lbl_wdth - _L._WIDTH) - 1) *
                                             SESSION:PIXELS-PER-COLUMN * _L._COL-MULT
                  ELSE (_L._COL - 1) * SESSION:PIXELS-PER-COLUMN * _L._COL-MULT.
    END.  /* Case */
    ASSIGN _Y                = ((_L._ROW - 1) * SESSION:PIXELS-PER-ROW *
                                  _L._ROW-MULT) - col-lbl-adj
           _WIDTH-P          = _L._WIDTH * SESSION:PIXELS-PER-COLUMN * _L._COL-MULT
           _HEIGHT-P         = _L._HEIGHT * SESSION:PIXELS-PER-ROW * _L._ROW-MULT
           _VIRTUAL-WIDTH-P  = _L._VIRTUAL-WIDTH * SESSION:PIXELS-PER-COLUMN *
                                                  _L._COL-MULT
           _VIRTUAL-HEIGHT-P = _L._VIRTUAL-HEIGHT * SESSION:PIXELS-PER-ROW *
                                                  _L._ROW-MULT.
  END.
  IF _U._TYPE = "BROWSE":U THEN
    _ROW-HEIGHT-P = IF _L._WIN-TYPE 
                      THEN _C._ROW-HEIGHT * SESSION:PIXELS-PER-ROW * _L._ROW-MULT
                      ELSE _C._ROW-HEIGHT.
END PROCEDURE.



/* Combos, Radio-sets & selection-lists should have an initial-value that is 
   in the list for those widgets.  Look at _F._LIST-ITEMS or _F._LIST-ITEM-PAIRS 
   and generate a {&NL} delimited list of items in the variable: valid-items. */
procedure make-valid-items.
  DEF VAR i      AS INTEGER NO-UNDO.
  DEF VAR iCnt   AS INTEGER NO-UNDO.
  DEF VAR item   AS CHAR    NO-UNDO.
  
  /* If we have LIST-ITEM-PAIRS, pull out the second element of each pair to
     make up the list and return. */
  IF _F._LIST-ITEM-PAIRS NE "" AND _F._LIST-ITEM-PAIRS NE ? THEN DO:
    DO i = 1 TO NUM-ENTRIES(_F._LIST-ITEM-PAIRS,CHR(10)):
      item = ENTRY(2,ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10))).
      CASE _F._DATA-TYPE:
          WHEN "INTEGER":U OR WHEN "INT64":U THEN 
            item = TRIM(STRING(INT64(item), "->>>>>>>>>9":U)).
          WHEN "DATE":U     THEN 
            item = STRING (DATE(item),"99/99/9999":U).
          WHEN "DECIMAL":U  THEN 
            item = STRING (DECIMAL(item), "->>>>>>>>9.99<<<<<<<":U).
          WHEN "LOGICAL":U  THEN 
            item = STRING (CAN-DO("TRUE,YES":U, TRIM(item))).
      END CASE.
      valid-items = valid-items + item + 
        (IF i < NUM-ENTRIES(_F._LIST-ITEM-PAIRS,CHR(10)) THEN CHR(10) ELSE "").
    END.
    RETURN.
  END.
  
  /* In the simplest case (combo-box and selection-lists that represent
     CHARACTER data), _F._LIST-ITEMS is already a {&NL}-delimeted list */
  IF _F._DATA-TYPE eq "CHARACTER":U AND 
     CAN-DO("COMBO-BOX,SELECTION-LIST":U, _U._TYPE)
  THEN 
    valid-items = _F._LIST-ITEMS.    
  ELSE DO:
    /* Actually parse the existing _F._LIST-ITEMS and massage each valid
       value according to the format used to validate it */
    valid-items = "".    
    DO i = 1 TO NUM-ENTRIES(_F._LIST-ITEMS, {&NL}):
      item = ENTRY (i, _F._LIST-ITEMS, {&NL}).
      IF _U._TYPE eq "RADIO-SET":U THEN DO:
        /* This logic will sometimes fail, especially if the radio-item or
           label has a comma or quote in it. */
        item = ENTRY(2,item).
        IF _F._DATA-TYPE eq "CHARACTER":U and item ne ?
        THEN item = ENTRY(2, item, "~"":U).       
      END.
      /* Format each item the way we format SCREEN-VALUE of initial-value. */
      /* Leave UNKNOWN values alone. */
      IF TRIM(item) eq "?" THEN item = "?".
      ELSE DO:
        CASE _F._DATA-TYPE:
          WHEN "INTEGER":U OR WHEN "INT64":U THEN 
            item = TRIM(STRING (INT64(item), "->>>>>>>>>9":U)).
          WHEN "DATE":U     THEN 
            item = STRING (DATE(item),"99/99/9999":U).
          WHEN "DECIMAL":U  THEN 
            item = STRING (DECIMAL(item), "->>>>>>>>9.99<<<<<<<":U).
          WHEN "LOGICAL":U  THEN 
            item = STRING (CAN-DO("TRUE,YES":U, TRIM(item))).
        END CASE.
      END. /* If item ne ?... */
      valid-items = valid-items + (IF i > 1 THEN {&NL} ELSE "") + item.
    END. /* DO i... */
  END. /* IF not character combo-box or selection-list */
END PROCEDURE.




