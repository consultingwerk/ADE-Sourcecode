/***********************************************************************
* Copyright (C) 2005-2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------------

File: _rdfill.p

Description:
    Procedure to read in static fill-in information.
    Wood (5/7/93) Note that we treat TEXT as a subclass of FILL-IN for v7.

Input Parameters:
   pcSubtype -  "TEXT" or "" (for regular fill-ins).
   from_schema - TRUE if processing schema picker output ELSE false

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1992

Modified on 11/20/96 by gfs added tooltip from qs
            02/12/98 by gfs added no-tab-stop,disable-auto-zap & drop-target
            10/13/98 by gfs added tooltip attr
            06/07/99 by tsm added context-help-id attribute
            06/25/99 by tsm set session numeric format to setting that user is
                            using so that db field inital values display with
                            the correct numeric format on fill-in fields
                            in a design window

---------------------------------------------------------------------------- */
DEFINE INPUT PARAMETER pcSubtype   AS CHAR                         NO-UNDO.
DEFINE INPUT PARAMETER from_schema AS LOGICAL                      NO-UNDO.

{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/sharvars.i}     /* Shared variables                                  */
{adeuib/analyze.i &TYPE = "FILL-IN" } /* Analyzer Names for Combo-box        */
{src/adm2/globals.i}

DEFINE SHARED  STREAM    _P_QS2.
                        /* This is the input stream with "Quick Save"        */
                        /* formatted data                                    */

DEFINE SHARED  VARIABLE  _inp_line  AS  CHAR     EXTENT 100           NO-UNDO.
                        /* This is the input line buffer for the _P_QS data  */
                        /* data stream                                       */

DEFINE VARIABLE cInitialData       AS  CHARACTER                      NO-UNDO.
DEFINE VARIABLE i                  AS  INTEGER                        NO-UNDO.
DEFINE VARIABLE tmp-db             AS  CHAR INITIAL ?                 NO-UNDO.
DEFINE VARIABLE tmp-entry          AS  CHAR                           NO-UNDO.
DEFINE VARIABLE tmp-label          AS  CHAR                           NO-UNDO.
DEFINE VARIABLE tmp-tbl            AS  CHAR INITIAL ?                 NO-UNDO.
DEFINE VARIABLE hSDO               AS HANDLE                          NO-UNDO.

FIND _P WHERE _P._WINDOW-HANDLE EQ _h_win.  /* Necessary for temp-table support  */

IF {&AH_widget} = "" THEN DO:  /* This is really a literal from a V6 proc        */
  RUN adeuib/_rdtext.p.
  RETURN.
END.

{adeuib/readinit.i &p_type="FILL-IN"
                   &p_basetype="FILL-IN" }
                   
/* If _U._TABLE is not equal to _U._BUFFER then this is a buffer field and
   we need to change _U._TABLE to the buffer name and we need to change
   _U._DBNAME to "Temp-Tables" so that the object's property sheet 
   functions without errors and so that the frame's query is generated
   properly */
IF _U._TABLE NE _U._BUFFER THEN 
  ASSIGN _U._TABLE  = _U._BUFFER
         _U._DBNAME = "Temp-Tables".    

IF from_schema THEN _F._DICT-VIEW-AS = _suppress_dict_view-as.

IF NOT parent_L._WIN-TYPE THEN    /* parent_L is the Master layout of the parent */
  ASSIGN _L._HEIGHT   = 1         /* We will create non-master _L's later        */
         _L._WIN-TYPE = NO.

IF from_schema AND _U._DBNAME = "Temp-Tables":U THEN DO:
  /* This is a temp-table field.  See if we have a temp-table definition for 
    _U._TABLE and _U._NAME                                 */
  SEARCH-LOOP:
  DO i = 1 TO NUM-ENTRIES(_fld_names):
    tmp-entry = ENTRY(i, _fld_names).
    IF ENTRY(1, tmp-entry, ".":U) = "Temp-Tables":U AND
       ENTRY(2, tmp-entry, ".":U) = _U._TABLE AND
       ENTRY(3, tmp-entry, ".":U) = _U._NAME THEN DO:
      /* We have a tt entry that meets our criteria, find the _TT record */
      FIND _TT WHERE _TT._p-recid = RECID(_P) AND
                     _TT._NAME = ENTRY(2, tmp-entry, ".":U) NO-ERROR.
      IF NOT AVAILABLE _TT THEN
        FIND _TT WHERE _TT._p-recid = RECID(_P) AND
                       _TT._LIKE-TABLE = ENTRY(2, tmp-entry, ".":U).
      ASSIGN _U._DBNAME = "Temp-Tables":U
             tmp-db     = _TT._LIKE-DB
             tmp-tbl    = _TT._LIKE-TABLE.
      LEAVE SEARCH-LOOP.
    END.  /* Have found a match */
  END. /* SEARCH-LOOP DO i = 1 to num-entries */  
END.  /* If from schema and not db or table */
IF from_schema AND tmp-db = ? THEN  /* Regular field */
  ASSIGN tmp-db  = _U._DBNAME
         tmp-tbl = _U._TABLE.

IF from_schema AND LENGTH(v_label, "raw":U) = 16 AND f_side_labels THEN DO:
  /* Label got truncated due to WITH 1 COLUMN. */
  /* Only call field label code when field is not from
     dataobject (temp-table type "D"). Fixes 98-09-18-034. - jep */
  IF (NOT AVAILABLE _TT OR _TT._TABLE-TYPE <> "D":U) THEN
      RUN adeuib/_fldlbl.p (tmp-db, tmp-tbl, _U._NAME, f_side_labels, 
                            OUTPUT v_label, OUTPUT _U._LABEL-ATTR).
END.

       

ASSIGN _U._SUBTYPE             = pcSubtype
       _F._DATA-TYPE           = IF {&AFF_data-type} = "1"  THEN "Character":U ELSE
                                 IF {&AFF_data-type} = "2"  THEN "Date":U ELSE
                                 IF {&AFF_data-type} = "3"  THEN "Logical":U ELSE
                                 IF {&AFF_data-type} = "4"  THEN "Integer":U ELSE
                                 IF {&AFF_data-type} = "5"  THEN "Decimal":U ELSE
                                 IF {&AFF_data-type} = "7"  THEN "RECID":U ELSE
                                 IF {&AFF_data-type} = "34" THEN "Datetime":U ELSE
                                 IF {&AFF_data-type} = "40" THEN "Datetime-Tz":U ELSE
                                 IF {&AFF_data-type} = "41" THEN "INT64":U ELSE
                                                            "WIDGET-HANDLE":U
       _U._ALIGN               = IF f_side_labels       THEN "C" ELSE "L"
       _F._FORMAT              = {&AFF_format}
       _F._FORMAT-ATTR         = IF {&AFF_format-sa} NE ? 
                                 THEN {&AFF_format-sa} ELSE ""
       _F._FORMAT-SOURCE       = IF from_schema OR _U._DBNAME NE ? THEN "D" ELSE "E"
       _U._HELP-SOURCE         = IF from_schema OR _U._DBNAME NE ? THEN "D" ELSE "E"
       _L._NO-LABELS           = ({&AFF_no-label} EQ "Y")
       /* If no-labels then don't show the label */
       tmp-label               = _U._LABEL  /* We MAY need this in the Temp-Table case */
       _U._LABEL               = IF _L._NO-LABELS 
                                 THEN ""
                                 ELSE (IF v_label = ? THEN _U._NAME ELSE v_label)
       _U._LABEL-SOURCE        = IF (from_schema OR _U._DBNAME NE ?)
                                 THEN "D" ELSE "E"
       _F._AUTO-RETURN         = ({&AFF_auto-return} EQ "Y")
       _F._DEBLANK             = ({&AFF_deblank} EQ "Y")
       _F._BLANK               = ({&AFF_blank} EQ "Y")
       _F._PASSWORD-FIELD      = ({&AFF_password-field} EQ "Y")
       _F._NATIVE              = ({&AFF_native} EQ "Y")
       _F._UNDO                = IF _U._TABLE = ? AND tmp-tbl = ? 
                                    THEN ({&AFF_undo} EQ "y") ELSE TRUE
       _U._TOOLTIP             = {&AFF_TOOLTIP}
       _U._TOOLTIP-ATTR        = {&AFF_TOOLTIP-ATTR}
       _U._DROP-TARGET         = {&AFF_drop-target} = "y"
       _U._NO-TAB-STOP         = {&AFF_NO-TAB-STOP} = "y"
       _F._DISABLE-AUTO-ZAP    = {&AFF_disable-auto-zap} = "y"
       _U._CONTEXT-HELP-ID     = INTEGER({&AFF_context-help-id}) 
       _U._WIDGET-ID           = INTEGER({&AFF_widget-id})
       .

/* For DB fields where we are supposed to use the Default name, 
  (LABEL-SOURCE = "D"), the UIB stores the label locally in _U._LABEL.  This
  will not have been set if the there is no label in the frame. (Note: we
  are assuming here that the frame has column-labels. */
IF (_U._DBNAME NE ?) AND _L._NO-LABELS AND (_U._LABEL EQ "") THEN DO:
  IF _U._DBNAME NE "Temp-Tables" THEN 
    RUN adeuib/_fldlbl.p
            (_U._DBNAME, _U._TABLE, _U._NAME, NO,
             OUTPUT _U._LABEL, OUTPUT _U._LABEL-ATTR).
  ELSE DO:  /* A Temp-Table - Find out what table to actually look up */
    FIND _TT WHERE _TT._p-recid = RECID(_P) AND
                   _TT._LIKE-TABLE = _U._TABLE AND
                   _TT._NAME = _U._NAME NO-ERROR.
    IF NOT AVAILABLE _TT THEN
      FIND _TT WHERE _TT._p-recid = RECID(_P) AND
                     _TT._LIKE-TABLE = _U._TABLE AND
                     _TT._NAME = ? NO-ERROR.
    IF AVAILABLE _TT THEN
      RUN adeuib/_fldlbl.p
              (_TT._LIKE-DB, _TT._LIKE-TABLE, _U._NAME, NO,
               OUTPUT _U._LABEL, OUTPUT _U._LABEL-ATTR).
    ELSE _U._LABEL = tmp-label.
  END.  /* If a temp-table */
END.  /* If _U._LABEL = "" */

/* If ICF is running and this is a dynamic viewer, get the label, format and help from 
   the running SDO */
IF _DynamicsIsRunning THEN 
DO:
  IF DYNAMIC-FUNCTION("ClassIsA" IN gshRepositoryManager, _P.object_type_code, "DynView":U) AND 
   _P._DATA-OBJECT NE "":U THEN DO:
    hSDO = DYNAMIC-FUNCTION("get-sdo-hdl" IN _h_func_lib, INPUT _P._DATA-OBJECT, THIS-PROCEDURE) NO-ERROR.
    IF VALID-HANDLE(hSDO) THEN
    DO:
      ASSIGN
        _U._LABEL  = DYNAMIC-FUNCTION("columnLabel":U IN hSDO, INPUT _U._NAME)
        _F._FORMAT = DYNAMIC-FUNCTION("columnFormat":U IN hSDO, INPUT _U._NAME)
        _U._HELP   = DYNAMIC-FUNCTION("columnHelp":U IN hSDO, INPUT _U._NAME).
      DYNAMIC-FUNCTION("shutdown-sdo" IN _h_func_lib, THIS-PROCEDURE).
    END.  /* valid SDO */
  END.  /* DynView */
END.  /* ICF Running */

CREATE VALUE(IF parent_U._WIN-TYPE AND _U._SUBTYPE NE "TEXT" THEN "FILL-IN" ELSE "TEXT")
    _U._HANDLE
       ASSIGN {adeuib/std_attr.i &MODE = "READ" }
              FORMAT            = _F._FORMAT
              DATA-TYPE         = IF parent_U._WIN-TYPE THEN _F._DATA-TYPE
                                                        ELSE "CHARACTER"
         TRIGGERS:
              {adeuib/std_trig.i}
         END TRIGGERS.

/* Assign Handles that we now know */
ASSIGN { adeuib/std_uf.i &SECTION = "HANDLES" } .

/* Make fill-ins read-only and set BGColor to white if not set to view-as-text 
   since read-only fields are displayed using default background color  */
IF _U._TYPE = "FILL-IN":U THEN
   ASSIGN _U._HANDLE:READ-ONLY = YES.
          _U._HANDLE:BGCOLOR   = IF _L._BGCOLOR = ? AND _U._SUBTYPE <> "TEXT":U 
                                THEN 15 ELSE _L._BGCOLOR.

/* If a date change string to the correct format */
{adeuib/datefrmt.i _F._INITIAL-DATA}

/* Need to set numeric format to user's setting so that the initial value
   will display correctly on the design window. 
   Need to set the screen value before setting the format in case an
   Intl Numeric format other than AMERICAN is being used.  When the fill-in
   is created, the format has been set to AMERICAN so for decimals the
   the screen-value is 0.00 and when changing the format this may give
   an error so we must set it to 0 or ?, change the format and
   then set it so that the format is taken into account. */
SESSION:SET-NUMERIC-FORMAT(_numeric_separator, _numeric_decimal).

/* Need to convert the initial data value from the dictionary to a 
   non-American format for display in the design window */
IF CAN-DO("DECIMAL,INTEGER,INT64":U,_F._DATA-TYPE) THEN DO:
  RUN adecomm/_convert.p (INPUT 'A-TO-N', 
                          INPUT _F._INITIAL-DATA, 
                          INPUT _numeric_separator, 
                          INPUT _numeric_decimal,
                          OUTPUT cInitialData).

  ASSIGN _F._INITIAL-DATA = cInitialData.
END.  /* if integer or decimal */

/* Set the FORMAT and SCREEN-VALUE */
IF _cur_win_type THEN DO:  /* We handle the TTY case in _sim_lbl.p */
  IF _U._HANDLE:DATA-TYPE EQ "CHARACTER":U 
  THEN ASSIGN _U._HANDLE:FORMAT       = "X(50)"
              _U._HANDLE:SCREEN-VALUE = _F._INITIAL-DATA.
  ELSE ASSIGN _U._HANDLE:SCREEN-VALUE = IF LOOKUP(_U._HANDLE:DATA-TYPE, "INTEGER,DECIMAL,INT64":U) > 0 
                                        THEN "0":U ELSE ?
              _U._HANDLE:FORMAT       = _F._FORMAT
              _U._HANDLE:SCREEN-VALUE = (IF _U._HANDLE:DATA-TYPE EQ "LOGICAL":U THEN
                                           IF _F._INITIAL-DATA = "":U THEN "no":U 
                                           ELSE TRIM(_F._INITIAL-DATA)
                                         ELSE _F._INITIAL-DATA).
END.

SESSION:NUMERIC-FORMAT = "AMERICAN":U.

IF {&AC_position-unit} = "p" THEN
  ASSIGN _U._HANDLE:X             = _X
         _U._HANDLE:Y             = _Y.
ELSE
  ASSIGN _U._HANDLE:COL           = 1 + (_L._COL - 1) * _cur_col_mult
         _U._HANDLE:ROW           = 1 + (_L._ROW - 1) * _cur_row_mult.

IF {&AC_size-unit} = "p" THEN
  ASSIGN _U._HANDLE:WIDTH-PIXELS        = _WIDTH-P
         _U._HANDLE:HEIGHT-PIXELS       = _HEIGHT-P.
ELSE
  ASSIGN _U._HANDLE:WIDTH    = _L._WIDTH * _cur_col_mult
         _U._HANDLE:HEIGHT   = _L._HEIGHT * _cur_row_mult.

/* This is a kluge to get it look right */
IF _F._DATA-TYPE = "RECID" AND _F._INITIAL-DATA = ? THEN
  ASSIGN _F._INITIAL-DATA = "?"
         _U._HANDLE:SCREEN-VALUE = "?".

/* Create multiple layout records if necessary */
{adeuib/crt_mult.i}
/* Now get the _L for the current layout instead of the master layout */
FIND _L WHERE RECID(_L) = _U._lo-recid.

IF NOT _L._WIN-TYPE OR _U._SUBTYPE = "TEXT" THEN
  RUN adeuib/_sim_lbl.p (_U._HANDLE).
  
/* Add a label to the current widget */
{ adeuib/addlabel.i }

/* Move the label into the proper place.  Note that _showlbl "fixes" up
   invalid alignment so we set it to "L" which is always correct.  [Colon
   alignment can't accept a column position < 1 [fill-in:COL < 3]. 
   We will again change the alignment when we read in the UIB settings.  */
_U._ALIGN = IF _U._HANDLE:COL < 3 OR NOT f_side_labels THEN "L" ELSE "C".
RUN adeuib/_showlbl.p (INPUT _U._HANDLE). 

/* Make sure the Universal Widget Record is "correct" by reading the actually
   instantiated values. */
ASSIGN  {adeuib/std_uf.i &section = "GEOMETRY"} .




