/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
  getdesc.i - Get the description for a table (in qbf-rel-buf) and store
      	      it in the qbf-rel-buf record.
*/

/*
 * This is one of the few times we do not want the alias name automatically
 * changed to its reference table. If we switched then all the aliases
 * of the table will have the same description in the table picker. And
 * that would not be good. So use the name of the alias as its description.
 */
  
IF qbf-rel-buf.sid = ? THEN
  RUN aderes/s-schema.p (qbf-rel-buf.tname, "", "", "FILE:DESC":u, 
                         OUTPUT qbf-rel-buf.tdesc).

/*
 * If there is no description then use the name of the table or alias.
 */

IF qbf-rel-buf.tdesc = "" THEN
  qbf-rel-buf.tdesc = ENTRY(2,qbf-rel-buf.tname,".").

/* getdesc.i - end of file */

