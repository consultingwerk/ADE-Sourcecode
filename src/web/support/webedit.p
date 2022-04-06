/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
