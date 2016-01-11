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
/*
 * j-field1.p - single field picker
 */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/j-clump.i NEW }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

/*      Available Fields
+---------------------------------+
| Cust-num  (demo.customer)     | |
| Name      (demo.customer)     | |
| Address   (demo.customer)     | |
| Address2  (demo.customer)     | |
| City      (demo.customer)     | |
| St        (demo.customer)     | | +--------+
| Zip       (demo.customer)     | | |   OK   |
| Phone     (demo.customer)     | | +--------+
| Contact   (demo.customer)     | | +--------+
| Sales-rep (demo.customer)     | | | Cancel |
+---------------------------------+ +--------+
*/

/*
qbf-t - list of table ids to show fields for.

qbf-p is parameter string:
   contains "$" - allow scalar database fields
   contains "#" - allow array database fields
   contains "@" - allow z-array expansion
   contains any of "rpcsdnlex" - allow that type of calc field:
		  r=running_total, p=pct_of_total, c=counter,
		  s=string_exp, d=date_exp, n=numeric_exp, l=logical_exp,
		  e=stacked_array, x=lookup_field
   contains any of "12345" - allow that dtype:
		  1=char 2=date 3=log 4=int 5=dec
   contains "=" - shorthand for all calc-fields and all database fields
		  same as "rpcsdnlex12345"

   qbf-lbl is a label for an extra fill-in field. If this is "",
   the fill-in will be squashed out of the dialog.  qbf-fill is the
   initial value for this fill-in.  On output, it is updated to the 
   new fill-in value.

   qbf-o will be set to "" if cancel was hit.
*/

DEFINE INPUT        PARAMETER qbf-t    AS CHARACTER NO-UNDO. /* table list */
DEFINE INPUT        PARAMETER qbf-p    AS CHARACTER NO-UNDO. /* param string */
DEFINE INPUT        PARAMETER qbf-ttl  AS CHARACTER NO-UNDO. /* title */
DEFINE INPUT        PARAMETER qbf-lbl  AS CHARACTER NO-UNDO. /* fill-in lbl */
DEFINE INPUT-OUTPUT PARAMETER qbf-o    AS CHARACTER NO-UNDO. /* output name */
DEFINE INPUT-OUTPUT PARAMETER qbf-fill AS CHARACTER NO-UNDO. /* fill-in val */

DEFINE VARIABLE qbf-b    AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c    AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-h    AS LOGICAL   NO-UNDO. /* hide file names? */
DEFINE VARIABLE qbf-i    AS INTEGER   NO-UNDO. /* scrap/loop */
DEFINE VARIABLE qbf-j    AS INTEGER   NO-UNDO. /* scrap/loop */
DEFINE VARIABLE qbf-hlp  AS INTEGER   NO-UNDO. /* help context */
DEFINE VARIABLE qbf-l    AS INTEGER   NO-UNDO. /* max label length per table */
DEFINE VARIABLE qbf-n    AS INTEGER   NO-UNDO. /* max name length */
DEFINE VARIABLE qbf-x    AS INTEGER   NO-UNDO. /* max extent */
DEFINE VARIABLE hdl      AS HANDLE    NO-UNDO. /* widget handle */
DEFINE VARIABLE mov-ht   AS DECIMAL   NO-UNDO. /* height to shift */
DEFINE VARIABLE tfName   AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-s    AS CHARACTER NO-UNDO. /* "available fields" sellist */
DEFINE VARIABLE qbf-s&   AS CHARACTER NO-UNDO. /* "available fields" descs */
DEFINE VARIABLE lst-ix   AS INTEGER   NO-UNDO INIT 1.  /* previous selection */
DEFINE VARIABLE qbf-sel  AS CHARACTER NO-UNDO . /* initial selection */
DEFINE VARIABLE qbf-sel& AS CHARACTER NO-UNDO .

DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"  {&STDPH_OKBTN}.
/* standard button rectangle */
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.

/*--------------------------------------------------------------------------*/

FORM
  SKIP({&TFM_WID})
  qbf-s& AT 2
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 48 INNER-LINES 10
    SCROLLBAR-V SCROLLBAR-H FONT 0
  qbf-s AT ROW-OF qbf-s& COL-OF qbf-s& 
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 48 INNER-LINES 10
    SCROLLBAR-V SCROLLBAR-H FONT 0
  SKIP({&VM_WID})

  qbf-toggle1 AT 2
    LABEL "Show Field &Labels"
    VIEW-AS TOGGLE-BOX
  SKIP({&VM_WID})

  qbf-lbl  AT 2 
    VIEW-AS TEXT FORMAT "X(48)":u
    
  SKIP({&VM_WID})
  qbf-fill AT 2 FORMAT "X(48)":u

  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  WITH FRAME qbf-fld NO-LABELS KEEP-TAB-ORDER THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  TITLE "Available Fields" VIEW-AS DIALOG-BOX.

/*--------------------------------------------------------------------------*/

ON HELP OF FRAME qbf-fld OR CHOOSE OF qbf-help IN FRAME qbf-fld
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,qbf-hlp,?).

ON DEFAULT-ACTION OF qbf-s, qbf-s& IN FRAME qbf-fld
  APPLY "GO":u TO FRAME qbf-fld.

ON ALT-V of FRAME qbf-fld
  APPLY "ENTRY":u TO qbf-fill IN FRAME qbf-fld.

ON GO OF FRAME qbf-fld DO:
  DEFINE VARIABLE qbf_v   AS CHARACTER NO-UNDO. /* value */
  DEFINE VARIABLE qbf_p   AS CHARACTER NO-UNDO. /* part in parens */
  DEFINE VARIABLE qbf_n   AS CHARACTER NO-UNDO. /* not in parens */
  DEFINE VARIABLE realtbl AS CHAR      NO-UNDO. 

  qbf_v = (IF qbf-toggle1 THEN
	     qbf-s&:SCREEN-VALUE IN FRAME qbf-fld
	   ELSE
	     qbf-s:SCREEN-VALUE IN FRAME qbf-fld
	  ).

  ASSIGN
    qbf-fill = qbf-fill:SCREEN-VALUE IN FRAME qbf-fld 
    qbf-c = STRING(qbf-toggle1,"y/n":u)
	  + STRING(qbf-h      ,"y/n":u)
	  + STRING(qbf-hidedb ,"y/n":u).
      /* Note: "yyn" or "nyn" should never happen. */

  FIND FIRST qbf-clump WHERE qbf-clump.qbf-cfil > 0 NO-ERROR.
  IF AVAILABLE qbf-clump THEN
    {&FIND_TABLE_BY_ID} qbf-clump.qbf-cfil.
  ASSIGN
    qbf-o = (IF AVAILABLE qbf-clump THEN qbf-rel-buf.tname ELSE "").

  /* When show labels, qbf_p is field or table.field or db.table.field
		       qbf_n is the label
     When show field,  qbf_p is table or db.table or nothing
		       qbf_n is the field name.
  */
  IF qbf-c <> "nyy":u THEN /* only variation w/no parens at all */
    ASSIGN
      qbf_p = SUBSTRING(qbf_v, R-INDEX(qbf_v,"(":u) + 1,
	LENGTH(qbf_v,"CHARACTER":u) - R-INDEX(qbf_v,"(":u) - 1,"CHARACTER":u)
      qbf_n = TRIM(SUBSTRING(qbf_v,1,R-INDEX(qbf_v,"(":u) - 1,"CHARACTER":u)).
      
  /* can't rely on qbf_p = "Calc Field", especially in other languages, so
     check qbf-rcn array to see if this is a calculated field -dma */
  DO qbf-i = 1 TO qbf-rc#:
    IF qbf_n = ENTRY(1,qbf-rcn[qbf-i]) THEN LEAVE.
  END.
  IF qbf-i <= qbf-rc# AND qbf-rcc[qbf-i] > "" THEN
    qbf-o = qbf_n.
    
  ELSE DO:
    CASE qbf-c:
      WHEN "yyy":u THEN /* labels, no table, no db */
	qbf-o = qbf-o + ".":u + qbf_p.
      WHEN "nyy":u THEN /* fields, no table, no db */
	qbf-o = qbf-o + ".":u + qbf_v.
      WHEN "yny":u THEN /* labels, table, no db */
	qbf-o = ENTRY(1,qbf-o,".":u) + ".":u + qbf_p.
      WHEN "nny":u THEN /* fields, table, no db */
	qbf-o = ENTRY(1,qbf-o,".":u) + ".":u + qbf_p + ".":u + qbf_n.
      WHEN "ynn":u THEN /* labels, table, db */
	qbf-o = qbf_p.
      WHEN "nnn":u THEN /* fields, table, db */
	qbf-o = qbf_p + ".":u + qbf_n.
    END CASE.
  END.
END.

ON VALUE-CHANGED OF qbf-s, qbf-s& IN FRAME qbf-fld 
  lst-ix = SELF:LOOKUP(SELF:SCREEN-VALUE) IN FRAME qbf-fld.

ON VALUE-CHANGED OF qbf-toggle1 IN FRAME qbf-fld DO:
  DEFINE VARIABLE widg AS HANDLE NO-UNDO.

  ASSIGN
    qbf-toggle1                     = INPUT FRAME qbf-fld qbf-toggle1
    qbf-s:VISIBLE IN FRAME qbf-fld  = NOT qbf-toggle1
    qbf-s&:VISIBLE IN FRAME qbf-fld = qbf-toggle1.

  IF qbf-toggle1 THEN 
    ASSIGN
      qbf-s&:SCREEN-VALUE IN FRAME qbf-fld =
	    qbf-s&:ENTRY(lst-ix) IN FRAME qbf-fld
      widg = qbf-s&:HANDLE IN FRAME qbf-fld.
  ELSE 
    ASSIGN
      qbf-s:SCREEN-VALUE IN FRAME qbf-fld  =  
	    qbf-s:ENTRY(lst-ix) IN FRAME qbf-fld
      widg = qbf-s:HANDLE IN FRAME qbf-fld.

  RUN adecomm/_scroll.p (widg,widg:SCREEN-VALUE).
END.

ON WINDOW-CLOSE OF FRAME qbf-fld
  APPLY "END-ERROR":u TO SELF.             

/*---------------------------Mainline-----------------------------------*/

RUN adecomm/_setcurs.p ("WAIT":u).

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
  &FRAME = "FRAME qbf-fld" 
  &BOX   = "rect_btns"
  &OK    = "qbf-ok" 
  &HELP  = "qbf-help" }

DO ON ERROR UNDO, LEAVE:
  IF INDEX(qbf-ttl,"insert") > 0 THEN 
    qbf-hlp = {&Choose_Field_to_Insert_Dlg_Box}. 
  ELSE IF INDEX(qbf-ttl,"running") > 0 THEN 
    qbf-hlp = {&Running_Totals_Dlg_Box}.
  ELSE IF INDEX(qbf-ttl,"percent") > 0 THEN 
    qbf-hlp = {&Percent_of_Total_Dlg_Box}.
  ELSE IF INDEX(qbf-ttl,"stacked") > 0 THEN 
    qbf-hlp = {&Stacked_Arrays_Dlg_Box}.
  ELSE IF INDEX(qbf-ttl,"source") > 0  THEN 
    qbf-hlp = {&Lookup_Field_Source_Dlg_Box}.
  ELSE IF INDEX(qbf-ttl,"display") > 0 THEN 
    qbf-hlp = {&Lookup_Field_Display_Dlg_Box}. 
  ELSE 
    qbf-hlp = {&Contents_Main}.     

  ASSIGN
    qbf-s:DELIMITER IN FRAME qbf-fld  = CHR(3)
    qbf-s&:DELIMITER IN FRAME qbf-fld = CHR(3).

  RUN aderes/j-clump.p (qbf-p,qbf-t).
  
  qbf-h = qbf-hidedb. /* if db hidden, then maybe table also can be hidden? */
  FIND FIRST qbf-clump NO-ERROR.
  IF NOT AVAILABLE qbf-clump THEN DO:
    RUN adecomm/_setcurs.p ("").
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-b,"error":u,"ok":u,
      "There are no fields of the desired type to choose from.").
    RETURN.
  END.
  IF qbf-clump.qbf-cfil = 0 THEN qbf-h = FALSE. /* if calc present, don't */
  FIND NEXT qbf-clump NO-ERROR.
  IF AVAILABLE qbf-clump THEN qbf-h = FALSE. /* if >1 table present, don't */

  FOR EACH qbf-clump:
    IF qbf-clump.qbf-cfil <> 0 THEN
      {&FIND_TABLE_BY_ID} qbf-clump.qbf-cfil.
    ASSIGN
      qbf-c = (IF qbf-clump.qbf-cfil = 0 THEN
		".":u + "Calc Field":t16
	      ELSE
		qbf-rel-buf.tname
	      )
      qbf-c = (IF qbf-hidedb THEN ENTRY(2,qbf-c,".":u) ELSE qbf-c)
      qbf-l = 0
      qbf-n = 0.

    /* calculate maximum label (qbf-l) or field name (qbf-n) width */
    DO qbf-i = 1 TO qbf-csiz BY 4: /* by 4's for better speed */
      ASSIGN
	qbf-l = MAXIMUM(qbf-l,
		  LENGTH(qbf-clump.qbf-clbl[qbf-i],"RAW":u),
		  LENGTH(qbf-clump.qbf-clbl[qbf-i + 1],"RAW":u),
		  LENGTH(qbf-clump.qbf-clbl[qbf-i + 2],"RAW":u),
		  LENGTH(qbf-clump.qbf-clbl[qbf-i + 3],"RAW":u)
		)
	qbf-n = MAXIMUM(qbf-n,
		  LENGTH(qbf-clump.qbf-cnam[qbf-i],"RAW":u),
		  LENGTH(qbf-clump.qbf-cnam[qbf-i + 1],"RAW":u),
		  LENGTH(qbf-clump.qbf-cnam[qbf-i + 2],"RAW":u),
		  LENGTH(qbf-clump.qbf-cnam[qbf-i + 3],"RAW":u)
		).
    END.

    DO qbf-i = 1 TO qbf-csiz:
      /* Does the user have permission to see the field */
      qbf-b = TRUE.
      IF _fieldCheck <> ? THEN DO:
	hook:
	DO ON STOP UNDO hook, RETRY hook:
	  IF RETRY THEN DO:
	    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-b,"error":u,"ok":u,
	      SUBSTITUTE("There is a problem with &1. &2 will use default field security.",_fieldCheck,qbf-product)).
	    _fieldCheck = ?.
	    LEAVE hook.
	  END.

	  RUN VALUE(_fieldCheck) (qbf-rel-buf.tname,
				  qbf-clump.qbf-cnam[qbf-i], 
				  USERID(ENTRY(1,qbf-rel-buf.tname,".":u)),
				  OUTPUT qbf-b).
	END.
      END.

      IF NOT qbf-b THEN NEXT.

      /* contains "@" - allow array expansion */
      IF qbf-clump.qbf-cext[qbf-i] = 0 OR INDEX(qbf-p,"@":u) = 0 THEN 
	RUN add_item (qbf-clump.qbf-cnam[qbf-i],
		      qbf-clump.qbf-clbl[qbf-i],qbf-c).
      ELSE
	DO qbf-j = 1 TO qbf-clump.qbf-cext[qbf-i]:
	  RUN add_item (qbf-clump.qbf-cnam[qbf-i] + "[":u 
			  + STRING(qbf-j) + "]":u, 
			qbf-clump.qbf-clbl[qbf-i],qbf-c).
	END.
    END.
  END.
  
  PAUSE 0.
  IF qbf-ttl <> "" THEN 
    FRAME qbf-fld:TITLE = qbf-ttl.
  
  IF qbf-lbl = "" THEN DO:
    /* We have to move everything up to squish out the space for the
       fill-in that isn't there!.
    */
    ASSIGN
      mov-ht = qbf-fill:HEIGHT IN FRAME qbf-fld + 
	       qbf-lbl:HEIGHT IN FRAME qbf-fld + ({&VM_WID} * 2)
      qbf-lbl:VISIBLE IN FRAME qbf-fld = NO
      qbf-fill:VISIBLE IN FRAME qbf-fld = NO
      hdl = qbf-ok:HANDLE in FRAME qbf-fld.     /* 1st widget to move */
  
    DO WHILE (hdl NE ?):
      ASSIGN
	hdl:ROW = hdl:ROW - mov-ht
	hdl     = hdl:NEXT-SIBLING.
    END.
  
    ASSIGN
      FRAME qbf-fld:SCROLLABLE = false
      &IF {&OKBOX} &THEN
      rect_btns:ROW IN FRAME qbf-fld = 
      rect_btns:ROW IN FRAME qbf-fld - mov-ht
      &ELSE
      FRAME qbf-fld:RULE-ROW = FRAME qbf-fld:RULE-ROW - mov-ht
      &ENDIF
      FRAME qbf-fld:HEIGHT = FRAME qbf-fld:HEIGHT - mov-ht.
  END.
END. /* end do on error block */

RUN adecomm/_setcurs.p ("").

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  DISPLAY qbf-toggle1 
	  qbf-lbl WHEN qbf-lbl <> ""
	  qbf-fill WHEN qbf-lbl <> ""
	  WITH FRAME qbf-fld.
  ASSIGN
    qbf-s:VISIBLE IN FRAME qbf-fld       = NOT qbf-toggle1
    qbf-s:SENSITIVE IN FRAME qbf-fld     = YES
    qbf-s:SCREEN-VALUE IN FRAME qbf-fld  = (IF qbf-sel = "" THEN
					    qbf-s:ENTRY(1) IN FRAME qbf-fld
					    ELSE qbf-sel)
    qbf-s&:VISIBLE IN FRAME qbf-fld      = qbf-toggle1
    qbf-s&:SENSITIVE IN FRAME qbf-fld    = YES
    qbf-s&:SCREEN-VALUE IN FRAME qbf-fld = (IF qbf-sel& = "" THEN
					    qbf-s&:ENTRY(1) IN FRAME qbf-fld
					    ELSE qbf-sel&)
    .

  ENABLE qbf-toggle1 
	 qbf-fill WHEN qbf-lbl <> ""
	 qbf-ok qbf-ee qbf-help
	 WITH FRAME qbf-fld.

  IF qbf-toggle1 THEN
    APPLY "ENTRY":u TO qbf-s& IN FRAME qbf-fld.
  ELSE
    APPLY "ENTRY":u TO qbf-s IN FRAME qbf-fld.

  qbf-o = "".
  WAIT-FOR CHOOSE OF qbf-ok IN FRAME qbf-fld OR GO OF FRAME qbf-fld.
END.

HIDE FRAME qbf-fld NO-PAUSE.
RETURN.

/*--------------------------------------------------------------------------*/
PROCEDURE add_item:
  DEFINE INPUT PARAMETER p_name AS CHAR NO-UNDO. /* field name */
  DEFINE INPUT PARAMETER p_lbl  AS CHAR NO-UNDO. /* field label */
  DEFINE INPUT PARAMETER p_qual AS CHAR NO-UNDO. /* field qualifier */
 
  DEFINE VARIABLE scrval AS CHARACTER NO-UNDO.
  DEFINE VARIABLE setsel AS LOGICAL   NO-UNDO INIT NO. 

  ASSIGN
    scrval = p_name
	   + (IF qbf-h THEN ""
	      ELSE FILL(" ":u,qbf-n - LENGTH(p_name,"RAW":u)) 
		   + " (":u + p_qual + ")":u)
    qbf-b  = qbf-s:ADD-LAST(scrval) IN FRAME qbf-fld.
    
  IF (IF qbf-hidedb THEN LDBNAME(1) + "." ELSE "") +
    p_qual + ".":u + p_name = qbf-o THEN
    ASSIGN
      setsel  = YES
      lst-ix  = qbf-s:NUM-ITEMS IN FRAME qbf-fld 
      qbf-sel = scrval.
      
  ASSIGN
    scrval = p_lbl
	       + FILL(" ":u,qbf-l - LENGTH(p_lbl,"RAW":u))
	       + " (":u
	   + (IF qbf-h THEN "" ELSE p_qual + ".")
	       + p_name
	       + ")":u
    qbf-b = qbf-s&:ADD-LAST(scrval) IN FRAME qbf-fld.
  IF setsel THEN
    qbf-sel& = scrval.
END.

/*--------------------------------------------------------------------------*/
/* alias_to_tbname */
{ aderes/s-alias.i }

/*--------------------------------------------------------------------------*/

/* j-field1.p - end of file */

