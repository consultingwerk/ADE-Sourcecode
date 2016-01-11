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

             ********** The QUERY BUILDER  Main Procedure **********

  File: _query.p 

  Description: 
   This code will bring up the dialog box frame that allows the developer
   to define the files for a query (and optionally, the fields for an 
   associated browse). 

  Input Parameters:
    browser-name    - The name of the browser to be editted
    suppress_dbname - Logical to indicate if dbname should be suppressed
                      from qualifications of the db fields in the generated
                      4GL code
    application     - Either "AB" or "Results"
    pcValidStates   - Valid Values for the Radio-Set at the top of the
                      screen  ("Table,Join,Where,Sort,Options").  The
                      first entry in this list is the initial state.
                      (eg. "Where,Join" will show only two items and will
                      set the initial state to "Where").
    plVisitFields   - YES if user cannot leave the dialog without first
                      Visiting the "Fields" entry.
    auto-check      - State of check syntax on OK toggle

  Output Parameters:
    pCancelBtn      - logical for ok/cancel btn    
     
  Author: Greg O'Connor

  Created: 03/23/93 - 12:17 pm

  Modified:
    1/17/94 wood - don't return _TblList = ?.  Use "" in this case.
    1/28/94 wood - moved to adeshar/_query2.p
    2/24/94 adams - added output param to check for endkey condition
                    added partial-key help for eDisplayCode 4GL widget
                    display WHERE clause only for single pcValidState
    2-3/94  ryan - Extensively modified all query programs to incorporate
                   calculated fields, real combo boxes, and fix about 40 query bugs
    4/28/95 wood - I &IF'd out the entire contents of the file if compiled in
                   TTY mode.
 -----------------------------------------------------------------------------*/
/* Parameters Definitions ---                                                */
&GLOBAL-DEFINE WIN95-BTN YES
DEFINE INPUT  PARAMETER browser-name    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER suppress_dbname AS LOGICAL   NO-UNDO.
DEFINE INPUT  PARAMETER application     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcValidStates   AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER plVisitFields   AS LOGICAL   NO-UNDO.
DEFINE INPUT  PARAMETER auto_check      AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER cancelled       AS LOGICAL   NO-UNDO. /* dma */

/* This file is not required in TTY, so IFDEF it out */
&IF "{&WINDOW-SYSTEM}" ne "TTY" &THEN

{ adeshar/quryshar.i }
{ adecomm/tt-brws.i }
{ adeshar/qurydefs.i NEW }
{ adecomm/cbvar.i }
{ adecomm/adeintl.i }
{ adeuib/uibhlp.i }           /*   AB Help pre-processor directives      */
{ aderes/reshlp.i }           /*   Results Help pre-processor directives */

/* Standard End-of-line character */
&SCOPED-DEFINE EOL  CHR(10)

/*---------------------------------------------------------------------------*/
DEFINE VARIABLE cCompOut         AS CHARACTER INITIAL ?   NO-UNDO.
DEFINE VARIABLE cCompIn          AS CHARACTER INITIAL ?   NO-UNDO.
DEFINE VARIABLE cState           AS CHARACTER NO-UNDO.
DEFINE VARIABLE iTemp            AS INTEGER   NO-UNDO.
DEFINE VARIABLE lNo_Tables       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lConstant        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lMustCheckFields AS LOGICAL   NO-UNDO.
DEFINE VARIABLE res_calcfld      AS LOGICAL   NO-UNDO. /* RESULTS calc field */
DEFINE VARIABLE sel-str          AS CHARACTER NO-UNDO. /* dma */
DEFINE VARIABLE sIndex           AS CHARACTER NO-UNDO.
DEFINE VARIABLE v_pick           AS CHARACTER NO-UNDO.

DEFINE RECTANGLE RECT-4 {&STDPH_OKBOX}.

DEFINE NEW SHARED STREAM P_4GL.

FORM
  SKIP ({&TFM_WID})
  SPACE({&HFM_WID}) 
  
  v_pick 
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 32 INNER-LINES 10 
  SKIP

  {adecomm/okform.i
    &BOX    = "RECT-4"
    &STATUS =  no
    &OK     = "bOk"
    &CANCEL = "bCancel"}
  
  WITH FRAME fr_pick NO-ATTR-SPACE NO-LABELS DEFAULT-BUTTON bOK 
  TITLE "Select Related Table":t32 VIEW-AS DIALOG-BOX.

  {adecomm/okrun.i  
    &FRAME  = "FRAME fr_pick" 
    &BOX    = "rect-4"
    &OK     = "bOK" 
    &CANCEL = "bCancel" }

/* Include the trigger code for the Query Builder */
{ adeshar/qurytrig.i }

ON WINDOW-CLOSE OF FRAME dialog-1 OR ENDKEY OF FRAME dialog-1 OR END-ERROR OF FRAME dialog-1 DO:
  cancelled = TRUE.
  APPLY "END-ERROR":u TO SELF.
END.

ON HELP OF eDisplayCode IN FRAME dialog-1 DO: /* dma */
  sel-str = "".
  IF (eDisplayCode:SELECTION-START <> eDisplayCode:SELECTION-END ) THEN
    sel-str = TRIM(TRIM(eDisplayCode:SELECTION-TEXT), ",.;:!? ~"~ '[]()").
  RUN adecomm/_adehelp.p ("lgrf","PARTIAL-KEY",?,sel-str).
END.

/* ----------------------------------------------------------- */
/* Main Code Block - Enable Widgets, Exit condition, Clean-up  */
/* ----------------------------------------------------------- */

IF SESSION:THREE-D = TRUE THEN FRAME DIALOG-1:THREE-D = TRUE.

/* Go through the list of radio-buttons. If the radio-button is NOT in the
   list of Valid States (pcValidStates) then delete the radio button. 
   NOTE: we want the 1st,3rd,5th element of radio buttons because this
   list is of the form "Label,value,label,value" */
   
DO iTemp = 1 TO NUM-ENTRIES(rsMain:RADIO-BUTTONS) BY 2:
  CASE LOOKUP(ENTRY(iTemp, REPLACE(rsMain:RADIO-BUTTONS,"~&":U,"")),
                                   pcValidStates):
    WHEN 0 THEN /* Radio-Button is NOT valid.  Delete it. */
    DO:
      lConstant = rsMain:DELETE(ENTRY(iTemp, rsMain:RADIO-BUTTONS) ).
      iTemp = iTemp - 2.
    END.
    WHEN 1 THEN /* This button is the first in the Valid List */
      cState = ENTRY(iTemp + 1, rsMain:RADIO-BUTTONS). 
  END CASE.
END.

/* Compute the number of "external" tables -- store this for future
   enabling -- these are always at the front of the list. */
iXternalCnt = 0.

ASSIGN _TblList       = RIGHT-TRIM(_TblList,{&Sep1}) 
       tKeyPhrase     = (LOOKUP ("KEY-PHRASE":U, _OptionList, " ":U) > 0)
       tSortByPhrase  = (LOOKUP ("SORTBY-PHRASE":U, _OptionList, " ":U) > 0)
       .

COUNT-EXTERNALS:
DO iTemp = 1 TO NUM-ENTRIES(_TblList,{&Sep1}):
  cTemp = ENTRY(iTemp,_TblList,{&Sep1}).
  IF NUM-ENTRIES(cTemp," ") = 2 AND ENTRY(2,cTemp," ") = "<external>" 
  THEN iXternalCnt = iTemp.
  ELSE LEAVE COUNT-EXTERNALS.
END.

/* Ensure the interface displays over the window with focus. */
IF VALID-HANDLE(ACTIVE-WINDOW) THEN CURRENT-WINDOW = ACTIVE-WINDOW.

/* Now enable the interface and wait for the exit condition. */ 
RUN adeshar/_qenable.p (auto_check, application, pcValidStates).
lNo_Tables = FALSE.

RUN RadioSetEnable.ip.

rsMain:SCREEN-VALUE = cState. 

RUN adeshar/_qenable.p (auto_check,application,pcValidStates).

IF cState = "2" THEN	
  APPLY "VALUE-CHANGED" TO eCurrentTable IN FRAME dialog-1.

/* We don't want to build the query if we're starting with one state */
IF NUM-ENTRIES(pcValidStates) > 1 THEN DO: /* dma */
  RUN BuildQuery.ip (OUTPUT eDisplayCode). 

  bCheckSyntax:SENSITIVE    = (IF eDisplayCode > "" THEN TRUE ELSE FALSE).
  eDisplayCode:SCREEN-VALUE = eDisplayCode.
END.

DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE: 
  RUN adecomm/_setcurs.p ("").
  WAIT-FOR GO OF FRAME dialog-1.

  IF {&Join-Mode} THEN APPLY "LEAVE" TO eDisplayCode.
END.
 
HIDE FRAME DIALOG-1.

/******************************************************************/
/*                     Internal Procedures                        */
/******************************************************************/

/* Include the Internal procedures for the Query Builder */
{ adeshar/quryproa.i }
{ adeshar/quryproe.i }

&ENDIF /* _query.p - end of file  (and end of &IF..ne "TTY") */

