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
**  Program: webinput.p
**       By:
** Descript:
**
*****************************************************************************
\***************************************************************************/

{src/web/method/cgidefs.i}

&SCOPED-DEFINE NEWLINE CHR(10)
&SCOPED-DEFINE TAB CHR(9)


/* for creating a <INPUT> field of type hidden,password, or text */
PROCEDURE web.output:
  /* Progress field containing the data */
  DEFINE INPUT PARAMETER hWid     AS HANDLE    NO-UNDO.
  /* the initial definition as contained in the HTML field definition */
  DEFINE INPUT PARAMETER fieldDef AS CHARACTER NO-UNDO.

  /* local variable definitions */
  DEFINE VARIABLE gtPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE resultString AS CHARACTER NO-UNDO.
  DEFINE VARIABLE screenValue  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE startPos     AS INTEGER   NO-UNDO.

  ASSIGN gtPos = INDEX(fieldDef, ">":U).
  
  IF INDEX(fieldDef,"<INPUT":U) = 0 OR gtPos = 0 THEN /* some error, get out! */
    RETURN.
  
  /* If it had a value, then replace it.  Otherwise just put one in
  ** at the end of the definition before the enclosing ">".
  */
  ASSIGN 
    startPos = INDEX(fieldDef, "value=":U).
  IF startPos = 0 THEN
    ASSIGN 
      startPos = INDEX(fieldDef, "value =":U).
    
  ASSIGN 
    resultString = IF startPos > 0 THEN 
                     SUBSTRING(fieldDef,1,startPos - 1,"CHARACTER":U)
                   ELSE
                     SUBSTRING(fieldDef,1,gtPos - 1,"CHARACTER":U).
  
  /* OK, now we have either skipped over the original value attribute setting 
  ** if there was one there.  Lets put a new value= setting. Typical field def 
  ** looks like this - <INPUT type=text name="Dave" value="Hello">. For now, 
  ** just pass along the whole thing, and replace the value. For things like 
  ** height, width, multiple, we need to determine if we want to inherit that 
  ** from the HTML field def or from the Progress field definition.
  ** Note that we need to convert the contents from ascii to html
  ** in case any invalid characters are in the widget itself.
  **
  ** If the PROGRESS widget is NOT enabled, just output the value. 
  */
  screenValue  = IF hWid:SCREEN-VALUE = ? THEN "" ELSE hWid:SCREEN-VALUE.
  RUN AsciiToHtml IN web-utilities-hdl (screenValue, OUTPUT screenValue).
  resultString = IF hWid:SENSITIVE EQ NO THEN (" ":U + screenValue + " ":U)
                 ELSE (resultString + ' VALUE="':U + screenValue + '">':U).

  {&OUT} resultString.

END PROCEDURE. /* web.output*/

/*---------------------------------------------------------------------------*/
/* for assigning the screen value from an INPUT field */
PROCEDURE web.input:
  /* Progress field containing the data */
  DEFINE INPUT PARAMETER hWid     AS HANDLE    NO-UNDO.
  /* the field value as obtained from an CGI post */
  DEFINE INPUT PARAMETER fieldVal AS CHARACTER NO-UNDO.

  ASSIGN hWid:SCREEN-VALUE = fieldVal.
END PROCEDURE. /* web.input */

/* webinput.p - end of file */
 
 
