/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _adjcols.p

Description:
Traps the END-RESIZE event of each browse-column and adjusts the size
of browse column to the one set after the resize opreation.

Input Parameters:
   h_self : The handle of the object we are editing

Output Parameters:
   <None>

Author: Alex Chlenski

Date Created: 07.28.2000 

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h_self   AS WIDGET                            NO-UNDO.
{adeuib/uniwidg.i}              /* Universal widget definition              */
{adeuib/brwscols.i}             /* Brwose column temp-table definitions     */

/* This include performs browse column last minute adjustment right after 
   the user column-resize event */ 
FIND _U WHERE _U._HANDLE = h_self NO-ERROR.
IF NOT AVAILABLE _U THEN RETURN.
{adeuib/_adjcols.i}             
