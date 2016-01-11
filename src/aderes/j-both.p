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
 * j-both.p - pick both a table and a field
 */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/j-define.i }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

DEFINE INPUT PARAMETER qbf-d   AS INTEGER   NO-UNDO. /* datatype or 0 */
DEFINE INPUT PARAMETER qbf-g   AS CHARACTER NO-UNDO. /* ignore table or "" */
DEFINE INPUT PARAMETER qbf-ttl AS CHARACTER NO-UNDO. /* frame title */
DEFINE INPUT-OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO. /* db.table.field */

DEFINE VARIABLE tbl     AS CHARACTER NO-UNDO. /* table name */
DEFINE VARIABLE fld     AS CHARACTER NO-UNDO. /* field name */
DEFINE VARIABLE qbf-a   AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c   AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c&  AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-t   AS CHARACTER NO-UNDO. /* target table selection list */
DEFINE VARIABLE qbf-t&  AS CHARACTER NO-UNDO. /* target table selection list */
DEFINE VARIABLE qbf-f   AS CHARACTER NO-UNDO. /* target field selection list */
DEFINE VARIABLE qbf-f&  AS CHARACTER NO-UNDO. /* target field selection list */
DEFINE VARIABLE qbf-i   AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE max_len AS INTEGER   NO-UNDO. /* max length of table names */
DEFINE VARIABLE tbname  AS CHARACTER NO-UNDO. /* for macro */
DEFINE VARIABLE tbdesc  AS CHARACTER NO-UNDO. /* for macro */
DEFINE VARIABLE qbf-val AS CHARACTER NO-UNDO. /* screen value for macro */
DEFINE VARIABLE tTitle  AS CHARACTER NO-UNDO.
DEFINE VARIABLE fTitle  AS CHARACTER NO-UNDO.

DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"  {&STDPH_OKBTN}.

/* standard button rectangle */
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.

DEFINE TEMP-TABLE qbf-w NO-UNDO /* table/field cache */
  FIELD qbf-n AS CHARACTER /* table name */
  FIELD qbf-e AS CHARACTER /* comma-sep field list */
  FIELD qbf-l AS CHARACTER /* comma-sep label list */
  INDEX qbf-w-index IS UNIQUE PRIMARY qbf-n.

/* transforms "desc" to "desc (demo)" OR "desc" */
&GLOBAL-DEFINE DESC_INTERNAL_TO_SCREEN ~
   qbf-rel-buf.tdesc + (IF qbf-hidedb THEN "" ~
      ELSE " (":u + ENTRY(1,qbf-tnam,".":u) + ")":u)

/* transforms "demo.cust" to "cust (demo)" OR "cust" */
&GLOBAL-DEFINE INTERNAL_TO_SCREEN ~
   ENTRY(2,tbname,".":u) + ~
   (IF qbf-hidedb THEN "" ELSE ~
      FILL(" ":u, max_len - LENGTH(ENTRY(2,tbname,".":u),"RAW":u) + 1) + ~
      " (":u + ENTRY(1,tbname,".":u) + ")":u)

/* transforms "cust (demo)" to "demo.cust" OR "cust" to "demo.cust" */
&GLOBAL-DEFINE SCREEN_TO_INTERNAL ~
   (IF qbf-hidedb THEN LDBNAME(1) + ".":u + qbf-val ELSE ~
     TRIM(ENTRY(2,qbf-val,"(":u),")":u) + ".":u + TRIM(ENTRY(1,qbf-val,"(":u)))

&IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &THEN
  &GLOBAL-DEFINE FLD_COL   36
&ELSE  /* motif */
  &GLOBAL-DEFINE FLD_COL   38
&ENDIF

FORM
  SKIP({&TFM_WID})
  tTitle AT 2 	 
    VIEW-AS TEXT
    
  fTitle AT {&FLD_COL} 
    VIEW-AS TEXT SKIP({&VM_WID})
 
  qbf-t& AT 2
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 30 INNER-LINES 10 
    SCROLLBAR-V SCROLLBAR-H
       
  qbf-t AT ROW-OF qbf-t& COL-OF qbf-t&
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 30 INNER-LINES 10 
    SCROLLBAR-V SCROLLBAR-H
       
  qbf-f& AT {&FLD_COL}
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 30 INNER-LINES 10 
    SCROLLBAR-V SCROLLBAR-H
  SKIP
  
  qbf-f AT ROW-OF qbf-f& COL-OF qbf-f&
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 30 INNER-LINES 10 
    SCROLLBAR-V SCROLLBAR-H
  SKIP
  
  qbf-toggle2 AT 2  VIEW-AS TOGGLE-BOX LABEL "Show Table &Descriptions":t30
  qbf-toggle1 AT 36 VIEW-AS TOGGLE-BOX LABEL "Show Field &Labels":t30
  SKIP({&VM_WID})

  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  WITH FRAME qbf-both NO-ATTR-SPACE NO-LABELS THREE-D
  DEFAULT-BUTTON qbf-Ok CANCEL-BUTTON qbf-ee
  TITLE "Select Table and Field" VIEW-AS DIALOG-BOX.

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME qbf-both" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help"}

/*--------------------------------------------------------------------------*/

/* toggle1 is for fields */
ON VALUE-CHANGED OF qbf-toggle1 IN FRAME qbf-both 
  OR ALT-L OF FRAME qbf-both DO: 

  ASSIGN
    qbf-i          = IF qbf-toggle1 THEN
                      qbf-f&:LOOKUP(qbf-f&:SCREEN-VALUE) IN FRAME qbf-both
                     ELSE
                      qbf-f:LOOKUP(qbf-f:SCREEN-VALUE) IN FRAME qbf-both 
    qbf-i          = IF qbf-i = ? THEN 1 ELSE qbf-i                         
    qbf-toggle1    = INPUT FRAME qbf-both qbf-toggle1
    qbf-f&:VISIBLE = IF qbf-toggle1 THEN TRUE ELSE FALSE
    qbf-f:VISIBLE  = IF qbf-toggle1 THEN FALSE ELSE TRUE
    .
  IF qbf-toggle1 THEN
    qbf-f&:SCREEN-VALUE = ENTRY(qbf-i,
                            qbf-f&:LIST-ITEMS IN FRAME qbf-both,CHR(3)).
  ELSE
    qbf-f:SCREEN-VALUE  = ENTRY(qbf-i,
                            qbf-f:LIST-ITEMS  IN FRAME qbf-both,CHR(3)).

END.

/* toggle2 is for tables */
ON VALUE-CHANGED OF qbf-toggle2 IN FRAME qbf-both 
  OR ALT-D OF FRAME qbf-both DO:

  ASSIGN
    qbf-i          = IF qbf-toggle2 THEN
                      qbf-t&:LOOKUP(qbf-t&:SCREEN-VALUE) IN FRAME qbf-both
                     ELSE
                       qbf-t:LOOKUP(qbf-t:SCREEN-VALUE) IN FRAME qbf-both 
    qbf-i          = IF qbf-i = ? THEN 1 ELSE qbf-i                         
    qbf-toggle2    = INPUT FRAME qbf-both qbf-toggle2
    qbf-t&:VISIBLE = IF qbf-toggle2 THEN TRUE  ELSE FALSE
    qbf-t:VISIBLE  = IF qbf-toggle2 THEN FALSE ELSE TRUE
    .

  IF qbf-toggle2 THEN
    qbf-t&:SCREEN-VALUE = ENTRY(qbf-i,
                            qbf-t&:LIST-ITEMS IN FRAME qbf-both,CHR(3)).
  ELSE
    qbf-t:SCREEN-VALUE  = ENTRY(qbf-i,
                            qbf-t:LIST-ITEMS  IN FRAME qbf-both,CHR(3)).
END.

ON HELP OF FRAME qbf-both OR CHOOSE OF qbf-help IN FRAME qbf-both
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,
                          {&Select_Table_and_Field_Dlg_Box},?).

ON VALUE-CHANGED OF qbf-t, qbf-t& IN FRAME qbf-both DO:
  DEFINE VARIABLE tname AS CHARACTER NO-UNDO.

  IF qbf-toggle2 THEN DO:
    IF qbf-t& = SELF:SCREEN-VALUE THEN RETURN.
    qbf-t& = SELF:SCREEN-VALUE. 
  END. 
  ELSE DO:
    IF qbf-t = SELF:SCREEN-VALUE THEN RETURN.
    qbf-t = SELF:SCREEN-VALUE. 
  END.
  
  ASSIGN
    qbf-val = IF qbf-toggle2 THEN
                ENTRY(qbf-t&:LOOKUP(qbf-t&) IN FRAME qbf-both,
                      qbf-t:LIST-ITEMS IN FRAME qbf-both,CHR(3))
              ELSE
                qbf-t:SCREEN-VALUE IN FRAME qbf-both
    tname   = {&SCREEN_TO_INTERNAL}.

  FIND qbf-w WHERE qbf-w.qbf-n = tname NO-ERROR.
  IF NOT AVAILABLE qbf-w THEN DO:
    RUN load_up_field (tname).
    FIND qbf-w WHERE qbf-w.qbf-n = tname NO-ERROR.
  END.
  ELSE
    ASSIGN
      qbf-f:LIST-ITEMS IN FRAME qbf-both  = ""
      qbf-f&:LIST-ITEMS IN FRAME qbf-both = ""
      qbf-a = qbf-f:ADD-LAST(qbf-w.qbf-e) IN FRAME qbf-both
      qbf-a = qbf-f&:ADD-LAST(qbf-w.qbf-l) IN FRAME qbf-both
      qbf-f:SCREEN-VALUE IN FRAME qbf-both = ENTRY(1,qbf-w.qbf-e,CHR(3))
      qbf-f&:SCREEN-VALUE IN FRAME qbf-both = ENTRY(1,qbf-w.qbf-l,CHR(3)).
END.

ON DEFAULT-ACTION OF qbf-f IN FRAME qbf-both 
  APPLY "GO":u TO FRAME qbf-both.

ON GO OF FRAME qbf-both DO:
  ASSIGN
    qbf-val = IF qbf-toggle2 THEN
                ENTRY(qbf-t&:LOOKUP(qbf-t&) IN FRAME qbf-both,
                      qbf-t:LIST-ITEMS IN FRAME qbf-both,CHR(3))
              ELSE
                qbf-t:SCREEN-VALUE IN FRAME qbf-both
    qbf-t   = {&SCREEN_TO_INTERNAL}

    qbf-f   = IF qbf-toggle1 THEN
                ENTRY(qbf-f&:LOOKUP(qbf-f&:SCREEN-VALUE) IN FRAME qbf-both,
                      qbf-f:LIST-ITEMS IN FRAME qbf-both,CHR(3))
              ELSE
                qbf-f:SCREEN-VALUE IN FRAME qbf-both
    .
   
  IF qbf-t = ? OR qbf-f = ? THEN DO:
    BELL.
    RETURN NO-APPLY.
  END.
  qbf-o = qbf-t + ".":u + qbf-f.
END.

ON WINDOW-CLOSE OF FRAME qbf-both
  APPLY "END-ERROR":u TO SELF.             

/*-----------------------------Mainline----------------------------------*/
DEFINE VARIABLE tname AS CHARACTER NO-UNDO.

ASSIGN 
  qbf-t:DELIMITER  = CHR(3)
  qbf-t&:DELIMITER = CHR(3)
  qbf-f:DELIMITER  = CHR(3)
  qbf-f&:DELIMITER = CHR(3).
           
RUN adecomm/_setcurs.p ("WAIT":u).

DO ON ERROR UNDO, LEAVE:
  IF qbf-ttl <> "" THEN 
    FRAME qbf-both:TITLE = qbf-ttl.
 
  RUN load_up_table (OUTPUT qbf-c, OUTPUT qbf-c&).
 
  ASSIGN qbf-a = qbf-t:ADD-LAST(qbf-c)   IN FRAME qbf-both
         qbf-a = qbf-t&:ADD-LAST(qbf-c&) IN FRAME qbf-both.
   
  IF qbf-o <> "" THEN                    
    ASSIGN
      tbname = SUBSTRING(qbf-o,1,R-INDEX(qbf-o,".":u) - 1,"RAW":u)
      qbf-t  = {&INTERNAL_TO_SCREEN}
      qbf-t& = ENTRY(1,qbf-c&,CHR(3)).
  ELSE
    ASSIGN qbf-t  = ENTRY(1,qbf-c,CHR(3))
           qbf-t& = ENTRY(1,qbf-c&,CHR(3)).

  ASSIGN
      qbf-t:SCREEN-VALUE IN FRAME qbf-both  = qbf-t
      qbf-t&:SCREEN-VALUE IN FRAME qbf-both = qbf-t&
      qbf-val                               = qbf-t
      tname                                 = {&SCREEN_TO_INTERNAL}
      .

  RUN load_up_field ({&SCREEN_TO_INTERNAL}).

  PAUSE 0.
  VIEW FRAME qbf-both.
         
  DISPLAY qbf-toggle2 qbf-toggle1
    WITH FRAME qbf-both.
  
  ENABLE qbf-t qbf-t& qbf-f qbf-f& qbf-ok qbf-ee qbf-help 
    qbf-toggle1 qbf-toggle2
    WITH FRAME qbf-both.
     
  ASSIGN 
    qbf-t:SCREEN-VALUE  = ENTRY(1,qbf-t:LIST-ITEMS IN FRAME qbf-both,CHR(3)).

  APPLY "VALUE-CHANGED":u TO qbf-t       IN FRAME qbf-both.
  APPLY "VALUE-CHANGED":u TO qbf-toggle2 IN FRAME qbf-both.
  APPLY "VALUE-CHANGED":u TO qbf-toggle1 IN FRAME qbf-both.
END.                                                              

RUN adecomm/_setcurs.p ("").

ASSIGN 
  qbf-o               = ""
  tTitle:SCREEN-VALUE = "&Table"
  fTitle:SCREEN-VALUE = "&Field".
       
DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  WAIT-FOR GO OF FRAME qbf-both.
END.

HIDE FRAME qbf-both NO-PAUSE.
RETURN.

/*==========================Internal Procedures=============================*/

/* compose a comma separated list of tables */

PROCEDURE load_up_table:
  DEFINE OUTPUT PARAMETER qbf_o  AS CHARACTER NO-UNDO. /* list of tables */
  DEFINE OUTPUT PARAMETER qbf_o& AS CHARACTER NO-UNDO. /* list of tables */

  DEFINE VARIABLE qbf_a   AS LOGICAL                 NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_c   AS CHARACTER INITIAL "y":u NO-UNDO. /* scrap */
  DEFINE VARIABLE realtbl AS CHAR                    NO-UNDO. 

  max_len = 0.

  IF NOT qbf-hidedb THEN
    FOR EACH qbf-rel-buf where qbf-rel-buf.cansee USE-INDEX tnameix:
      max_len = MAXIMUM(max_len,LENGTH(ENTRY(2,qbf-rel-buf.tname,".":u),
                                       "RAW":u)).
    END.
    
  FOR EACH qbf-rel-buf where qbf-rel-buf.cansee USE-INDEX tnameix:
  
    IF qbf-rel-buf.tdesc = "" THEN DO:
      { aderes/getdesc.i }

      /*  keep for possible use - J.M. Springer 5/11/95
      ASSIGN
        qbf-tnam          = qbf-rel-buf.tname
        qbf-rel-buf.tdesc = {&DESC_INTERNAL_TO_SCREEN}.
      */
    END.

    IF qbf-d > 0 THEN DO:                                            
      RUN alias_to_tbname (qbf-rel-buf.tname, FALSE, OUTPUT realtbl).
      RUN aderes/s-schema.p (realtbl,"","","FILE:HAS-TYPE:":u + STRING(qbf-d),
               	     	     OUTPUT qbf_c).
    END.
  
    qbf_a = (qbf_c = "y":u AND qbf-rel-buf.tname <> qbf-g).
    
    IF qbf_a THEN DO:
      ASSIGN
        tbname = qbf-rel-buf.tname
        qbf_o = qbf_o + (IF qbf_o = "" THEN "" ELSE CHR(3))
              + {&INTERNAL_TO_SCREEN}
        tbdesc = qbf-rel-buf.tdesc
        qbf_o& = qbf_o& + (IF qbf_o& = "" THEN "" ELSE CHR(3))
              + qbf-rel-buf.tdesc.
    END.
  END.
END PROCEDURE. /* load_up_table */

/*---------------------------------------------------------------------------*/
PROCEDURE load_up_field:
  DEFINE INPUT PARAMETER qbf_n AS CHARACTER NO-UNDO. /* table name */
  
  DEFINE VARIABLE qbf_c     AS CHARACTER NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf-b     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE i         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE fList     AS CHARACTER NO-UNDO. /* field list */
  DEFINE VARIABLE lList     AS CHARACTER NO-UNDO. /* label list */
  DEFINE VARIABLE lookAhead AS CHARACTER NO-UNDO. 

  CREATE qbf-w.
  qbf-w.qbf-n = qbf_n.

  RUN alias_to_tbname (qbf_n,TRUE,OUTPUT qbf_n).
  
  CREATE ALIAS "DICTDB":u FOR DATABASE VALUE(SDBNAME(ENTRY(1,qbf_n,".":u))).
  
  RUN adecomm/_a-schem.p (ENTRY(1,qbf_n,".":u),
                          ENTRY(2,qbf_n,".":u),
                          STRING(qbf-d),
                          OUTPUT lList, /* label list */
                          OUTPUT fList  /* field list */).
   
  /* Loop through field list to see if user has permission to use field. */
  IF _fieldCheck <> ? THEN DO:
    hook:
    DO ON STOP UNDO hook, RETRY hook:
      IF RETRY THEN DO:
        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-b,"error":u,"ok":u,
          SUBSTITUTE("There is a problem with &1. &2 will use default field security.",_fieldCheck,qbf-product)).
        _fieldCheck = ?.
        LEAVE hook.
      END.

      DO i = 1 to NUM-ENTRIES(fList):
        qbf-b = TRUE.
        RUN VALUE(_fieldCheck) (qbf-n,
                                ENTRY(i, fList), 
                                USERID(ENTRY(1,qbf-n,".":u)),
                                OUTPUT qbf-b).
        IF qbf-b THEN DO:
          qbf-w.qbf-e = qbf-w.qbf-e + lookAhead + ENTRY(i, fList).
          qbf-w.qbf-l = qbf-w.qbf-l + lookAhead + ENTRY(i, lList).
          lookAhead = ",":u.
        END.
      END.
    END.
  END.
  ELSE
    ASSIGN
      qbf-w.qbf-e = fList
      qbf-w.qbf-l = lList.

  ASSIGN
    qbf-w.qbf-l = REPLACE(qbf-w.qbf-l,",":u,CHR(3))
    qbf-w.qbf-e = REPLACE(qbf-w.qbf-e,",":u,CHR(3))
    qbf-f:LIST-ITEMS IN FRAME qbf-both  = qbf-w.qbf-e
    qbf-f&:LIST-ITEMS IN FRAME qbf-both = qbf-w.qbf-l
    qbf-f:SCREEN-VALUE IN FRAME qbf-both  = ENTRY(1,qbf-w.qbf-e,CHR(3))
    qbf-f&:SCREEN-VALUE IN FRAME qbf-both = ENTRY(1,qbf-w.qbf-l,CHR(3)).
END PROCEDURE. /* load_up_field */

/*--------------------------------------------------------------------------*/
/* alias_to_tbname */
{ aderes/s-alias.i }

/* j-both.p - end of file */

