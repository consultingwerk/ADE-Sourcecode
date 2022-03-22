/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
