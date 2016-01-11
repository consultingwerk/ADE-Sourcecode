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

/* filesbtn.i--defines a Files... button, with a specified name.*/
/**
** PARAMETERS:
** &NAME    button name
** &NOACC   if present leave off accelerator on Files button
**/
&IF "{&NAME}" = "" &THEN
   &SCOPED-DEFINE BTN-NAME btn_File /*Default button name is btn_File*/
&ELSE
   &SCOPED-DEFINE BTN-NAME {&NAME}
&ENDIF

&IF "{&NOACC}" = "" &THEN
   DEFINE BUTTON {&BTN-NAME} LABEL "&Files..." 
&ELSE
   DEFINE BUTTON {&BTN-NAME} LABEL "Files..." 
&ENDIF
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   SIZE 11 by 1
&ENDIF
   .
