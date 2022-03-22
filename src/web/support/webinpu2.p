/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/***************************************************************************\
*****************************************************************************
**  Program: webinpu2.p
**       By:
** Descript: Like webinput.p, except PROGRESS form HELP is added as 
** onBlur/onFocus JavaScript to the HTML field.
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
                 ELSE (resultString 
                       + ' VALUE="':U + screenValue + '"':U
                       + (IF hWid:HELP eq "" 
                          THEN ""   /* No PROGRESS HELP */
                          ELSE " onFocus=~"window.status='" + hWid:HELP + "'~"" 
                             + " onBlur= ~"window.status=''~"")
                       + '>':U).

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
 
 
