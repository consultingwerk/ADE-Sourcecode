/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/


/*
File: prodict/mss/genrowid.p
      invoved from wrapper file prodict/mss/genrowid.i  

History: 
       ashukla 06/11     Created
*/  

DEFINE INPUT PARAMETER p_edbtype AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER l_overwrite AS logical NO-UNDO.


DEFINE VARIABLE msg              AS CHARACTER NO-UNDO.
DEFINE VARIABLE idbtype          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cons_name        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cons_desc        AS CHARACTER NO-UNDO INITIAL "Generated from SI ROWID".
DEFINE VARIABLE cons_type        AS CHARACTER NO-UNDO. 
DEFINE VARIABLE l_con-num        AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_files          AS CHARACTER NO-UNDO.
DEFINE VARIABLE a                AS INTEGER   NO-UNDO.
DEFINE VARIABLE max_id_length    AS INTEGER   NO-UNDO INITIAL 128.
DEFINE VARIABLE mandatory        AS LOGICAL   NO-UNDO INITIAL TRUE.

{ prodict/dictvar.i }
{ prodict/mss/mssvar.i } /* temp */
{ prodict/user/uservar.i }

/* DICTDB2 is original progress database.
 * DICTDB is newly created schema holder.
*/


/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
FORM
  SKIP(1)
  msg FORMAT "x(35)" LABEL "  Processing File" SKIP
  SKIP(1)
  WITH FRAME mss_fix ATTR-SPACE OVERLAY SIDE-LABELS ROW 4 CENTERED
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN view-as dialog-box three-d &ENDIF
  TITLE " Generating Constraint From MSS SI ROWID".
/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

IF NOT SESSION:BATCH-MODE  
 then assign SESSION:IMMEDIATE-DISPLAY = yes.

/* Current implementation processes all tables. l_file can be a ; separated list to process
   only selective tables.
*/
 ASSIGN l_files = "**all**".

 idbtype = { adecomm/ds_type.i
                &direction = "ETOI"
                &from-type = "p_edbtype"
                }.


/*------------------------------------------------------------------*/
/*------------------------       FILE       ------------------------*/
/*------------------------------------------------------------------*/

FOR EACH DICTDB._File WHERE DICTDB._File._Owner = "_FOREIGN" 
                         AND DICTDB._File._Tbl-type = "T"
                         AND ( l_files = "**all**"
                               or lookup(DICTDB._File._File-name,l_files) <> 0):
  ASSIGN l_con-num = 0. 
  IF DICTDB._File._File-name BEGINS "_" THEN NEXT.  
  
 
  FIND DICTDB2._File WHERE DICTDB2._File._File-name = DICTDB._File._File-name 
                      and DICTDB2._File._DB-recid = drec_db 
                      and DICTDB2._File._Owner = "PUB" NO-ERROR.

  IF NOT AVAILABLE DICTDB2._File THEN 
  FIND DICTDB2._File WHERE DICTDB2._File._For-name = DICTDB._File._File-name 
                      and DICTDB2._File._DB-recid = drec_db 
                      and DICTDB2._File._Owner = "PUB" NO-ERROR.
                      
  IF NOT AVAILABLE DICTDB2._File THEN NEXT.
/*
Progress Table : DICTDB2._File._File-name
Schema Holder Table name : DICTDB._File._File-name
*/
/*------------------------------------------------------------------*/
/*------------------------  generate CONSTRAINTS     ---------------*/
/*------------------------------------------------------------------*/

    IF TERMINAL <> "" and NOT SESSION:BATCH-MODE THEN
      DISPLAY  DICTDB._File._File-name @ msg 
         WITH FRAME mss_fix.

     FIND FIRST DICTDB2._CONSTRAINT OF DICTDB2._File  WHERE 
                               (DICTDB2._Constraint._Con-Type = "P" OR DICTDB2._Constraint._Con-Type = "PC" OR
                                DICTDB2._Constraint._Con-Type = "MP" OR DICTDB2._Constraint._Con-Type = "M") 
                            AND DICTDB2._Constraint._Con-Status <>  "O"
     NO-ERROR.
    
     IF AVAILABLE DICTDB2._CONSTRAINT THEN DO:
       IF l_overwrite THEN DO:
          assign DICTDB2._CONSTRAINT._Con-Status   = "O"
                 DICTDB2._CONSTRAINT._Con-Desc     = "Retired by system utility".
       END.
       ELSE NEXT.
     END.

      FIND DICTDB._Index OF DICTDB._File WHERE DICTDB._Index._idx-num = DICTDB._File._Fil-misc1[2]
      NO-ERROR.

      IF AVAILABLE DICTDB._Index 
      THEN DO:
        FIND DICTDB2._Index OF DICTDB2._File WHERE DICTDB2._Index._Index-name = DICTDB._Index._Index-name
        NO-ERROR.
        FOR EACH DICTDB2._Index-field OF DICTDB2._Index:
            IF CAN-FIND(DICTDB2._Field WHERE RECID(DICTDB2._Field) = DICTDB2._Index-field._Field-Recid 
                        AND DICTDB2._Field._Mandatory EQ FALSE ) THEN ASSIGN mandatory = FALSE. 
        END.
        IF mandatory THEN  ASSIGN cons_type = "P". ELSE ASSIGN cons_type = "M".

        ASSIGN cons_name = "_PKC_" + DICTDB2._File._File-Name + "_" + DICTDB2._Index._Index-name.
      /*  need to truncate name if too big */
       IF length(cons_name) > max_id_length then cons_name = substring(cons_name,1,max_id_length).
       
        _verify-cons:
        DO WHILE TRUE:
        find DICTDB2._Constraint WHERE DICTDB2._Constraint._Con-Name = cons_name NO-ERROR.
        IF NOT AVAILABLE DICTDB2._Constraint THEN DO:
           LEAVE _verify-cons.
        END.
        ELSE DO:
          DO a = 1 TO 999:
             ASSIGN cons_name = SUBSTRING(cons_name, 1, LENGTH(cons_name) - LENGTH(STRING(a))) + STRING(a).
             IF CAN-FIND( DICTDB2._Constraint WHERE DICTDB2._Constraint._Con-Name = cons_name ) THEN NEXT.
             ELSE LEAVE _verify-cons.
          END.
        END.
        END.  /* end DO WHILE TRUE: */

        for each DICTDB2._Constraint:
          IF l_con-num < DICTDB2._Constraint._con-num THEN
             ASSIGN l_con-num = DICTDB2._Constraint._con-num.
        END. 
        l_con-num  = l_con-num + 1.

        CREATE DICTDB2._Constraint.
        ASSIGN
           DICTDB2._Constraint._File-recid   = RECID (DICTDB2._File)
           DICTDB2._Constraint._db-recid     = drec_db
           DICTDB2._Constraint._Index-recid  = RECID (DICTDB2._Index)
           DICTDB2._Constraint._Con-Desc     = cons_desc 
           DICTDB2._constraint._con-num      = l_con-num 
           DICTDB2._Constraint._Con-Name     = cons_name
           DICTDB2._Constraint._For-Name     = cons_name
           DICTDB2._Constraint._Con-Type     = cons_type
           DICTDB2._Constraint._Con-Status   = "N"
           DICTDB2._Constraint._Con-Active   = TRUE.
      END.
      ASSIGN mandatory = FALSE.  /* re-initialize */
END. /* each DICTDB._File */


IF NOT SESSION:BATCH-MODE THEN 
    HIDE FRAME mss_fix NO-PAUSE.

IF NOT SESSION:BATCH-MODE  
 then assign SESSION:IMMEDIATE-DISPLAY = no.

RETURN.
