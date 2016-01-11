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

