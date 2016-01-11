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
/* s-calc.p - report writer calculated fields */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/t-define.i }
{ aderes/j-define.i }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

/* Edit an existing calculated expression (qbf-ix > 0) or add a new one */
DEFINE INPUT  PARAMETER qbf-t   AS CHARACTER NO-UNDO. /* calc field type */
DEFINE INPUT  PARAMETER qbf-ix  AS INTEGER   NO-UNDO. /* field array index */
DEFINE OUTPUT PARAMETER qbf-chg AS LOGICAL   NO-UNDO. /* anything changed? */

DEFINE VARIABLE junk    AS CHARACTER NO-UNDO INIT "". /* unused output parm */
DEFINE VARIABLE qbf-1	AS CHARACTER NO-UNDO. /* lookup-field: source field */
DEFINE VARIABLE qbf-2	AS CHARACTER NO-UNDO. /* lookup-field: target field */
DEFINE VARIABLE qbf-3	AS CHARACTER NO-UNDO. /* lookup-field: display field */
DEFINE VARIABLE qbf-4	AS CHARACTER NO-UNDO. /* lookup-field: no-match val */
DEFINE VARIABLE qbf-1p	AS CHARACTER NO-UNDO. /* prev source field */
DEFINE VARIABLE qbf-2p	AS CHARACTER NO-UNDO. /* prev target field */
DEFINE VARIABLE qbf-a	AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-c	AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-d	AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i	AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-k	AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-l	AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-x	AS INTEGER   NO-UNDO. /* used for positioning widgets */
DEFINE VARIABLE qbf-y	AS INTEGER   NO-UNDO. /* used for positioning widgets */

DEFINE VARIABLE edit_it AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-new AS LOGICAL   NO-UNDO.
DEFINE VARIABLE realtbl AS CHARACTER NO-UNDO. 

DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-Help LABEL "&Help"  {&STDPH_OKBTN}.
/* standard button rectangle */
DEFINE RECTANGLE rect_btns   {&STDPH_OKBOX}.
DEFINE RECTANGLE qbf-r       SIZE-PIXELS 66 BY 78  NO-FILL EDGE-PIXELS 2.

DEFINE IMAGE qbf-i1 FILENAME "adeicon/counter1":u.
DEFINE IMAGE qbf-i2 FILENAME "adeicon/counter2":u.
DEFINE IMAGE qbf-i3 FILENAME "adeicon/counter3":u.

/*--------------------------------------------------------------------------*/

FORM 
  SKIP({&TFM_WID}) 
  qbf-l COLON 33 FORMAT "->>>,>>9":u LABEL "&Starting Number"
    HELP "Enter starting number for counter":t63 {&STDPH_FILL}
  SKIP({&VM_WID}) 
  qbf-i COLON 33 FORMAT "->>>,>>9":u LABEL "&Number to Add (for Each Record)"
    HELP "Enter increment, or a negative number to subtract":t63 {&STDPH_FILL}
  SKIP({&VM_WIDG})

  "Sections Used In:" AT 5 
    VIEW-AS TEXT
  SKIP({&VM_WID})
  
  qbf-d AT 5 NO-LABEL
    VIEW-AS RADIO-SET VERTICAL RADIO-BUTTONS
      "&Master Section Only":t45, "<":u,
      "&Detail Section Only":t45, ">":u,
      "&All Sections":t45,        "*":u

  SPACE({&HM_WIDG})
  qbf-i1 
  
  qbf-i2 AT ROW-OF qbf-i1 COL-OF qbf-i1
  
  qbf-i3 AT ROW-OF qbf-i1 COL-OF qbf-i1
  
  qbf-r  AT ROW-OF qbf-i1 COL-OF qbf-i1 
  SKIP({&VM_WID})

  {adecomm/okform.i
     &BOX    = rect_btns
     &STATUS = no
     &OK     = qbf-ok
     &CANCEL = qbf-ee
     &HELP   = qbf-help}

  WITH FRAME qbf-counter SIDE-LABELS NO-ATTR-SPACE THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee 
  TITLE "Add Field - Counter":t32 VIEW-AS DIALOG-BOX.

/*--------------------------------Triggers--------------------------------*/

ON HELP OF FRAME qbf-counter OR CHOOSE OF qbf-help IN FRAME qbf-counter
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Define_Counters_Dlg_Box},?).

ON GO OF FRAME qbf-counter DO:
  ASSIGN
    qbf-l = INPUT FRAME qbf-counter qbf-l
    qbf-i = INPUT FRAME qbf-counter qbf-i.

  IF qbf-new THEN
    ASSIGN
      qbf-rc#  	      = qbf-rc# + 1
      qbf-ix   	      = qbf-rc#
      qbf-rcg[qbf-ix] = ""
      qbf-rct[qbf-ix] = 4
      qbf-rcl[qbf-ix] = "Counter":u
      qbf-rcf[qbf-ix] = (IF qbf-l < 0 OR qbf-i < 0 THEN "-":u ELSE "")
                      	 + 
      	       	     	(IF qbf-l + qbf-i >= 100000 THEN ">>>>>>9":u ELSE
      	       	     	 IF qbf-l + qbf-i >= 10000  THEN ">>>>>9":u 
      	       	     	      	       	            ELSE ">>>>9":u)
      qbf-rcp[qbf-ix] = ",,,,,":u
      qbf-rcn[qbf-ix] = "qbf-" + STRING(qbf-ix,"999":u) 
                      + ",":u + STRING(qbf-l) + ",":u + STRING(qbf-i)
      .
  ASSIGN
    qbf-rcc[qbf-ix] = "c,":u + TRIM(qbf-d:SCREEN-VALUE IN FRAME qbf-counter)
    qbf-rcn[qbf-ix] = ENTRY(1,qbf-rcn[qbf-ix]) + ",":u
                    + STRING(qbf-l) + ",":u + STRING(qbf-i)
    qbf-chg         = TRUE
    .
END.

ON VALUE-CHANGED OF qbf-d IN FRAME qbf-counter 
  RUN show_graphic.

ON WINDOW-CLOSE OF FRAME qbf-counter
  APPLY "END-ERROR":u TO SELF.

/*------------------------------Mainline---------------------------------*/

ASSIGN
  qbf-new = (qbf-ix = 0) 
  qbf-chg = FALSE.

IF qbf-new AND qbf-rc# = EXTENT(qbf-rcn) THEN DO:
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,SUBSTITUTE(
    "You already have the maximum number of columns (&1) defined.",
    EXTENT(qbf-rcn))).
    
  RETURN.
END.

CASE qbf-t:
  WHEN "c":u THEN DO: /*------------------------------------------- COUNTER */
    ASSIGN
      qbf-c = ""
      qbf-d = IF qbf-new THEN "<":u ELSE ENTRY(2,qbf-rcc[qbf-ix]) 
      qbf-l = IF qbf-new THEN 1     ELSE INTEGER(ENTRY(2,qbf-rcn[qbf-ix]))
      qbf-i = IF qbf-new THEN 1     ELSE INTEGER(ENTRY(3,qbf-rcn[qbf-ix]))
      qbf-y = qbf-d:Y IN FRAME qbf-counter
      qbf-x = qbf-l:X IN FRAME qbf-counter
      qbf-i1:HIDDEN   IN FRAME qbf-counter = TRUE
      qbf-i2:HIDDEN   IN FRAME qbf-counter = TRUE
      qbf-i3:HIDDEN   IN FRAME qbf-counter = TRUE
      qbf-r:X         IN FRAME qbf-counter = qbf-i1:X IN FRAME qbf-counter - 3
      qbf-r:Y         IN FRAME qbf-counter = qbf-i1:Y IN FRAME qbf-counter - 3
      qbf-d:SENSITIVE IN FRAME qbf-counter = (qbf-detail > 0)
      qbf-d:SCREEN-VALUE IN FRAME qbf-counter = IF qbf-new THEN "<":u ELSE 
                                                  ENTRY(2,qbf-rcc[qbf-ix]) 
      .

    /* Run time layout for button area.  This defines eff_frame_width */
    {adecomm/okrun.i  
       &FRAME = "FRAME qbf-counter" 
       &BOX   = "rect_btns"
       &OK    = "qbf-ok" 
       &HELP  = "qbf-help" }

    DISPLAY qbf-l qbf-i qbf-d 
      WITH FRAME qbf-counter.

    RUN show_graphic.

    ENABLE qbf-l qbf-i qbf-d qbf-ok qbf-ee qbf-help 
      WITH FRAME qbf-counter.

    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
      WAIT-FOR "GO":u OF FRAME qbf-counter FOCUS qbf-l IN FRAME qbf-counter.
    END.
    HIDE FRAME qbf-counter NO-PAUSE.
  END.

  WHEN "r":u OR WHEN "p":u THEN DO: /*------ RUNNING TOTAL/PERCENT OF TOTAL */
    qbf-c = "".
    RUN aderes/j-field1.p (qbf-tables,"$#45@":u,
      IF qbf-t = "r":u THEN "Add Field - Running Total":c36 
      	       	       ELSE "Add Field - Percent of Total":c39,
      "",
      INPUT-OUTPUT qbf-c, INPUT-OUTPUT junk).

    IF qbf-c <> "" THEN DO:
      RUN alias_to_tbname (qbf-c, TRUE, OUTPUT realtbl).
      RUN adecomm/_y-schem.p (realtbl,"","",OUTPUT qbf-k).

      IF qbf-new THEN
        ASSIGN
          qbf-rc#    	  = qbf-rc# + 1
          qbf-ix     	  = qbf-rc#
          qbf-rcg[qbf-ix] = ""
          qbf-rcl[qbf-ix] = (IF qbf-t = "r":u THEN "Running Total":t20
		                     ELSE "% Total":t20)
          qbf-rcf[qbf-ix] = (IF qbf-t = "p":u THEN "->>>9.9%":u
		                     ELSE ENTRY(2,qbf-k,CHR(10)))
          qbf-rcp[qbf-ix] = ",,,,,":u
          qbf-rcn[qbf-ix] = "qbf-" + STRING(qbf-ix,"999":u) + ",":u + qbf-c
          .
      ASSIGN
        qbf-rcc[qbf-ix]          = qbf-t
        qbf-rct[qbf-ix]          = INTEGER(ENTRY(1,qbf-k))
        ENTRY(2,qbf-rcn[qbf-ix]) = qbf-c
        qbf-chg                  = TRUE.
    END.
  END.

  WHEN "e":u THEN DO: /*------------------------------------ STACKED ARRAYS */
    qbf-c = "".
    RUN aderes/j-field1.p (qbf-tables,"#12345":u,
       "Add Field - Stacked Array":c32,"",
       INPUT-OUTPUT qbf-c, INPUT-OUTPUT junk).
  
    IF qbf-c <> "" THEN DO:
      RUN alias_to_tbname (qbf-c, TRUE, OUTPUT realtbl).

      RUN adecomm/_y-schem.p (realtbl,"","",OUTPUT qbf-k).

      IF qbf-new THEN
        ASSIGN
          qbf-rc#    	  = qbf-rc# + 1.

      ASSIGN
        qbf-ix     	  = qbf-rc#
        qbf-rcg[qbf-ix] = ""
        qbf-rcl[qbf-ix] = ENTRY(3,qbf-k,CHR(10))
        qbf-rcf[qbf-ix] = ENTRY(2,qbf-k,CHR(10))
        qbf-rcp[qbf-ix] = ",,,,,":u
        qbf-rcc[qbf-ix] = "e":u + ENTRY(2,qbf-k)
        qbf-rct[qbf-ix] = INTEGER(ENTRY(1,qbf-k))
        qbf-chg         = TRUE
        qbf-rcn[qbf-ix] = "qbf-":u + STRING(qbf-ix,"999":u) + ",":u + qbf-c
          .
    END.
  END.

  WHEN "x":u THEN DO: /*------------------------------------- LOOKUP FIELDS */
    ASSIGN
      qbf-1 = (IF qbf-ix = 0 THEN "" 
      	       ELSE ENTRY(2,qbf-rcn[qbf-ix]) + ".":u
                  + ENTRY(3,qbf-rcn[qbf-ix]))
      qbf-1p = qbf-1.
    RUN aderes/j-field1.p (qbf-tables, "$#@12345":u,
                           "Add Field - Lookup Source Field":c32, "", 
                           INPUT-OUTPUT qbf-1,INPUT-OUTPUT junk).
   
    IF qbf-1 <> "" THEN DO:
      ASSIGN
        edit_it = (qbf-ix <> 0 AND (qbf-1 = qbf-1p))
        qbf-2   = (IF NOT edit_it THEN "" ELSE
      	           ENTRY(4,qbf-rcn[qbf-ix]) + ".":u
                 + ENTRY(5,qbf-rcn[qbf-ix]))
        qbf-2p  = qbf-2.
        
      RUN alias_to_tbname (qbf-1, TRUE, OUTPUT realtbl).
      
      RUN adecomm/_y-schem.p (realtbl,"","",OUTPUT qbf-c).
      
      qbf-l = INTEGER(ENTRY(1,qbf-c)).
      
      RUN aderes/j-both.p (qbf-l,"","Add Field - Lookup Matching Field":c34,
      	       	     	     INPUT-OUTPUT qbf-2). 
      IF qbf-2 <> "" THEN DO:
        ASSIGN
          edit_it = (qbf-ix <> 0 AND (qbf-2 = qbf-2p))
      	  qbf-3 = (IF edit_it THEN ENTRY(4,qbf-rcn[qbf-ix]) + ".":u +
      	       	     	      	   ENTRY(6,qbf-rcn[qbf-ix]) ELSE "")
          qbf-4 = (IF edit_it THEN ENTRY(7,qbf-rcn[qbf-ix]) ELSE "?":u).
          
        RUN lookup_table
          (SUBSTRING(qbf-2,1,R-INDEX(qbf-2,".":u) - 1,"CHARACTER":u),
           OUTPUT qbf-i).
          
        RUN aderes/j-field1.p (STRING(qbf-i),"$#@12345":u,
          "Add Field - Lookup Display Field":c34,
      	  "&Value to display when there is no match:",
          INPUT-OUTPUT qbf-3, INPUT-OUTPUT qbf-4).
      END.    
    END. 
 
    IF qbf-3 <> "" THEN DO:
      /*
      qbf-1 = source-dbname.source-table.source-field
      qbf-2 = target-dbname.target-table.target-field
      qbf-3 = target-dbname.target-table.display-field
      #2 source-dbname.source-table,
      #3 source-field,
      #4 target-dbname.target-table,
      #5 target-field,
      #6 display-field
      #7 no-match value
      */
      RUN alias_to_tbname (qbf-3, TRUE, OUTPUT realtbl).
      
      RUN adecomm/_y-schem.p (realtbl,"","",OUTPUT qbf-c).

      IF qbf-new THEN
        ASSIGN
          qbf-rc#    	  = qbf-rc# + 1
          qbf-ix     	  = qbf-rc#
          qbf-rcg[qbf-ix] = ""
          qbf-rcp[qbf-ix] = ",,,,,":u
          qbf-rcn[qbf-ix] = "qbf-" + STRING(qbf-ix,"999":u) + ",":u
                          + ENTRY(1,qbf-1,".":u) + ".":u
                          + ENTRY(2,qbf-1,".":u) + ",":u
                          + ENTRY(3,qbf-1,".":u) + ",":u
                          + ENTRY(1,qbf-2,".":u) + ".":u
                          + ENTRY(2,qbf-2,".":u) + ",":u
                          + ENTRY(3,qbf-2,".":u) + ",":u
                          + ENTRY(3,qbf-3,".":u) + ",":u
                          + qbf-4
          .
      ASSIGN
        qbf-rcc[qbf-ix] = "x":u
        qbf-rcl[qbf-ix] = ENTRY(3,qbf-c,CHR(10))
        qbf-rcf[qbf-ix] = ENTRY(2,qbf-c,CHR(10))
        qbf-rct[qbf-ix] = INTEGER(ENTRY(1,qbf-c))
        qbf-rcn[qbf-ix] = ENTRY(1,qbf-rcn[qbf-ix]) + ",":u
                        + ENTRY(1,qbf-1,".":u) + ".":u
                        + ENTRY(2,qbf-1,".":u) + ",":u
                        + ENTRY(3,qbf-1,".":u) + ",":u
                        + ENTRY(1,qbf-2,".":u) + ".":u
                        + ENTRY(2,qbf-2,".":u) + ",":u
                        + ENTRY(3,qbf-2,".":u) + ",":u
                        + ENTRY(3,qbf-3,".":u) + ",":u
                        + qbf-4
        qbf-chg         = TRUE.
    END.
  END.

  OTHERWISE DO: /*---------------------------------------------- EXPRESSION */
    /* one of "s" "n" "d" "l" or "m" */

    RUN aderes/s-exp.p (qbf-t, (IF qbf-new THEN qbf-rc# + 1 ELSE qbf-ix),
      	       	        OUTPUT qbf-c,OUTPUT qbf-d,OUTPUT qbf-k).

    IF qbf-c <> ? AND qbf-c <> "" THEN DO:

      IF qbf-new THEN
        ASSIGN
          qbf-rc#         = qbf-rc# + 1
          qbf-ix          = qbf-rc#
          qbf-rcn[qbf-ix] = "qbf-":u + STRING(qbf-ix,"999":u) + ",":u + qbf-c
          .
      ELSE
        qbf-rcn[qbf-ix] = ENTRY(1,qbf-rcn[qbf-ix]) + ",":u + qbf-c.

      ASSIGN
        qbf-rcc[qbf-ix] = qbf-d + (IF qbf-k = "" THEN "" ELSE ",":u + qbf-k)
        qbf-rct[qbf-ix] = INDEX("sdl_n":u,qbf-d)
        qbf-chg         = TRUE
        .

      IF qbf-new THEN
        ASSIGN
          qbf-rcg[qbf-ix] = ""
          qbf-rcl[qbf-ix] = ENTRY(IF qbf-t = "m":u THEN 4 ELSE qbf-rct[qbf-ix],
                            TRIM("String Value":l16 ) + ",":u
                          + TRIM("Date Value":l16   ) + ",":u
                          + TRIM("Logical Value":l16) + ",":u
                          + TRIM("Math Value":l16   ) + ",":u
                          + TRIM("Numeric Value":l16))
          qbf-rcf[qbf-ix] = ENTRY(qbf-rct[qbf-ix],
		                    "x(15),99/99/99,":u
                          + "yes":t8 + "/":u + "no":t8
                          + ",,->>>>>>>9.99":u)
          qbf-rcp[qbf-ix] = ",,,,,":u
        .
    END.
  END.
END CASE.

IF qbf-chg AND qbf-new THEN DO:
  qbf-index  = qbf-rc#.
  RUN aderes/y-format.p (qbf-rc#,OUTPUT qbf-a).

  IF qbf-module = "l":u THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"information":u,"ok":u,
      "Choose Field->Add/Remove Fields to add the new calculated field to Label View.").
  ELSE IF CAN-DO("r,e":u,qbf-module) THEN
    qbf-redraw = TRUE.
END.

RETURN.

/*--------------------------------------------------------------------------*/
PROCEDURE show_graphic:
  ASSIGN
    qbf-d = TRIM(qbf-d:SCREEN-VALUE IN FRAME qbf-counter)
    qbf-i1:VISIBLE IN FRAME qbf-counter = (qbf-d = "<":u)
    qbf-i2:VISIBLE IN FRAME qbf-counter = (qbf-d = ">":u)
    qbf-i3:VISIBLE IN FRAME qbf-counter = (qbf-d = "*":u).
END PROCEDURE.

/*--------------------------------------------------------------------------*/
/* sub-proc to lookup file reference in relationship table */
{ aderes/p-lookup.i }

/*--------------------------------------------------------------------------*/
/* alias_to_tbname */
{ aderes/s-alias.i }

/* s-calc.p - end of file */

