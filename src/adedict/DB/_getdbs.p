/*********************************************************************
* Copyright (C) 2000,2010 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*-----------------------------------------------------------------------

File: _getdbs.p

Description:   
   This procedure gets the list of databases as follows:

   This includes:
      all connected databases and foreign databases whose schema holders
      are connected.

Shared Output:
   s_CurrDb    	  - will have been set.

Author: Laura Stern

Date Created: 01/28/92 

History:    
     laurief       12/18/97    Made V8 to "generic version" changes
     mcmann        10/29/98    Change message to read V9 Dictionary
     mcmann        11/23/02    Changed adecomm/_dictdb.p to prodict/_dictdb.p
     mcmann        07/24/03    Changed for V10
     mcmann        09/23/03    Changed message to remove version of dictionary
     fernando      09/30/10    Support for OE11
-----------------------------------------------------------------------*/

{ adedict/dictvar.i shared }
{ adedict/brwvar.i  shared }

{ adecomm/getdbs.i
  &new = "NEW"
  }

Define var l_i     as int     NO-UNDO.
Define var l_strng as char    NO-UNDO.

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

/* initialize cache */
assign
  s_DbCache_Cnt        = 0
  s_lst_dbs:list-items = "".

/* get list of dbs */
if NUM-DBS <> 0 
 then do:
  RUN prodict/_dictdb.p.
  RUN adecomm/_getdbs.p.
  end.
  
/* create cache and selection-list */
for each s_ttb_db:
  
  /* get rid of older versions, because we can't handle them and
   * Keep track of these old connected databases so we don't keep
   * repeating this message to the user every time they connect
   * to a new database.
   */
  if INTEGER(s_ttb_db.vrsn) < 11
   then do:
    if NOT CAN-DO (s_OldDbs, s_ttb_db.ldbnm)
     then do:
      assign
        s_OldDbs = s_OldDbs
                 + (if s_OldDbs = "" then "" else ",")
                 + s_ttb_db.ldbnm.
        l_strng  = "R" + s_ttb_db.vrsn.
      message 
        "Database" s_ttb_db.ldbnm "is a" l_strng "database." SKIP
        "This dictionary cannot be used with a" SKIP
        "OpenEdge" l_strng "database.  Use the dictionary" SKIP
        "under OpenEdge" l_strng "to access this database." SKIP(1)
        "(Note: Database" s_ttb_db.ldbnm "is still connected.)"
         view-as ALERT-BOX INFORMATION buttons OK.
      end.
    next.
    end.

  /* Skip auto-connect records
   */
  if   s_ttb_db.local = FALSE
   and s_ttb_db.dbtyp = "PROGRESS"
   then next.
   
  /* check for number of dbs to be maller than extent */
  if EXTENT(s_DbCache_Pname) <= s_DbCache_Cnt
   then next.

  assign
    /* Add the name to the select list in the browse window. */
    s_Res = ( if s_ttb_db.local = TRUE
                then s_lst_Dbs:add-last(s_ttb_db.ldbnm) in frame browse
                else s_lst_Dbs:add-last( " " + s_ttb_db.ldbnm
                                       + "(" + s_ttb_db.sdbnm + ")"
                                       ) in frame browse
            )
    /* generate internal db-type */
    l_strng = { adecomm/ds_type.i
                 &direction = "etoi"
                 &from-type = "s_ttb_db.dbtyp"
              }

    /* Add database to the cache. */
    { adedict/DB/cachedb.i
       &Lname  = s_ttb_db.ldbnm
       &Pname  = s_ttb_db.pdbnm
       &Holder = s_ttb_db.sdbnm
       &Type   = l_strng
       }

  end.  /* for each s_ttb_db */


