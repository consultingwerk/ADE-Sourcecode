/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

IMPORTANT: THIS PROGRAM CANNOT BE RAN WITH NO _DB-RECORD IN THE SYSTEM!!

File: prodict/misc/_getconp.p

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
    Mario B     99/06/16    Fixed so that -S would not be confused with -Sn,
                            also made it case senstive.
    
NOTE:
I use this file only from within 
  prodict/user/_usrscon.p
  adedict/DB/_connect.p. 
There the physical db-name and the db-type are already known, so I don't 
care about that around here.

--------------------------------------------------------------------*/        
/*h-*/
/*----------------------------  DEFINES  ---------------------------*/

DEFINE INPUT        parameter p_user_dbname AS CHARACTER      .
DEFINE INPUT-OUTPUT parameter p_db          AS CHARACTER      .
DEFINE INPUT-OUTPUT parameter p_ld          AS CHARACTER      .
DEFINE INPUT-OUTPUT parameter p_dt          AS CHARACTER      .
DEFINE OUTPUT       parameter p_tl          AS CHARACTER      .
DEFINE OUTPUT       parameter p_pf          AS CHARACTER      .
DEFINE OUTPUT       parameter p_1           AS LOGICAL        .
DEFINE OUTPUT       parameter p_network     AS CHARACTER      .
DEFINE OUTPUT       parameter p_host        AS CHARACTER      .
DEFINE OUTPUT       parameter p_service     AS CHARACTER      .
DEFINE OUTPUT       parameter p_u           AS CHARACTER      .
DEFINE OUTPUT       parameter p_p           AS CHARACTER      .
DEFINE OUTPUT       parameter p_r1          AS CHARACTER      .
DEFINE OUTPUT       parameter p_r2          AS CHARACTER      .
DEFINE OUTPUT       parameter p_r3          AS CHARACTER      .

DEFINE VARIABLE         ix            AS INTEGER       NO-UNDO.
DEFINE VARIABLE         l_stri          AS CHARACTER     NO-UNDO CASE-SENSITIVE.

/*---------------------------  TRIGGERS  ---------------------------*/

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

    find first _db where _db._db-name = p_user_dbname
      no-lock no-error.
    if available _db
     then do:   /* try to scan for specific parameters */

      assign 
        l_stri = " " + _db._db-comm
        p_db   = ( if _Db._Db-addr <> "" 
                    then _Db._Db-addr
                    ELSE ""
                 ).  
      
      /* replace CarriageReturns by Blanks to make text scanable */
      repeat while index(l_stri,chr(10)) <> 0:
        assign substring(l_stri,index(l_stri,chr(10))) = " ".  
        end.
        
      if index(l_stri," -db":u) <> 0
       then assign 
        p_db   = substring(l_stri,index(l_stri," -db":u) + 5)
        p_db   = substring(p_db,1,index(p_db + " "," "))
        l_stri = substring(l_stri,1,index(l_stri," -db":u)) +
                 substring(l_stri,index(l_stri," -db":u) + 5 + length(p_db)).

      if index(l_stri," -ld":u) <> 0
       then assign 
        p_ld   = substring(l_stri,index(l_stri," -ld":u) + 5)
        p_ld   = substring(p_ld,1,index(p_ld + " "," ") - 1)
        l_stri = substring(l_stri,1,index(l_stri," -ld":u)) +
                 substring(l_stri,index(l_stri," -ld":u) + 5 + length(p_ld)).

      if index(l_stri," -dt":u) <> 0
       then assign 
        p_dt   = substring(l_stri,index(l_stri," -dt":u) + 5)
        p_dt   = substring(p_dt,1,index(p_dt + " "," ") - 1)
        l_stri = substring(l_stri,1,index(l_stri," -dt":u)) +
                 substring(l_stri,index(l_stri," -dt":u) + 5 + length(p_dt)).

      if index(l_stri," -trig":u) <> 0
       then assign 
        p_tl   = substring(l_stri,index(l_stri," -trig":u) + 7)
        p_tl   = substring(p_tl,1,index(p_tl + " "," "))
        l_stri = substring(l_stri,1,index(l_stri," -trig":u)) +
                 substring(l_stri,index(l_stri," -trig":u) + 7 + length(p_tl)).

      if index(l_stri," -pf":u) <> 0
       then assign 
        p_pf   = substring(l_stri,index(l_stri," -pf":u) + 5)
        p_pf   = substring(p_pf,1,index(p_pf + " "," "))
        l_stri = substring(l_stri,1,index(l_stri," -pf":u)) +
                 substring(l_stri,index(l_stri," -pf":u) + 5 + length(p_pf)).

      if index(l_stri," -1":u) <> 0
       then assign 
        p_1    = false
        l_stri = substring(l_stri,1,index(l_stri," -1":u)) +
                 substring(l_stri,index(l_stri," -1":u) + 4).
       else assign 
        p_1    = true.

      if index(l_stri," -N":u) <> 0
       then assign 
        p_network = substring(l_stri,index(l_stri," -N":u) + 4)
        p_network = substring(p_network,1,index(p_network + " "," "))
        l_stri    = substring(l_stri,1,index(l_stri," -N":u)) +
                    substring(l_stri,index(l_stri," -N":u) + 4 + length(p_network)).
      
      if index(l_stri," -H":u) <> 0
       then assign 
        p_host    = substring(l_stri,index(l_stri," -H":u) + 4)
        p_host    = substring(p_host,1,index(p_host + " "," "))
        l_stri    = substring(l_stri,1,index(l_stri," -H":u)) +
                    substring(l_stri,index(l_stri," -H":u) + 4 + length(p_host)).

      if index(l_stri," -S ":u) <> 0
       then assign 
        p_service = substring(l_stri,index(l_stri," -S":u) + 4)
        p_service = substring(p_service,1,index(p_service + " "," "))
        l_stri    = substring(l_stri,1,index(l_stri," -S":u)) +
                    substring(l_stri,index(l_stri," -S":u) + 4 + length(p_service)).

      if index(l_stri," -U":u) <> 0
       then assign 
        p_u    = substring(l_stri,index(l_stri," -U":u) + 4)
        p_u    = substring(p_u,1,index(p_u + " "," "))
        l_stri = substring(l_stri,1,index(l_stri," -U":u)) +
                 substring(l_stri,index(l_stri," -U":u) + 4 + length(p_u)).

      if index(l_stri," -P":u) <> 0
       then assign 
        p_p    = substring(l_stri,index(l_stri," -P":u) + 4)
        p_p    = substring(p_p,1,index(p_p + " "," ":u))
        l_stri = substring(l_stri,1,index(l_stri," -P":u)) +
                 substring(l_stri,index(l_stri," -P":u) + 4 + length(p_p)).

      assign l_stri = trim(l_stri).  

      if length(l_stri) > 64 then assign p_r1   = substring(l_stri,1,64)
                                         l_stri = substring(l_stri,65).
                             else assign p_r1   = l_stri
                                         l_stri = "".            
      if length(l_stri) > 64 then assign p_r2   = substring(l_stri,1,64)
                                         l_stri = substring(l_stri,65).
                             else assign p_r2   = l_stri
                                         l_stri = "".            
      if length(l_stri) > 64 then assign p_r3   = substring(l_stri,1,64)
                                         l_stri = substring(l_stri,65).
                             else assign p_r3   = l_stri
                                         l_stri = "".            


      end.      /* try to scan for specific parameters */
