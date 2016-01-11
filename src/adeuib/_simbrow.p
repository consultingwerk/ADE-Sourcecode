/************************************************************************
* Copyright (C) 2000,2005 by Progress Software Corporation.  All rights *
* reserved.  Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                              *
************************************************************************/
/*
File            : _simbrow.p
Description     : Simulates the contents of a browse widget in a editor container
Input Parms     : p_RECID_U, the recid of the current _U record
Output Parms    : none
Author          : re-written by R Ryan (from B Wood)
Last Modified   : 04/12/99  tsm  Added support for various Intl Numeric formats
                                 (in addition to American and European).  Changed
                                 call to adecomm/_convert.p to "A-TO-N" to convert
                                 from American format to non-American rather than
                                 "A-TO-E" (American to European).
                  2/24/94
*/

define input parameter p_recid_u as recid no-undo.
{adeuib/uniwidg.i}
{adeuib/brwscols.i}
{adeuib/triggers.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

&SCOPED-DEFINE MaxTbl 127
DEFINE VARIABLE empty-browse AS LOGICAL INITIAL TRUE       NO-UNDO.
DEFINE VARIABLE i            AS INTEGER INITIAL 1          NO-UNDO.
DEFINE VARIABLE j            AS INTEGER INITIAL 0          NO-UNDO.
DEFINE VARIABLE k            AS INTEGER INITIAL 0          NO-UNDO.
DEFINE VARIABLE MaxRows      AS INTEGER INITIAL 0          NO-UNDO.
DEFINE VARIABLE MaxTest      AS INTEGER INITIAL 0          NO-UNDO.
DEFINE VARIABLE MaxLength    AS INTEGER INITIAL 0          NO-UNDO.
DEFINE VARIABLE num-cols     AS INTEGER INITIAL 0          NO-UNDO.
DEFINE VARIABLE TokenLength  AS INTEGER INITIAL 0          NO-UNDO.
DEFINE VARIABLE FormatLength AS INTEGER INITIAL 0          NO-UNDO.
DEFINE VARIABLE DiffRows     AS INTEGER INITIAL 0          NO-UNDO.

DEFINE VARIABLE fd-tp        AS INTEGER                    NO-UNDO.
DEFINE VARIABLE lbl          AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE fmt          AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE isaSMO       AS LOGICAL                    NO-UNDO.
DEFINE VARIABLE pad          AS CHARACTER                  NO-UNDO.

DEFINE VARIABLE Simulation   AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE TitleString  AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE LabelString  AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE FormatStr    AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE LabelName    AS CHARACTER EXTENT {&MaxTbl} NO-UNDO.
DEFINE VARIABLE LabelType    AS INTEGER   EXTENT {&MaxTbl} NO-UNDO.
DEFINE VARIABLE ColumnWidth  AS INTEGER   EXTENT {&MaxTbl} NO-UNDO.
DEFINE VARIABLE FormatString AS CHARACTER EXTENT {&MaxTbl} NO-UNDO.

/****************************** Database finds *****************************/

find _U where RECID(_U) = p_recid_U.
find _L where RECID(_L) = _U._lo-recid.
find _C where RECID(_C) = _U._x-recid.
find _Q where RECID(_Q) = _C._q-recid.

/***************************** Main code block *****************************/

/* See if it is a freeform query */
FIND _TRG WHERE _TRG._wRECID = p_recid_U AND
                _TRG._tEVENT = "OPEN_QUERY":U NO-ERROR.
IF AVAILABLE _TRG THEN DO:            
  ASSIGN lbl         = "Freeform Browse " + _U._NAME 
         LabelString = FILL(" ", INTEGER((_L._WIDTH - 
                                   FONT-TABLE:GET-TEXT-WIDTH-CHARS(lbl,
                                      IF NOT _U._WIN-TYPE THEN 3 ELSE 2)) / 2 ) - 3) +
                       lbl + CHR(10) + CHR(10) + _TRG._tCODE + CHR(10).
  FIND _TRG WHERE _TRG._wRECID = p_recid_U AND _TRG._tEVENT = "DISPLAY":U.

  ASSIGN _U._HANDLE:FONT         = IF NOT _U._WIN-TYPE THEN 3 ELSE 2
         _U._HANDLE:SCREEN-VALUE = LabelString + CHR(10) + "DISPLAY" + CHR(10) +
                                   _TRG._tCODE.
  
  RETURN.
END.

/*
** Step 1 of 3: Pre-process data calculating various max lengths
*/
i = 1.
FOR EACH _BC WHERE _BC._x-recid = p_recid_U:
  run GetLabel.
  run GetFormat. 
  ASSIGN MaxLength    = 0
         empty-browse = FALSE. 
   
  /* 
  ** Now figure out what the max rows for a label is 
  */
  IF NOT _L._NO-LABELS THEN DO:
    MaxTest = num-entries(LabelName[i],"!").
    if MaxTest > MaxRows then  MaxRows = MaxTest.
 
    /*
    ** Now we know what the max rows are, figure out the max string length
    */
    do j = 1 to MaxTest:
      assign lbl         = entry(j,LabelName[i],"!")
             TokenLength = length(lbl).
     if TokenLength > MaxLength then MaxLength = TokenLength.
    end.
  END. /* IF the browser has labels */
  
  if MaxLength < FormatLength then MaxLength = FormatLength.
     
  assign ColumnWidth[i] = MaxLength
         FormatStr      = FormatStr + IF i > 1 THEN " " ELSE ""
         pad            = fill(" ", ColumnWidth[i] - length(FormatString[i]))
         FormatStr      = FormatStr + if LabelType[i] > 3 /* A Numeric type */
                           then pad + FormatString[i]
                           else FormatString[i] + pad
         i              = i + 1.
end. /* end i loop */
num-cols = i.
 
/*
** Step 2 of 3: Format the label tokens
*/
IF NOT _L._NO-LABELS THEN DO:
  do j = 1 to MaxRows:
    do i = 1 to num-cols: 
       /*
       ** First stick in a placeholder and separator for labels < maxrows
       */
       DiffRows = MaxRows - num-entries(LabelName[i],"!").
       If DiffRows > 0 then do k = 1 to DiffRows:
          LabelName[i] = " " + "!" + LabelName[i].
       end.
     
       /* 
       ** Now, start padding the label tokens
       */
       assign
         LabelString = LabelString + IF i > 1 THEN " " ELSE ""
         pad         = fill(" ", ColumnWidth[i] - length(entry(j,LabelName[i],"!")))
         LabelString = LabelString + if LabelType[i] > 3 
                       then pad + entry(j,LabelName[i],"!")
                       else entry(j,LabelName[i],"!") + pad.
    end. /* end i loop */
    LabelString = LabelString + CHR(10). 
  end. /* end j loop */
END. /* If the browser has labels */
ELSE LabelString = "".

/*
** Step 3 of 3: Collate the strings and ship it out
*/
if _C._TITLE then do:
  run adeuib/_strfmt.p (_U._LABEL, _U._LABEL-ATTR, FALSE, OUTPUT lbl).
  /*
  ** Center a title 
  */
  TitleString = FILL(" ",
                INTEGER((INTEGER(_L._WIDTH) - LENGTH(lbl)) / 2) - 2) +
                lbl + CHR(10) + FILL(".",INTEGER(_L._WIDTH) - 4).
end.

FIND _P WHERE _P._WINDOW-HANDLE = _U._WINDOW-HANDLE NO-ERROR.

/* Put out the Title, Labels, and Format strings.  If there are no fields (i.e.
   FormatStr = "") then put out a notice that the browse is empty. */
ASSIGN _U._HANDLE:FONT = IF NOT _U._WIN-TYPE THEN 3 ELSE 2
       Simulation      = IF empty-browse
                         THEN ("Empty Browse: Use Property Sheet to add Fields" +
                                IF _Q._TblList eq "" THEN  " & Query." ELSE "]" )      
                         ELSE ((IF _L._NO-LABELS THEN "" ELSE (LabelString + chr(10)))
                                + FormatStr).

RUN adeuib/_isa.p (INPUT INTEGER(RECID(_P)),
                   INPUT "SmartObject":U,
                   OUTPUT isaSMO).
IF isaSMO AND empty-browse THEN 
  ASSIGN Simulation = Simulation + CHR(10) +
                              "              Use Procedure Settings to modify"  + chr(10) +
                              "              External Tables (see Tools menu)." + chr(10).
ASSIGN _U._HANDLE:SCREEN-VALUE = (IF _C._TITLE THEN (TitleString + CHR(10)) ELSE "") + 
                                 Simulation.
/******************************* Procedures *******************************/
procedure GetFormat: 
  IF _BC._DBNAME = "_<CALC>":U then do:
    /* Because we don't know what type of expression it is, we have to make
       a very crude guess as to the type - 1 is char, 2 is date, 3 is logical
       4 is numeric, 34 is datetime, 40 is datetime-tz      */
    ASSIGN  LabelType[i] = IF _BC._DATA-TYPE = "CHARACTER":U OR
                              index(_BC._FORMAT,"(":U) > 0  OR
                              index(_BC._FORMAT,"!":U) > 0  OR
                              _BC._FORMAT = "999-99-9999"   OR
                              _BC._FORMAT = "999-9999" then 1
                           ELSE IF _BC._DATA-TYPE = "DATE":U OR
                                   SUBSTRING(_BC._FORMAT,1,8) = "99/99/99" OR
                                   SUBSTRING(_BC._FORMAT,1,8) = "99.99.99" OR
                                   SUBSTRING(_BC._FORMAT,1,8) = "99-99-99" THEN 2
                           ELSE IF _BC._DATA-TYPE = "DATETIME":U THEN 34
                           ELSE IF _BC._DATA-TYPE = "DATETIME-TZ":U THEN 40
                           ELSE IF _BC._DATA-TYPE = "LOGICAL":U OR
                                   INDEX(_BC._FORMAT,"YES":U) > 0  OR
                                   INDEX(_BC._FORMAT,"NO":U)  > 0  OR
                                   INDEX(_BC._FORMAT,"TRUE":U)  > 0  OR
                                   INDEX(_BC._FORMAT,"FALSE":U)  > 0 THEN 3
                           ELSE IF _BC._DATA-TYPE = "INT64":U THEN 41
                           ELSE 4
            FormatString[i] = _BC._FORMAT.
     RETURN.
   END.

   ASSIGN  /* type 1=char, 2=date, 34=datetime, 40=datetime-tz, 3=logical, 4=int */
           fd-tp           = IF _BC._DATA-TYPE = "CHARACTER":U THEN 1
                             ELSE IF _BC._DATA-TYPE = "DATE":U THEN 2
                             ELSE IF _BC._DATA-TYPE = "DATETIME":U THEN 34
                             ELSE IF _BC._DATA-TYPE = "DATETIME-TZ":U THEN 40
                             ELSE IF _BC._DATA-TYPE = "LOGICAL":U THEN 3
                             ELSE IF _BC._DATA-TYPE = "INTEGER":U THEN 4
                             ELSE IF _BC._DATA-TYPE = "INT64":U THEN 41
                             ELSE 5
           fmt             = _BC._FORMAT
           LabelType[i]    = fd-tp
           FormatString[i] = fmt
           FormatLength    = if fd-tp = 1 then length(string("A",fmt))
                             else if fd-tp = 2 then length(string(today,fmt))
                             else if fd-tp = 34 then length(string(NOW,fmt))
                             else if fd-tp = 40 then length(string(NOW,fmt))
                             else if fd-tp = 3 then max(length(string(YES,fmt)),
                                                    length(string(NO,fmt)))
                             else length(string(0,fmt)).

   IF (_numeric_separator NE "," OR _numeric_decimal NE ".") AND fd-tp > 3 THEN 
     RUN adecomm/_convert.p (INPUT "A-TO-N", INPUT FormatString[i],
                             INPUT _numeric_separator, INPUT _numeric_decimal,                          
                             OUTPUT FormatString[i]).
     
END PROCEDURE.      


procedure GetLabel:
  if _BC._LABEL = "" AND _BC._DBNAME NE "_<CALC>":U then do:
     run adecomm/_s-schem.p (_BC._DBNAME, _BC._TABLE, _BC._NAME,
                             "FIELD:LABEL", output lbl).
     LabelName[i] = lbl.
  end.
  else LabelName[i] = _BC._LABEL.
end procedure.
