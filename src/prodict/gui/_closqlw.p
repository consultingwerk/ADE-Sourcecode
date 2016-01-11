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

/*----------------------------------------------------------------------------

File: _closqlw.p

Description:
   Clean up after the closing of the _guisqlw.p program.  This is necessary
   so that the temp-table is deleted and certain tracking variables used in
   the program (GUI version only) are re-set.  
   
Author: Mario Brunetti

Date Created: 05/28/99 
-----------------------------------------------------------------------------*/

/* We're just sharing what we need, because sharing the frames and all was  *
 * causing a problem of certain variables not being available, etc.   */
 
DEF SHARED TEMP-TABLE t_Field LIKE _Field. 

DEF SHARED BUFFER w_Field FOR t_Field.

DEF SHARED VAR qry-width-hdl    AS WIDGET-HANDLE NO-UNDO.
DEF SHARED VAR s_PreviousTbl    AS CHAR          NO-UNDO.

DO ON ERROR UNDO, LEAVE
   ON STOP UNDO, LEAVE:

      qry-width-hdl:QUERY-CLOSE.

      DELETE WIDGET qry-width-hdl.

      FOR EACH w_Field:
         DELETE w_Field.
      END.

      s_PreviousTbl = ?.
END.      
