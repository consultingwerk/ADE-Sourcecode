/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: readinit.i

Description:
    Procedure to check for widget already existing and resolve the conflict.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: Greg O'Connor, Ross Hunter

Date Created: 1993

Modified    : HD 1998 July 
              Don't run adecomm/_s-schem.p for _TT._TABLE_TYPE = "W"
              This is WebSpeed temp-tables that may exist 
              in a unconnected     
---------------------------------------------------------------------------- */
{adeuib/name-rec.i}     /* Name indirection table                            */
{adeuib/layout.i }      /* Layout temp-table definitions                     */
{adeuib/uibhlp.i }      /* Layout temp-table definitions                     */

DEFINE SHARED VARIABLE tab-number AS INTEGER                          NO-UNDO.
DEFINE SHARED VARIABLE ok_to_load AS LOG                              NO-UNDO.
DEFINE SHARED VARIABLE dot-w-file AS CHAR   FORMAT "X(40)"            NO-UNDO.

DEFINE VARIABLE AZ            AS   CHAR                               NO-UNDO.
DEFINE VARIABLE action-string AS   CHAR                               NO-UNDO.
DEFINE VARIABLE asc-value     AS   INTEGER                            NO-UNDO.
DEFINE VARIABLE f_side_labels AS   LOGICAL                            NO-UNDO.
DEFINE VARIABLE frm-name      AS   CHAR                               NO-UNDO.
DEFINE VARIABLE i-let         AS   INTEGER                            NO-UNDO.
DEFINE VARIABLE potntl-num    AS   CHAR                               NO-UNDO.
DEFINE VARIABLE v_name        AS   CHAR                               NO-UNDO.
DEFINE VARIABLE v_org-name    AS   CHAR                               NO-UNDO.
DEFINE VARIABLE v_label       AS   CHAR                               NO-UNDO.
DEFINE VARIABLE v_lbl_attr    AS   CHAR                               NO-UNDO.
DEFINE VARIABLE v_tmp_label   AS   CHAR                               NO-UNDO.
DEFINE VARIABLE v_exists      AS   LOGICAL                            NO-UNDO.
DEFINE VARIABLE p_index       AS   INTEGER                            NO-UNDO.
DEFINE VARIABLE ret-msg       AS   CHARACTER                          NO-UNDO.
DEFINE VARIABLE subscrpt      AS   CHAR                               NO-UNDO.
DEFINE VARIABLE v_cur_win     AS   WIDGET                             NO-UNDO.
DEFINE VARIABLE _HEIGHT-P     AS INTEGER INITIAL ?.
DEFINE VARIABLE _WIDTH-P      AS INTEGER INITIAL ?.
DEFINE VARIABLE _X            AS INTEGER INITIAL ?.
DEFINE VARIABLE _Y            AS INTEGER INITIAL ?.
DEFINE VARIABLE tmp_handle    AS HANDLE                               NO-UNDO.
DEFINE VARIABLE v_dbPname     AS CHAR                                 NO-UNDO.
DEFINE VARIABLE v_dbLname     AS CHAR                                 NO-UNDO.
DEFINE VARIABLE v_dbType      AS CHAR                                 NO-UNDO.
DEFINE VARIABLE v_choice      AS CHAR                                 NO-UNDO.
DEFINE VARIABLE l_dummy       AS LOG                                  NO-UNDO.

DEFINE VARIABLE cBuffer        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cClobCols      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cHelp          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLocalName     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMappedName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTable         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hDataSource    AS HANDLE     NO-UNDO.
DEFINE VARIABLE lClob          AS LOGICAL    NO-UNDO.    

DEFINE BUFFER   parent_U      FOR  _U.
DEFINE BUFFER   parent_L      FOR  _L.
DEFINE BUFFER   parent_C      FOR  _C.

/* First see if we are dealing with a dialog-box or window                   */
FIND _U WHERE _U._HANDLE = _h_win.
v_cur_win = _U._WINDOW-HANDLE.  /* _U._WINDOW-HANDLE is ? for a dialog-box   */

/* Get current frames recid as the parent recid                              */
FIND parent_U WHERE parent_U._HANDLE eq _h_frame.
FIND parent_L WHERE parent_L._u-recid = RECID(parent_U) AND
                    parent_L._lo-name = "Master Layout".
FIND parent_C WHERE RECID(parent_C)  eq parent_U._x-recid.
ASSIGN frm-name      = parent_U._NAME
       f_side_labels = parent_C._SIDE-LABELS.

_cur_win_type = parent_U._WIN-TYPE.

/*
** Find out what the _count index should be
*/
CASE "{&p_type}":
    WHEN "BROWSE":U   THEN  p_index = {&BRWSR}.
    WHEN "BUTTON":U   THEN  p_index = {&BTN}.
    WHEN "COMBO-BOX":U          THEN    p_index = {&CBBOX}.
    WHEN "EDITOR":U   THEN  p_index = {&EDITR}.
    WHEN "FILL-IN":U    THEN  p_index = {&FILLN}.
    WHEN "IMAGE":U    THEN  p_index = {&IMAGE}.
    WHEN "RADIO-SET":U    THEN  p_index = {&RADIO}.
    WHEN "RECTANGLE":U    THEN  p_index = {&RECT}.
    WHEN "SELECTION-LIST":U THEN  p_index = {&SELCT}.
    WHEN "SLIDER":U   THEN  p_index = {&SLIDR}.
    WHEN "TEXT":U   THEN  p_index = {&TEXT}.
    WHEN "TOGGLE-BOX":U   THEN  p_index = {&TOGGL}.
    OTHERWISE
      message "Assert error TYPE: {&p_type}" SKIP
              "FILE: {&FILE-NAME} LINE: {&LINE-NUMBER}."
              view-as alert-box error buttons Ok.
   END CASE.
/*
** IF the type is TEXT then build a name automatically
*/
IF "{&p_type}" = "TEXT" then
 ASSIGN 
      _count[p_index] = _count[p_index] + 1
      v_name = "{&p_type}-" + STRING (_count[p_index]).
ELSE
  ASSIGN v_org-name  = {&AH_widget}  /* v_org-name is necessary if v_name   */
         v_name      = {&AH_widget}. /* changes on an import                */
  
/* If the procedure has a data source, the field may be a CLOB data field that 
   must be represented by a local LONGCHAR editor on the frame.  The frame's
   mapping is checked to get the name of the field in its data source.  That is 
   then checked against the the data source's clobColumns to ensure that 
   the field is a clob (though it should be if it is in the mapping).    
   The buffer, table and help are set appropriately from the field mapping/
   data source.  */
FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
IF AVAILABLE _P AND _P._DATA-OBJECT NE "":U THEN 
DO:
  hDataSource = DYNAMIC-FUNC("get-sdo-hdl" IN _h_func_lib, 
                                          INPUT _P._DATA-OBJECT,
                                          INPUT SOURCE-PROCEDURE).

  IF VALID-HANDLE(hDataSource) THEN
  DO:
    IF LOOKUP(v_name, parent_C._DATAFIELD-MAPPING) > 0 THEN
    DO:
      ASSIGN 
        cLocalName  = v_name
        cMappedName = DYNAMIC-FUNCTION("mappedEntry":U IN _h_func_lib,
                                      INPUT v_name,
                                      INPUT parent_C._DATAFIELD-MAPPING,
                                      INPUT TRUE,
                                      INPUT ",":U).
      IF cMappedName NE "":U THEN 
      DO:
        cClobCols = DYNAMIC-FUNCTION("getClobColumns":U IN hDataSource).
        
        /* Currently the _C._DATAFIELD-MAPPING in an SDO has unqualifed names 
           when the field is added and qualified on file open ..., 
           so make sure the field is in synch before looking up the list  */
        IF cMappedname BEGINS 'RowObject.' AND INDEX(cClobcols,'.':U) = 0 THEN
          cMappedName = ENTRY(2,cMappedName,'.').

        IF LOOKUP(cMappedName, cClobCols) > 0 THEN
          ASSIGN 
            lClob      = TRUE
            cBuffer    = (IF NUM-ENTRIES(cMappedName, ".":U) > 1
                          THEN ENTRY(1, cMappedName, ".":U)
                          ELSE 'RowObject':U)
            cTable     = cBuffer
            cHelp      = DYNAMIC-FUNCTION("columnHelp":U IN hDataSource, INPUT cMappedName)
            v_name     = (IF NUM-ENTRIES(cMappedName, ".":U) > 1
                          THEN ENTRY(2, cMappedName, ".":U)
                          ELSE cMappedName).
      END.
    END.  /* if name in mapping */
    ELSE cLocalName = "":U.
  END.  /* if valid data source */
END.  /* if avail _P */

IMPORT STREAM _P_QS2 _inp_line.

/* If it is a clob field and the help is set in the analyzer output, then 
   help for the field is set to that.  Otherwise it is set to cHelp retrieved
   above from the data source. */
IF lClob THEN
DO:
  IF {&AC_help} > "":U THEN 
    cHelp = {&AC_help}.
END.  /* if clob */
/* If it is not a clob field then its buffer, table and help come from the 
   analyser output. */
ELSE
  ASSIGN
    cBuffer = {&AC_buffer}
    cTable  = {&AC_table}
    cHelp   = {&AC_help}.

/* The qs file may have a different db name if this file is opened remotely */
IF {&AC_ldbname} <> "":U AND NOT CONNECTED({&AC_ldbname}) AND NOT ok_to_load THEN 
DO:   
  RUN adeuib/_advisor.w (
    INPUT "The database '" + {&AC_ldbname} + "' is used to " +
          "compile the " + dot-w-file + " file on the server." + CHR(10) +
           CHR(10) + "Would you like to connect to this database?",
    INPUT
"Co&nnect. Connect to '" + {&AC_ldbname} + "' now.,_CONNECT,
&Open. Try to open the file without connecting.,_LOAD,
&Cancel. Do not open the file.,_CANCEL" ,
   INPUT FALSE,
   INPUT "{&UIB_SHORT_NAME}",
   INPUT {&Advisor_DB_Connect_on_Open},
   INPUT-OUTPUT v_choice,
   OUTPUT l_dummy ).
  
 CASE v_choice:
   WHEN "_CONNECT":U THEN DO:
     ASSIGN v_DbPname = {&AC_ldbname}
            v_DbLname = ?
            v_DbType  = "":U.
     IF v_DbType = "" OR v_DbType = ? THEN v_Dbtype = "PROGRESS".
     RUN adecomm/_dbconn.p
       (INPUT-OUTPUT  v_DbPname,
        INPUT-OUTPUT  v_DbLname,
        INPUT-OUTPUT  v_DbType).
     IF (v_DbPname = ?) AND (v_DbLname = ?) THEN RETURN "_ABORT".
   END. /* _CONNECT */   
   WHEN "_LOAD":U THEN DO:
     ASSIGN v_choice = "_CANCEL":U.
       RUN adeuib/_advisor.w (
         INPUT "You have chosen to attempt to load " + dot-w-file +
               " despite not having the correct database(s) connected." +
               " This will probably cause " + dot-w-file + " to be corrupted." +
               " However, there may be cases when no harm will be done." +
               CHR(10) + CHR(10) +
               "You should not save this file on top of " + dot-w-file +
               " unless you are certain that no corruption has occurred." +
               CHR(10) + CHR(10) +
               "Would you like to continue loading?",
         INPUT "Co&ntinue.  Continue loading.,_CONTINUE, &Cancel. Do not load.,_CANCEL",
         INPUT FALSE,          
         INPUT "{&UIB_SHORT_NAME}",
         INPUT {&Advisor_DB_Connect_on_Open},
         INPUT-OUTPUT v_choice,
         OUTPUT l_dummy).
     If v_choice EQ "_CANCEL" then RETURN "_ABORT".        
     ELSE ok_to_load = TRUE.
   END. /* _LOAD */   
   WHEN "_CANCEL":U THEN RETURN "_ABORT".
 END CASE.

END.  /* If not connected */


/*
** IF the type is FILL-IN then the side label is in the 19 postion
*/
&IF "{&p_type}" eq "FILL-IN" &THEN
/* Use label if SIDE-LABELS on the frame (or if there is no explicit 
   Column-label) */
IF f_side_labels OR {&AFF_col-label} eq ? 
THEN ASSIGN v_label    = {&AFF_label}
            v_lbl_attr = IF {&AFF_label-sa} NE ? THEN {&AFF_label-sa}
                         ELSE "".
ELSE ASSIGN v_label    = {&AFF_col-label}
            v_lbl_attr = IF {&AFF_col-label-sa} NE ? THEN {&AFF_col-label-sa} 
                         ELSE "".
/* If there is no label at all, use the PROGRESS default: label = name */
IF v_label eq ? THEN
    ASSIGN v_label    = v_name
         v_lbl_attr = "".

/*
** IF the type is COMBO-BOX then
*/
&ELSEIF "{&p_type}" eq "COMBO-BOX" &THEN
/* Use label if SIDE-LABELS on the frame (or if there is no explicit 
   Column-label) */
IF f_side_labels OR {&ACB_col-label} eq ? 
THEN ASSIGN v_label    = {&ACB_label}
            v_lbl_attr = IF {&ACB_label-sa} NE ? THEN {&ACB_label-sa}
                         ELSE "".
ELSE ASSIGN v_label    = {&ACB_col-label}
            v_lbl_attr = IF {&ACB_col-label-sa} NE ? THEN {&ACB_col-label-sa} 
                         ELSE "".
/* If there is no label at all, use the PROGRESS default: label = name */
IF v_label eq ? THEN
    ASSIGN v_label    = v_name
         v_lbl_attr = "".
         
&ELSE
IF p_index EQ {&BRWSR} THEN
  ASSIGN v_label    = ?
         v_lbl_attr = "".
ELSE
  ASSIGN v_label    = {&ApC_label}
         v_lbl_attr = IF {&ApC_label-sa} NE ? THEN {&ApC_label-sa} ELSE "".
&ENDIF

         
ASSIGN subscrpt = &IF "{&p_type}" = "COMBO-BOX"          &THEN {&ACB_extent}
                  &ELSEIF "{&p_type}" = "EDITOR"         &THEN {&AED_extent}
                  &ELSEIF "{&p_type}" = "FILL-IN"        &THEN {&AFF_extent}
                  &ELSEIF "{&p_type}" = "RADIO-SET"      &THEN {&ARS_extent}
                  &ELSEIF "{&p_type}" = "SELECTION-LIST" &THEN {&ASE_extent}
                  &ELSEIF "{&p_type}" = "SLIDER"         &THEN {&ASL_extent}
                  &ELSEIF "{&p_type}" = "TOGGLE-BOX"     &THEN {&ATB_extent}
                  &ELSE ? &ENDIF
       v_name   = v_name + IF subscrpt NE ? AND subscrpt NE "0" AND
                              subscrpt NE "" THEN
                           "[" + subscrpt + "]" ELSE "".
            

/*
** IF there is no frame then we can not place a field level widget. 
** Read mode may need to be set to deleted if there is no frame.
** This should never happen!!!
*/
IF _h_frame = ? THEN
DO:
  /* Tried to draw something outside of a frame. */
  IF _count[{&FRAME}] > 0 THEN action-string = "select".
  ELSE action-string = "create".
  BELL.

  MESSAGE "You cannot draw an {&p_type} object outside a frame." SKIP
          "      Please" action-string  "a frame."
       VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  RETURN.
END.

CREATE _NAME-REC.
ASSIGN _NAME-REC._wNAME   = v_name
       _NAME-REC._wDBNAME = {&AC_ldbname}
       _NAME-REC._wTABLE  = IF cBuffer NE ? THEN cBuffer ELSE cTable
       _NAME-REC._wTYPE   = "{&p_type}"
       _NAME-REC._wFRAME  = frm-name.

/* Adjust for temp-tables */
IF _NAME-REC._wDBNAME = "" AND _NAME-REC._wTABLE NE ? THEN
   _NAME-REC._wDBNAME = "Temp-Tables":U.
          
/* Look to see if record already exists IN THE SAME FRAME. We allow 
   multiple copies of  a variable if they are in different frames.  
   So if we can find a widget with the same name in another frame that
   will not prevent a duplicate.  If a copy of the widget cannot be 
   found in _h_frame, then check for the error condition of a copy in
   another frame (in which case we need to make sure TYPE and DATA-TYPE
   match.*/
FIND FIRST _U WHERE _U._NAME = v_name AND
           _U._STATUS = "NORMAL" AND
           NOT CAN-DO("FRAME,DIALOG-BOX",_U._TYPE) AND
           _U._parent-recid = RECID(parent_U)
           USE-INDEX _NAME NO-ERROR.

/* If not in same frame, try to find ANY matching name. */
IF NOT AVAILABLE _U THEN 
FIND FIRST _U WHERE _U._NAME = v_name AND
           _U._STATUS = "NORMAL" AND
           NOT CAN-DO("FRAME,DIALOG-BOX",_U._TYPE) AND
           _U._WINDOW-HANDLE = v_cur_win 
           USE-INDEX _NAME NO-ERROR.

IF available _U THEN
DO:   /* Found a field level widget by the same name in this window         */
  /* Fill-ins have two -'s that must be replaced                            */
  v_tmp_label = REPLACE (v_name, "-", " ").
  /* Okay to have two of the same name in different frames.  If the frame   */
  /* is the same, then we need to find a unique name for non-database vars. */
  /* We just do ignore a second copy of a database variable.                */
  IF p_index NE {&BRWSR} AND _U._parent-recid = RECID(parent_U) THEN DO:
    /* Is it a DB field?  We must refind the _u because find FIRST using name
       might have found one that is different while there might exist other
       with conflicting data */
    FIND FIRST _U WHERE _U._NAME          = v_name 
                  AND _U._STATUS        = "NORMAL" 
                  AND _U._WINDOW-HANDLE = v_cur_win  
                  AND _U._DBNAME        = _NAME-REC._wDBNAME 
                  AND _U._TABLE         = _NAME-REC._wTABLE  
                  AND _U._BUFFER        = (IF cBuffer = ? 
                                           THEN _U._TABLE 
                                           ELSE cBuffer) 
                  AND NOT CAN-DO("FRAME,DIALOG-BOX",_U._TYPE) 
                  AND _NAME-REC._wTABLE NE ? NO-ERROR.
    IF AVAIL _U THEN
    DO:  
      MESSAGE "It is illegal to put the" 
              IF _NAME-REC._wDBNAME = "Temp-Tables":U 
              THEN "temp-table field"
              ELSE "database field"
              (IF _NAME-REC._wDBNAME = ? OR _NAME-REC._wDBNAME = "Temp-Tables" 
               THEN ""
               ELSE _NAME-REC._wDBNAME + ".") 
              + _U._BUFFER + "." + _NAME-REC._wNAME SKIP
             "more than once into the same frame."  SKIP (1)
             "Ignoring second definition." 
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      DELETE _NAME-REC.
      RETURN.
    END. /* if avail _u */
    /* Get a new unique name for non database fields in the same frame. */
    ELSE IF _NAME-REC._wTABLE EQ ? THEN DO:
      RUN adeshar/_bstname.p 
                   (v_name, ?, "{&p_type}", p_index, _h_win, OUTPUT v_name).
      IF v_label BEGINS REPLACE("{&p_basetype}","-","  ") THEN
        v_label = SUBSTRING(v_name,1,1,"CHARACTER":U) + 
                           REPLACE (LC(SUBSTRING(v_name,2,-1,"CHARACTER":U)), "-", " ").
    END.  /* If widget with same name is in this frame.                    */
  END.  /* If not a browse widget */
                   
  /* Get a new unique name for Rectangles, Images, Buttons, Text and Browses
     even if they are in different frames                                    */
  ELSE IF _NAME-REC._wTABLE EQ ? AND
       CAN-DO("RECTANGLE,IMAGE,TEXT,BUTTON,BROWSE":U,_NAME-REC._wTYPE) THEN DO:
    RUN adeshar/_bstname.p 
                   (v_name, ?, "{&p_type}", p_index, _h_win, OUTPUT v_name).
    IF v_label BEGINS REPLACE("{&p_basetype}","-","  ") THEN
      v_label = SUBSTRING(v_name,1,1,"CHARACTER":U) +
                          REPLACE (LC(SUBSTRING(v_name,2,-1,"CHARACTER":U)), "-", " ").
  END.
END. /* if available _u */ 

CREATE _U.
CREATE _L.
IF p_index NE {&BRWSR} THEN CREATE _F.
ELSE DO:
  CREATE _C.
  CREATE _Q.
END.

ASSIGN _U._NAME                = v_name
       _U._lo-recid            = RECID(_L)
       _L._LO-NAME             = "Master Layout"
       _L._u-recid             = RECID(_U)
       _L._WIN-TYPE            = parent_L._WIN-TYPE
       _L._COL-MULT            = parent_L._COL-MULT
       _L._ROW-MULT            = parent_L._ROW-MULT
       _U._x-recid             = IF p_index = {&BRWSR} THEN RECID(_C) ELSE RECID(_F)
       _U._parent-recid        = RECID(parent_U)
       _U._LABEL               = IF p_index NE {&RECT} AND p_index NE {&IMAGE}
                                 THEN v_label ELSE ""
       _U._LABEL-ATTR          = v_lbl_attr
       _U._SENSITIVE           = TRUE
       _U._DISPLAY             = TRUE
       _U._STATUS              = "NORMAL"
       _U._TYPE                = "{&p_type}"
       _NAME-REC._wRECID       = RECID(_U).

IF p_index NE {&BRWSR} THEN
  ASSIGN
    _F._SOURCE-DATA-TYPE    = IF lClob THEN "CLOB":U ELSE ?
    _U._LOCAL-NAME          = IF lClob THEN cLocalName ELSE "":U.

/* Set the TAB-ORDER field to the shared var tab-number, which is defined  */
/* and initialized in _qssuckr.p; everytime a new frame is read, the value */
/* is reset to 0. This value needs to be set so that the tab order the     */
/* analyzer is reading the objects in is mimicked in the _U records.       */
/* IMPORTANT - only non-frame objects are read in, and assigned a tab order*/
/* number here. If a frame is a sibling to one of these objects, the tab   */
/* order is adjusted appropriately based upon the information found in the */
/* runtime attributes section. */

IF NOT CAN-DO ('SmartObject,OCX,TEXT,IMAGE,RECTANGLE,LABEL':U, _U._TYPE) THEN DO:
  tab-number = tab-number + 1.
  _U._TAB-ORDER = tab-number.
END.

IF p_index NE {&BRWSR} THEN DO:
  ASSIGN _F._FRAME     = _h_frame
         _F._SUBSCRIPT = IF subscrpt EQ ? THEN ? ELSE INTEGER(subscrpt).
END.  /* If not a browse widget */
ELSE _C._q-recid = RECID(_Q).

/* Establish new _count[{&TYPE}] */
IF _U._NAME BEGINS "{&p_basetype}-" THEN
NUMERIC-CHECK:
DO:
  potntl-num = SUBSTRING(_U._NAME,LENGTH("{&p_basetype}-","CHARACTER":U) + 1,
                                    -1,"CHARACTER":U).
  IF LENGTH(potntl-num,"CHARACTER":U) > 0 THEN
  DO i-let = 1 TO LENGTH(potntl-num,"CHARACTER":U):
    asc-value = ASC(SUBSTRING(potntl-num,i-let,1,"CHARACTER":U)).
    IF asc-value < 48 OR asc-value  > 57 THEN LEAVE NUMERIC-CHECK.
  END.
 _count[p_index] = MAX(_count[p_index], INTEGER(potntl-num)). 
END.  /* NUMERIC-CHECK  potentially a numeric */
  
IF {&AC_position-unit} = "p" THEN 
    ASSIGN _X      = INTEGER({&AC_X})
           _Y      = INTEGER({&AC_Y}).
  ELSE DO:
    ASSIGN _L._COL   = DECIMAL({&AC_X})
           _L._ROW   = DECIMAL({&AC_Y}).
    /* Row and Col are 1 based */
    IF _L._COL < 1 THEN _L._COL = 1.
    IF _L._ROW < 1 THEN _L._ROW = 1.
  END.
           
IF {&AC_size-unit} = "p" THEN 
  ASSIGN _WIDTH-P        = INTEGER({&AC_width})
         _HEIGHT-P       = INTEGER({&AC_height})
         _U._LAYOUT-UNIT = FALSE.
ELSE
  ASSIGN _L._WIDTH       = DECIMAL({&AC_width})
         _L._HEIGHT      = DECIMAL({&AC_height})
         _U._LAYOUT-UNIT = TRUE.
                              
ASSIGN _L._FGCOLOR        = IF {&AC_color-mode} = "7"   THEN INTEGER({&AC_FGcolor})
                            ELSE IF {&AC_color-mode} = "6" THEN -1 ELSE ?
       _L._BGCOLOR        = IF {&AC_color-mode} = "7"   THEN INTEGER({&AC_BGcolor})
                            ELSE IF {&AC_color-mode} = "6" THEN -1 ELSE ?
       _L._FONT           = INTEGER({&AC_font})
       _U._DBNAME         = {&AC_ldbname}
       _U._TABLE          = cTable
       _U._BUFFER         = IF cBuffer = ? THEN _U._TABLE
                                                ELSE cBuffer
       _U._LABEL-SOURCE   = IF _U._DBNAME = ? THEN "E" ELSE "D".

IF cBuffer NE ? THEN _NAME-REC._wTABLE = cBuffer.

/* Adjust for temp-tables and CLOBs */
IF lClob AND _U._DBNAME = ? THEN 
  ASSIGN 
    _U._DBNAME       = "Temp-Tables":U
    _U._LABEL-SOURCE = "D":U.
IF _U._DBNAME = "" AND _U._TABLE NE ? THEN _U._DBNAME = "Temp-Tables":U.

IF p_index NE {&BRWSR} THEN
  ASSIGN _F._FORMAT-SOURCE  = _U._LABEL-SOURCE
         _U._HELP-SOURCE    = _U._LABEL-SOURCE.
ASSIGN _U._HELP           = IF cHelp ne ? THEN cHelp ELSE "" 
       _U._HELP-ATTR      = IF {&AC_help-sa} ne ? THEN {&AC_help-sa} ELSE "".

/* Initial Value apply only to "variables". */
IF NOT CAN-DO("BROWSE,BUTTON,RECTANGLE,IMAGE",_U._TYPE) THEN DO:
  IF _U._TABLE = ? THEN _F._INITIAL-DATA = {&AC_initial}.
  ELSE DO:  /* A database field */
    IF _U._DBNAME NE "Temp-Tables":U THEN
      RUN adecomm/_s-schem.p (_U._DBNAME,
                              _U._TABLE,
                              _U._NAME,
                              "FIELD:INITIAL":U,
                               OUTPUT _F._INITIAL-DATA).
    ELSE DO: /* A field from a temp-table. */
      FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
      FIND FIRST _TT WHERE _TT._p-recid = RECID(_P) AND
                           _TT._NAME    = _U._TABLE NO-ERROR.
      IF NOT AVAILABLE _TT THEN
        FIND FIRST _TT WHERE _TT._p-recid = RECID(_P) AND
                             _TT._LIKE-TABLE = _U._TABLE NO-ERROR.

      /* If Data-Object temp-table field, query the data-object for initial value and
         enabled state. jep-code */
      IF AVAILABLE _TT 
      AND (_TT._TABLE-TYPE = "D":u)
      AND (_P._DATA-OBJECT = "<_CONVERTED_>") THEN 
      DO:
        RUN adeuib/_get-sdo.w (INPUT _U._NAME, INPUT 'SmartViewer':U, OUTPUT _P._DATA-OBJECT).
        /* If it is not a valid SDO, set it back to converted flag for future consideration */
        IF _P._DATA-OBJECT = "" THEN DO:
          _P._DATA-OBJECT = "<_CONVERTED_>".
          DELETE _U.
          DELETE _L.
          IF p_index NE {&BRWSR} THEN DELETE _F.
          ELSE DO:
            DELETE _C.
            DELETE _Q.
          END.
          FOR EACH _TT WHERE _TT._p-recid = RECID(_P):
            DELETE _TT.
          END.
          DELETE _P.
          FIND _U WHERE _U._HANDLE = _h_win.
          RUN adeuib/_delet_u.p (RECID(_U), TRUE).
          RETURN "_ABORT":U.
        END.  /* If _get-sdo was canceled */
      END.

      IF _P._DATA-OBJECT <> '':U THEN
        /* Start the sdo or a sdo pretender for remote sdos on behalf of the 
           source, in order to avoid restarting it each time.            
           The source _qssuckr.p must run shutdown  */           
        tmp_handle = DYNAMIC-FUNC("get-sdo-hdl" IN _h_func_lib, 
                                  INPUT _P._DATA-OBJECT,
                                  INPUT SOURCE-PROCEDURE).
      
      IF VALID-HANDLE(tmp_handle) THEN 
      DO:
        /* In case the initial value is a DATE, we must ensure the string comes back as
           a "mdy" date string for internal use by the AppBuilder. Then we must set the
           session date format back to original -d value. Fixes 98-08-14-002 (jep). */
        SESSION:DATE-FORMAT = "mdy":U.
        _F._INITIAL-DATA = DYNAMIC-FUNC("columnInitial" IN tmp_handle, 
                                        _U._TABLE + '.' + _U._NAME) NO-ERROR.

        SESSION:DATE-FORMAT = _orig_dte_fmt.
        _U._SENSITIVE    = NOT DYNAMIC-FUNC("columnReadOnly" IN tmp_handle, 
                                            _U._TABLE + '.' + _U._NAME) NO-ERROR.
        _U._LABEL-SOURCE = "E".   
        ASSIGN NO-ERROR. /* Clear the ERROR-STATUS handle just in case. */
      END.  /* If valid handle */

      /* Don't do this for Webspeed unmapped fields, because we may not be connected*/      
      ELSE IF AVAIL _TT AND _TT._TABLE-TYPE <> "W":U THEN 
        RUN adecomm/_s-schem.p (_TT._LIKE-DB,
                                _TT._LIKE-TABLE,
                                _U._NAME,
                                "FIELD:INITIAL":U,
                                OUTPUT _F._INITIAL-DATA).
    END. /* A temp-table field */
  END. /* A database field */
END.  /* A widget that can contain a db field */

/* DO NOT shutdown here as it will stop and start the sdo for each field 
   the caller shuts down the SDO  
DYNAMIC-FUNCTION("shutdown-sdo":U  IN _h_func_lib, SOURCE-PROCEDURE).
*/
