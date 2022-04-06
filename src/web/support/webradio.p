/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/***************************************************************************\
*****************************************************************************
**  Program: webradio.p
**       By:
** Descript:
**
*****************************************************************************
\***************************************************************************/

{src/web/method/cgidefs.i}

&SCOPED-DEFINE NEWLINE CHR(10)
&SCOPED-DEFINE TAB CHR(9)

PROCEDURE web.output:
  DEFINE INPUT PARAMETER hWid      AS HANDLE    NO-UNDO. /* radio object */
  DEFINE INPUT PARAMETER pFieldDef AS CHARACTER NO-UNDO. /* HTML field def */
  DEFINE INPUT PARAMETER pItem     AS INTEGER   NO-UNDO. /* radio item# */

  /* local variable definitions */
  DEFINE VARIABLE aValue           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE checked          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE endPos           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE resultString     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE screenValue      AS CHARACTER NO-UNDO.

  /* Invalid widget handle or pFieldDef. */
  IF NOT VALID-HANDLE(hWid) OR 
    INDEX(pFieldDef, "RADIO":U) = 0 OR
    INDEX(pFieldDef, ">":U) = 0 THEN RETURN.
 
  IF ENTRY(pItem * 2, hWid:RADIO-BUTTONS) <> "" THEN
    ASSIGN aValue = ENTRY(pItem * 2, hWid:RADIO-BUTTONS).

  ASSIGN 
    screenValue  = IF hWid:SCREEN-VALUE = ? 
                   THEN "" ELSE hWid:SCREEN-VALUE
    resultString = pFieldDef.

  IF aValue = screenValue THEN                       
    ASSIGN resultString = REPLACE(resultString,">":U," CHECKED>":U).
    
  /* Set DISABLED flag if widget is not sensitive. This currently is known 
     to work with Internet Explorer 4.x, and not Netscape Navigator 4.x. */
  IF NOT hWid:SENSITIVE THEN
    ASSIGN resultString = REPLACE(resultString,">":U," DISABLED>":U).

  {&OUT} resultString.

END PROCEDURE. /* web.output */
  
/*---------------------------------------------------------------------------*/
/* for assigning the screen value from a radio field */
PROCEDURE web.input:
  /* Progress field containing the data */
  DEFINE INPUT PARAMETER hWid     AS HANDLE    NO-UNDO.
  /* the field value as obtained from an CGI post */
  DEFINE INPUT PARAMETER fieldVal AS CHARACTER NO-UNDO.
  
  ASSIGN hWid:SCREEN-VALUE = fieldVal.
END PROCEDURE. /* web.input */

/* webradio.p - end of file */ 
