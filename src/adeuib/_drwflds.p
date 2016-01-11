/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
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
using adeuib.ide._drawfields.
using adeuib.ide._selecttables.

DEFINE INPUT        PARAMETER flds_list     AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER drawn         AS LOGICAL NO-UNDO.
DEFINE OUTPUT       PARAMETER dbf_temp_file AS CHARACTER NO-UNDO.

{adeuib/sharvars.i}
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adecomm/adestds.i}
{adecomm/adeintl.i}
{adecomm/oeideservice.i}


DEFINE VAR pressed_ok      AS LOGICAL                       NO-UNDO.
DEFINE VAR dummy           AS LOGICAL                       NO-UNDO.
DEFINE VAR cSDOClobCols    AS CHARACTER                     NO-UNDO.
DEFINE VAR useDataObject   AS LOGICAL                       NO-UNDO.
define var hDataObject as handle no-undo.



/*DEFINE BUFFER x_L FOR _L.*/

DEFINE STREAM temp_file.

/* Select one table. */
ASSIGN dummy      =_h_win:LOAD-MOUSE-POINTER("")
       _fl_name   = "":U
       _fld_names = "":U.

FIND _U WHERE _U._HANDLE = _h_frame NO-ERROR.
FIND _P WHERE _P._WINDOW-HANDLE = _h_win.

useDataObject = (_P._DATA-OBJECT <> "").
IF useDataObject THEN
DO:  
    /* flds_list <> "" = called from wizard - no prompt -  no special treatment for OEIDEIsRunning */
    if not OEIDEIsRunning or (flds_list <> "") then
    do: 
       hDataObject = DYNAMIC-FUNC("get-sdo-hdl" IN _h_func_lib, INPUT _P._DATA-OBJECT,
                                                             INPUT TARGET-PROCEDURE).
       IF NOT VALID-HANDLE(hDataObject) THEN
       DO:
           MESSAGE "Unable to start data object " _P._DATA-OBJECT "."
                   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
           drawn = no.
           RETURN.
       END.
    end.
    RUN GetDataObjectFields(hDataObject).
   
END.  
ELSE
    RUN GetDBFields.
     /* we have requested childDialog command to continue from ide */

if OEIDEIsRunning and return-value = "IDE DRAW" then 
    return return-value.

IF _fld_names = "" OR _fld_names = ? THEN DO:
  /* Do Nothing -- we used to do give this error message which I did not take out:
  MESSAGE "There are no database fields selected."
       VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. 
  ------------------------------*/
END.
ELSE IF pressed_ok THEN
DO:
    if useDataObject then
         /* Clean up the running SDO */
         cSDOClobCols = DYNAMIC-FUNCTION("getCLOBColumns":U IN hDataObject).
    
    /*  _fld_names */
    RUN adeuib/_drwflds2.p(_db_name,_fl_name,_fld_names,useDataObject,cSDOClobCols,output dbf_temp_file).  
    drawn = true.
END.

if useDataObject and not OEIDEIsRunning then
    {fnarg shutdown-sdo target-procedure _h_func_lib}.
    
RETURN.
 
PROCEDURE GetDBFields.
  DEFINE VARIABLE exclude-fields AS CHAR NO-UNDO.
  DEFINE VAR tbl_list     AS CHARACTER                     NO-UNDO.
  DEFINE VAR tt-info      AS CHARACTER                     NO-UNDO.
  DEFINE VAR i            AS INTEGER                       NO-UNDO.
  DEFINE VAR num_ent         AS INTEGER                       NO-UNDO.
  define var ideSelect    as _selecttables       no-undo.
  DEFINE BUFFER x_U FOR _U.
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
  
  if OEIDEIsRunning then 
  do:
      ideSelect = new _selecttables().
      assign
          ideSelect:MultiSelect = TRUE
          ideSelect:TempTableInfo = tt-info
          ideSelect:DataBaseName = _db_name
          ideSelect:TableNames = _fl_name.
      ideSelect:SetCurrentEvent(_h_uib,"ide_select_tables_and_draw_fields").    
      run runChildDialog in hOEIDEService (ideSelect) .
      RETURN "IDE DRAW".              
  end.
  else  
      RUN adecomm/_tblsel.p
                    (true, 
                     tt-info,
                     INPUT-OUTPUT _db_name, 
                     INPUT-OUTPUT _fl_name,
                     OUTPUT pressed_ok).
   
      
  IF NOT pressed_ok THEN RETURN.
  ELSE IF _fl_name = "" OR _fl_name = ? THEN DO:
    MESSAGE "There are no database tables selected."
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    drawn = no.
    RETURN.
  END.
  
  run select_fields_for_table in _h_uib(tt-info,_db_name,_fl_name).
  
/*  ASSIGN num_ent  = NUM-ENTRIES(_fl_name)                                                */
/*         tbl_list = _fl_name.                                                            */
/*  IF num_ent > 0 THEN DO:                                                                */
/*    /* Get a list of "database.table,database.table" */                                  */
/*    DO i = 1 TO num_ent:                                                                 */
/*      ENTRY(i,tbl_list) = _db_name + "." + ENTRY(i,_fl_name).                            */
/*    END.                                                                                 */
/*                                                                                         */
/*    /* Build an exclude field list of those database fields already in                   */
/*       the object. Don't want them to display in the available fields list.              */
/*    */                                                                                   */
/*                                                                                         */
/*    IF AVAILABLE _U THEN                                                                 */
/*    DO:                                                                                  */
/*        FOR EACH x_U WHERE x_U._PARENT-Recid = RECID(_U)                                 */
/*                     AND   (IF x_u._TABLE = x_u._BUFFER                                  */
/*                            THEN CAN-DO(tbl_list,x_u._DBNAME + "." + x_U._TABLE)         */
/*                                                                                         */
/*                            /* if this is a buffer the 'temp-tables' in                  */
/*                               tbl-list cannot be used to compare x_u,                   */
/*                               so we compare only the buffername  */                     */
/*                            ELSE CAN-DO(REPLACE(tbl_list,"Temp-Tables.":U,"":U),         */
/*                                        x_u._BUFFER)                                     */
/*                           )                                                             */
/*                     AND   x_U._STATUS <> "DELETED":U NO-LOCK:                           */
/*            ASSIGN exclude-fields = exclude-fields + x_u._BUFFER + "." + x_U._NAME + ",".*/
/*        END.                                                                             */
/*        ASSIGN exclude-fields = TRIM(exclude-fields, ',') NO-ERROR.                      */
/*    END.                                                                                 */
/*    RUN adecomm/_mfldsel.p (INPUT tbl_list, INPUT ?, INPUT tt-info, "2", ",",            */
/*                            INPUT exclude-fields, INPUT-OUTPUT _fld_names).              */
/*                                                                                         */
/*    RUN adecomm/_setcurs.p ("":U).                                                       */
/*  END.*/
END PROCEDURE.

PROCEDURE GetDataObjectFields.
  
  define input  parameter p_hDataObject  as handle no-undo.
  define var drawfieldsservice as _drawfields       no-undo.
  DEFINE VARIABLE ret-msg           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE show_items        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE exclude-fields    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFieldName        AS CHARACTER NO-UNDO.
  DEFINE VAR i            AS INTEGER                       NO-UNDO.
  DEFINE VAR tbl_list     AS CHARACTER                     NO-UNDO.
  DEFINE VAR tt-info      AS CHARACTER                     NO-UNDO.
  DEFINE VAR num_ent         AS INTEGER                       NO-UNDO.
  DEFINE BUFFER fld_U FOR _U.
  DEFINE BUFFER X_S   FOR _S.

  /* When drawing a "DB-FIELDS" object for a procedure object that has a Data Object
     for its data source, set _db_name to "Temp-Tables". This is because AppBuilder
     support of data-object fields is through its temp-tables support. So force
     _db_name to be "Temp-Tables". */
  ASSIGN _db_name = "Temp-Tables":U.
  IF (flds_list <> "") THEN
  DO:
      ASSIGN  _fld_names   = flds_list
              num_ent     = NUM-ENTRIES(_fld_names)
              pressed_ok  = TRUE.

      RETURN.
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
            IF fld_U._TABLE > '' THEN
            DO:
              IF fld_U._BUFFER = "RowObject":U OR fld_U._TABLE = "RowObject":U THEN
                ASSIGN exclude-fields = exclude-fields + fld_U._NAME + ",":U.
              ELSE
                ASSIGN exclude-fields = exclude-fields + fld_U._TABLE + ".":U +
                                                         fld_U._NAME + ",":U.
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
        END. /* end for each */

     ASSIGN exclude-fields = TRIM(exclude-fields, ',') NO-ERROR.
    END. /* end if avail */
    if OEIDEIsRunning then
    do:
        drawfieldsservice = new _drawfields().
        assign
            drawfieldsservice:TableList = tbl_list
            drawfieldsservice:TempTableInfo = tt-info
            drawfieldsservice:Items =  show_items
            drawfieldsservice:Delimiter = ","
            drawfieldsservice:ExcludeFieldNames = exclude-fields
            drawfieldsservice:FieldNames = _fld_names.
        drawfieldsservice:SetCurrentEvent(_h_uib,"ide_select_and_draw_fields").    
        run runChildDialog in hOEIDEService (drawfieldsservice) .
        RETURN "IDE DRAW".
    end.
    else
   
        RUN adecomm/_mfldsel.p
                (tbl_list,p_hDataObject,tt-info, show_items,",",exclude-fields,
                 INPUT-OUTPUT _fld_names).

    RUN adecomm/_setcurs.p ("":U).
  END.
   
END PROCEDURE.