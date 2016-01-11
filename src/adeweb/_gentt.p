/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _gentt.p

Description: Create an iternal AB temp-table to contain a list of unmapped 
   fields.  

Input Parameters:
   p_procId
                
Output Parameters:
   <None>

Author: D.M.Adams

Date Created: April, 1998
Updated: H. Danielsen . Don't generate ab_unmap for user defined fields.
         04/26/01 jep   IZ 993 - Check Syntax support for local WebSpeed V2 files.
                        Check for _TT and changed _TT._ADDITIONAL_FIELDS
                        assignment to NO-ERROR.

---------------------------------------------------------------------------- */

{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/sharvars.i}     /* Shared variables                                  */
{adeuib/pre_proc.i}

DEFINE INPUT PARAMETER p_procID AS RECID     NO-UNDO.

DEFINE VARIABLE cFieldList      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFieldName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTmpString      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cWidgets        AS CHARACTER NO-UNDO.
DEFINE VARIABLE iMaxExtent      AS INTEGER   NO-UNDO.

DEFINE BUFFER  x_F FOR _F.
DEFINE BUFFER  x_U FOR _U.
DEFINE BUFFER xx_U FOR _U.

/* Find the procedure. */
FIND _P WHERE RECID(_P) = p_procId.

/* Find the temp-table that contains a list of unmapped fields. */
FIND _TT WHERE 
  _TT._p-RECID    eq p_procId AND
  _TT._NAME       eq "{&WS-TEMPTABLE}":U AND
  _TT._TABLE-TYPE eq "W":U NO-ERROR.
  
cWidgets = "COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,"
         + "TOGGLE-BOX,TEXT":U.

/* Build the list of unmapped fields.  We only expect one frame.  */
FOR EACH _U WHERE _U._WINDOW-HANDLE eq _P._WINDOW-HANDLE AND   _U._TYPE eq "FRAME":U:
  IF NOT CAN-FIND(FIRST x_U WHERE 
                    x_U._parent-recid eq RECID(_U) AND
                    x_U._STATUS       eq "NORMAL":U AND 
                    x_U._DBNAME       eq ? AND 
                    x_U._TABLE        eq ? AND
                   (x_U._DEFINED-BY   eq "tool":U or 
                    x_U._DEFINED-BY   eq "db")    AND
                    NOT x_U._NAME BEGINS "_LBL":U AND
                    CAN-DO(cWidgets,x_U._TYPE)) THEN DO:
    IF AVAILABLE _TT THEN DELETE _TT.
    RETURN.
  END.
  ELSE DO:
    IF NOT AVAILABLE _TT THEN DO:
      CREATE _TT.
      ASSIGN
        _TT._p-RECID    = p_procId
        _TT._NAME       = "{&WS-TEMPTABLE}":U
        _TT._TABLE-TYPE = "W":U
        _TT._UNDO-TYPE  = ?.
    END.

    ASSIGN _TT._ADDITIONAL_FIELDS = "".
  END.

  FOR EACH x_U WHERE 
    x_U._parent-recid eq RECID(_U) AND
    x_U._STATUS       eq "NORMAL":U AND
    x_U._DBNAME       eq ? AND
    x_U._TABLE        eq ? AND
    NOT x_U._NAME BEGINS "_LBL":U AND
    x_U._DEFINED-BY   ne "USER":U AND
    CAN-DO(cWidgets,x_U._TYPE) USE-INDEX _NAME,
    EACH _F WHERE RECID(_F) = x_U._x-recid:

    ASSIGN
      x_U._DBNAME = "Temp-Tables":U
      x_U._TABLE  = "{&WS-TEMPTABLE}":U
      x_U._BUFFER = "{&WS-TEMPTABLE}":U
      cFieldName  = IF _F._SUBSCRIPT = 0 THEN x_U._NAME ELSE
                      SUBSTRING(x_U._NAME,1,INDEX(x_U._NAME,"[":U) - 1,
                                "CHARACTER":U) 
      cFieldList  = cFieldList + (IF cFieldList <> "" THEN CHR(10) ELSE "") + 
                    "FIELD ":U + cFieldName + " AS ":U + CAPS(_F._DATA-TYPE) +
        (IF CAN-DO("FILL-IN,COMBO-BOX":U, x_U._TYPE) AND _F._FORMAT ne ? THEN
          (" FORMAT ~"":U + _F._FORMAT + "~"":U +
          (IF _F._FORMAT-ATTR NE "" AND _F._FORMAT-ATTR NE ?
           THEN ":":U + _F._FORMAT-ATTR ELSE "") + " ":U) ELSE " ":U).
           
    IF _F._INITIAL-DATA NE "" THEN 
    INITIAL-VALUE-BLK:
    DO:
      IF x_U._TYPE = "RADIO-SET":U AND _F._INITIAL-DATA = ? THEN
        LEAVE INITIAL-VALUE-BLK.
      cTmpString = IF _F._INITIAL-DATA = ? THEN "?":U ELSE _F._INITIAL-DATA.
        
      /* For logical fill-ins, determine if initial value is yes or no based 
         on format, i.e. for format "GUI/TTY" 'GUI' is not a legal initial 
         value, 'yes' is. */          
      IF CAN-DO("FILL-IN,COMBO-BOX":U, x_U._TYPE) AND 
        _F._DATA-TYPE = "logical":U THEN
        cTmpString = IF ENTRY(1,_F._FORMAT, "/":U) EQ _F._INITIAL-DATA 
                     THEN "YES":U ELSE "NO":U.
        
      /* Quote this if character datatype. */
      IF _F._DATA-TYPE eq "character":U THEN
        cTmpString = "~"":U + cTmpString + "~"":U.
          													 
      /* Note that this TRIM won't remove leading (or trailing) spaces on character 
         values because of the quotes added in the last line.  It only trims 
         non-character values for neatness. */
      ASSIGN cFieldList = cFieldList + " INITIAL ":U + TRIM(cTmpString).
    END. /* IF...INITIAL-DATA... */

    IF _F._SUBSCRIPT > 0 THEN DO:
      ASSIGN 
        cTmpString    = cFieldName + "[":U
        iMaxExtent    = _F._SUBSCRIPT
        _F._SUBSCRIPT = -1 * _F._SUBSCRIPT.
       
      FOR EACH xx_U WHERE xx_U._NAME BEGINS cTmpString AND xx_U._TYPE = x_U._TYPE,
        EACH x_F WHERE RECID(x_F) = xx_U._x-recid AND x_F._SUBSCRIPT > 0:
        ASSIGN 
          iMaxExtent     = MAXIMUM(iMaxExtent,x_F._SUBSCRIPT)
          x_F._SUBSCRIPT = -1 * x_F._SUBSCRIPT.
      END.

      ASSIGN cFieldList = cFieldList + " EXTENT " + STRING(iMaxExtent).
    END.
  END. /* FOR EACH x_U */
END. /* FOR EACH frame */

IF AVAILABLE _TT THEN
    ASSIGN _TT._ADDITIONAL_FIELDS = cFieldList NO-ERROR.

/* _gentt.p - end of file */

