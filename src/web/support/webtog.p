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
/***************************************************************************\
*****************************************************************************
**  Program: webtog.p
**       By: Progress Software Corp
** Descript: Standard Web Tag Mapping utility between an HTML Checkbox and
**           WebSpeed TOGGLE-BOX widget.
**
*****************************************************************************
\***************************************************************************/

{src/web/method/cgidefs.i}

&SCOPED-DEFINE NEWLINE CHR(10)
&SCOPED-DEFINE TAB CHR(9)

PROCEDURE web.output:
  /* Progress toggle-box object containing the data */
  DEFINE INPUT PARAMETER hWid     AS HANDLE    NO-UNDO.
  /* the initial definition as contained in the HTML field definition */
  DEFINE INPUT PARAMETER fieldDef AS CHARACTER NO-UNDO.

  /* local variable definitions */
  DEFINE VARIABLE resultString AS CHARACTER NO-UNDO.

  /* Invalid widget handle or invalid fieldDef. */
  IF NOT VALID-HANDLE(hWid) OR 
    INDEX(fieldDef, "CHECKBOX":U) = 0 OR
    INDEX(fieldDef, ">":U) = 0 THEN RETURN.

  ASSIGN 
    /* remove special HotMetal case */ 
    resultString = REPLACE(fieldDef,'CHECKED="CHECKED"':U,"":U)
    /* remove remaining CHECKED if it exists */
    resultString = REPLACE(resultString,"CHECKED":U,"":U)
    /* remove DISABLED flag */
    resultString = REPLACE(resultString,"DISABLED":U,"":U)
    .

  /* See if the toggle box is checked...
     NOTE: We cannot directly check the hWid:CHECKED attribute because this
     fails if the SCREEN-VALUE is unknown (which occurs if we try to 
     DISPLAY a database field to a toggle-box with NO-ERROR 
     [see issue # 96-11-25-018]) */
  IF (hWid:INPUT-VALUE eq "yes":U) THEN 
    ASSIGN resultString = REPLACE(resultString,">":U," CHECKED>":U).

  /* Set DISABLED flag if widget is not sensitive. This currently is known 
     to work with Internet Explorer 4.x, and not Netscape Navigator 4.x. */
  IF NOT hWid:SENSITIVE THEN
    ASSIGN resultString = REPLACE(resultString,">":U," DISABLED>":U).
 
  {&OUT} resultString.
END PROCEDURE. /* web.output */
  
/*---------------------------------------------------------------------------*/
/* for assigning the screen value from an checkbox field */
PROCEDURE web.input:
  /* Progress field containing the data */
  DEFINE INPUT PARAMETER hWid     AS HANDLE    NO-UNDO.
  /* the field value as obtained from an CGI post */
  DEFINE INPUT PARAMETER fieldVal AS CHARACTER NO-UNDO.
  
  IF NOT VALID-HANDLE(hWid) THEN /* don't know how to handle - get out */ 
    RETURN.

  ASSIGN hwid:CHECKED = IF fieldVal = "" THEN FALSE ELSE TRUE.
  
END PROCEDURE. /* web.input */

/* webtog.p - end of file */ 
