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

File: _calcfld.p

Description:
    Visual expression builder, called as a function

Input Parameters:
   pCurrentDB           The currently selected database logical name
                        (If we are building an SDO, this is the Recid of
                         the QUERY so we can pass it through to other
                         procedures to access the _BC records.)
   pCurrentThisTbl      The currently selected Table
   pSelectedTables      A list of selected (not available Tables)
   pInputExpression     The selected calculated field, if appropriate

Output Parameters:
   pOutputExpression     returns the calculated expression
   pErrorStatus          return syntax error status
   pOk                   to see whether the user OKed 
   
Author:   Robert Ryan

Date Created: Feb 17, 1994
Modified: SLK 03/31/98 Handle SmartData
          tsm 04/05/99 Changed setting of session:numeric-format back to use
                       set-numeric-format method to handle Intl formats
                       other than just American and European

----------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&Scoped-define WINDOW-NAME    DIALOG-1
&Scoped-define FRAME-NAME     DIALOG-1

DEFINE INPUT  PARAMETER pCurrentDB        AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER pCurrentTable     AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER phSmartData       AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER pSelectedTables   AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER pInputExpression  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER application       AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER this-is-a-SB      AS LOGICAL       NO-UNDO.
DEFINE INPUT  PARAMETER this-is-a-SDO     AS LOGICAL       NO-UNDO.
DEFINE INPUT  PARAMETER pTT               AS CHARACTER     NO-UNDO.
DEFINE OUTPUT PARAMETER pOutputExpression AS CHARACTER     NO-UNDO.
DEFINE OUTPUT PARAMETER pErrorStatus      AS LOGICAL       NO-UNDO.
DEFINE OUTPUT PARAMETER pOK               AS LOGICAL       NO-UNDO.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF VAR cQueryRec       AS CHAR    NO-UNDO.
DEF VAR CHOOSE-STATE    AS INTEGER NO-UNDO.
DEF VAR Insert-Value    AS CHAR    NO-UNDO.
DEF VAR Stat            AS LOGICAL NO-UNDO.
DEF VAR Result          AS LOGICAL NO-UNDO.
DEF VAR i               AS INTEGER NO-UNDO.
DEF VAR TempString      AS CHAR    NO-UNDO.
DEF VAR TempLen         AS INTEGER NO-UNDO.
DEF VAR CurrentDB       AS CHAR    NO-UNDO.
DEF VAR CurrentDBDir    AS CHAR    NO-UNDO.
DEF VAR TempDB          AS CHAR    NO-UNDO.
DEF NEW SHARED STREAM P_4GL.

&IF LOOKUP(OPSYS, "MSDOS,WIN32":u) = 0
&THEN
      &Scoped-define OS-HT       1.17
      &Scoped-define FUNC-HT     5.10
      &Scoped-define FLDS-HT     3.00  
      &Scoped-define FLDS-ROW    9.05 
      &Scoped-define FLDS-TXT    8.13 
      &Scoped-define PASTE-ARGS 12.15
      
&ELSE 
      &Scoped-define OS-HT       1.00
      &Scoped-define FUNC-HT     5.15 
      &Scoped-define FLDS-HT     3.95 
      &Scoped-define FLDS-ROW    8.90 
      &Scoped-define FLDS-TXT    8.03 
      &Scoped-define PASTE-ARGS 12.20
&ENDIF    

/*
** include sharvars for the variable _suppress_DBname
*/
{adeuib/sharvars.i}
{adecomm/adefext.i}

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnInsert 
     LABEL "&Insert":L 
     SIZE 15 BY {&OS-HT}.

DEFINE BUTTON BtnSyntax 
     LABEL "Check &Syntax":L 
     SIZE 15 BY {&OS-HT}.

DEFINE VARIABLE EditorBox AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL 
     SIZE 70.33 BY 3.28 NO-UNDO.

DEFINE VARIABLE FieldsList AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 28 BY {&FLDS-HT} NO-UNDO.

DEFINE VARIABLE FunctionBox AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SORT SCROLLBAR-VERTICAL 
     LIST-ITEMS "ABSOLUTE (num)","ACCUM  (str)","ASC  (str)","BEGINS",~
"CAN-DO (idlist, str)","CAPS (str)","CHR (int)","CONTAINS","DATE (month, day, year)",~
"DAY (date)","DECIMAL (num)","ENCODE (str)","ENTRY (element, list, char)",~
"ETIME (logical)","EXP (base, exponent)","FILL (str, repeats)","GET-BYTE (str, pos)",~
"GET-DOUBLE (str, pos)","GET-FLOAT (str, pos)","GET-LONG (str, pos)",~
"GET-POINTER-VALUE (str)","GET-SHORT (str, pos)","GET-SIZE (str)",~
"GET-STRING (str, pos)","IF (condition) THEN (expr) ELSE (expr)",~
"INDEX (source, target, starting)","INTEGER (num)","LC (str)","LEFT-TRIM (str, chars)",~
"LENGTH (str)","LIKE","LOG (decimal, base)","LOOKUP (str, list, char)","MATCHES",~
"MAXIMUM (str1, str2)","MINIMUM (str1, str2)","MODULO","MONTH (date)","NUM-ENTRIES ()",~
"OPSYS","R-INDEX (source, target, starting)","RANDOM (low, high)","RECID (record)",~
"REPLACE (source, from, to)","RIGHT-TRIM (str, chars)","ROUND (str, precision)",~
"SQRT (str)","STRING (source, format)","SUBSTITUTE (str, str)",~
"SUBSTRING (source, pos, length)","TIME","TODAY","TRIM (str, chars)",~
"TRUNCATE (str, precision)","USERID (dbname)","WEEKDAY (date)","YEAR (date)" 
     SIZE 28 BY {&FUNC-HT} NO-UNDO.

DEFINE BUTTON LogicalAND 
     LABEL "and":U 
     SIZE 7.5 BY 1.28.

DEFINE BUTTON LogicalNO 
     LABEL "no":U 
     SIZE 4.5 BY 1.28.

DEFINE BUTTON LogicalNOT 
     LABEL "not":U 
     SIZE 7.5 BY 1.28.

DEFINE BUTTON LogicalOR 
     LABEL "or":U 
     SIZE 8 BY 1.28.

DEFINE BUTTON LogicalYES 
     LABEL "yes":U 
     SIZE 4.5 BY 1.28.

DEFINE BUTTON OperatorADD 
     LABEL "+":U 
     SIZE 4.5 BY 1.28.

DEFINE BUTTON OperatorBRACKETS 
     LABEL "[ ]":U 
     SIZE 4.5 BY 1.28.

DEFINE BUTTON OperatorDIV 
     LABEL "/":U 
     SIZE 4.5 BY 1.28.

DEFINE BUTTON OperatorEQ 
     LABEL "=":U 
     SIZE 4.5 BY 1.28.

DEFINE BUTTON OperatorGE 
     LABEL ">=":U 
     SIZE 4.5 BY 1.28.

DEFINE BUTTON OperatorGT 
     LABEL ">":U 
     SIZE 4.5 BY 1.28.

DEFINE BUTTON OperatorLE 
     LABEL "<=":U 
     SIZE 4.5 BY 1.28.

DEFINE BUTTON OperatorLT 
     LABEL "<":U 
     SIZE 4.5 BY 1.28.

DEFINE BUTTON OperatorMULT 
     LABEL "*":U 
     SIZE 4.5 BY 1.28.

DEFINE BUTTON OperatorNE 
     LABEL "<>":U 
     SIZE 4.5 BY 1.28.

DEFINE BUTTON OperatorPARENS 
     LABEL "( )":U 
     SIZE 4.5 BY 1.28.

DEFINE BUTTON OperatorQUOTES 
     LABEL "~" ~"":U 
     SIZE 4.5 BY 1.28.

DEFINE BUTTON OperatorSUB 
     LABEL "-":U 
     SIZE 4.5 BY 1.28.

DEFINE VARIABLE PasteArgs AS Logical  LABEL "&Paste Function Arguments"
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 NO-FILL 
     SIZE 26.83 BY 6.10
     BGCOLOR 7 FGCOLOR 7 .
     
DEFINE VARIABLE TablesCombo AS CHARACTER FORMAT "X(240)" 
     VIEW-AS COMBO-BOX SORT  
     LIST-ITEMS ""  INNER-LINES 5
     SIZE 28 BY .85 NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     "Expression:" VIEW-AS TEXT
          SIZE 69.67 BY .92 AT ROW 1.52 COL 2.67
     EditorBox AT ROW 2.44 COL 2.67 NO-LABEL
     BtnSyntax AT ROW 2.44 COL 74.17 NO-LABEL
     BtnInsert AT ROW 4.72 COL 74.17 NO-LABEL
     " Operators:" VIEW-AS TEXT
          SIZE 10.58 BY .82 AT ROW 6.13 COL 62
     "Tables:" VIEW-AS TEXT
          SIZE 28 BY .92 AT ROW 6.08 COL 2.67
     "Fields:" VIEW-AS TEXT
          SIZE 28 BY .92 AT ROW {&FLDS-TXT} COL 2.67
     "Functions:" VIEW-AS TEXT
          SIZE 28 BY .92 AT ROW 6.08 COL 32.67
     RECT-1 AT ROW 6.95 COL 61.75
     OperatorEQ AT ROW 7.55 COL 63.83 NO-LABEL
     OperatorNE AT ROW 7.55 COL 68.5 NO-LABEL
     OperatorADD AT ROW 7.55 COL 73 NO-LABEL
     OperatorDIV AT ROW 7.55 COL 77.5 NO-LABEL
     OperatorBRACKETS AT ROW 7.55 COL 82.17 NO-LABEL
     TablesCombo AT ROW 6.95 COL 2.67 NO-LABEL
     FieldsList AT ROW {&FLDS-ROW} COL 2.67 NO-LABEL
     FunctionBox AT ROW 6.95 COL 32.67 NO-LABEL
     OperatorLT AT ROW 8.83 COL 63.83 NO-LABEL
     OperatorGT AT ROW 8.83 COL 68.5 NO-LABEL
     OperatorSUB AT ROW 8.83 COL 73 NO-LABEL
     OperatorQUOTES AT ROW 8.83 COL 77.5 NO-LABEL
     OperatorPARENS AT ROW 8.83 COL 82.17 NO-LABEL
     OperatorLE AT ROW 10.07 COL 63.83 NO-LABEL
     OperatorGE AT ROW 10.07 COL 68.5 NO-LABEL
     OperatorMULT AT ROW 10.07 COL 73 NO-LABEL
     LogicalYES AT ROW 10.07 COL 77.5 NO-LABEL
     LogicalNO AT ROW 10.07 COL 82.17 NO-LABEL
     LogicalAND AT ROW 11.31 COL 63.83 NO-LABEL
     LogicalOR AT ROW 11.31 COL 71.33 NO-LABEL
     LogicalNOT AT ROW 11.31 COL 79.33 NO-LABEL
     PasteArgs AT ROW {&PASTE-ARGS} COL 32.67
    WITH VIEW-AS DIALOG-BOX SIDE-LABELS 
         SIZE 89.83 BY 11.52 THREE-D
         TITLE "Calculated Field Editor":C30.
      
    /*
    ** Make certain that <CR> is treated like a return and not the default key
    */   
    EditorBox:RETURN-INSERTED = True.
IF application = "{&UIB_SHORT_NAME}":U THEN stat = FunctionBox:DELETE(2).

&Scoped-define FIELDS-IN-QUERY-DIALOG-1 
 
/* Custom List Definitions                                              */
&Scoped-define LIST-1 
&Scoped-define LIST-2 
&Scoped-define LIST-3 

/* Include Sullivan Bar standards                                       */
{ adecomm/commeng.i }
{ adecomm/okbar.i &TOOL = "COMM" &CONTEXT = {&Calc_Field_Dlg_Box} }

/* ************************  Control Triggers  ************************ */

ON CHOOSE OF BtnInsert IN FRAME DIALOG-1 /* Insert */
  Run PasteValue.

ON CHOOSE OF btn_OK IN FRAME DIALOG-1
  pOK = True.

ON CHOOSE OF BtnSyntax IN FRAME DIALOG-1 DO: /* Syntax check */
  IF EditorBox:SCREEN-VALUE = "" THEN 
     MESSAGE "You must create an expression before checking syntax." 
       VIEW-AS ALERT-BOX WARNING.
   ELSE 
     RUN CheckSyntax (INPUT True).
END.

ON HELP OF EditorBox IN FRAME DIALOG-1
 RUN adecomm/_adehelp.p ("lgrf":U,"PARTIAL-KEY":U,?,TRIM(SELF:SELECTION-TEXT)). 

ON VALUE-CHANGED OF FieldsList IN FRAME DIALOG-1
  RUN CopyFieldValue.

ON DEFAULT-ACTION OF FieldsList IN FRAME DIALOG-1
  APPLY "CHOOSE" TO BtnInsert IN FRAME {&FRAME-NAME}.

ON DEFAULT-ACTION OF FunctionBox IN FRAME DIALOG-1
  APPLY "CHOOSE":U TO BtnInsert IN FRAME {&FRAME-NAME}.

ON HELP OF FunctionBox IN FRAME DIALOG-1
  RUN adecomm/_adehelp.p ("lgrf":U,"PARTIAL-KEY":U,?,TRIM(SELF:SCREEN-VALUE)). 

ON VALUE-CHANGED OF FunctionBox IN FRAME DIALOG-1
  RUN CopyFunctionValue.

ON CHOOSE OF LogicalAND IN FRAME DIALOG-1 /* and */
  RUN CopyOperatorValue.

ON CHOOSE OF LogicalNO IN FRAME DIALOG-1 /* no */
  RUN CopyOperatorValue.

ON CHOOSE OF LogicalNOT IN FRAME DIALOG-1 /* not */
  RUN CopyOperatorValue.

ON CHOOSE OF LogicalOR IN FRAME DIALOG-1 /* or */
  RUN CopyOperatorValue.

ON CHOOSE OF LogicalYES IN FRAME DIALOG-1 /* yes */
  RUN CopyOperatorValue.

ON CHOOSE OF OperatorADD IN FRAME DIALOG-1 /* + */
  RUN CopyOperatorValue.

ON CHOOSE OF OperatorBRACKETS IN FRAME DIALOG-1 /* [ ] */
  RUN CopyOperatorValue.

ON CHOOSE OF OperatorDIV IN FRAME DIALOG-1 /* / */
  RUN CopyOperatorValue.

ON CHOOSE OF OperatorEQ IN FRAME DIALOG-1 /* = */
  RUN CopyOperatorValue.

ON CHOOSE OF OperatorGE IN FRAME DIALOG-1 /* >= */
  RUN CopyOperatorValue.

ON CHOOSE OF OperatorGT IN FRAME DIALOG-1 /* > */
  RUN CopyOperatorValue.

ON CHOOSE OF OperatorLE IN FRAME DIALOG-1 /* <= */
  RUN CopyOperatorValue.

ON CHOOSE OF OperatorLT IN FRAME DIALOG-1 /* < */
  RUN CopyOperatorValue.

ON CHOOSE OF OperatorMULT IN FRAME DIALOG-1 /* * */
  RUN CopyOperatorValue.

ON CHOOSE OF OperatorNE IN FRAME DIALOG-1 /* <> */
  RUN CopyOperatorValue.

ON CHOOSE OF OperatorPARENS IN FRAME DIALOG-1 /* ( ) */
  RUN CopyOperatorValue.

ON CHOOSE OF OperatorQUOTES IN FRAME DIALOG-1 /* " " */
  RUN CopyOperatorValue.

ON CHOOSE OF OperatorSUB IN FRAME DIALOG-1 /* - */
  RUN CopyOperatorValue.

ON VALUE-CHANGED OF TablesCombo IN FRAME DIALOG-1 
  RUN PopulateFields.

/* ***************************  Main Block  *************************** */
IF CURRENT-WINDOW:WINDOW-STATE = WINDOW-MINIMIZED 
   THEN CURRENT-WINDOW:WINDOW-STATE = WINDOW-NORMAL.

/* Restore the current-window if it is an icon.                         */
/* Otherwise the dialog box will be hidden                              */

IF CURRENT-WINDOW:WINDOW-STATE = WINDOW-MINIMIZED 
THEN CURRENT-WINDOW:WINDOW-STATE = WINDOW-NORMAL.

/* Set initial values and screen conditions */
ASSIGN 
  pOK                       = False
  PasteArgs:SCREEN-VALUE    = "no"
  TempString                = if pInputExpression = ? then "" 
                                 else TRIM(pInputExpression)
  EditorBox:SCREEN-VALUE    = TempString
  FunctionBox:SCREEN-VALUE  = FunctionBox:ENTRY(1)
  CurrentDB                 = pCurrentDB.
IF this-is-a-SDO THEN /* This is a calculated field for a SDO */
  cQueryRec = pCurrentDB.
   
/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} 
  APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
RUN PopulateTables.
RUN PopulateFields.
RUN enable_UI.

RETRY-BLOCK:
DO ON ERROR UNDO, RETRY:
  WAIT-FOR GO OF FRAME {&FRAME-NAME} FOCUS EditorBox.

  IF pOK THEN DO:
    ASSIGN pOutputExpression = TRIM(EditorBox:SCREEN-VALUE).
    IF this-is-a-SB THEN DO:  /* Make sure calculated fields have @ */
      TempString = TRIM(REPLACE(pOutputExpression,CHR(10)," ":U)).
      IF LOOKUP("@":U,TempString," ":U) = 0 THEN DO:
        MESSAGE 'Calculated fields in SmartBrowsers must be named fields.'
                'This is achieved by specifying "@ <field-name>" after the'
                'calculated field expression. "<field-name>" is a variable'
                'of the correct data-type defined elsewhere (usually in the'
                ' Definition Section) in the same SmartBrowser.' SKIP (1)
                'If you haven~'t already defined a field-name, you will'
                'receive an unknown field message when you "OK" this'
                'dialog, but your calculated field will be preserved.'
              VIEW-AS ALERT-BOX ERROR.
        pOK = FALSE.
        UNDO RETRY-BLOCK, RETRY RETRY-BLOCK.
      END. /* IF NO @ for SB */    
    END. /* IF working on a SmartBrowser */
    ELSE IF this-is-a-SDO THEN /* Make sure SmartDataObject calculated fields do NOT have @ */
    DO:
      TempString = TRIM(REPLACE(pOutputExpression,CHR(10)," ":U)).
      IF LOOKUP("@":U,TempString," ":U) <> 0 THEN
      DO:
        MESSAGE 'Calculated fields in SmartDataObjects are named automatically.'                SKIP
                'You can not specify " @ <field-name>" after the'
                'calculated field expression.'
              VIEW-AS ALERT-BOX ERROR.
        pOK = FALSE.
        UNDO RETRY-BLOCK, RETRY RETRY-BLOCK.
      END. /* IF @ for SmartDataObject */
    END. /* IF working on a SmartDataObject */
  END. /* IF pOK */
  RUN CheckSyntax (INPUT False).
END.  /* RETRY-BLOCK */

RUN disable_UI.

/* **********************  Internal Procedures  *********************** */
PROCEDURE CheckSyntax :        
  DO WITH FRAME {&frame-name}:
    DEF INPUT PARAMETER pCheck AS LOGICAL NO-UNDO.
    DEF VAR TempString         AS CHAR    NO-UNDO.
    DEF VAR StreamLength       AS INT     NO-UNDO.
    DEF VAR StreamDiff         AS INT     NO-UNDO. 
    DEF VAR ThisTbl            AS CHAR    NO-UNDO.
    DEF VAR ThisDB             AS CHAR    NO-UNDO.
  
    TempString = "".
    RUN adecomm/_setcurs.p ("WAIT":U).
    IF _comp_temp_file = ? THEN
      RUN adecomm/_tmpfile.p ({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB},OUTPUT _comp_temp_file).
    OUTPUT STREAM P_4GL TO VALUE(_comp_temp_file) NO-ECHO.
    ASSIGN SESSION:NUMERIC-FORMAT = "AMERICAN":U.
    
    RUN adeuib/_writedf.p .

    /* Now write out RowObject Temp-table definition if building an SDO */
    IF this-is-a-SDO THEN RUN adeuib/_wrrott.p (cQueryRec).

    i = 0.
    DO i = 1 TO NUM-ENTRIES(TablesCombo:LIST-ITEMS): 
       ASSIGN  
         ThisTbl    = ENTRY(i,TablesCombo:LIST-ITEMS)   
         ThisDB     = IF NUM-ENTRIES(ThisTbl,".":u) > 1 THEN 
                        ENTRY(1,ThisTbl,".":u)
                      ELSE CurrentDB
         ThisTbl    = IF NUM-ENTRIES(ThisTbl,".":u) > 1 THEN 
                        ENTRY(2,ThisTbl,".":u)
                      ELSE ThisTbl.
         IF VALID-HANDLE(phSmartData) THEN
            ASSIGN TempString = TempString + "FIND FIRST " 
                    + ThisTbl + ".":u + CHR(10).
         ELSE IF this-is-a-SDO THEN
             ASSIGN TempString = TempString + "FIND FIRST " + ThisTbl + ".":u + CHR(10).
         ELSE
            ASSIGN TempString = TempString + "FIND FIRST " + 
                    (IF ThisDB NE "Temp-Tables":U THEN ThisDB + ".":u ELSE "":u) 
                    + ThisTbl + ".":u + CHR(10).
    END.
 
    TempString = TempString
               + "DISPLAY "
               + TRIM(REPLACE(EditorBox:SCREEN-VALUE,CHR(10)," "))
               + ".":U.
    PUT STREAM P_4GL UNFORMATTED TempString.
    StreamLength = SEEK (P_4GL).
    OUTPUT STREAM P_4GL CLOSE. 
 
    /*  Need to set session numeric format back to user's setting after setting 
        it to American above  */
    SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
    
    COMPILE VALUE(_comp_temp_file) NO-ERROR.
    IF NOT COMPILER:ERROR THEN DO:
      /*
      ** Only report a valid syntax message if pCheck is True 
      */
      IF pCheck THEN MESSAGE "Syntax is correct." VIEW-AS ALERT-BOX INFORMATION.
      pErrorStatus = True.
    END.
    ELSE DO:
      StreamDiff = StreamLength - INTEGER(COMPILER:FILE-OFFSET).
      MESSAGE error-status:get-message(1) SKIP "in column" StreamDiff "." VIEW-AS ALERT-BOX ERROR.
      ASSIGN pErrorStatus = FALSE.
    END.
  
    OS-DELETE VALUE(_comp_temp_file).  
    RUN adecomm/_setcurs.p ("":U).
  END.
END PROCEDURE.

PROCEDURE CopyFieldValue :
  DO WITH FRAME {&FRAME-NAME}:
    IF VALID-HANDLE(phSmartData) THEN
       insert-value = SELF:SCREEN-VALUE.
    ELSE IF NOT _suppress_DBname THEN DO:
      /*
      ** We do want the database name but first we need to make sure we
      ** don't redundantly qualify the Table
      */
      IF NUM-ENTRIES(TablesCombo:SCREEN-VALUE,".":U) > 1 THEN
        insert-value = TablesCombo:SCREEN-VALUE + ".":U + SELF:SCREEN-VALUE.
      ELSE
        insert-value = (IF NOT CAN-DO(_tt_log_name, CurrentDB) AND 
                           TablesCombo:SCREEN-VALUE NE "RowObject":U
                           THEN CurrentDB + ".":U ELSE "")
                          + TablesCombo:SCREEN-VALUE + ".":U + SELF:SCREEN-VALUE.
     END.
     ELSE DO:  
       /* 
       ** We do NOT want the database name, but first we need to insure
       ** that it isn't already part of the Tables list.
       */
       IF NUM-ENTRIES(TablesCombo:SCREEN-VALUE,".":U) > 1 THEN
          insert-value = ENTRY(2,TablesCombo:SCREEN-VALUE,".":U) + ".":U 
                       + SELF:SCREEN-VALUE.
       ELSE
          insert-value = TablesCombo:SCREEN-VALUE + ".":U + SELF:SCREEN-VALUE.
     END.
   END.
END PROCEDURE.

PROCEDURE CopyFunctionValue :
 DEFINE VARIABLE StrParms AS CHARACTER.
  
  DO WITH FRAME {&FRAME-NAME}:
     IF INDEX(FunctionBox:SCREEN-VALUE, "(" ) = 0 OR PasteArgs:CHECKED
     THEN DO:
         /* Case 1: take the function (including args) as is */
         Insert-Value = " " + FunctionBox:SCREEN-VALUE + " ".
         RETURN.
     END.             
     
     ELSE IF SUBSTRING(FunctionBox:SCREEN-VALUE,1,3,"CHARACTER":u) = "IF ":U 
     THEN DO:
       Insert-Value = " IF () THEN () ELSE ()":U.
       RETURN.
     END.
   
     ELSE DO:
         /* Case 2: Strip out the function arguments retaining only the 
            placeholders, parens */
         IF NUM-ENTRIES(FunctionBox:SCREEN-VALUE,",":U) - 1 > 0 THEN DO:
            DO i = 1 TO NUM-ENTRIES(FunctionBox:SCREEN-VALUE,",") - 1:
              StrParms = StrParms + ",".
            END.
        END.
        /* Now assemble the base function with the commas which represent 
           parms */
        Insert-Value = " "
                     + SUBSTRING(FunctionBox:SCREEN-VALUE,1,
                         INDEX(FunctionBox:SCREEN-VALUE,"(":u),"CHARACTER":u) 
                     + StrParms + ") ":u.
    END.
  END.   
END PROCEDURE.

PROCEDURE CopyOperatorValue :
  IF insert-value = " " + CAPS(SELF:LABEL) + " " THEN
    ASSIGN choose-state = IF choose-state = 1 THEN 2 ELSE 1.
    
  ELSE
    ASSIGN choose-state = 1
           insert-value = " " + CAPS(SELF:LABEL) + " ".

  IF choose-state = 1 THEN RUN PasteValue.
END PROCEDURE.

PROCEDURE disable_UI :
  HIDE FRAME DIALOG-1.
END PROCEDURE.

PROCEDURE enable_UI :
  IF NOT VALID-HANDLE(phSmartData) THEN ENABLE TablesCombo WITH FRAME DIALOG-1.
  ENABLE 
        EditorBox BtnSyntax BtnInsert RECT-1 FieldsList
        FunctionBox PasteArgs OperatorEQ OperatorNE OperatorADD
        OperatorDIV OperatorBRACKETS OperatorLT OperatorGT OperatorSUB 
        OperatorQUOTES OperatorPARENS OperatorLE OperatorGE OperatorMULT
        LogicalYES LogicalNO LogicalAND LogicalOR LogicalNOT 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}

END PROCEDURE.

PROCEDURE PasteValue :
  IF EditorBox:TEXT-SELECTED IN FRAME {&FRAME-NAME} THEN
    Stat = EditorBox:REPLACE-SELECTION-TEXT(Insert-Value) in FRAME {&FRAME-NAME}.
  ELSE
    Stat = EditorBox:INSERT-STRING(Insert-Value) in FRAME {&FRAME-NAME}.
END PROCEDURE.

PROCEDURE PopulateFields:
  DO WITH FRAME {&FRAME-NAME}:
    FieldsList:LIST-ITEMS = "".
    
    IF VALID-HANDLE(phSmartData) THEN 
      RUN adecomm/_getdlst.p (
          FieldsList:HANDLE in frame {&FRAME-NAME},
          phSmartData,
          yes,
          1,
          ?,
          OUTPUT Stat).
    ELSE IF this-is-a-SDO THEN  /* A calculated field for an SDO */
      RUN adeuib/_roflds.p(FieldsList:HANDLE IN FRAME {&FRAME-NAME},
                           cQueryRec,   /* Query Recid in character form */
                           OUTPUT Stat).
    ELSE
      RUN adecomm/_mfldlst.p (FieldsList:HANDLE in frame {&FRAME-NAME},
                              TablesCombo:SCREEN-VALUE,
                              pTT,
                              yes,
                              "",
                              2,
                              "",
                              OUTPUT Stat).
    IF Stat THEN 
       FieldsList:SCREEN-VALUE = FieldsList:ENTRY(1).
    ELSE
       MESSAGE "Schema Error: Fields cannot be read from " TRIM(TablesCombo:SCREEN-VALUE) "." 
         VIEW-AS ALERT-BOX ERROR.
  END.
END PROCEDURE.

PROCEDURE PopulateTables:   
  DO WITH FRAME {&FRAME-NAME}:
    /*
    RUN adecomm/_tbllist.p (TablesCombo:HANDLE in frame {&FRAME-NAME},
                            NO,pDB-RECID,"",OUTPUT Stat). 
    */                     
    TablesCombo:list-items = pSelectedTables.
    IF pCurrentTable = "" THEN
       TablesCombo:SCREEN-VALUE = TablesCombo:ENTRY(1).
    ELSE
       TablesCombo:SCREEN-VALUE = pCurrentTable.
  END.   
END PROCEDURE.

&UNDEFINE FRAME-NAME 
&UNDEFINE WINDOW-NAME

/* _calcfld.p - end of file */

