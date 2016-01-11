/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _chkrlnk.i

Description:
   Routines to check whether a record is possible between two objects.   
   Link lists are space delimited.
   
Used in: adeuib/_advslnk.p, adeuib/_linkadd.w

Author:  Wm.T.Wood

Date Created: March 1995

----------------------------------------------------------------------------*/

/* ok-key-source:  Return the list of possible keys supplied by the source
                   that are acceptable by the target.  */
PROCEDURE ok-key-source:
  DEFINE INPUT  PARAMETER p_src-keys-supplied AS CHAR NO-UNDO.
  DEFINE INPUT  PARAMETER p_trg-keys-accepted AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER p_keys-possible AS CHAR NO-UNDO.  
  
  DEF VAR cnt AS INTEGER NO-UNDO.
  DEF VAR i   AS INTEGER NO-UNDO.
  DEF VAR key AS CHAR    NO-UNDO.
  
  /* Check degenerate case - where no keys are supplied */
  IF p_src-keys-supplied ne "" THEN DO:
    cnt = NUM-ENTRIES(p_trg-keys-accepted). 
    /* For each accepted key, see if it is supplied by the source.
       If so, add it to the list of possible keys. */
    DO i = 1 to cnt:    
      key = ENTRY(i, p_trg-keys-accepted).
      IF CAN-DO(p_src-keys-supplied, key) 
      THEN p_keys-possible = (IF p_keys-possible eq "" 
                              THEN "" ELSE p_keys-possible + ",":U) 
                           + key.
    END.  
  END. /* IF..keys-accepter ne ""... */
END PROCEDURE. /* ok-key-source */

/* ok-table-source:  Are all the tables found in the target-list also in the
                      source-list. */
PROCEDURE ok-table-source:
  DEFINE INPUT PARAMETER source-internal AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER source-external AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER target-external AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER ok-to-link AS LOGICAL NO-UNDO.
  
  DEFINE VARIABLE i       AS INTEGER NO-UNDO.
  DEFINE VARIABLE cnt     AS INTEGER NO-UNDO.
  DEFINE VARIABLE tbllist AS CHAR NO-UNDO.
    
  /* The lists are assumed to be SPACE delimeted. */
  &Scoped-define DELIM ' ':U
    
  /* Check special cases. */
  IF source-internal = ? THEN source-internal = "".
  IF source-external = ? THEN source-external = "".
  IF target-external = ? THEN target-external = "".
  
  /* Create one list out of the source list. */
  tbllist = source-internal + 
            (IF source-internal ne "" AND source-external ne "" THEN {&DELIM} ELSE "") +
            source-external
            .
  /* Linking never works if either list is empty. */
  IF tbllist eq "" OR target-external eq "" 
  THEN ok-to-link = no.
  ELSE DO:

    /* If either list does not contail "db" names (in the form "db.table") then
       just look at table names. */
    IF INDEX(".", target-external) eq 0 THEN 
      RUN strip-dbnames (INPUT-OUTPUT tbllist).
    IF INDEX(".", tbllist) eq 0 THEN 
      RUN strip-dbnames (INPUT-OUTPUT target-external).

    /* Assume we are ok? */
    ASSIGN cnt        = NUM-ENTRIES (target-external, {&DELIM})
           i          = 0
           ok-to-link = yes     
           &IF {&DELIM} ne ",":U &THEN
           /* Change delimiter in the list to COMMA for use in "CAN-DO". */
           tbllist    = REPLACE (tbllist, {&DELIM}, ",":U)   
           &ENDIF
           .
    DO WHILE i < cnt AND ok-to-link:
      i = i + 1.
      IF NOT CAN-DO (tbllist, ENTRY(i, target-external, {&DELIM})) 
      THEN ok-to-link = no.
    END.
  END.

  /* Debugging code. */
  /*message "qqq" SKIP
 *         "Int. Tables in Target:"  tbllist skip
 *         "Ext. Tables in Source:" target-external skip
 *         ok-to-link.  */
END PROCEDURE.
  
/* strip-dbnames -- take a list of "db.tbl" names and strip the list of the db
   names.  So "sports.customer,sports.xyz" becomes "customer,xyz". */
PROCEDURE strip-dbnames:
  DEFINE INPUT-OUTPUT PARAMETER p_tbllist AS CHAR NO-UNDO.
  
  DEFINE VARIABLE i       AS INTEGER NO-UNDO.
  DEFINE VARIABLE cnt     AS INTEGER NO-UNDO.
  DEFINE VARIABLE dbtbl   AS CHAR NO-UNDO.
  
  cnt = NUM-ENTRIES(p_tbllist, {&DELIM}).
  DO i = 1 to cnt:
    dbtbl = ENTRY(i, p_tbllist, {&DELIM}).
    IF INDEX(".", dbtbl) > 0 THEN 
      ASSIGN dbtbl = ENTRY(2, dbtbl, ".")
             ENTRY(i, p_tbllist, {&DELIM}) =  dbtbl.
  END.
  
END PROCEDURE.

/* Checks to make sure that 2 objects shares the same signature
 * ADM2
 * For the purposes of linking, queryObjects do not have to match.
 */
PROCEDURE ok-sig-match:
  DEFINE INPUT  PARAMETER ph_1stObject   AS HANDLE    NO-UNDO.
  DEFINE INPUT  PARAMETER ph_2ndObject   AS HANDLE    NO-UNDO.
  DEFINE INPUT  PARAMETER p_link-type    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pl_details     AS LOGICAL   NO-UNDO.
  DEFINE OUTPUT PARAMETER p_result       AS LOGICAL   NO-UNDO.
  DEFINE OUTPUT PARAMETER pc_errorMsg    AS CHARACTER NO-UNDO.

  RUN adecomm/_somatch.w (INPUT  ph_1stObject
                            ,INPUT  ph_2ndObject 
                            ,INPUT  p_link-type 
                            ,INPUT  pl_details 
                            ,OUTPUT p_result
                            ,OUTPUT pc_errorMsg).
  /* If we can not figure it out, default to yes */
  IF p_result = ? THEN p_result = YES.
END PROCEDURE. /* ok-sig-match */

/* Checks to make sure that 2 objects can be linked
 * ADM2
 */
PROCEDURE ok-link:
  DEFINE INPUT  PARAMETER ph_1stObject   AS HANDLE    NO-UNDO.
  DEFINE INPUT  PARAMETER ph_2ndObject   AS HANDLE    NO-UNDO.
  DEFINE INPUT  PARAMETER p_link-type    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pl_details     AS LOGICAL   NO-UNDO.
  DEFINE OUTPUT PARAMETER p_result       AS LOGICAL   NO-UNDO.
  DEFINE OUTPUT PARAMETER pc_errorMsg    AS CHARACTER NO-UNDO.

  RUN adecomm/_solink.w (INPUT  ph_1stObject
                        ,INPUT  ph_2ndObject 
                        ,INPUT  p_link-type 
                        ,INPUT  pl_details 
                        ,OUTPUT p_result
                        ,OUTPUT pc_errorMsg).
  /* If we can not figure it out, default to yes */
  IF p_result = ? THEN p_result = YES.
END PROCEDURE. /* ok-sig-match */
