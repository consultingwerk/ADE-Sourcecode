/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
