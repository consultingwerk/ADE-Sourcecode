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

  File: sharvars.i

  Description: Include file that defines the "global" or shared variables.

  Input Parameters: 
      <none>

  Output Parameters:
      <none>

  Author: D.M.Adams, Wm.T.Wood

  Created: 12-11-96

------------------------------------------------------------------------*/

/* ===================================================================== */
/*                    SHARED VARIABLES Definitions                       */
/* ===================================================================== */

DEFINE {1} SHARED VAR _comp_temp_file  AS CHARACTER INITIAL ? NO-UNDO.
       /* _comp_temp_file  is the temporary file used for compilation    */

DEFINE {1} SHARED VAR _err_msg         AS CHARACTER                NO-UNDO.
       /* _err_msg         is the first error message from the last      */
       /*                  compile attempt                               */

DEFINE {1} SHARED VAR _err_num         AS INTEGER                  NO-UNDO.
       /* _err_num         is the first error number from the last       */
       /*                  compile attempt                               */

DEFINE {1} SHARED VAR _err_recid       AS RECID INITIAL ?          NO-UNDO.
       /* _err_recid       is the record ID of the trigger temptable     */
       /*                  record containing the trigger code that       */
       /*                  caused the compiler to choke.                 */

DEFINE {1} SHARED VAR _h_tool          AS WIDGET-HANDLE            NO-UNDO.
       /* _h_tool          is the handle of the Workshops main procedure */
       /*                  (_h_win:FILE-NAME = "workshop/_main.w")       */

DEFINE {1} SHARED VAR _numeric_format  AS CHAR                     NO-UNDO.
       /* _numeric_format  is either "AMERICAN" or "EUROPEAN" depending  */
       /*                  on the start-up option. File import routines, */
       /*                  (eg. _reader.p) temporarily change this to    */
       /*                  "AMERICAN" and it must be changed back upon   */
       /*                  exitting those routines                       */

DEFINE {1} SHARED VAR _suppress_dbname AS LOGICAL INITIAL yes      NO-UNDO.
       /* _suppress_dbname is the option that causes the suppression of  */
       /*                  the database name when writing database       */
       /*                  fields into the Workshop 4GL output code      */

DEFINE {1} SHARED VAR _reset_joins     AS LOGICAL INITIAL no       NO-UNDO.
       /* _reset_joins     is the option that calculates natural OF-     */
       /*                  table joins at Workshop startup (_main.w)     */

DEFINE {1} SHARED VAR _timeout_period  AS DECIMAL INITIAL 60       NO-UNDO.
       /* _timeout_period  is the number of minutes that the agent will  */
       /*                  remain locked before it times-out.            */

DEFINE {1} SHARED VAR _VERSION-NO      AS CHAR INITIAL "WDT_v2r1"  NO-UNDO.
       /*  _VERSION-NO  WebSpeed Workshop File Verson Number             */
       /*    WDT_v2r1 (WTW 12/29/96) WebSpeed Design Tool Version 2.0 R1 */
       /*  Old Values:                                                   */
       /*    WDT_v1r1 (JEP 09/04/96) WebSpeed Design Tool Version 1.0 R1 */
 
/* sharvars.i - end of file */
        	
