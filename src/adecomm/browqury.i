/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-----------------------------------------------------------------------------

  File: browqury.i

  Description: 
   This code will bring up the dialog box frame that allows the developer
   to define the files and their query relationships used in a browse.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Greg O'Connor

  Created: 03/23/93 - 12:17 pm

-----------------------------------------------------------------------------*/
&Global-Define Debug FALSE /*TRUE*/

{ adecomm/qurywidg.i }
{ adecomm/adestds.i }
/*
** The five main states of the query builder as returned by rsmain:screen-value
*/
&Global-Define Table         1
&Global-Define Join          2
&Global-Define Where         3
&Global-Define Sort          4
&Global-Define Field         5
&Global-Define Max-function  5

&Global-Define CurRight     whRight   [INTEGER (rsMain:screen-value)]
&Global-Define TableRight   whRight   [{&Table}]
&Global-Define CurLeft      whLeft    [INTEGER (rsMain:screen-value)]
&Global-Define CurData      cMoreData [INTEGER (rsMain:screen-value)]
&Global-Define CurSortData  cMoreData [{&Sort}]
&Global-Define CurFieldData cMoreData [{&Field}]
&Global-Define CurTable     eCurrentTable:SCREEN-VALUE 

&Global-Define DisFieldList  "<<Selected Fields>>"
/* Temp Table for WHERE builder */

DEFINE {1} SHARED TEMP-TABLE ttWhere NO-UNDO
  FIELD iState      AS INTEGER         /* Screen State */
  FIELD cTable      AS CHARACTER       /* Table Name */
  FIELD iSeq        AS INTEGER         /* sequence */
  FIELD cExpression AS CHARACTER       /* Expression */
  FIELD cLastField  AS CHARACTER       /* Where Last Field */
  FIELD iOffset     AS INTEGER         /* Display Offset */
  FIELD lOperator   AS LOGICAL         /* Operator State */
  INDEX ttWhere-index IS PRIMARY UNIQUE iState cTable iSeq.

/* internal variables */
DEFINE {1} SHARED VARIABLE cOperator  AS CHARACTER NO-UNDO. /* comparison operator  */
DEFINE {1} SHARED VARIABLE cLastField AS CHARACTER NO-UNDO. /* last field referenced */
DEFINE {1} SHARED VARIABLE cValue     AS CHARACTER NO-UNDO. /* value                */
/*
** These DEFINE {1} SHAREDs and acWhereState are use to controll the operators that
** are available in the WHERE builder.
*/
&Global-Define bEqual	         1
&Global-Define bNotEqual	 2
&Global-Define bLess		 3
&Global-Define bGreater	     	 4
&Global-Define bLessEqual	 5
&Global-Define bGreaterEqual	 6
&Global-Define bBegins		 7
&Global-Define bMatches		 8
&Global-Define bContains	 9
&Global-Define bXMatches	 10 
&Global-Define bContainsQBF	 11
&Global-Define bRange		 12
&Global-Define bXRange		 13	
&Global-Define bList		 14	
&Global-Define bXList		 15	
&Global-Define bAnd 		 16	
&Global-Define bOr  		 17	

&Global-Define lEqual	         "=" 
&Global-Define lNotEqual	 "<>" 
&Global-Define lLess		 "<" 
&Global-Define lGreater	     	 ">" 
&Global-Define lLessEqual	 "<=" 
&Global-Define lGreaterEqual	 ">=" 
&Global-Define lBegins		 "Begins" 
&Global-Define lMatches		 "Matches" 
&Global-Define lContains 	 "Contains" 
&Global-Define lXMatches	 "Like"  
&Global-Define lContainsQBF	 "Contains (QBF)" 
&Global-Define lRange		 "Range" 
&Global-Define lXRange		 "X-Range" 	
&Global-Define lList		 "List" 	
&Global-Define lXList		 "X-List" 	
&Global-Define lAnd              "AND"
&Global-Define lOr               "OR"
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
DEFINE {1} SHARED VARIABLE acWhereState AS CHARACTER EXTENT 17 NO-UNDO.
ASSIGN
  acWhereState[{&bEqual}]        = "o12345," + {&lEqual} + "," +
                                    "Equal             " +  " ( = )":u
  acWhereState[{&bNotEqual}]     = "o12345," + {&lNotEqual} + "," +
                                    "Not Equal        " + " ( <> )":u
  acWhereState[{&bLess}]         = "o1245,"  + {&lLess} + "," +
                                    "Less Than         " + " ( < )":u
  acWhereState[{&bGreater}]      = "o1245,"  + {&lGreater} + "," +
                                    "Less or Equal    "  + " ( <= )":u
  acWhereState[{&bLessEqual}]    = "o1245,"  + {&lLessEqual} + "," +
                                    "Greater Than      " +  " ( > )":u
  acWhereState[{&bGreaterEqual}] = "o1245,"  + {&lGreaterEqual} + "," +
                                    "Greater or Equal "  + " ( >= )":u
  acWhereState[{&bBegins}]       = "u1,"     + {&lBegins} + "," +
                                    "Begins                  "
  acWhereState[{&bMatches}]      = "u1,"     + {&lMatches} + "," +
                                    "Matches                 "
  acWhereState[{&bContains}]     = "q,"      + {&lContains} + "," +
                                    "Contains              " +  " (SQL)":u
  acWhereState[{&bXMatches}]     = "u1,"     + {&lXMatches} + "," +
                                    "Contains                "
  acWhereState[{&bContainsQBF}]  = "q,"      + {&lContainsQBF} + "," +
                                    "Contains          " +  " (QBW)":u
  acWhereState[{&bRange}]        = "r1245,"  + {&lRange} + "," +
                                    "Range (Inclusive)       "
  acWhereState[{&bXRange}]       = "r1245,"  + {&lXRange} + "," +
                                    "Range (Exclusive)       "
  acWhereState[{&bList}]         = "m1245,"  + {&lList} + "," +
                                    "In List of Values       "
  acWhereState[{&bXList}]        = "m1245,"  + {&lXList} + "," +
                                    "Not In List of Values   "
  acWhereState[{&bAnd}]          = "3,"      + {&lAnd} + "," + "x"
  acWhereState[{&bOr}]           = "3,"      + {&lOr} + "," + "x".
											     
/* DEFINE {1} SHARED a dialog box                                                      */
											     
/* Definitions of the field level widgets                               */
DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 1 	  
     SIZE-CHAR 67.4 BY 1.1 {&STDPH_FILL}.

DEFINE RECTANGLE RECT-3 {&STDPH_OKBOX}.

&Global-Define partialFeatures	 1

DEFINE {1} SHARED VARIABLE rsMain AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL  
     RADIO-BUTTONS 
                   &if defined(partialFeatures) = 0 &then
                       "Table   ",{&Table},
                   &endif
                       "Join",    {&Join}
                      ,"Where",   {&Where}
                   &if defined(partialFeatures) = 0 &then
                       ,"Sort",    {&Sort}
                       ,"Fields",  {&Field}     
                   &endif
     SIZE 62 BY .95 
     BGCOLOR 8 FGCOLOR 0 NO-UNDO. 

DEFINE {1} SHARED VARIABLE RADIO-SET-2 AS LOGICAL 
     VIEW-AS RADIO-SET HORIZONTAL  
     RADIO-BUTTONS "AND",TRUE,"OR",FALSE NO-UNDO.

DEFINE {1} SHARED VARIABLE rsSortDirection AS LOGICAL 
     VIEW-AS RADIO-SET HORIZONTAL  
     RADIO-BUTTONS "Ascending",TRUE,
                   "Descending",FALSE  NO-UNDO.
				  
DEFINE BUTTON bEqual 	      SIZE-CHAR 4.14  BY 1      LABEL {&lEqual	       }.
DEFINE BUTTON bNotEqual       SIZE-CHAR 4.14  BY 1      LABEL {&lNotEqual	   }.
DEFINE BUTTON bLess 	      SIZE-CHAR 4.14  BY 1      LABEL {&lLess		   }.
DEFINE BUTTON bGreater 	      SIZE-CHAR 4.14  BY 1      LABEL {&lGreater	   }.
DEFINE BUTTON bLessEqual      SIZE-CHAR 4.14  BY 1      LABEL {&lLessEqual     }.
DEFINE BUTTON bGreaterEqual   SIZE-CHAR 4.14  BY 1      LABEL {&lGreaterEqual  }.
DEFINE BUTTON bBegins 	      SIZE-CHAR 10.25 BY 1      LABEL {&lBegins	       }.
DEFINE BUTTON bMatches 	      SIZE-CHAR 10.25 BY 1      LABEL {&lMatches	   }.
DEFINE BUTTON bXMatches       SIZE-CHAR 10.25 BY 1      LABEL {&lXMatches	   }.
DEFINE BUTTON bContains	      SIZE-CHAR 10.25 BY 1      LABEL {&lContains      }.
DEFINE BUTTON bRange 	      SIZE-CHAR 10.25 BY 1      LABEL {&lRange	       }.
DEFINE BUTTON bXRange 	      SIZE-CHAR 10.25 BY 1      LABEL {&lXRange	       }.
DEFINE BUTTON bContainsQBF    SIZE-CHAR 21.5  BY 1      LABEL {&lContainsQBF   }.
DEFINE BUTTON bXList 	      SIZE-CHAR 10.25 BY 1      LABEL {&lXList		   }.
DEFINE BUTTON bList 	      SIZE-CHAR 10.25 BY 1      LABEL {&lList	       }.
DEFINE BUTTON bAnd		      SIZE-CHAR 8.5   BY 1      LABEL {&lAnd	       }.
DEFINE BUTTON bOr		      SIZE-CHAR 8.5   BY 1      LABEL {&lOr 	       }.
DEFINE BUTTON bUp             SIZE-CHAR 12    BY 1      LABEL "Move up" .
DEFINE BUTTON bDown           SIZE-CHAR 12    BY 1      LABEL "Move Down" .
DEFINE BUTTON bTableSwitch    SIZE-CHAR 25    BY 1	    LABEL "Switch Join Partners.." .
DEFINE BUTTON bAdd 	      SIZE-CHAR 12.14  BY 1      LABEL "Add >>" .
DEFINE BUTTON bRemove 	      SIZE-CHAR 12.14  BY 1      LABEL "<< Remove" .
DEFINE BUTTON bHelp 	      {&STDPH_OKBTN}            LABEL "&Help".
DEFINE BUTTON bDebug 	      {&STDPH_OKBTN}            LABEL "&Debug".
DEFINE BUTTON bOk 		      {&STDPH_OKBTN}            LABEL "OK" AUTO-GO.
DEFINE BUTTON bCancel 	      {&STDPH_OKBTN}            LABEL "Cancel" AUTO-ENDKEY.
DEFINE BUTTON bCheckSyntax    SIZE-CHAR 6     BY 1      LABEL "Now" .
DEFINE BUTTON bFieldFormat    SIZE-CHAR 16    BY 1 	    LABEL "Format Help..." .
DEFINE BUTTON bUndo 	      {&STDPH_OKBTN}            LABEL "Undo" .

DEFINE BUTTON bDrop IMAGE-UP FILE "btn-down-arrow".

DEFINE {1} SHARED VARIABLE slComboBox AS CHARACTER NO-UNDO
   VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-V
     SIZE-CHAR 30 BY 5.5 .

DEFINE {1} SHARED VARIABLE eDisplayCode AS CHARACTER 
     VIEW-AS EDITOR scrollbar-vertical
     SIZE-CHAR 66 BY 3 {&STDPH_EDITOR}.

DEFINE {1} SHARED VARIABLE eCurrentTable AS CHARACTER 
     format "x(72)" Label "Table" 
     view-as fill-in size 29 by 1 {&STDPH_FILL}.

DEFINE {1} SHARED VARIABLE eFieldFormat AS CHARACTER 
     format "x(27)" Label "Format" {&STDPH_FILL}.

DEFINE {1} SHARED VARIABLE eFieldLabel AS CHARACTER 
     VIEW-AS EDITOR   scrollbar-vertical
     SIZE-CHAR 28 BY 2  Label " Label" {&STDPH_FILL}.

DEFINE {1} SHARED variable l_label-2 as character 
       view-as text format "x(25)"
       init "Selected Tables && Joins:". 
       
DEFINE {1} SHARED variable lCombineUsing as character 
       view-as text format "x(15)".
       
DEFINE {1} SHARED variable lBrowseLabel as character 
       view-as text format "x(66)" {&STDPH_SDIV}.

DEFINE {1} SHARED variable lRight as character 
       view-as text format "x(25)".

DEFINE {1} SHARED variable lLeft as character 
       view-as text format "x(25)".

DEFINE {1} SHARED variable lSyntax as character 
       view-as text format "x(15)" init "Check Syntax:".

DEFINE {1} SHARED variable lInclusive as character 
       view-as text format "x(25)" init "Inclusive:".

DEFINE {1} SHARED variable lExclusive as character 
       view-as text format "x(25)" init "Exclusive:".

DEFINE {1} SHARED variable tJoinable as LOGICAL 
       view-as toggle-box label "Customize Join".

DEFINE {1} SHARED variable tOnOk as LOGICAL 
       view-as toggle-box label "On OK".

DEFINE {1} SHARED variable lOnOk as character 
       view-as text init "On OK".

/* Definitions of the frame widgets                                     */
DEFINE {1} SHARED FRAME DIALOG-1
     RECT-1             AT ROW 1     COL 1
     rsMain             AT ROW 1.1   COL 5 /* MSW */ NO-LABEL
     eCurrentTable      AT ROW 2.4   COL 10 
	 bDrop              AT ROW 2.25  COL 48 NO-LABEL
	 tJoinable			AT ROW 2.5   COL 51
	 slComboBox         AT ROW 2.25  COL 1  NO-LABEL

     l_label-2 VIEW-AS TEXT no-label AT ROW 3.75 COL 32

/** The left and right selection lists labels ***/
     lLeft          	AT ROW 3.75  COL 2  NO-LABEL
     lRight          	AT ROW 3.75  COL 42 NO-LABEL
/** The left and right selection lists ***/
/** The Add and Remove buttons in between the selection lists **/
     bAdd               AT ROW 4.5   COL 29
     bRemove            AT ROW 5.6     COL 29
/** The Operators for Join ***/
     bEqual		        AT ROW 4.5   COL 31
     bNotEqual			AT ROW 4.5   COL 35.4
     bLess				AT ROW 5.6   COL 31
     bGreater			AT ROW 5.6   COL 35.4
     bLessEqual			AT ROW 6.7   COL 31
     bGreaterEqual		AT ROW 6.7   COL 35.4
     bAnd				AT ROW 7.8   COL 31
     bOr				AT ROW 8.9   COL 31
/** The Operators for Where ***/
     bBegins 			AT ROW 5.6   COL 42
     bMatches 			AT ROW 6.7   COL 42
     bList 				AT ROW 7.8   COL 42 
     bXMatches 			AT ROW 5.6   COL 53
     bContains			AT ROW 6.7   COL 53
     bRange 			AT ROW 7.8   COL 53

/*     bContains 			AT ROW 10    COL 42 
     lInclusive			AT ROW 6.7   COL 42 NO-LABEL 
     lExclusive			AT ROW 8.9   COL 42	NO-LABEL
     bXList 			AT ROW 10    COL 42 
     bxRange 			AT ROW 10     COL 53
*/

     bTableSwitch       AT ROW 10.25  COL 42.5

     bUp                AT ROW 7.9 /*9.65*/  COL 29 /* 40 */
     bDown              AT ROW 9   /*9.65*/  COL 29 /* 56 */
     rsSortDirection    AT ROW 10.25 COL 41 NO-LABEL
     edisplaycode       AT ROW 12.25 COL 2  NO-LABEL
     lBrowseLabel       AT ROW 11.5  COL 2  NO-LABEL
     eFieldLabel        AT ROW 12.85 COL 3
     eFieldFormat       AT ROW 15    COL 2.25
     bFieldFormat       AT ROW 15    COL 39

     lCombineUsing      AT ROW 15.4    COL 3 NO-LABEL
     RADIO-SET-2        AT ROW 16.1    COL 4 NO-LABEL

     bUndo              AT ROW 16      COL 22
     lSyntax            AT ROW 16      COL 37 NO-LABEL 
     bCheckSyntax       AT ROW 16      COL 51 
     tOnOk              AT ROW 16      COL 58 NO-LABEL 
/** The Standard dialog button **/
     {adecomm/okform.i
	     &BOX    = "RECT-3"
         &STATUS =  no
		 &OK     = "bOk"
		 &CANCEL = "bCancel"
		 &OTHER  = "SPACE({&HM_DBTNG}) bDebug"
		 &HELP   = "bHelp"
	 }
   WITH VIEW-AS DIALOG-BOX DEFAULT-BUTTON bOk
   SIDE-LABELS  SCROLLABLE. 
 
/* Local Variable Definitions ---                                            */

DEFINE VARIABLE i                      AS INTEGER   NO-UNDO.
DEFINE VARIABLE j                      AS INTEGER   NO-UNDO.
DEFINE {1} SHARED VARIABLE lOk         AS LOGICAL   NO-UNDO.
DEFINE {1} SHARED VARIABLE lLogical    AS LOGICAL   NO-UNDO.
DEFINE {1} SHARED VARIABLE cTemp       AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE cList       AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE cDbName     AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE cFieldName  AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE cTableName  AS CHARACTER NO-UNDO.

DEFINE {1} SHARED VARIABLE cSortData   AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE cFieldData  AS CHARACTER NO-UNDO.
/**/
DEFINE {1} SHARED VARIABLE iTableNum   AS INTEGER   NO-UNDO.
DEFINE {1} SHARED VARIABLE rDbId       AS REC       NO-UNDO EXTENT {&MaxTbl}. /* DB recid */
DEFINE {1} SHARED VARIABLE rTableId    AS REC       NO-UNDO EXTENT {&MaxTbl}. /* Tbl recid */
DEFINE {1} SHARED VARIABLE cSchema     AS CHARACTER NO-UNDO EXTENT {&MaxTbl}. /* schema db */

DEFINE {1} SHARED VARIABLE whLeft      AS WIDGET    NO-UNDO EXTENT {&Max-function}.
DEFINE {1} SHARED VARIABLE whRight     AS WIDGET    NO-UNDO EXTENT {&Max-function}.
DEFINE {1} SHARED VARIABLE cMoreData   AS CHARACTER NO-UNDO EXTENT {&Max-function}.
DEFINE {1} SHARED VARIABLE cCurrentDb  AS CHARACTER NO-UNDO.

DEFINE {1} SHARED VARIABLE acWhere     AS CHARACTER EXTENT 100 NO-UNDO.
DEFINE {1} SHARED VARIABLE acJoin      AS CHARACTER EXTENT 100 NO-UNDO.

