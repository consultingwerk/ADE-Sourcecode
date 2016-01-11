/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
