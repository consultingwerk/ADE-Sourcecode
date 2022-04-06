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

Author: Wm.T.Wood [from adeuuib/property.i by D. Ross Hunter]

Date Created: 1997

Modified:
  2/2/97 (wood) Remove fields needed by the old UIB property sheets.

----------------------------------------------------------------------------------*/

DEFINE {1} SHARED TEMP-TABLE _PROP   NO-UNDO
   FIELD _NAME           AS CHAR     LABEL "Prop Name"       FORMAT "X(20)"
   FIELD _VALUE          AS CHAR                             FORMAT "X(35)"
   FIELD _DATA-TYPE      AS CHAR                             FORMAT "!"
   FIELD _WIDGETS        AS CHAR
 INDEX _NAME IS PRIMARY UNIQUE _NAME.
