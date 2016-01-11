/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _drwflds.p

Description:
    Draws a series of fields and labels using the schema picker.

Input Parameters:

    flds_list - If passed, _drwflds.p skips the field picking and simply generated the
                import file with the specified fields. Currently supported only for procedures
                that have data objects.
                
Input-Output Paramaters:
    drawn - Return TRUE if any fields are chosen AND a valid import file
            is created.

Output Paramaters:
    dbf_temp_file - Name of file to import

Author: D. Ross Hunter, Wm.T.Wood, Ravi-Chandar Ramalingam

Date Created: 1992

11-May-1993 D. Lee	Standardized the error messages.
17-Feb-1995 GFS         Add support to box-mark area for field drop.
13-Mar-1995 GFS         Added routine to check field labels lengths and adjust
                        the x starting location if necessary.
12-Mar-1998 JEP     If user does not have any temp-tables defined other than RowObject,
                    display only the field name. Otherwise, display table.field.
03-Sep-1998 JEP     Added support to exclude existing fields when calling
                    multi-field selector.
11-Dec-1998 HD      Added support to exclude existing DATABASE fields when 
                    calling multi-field selector.
----------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER flds_list     AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER drawn         AS LOGICAL NO-UNDO.
DEFINE OUTPUT       PARAMETER dbf_temp_file AS CHARACTER NO-UNDO.

{adeuib/sharvars.i}
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adecomm/adestds.i}
{adecomm/adeintl.i}

DEFINE VAR db_table     AS CHARACTER                     NO-UNDO.
DEFINE VAR fld_name     AS CHARACTER FORMAT "X(12)"      NO-UNDO.
DEFINE VAR fld_leader   AS CHARACTER                     NO-UNDO.
DEFINE VAR tbl_list     AS CHARACTER                     NO-UNDO.
DEFINE VAR i            AS INTEGER                       NO-UNDO.
DEFINE VAR skip_hgt     AS DECIMAL   INITIAL 0.0         NO-UNDO.
DEFINE VAR num_ent      AS INTEGER                       NO-UNDO.
DEFINE VAR pressed_ok   AS LOGICAL                       NO-UNDO.
DEFINE VAR dummy        AS LOGICAL                       NO-UNDO.
DEFINE VAR f-row        AS INTEGER                       NO-UNDO.
DEFINE VAR f-col        AS INTEGER                       NO-UNDO.
DEFINE VAR numrows      AS INTEGER                       NO-UNDO.
DEFINE VAR numcols      AS INTEGER                       NO-UNDO.
DEFINE VAR to-row       AS INTEGER                       NO-UNDO.
DEFINE VAR to-col       AS INTEGER                       NO-UNDO.
DEFINE VAR tt-def       AS CHARACTER                     NO-UNDO.
DEFINE VAR tt-info      AS CHARACTER                     NO-UNDO.
DEFINE VAR c            AS INTEGER                       NO-UNDO.
DEFINE VAR fwidth       AS INTEGER                       NO-UNDO.
DEFINE VAR ok           AS LOGICAL INITIAL FALSE         NO-UNDO.
DEFINE VAR cClobMapping AS CHARACTER                     NO-UNDO.
DEFINE VAR cLocalFld    AS CHARACTER                     NO-UNDO.
DEFINE VAR cSDOClobCols AS CHARACTER                     NO-UNDO.
DEFINE VAR iNumFld      AS INTEGER                       NO-UNDO.
DEFINE VAR lSBOSource   AS LOGICAL                       NO-UNDO.
DEFINE BUFFER x_U FOR _U.
DEFINE BUFFER x_L FOR _L.


DEFINE VAR p_hDataObject AS WIDGET-HANDLE NO-UNDO.
DEFINE VAR useDataObject AS LOGICAL NO-UNDO.

DEFINE STREAM temp_file.

/* Select one table. */
ASSIGN dummy      =_h_win:LOAD-MOUSE-POINTER("")
       _fl_name   = "":U
       _fld_names = "":U.

FIND _U WHERE _U._HANDLE = _h_frame NO-ERROR.
FIND _P WHERE _P._WINDOW-HANDLE = _h_win.

useDataObject = (_P._DATA-OBJECT <> "").
IF useDataObject THEN
    RUN GetDataObjectFields.
ELSE
    RUN GetDBFields.
    
IF num_ent = 0 OR _fld_names = ? THEN DO:
  /* Do Nothing -- we used to do give this error message which I did not take out:
  MESSAGE "There are no database fields selected."
       VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. 
  ------------------------------*/
END.
ELSE IF pressed_ok THEN DO:
  /* We need to fully specify the names of the fields: db.table.field.
     The fld_names may already include the table (if we selected multiple tables),
     otherwise add the database.table leader on each file name is... */
  IF _db_name NE "Temp-Tables":U THEN DO:
    IF NUM-ENTRIES(ENTRY(1,_fld_names),".") eq 1
      THEN fld_leader = _db_name + "." + _fl_name + "." .
      ELSE fld_leader = _db_name + "." .
  END.  /* If not dealing with temp-tables */

  /* Get information about the frame we are drawing in.  Find the lower edge
     corner of all widgets already in the frame so that we can import at the
     correct spot.  NOTE: in a column-label frame, look at all non-RECTANGLE
     widgets.  In a side-label frame, just look at DB Field widgets in 
     deciding how much to skip. */
  FIND _U WHERE _U._HANDLE eq _h_frame.
  FIND _L WHERE RECID(_L) eq _U._lo-recid.
  FIND _C WHERE RECID(_C) eq _U._x-recid.

  /* Create a temporary file to IMPORT */
  RUN  adecomm/_tmpfile.p ({&STD_TYP_UIB_DBFIELD}, {&STD_EXT_UIB}, OUTPUT dbf_temp_file).
  OUTPUT STREAM temp_file TO VALUE(dbf_temp_file) {&NO-MAP}.
  PUT STREAM temp_file UNFORMATTED
      "&ANALYZE-SUSPEND _EXPORT-NUMBER " _UIB_VERSION SKIP
      "&ANALYZE-RESUME" SKIP.

  /* If there are temp-table definitions, write them out here */
  RUN gen-tt-def(OUTPUT tt-def).
  PUT STREAM temp_file UNFORMATTED tt-def SKIP.

  IF useDataObject THEN 
  DO:
    DO iNumFld = 1 TO NUM-ENTRIES(_fld_names):
      fld_name = ENTRY(iNumFld, _fld_names).
      IF fld_name BEGINS "Temp-Tables":U THEN
        fld_name = REPLACE(fld_name, "Temp-Tables.":U, "":U).
      IF fld_name BEGINS "RowObject":U THEN
        fld_name = REPLACE(fld_name, "RowObject.":U, "":U).
      /* If the field is a clob field, add a local LONGCHAR variable to the frame */
      IF LOOKUP(fld_name, cSDOClobCols) > 0 THEN
      DO:
        /* Rename the local field if there is already a field on the viewer 
           with the same name. */
        cLocalFld = IF lSBOSource AND NUM-ENTRIES(fld_name, ".":U) > 1 
                    THEN ENTRY(2, fld_name, ".":U)
                    ELSE fld_name.
        i = 0.
        /* First check for other fields */
        NameCheck:
        DO WHILE TRUE:
          FIND FIRST x_U WHERE x_U._NAME EQ cLocalFld 
               AND x_U._WINDOW-HANDLE = _P._WINDOW-HANDLE 
               AND x_U._STATUS NE "DELETED":U NO-ERROR.
          IF AVAILABLE x_U THEN
          DO:
            IF i > 0 THEN
              cLocalFld = SUBSTRING(cLocalFld, 1, INDEX(cLocalFld, "-":U) - 1).
            i = i + 1.
            cLocalFld = cLocalFld + "-":U + STRING(i).
          END.  /* if avail x_U */
          ELSE LEAVE NameCheck.
        END.  /* do while true */
        /* Second check for other CLOB fields that may already have the same name
           local name */
        LocalNameCheck:
        DO WHILE TRUE:
          FIND FIRST x_U WHERE x_U._LOCAL-NAME EQ cLocalFld 
               AND x_U._WINDOW-HANDLE = _P._WINDOW-HANDLE 
               AND x_U._STATUS NE "DELETED":U NO-ERROR.
          IF AVAILABLE x_U THEN
          DO:
            IF i > 0 THEN
              cLocalFld = SUBSTRING(cLocalFld, 1, INDEX(cLocalFld, "-":U) - 1).
            i = i + 1.
            cLocalFld = cLocalFld + "-":U + STRING(i).
          END.  /* if avail x_U */
          ELSE LEAVE LocalNameCheck.
        END.  /* do while true */
        /* If the data source is an SBO there could be a name clash with
           with other fields in the SBO (same field in multiple SDOs) being 
           added at the same time.  If it clashes with another field already 
           in the mapping, create a unique name for the local field. */ 
        IF lSBOSource THEN 
        DO:
          DO WHILE LOOKUP(cLocalFld, cClobMapping) > 0:
            IF i > 0 THEN
              cLocalFld = SUBSTRING(cLocalFld, 1, INDEX(cLocalFld, "-":U) - 1).
            i = i + 1.
            cLocalFld = cLocalFld + "-" + STRING(i).
          END.  /* do while */
        END.  /* if SBO data source */
        /* Add to mapping - format is 
           localfield,SDOName.fieldname[,...] */
        cClobMapping = cClobMapping + 
                       (IF cClobMapping NE "":U THEN ",":U ELSE "":U) +
                       cLocalFld + ",":U + fld_name.
        fld_name = cLocalFld.
        PUT STREAM temp_file UNFORMATTED 
          "DEFINE VARIABLE " fld_name " AS LONGCHAR" SKIP
          "    VIEW-AS EDITOR LARGE SIZE 30 BY 1." SKIP(1).
      END.  /* if clob */
    END.  /* do iNumFld */
    /* Assign frame datafield-mapping so that mapping is used in readinit.i to 
       set _U name, table and buffer correctly */
    _C._DATAFIELD-MAPPING = cClobMapping.
  END.  /* if useDataObject */

  /* Figure out the area in which to draw the fields in the frame */
  IF _C._SIDE-LABELS THEN RUN adeuib/_chklbls.p (_L._FONT). /* adjust x to start */
  ASSIGN f-row   = 1.0 + (_frmy / SESSION:PIXELS-PER-ROW)  /* starting row */
         f-col   = 1.0 + (_frmx / SESSION:PIXELS-PER-COL). /* starting column */
         
  IF (_second_corner_x - _frmx) / SESSION:PIXELS-PER-COLUMN < .9 OR
     (_second_corner_y - _frmy) / SESSION:PIXELS-PER-ROW < .9 THEN DO:
    IF (_second_corner_x - _frmx) / SESSION:PIXELS-PER-COLUMN < .9 THEN
      ASSIGN fwidth = _h_frame:WIDTH - f-col.
    IF (_second_corner_y - _frmy) / SESSION:PIXELS-PER-ROW < .9 THEN
      ASSIGN numrows = _h_frame:HEIGHT - f-row.
  END.  /* If either part of the click is close */
  ELSE 
    ASSIGN
      to-row  = 1.0 + (_second_corner_y / SESSION:PIXELS-PER-ROW)  /* ending row */
      numrows = to-row - f-row
      to-col  = 1.0 + (_second_corner_x / SESSION:PIXELS-PER-COLUMN)  /* ending col */
      fwidth  = to-col - f-col.
  IF numrows = ? OR numrows < 1 THEN numrows = 1.
  ASSIGN numrows = MAX(1,numrows)
         numcols = MAX(1, (num_ent / numrows)). /* number of columns needed */
  IF num_ent MOD numrows <> 0 then numcols = numcols + 1.
  /* Write out the FORM statement */
  PUT STREAM temp_file UNFORMATTED 
    /* Skip to the next line, unless there are no lines left, in which case
       we start at the top again */
    "FORM " .
  DO i = 1 TO num_ent:
    fld_name = fld_leader + ENTRY(i, _fld_names).
    IF fld_name BEGINS "Temp-Tables":U THEN
      fld_name = REPLACE(fld_name, "Temp-Tables.":U, "":U).
    /* Check the mapping for the field name to get the local field
       name for the frame. */
    cLocalFld = REPLACE(fld_name, "RowObject.":U, "":U).
    IF LOOKUP(cLocalFld, cClobMapping) > 0 THEN
      fld_name = DYNAMIC-FUNCTION("mappedEntry":U IN _h_func_lib,
                                  INPUT cLocalFld,
                                  INPUT cClobMapping,
                                  INPUT FALSE,
                                  INPUT ",":U).
    PUT STREAM temp_file UNFORMATTED SKIP "    ":U fld_name.
    IF (i - 1) MOD numrows ne 0 THEN DO: /* same column */
      PUT STREAM temp_file UNFORMATTED " COLON " (IF c > 0 THEN c ELSE f-col).
    END.
    ELSE DO: /* new column */
      c = IF i eq 1 THEN f-col  /* First Column */
          ELSE c + fwidth / numcols.
      PUT STREAM temp_file UNFORMATTED " AT ROW " f-row " COL " c " COLON-ALIGNED".
    END.
  END.
  IF _C._SIDE-LABELS THEN
    PUT STREAM temp_file UNFORMATTED SKIP
	  "  WITH SIDE-LABELS SCROLLABLE".
  ELSE DO:   /* Column LABELS */
    PUT STREAM temp_file UNFORMATTED SKIP
	  "  WITH DOWN SCROLLABLE".
  END.  
  /* Add Frame attributes that would affect the default size of a fill-in
     (e.g. THREE-D and FONT) */
  PUT STREAM temp_file UNFORMATTED
	     (IF _L._3-D THEN " THREE-D" ELSE "") + 
	     (IF _L._FONT ne ? THEN " FONT " + STRING(_L._FONT) ELSE "") + 
	     "." SKIP "ENABLE ALL." SKIP.
  
  OUTPUT STREAM temp_file CLOSE.
  /* Debugging Code: Look at the file before we return */
/*   RUN adeuib/_prvw4gl.p (dbf_temp_file, ?, ?, ?).                        */
/*   RUN adecomm/_pwmain.p (INPUT "_ab.p"    /* PW Parent ID  */ ,          */
/*                          INPUT dbf_temp_file      /* Files to open */ ,  */
/*                          INPUT "" /* PW Command    */ ).                 */
  drawn = TRUE.
END.  /* DO because we have at least one field */

RETURN.

PROCEDURE gen-tt-def :
/*------------------------------------------------------------------------------
  Purpose:  Fill up a character parameter with the temp-table definition    
  Parameters:  def-line
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER def-line AS CHARACTER                         NO-UNDO.
  
  DEFINE VAR addl_fields AS CHARACTER NO-UNDO.

  FOR EACH _TT WHERE _TT._p-recid = RECID(_P):
    CASE _TT._TABLE-TYPE:
  
      WHEN "T":U THEN
      DO:
        addl_fields = REPLACE(_TT._ADDITIONAL_FIELDS, CHR(10),
                             CHR(10) + "       ":U).
        def-line = def-line +
                   "DEFINE ":U + (IF _TT._SHARE-TYPE NE "" THEN
                   (_TT._SHARE-TYPE + " ":U) ELSE "") + "TEMP-TABLE " +
                   (IF _TT._NAME = ? THEN _TT._LIKE-TABLE ELSE _TT._NAME) +
                   (IF _TT._UNDO-TYPE = "NO-UNDO":U THEN " NO-UNDO":U ELSE "":U) +
                   " LIKE ":U + _TT._LIKE-DB + ".":U + _TT._LIKE-TABLE +
                   (IF _TT._ADDITIONAL_FIELDS NE "":U THEN (CHR(10) + "       ":U +
                    addl_fields + ".":U) ELSE ".") + CHR(10).
      END.
      
      WHEN "B":U THEN
      DO:
        def-line = def-line +
                   "DEFINE ":U + (IF _TT._SHARE-TYPE NE "" THEN
                   (_TT._SHARE-TYPE + " ":U) ELSE "") + "BUFFER " + _TT._NAME + 
                   " FOR ":U + _TT._LIKE-DB + ".":U + _TT._LIKE-TABLE + ".":U +
                   CHR(10).
      END.
  
      WHEN "D":U THEN
      DO:    
        addl_fields = REPLACE(_TT._ADDITIONAL_FIELDS, CHR(10),
                             CHR(10) + "       ":U).
        IF _TT._NAME = "RowObject":U THEN
        DO: /* In case dataobject include file path contains spaces, we enclose
               its file reference in quotes. - jep */
            addl_fields = REPLACE(addl_fields, '~{', '~{"').
            addl_fields = REPLACE(addl_fields, '~}', '"~}').
        END.
        def-line = def-line + 
                   "DEFINE TEMP-TABLE " + _TT._NAME 
                   + (IF _TT._UNDO-TYPE = "NO-UNDO":U THEN " NO-UNDO":U ELSE "":U) 
                   +  (IF _TT._ADDITIONAL_FIELDS NE "":U 
                       THEN (CHR(10) + "       ":U + addl_fields + ".":U) 
                       ELSE ".") 
                   + CHR(10).
      END.
    
    END CASE.
  END.
    
END PROCEDURE.

PROCEDURE GetDBFields.
  DEFINE VARIABLE exclude-fields AS CHAR NO-UNDO.
  
  FOR EACH x_U WHERE x_U._PARENT-RECID = RECID(_U) AND
           x_U._DBNAME = _db_name:
    IF NOT CAN-DO(_fl_name,x_U._TABLE) THEN
      _fl_name = _fl_name + (IF _fl_name NE "":U THEN ",":U ELSE "":U)
                          + x_U._TABLE.
  END.
  
  IF CAN-FIND(FIRST _TT WHERE _TT._p-recid = RECID(_P)) THEN DO:
    FOR EACH _TT WHERE _TT._p-recid = RECID(_P):
      tt-info = tt-info + ",":U + _TT._LIKE-DB + ".":U + _TT._LIKE-TABLE +
                "|":U + (IF _TT._NAME = ? THEN "?":U ELSE _TT._NAME) +
                "|":U + _TT._TABLE-TYPE.
    END.
    tt-info = LEFT-TRIM(tt-info,",":U).
  END.
  ELSE tt-info = ?.
 
  RUN adecomm/_tblsel.p (true, INPUT tt-info,
                         INPUT-OUTPUT _db_name, INPUT-OUTPUT _fl_name,
  		           OUTPUT pressed_ok).
  
  IF NOT pressed_ok THEN RETURN.
  ELSE IF _fl_name = "" OR _fl_name = ? THEN DO:
    MESSAGE "There are no database tables selected."
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    drawn = no.
    RETURN.
  END.
  
  ASSIGN num_ent  = NUM-ENTRIES(_fl_name)
         tbl_list = _fl_name.
  IF num_ent > 0 THEN DO:
    /* Get a list of "database.table,database.table" */
    DO i = 1 TO num_ent:
      ENTRY(i,tbl_list) = _db_name + "." + ENTRY(i,_fl_name).
    END.
    
    /* Build an exclude field list of those database fields already in
       the object. Don't want them to display in the available fields list.
    */
    
    IF AVAILABLE _U THEN
    DO:
        FOR EACH x_U WHERE x_U._PARENT-Recid = RECID(_U)
                     AND   (IF x_u._TABLE = x_u._BUFFER 
                            THEN CAN-DO(tbl_list,x_u._DBNAME + "." + x_U._TABLE) 
                            
                            /* if this is a buffer the 'temp-tables' in 
                               tbl-list cannot be used to compare x_u, 
                               so we compare only the buffername  */
                            ELSE CAN-DO(REPLACE(tbl_list,"Temp-Tables.":U,"":U),
                                        x_u._BUFFER)  
                           )                       
                     AND   x_U._STATUS <> "DELETED":U NO-LOCK:
            ASSIGN exclude-fields = exclude-fields + x_u._BUFFER + "." + x_U._NAME + ",".
        END.
        ASSIGN exclude-fields = TRIM(exclude-fields, ',') NO-ERROR.
    END.
    
    RUN adecomm/_mfldsel.p (INPUT tbl_list, INPUT ?, INPUT tt-info, "2", ",", 
                            INPUT exclude-fields, INPUT-OUTPUT _fld_names).
    RUN adecomm/_setcurs.p ("":U).
    num_ent = NUM-ENTRIES(_fld_names).
  END.
END PROCEDURE.


PROCEDURE GetDataObjectFields.
  DEFINE VARIABLE ret-msg           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE show_items        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE exclude-fields    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFieldName        AS CHARACTER NO-UNDO.

  DEFINE BUFFER fld_U FOR _U.
  DEFINE BUFFER X_S   FOR _S.

  p_hDataObject = DYNAMIC-FUNC("get-proc-hdl" IN _h_func_lib, INPUT _P._DATA-OBJECT).
  IF NOT VALID-HANDLE(p_hDataObject) THEN
  DO:
    MESSAGE "Unable to start data object " _P._DATA-OBJECT "."
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    drawn = no.
    RETURN.
  END.
  ELSE
  DO:
      /* When drawing a "DB-FIELDS" object for a procedure object that has a Data Object
         for its data source, set _db_name to "Temp-Tables". This is because AppBuilder
         support of data-object fields is through its temp-tables support. So force
         _db_name to be "Temp-Tables". */
      ASSIGN _db_name = "Temp-Tables":U.
      cSDOClobCols = DYNAMIC-FUNCTION("getCLOBColumns":U IN p_hDataObject).
      lSBOSource = IF DYNAMIC-FUNCTION("getObjectType":U IN p_hDataObject) = "SmartBusinessObject":U
                   THEN TRUE 
                   ELSE FALSE. 
      IF (flds_list <> "") THEN
      DO:
          ASSIGN  _fld_names   = flds_list
                  num_ent     = NUM-ENTRIES(_fld_names)
                  pressed_ok  = TRUE.
          RETURN.
      END.
  END.
  
  /* Build the temp-tables info to pass to the field picker. */
  _fl_name = "".
  IF CAN-FIND(FIRST _TT WHERE _TT._p-recid = RECID(_P)) THEN
  DO:
    FOR EACH _TT WHERE _TT._p-recid = RECID(_P):
      tt-info = tt-info + ",":U + _TT._LIKE-DB + ".":U + _TT._LIKE-TABLE +
                "|":U + (IF _TT._NAME = ? THEN "?":U ELSE _TT._NAME).
      _fl_name = _fl_name + (IF _TT._NAME = ? THEN _TT._LIKE-TABLE ELSE _TT._NAME) + ",".
    END.
    tt-info = LEFT-TRIM(tt-info,",":U).
    _fl_name = TRIM(_fl_name, ",":U).
  END.
  ELSE tt-info = ?.
  
  IF _fl_name = "" OR _fl_name = ? THEN
  DO:
    MESSAGE "Unable to determine data souce table information."
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    drawn = no.
    RETURN.
  END.
  pressed_ok = YES.
    
  ASSIGN num_ent  = NUM-ENTRIES(_fl_name)
         tbl_list = _fl_name.
  IF num_ent > 0 THEN
  DO:
    /* Get a list of "database.table,database.table" */
    DO i = 1 TO num_ent:
      ENTRY(i,tbl_list) = _db_name + "." + ENTRY(i,_fl_name).
    END.
  
    /* If user does not have any temp-tables defined other than RowObject,
       display only the field name. Otherwise, display table.field.  jep-code */
    ASSIGN show_items = (IF NUM-ENTRIES(tbl_list) <= 1 THEN "1":U
                                                       ELSE "2":U).

    /* Build an exlcude field list of those rowobject fields already in
       the object. Don't want them to display in the available fields list.
    */
    IF AVAILABLE _U THEN
    DO:
        FOR EACH fld_U WHERE fld_U._PARENT-Recid = RECID(_U)
                            AND fld_U._STATUS <> "DELETED":U NO-LOCK:
            IF fld_U._TABLE = "RowObject":U OR fld_U._BUFFER = "RowObject":U OR 
               fld_U._CLASS-NAME = "DataField":U THEN DO:
              IF VALID-HANDLE(p_hDataObject) AND lSBOSource
              THEN
                ASSIGN exclude-fields = exclude-fields + fld_U._TABLE + ".":U +
                                                         fld_U._NAME + ",":U.
              ELSE
                ASSIGN exclude-fields = exclude-fields + fld_U._NAME + ",":U.
            END.
            /* special case is when the table is ? but the subtype is a smart
             * data field. We need to go and get the actual field name so we exclude
             * it from the list too.
             */
            ELSE IF fld_U._subtype = "SmartDataField":U THEN DO:
              FIND x_S WHERE RECID(x_S) = fld_U._x-recid. 
              cFieldName = dynamic-function('getFieldName' IN X_S._HANDLE).
              ASSIGN exclude-fields = exclude-fields + cFieldName + ',' NO-ERROR.
            END. /* end else if subtype*/
            ELSE IF fld_U._TABLE <> "" AND fld_U._TABLE <> ? THEN
                ASSIGN exclude-fields = exclude-fields + fld_U._TABLE + ".":U + fld_U._NAME + ",".
        END. /* end for each */
     ASSIGN exclude-fields = TRIM(exclude-fields, ',') NO-ERROR.   
    END. /* end if avail */
   
    RUN adecomm/_mfldsel.p
        (INPUT tbl_list, INPUT p_hDataObject , INPUT tt-info, show_items, ",", 
         INPUT exclude-fields, INPUT-OUTPUT _fld_names).
    RUN adecomm/_setcurs.p ("":U).
    num_ent = NUM-ENTRIES(_fld_names).
  END.
  IF AVAILABLE _P THEN
    ret-msg = DYNAMIC-FUNCTION("shutdown-proc" IN _h_func_lib, INPUT _P._data-object).
END PROCEDURE.


