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
/*------------------------------------------------------------------------
  File: _close_p.p
  
  Description: Closes the _P record (by removing all the associated records)  
  Parameters:  p_id      -- integer (RECID) of the _P to delete.
               p_options -- char list of options [unused]

  Author:  Wm. T. Wood
  Created: Dec. 31, 1996
------------------------------------------------------------------------*/

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_id      AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER p_options AS CHAR    NO-UNDO.

/* Included Definitions ---                                             */
{ workshop/code.i }         /* Shared code block temp-tables.           */
{ workshop/objects.i }      /* Shared web-object temp-tables.           */
{ workshop/uniwidg.i }      /* Shared universal widget temp-tables.     */

/* ************************  Main Code Block  ************************* */

/* Get the _P record for this file. */
FIND _P WHERE RECID(_P) eq p_id.

/* Loop though all associated code blocks for this file. */
FOR EACH _code WHERE _code._p-recid eq p_id: 
  { workshop/delet_cd.i } /* delete code block and the associated text */
END. /* FOR EACH _code... */

/* Delete all the universal widget records. */
FOR EACH _U WHERE _U._p-recid eq RECID(_P):   
  RUN workshop/_delet_u.p (RECID(_U), yes /* TRASH */ ).
END.

/* Now mark the record as closed (and unmodified). */
ASSIGN _P._open     = FALSE
       _P._modified = FALSE
       .