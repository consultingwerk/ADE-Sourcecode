/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

IMPORTANT: THIS PROGRAM CANNOT BE RAN WITH NO _DB-RECORD IN THE SYSTEM!!

File: adecomm/_getconp.p

Description:
  parses the connection-parameters of the databases (according to
  p_user_dbname) and returns them within the corresponding parameters

Input-Parameters:
  p_user_dbname logical name of the DB to be connected

Output-Parameters:
  p_db          physical db-name
  p_ld          logical db-name
  p_dt          db-type
  p_tl          trigger-file-name
  p_pf          parameter-file
  p_1           multi-user ?
  p_network     network type (-N)
  p_host        host name (-H)
  p_service     service name (-S)
  p_u           user-id
  p_p           password
  p_r1          rest of parameters 1. line
  p_r2          rest of parameters 2. line
  p_r3          rest of parameters 3. line

Used/Modified Shared Objects:
  none

Author: Tom Hutegger

History:
  hutegger    94/03/31    creation
  hutegger    94/05/02    removed .ai and .bi-handling
  j.palazzo   95/04/17    Added p_network, p_host, p_service.
  D.Adams     95/05/12    Moved from prodict/misc to adecomm
  D.McMann    01/16/98    Changed so -S would not fine -Sn instead
                          97-10-27-022

NOTE: I use this file only from within
        prodict/user/_usrscon.p
        adedict/DB/_connect.p.

      There the physical db-name and the db-type are already known, so I 
      don't care about that around here.

--------------------------------------------------------------------*/

/*----------------------------  DEFINES  ---------------------------*/

DEFINE INPUT        PARAMETER p_user_dbname AS CHARACTER.
DEFINE INPUT-OUTPUT PARAMETER p_db          AS CHARACTER.
DEFINE INPUT-OUTPUT PARAMETER p_ld          AS CHARACTER.
DEFINE INPUT-OUTPUT PARAMETER p_dt          AS CHARACTER.
DEFINE OUTPUT       PARAMETER p_tl          AS CHARACTER.
DEFINE OUTPUT       PARAMETER p_pf          AS CHARACTER.
DEFINE OUTPUT       PARAMETER p_1           AS LOGICAL.
DEFINE OUTPUT       PARAMETER p_network     AS CHARACTER.
DEFINE OUTPUT       PARAMETER p_host        AS CHARACTER.
DEFINE OUTPUT       PARAMETER p_service     AS CHARACTER.
DEFINE OUTPUT       PARAMETER p_u           AS CHARACTER.
DEFINE OUTPUT       PARAMETER p_p           AS CHARACTER.
DEFINE OUTPUT       PARAMETER p_r1          AS CHARACTER.
DEFINE OUTPUT       PARAMETER p_r2          AS CHARACTER.
DEFINE OUTPUT       PARAMETER p_r3          AS CHARACTER.

DEFINE VARIABLE ix         AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_stri     AS CHARACTER NO-UNDO.

/*---------------------------  TRIGGERS  ---------------------------*/

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

FIND FIRST _db WHERE _db._db-name = p_user_dbname NO-LOCK NO-ERROR.
IF AVAILABLE _db THEN DO:   /* try to scan for specific parameters */
  ASSIGN
    l_stri = " ":u + _db._db-comm
    p_db   = ( IF _Db._Db-addr <> "" THEN _Db._Db-addr ELSE "").

  /* replace CarriageReturns by Blanks to make text scanable */
  REPEAT WHILE INDEX(l_stri,CHR(10)) <> 0:
    ASSIGN SUBSTRING(l_stri,INDEX(l_stri,CHR(10)),-1,"CHARACTER":u) = " ":u.
  END.

  IF INDEX(l_stri," -db":u) <> 0 THEN
    ASSIGN
      p_db   = SUBSTRING(l_stri,INDEX(l_stri," -db":u) + 5,-1,"CHARACTER":u)
      p_db   = SUBSTRING(p_db,1,INDEX(p_db + " ":u," ":u),"CHARACTER":u)
      l_stri = SUBSTRING(l_stri,1,INDEX(l_stri," -db":u),"CHARACTER":u) 
             + SUBSTRING(l_stri,INDEX(l_stri," -db":u) + 5 
               + LENGTH(p_db,"CHARACTER":u),-1,"CHARACTER":u).

  IF INDEX(l_stri," -ld":u) <> 0 THEN
    ASSIGN
      p_ld   = SUBSTRING(l_stri,INDEX(l_stri," -ld":u) + 5,-1,"CHARACTER":u)
      p_ld   = SUBSTRING(p_ld,1,INDEX(p_ld + " ":u," ":u) - 1,"CHARACTER":u)
      l_stri = SUBSTRING(l_stri,1,INDEX(l_stri," -ld":u),"CHARACTER":u)
             + SUBSTRING(l_stri,INDEX(l_stri," -ld":u) + 5 
               + LENGTH(p_ld,"CHARACTER":u),-1,"CHARACTER":u).

  IF INDEX(l_stri," -dt":u) <> 0 THEN
    ASSIGN
      p_dt   = SUBSTRING(l_stri,INDEX(l_stri," -dt":u) + 5,-1,"CHARACTER":u)
      p_dt   = SUBSTRING(p_dt,1,INDEX(p_dt + " ":u," ":u) - 1,"CHARACTER":u)
      l_stri = SUBSTRING(l_stri,1,INDEX(l_stri," -dt":u),"CHARACTER":u)
             + SUBSTRING(l_stri,INDEX(l_stri," -dt":u) + 5 
               + LENGTH(p_dt,"CHARACTER":u),-1,"CHARACTER":u).

  IF INDEX(l_stri," -trig":u) <> 0 THEN
    ASSIGN
      p_tl   = SUBSTRING(l_stri,INDEX(l_stri," -trig":u) + 7,-1,"CHARACTER":u)
      p_tl   = SUBSTRING(p_tl,1,INDEX(p_tl + " ":u," ":u),"CHARACTER":u)
      l_stri = SUBSTRING(l_stri,1,INDEX(l_stri," -trig":u),"CHARACTER":u) 
             + SUBSTRING(l_stri,INDEX(l_stri," -trig":u) 
             + 7 + LENGTH(p_tl,"CHARACTER":u),-1,"CHARACTER":u).

  IF INDEX(l_stri," -pf":u) <> 0 THEN
    ASSIGN
      p_pf   = SUBSTRING(l_stri,INDEX(l_stri," -pf":u) + 5,-1,"CHARACTER":u)
      p_pf   = SUBSTRING(p_pf,1,INDEX(p_pf + " ":u," ":u),"CHARACTER":u)
      l_stri = SUBSTRING(l_stri,1,INDEX(l_stri," -pf":u),"CHARACTER":u) 
             + SUBSTRING(l_stri,INDEX(l_stri," -pf":u) 
             + 5 + LENGTH(p_pf,"CHARACTER":u),-1,"CHARACTER":u).

  IF INDEX(l_stri," -1":u) <> 0 THEN
    ASSIGN
      p_1    = FALSE
      l_stri = SUBSTRING(l_stri,1,INDEX(l_stri," -1":u),"CHARACTER":u) 
             + SUBSTRING(l_stri,INDEX(l_stri," -1":u) + 4,-1,"CHARACTER":u).
  ELSE
    ASSIGN
      p_1    = TRUE.

  IF INDEX(l_stri," -N":u) <> 0 THEN
    ASSIGN
      p_network = SUBSTRING(l_stri,INDEX(l_stri," -N":u) + 4,-1,"CHARACTER":u)
      p_network = SUBSTRING(p_network,1,INDEX(p_network + " ":u," ":u),
                            "CHARACTER":u)
      l_stri    = SUBSTRING(l_stri,1,INDEX(l_stri," -N":u),"CHARACTER":u) 
                + SUBSTRING(l_stri,INDEX(l_stri," -N":u) + 4
                  + LENGTH(p_network,"CHARACTER":u),-1,"CHARACTER":u).

  IF INDEX(l_stri," -H":u) <> 0 THEN
    ASSIGN
      p_host    = SUBSTRING(l_stri,INDEX(l_stri," -H":u) + 4,-1,"CHARACTER":u)
      p_host    = SUBSTRING(p_host,1,INDEX(p_host + " ":u," ":u),"CHARACTER":u)
      l_stri    = SUBSTRING(l_stri,1,INDEX(l_stri," -H":u),"CHARACTER":u) 
                + SUBSTRING(l_stri,INDEX(l_stri," -H":u) + 4 
                  + LENGTH(p_host,"CHARACTER":u),-1,"CHARACTER":u).

  IF INDEX(l_stri," -S ":u) <> 0 THEN
    ASSIGN
      p_service = SUBSTRING(l_stri,INDEX(l_stri," -S":u) + 4,-1,"CHARACTER":u)
      p_service = SUBSTRING(p_service,1,INDEX(p_service + " ":u," ":u),
                            "CHARACTER":u)
      l_stri    = SUBSTRING(l_stri,1,INDEX(l_stri," -S":u),"CHARACTER":u) 
                + SUBSTRING(l_stri,INDEX(l_stri," -S":u) + 4
                  + LENGTH(p_service,"CHARACTER":u),-1,"CHARACTER":u).

  IF INDEX(l_stri," -U":u) <> 0 THEN
    ASSIGN
      p_u    = SUBSTRING(l_stri,INDEX(l_stri," -U":u) + 4,-1,"CHARACTER":u)
      p_u    = SUBSTRING(p_u,1,INDEX(p_u + " ":u," ":u),"CHARACTER":u)
      l_stri = SUBSTRING(l_stri,1,INDEX(l_stri," -U":u),"CHARACTER":u) 
             + SUBSTRING(l_stri,INDEX(l_stri," -U":u) + 4
               + LENGTH(p_u,"CHARACTER":u),-1,"CHARACTER":u).

  IF INDEX(l_stri," -P":u) <> 0 THEN
    ASSIGN
      p_p    = SUBSTRING(l_stri,INDEX(l_stri," -P":u) + 4,-1,"CHARACTER":u)
      p_p    = SUBSTRING(p_p,1,INDEX(p_p + " ":u," ":u),"CHARACTER":u)
      l_stri = SUBSTRING(l_stri,1,INDEX(l_stri," -P":u),"CHARACTER":u) 
             + SUBSTRING(l_stri,INDEX(l_stri," -P":u) + 4 
               + LENGTH(p_p,"CHARACTER":u),-1,"CHARACTER":u).

  ASSIGN l_stri = TRIM(l_stri).

  IF LENGTH(l_stri,"CHARACTER":u) > 64 THEN
    ASSIGN
      p_r1   = SUBSTRING(l_stri,1,64,"CHARACTER":u)
      l_stri = SUBSTRING(l_stri,65,-1,"CHARACTER":u).
  ELSE
    ASSIGN 
      p_r1   = l_stri
      l_stri = "".

  IF LENGTH(l_stri,"CHARACTER":u) > 64 THEN
    ASSIGN 
      p_r2   = SUBSTRING(l_stri,1,64,"CHARACTER":u)
      l_stri = SUBSTRING(l_stri,65,-1,"CHARACTER":u).
  ELSE
    ASSIGN
      p_r2   = l_stri
      l_stri = "".

  IF LENGTH(l_stri,"CHARACTER":u) > 64 THEN
    ASSIGN 
      p_r3   = SUBSTRING(l_stri,1,64,"CHARACTER":u)
      l_stri = SUBSTRING(l_stri,65,-1,"CHARACTER":u).
  ELSE
    ASSIGN 
      p_r3   = l_stri
      l_stri = "".
END. 

/* _getconp.p - end of file */

