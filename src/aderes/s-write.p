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
 * s-write.p - write out query file to OS
 *           - write generic view object header and then call the
 *             routine to output view specific code.
 *
 * Input Parameters:
 *    qbf-f - File name we're outputting to.
 *    usage - Indicates what the output file will be used for.
 *
 *            "g"  for a generated .p for use outside RESULTS.
 *    	      "r"  for running during a RESULTS session, 
 *    	      "rr" for running during a RESULTS session during window resize, 
 *                 browse view only, to prevent reasking ask-at-runtime
 *            "s"  for a saved query, or
 */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/e-define.i }
{ aderes/l-define.i }
{ aderes/r-define.i }
{ aderes/fbdefine.i }

DEFINE INPUT PARAMETER qbf-f AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER usage AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-a   AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c   AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-d   AS LOGICAL   NO-UNDO. /* day names needed? */
DEFINE VARIABLE qbf-i   AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-j   AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-m   AS LOGICAL   NO-UNDO. /* month names used? */
DEFINE VARIABLE db-lst  AS CHARACTER NO-UNDO.
DEFINE VARIABLE db-nam  AS CHARACTER NO-UNDO.
DEFINE VARIABLE g-mode  AS LOGICAL   NO-UNDO. /* true=dynamic,false=static */
DEFINE VARIABLE retval  AS CHARACTER NO-UNDO INIT "Ok".
DEFINE VARIABLE switch  AS CHARACTER NO-UNDO.


problemo:
DO ON ERROR UNDO problemo, RETRY problemo:
  IF RETRY THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
      SUBSTITUTE("There is a problem writing &1.  The file will not be created.",qbf-f)).
    RETURN "Error: No Write":u.
  END.

  FIND FIRST qbf-esys.
  FIND FIRST qbf-lsys.
  FIND FIRST qbf-rsys WHERE qbf-rsys.qbf-live.

  /* Ask-At-Runtime setup.  Generate dialog box code (s-ask.p), then RUN code
     and PROMPT user for value(s) (c-ask.p).  Do this stuff BEFORE output 
     stream is opened, so any errors generated here don't wind up in qbf.p 
     -dma */
  IF usage <> "s":u THEN DO:

    IF usage = "g":u THEN DO:
      /* check for any ask-at-runtime phrases */
      qbf-a = FALSE.
      FOR EACH qbf-where:
        IF INDEX(qbf-where.qbf-wcls,"/*":u) > 0
          AND INDEX(qbf-where.qbf-wcls,"*/":u) > 0 THEN DO:
          qbf-a = TRUE.
          LEAVE.
        END.
      END.

      IF qbf-a THEN 
        RUN adecomm/_s-alert.p (INPUT-OUTPUT g-mode,"question":u,"yes-no":u,
          "An Ask-At-Runtime phrase was detected in your query. Choose YES to prompt for data selection values when the generated code is run or NO to prompt for the values now.").
    END.

    IF (qbf-module = "b":u AND usage <> "rr":u) 
      OR CAN-DO("r,f,l,e":u,qbf-module) THEN DO:
      qbf-a = TRUE.
        RUN aderes/s-ask.p (qbf-f, g-mode, INPUT-OUTPUT qbf-a).
      IF qbf-a THEN DO:
        RUN adecomm/_setcurs.p ("WAIT":u).
        RUN aderes/c-ask.p (g-mode).
      END.
      ELSE
        RETURN "".
    END.
  END.

  /* restore "running" usage to single "r" */
  ASSIGN usage = IF usage = "rr":u THEN "r":u ELSE usage.

  IF usage = "g":u AND g-mode THEN
    OUTPUT TO VALUE(qbf-f) APPEND NO-ECHO NO-MAP.
  ELSE
    OUTPUT TO VALUE(qbf-f) NO-ECHO NO-MAP.

  DO qbf-i = 1 TO qbf-rc#:
    ASSIGN
      qbf-d = qbf-d OR INDEX(qbf-rcn[qbf-i],"qbf-day-names":u) > 0
      qbf-m = qbf-m OR INDEX(qbf-rcn[qbf-i],"qbf-month-names":u) > 0.
  END.

  /*---------------------- Begin output comment section ----------------------*/

  IF NOT CAN-DO("g,r":u,usage) THEN DO: 
    /*
    databases= "demo,sports"
    config= query
    version= 2.0G
    results.view-as= browse
    results.name= "sample query"
    results.summary= false
    results.detail-level= 0
    results.governor = 0
    results.govergen = false
    */
  
    PUT UNFORMATTED
      '/*':u SKIP.

    DO qbf-i = 1 TO NUM-ENTRIES(qbf-tables):
      {&FIND_TABLE_BY_ID} INTEGER(ENTRY(qbf-i, qbf-tables)).
      ASSIGN
        db-nam = qbf-rel-buf.tname
        db-nam = SUBSTRING(db-nam,1,INDEX(db-nam,".":u) - 1,"CHARACTER":u).
       
      IF NOT CAN-DO(db-lst, db-nam) THEN
        db-lst = db-lst + (IF db-lst <> "" THEN ",":u ELSE "") + db-nam.
    END.
    
    PUT UNFORMATTED 'databases= ':u.
    EXPORT db-lst.

    PUT UNFORMATTED
      'config= query':u SKIP
      'version= ':u              qbf-vers SKIP
      'results.status-area= ':u  STRING(lGlbStatus,"true/false":u) SKIP
      'results.toolbar= ':u      STRING(lGlbToolbar,"true/false":u) SKIP
      'results.summary= ':u      STRING(qbf-summary,"true/false":u) SKIP
      'results.governor= ':u     STRING(qbf-governor) SKIP
      'results.govergen= ':u     STRING(qbf-govergen,"true/false":u) SKIP
      'results.detail-level= ':u qbf-detail SKIP
      'results.name= ':u
      .
      
    EXPORT qbf-name.
    PUT UNFORMATTED
      'results.view-as= ':u
      ENTRY(INDEX("beflr":u,qbf-module),"browse,export,form,label,report":u) 
      SKIP
      .
    /*------------------------------------------------------------------------*/

    DO qbf-i = 1 TO NUM-ENTRIES(qbf-tables):

      FIND FIRST qbf-where
        WHERE qbf-where.qbf-wtbl = INTEGER(ENTRY(qbf-i,qbf-tables)) NO-ERROR.
      
      {&FIND_TABLE_BY_ID} INTEGER(ENTRY(qbf-i,qbf-tables)).
      qbf-c = qbf-rel-buf.tname.
    
      PUT UNFORMATTED 'results.table[':u qbf-i ']= ':u.

      /* ???? Should this call to get security even be here? What
       * about the admin defined WHERE clause. Should they be written out
       * or rebuilt after this output is read back in? I'm doing the latter
       * for now!
       */

      IF _whereSecurity <> ?
        AND AVAILABLE qbf-where
        AND qbf-where.qbf-wcls <> "" THEN
        RUN VALUE(_whereSecurity) (qbf-c, USERID(ENTRY(1,qbf-c,".":u)),
                                   OUTPUT qbf-where.qbf-wsec).

      IF AVAILABLE qbf-where THEN
        EXPORT
          qbf-c
          qbf-rel-buf.crc
          qbf-where.qbf-wrel
          qbf-where.qbf-wcls
          qbf-where.qbf-wojo
          qbf-where.qbf-winc.
      ELSE
        EXPORT qbf-c qbf-rel-buf.crc "":u "":u FALSE "":u.
        
      /*
       * Now worry about the customized table selection
       */
      
      IF length(qbf-rel-choice) > 0 THEN DO:
        /*
         * Loop through all the possibilites
         */
        
        DO qbf-j = 1 to NUM-ENTRIES(qbf-rel-choice):
        
          /*
           * Does the table match the current table
           */
          
          switch = ENTRY(qbf-j, qbf-rel-choice).
          
          IF INTEGER(ENTRY(1, switch, ":":u)) = qbf-rel-buf.tid THEN DO:
              {&FIND_TABLE2_BY_ID} INTEGER(ENTRY(2, switch, ":":u)).
              
              PUT UNFORMATTED 'results.tchoice[':u qbf-i ']= ':u.
              EXPORT qbf-rel-buf.tname qbf-rel-buf2.tname.
          
          END.
        END.
      END.
    END.

    /*------------------------------------------------------------------------*/
    /*
    results.field[1]= "sports.customer.City" "City" "x(12)" "" "character" ""
    results.field[2]= "qbf-002,sports.customer.Curr-bal" "Running Total"
	                  "->,>>>,>>9.99" "" "decimal" "r"
    results.field[3]= "qbf-003,sports.customer.Curr-bal" "% Total" "->>>9.9%"
                      "" "decimal" "p"
    results.field[4]= "qbf-004,1,1" "Counter" ">>>>9" "" "integer" "c"
    results.field[5]= "qbf-005,ENTRY(WEEKDAY(TODAY),""Sunday,Monday,Tuesday,~
	                   Wednesday,Thursday,Friday,Saturday"")"
                      "String Value" "x(9)" "" "character" "s"
    results.field[6]= "qbf-006,1,1" "Counter" ">>>>9" "" "integer" "c"
    results.field[7]= "qbf-007,ENTRY(WEEKDAY(TODAY),""Sunday,Monday,Tuesday,~
	                   Wednesday,Thursday,Friday,Saturday"")"
                      "DayName" "x(9)" "" "character" "s"
    results.field[8]= "sports.customer.City" "City" "x(12)" "" "character" ""
    results.field[9]= "sports.order.City" "City" "x(12)" "" "character" ""
    */
  
    DO qbf-i = 1 TO qbf-rc#:
      PUT UNFORMATTED 'results.field[':u qbf-i ']= ':u.
      EXPORT 
        qbf-rcn[qbf-i] qbf-rcl[qbf-i] qbf-rcf[qbf-i] qbf-rcg[qbf-i]
        ENTRY(qbf-rct[qbf-i],qbf-dtype) qbf-rcc[qbf-i]
        qbf-rcs[qbf-i] qbf-rcp[qbf-i].
    END.
  
    /*------------------------------------------------------------------------*/
    /*
    results.order[1]= "sports.customer.Sales-region" "ascending"
    results.order[2]= "sports.customer.St" "descending"
    */
  
    DO qbf-i = 1 TO NUM-ENTRIES(qbf-sortby):
      PUT UNFORMATTED
        'results.order[':u STRING(qbf-i) ']= "':u
        ENTRY(1,ENTRY(qbf-i,qbf-sortby)," ":u)
        '" "':u
        (IF ENTRY(qbf-i,qbf-sortby) MATCHES "* DESC":u THEN 'de':u ELSE 'a':u)
        'scending"':u SKIP.
    END.
  
    /*------------------------------------------------------------------------*/
    /*
    export.base-date= 12/30/1899
    export.field-delimiter= "34"
    export.field-separator= "32"
    export.record-start= "42"
    export.record-end= "13,10"
    export.delimit-type= "*"
    export.type= PROGRESS
    export.description= "PROGRESS Export"
    export.prepass= "no"
    export.use-headings= "no"
    export.fixed-width= "no"
    */
  
    PUT UNFORMATTED
      'export.type= ':u             qbf-esys.qbf-type SKIP
      'export.use-headings= ':u     STRING(qbf-esys.qbf-headers,"yes/no":u) SKIP
      'export.fixed-width= ':u      STRING(qbf-esys.qbf-fixed,"yes/no":u) SKIP
      'export.prepass= ':u          STRING(qbf-esys.qbf-prepass,"yes/no":u) SKIP
      'export.base-date= ':u        qbf-esys.qbf-base SKIP
      'export.record-start= "':u    qbf-esys.qbf-lin-beg '"':u SKIP
      'export.record-end= "':u      qbf-esys.qbf-lin-end '"':u SKIP
      'export.field-delimiter= "':u qbf-esys.qbf-fld-dlm '"':u SKIP
      'export.field-separator= "':u qbf-esys.qbf-fld-sep '"':u SKIP
      'export.delimit-type= "':u    qbf-esys.qbf-dlm-typ '"':u SKIP
      'export.description= ':u
      .
    EXPORT qbf-esys.qbf-desc.
  
    /*------------------------------------------------------------------------*/
    /*
    form.prop[1]= "demo.Customer,demo.Order" "5" "rt" 100
        (tables, row, flags, width)
    */
  
    qbf-i = 1.
    FOR EACH qbf-frame:
      IF (qbf-frame.qbf-frow[{&F_IX}] = 0 AND
          qbf-frame.qbf-fflg[{&F_IX}] = "" AND 
          qbf-frame.qbf-fwdt = 0) THEN NEXT.

      PUT UNFORMATTED 'form.prop[':u qbf-i ']= ':u.
      qbf-c = "".
    
      DO qbf-j = 1 TO NUM-ENTRIES (qbf-frame.qbf-ftbl):
        {&FIND_TABLE_BY_ID} INTEGER(ENTRY(qbf-j,qbf-frame.qbf-ftbl)).
        qbf-c = qbf-c + (IF qbf-c = "" THEN "" ELSE ",") 
              + qbf-rel-buf.tname.
      END.
    
      EXPORT qbf-c qbf-frame.qbf-frow[{&F_IX}]
             qbf-frame.qbf-fflg[{&F_IX}] qbf-frame.qbf-fwdt.
  
      qbf-i = qbf-i + 1.
    END.
  	
    /*------------------------------------------------------------------------*/
    /*
    browse.prop[1]= "demo.Customer,demo.Order" "5" "t" "8"
        (tables, row, flags, browse height)
    */
  
    qbf-i = 1.
    FOR EACH qbf-frame:
      IF (qbf-frame.qbf-frow[{&B_IX}] = 0 AND 
          qbf-frame.qbf-fflg[{&B_IX}] = "") THEN NEXT.

      PUT UNFORMATTED 'browse.prop[':u qbf-i ']= ':u.
      qbf-c = "".
      DO qbf-j = 1 TO NUM-ENTRIES (qbf-frame.qbf-ftbl):
        {&FIND_TABLE_BY_ID} INTEGER(ENTRY(qbf-j,qbf-frame.qbf-ftbl)).
        qbf-c = qbf-c + (IF qbf-c = "" THEN "" ELSE ",":u) 
              + qbf-rel-buf.tname.
      END.
      EXPORT qbf-c qbf-frame.qbf-frow[{&B_IX}]
             qbf-frame.qbf-fflg[{&B_IX}] qbf-frame.qbf-fbht.
  
      qbf-i = qbf-i + 1.
    END.
  
    /*------------------------------------------------------------------------*/
    /*
    label.type= "Rolodex"
    label.dimension= '3""x5""'
    label.label-spacing= 0
    label.left-margin= 0
    label.number-across= 1
    label.number-copies= 1
    label.omit-blank= true
    label.top-margin= 1
    label.total-height= 6
    label.text1= "{Name}"
    label.text2= "{Address}"
    label.text3= "{Address2}"
    label.text4= "{City}, {St}  {Zip}"
    */
 
    PUT UNFORMATTED 'label.type= ':u.
    EXPORT qbf-lsys.qbf-type.
    PUT UNFORMATTED 'label.dimension= ':u.
    EXPORT qbf-lsys.qbf-dimen.
 
    PUT UNFORMATTED
      'label.left-margin= ':u   qbf-lsys.qbf-origin-hz   SKIP
      'label.label-width= ':u   qbf-lsys.qbf-label-wd    SKIP
      'label.total-height= ':u  qbf-lsys.qbf-label-ht    SKIP
      'label.vert-space= ':u    qbf-lsys.qbf-space-vt    SKIP
      'label.horz-space= ':u    qbf-lsys.qbf-space-hz    SKIP
      'label.number-across= ':u qbf-lsys.qbf-across      SKIP
      'label.number-copies= ':u qbf-lsys.qbf-copies      SKIP
      'label.omit-blank= ':u    STRING(qbf-lsys.qbf-omit,"true/false":u) SKIP.

    DO qbf-i = 1 TO EXTENT(qbf-l-text):
      IF qbf-l-text[qbf-i] = "" THEN NEXT.
      PUT UNFORMATTED 'label.text[':u qbf-i ']= ':u.
      EXPORT qbf-l-text[qbf-i].
    END.
 
    /*------------------------------------------------------------------------*/
    /*
    report.time
    report.after-body= 0
    report.before-body= 0
    report.bottom-center= "" "" ""
    report.bottom-left= "abcdefghijklmnopqrs Page {PAGE}" "" ""
    report.bottom-right= "{PAGE} Page srqponmlkjihgfedcba" "" ""
    report.column-spacing= 1
    report.first-only= "" "" ""
    report.last-only= "" "" ""
    report.left-margin= 1
    report.line-spacing= 1
    report.page-eject= ""
    report.page-size= 60
    report.top-center= "top and center" "" ""
    report.top-left= "page  {PAGE}" "today {TODAY}" "time  {now}"
    report.top-margin= 0
    report.top-right= "user {USER}" "" ""
    */

    PUT UNFORMATTED 'report.format= ':u.
    EXPORT qbf-rsys.qbf-format.
    PUT UNFORMATTED 'report.dimension= ':u.
    EXPORT qbf-rsys.qbf-dimen.

    PUT UNFORMATTED
      'report.time= ':u           qbf-timing   	      	 SKIP
      'report.left-margin= ':u    qbf-rsys.qbf-origin-hz   SKIP
      'report.page-size= ':u      qbf-rsys.qbf-page-size   SKIP
      'report.page-width= ':u     qbf-rsys.qbf-width       SKIP
      'report.column-spacing= ':u qbf-rsys.qbf-space-hz    SKIP
      'report.line-spacing= ':u   qbf-rsys.qbf-space-vt    SKIP
      'report.top-margin= ':u     qbf-rsys.qbf-origin-vt   SKIP
      'report.before-body= ':u    qbf-rsys.qbf-header-body SKIP
      'report.after-body= ':u     qbf-rsys.qbf-body-footer SKIP
      'report.page-eject= ':u.
    EXPORT qbf-rsys.qbf-page-eject.
  
    /* header1,2,3 */
    DO qbf-i = 1 TO 10:
      FIND FIRST qbf-hsys WHERE qbf-hsys.qbf-hpos = qbf-i NO-ERROR.
      IF NOT AVAILABLE qbf-hsys THEN NEXT.
      qbf-c = ENTRY(qbf-i,
	      "top-left,top-center,top-right,":u
	    + "bottom-left,bottom-center,bottom-right,":u
	    + "first-only,last-only,cover-page,final-page":u).
      DO qbf-j = 1 TO EXTENT(qbf-hsys.qbf-htxt):
        IF qbf-hsys.qbf-htxt[qbf-j] = "" THEN NEXT.
        PUT UNFORMATTED 'report.':u qbf-c '[':u qbf-j ']= ':u.
        EXPORT qbf-hsys.qbf-htxt[qbf-j].
      END.
    END.
  
    PUT UNFORMATTED '*/':u SKIP(1).	 
  END. /* usage <> "r" or "g" */
  /*--------------------- End output comment section -------------------------*/

  /*------------------------ Generated code section --------------------------*/

  IF usage <> "s":u THEN DO:
    IF qbf-d THEN
      PUT UNFORMATTED
        'DEFINE VARIABLE qbf-day-names AS CHARACTER INITIAL "':u
        qbf-day-names '" NO-UNDO.':u.
    IF qbf-d AND qbf-m THEN 
      PUT UNFORMATTED SKIP.
    IF qbf-m THEN
      PUT UNFORMATTED
        'DEFINE VARIABLE qbf-month-names AS CHARACTER INITIAL "':u
        qbf-month-names '" NO-UNDO.':u.
    IF qbf-d OR qbf-m THEN 
      PUT UNFORMATTED SKIP(1).

    CASE qbf-module:
      WHEN "b":u THEN RUN aderes/b-write.p (usage). /* browse */
      WHEN "r":u THEN RUN aderes/r-write.p (usage). /* report */
      WHEN "f":u THEN RUN aderes/f-write.p (usage). /* form   */
      WHEN "l":u THEN RUN aderes/l-write.p (usage). /* label  */
      WHEN "e":u THEN RUN aderes/e-write.p (usage). /* export */
    END CASE.
    retval = RETURN-VALUE.
  END.

  OUTPUT CLOSE.
END. /*DO ON ERROR block */

RETURN retval.

/* s-write.p - end of file */

