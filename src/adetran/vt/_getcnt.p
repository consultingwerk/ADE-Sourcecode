/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/vt/_getcnt.p
Author:       R. Ryan 
Created:      1/95 
Updated:      9/95
Purpose:      Visual Translator's Get Count program
Background:   Simple procedure for determining whether or not
              there are any records in the project.  This is used
              by vt/_main.p for sensitizing menus and buttons. 
Includes:     none
Called By:    vt/_main.p
*/

define output parameter TransFlag as logical no-undo.
define output parameter GlossaryFlag as logical no-undo.

find kit.XL_Project no-lock no-error.  
if available kit.XL_Project then 
DO:
  FIND FIRST kit.XL_Instance NO-LOCK NO-ERROR.
  FIND FIRST kit.XL_GlossEntry NO-LOCK NO-ERROR.
  ASSIGN
     TransFlag    = IF AVAILABLE kit.XL_Instance   THEN TRUE ELSE FALSE
     GlossaryFlag = IF AVAILABLE kit.XL_GlossEntry THEN TRUE ELSE FALSE.
END.
