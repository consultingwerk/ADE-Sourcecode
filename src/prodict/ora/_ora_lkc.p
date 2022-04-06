/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/ora/_ora_lkc.p   THIS ROUTINE GETS CALLED ONCE PER LINK!

Description:
    CONNECTs to s_ldbname and sets alias DICTDBG
    
Input-Parameters:  
   none
                                     
Output-Parameters: 
    none
    
Used/Modified Shared Objects:
    DICTDBG     alias gets reset for all selected links
History:
    hutegger    94/10/18    creation
    
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

&SCOPED-DEFINE DATASERVER YES
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
&UNDEFINE DATASERVER

/*---------------------------  TRIGGERS  ---------------------------*/

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/


SESSION:IMMEDIATE-DISPLAY = yes.
RUN adecomm/_setcurs.p ("WAIT").


if s_level > 0
 then do:  /* only if s_ttb_link is for linked db */

/** / message "_ora_lkc.p: set alias DICTDBG to" s_ldbname
/**/     view-as alert-box.
/ **/
  if not connected(s_ldbname)
   then connect value(s_ldbconct).

  run prodict/ora/_ora_als.p        /* create alias */
    ( INPUT s_ldbname
    ).

  end.     /* only if s_ttb_link is for linked db */

else if LDBNAME("DICTDBG") <> user_dbname
 then do:  /* use normal _db for local-db; set alias only if needed */
  
/** / message "_ora_lkc.p: set alias DICTDBG to" user_dbname
/**/     view-as alert-box.
/ **/
  if not connected(user_dbname)
   then connect value(user_dbname). /* should always be no-op */

  run prodict/ora/_ora_als.p        /* create alias */
    ( INPUT user_dbname
    ).

  end.     /* use normal _db for local-db; set alias only if needed */

/** /
 else message "DICTDBG already set to" user_dbname view-as alert-box.
/ **/
  
/*------------------------------------------------------------------*/
