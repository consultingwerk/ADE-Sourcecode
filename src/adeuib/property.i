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

File: property.i

Description:
    Temp-Table definitions for UIB property sheet support.

Input Parameters:
   {1} is "NEW" (or blank)

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1994

---------------------------------------------------------------------------*/

DEFINE {1} SHARED TEMP-TABLE _PROP   NO-UNDO
   FIELD _NAME           AS CHAR     LABEL "Prop Name"       FORMAT "X(20)"
   FIELD _VALUE          AS CHAR                             FORMAT "X(35)"
   FIELD _SQ             AS INTEGER                          FORMAT ">>9"
   FIELD _DISP-SEQ       AS INTEGER                          FORMAT ">>9"
   FIELD _CLASS          AS INTEGER                          FORMAT ">9"
   FIELD _DATA-TYPE      AS CHAR                             FORMAT "!"
   FIELD _SIZE           AS CHAR
   FIELD _ADV            AS LOGICAL /* Property set on Advanced Property Sheet  */
   FIELD _CUSTOM         AS LOGICAL /* Property can be set in a Custom Widget   */
   FIELD _GEOM           AS LOGICAL /* Property sets Geometry (Location or size)*/
   FIELD _WIDGETS        AS CHAR
 INDEX _NAME IS PRIMARY UNIQUE _NAME
 INDEX _DISP-SEQ _DISP-SEQ.
