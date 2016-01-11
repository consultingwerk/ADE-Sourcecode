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
