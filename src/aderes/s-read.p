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
 * s-read.p - read generic view object header (query file)
 */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/i-define.i }
{ aderes/j-define.i }
{ aderes/e-define.i }
{ aderes/l-define.i }
{ aderes/r-define.i }
{ aderes/fbdefine.i }
{ aderes/af-rship.i }
{ aderes/_fdefs.i }

DEFINE INPUT  PARAMETER qbf-f    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER qbf-mode AS CHARACTER NO-UNDO. /* open, build */
DEFINE OUTPUT PARAMETER qbf-ok   AS LOGICAL   NO-UNDO INIT TRUE.

DEFINE VARIABLE qbf-a  AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-b  AS LOGICAL   NO-UNDO. /* unrecognized token */
DEFINE VARIABLE qbf-c  AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-d  AS CHARACTER NO-UNDO. /* _Field.Can-Read */
DEFINE VARIABLE qbf-i  AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-g  AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-j  AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-k  AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-l  AS INTEGER   NO-UNDO. /* lseek position */
DEFINE VARIABLE qbf-m  AS CHARACTER NO-UNDO EXTENT 8.
DEFINE VARIABLE qbf-s  AS INTEGER   NO-UNDO. /* subscript */
DEFINE VARIABLE qbf-t  AS CHARACTER NO-UNDO. /* keyword token */
DEFINE VARIABLE qbf-v  AS CHARACTER NO-UNDO. /* object version */
DEFINE VARIABLE qbf-z  AS CHARACTER NO-UNDO. /* error listing */
DEFINE VARIABLE w-jnk  AS HANDLE    NO-UNDO. /* scrap */
DEFINE VARIABLE m-hdl  AS HANDLE    NO-UNDO. /* menu handle */
DEFINE VARIABLE cand   AS INTEGER   NO-UNDO. /* join candidate */
DEFINE VARIABLE qbf-p  AS INTEGER   NO-UNDO. /* table id */
DEFINE VARIABLE crcchg AS LOGICAL   NO-UNDO. /* CRC change */
DEFINE VARIABLE junk   AS LOGICAL   NO-UNDO. /* found bad field */
DEFINE VARIABLE found  AS LOGICAL   NO-UNDO. /* found good field */
DEFINE VARIABLE tbnam  AS CHARACTER NO-UNDO. /* tbl name, not alias */
DEFINE VARIABLE tIndex AS INTEGER   NO-UNDO.
DEFINE VARIABLE iJunk  AS INTEGER   NO-UNDO.

DEFINE STREAM qbf-io.

qbf-c = qbf-report.
RUN aderes/s-zap.p (TRUE).
qbf-report = qbf-c.

FIND FIRST qbf-esys /*WHERE qbf-esys.qbf-live*/ .
FIND FIRST qbf-lsys /*WHERE qbf-lsys.qbf-live*/ .
FIND FIRST qbf-rsys WHERE qbf-rsys.qbf-live.

&if true &then
INPUT STREAM qbf-io FROM VALUE(qbf-f) NO-ECHO NO-MAP.
&else
RUN aderes/s-prefix.p (qbf-qdfile, OUTPUT qbf-c).
INPUT STREAM qbf-io FROM VALUE(SEARCH(qbf-c + qbf-f + ".p":u)) NO-ECHO NO-MAP.
&endif

main-loop:
REPEAT:														    
  ASSIGN
    qbf-b = FALSE
    qbf-m = ""
    qbf-l = SEEK(qbf-io).

  IMPORT STREAM qbf-io qbf-t qbf-m.
  IF qbf-t BEGINS "#":u OR qbf-t = "" OR qbf-t = "/*":u THEN NEXT.
  IF qbf-t = "*/":u THEN LEAVE.

  IF SUBSTRING(qbf-t,LENGTH(qbf-t,"CHARACTER":u),-1,
               "CHARACTER":u) <> "=":u THEN DO:
    SEEK STREAM qbf-io TO qbf-l.
    IMPORT STREAM qbf-io UNFORMATTED qbf-t.
    qbf-z = qbf-z + (IF qbf-z = "" THEN "" ELSE CHR(10))
          + SUBSTITUTE("Unknown line: [&1].",qbf-t).
    NEXT.
  END.

  ASSIGN
    /* strip off trailing "=" */
    qbf-t = SUBSTRING(qbf-t,1,LENGTH(qbf-t,"CHARACTER":u) - 1,"CHARACTER":u)
    qbf-i = INDEX(qbf-t,"[":u)
    qbf-j = INDEX(qbf-t,"]":u)
    qbf-s = 0. /* is subscript n if token[n] seen */

  IF qbf-i > 0 AND qbf-j > qbf-i THEN
    ASSIGN
      qbf-s = INTEGER(SUBSTRING(qbf-t,qbf-i + 1,qbf-j - qbf-i - 1,
                                "CHARACTER":u))
      qbf-t = SUBSTRING(qbf-t,1,qbf-i - 1,"CHARACTER":u).

  /*------------------------------------------------------------------------*/
  /*
  config= query
  version= 2.0I
  results.view-as= browse
  results.summary= false
  results.detail-level= 0
  results.governor = 0

  results.table[1]= "tony.customer" "" "" FALSE
  results.table[2]= "tony.order" "OF tony.customer" "" FALSE
  results.table[3]= "tony.order-line" "OF tony.order" "" FALSE
  results.table[4]= "tony.item" "OF tony.order-line" "" FALSE

  results.field[1]= "tony.customer.City" "City" "x(12)" "" "character" ""
  results.field[2]= "qbf-002,tony.customer.Curr-bal" "Running Total"
                    "->,>>>,>>9.99" "" "decimal" "r"
  results.field[3]= "qbf-003,tony.customer.Curr-bal" "% Total" "->>>9.9%"
                    "" "decimal" "p"
  results.field[4]= "qbf-004,1,1" "Counter" ">>>>9" "" "integer" "c"
  results.field[5]= "qbf-005,ENTRY(WEEKDAY(TODAY),""Sunday,Monday,Tuesday,
                    Wednesday,Thursday,Friday,Saturday"")"
                    "String Value" "x(9)" "" "character" "s"
  results.field[6]= "qbf-006,1,1" "Counter" ">>>>9" "" "integer" "c"
  results.field[7]= "qbf-007,ENTRY(WEEKDAY(TODAY),""Sunday,Monday,Tuesday,
                    Wednesday,Thursday,Friday,Saturday"")"
                    "DayName" "x(9)" "" "character" "s"
  results.field[8]= "tony.customer.City" "City" "x(12)" "" "character" ""
  results.field[9]= "tony.order.City" "City" "x(12)" "" "character" ""

  results.order[1]= "tony.customer.Sales-region" "ascending"
  results.order[2]= "tony.customer.St" "descending"
  */

  IF qbf-t = "databases":u THEN DO:
    DO qbf-i = 1 TO NUM-ENTRIES(qbf-m[1]):
      IF NOT CONNECTED(ENTRY(qbf-i,qbf-m[1])) THEN DO:

        IF qbf-mode = "open":u THEN
        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u, 
          SUBSTITUTE('The "&1" query could not be opened, since the &2 database was needed but was not connected.', 
          qbf-name,ENTRY(qbf-i,qbf-m[1]))).
        qbf-ok    = FALSE.
        RETURN.
      END. 
    END.
  END.

  ELSE IF qbf-t = "version":u THEN
    qbf-v = qbf-m[1].

  ELSE IF qbf-t = "config":u THEN .

  ELSE IF qbf-t BEGINS "results.":u THEN DO:
    CASE SUBSTRING(qbf-t,9,-1,"CHARACTER":u):
      /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
      WHEN "ruler":u THEN .  /* obsolete */
      /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
      WHEN "Status-Area":u THEN
        lGlbStatus = IF qbf-m[1] = "true":u THEN TRUE ELSE FALSE.
      /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
      WHEN "Toolbar":u THEN DO:
        lGlbToolBar = IF qbf-m[1] = "true":u THEN TRUE ELSE FALSE.
        RUN adeshar/_mgeti2.p ({&resId}, {&rfToolBar}, 
      	                       OUTPUT qbf-c,OUTPUT qbf-c,OUTPUT qbf-a,
      	                       OUTPUT m-hdl,OUTPUT w-jnk,OUTPUT qbf-c,
                               OUTPUT qbf-a).
      	m-hdl:CHECKED = lGlbToolBar.
      END.
      /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
      /*----
      WHEN "ToolText":u THEN DO:
        lGlbToolText = IF qbf-m[1] = "true":u THEN TRUE ELSE FALSE.
        RUN adeshar/_mgeti2.p ({&resId}, {&rfToolbarAndText}, 
      	                       OUTPUT qbf-c,OUTPUT qbf-c,OUTPUT qbf-a,
      	       	     	       OUTPUT m-hdl,OUTPUT w-jnk,OUTPUT qbf-c,
                               OUTPUT qbf-a).
      	m-hdl:CHECKED = lGlbToolText.
      END.
      ----*/
      /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
      WHEN "name":u THEN
        qbf-name = qbf-m[1].
      /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
      WHEN "summary":u THEN
        qbf-summary = CAN-DO("t*,y*":u,qbf-m[1]).
      /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
      WHEN "detail-level":u THEN
        qbf-detail = INTEGER(qbf-m[1]).
      /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
      WHEN "governor":u THEN
        qbf-governor = INTEGER(qbf-m[1]).
      /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
      WHEN "govergen":u THEN
        qbf-govergen = IF qbf-m[1] = "true":u THEN TRUE ELSE FALSE.
      /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
      WHEN "view-as":u THEN DO:

        ASSIGN
          qbf-i      = LOOKUP(qbf-m[1],"browse,export,form,label,report":u)
          qbf-module = SUBSTRING("beflr":u,qbf-i,1,"CHARACTER":u)
        .

        /*
         * If this is the first query read then get the view permissions. 
         * Doing the work here is to avoid doing the work during startup, and
         * making startup slower.
         */

        IF _viewPermission[1] = ? THEN DO:
          RUN adeshar/_mgetfs.p ({&resId}, {&rfReportView},
                                           OUTPUT _viewPermission[1]).      
          RUN adeshar/_mgetfs.p ({&resId}, {&rfBrowseView},
                                           OUTPUT _viewPermission[2]).
          RUN adeshar/_mgetfs.p ({&resId}, {&rfFormView},
                                           OUTPUT _viewPermission[3]).
          RUN adeshar/_mgetfs.p ({&resId}, {&rfExportView},
                                           OUTPUT _viewPermission[4]).
          RUN adeshar/_mgetfs.p ({&resId}, {&rfLabelView},
                                           OUTPUT _viewPermission[5]).
        END.

        /* Make sure that this user can see the query in the view the query
         * was saved in. 
         */
        qbf-k = LOOKUP(qbf-module,"r,b,f,e,l":u).

        IF _viewPermission[qbf-k] <> TRUE THEN DO:

          /*
           * If the user can't use the mode then choose another, using
           * the following order: report, browse, form, export, label.
           * Convert the type old order to the new order
           */
          qbf-module = ?.

          DO qbf-j = 1 TO EXTENT(_viewPermission):
            IF qbf-j = qbf-k THEN NEXT.
            IF _viewPermission[qbf-j] = TRUE THEN DO:
              qbf-module = SUBSTRING("rbfel":u,qbf-j,1,"CHARACTER":u).
              LEAVE.
            END.
          END.

          /* Inform the user */
          IF qbf-module = ? THEN DO:
            RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"information":u,"ok":u,
              SUBSTITUTE("You do not have permission to access &1 in any view.",
              qbf-name)).
          END.
          ELSE DO:
            qbf-c = ENTRY(qbf-j,"report,browse,form,export,label":u).
            RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"information":u,"ok":u,
              SUBSTITUTE("You do not have permission to view &1 as a &2. The query will be displayed as a &3 view.",
              qbf-name,qbf-m[1],qbf-c)).
          END.
        END.
      END.
      /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
      WHEN "tchoice":u THEN DO:
        /* m[1] = database.table name
           m[2] = "chosen table to be joined against*/
        
        /*
         * This keyword exists when a user has a choice between tables
         * to join against. We have to get the table information, see
         * if the relationship is still valid, the table is valid etc.,
         * and then rebuild the
         * data structures.
         */
        
        RUN lookup_table (qbf-m[1], OUTPUT qbf-i).
        
        /* Table not found in list of relationships -dma */
        IF qbf-i <= 0 THEN DO:

          IF qbf-mode = "open":u THEN
          RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u, 
            SUBSTITUTE('The "&1" query could not be opened since the &2 table was not found.',
            qbf-name,qbf-m[1])).

          RUN error_log ("** Query open error - ":l + qbf-name 
                       + " (":u + LC(qbf-f) + ")":u + CHR(10) 
                       + "   Missing table: ":l + qbf-m[1]).

          qbf-ok = FALSE.
          RETURN.
        END.
        ELSE DO:
          RUN lookup_table (qbf-m[2], OUTPUT qbf-j).
        
          /* Table not found in list of relationships -dma */
          IF qbf-j <= 0 THEN DO:

            IF qbf-mode = "open":u THEN
            RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u, 
              SUBSTITUTE('The "&1" query could not be opened since the &2 table was not found.',
              qbf-name,qbf-m[2])).

            RUN error_log ("** Query open error - ":l + qbf-name 
                         + " (":u + LC(qbf-f) + ")":u + CHR(10) 
                         + "   Missing table: ":l + qbf-m[2]).

            qbf-ok = FALSE.
            RETURN.
          END.
          ELSE DO:
            /*
             * The tables are still there! Is the relationship between the
             * table and the alternate still valid?
             */
            
            {&FIND_TABLE_BY_ID} qbf-i.
            qbf-a = false.
            DO qbf-k = 2 TO NUM-ENTRIES(qbf-rel-buf.rels):
              RUN breakJoinInfo (ENTRY(qbf-k, qbf-rel-buf.rels),
                                 OUTPUT tIndex,
                                 OUTPUT qbf-g,
                                 OUTPUT qbf-g,
                                 OUTPUT iJunk).
              IF tIndex = qbf-j THEN DO:
                qbf-a = TRUE.
                LEAVE.
              END.
            END.
            
            IF qbf-a THEN DO: 
              IF LENGTH(qbf-rel-choice) > 0 THEN
                qbf-rel-choice = qbf-rel-choice + ",":u + STRING(qbf-i) + ":":u + STRING(qbf-j).
              ELSE
                qbf-rel-choice = STRING(qbf-i) + ":":u + STRING(qbf-j).
            END.
            ELSE DO:
              RUN error_log ("** Query open error - ":l + qbf-name 
                             + " (":u + LC(qbf-f) + ")":u + CHR(10)
                             + "   Invalid relationship: ":l + qbf-m[1] 
                             + " ":u + qbf-m[2]).
  
              IF qbf-mode = "open":u THEN
                RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
                  SUBSTITUTE('The "&1" query could not be opened due to an invalid table relationship:^^&2 &3',
                  qbf-name,qbf-m[1],qbf-m[2])).
                    
              qbf-ok = FALSE.
              RETURN.
            END.
          END.

        END.
      END.
      /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
      WHEN "table":u THEN DO:
        /*  m[1] = database.table name
            m[2] = table CRC
            m[3] = join relationship
            m[4] = talbe WHERE clause
            m[5] = outer join (yes/no)
            m[6] = code to be included */
            
        /* Lookup child table ID# */
        RUN lookup_table (qbf-m[1], OUTPUT qbf-i).
        
        /* Table not found in list of relationships -dma */
        IF qbf-i <= 0 THEN DO:

          IF qbf-mode = "open":u THEN
          RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u, 
            SUBSTITUTE('The "&1" query could not be opened since the &2 table was not found.',
            qbf-name,qbf-m[1])).

          RUN error_log ("** Query open error - ":l + qbf-name 
                       + " (":u + LC(qbf-f) + ")":u + CHR(10) 
                       + "   Missing table: ":l + qbf-m[1]).

          qbf-ok = FALSE.
          RETURN.
        END.
        
        /* table found */
        ELSE DO:
          /* Compare current CRC against that in query - dma */
          {&FIND_TABLE_BY_ID} qbf-i NO-ERROR.
         
          IF qbf-rel-buf.crc <> qbf-m[2] 
            AND qbf-mode = "open":u THEN DO:
            RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"warning":u,"ok":u,
              SUBSTITUTE("The query CRC for &1 does not agree with the database.  Saving the query will repair the inconsistency.",
              qbf-m[1])).

            ASSIGN
              qbf-dirty = TRUE
              crcchg    = TRUE.
          END.
          
          qbf-tables = qbf-tables
                     + (IF qbf-tables = "" THEN "" ELSE ",":u) + STRING(qbf-i).

          IF qbf-m[3] + qbf-m[4] + qbf-m[6] <> "" THEN DO:
            FIND FIRST qbf-where
              WHERE qbf-where.qbf-wtbl = qbf-i NO-ERROR.
            IF NOT AVAILABLE qbf-where THEN DO:
              CREATE qbf-where.
              ASSIGN
                qbf-where.qbf-wtbl = qbf-i
                qbf-where.qbf-wrel = qbf-m[3]
                qbf-where.qbf-wcls = qbf-m[4]
                qbf-where.qbf-wojo = CAN-DO("y*,t*":u,qbf-m[5])
                qbf-where.qbf-winc = qbf-m[6]
                qbf-where.qbf-wask = "".
            END.

            IF qbf-m[3] BEGINS "WHERE":u THEN DO:
              FIND FIRST qbf-where WHERE qbf-where.qbf-wtbl = qbf-i NO-ERROR.

              IF NOT AVAILABLE qbf-where OR (AVAILABLE qbf-where AND
                qbf-m[3] <> qbf-where.qbf-wrel) THEN DO:
                
                RUN error_log ("** Query open error - ":l + qbf-name 
                             + " (":u + LC(qbf-f) + ")":u + CHR(10)
                             + "   Invalid relationship: ":l + qbf-m[1] 
                             + " ":u + qbf-m[3]).
  
                IF qbf-mode = "open":u THEN
                  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
                    SUBSTITUTE('The "&1" query could not be opened due to an invalid table relationship:^^&2 &3',
                    qbf-name,qbf-m[1],qbf-m[3])).
                    
                qbf-ok = FALSE.
                RETURN.
              END.
             
            
            END. /* join relationship */
          END.
        END.
      END. /* table */
      /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
      WHEN "field":u THEN DO:
        ASSIGN
          found = TRUE
          qbf-k = IF qbf-m[6] BEGINS "c" THEN 0
                  ELSE IF qbf-m[6] > "" THEN NUM-ENTRIES(qbf-m[6])
                  ELSE 2.												
        IF qbf-k >= 2 THEN
        DO qbf-j = 2 TO qbf-k:
          qbf-g = IF qbf-m[6] > "" THEN ENTRY(qbf-j,qbf-m[6]) ELSE qbf-m[1].

          /* Omit missing fields -dma */
      	  RUN alias_to_tbname (qbf-g,TRUE,OUTPUT tbnam).

          RUN aderes/s-schema.p (tbnam,"","","DB:ANY-FIELD":u,OUTPUT qbf-c).
          RUN aderes/s-schema.p (tbnam,"","","FIELD:CAN-READ":u,OUTPUT qbf-d).
                                                
          IF qbf-c = "nn":u 
            OR NOT CAN-DO(qbf-d,USERID(ENTRY(1,tbnam,".":u))) THEN DO:
          
            RUN error_log ("** Query open error - ":l + qbf-name 
                         + " (":u + LC(qbf-f) + ")":u + CHR(10)
                         + "   Missing field: ":l + qbf-m[1]).
                                   
            ASSIGN
              qbf-dirty = TRUE
              junk      = TRUE
              found     = FALSE.
            LEAVE.
          END.

          /* Omit missing fields - RESULTS level security */
          IF _fieldCheck <> ? THEN DO:
            hook:
            DO ON STOP UNDO hook, RETRY hook:
              IF RETRY THEN DO:
                RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"warning":u,"ok":u,
                  SUBSTITUTE("There is a problem with &1.  &2 will use default field security.",
                  _fieldCheck,qbf-product)).
                  
                _fieldCheck = ?.
                LEAVE hook.
              END.
 
              qbf-c = ENTRY(1,tbNam,".":u) + ".":u + ENTRY(2,tbNam,".":u).
     
              RUN VALUE(_fieldCheck) (qbf-c,
                                      ENTRY(3,tbNam,".":u), 
                                      USERID(ENTRY(1,tbNam,".":u)),
                                      OUTPUT qbf-a).

              IF NOT qbf-a THEN DO:
                RUN error_log ("** Query open error - ":l + qbf-name 
                             + " (":u + LC(qbf-f) + ")":u + CHR(10)
                             + "   Missing field: ":l + qbf-m[1]).
                                       
                ASSIGN
                  qbf-dirty = TRUE
                  junk      = TRUE
                  found     = FALSE.
                LEAVE.
              END.
            END.
          END.
        
          IF qbf-m[6] = "" THEN DO:
            /* Omit fields with mismatched datatype -dma */
            RUN aderes/s-schema.p (tbnam,"","","FIELD:TYP&FMT":u,OUTPUT qbf-c).
        
            IF ENTRY(1,qbf-c) <> STRING(LOOKUP(qbf-m[5],qbf-dtype)) THEN DO:
            
              RUN error_log ("** Query open error - ":l + qbf-name 
                           + " (":u + LC(qbf-f) + ")":u + CHR(10)
                           + "   Invalid datatype: ":l + qbf-m[1] 
                           + " (":u + qbf-m[5] + ")":u).
                         
              ASSIGN
                qbf-dirty = TRUE
                junk      = TRUE
                found     = FALSE.
              LEAVE.
            END.
          END.
        END.

        /*
        message
          "qbf-m[1]" qbf-m[1] skip
          "qbf-m[2]" qbf-m[2] skip
          "qbf-m[3]" qbf-m[3] skip
          "qbf-m[4]" qbf-m[4] skip
          "qbf-m[5]" qbf-m[5] skip
          "qbf-m[6]" qbf-m[6] skip
          "found" found skip
          view-as alert-box title "s-read".
        */

        IF NOT found THEN NEXT.

        ASSIGN
          qbf-s          = qbf-rc# + 1
          qbf-rc#        = MAXIMUM(qbf-s,qbf-rc#)
          qbf-rcn[qbf-s] = qbf-m[1]
          qbf-rcl[qbf-s] = qbf-m[2]
          qbf-rcf[qbf-s] = qbf-m[3]
          qbf-rcg[qbf-s] = qbf-m[4]
          qbf-rct[qbf-s] = LOOKUP(qbf-m[5],qbf-dtype)
          qbf-rcc[qbf-s] = qbf-m[6]
        /*qbf-rcs[qbf-s] = qbf-m[7]*/
          qbf-rcp[qbf-s] = qbf-m[8]

          qbf-i          = NUM-ENTRIES(qbf-rcp[qbf-s]).

        IF qbf-i < 9 THEN
          qbf-rcp[qbf-s] = qbf-rcp[qbf-s] + FILL(",":u,9 - qbf-i).
          
        IF qbf-m[6] BEGINS "e":u AND NUM-ENTRIES(qbf-m[1]) = 1 THEN
            qbf-rcn[qbf-s] = "qbf-":u + STRING(qbf-s,"999":u)
                           + ",":u + qbf-rcn[qbf-s].
      END.
      /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
      WHEN "order":u THEN DO:
      
        /* calculated field? */
        DO qbf-i = 1 TO qbf-rc#:
          IF qbf-m[1] = ENTRY(1,qbf-rcn[qbf-i]) THEN LEAVE.
        END.

        qbf-k = IF qbf-i <= qbf-rc# AND qbf-rcc[qbf-i] > "" THEN
                  NUM-ENTRIES(qbf-rcc[qbf-i]) ELSE 2.
        
        /* Omit invalid order field - dma */
        DO qbf-j = 2 TO qbf-k:
          qbf-g = IF qbf-i <= qbf-rc# AND qbf-rcc[qbf-i] > "" THEN
                    ENTRY(qbf-j,qbf-rcc[qbf-i]) ELSE qbf-m[1].
          
          RUN alias_to_tbname (qbf-g,TRUE,OUTPUT tbnam).
          RUN aderes/s-schema.p (tbnam,"","","DB:ANY-FIELD":u,OUTPUT qbf-c).

          IF qbf-c = "nn":u THEN DO:
            IF qbf-mode = "open":u THEN
            RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"warning":u,"ok":u, 
              SUBSTITUTE('The "&1" query contains an invalid sort field &2, which will be omitted from the sort field list.',
              qbf-name,qbf-m[1])).
              
            qbf-dirty = TRUE.
            NEXT main-loop.
          END.
        END.
        
        IF qbf-s > 0 THEN
          qbf-sortby = qbf-sortby
                     + (IF qbf-sortby = "" THEN "" ELSE ",":u)
                     + qbf-m[1]
                     + (IF qbf-m[2] BEGINS "d":u THEN " DESC":u ELSE "").
      END.

      OTHERWISE
        qbf-b = TRUE.
    END CASE.
  END. /* results. */

  /*------------------------------------------------------------------------*/
  /*
  export.base-date= 12/30/1899
  export.delimit-type= "*"
  export.field-delimiter= "34"
  export.field-separator= "32"
  export.fixed-width= "no"
  export.prepass= "no"
  export.record-delimiter= "42"
  export.record-separator= "13,10"
  export.type= "PROGRESS"
  export.description= "PROGRESS Export"
  export.use-headings= "no"
  */

  ELSE
  IF qbf-t BEGINS "export.":u THEN DO:
    CASE SUBSTRING(qbf-t,8,-1,"CHARACTER":u):
      WHEN "type":u THEN DO:
        ASSIGN
          qbf-esys.qbf-type    = qbf-m[1]
          qbf-esys.qbf-program = "".

        IF qbf-m[1] = "CUSTOM" THEN
          qbf-esys.qbf-program = "e-ascii.p".

        ELSE
        
        /* set program to use */
        DO qbf-i = 1 TO EXTENT(qbf-e-cat):
          DO qbf-j = 1 TO NUM-ENTRIES(qbf-e-cat[qbf-i],"|":u):
            IF ENTRY(qbf-j,qbf-e-cat[qbf-i],"|":u) BEGINS "p=":u AND
              LOOKUP("t=":u + qbf-m[1],qbf-e-cat[qbf-i],"|":u) > 0 THEN DO:
              qbf-esys.qbf-program = 
                SUBSTRING(ENTRY(qbf-j,qbf-e-cat[qbf-i],"|":u),3,-1,
                          "CHARACTER":u) + ".p":u.
              LEAVE.
            END.
          END.
          IF qbf-esys.qbf-program > "" THEN LEAVE.
        END.
        
        IF qbf-esys.qbf-program = "" THEN 
          qbf-esys.qbf-program = "e-pro.p":u.
      END.

      WHEN "description":u THEN
        qbf-esys.qbf-desc = qbf-m[1].
        
      WHEN "base-date":u THEN
        qbf-esys.qbf-base = (IF qbf-m[1] = ? OR qbf-m[1] = "?":u THEN ?
                            ELSE DATE(qbf-m[1])).
                            
      WHEN "use-headings":u THEN
        qbf-esys.qbf-headers = CAN-DO("y*,t*":u,qbf-m[1]).
        
      WHEN "fixed-width":u THEN
        qbf-esys.qbf-fixed = CAN-DO("y*,t*":u,qbf-m[1]).
        
      WHEN "prepass":u THEN
        qbf-esys.qbf-prepass = CAN-DO("y*,t*":u,qbf-m[1]).
        
      WHEN "record-start":u THEN
        qbf-esys.qbf-lin-beg = qbf-m[1].
        
      WHEN "record-end":u THEN
        qbf-esys.qbf-lin-end = qbf-m[1].
        
      WHEN "field-delimiter":u THEN
        qbf-esys.qbf-fld-dlm = qbf-m[1].
        
      WHEN "field-separator":u THEN
        qbf-esys.qbf-fld-sep = qbf-m[1].
        
      WHEN "delimit-type":u THEN
        qbf-esys.qbf-dlm-typ = qbf-m[1].
        
      OTHERWISE
        qbf-b = TRUE.
    END CASE.
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
  label.text[1]= "{Name}"
  label.text[2]= "{Address}"
  label.text[3]= "{Address2}"
  label.text[4]= "{City}, {St}  {Zip}"
  label.top-margin= 1
  label.total-height= 6
  */

  ELSE
  IF qbf-t BEGINS "label.":u THEN DO:
    CASE SUBSTRING(qbf-t,7,-1,"CHARACTER":u):
      WHEN "type":u          THEN qbf-lsys.qbf-type      = qbf-m[1].
      WHEN "dimension":u     THEN qbf-lsys.qbf-dimen     = qbf-m[1].
      WHEN "left-margin":u   THEN qbf-lsys.qbf-origin-hz = INTEGER(qbf-m[1]).
      WHEN "label-width":u   THEN qbf-lsys.qbf-label-wd  = INTEGER(qbf-m[1]).
      WHEN "total-height":u  THEN qbf-lsys.qbf-label-ht  = INTEGER(qbf-m[1]).
      WHEN "vert-space":u    THEN qbf-lsys.qbf-space-vt  = INTEGER(qbf-m[1]).
      WHEN "horz-space":u    THEN qbf-lsys.qbf-space-hz  = INTEGER(qbf-m[1]).
      WHEN "number-across":u THEN qbf-lsys.qbf-across    = INTEGER(qbf-m[1]).
      WHEN "number-copies":u THEN qbf-lsys.qbf-copies    = INTEGER(qbf-m[1]).
      WHEN "omit-blank":u THEN
        qbf-lsys.qbf-omit = CAN-DO("t*,y*":u,qbf-m[1]).
      WHEN "text":u THEN DO:
        IF qbf-s > 0 THEN qbf-l-text[qbf-s] = qbf-m[1].
      END.
      OTHERWISE
        qbf-b = TRUE.
    END CASE.
  END.

  /*------------------------------------------------------------------------*/
  /*
  form.prop[1]= "demo.Customer,demo.Order" "Customer Info" 0 "rt"
  form.prop[2]= "demo.Order-line" "lines" 5 ""
      (tables, title, row, flags)
  */

  ELSE
  IF qbf-t BEGINS "form.":u THEN DO:
    CASE SUBSTRING(qbf-t,6,-1,"CHARACTER":u):
      WHEN "prop":u THEN 
      	RUN fb_properties ({&F_IX}).
      OTHERWISE
        qbf-b = TRUE.
    END CASE.
  END.

  /*------------------------------------------------------------------------*/
  /*
  browse.prop[1]= "demo.Customer,demo.Order" "Customer Info" 0 "t" "8"
  browse.prop[2]= "demo.Order-line" "lines" 5 "" "4"
      (tables, title, row, flags, browse height)
  */

  ELSE
  IF qbf-t BEGINS "browse.":u THEN DO:
    CASE SUBSTRING(qbf-t,8,-1,"CHARACTER":u):
      WHEN "prop":u THEN 
      	RUN fb_properties ({&B_IX}).
      OTHERWISE
        qbf-b = TRUE.
    END CASE.

  END.

  /*------------------------------------------------------------------------*/
  /*
  report.time= 70.32
  report.after-body= 0
  report.before-body= 0
  report.bottom-center[1]= ""
  report.bottom-center[2]= ""
  report.bottom-center[3]= ""
  report.bottom-left[1]= "abcdefghijklmnopqrs Page {PAGE}"
  report.bottom-left[2]= ""
  report.bottom-left[3]= ""
  report.bottom-right[1]= "{PAGE} Page srqponmlkjihgfedcba"
  report.bottom-right[2]= ""
  report.bottom-right[3]= ""
  report.column-spacing= 1
  report.first-only[1]= ""
  report.first-only[2]= ""
  report.first-only[3]= ""
  report.last-only[1]= ""
  report.last-only[2]= ""
  report.last-only[3]= ""
  report.left-margin= 1
  report.line-spacing= 1
  report.page-eject= ""
  report.page-size= 66
  report.top-center[1]= "top and center"
  report.top-center[2]= ""
  report.top-center[3]= ""
  report.top-left[1]= "page  {PAGE}"
  report.top-left[2]= "today {TODAY}"
  report.top-left[3]= "time  {now}"
  report.top-margin= 0
  report.top-right[1]= "user {USER}"
  report.top-right[2]= ""
  report.top-right[3]= ""
  */

  ELSE
  IF qbf-t BEGINS "report.":u THEN DO:

    CASE SUBSTRING(qbf-t,8,-1,"CHARACTER":u):
      WHEN "time":u           THEN qbf-timing               = qbf-m[1].
      WHEN "format":u         THEN qbf-rsys.qbf-format      = qbf-m[1].
      WHEN "dimension":u      THEN qbf-rsys.qbf-dimen       = qbf-m[1].
      WHEN "page-width":u     THEN qbf-rsys.qbf-width       = INTEGER(qbf-m[1]).
      WHEN "left-margin":u    THEN qbf-rsys.qbf-origin-hz   = INTEGER(qbf-m[1]).
      WHEN "page-size":u      THEN qbf-rsys.qbf-page-size   = INTEGER(qbf-m[1]).
      WHEN "column-spacing":u THEN qbf-rsys.qbf-space-hz    = INTEGER(qbf-m[1]).
      WHEN "line-spacing":u   THEN qbf-rsys.qbf-space-vt    = INTEGER(qbf-m[1]).
      WHEN "top-margin":u     THEN qbf-rsys.qbf-origin-vt   = INTEGER(qbf-m[1]).
      WHEN "before-body":u    THEN qbf-rsys.qbf-header-body = INTEGER(qbf-m[1]).
      WHEN "after-body":u     THEN qbf-rsys.qbf-body-footer = INTEGER(qbf-m[1]).
      WHEN "page-eject":u     THEN qbf-rsys.qbf-page-eject  = qbf-m[1].
      OTHERWISE DO:
        qbf-i = LOOKUP(SUBSTRING(qbf-t,8,-1,"CHARACTER":u),
                "top-left,top-center,top-right,bottom-left,bottom-center,":u
                + "bottom-right,first-only,last-only,cover-page,final-page":u).
        IF qbf-i = 0 OR qbf-s = 0 THEN
          qbf-b = TRUE.
        ELSE DO:
          FIND FIRST qbf-hsys WHERE qbf-hsys.qbf-hpos = qbf-i NO-ERROR.
          IF NOT AVAILABLE qbf-hsys THEN CREATE qbf-hsys.
          ASSIGN
            qbf-hsys.qbf-hpos        = qbf-i
            qbf-hsys.qbf-htxt[qbf-s] = qbf-m[1].
        END.
      END.
    END CASE.
  END.

  ELSE
    qbf-b = TRUE.

  IF qbf-b THEN DO:
    SEEK STREAM qbf-io TO qbf-l.
    IMPORT STREAM qbf-io UNFORMATTED qbf-t.
    qbf-z = qbf-z + (IF qbf-z = "" THEN "" ELSE CHR(10))
          + SUBSTITUTE("Unknown line: [&1].",qbf-t).
    NEXT.
  END.

END. /* REPEAT: */

/* IF qbf-v <> qbf-vers THEN RUN fix-me-up! */

/* Make sure all the WHERE clauses are properly set */
RUN aderes/j-link.p.

IF qbf-z <> "" AND qbf-mode = "open":u THEN
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
    "File->Open Errors^^":l + qbf-z).

/*------------------------------------------------------------------------*/

/* no valid fields found - dma */
IF qbf-rc# = 0 AND qbf-module <> "l":u THEN DO:

  IF qbf-mode = "open" THEN
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,SUBSTITUTE(
    'The "&1" query could not be opened, since no valid fields were found.',
    qbf-name)).
  
  RUN error_log("** Query open error - ":l + qbf-name 
              + " (":u + LC(qbf-f) + ")":u + CHR(10)
              + "   No valid fields were found":l).
                
  qbf-ok    = FALSE.
  RETURN.
END.

/* alert user to missing fields - dma */
IF junk AND qbf-mode = "open":u THEN DO:
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"warning":u,"ok":u,SUBSTITUTE(
    'Some of the fields in the "&1" query are missing or invalid and will be omitted.  Select File->Save to save these changes.',qbf-name)).
  qbf-dirty = TRUE.
END.

/* database inconsistency found - dma */
IF crcchg THEN DO:
  /* validate query by running test compile */
  RUN adecomm/_statdsp.p (wGlbStatus,1,"Validating query...":t72).

  RUN aderes/s-level.p.
  RUN aderes/s-write.p (qbf-tempdir + ".p":u,"r":u).

  IF SEARCH(qbf-tempdir + ".r":u) = qbf-tempdir + ".r":u THEN
    OS-DELETE VALUE(qbf-tempdir + ".r":u).

  qbf-ok = TRUE.

  OUTPUT TO VALUE(qbf-qcfile + ".ql":u) NO-ECHO APPEND.
  DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    COMPILE VALUE(qbf-tempdir + ".p":u) NO-ATTR-SPACE.
    qbf-ok = (COMPILER:ERROR = FALSE).
  END.
  OUTPUT CLOSE.

  IF NOT qbf-ok THEN DO: /* compile error! */
    IF qbf-mode = "open" THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,SUBSTITUTE(
      'The "&1" query could not be opened due to database definition changes.',
      qbf-name)).
    
    RUN error_log ("** Query open error - ":l + qbf-name 
                 + " (":u + LC(qbf-f) + ")":u + CHR(10)
                 + "   Schema CRC inconsistency":l).
                   
    RUN adecomm/_setcurs.p ("":u).
    RETURN.
  END.
END.

RETURN.

/*--------------------------------------------------------------------------*/

/* lookup_table (to lookup table reference in relationship table) */
{ aderes/p-lookup.i }

/* lookup_join routine */
{ aderes/p-join.i }

/* alias_to_tbname routine */
{ aderes/s-alias.i }

/*--------------------------------------------------------------------------*/

/* Write error to ql file */
PROCEDURE error_log:
  DEFINE INPUT PARAMETER err-text AS CHARACTER NO-UNDO.
  
  OUTPUT TO VALUE(qbf-qcfile + ".ql":u) NO-ECHO APPEND.
  PUT UNFORMATTED err-text SKIP FILL("-":u,76) SKIP.
  OUTPUT CLOSE.
END PROCEDURE.

/*--------------------------------------------------------------------------*/

/* Read in form or browse properties. */
PROCEDURE fb_properties:
  /* Index into qbf-frame arrays */
  DEFINE INPUT PARAMETER p_ix AS INTEGER NO-UNDO.

  /* qbf-frame could be there already from form/browse properties.
     If it is find it and fill in other stuff. Otherwise, create a new 
     record.
  */

  /* Translate table names back to table ids */
  qbf-c = "".
  DO qbf-i = 1 TO NUM-ENTRIES(qbf-m[1]):
    RUN lookup_table (ENTRY(qbf-i,qbf-m[1]), OUTPUT qbf-j).
    qbf-c = qbf-c + (IF qbf-c = "" THEN "" ELSE ",":u) + STRING(qbf-j).
  END.
  FIND FIRST qbf-frame WHERE qbf-frame.qbf-ftbl = qbf-c NO-ERROR.
  IF NOT AVAILABLE qbf-frame THEN DO:
    CREATE qbf-frame.
    qbf-frame.qbf-ftbl = qbf-c.
  END.
  ASSIGN
    qbf-frame.qbf-frow[p_ix] = 
      (IF qbf-m[2] <> "" THEN DECIMAL(qbf-m[2]) ELSE 0)
    qbf-frame.qbf-fflg[p_ix] = qbf-m[3].
  IF qbf-t BEGINS "browse":u THEN
    qbf-frame.qbf-fbht = INTEGER(qbf-m[4]).
  ELSE
    qbf-frame.qbf-fwdt = DECIMAL(qbf-m[4]).
END PROCEDURE.

/* s-read.p - end of file */

