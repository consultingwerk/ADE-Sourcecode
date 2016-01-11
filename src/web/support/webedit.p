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
/****************************************************************************
*****************************************************************************
**  Program: webedit.p
**       By:
** Descript:
**
*****************************************************************************
****************************************************************************/

{src/web/method/cgidefs.i}

&SCOPED-DEFINE NEWLINE CHR(10)
&SCOPED-DEFINE TAB CHR(9)

PROCEDURE web.output:
  /* Progress editor control containing the data */
  DEFINE INPUT PARAMETER hWid    AS HANDLE    NO-UNDO.
  /* the initial definition as contained in the HTML field definition */
  DEFINE INPUT PARAMETER fieldDef AS CHARACTER NO-UNDO.

  /* local variable definitions */
  DEFINE VARIABLE gtPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE resultString AS CHARACTER NO-UNDO.
  DEFINE VARIABLE screenValue  AS CHARACTER NO-UNDO.

  IF NOT VALID-HANDLE(hWid) OR 
    INDEX(fieldDef,"<TEXTAREA":U) = 0 OR
    INDEX(fieldDef, ">":U) = 0 THEN RETURN.  
  
  ASSIGN  
    resultString = REPLACE(fieldDef,"DISABLED":U,"":U)
    gtPos        = INDEX(resultString, ">":U)
    resultString = SUBSTRING(resultString,1,gtPos,"CHARACTER":U).
    
  /* The beginning part of the definition stores attributes, like -
  ** <TEXTAREA name="Dave" height=4 multiple>
  ** For now, just pass along the whole thing.  For things like height,
  ** width, we need to determine if we want to inherit that
  ** from the HTML field def or from the Progress field definition.
  ** Note that we need to convert the contents from ascii to html 
  ** in case any invalid characters are in the widget itself.
  */
  screenValue  = IF hWid:SCREEN-VALUE = ? THEN "" ELSE hWid:SCREEN-VALUE.
  RUN AsciiToHtml IN web-utilities-hdl (screenValue, OUTPUT screenValue).
  
  /* Set DISABLED flag if widget is not sensitive. This currently is known
     to work for Internet Explorer 4.x, and not Netscape Navigator 4.x. */
  IF NOT hWid:SENSITIVE THEN
    SUBSTRING(resultString,gtPos,0,"CHARACTER":U) = " DISABLED":U.
    
  resultString = resultString + screenValue + "</TEXTAREA>":U.
  
  {&OUT} resultString. 

END PROCEDURE. /* procedure web.output */

/*---------------------------------------------------------------------------*/
/* for assigning the screen value from an TESTAREA field */
PROCEDURE web.input:
  /* Progress field containing the data */
  DEFINE INPUT PARAMETER hWid     AS HANDLE    NO-UNDO.
  /* the field value as obtained from an CGI post */
  DEFINE INPUT PARAMETER fieldVal AS CHARACTER NO-UNDO.
  
  IF NOT VALID-HANDLE(hWid) THEN /* don't know how to handle - get out */ 
    RETURN.

  hWid:SCREEN-VALUE = fieldVal.

END PROCEDURE. /* web.input */

/* webedit.p - end of file */
