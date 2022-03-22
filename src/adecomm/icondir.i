/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
