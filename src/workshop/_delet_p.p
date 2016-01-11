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
  File: _delet_p.p
  
  Description: Closes and Deletes the _P record.  
  Parameters:  p_id -- integer (RECID) of the _P to delete.

  Author:  Wm. T. Wood
  Created: Dec. 31, 1996
------------------------------------------------------------------------*/

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_id AS INTEGER NO-UNDO.

/* Included Definitions ---                                             */
{ workshop/objects.i }      /* Shared web-object temp-tables. */

/* ************************  Main Code Block  *********************** */

/* Get the _P record for this file. */
FIND _P WHERE RECID(_P) eq p_id.

/* Close it (i.e. remove the associted code and objects. */
RUN workshop/_close_p.p (INPUT p_id, INPUT "":U /* No options */ ).

/* Now delete _P. */
DELETE _P.
