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
/*-----------------------------------------------------------------------------

  File: qurydefs.i

  Description: 
   This code provides the shared definitions forthe dialog box frame that 
   allows the developer to define the files and their query relationships.

  History: prior to Jan.94, this file was in adeuib/browqury.i
  
  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Greg O'Connor

  Created: 03/23/93 - 12:17 pm     
  
  Modified: 2/24/94 by RPR (Added cShareType, tIndexReposition, bCalcField)

-----------------------------------------------------------------------------*/
&GLOBAL-DEFINE Debug False

{ adecomm/adestds.i }
/* five main states of the query builder as returned by rsmain:SCREEN-VALUE */
&GLOBAL-DEFINE Table         1
&GLOBAL-DEFINE Join          2
&GLOBAL-DEFINE Where         3
&GLOBAL-DEFINE Sort          4
&GLOBAL-DEFINE Options       5
&GLOBAL-DEFINE Max-function  5

&GLOBAL-DEFINE Table-Mode    rsMain:SCREEN-VALUE = "{&Table}":U
&GLOBAL-DEFINE Join-Mode     rsMain:SCREEN-VALUE = "{&Join}":U
&GLOBAL-DEFINE Where-Mode    rsMain:SCREEN-VALUE = "{&Where}":U
&GLOBAL-DEFINE Sort-Mode     rsMain:SCREEN-VALUE = "{&Sort}":U
&GLOBAL-DEFINE Options-Mode  rsMain:SCREEN-VALUE = "{&Options}":U

&GLOBAL-DEFINE CurRight      whRight   [INTEGER (rsMain:SCREEN-VALUE)]
&GLOBAL-DEFINE TableRight    whRight   [{&Table}]
&GLOBAL-DEFINE CurLeft       whLeft    [INTEGER (rsMain:SCREEN-VALUE)]
&GLOBAL-DEFINE CurData       cMoreData [INTEGER (rsMain:SCREEN-VALUE)]
&GLOBAL-DEFINE CurSortData   cMoreData [{&Sort}]
&GLOBAL-DEFINE CurFieldData  cMoreData [{&Options}]
&GLOBAL-DEFINE CurTable      eCurrentTable
&GLOBAL-DEFINE DisFieldList  "<<Selected Fields>>"

/* Temp Table for WHERE builder */
DEFINE {1} SHARED TEMP-TABLE ttWhere NO-UNDO
  FIELD iState      AS INTEGER         /* Screen State */
  FIELD cTable      AS CHARACTER       /* Table Name */
  FIELD iSeq        AS INTEGER         /* sequence */
  FIELD cExpression AS CHARACTER  CASE-SENSITIVE  /* Expression */
  FIELD cLastField  AS CHARACTER       /* Where Last Field */
  FIELD iOffset     AS INTEGER         /* Display Offset */
  FIELD lOperator   AS LOGICAL         /* Operator State */
  FIELD lWhState    AS LOGICAL         /* Where Clause State */
  INDEX ttWhere-index IS PRIMARY UNIQUE iState cTable iSeq.

/* internal variables */
DEFINE {1} SHARED VARIABLE cOperator  AS CHARACTER NO-UNDO. /* comparison */
DEFINE {1} SHARED VARIABLE cLastField AS CHARACTER NO-UNDO. /* last field */
DEFINE {1} SHARED VARIABLE cValue     AS CHARACTER NO-UNDO. /* value */

/* DEFINE {1} SHAREDs and acWhereState are used to control the operators that
   are available in the WHERE builder. */
&GLOBAL-DEFINE bEqual        1
&GLOBAL-DEFINE bNotEqual     2
&GLOBAL-DEFINE bLess         3
&GLOBAL-DEFINE bGreater      4
&GLOBAL-DEFINE bLessEqual    5
&GLOBAL-DEFINE bGreaterEqual 6
&GLOBAL-DEFINE bBegins       7
&GLOBAL-DEFINE bMatches      8
&GLOBAL-DEFINE bContains     9
&GLOBAL-DEFINE bOr           10	
&GLOBAL-DEFINE bContainsQBF  11
&GLOBAL-DEFINE bRange        12
&GLOBAL-DEFINE bXRange       13	
&GLOBAL-DEFINE bList         14	
&GLOBAL-DEFINE bXList        15	
&GLOBAL-DEFINE bAnd          16	

&GLOBAL-DEFINE lEqual        "=" 
&GLOBAL-DEFINE lNotEqual     "<>" 
&GLOBAL-DEFINE lLess         "<" 
&GLOBAL-DEFINE lGreater      ">" 
&GLOBAL-DEFINE lLessEqual    "<=" 
&GLOBAL-DEFINE lGreaterEqual ">=" 
&GLOBAL-DEFINE lBegins       "&Begins" 
&GLOBAL-DEFINE lMatches      "&Matches" 
&GLOBAL-DEFINE lContains     "&Contains" 
&GLOBAL-DEFINE lContainsQBF  "&Contains (QBF)" 
&GLOBAL-DEFINE lRange        "Ran&ge" 
&GLOBAL-DEFINE lXRange       "X-Range" 	
&GLOBAL-DEFINE lList         "&List" 	
&GLOBAL-DEFINE lXList        "X-List" 	
&GLOBAL-DEFINE lAnd          "&AND"
&GLOBAL-DEFINE lOr           "O&R"

/*
Each string consists of three parts: control, expression and UI.
The control portion includes the following embedded codes:
  "o" = ask for a single value
  "r" = ask for an upper and a lower bound
  "u" = ask for value w/o using dictionary format string
  "q" = query by words
  "m" = ask for multiple values
  "1" .. "5" = datatypes allowed (none for QBW)
*/

DEFINE {1} SHARED VARIABLE acWhereState AS CHARACTER EXTENT 16 NO-UNDO
  INITIAL [/* &bEqual        */ "o12345,=":U,
           /* &bNotEqual     */ "o12345,<>":U,
           /* &bLess         */ "o1245,<":U,
           /* &bGreater      */ "o1245,>":U,
           /* &bLessEqual    */ "o1245,<=":U,
           /* &bGreaterEqual */ "o1245,>=":U,
           /* &bBegins       */ "u1,&Begins":U,
           /* &bMatches      */ "u1,&Matches":U,
           /* &bContains     */ "q,&Contains":U,
           /* &bOr           */ "3,O&r":U,
           /* &bContainsQBF  */ "q,&Contains (QBF)":U,
           /* &bRange        */ "r1245,Ran&ge":U,
           /* &bXRange       */ "r1245,&X-Range":U,
           /* &bList         */ "m1245,&List":U,
           /* &bXList        */ "m1245,&X-List":U,
           /* &bAnd          */ "3,&And":U] .

/* Definitions of the field level widgets */
DEFINE RECTANGLE rect-1 EDGE-PIXELS 1 SIZE-CHAR 67.4 BY 1.1 BGCOLOR 8.

DEFINE RECTANGLE rect-3 {&STDPH_OKBOX}.

DEFINE {1} SHARED VARIABLE rsMain AS INTEGER 
  VIEW-AS RADIO-SET HORIZONTAL 
  RADIO-BUTTONS "&Table",   {&Table},
                "&Join",    {&Join},
                "&Where",   {&Where},
                "&Sort",    {&Sort}, 
                "&Options", {&Options}
  SIZE 62 BY .95 BGCOLOR 8 FGCOLOR 0 NO-UNDO.

DEFINE {1} SHARED VARIABLE rsSortDirection AS LOGICAL 
  VIEW-AS RADIO-SET HORIZONTAL  
  RADIO-BUTTONS "&Ascending", TRUE, "&Descending", FALSE NO-UNDO.

DEFINE BUTTON b_fields        LABEL "&Fields...":U SIZE 14 BY {&H_OKBTN}. 
DEFINE BUTTON b_freeformq     LABEL "Freeform &Query...":U SIZE 22 BY {&H_OKBTN}.

DEFINE BUTTON bEqual          SIZE-CHAR 4.14  BY 1 LABEL {&lEqual}.
DEFINE BUTTON bNotEqual       SIZE-CHAR 4.14  BY 1 LABEL {&lNotEqual}.
DEFINE BUTTON bLess           SIZE-CHAR 4.14  BY 1 LABEL {&lLess}.
DEFINE BUTTON bGreater        SIZE-CHAR 4.14  BY 1 LABEL {&lGreater}.
DEFINE BUTTON bLessEqual      SIZE-CHAR 4.14  BY 1 LABEL {&lLessEqual}.
DEFINE BUTTON bGreaterEqual   SIZE-CHAR 4.14  BY 1 LABEL {&lGreaterEqual}.
DEFINE BUTTON bBegins         SIZE-CHAR 12    BY 1 LABEL {&lBegins}.
DEFINE BUTTON bMatches        SIZE-CHAR 12    BY 1 LABEL {&lMatches}.
DEFINE BUTTON bContains       SIZE-CHAR 12    BY 1 LABEL {&lContains}.
DEFINE BUTTON bRange          SIZE-CHAR 12    BY 1 LABEL {&lRange}.
DEFINE BUTTON bXRange         SIZE-CHAR 12    BY 1 LABEL {&lXRange}.
DEFINE BUTTON bContainsQBF    SIZE-CHAR 21.5  BY 1 LABEL {&lContainsQBF}.
DEFINE BUTTON bXList          SIZE-CHAR 12    BY 1 LABEL {&lXList}.
DEFINE BUTTON bList           SIZE-CHAR 12    BY 1 LABEL {&lList}.
DEFINE BUTTON bAnd            SIZE-CHAR 8.5   BY 1 LABEL {&lAnd}.
DEFINE BUTTON bOr             SIZE-CHAR 8.5   BY 1 LABEL {&lOr}.
DEFINE BUTTON bUp             SIZE-CHAR 12    BY 1 LABEL "Move &Up".
DEFINE BUTTON bDown           SIZE-CHAR 12    BY 1 LABEL "Move &Down".
DEFINE BUTTON bTableSwitch    SIZE-CHAR 25    BY 1 LABEL "Switch Join &Partners..".
DEFINE BUTTON bAdd            SIZE-CHAR 12.14 BY 1 LABEL "&Add >>".
DEFINE BUTTON bRemove         SIZE-CHAR 12.14 BY 1 LABEL "<< &Remove".
DEFINE BUTTON bHelp           {&STDPH_OKBTN}       LABEL "&Help".
DEFINE BUTTON bDebug          {&STDPH_OKBTN}       LABEL "Debug".
DEFINE BUTTON bOk             {&STDPH_OKBTN}       LABEL "OK" AUTO-GO.
DEFINE BUTTON bCancel         {&STDPH_OKBTN}       LABEL "Cancel" AUTO-ENDKEY.
DEFINE BUTTON bCheckSyntax    SIZE-CHAR 6     BY 1 LABEL "&Now".
DEFINE BUTTON bFieldFormat    SIZE-CHAR 16    BY 1 LABEL "For&mat Help...".
DEFINE BUTTON bUndo           {&STDPH_OKBTN}       LABEL "&Undo".

DEFINE {1} SHARED VARIABLE eDisplayCode AS CHARACTER 
  VIEW-AS EDITOR SCROLLBAR-VERTICAL NO-WORD-WRAP
  SIZE-CHAR 66 BY 3 {&STDPH_EDITOR} font 2.

DEFINE {1} SHARED variable cShareType as character format "X(15)"
  VIEW-AS combo-box size 26 by .85 inner-lines 5
  list-items "No-lock","Share-lock","Exclusive-lock" 
  init "NO-LOCK".

DEFINE {1} SHARED VARIABLE eResCurrentTable AS CHARACTER format "x(72)"
  VIEW-AS editor size 40 by 1.2 Label "Join" .

DEFINE {1} SHARED VARIABLE eCurrentTable AS CHARACTER format "x(72)"
  VIEW-AS combo-box size 32 by 1 inner-lines 5
  Label "&Database":R10 .

DEFINE {1} SHARED VARIABLE eFieldFormat AS CHARACTER 
  VIEW-AS fill-in size-char 28 by 1 format "x(256)" 
  Label "Fo&rmat":U {&STDPH_FILL}.
     
DEFINE {1} SHARED VARIABLE eFieldLabel AS CHARACTER 
  VIEW-AS EDITOR scrollbar-vertical
  SIZE-CHAR 28 BY 2  Label "Label":U {&STDPH_FILL}.

DEFINE {1} SHARED variable l_label-2 as character 
  VIEW-AS text format "x(25)"
  init "Selected Tables && Joins:".       
       
DEFINE {1} SHARED variable lBrowseLabel as character 
  VIEW-AS text format "x(66)" {&STDPH_SDIV}.

DEFINE {1} SHARED variable lRight as character 
  VIEW-AS text size-char 25 by .8 format "x(50)".

DEFINE {1} SHARED variable lLeft as character 
  VIEW-AS text size-char 25 by .8 format "x(50)".

DEFINE {1} SHARED variable lqrytune as character 
  VIEW-AS text format "x(23)" init "Query Tuning Options:".

DEFINE {1} SHARED variable lSyntax as character 
  VIEW-AS text format "x(15)" init "Check Syntax:".

DEFINE {1} SHARED variable lInclusive as character 
  VIEW-AS text format "x(25)" init "Inclusive:".

DEFINE {1} SHARED variable lExclusive as character 
  VIEW-AS text format "x(25)" init "Exclusive:".
  
DEFINE {1} SHARED variable lWhState as logical.
  /* False is where clause not been built, True it has */

DEFINE {1} SHARED variable tJoinable as LOGICAL 
  VIEW-AS toggle-box label "&Customize Join".

DEFINE {1} SHARED variable tOnOk as LOGICAL 
  VIEW-AS toggle-box label "On &OK".

DEFINE {1} SHARED variable tAskRun as LOGICAL
  VIEW-AS toggle-box label "A&sk At Run Time".

DEFINE {1} SHARED variable lOnOk as character 
  VIEW-AS text init "On &OK".

DEFINE {1} SHARED variable lPhraseLabel as character 
  VIEW-AS text format "x(66)" {&STDPH_SDIV} 
          INITIAL " Preprocessor Phrases".

DEFINE {1} SHARED variable tKeyPhrase as LOGICAL 
  VIEW-AS toggle-box label "&Key-Phrase".

DEFINE {1} SHARED variable tSortByPhrase as LOGICAL 
  VIEW-AS toggle-box label "&SortBy-Phrase".

DEFINE {1} SHARED variable tIndexReposition as logical
  VIEW-AS toggle-box size 25 by .85 label "&Indexed-Reposition".

DEFINE {1} SHARED TEMP-TABLE _query-opt NO-UNDO
  FIELD _seq-no      AS INTEGER
  FIELD _tbl-name    AS CHARACTER
                     FORMAT &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN "X(29)"
                            &ELSE "X(28)" &ENDIF
                     LABEL "Table"
  FIELD _find-type   AS CHARACTER
                     FORMAT  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                             "X(9)" &ELSE "X(5)" &ENDIF
                     LABEL "Find  "
  FIELD _join-type   AS CHARACTER
                     FORMAT  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                             "X(8)" &ELSE "X(6)" &ENDIF
                     LABEL "Join   "
  FIELD _flds-returned AS CHARACTER FORMAT "X(12)" LABEL "Returned"
  INDEX _seq-no IS PRIMARY UNIQUE _seq-no.

DEFINE {1} SHARED BUFFER _qo FOR _query-opt.
DEFINE {1} SHARED QUERY _qrytune FOR _qo SCROLLING.   
DEFINE {1} SHARED BROWSE _qrytune QUERY _qrytune
  DISPLAY _qo._tbl-name 
          _qo._find-type
          _qo._join-type
          _qo._flds-returned 
  ENABLE _qo._find-type _qo._join-type _qo._flds-returned 
  WITH SIZE 65 BY 5  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN"
                     &THEN SEPARATORS &ENDIF .
           
/* Definitions of the frame widgets                                     */
DEFINE {1} SHARED FRAME DIALOG-1
      rect-1                 AT ROW 1     COL 1
      rsMain                 AT ROW 1.1   COL 5    NO-LABEL /* MSW */
      eCurrentTable          AT ROW 2.4   COL 8
      eResCurrentTable       AT ROW 2.4   COL 5
      b_fields               AT ROW 2.4   COL 54 
      l_label-2 VIEW-AS TEXT AT ROW 3.75  COL 32   NO-LABEL
      _qrytune               AT ROW 3.75  COL 3
      
/** The left and right selection lists labels ***/
      lLeft                  AT ROW 3.7   COL 2    NO-LABEL
      lRight                 AT ROW 3.7   COL 42   NO-LABEL
     
/** The left and right selection Lists are dynamic **/

/** The Add and Remove buttons in between the selection lists **/
      bAdd                   AT ROW 4.5   COL 29
      bRemove                AT ROW 5.6   COL 29
      bUp                    AT ROW 7.9   COL 29
      bDown                  AT ROW 9     COL 29
      cShareType             AT ROW 10.25 COL 2    NO-LABEL
      bTableSwitch           AT ROW 10.25 COL 42.5

/** The Operators for Join ***/
      bEqual                 AT ROW 4.5   COL 31
      bNotEqual              AT ROW 4.5   COL 35.4
      bLess                  AT ROW 5.6   COL 31
      bGreater               AT ROW 5.6   COL 35.4
      bLessEqual             AT ROW 6.7   COL 31
      bGreaterEqual          AT ROW 6.7   COL 35.4
      bAnd                   AT ROW 7.8   COL 31
      bOr                    AT ROW 8.9   COL 31
      tJoinable              AT ROW 10.25 COL 25

/** The Operators for Where ***/
      bBegins                AT ROW 4.5   COL 42
      bContains              AT ROW 5.6   COL 42
      bMatches               AT ROW 6.7   COL 42
      bList                  AT ROW 7.8   COL 42 
      bRange                 AT ROW 8.9   COL 42
      tAskRun                AT ROW 10.0  COL 42

/** Field and Sort level widgets ***/
      rsSortDirection        AT ROW 10.25 COL 41  NO-LABEL
      edisplaycode           AT ROW 12.35 COL 2   NO-LABEL
      lBrowseLabel           AT ROW 11.6  COL 2   NO-LABEL
      eFieldLabel            AT ROW 12.85 COL 8   COLON-ALIGNED
      eFieldFormat           AT ROW 15    COL 8   COLON-ALIGNED
      bFieldFormat           AT ROW 15    COL 39
      
/** Query Tuning Options **/
      lqrytune               AT ROW 9.2   COL 3   NO-LABEL
      _TuneOptions           AT ROW 9.8   COL 3   VIEW-AS EDITOR SIZE 65 BY 3.5
                                                  SCROLLBAR-VERTICAL NO-WORD-WRAP 
                                                  NO-LABEL
/** Phrase Options **/  
      lPhraseLabel           AT ROW 13.7 COL 3    NO-LABEL
      tKeyPhrase             AT ROW 14.4 COL 5 
      tSortByPhrase          AT ROW 14.4 COL 25                               

&IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN
      bUndo                  AT ROW 15.35 COL 2
&ELSE
      bUndo                  AT ROW 15.5  COL 2
&ENDIF
      tIndexReposition       AT ROW 15.50 COL 2
      lSyntax                AT ROW 15.50 COL 37  NO-LABEL 
      bCheckSyntax           AT ROW 15.45 COL 51 
      tOnOk                  AT ROW 15.50 COL 58  NO-LABEL 

  {adecomm/okform.i
      &BOX    = "RECT-3"
      &STATUS =  no
      &OK     = "bOk"
      &CANCEL = "bCancel"
      &OTHER  = "b_freeformq"
      &HELP   = "bHelp" }

   WITH VIEW-AS DIALOG-BOX DEFAULT-BUTTON bOk TITLE "Query Builder"
   SIDE-LABELS KEEP-TAB-ORDER SCROLLABLE /*THREE-D*/ . 
 
/* Local Variable Definitions ---                                            */

DEFINE VARIABLE i                      AS INTEGER                       NO-UNDO.
DEFINE VARIABLE j                      AS INTEGER                       NO-UNDO.
DEFINE {1} SHARED VARIABLE lOk         AS LOGICAL                       NO-UNDO.
DEFINE {1} SHARED VARIABLE lLogical    AS LOGICAL                       NO-UNDO.
DEFINE {1} SHARED VARIABLE lPasted     AS LOGICAL                       NO-UNDO.
DEFINE {1} SHARED VARIABLE cTemp       AS CHARACTER                     NO-UNDO.
DEFINE {1} SHARED VARIABLE cList       AS CHARACTER                     NO-UNDO.
DEFINE {1} SHARED VARIABLE cDbName     AS CHARACTER                     NO-UNDO.
DEFINE {1} SHARED VARIABLE cFieldName  AS CHARACTER                     NO-UNDO.
DEFINE {1} SHARED VARIABLE cTableName  AS CHARACTER                     NO-UNDO.
DEFINE {1} SHARED VARIABLE cSortData   AS CHARACTER                     NO-UNDO.
DEFINE {1} SHARED VARIABLE cFieldData  AS CHARACTER                     NO-UNDO.

DEFINE {1} SHARED VARIABLE iTableNum   AS INTEGER                       NO-UNDO.
DEFINE {1} SHARED VARIABLE iXternalCnt AS INTEGER                       NO-UNDO.
DEFINE {1} SHARED VARIABLE rDbId       AS RECID     EXTENT {&MaxTbl}    NO-UNDO. 
DEFINE {1} SHARED VARIABLE rTableId    AS RECID     EXTENT {&MaxTbl}    NO-UNDO.
DEFINE {1} SHARED VARIABLE cSchema     AS CHARACTER EXTENT {&MaxTbl}    NO-UNDO.

DEFINE {1} SHARED VARIABLE whLeft      AS WIDGET    
  EXTENT {&Max-function} NO-UNDO.
DEFINE {1} SHARED VARIABLE whRight     AS WIDGET    
  EXTENT {&Max-function} NO-UNDO.
DEFINE {1} SHARED VARIABLE cMoreData   AS CHARACTER 
  EXTENT {&Max-function} NO-UNDO.
DEFINE {1} SHARED VARIABLE cCurrentDb  AS CHARACTER                     NO-UNDO.

DEFINE {1} SHARED VARIABLE acWhere     AS CHARACTER EXTENT 100          NO-UNDO.
DEFINE {1} SHARED VARIABLE acJoin      AS CHARACTER EXTENT 100          NO-UNDO.

/* qurydefs.i - end of file */


