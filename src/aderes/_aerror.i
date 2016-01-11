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
 * _aerror.i
 *
 *   This insert decides if there are any system error and writes
 *   out any error messages.
 *
 *  Input
 *
 *    loopVar   An integer variable.
 *    message   The message to display.
 */

IF ERROR-STATUS:ERROR = TRUE AND ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:

  MESSAGE "{&msg}" VIEW-AS ALERT-BOX.

  DO {&i} = 1 TO ERROR-STATUS:NUM-MESSAGES:
    MESSAGE ERROR-STATUS:GET-NUMBER({&i}) ERROR-STATUS:GET-MESSAGE({&i})
      VIEW-AS ALERT-BOX.
  END. 
END.

/* _aerror.i - end of file */

