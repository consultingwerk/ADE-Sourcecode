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
** Program:         icondir.i (from _fndfile.p)
** Author:          Robert Ryan
** Date:            6/10/94
**
** Description:     Defines a global variable for adecion so that Progress
**                  doesn't continue to search Propath for the icon directory
** Inputs:          none - this is an include file
** Outputs:         global preprocessor {&ADEICON-DIR} references _ADEIconDir
**                  global preprocessor {&BITMAP-EXT} bitmap extension for O/S
**                  global preprocessor {&ICON-EXT} icon extension for O/S
*/
&GLOBAL ADEICONDIR "" /* allow to check if this file has already been included */

&IF DEFINED(ADEICON-DIR) = 0 &THEN
  DEFINE NEW GLOBAL SHARED VARIABLE _ADEIconDir AS CHAR NO-UNDO.

  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN  
     &GLOBAL BITMAP-EXT .bmp   /* .bmps are standard for ADE buttons           */
     &GLOBAL ICON-EXT   .ico   /* .icos are used for desktop & minimized       */ 
  &ELSE
     &GLOBAL BITMAP-EXT .xpm   /* usually xpm - sometimes xbm                  */
     &GLOBAL ICON-EXT   .xpm   /* usually xpm - sometimes xbm                  */
  &ENDIF

  IF _ADEIconDir = ? OR _ADEIconDir = "" THEN _ADEIconDir = "adeicon/".

  &GLOBAL ADEICON-DIR _ADEIconDir   /* The Qualified path of the icon directory      */
&ENDIF
