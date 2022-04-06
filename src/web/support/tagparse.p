/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/***************************************************************************\
*****************************************************************************
**          Program:  tagparse.p
**
**           Author:  
**
**      Description:  The purpose of this procedure is to parse 'fieldDef'
**                    for 'paramName'.
**
**                    'FieldDef' contains the tag definition.
**                    'ParamName' is the parameter/token that is to be
**                    parsed for in 'fieldDef so that its value can be
**                    returned.
**
**                    *  example WSTAG tag stored in 'fieldDef':
**                     <!--WSTAG NAME=CustTable FILE=custtbl.p-->
**
**                    *  example WSMSG  tag stored in 'fieldDef':
**                     <!--WSMSG NAME=all VALUE=Application Messages-->
**
**                    *  parameters/tokens in the tags:  
**                     NAME, TYPE, FILE, VALUE 
**
**                    This file is called by web/support/tagrun.p
**                                     -and-
**                    This file is called by web/support/webmsg.p
**
**  Input Parameters: fieldDef          custom tag definition from HTML file
**                    paramName         parameter/token to parse custom tag for
**
** Output Parameters: paramValue        value of parameter/token in tag
*****************************************************************************
\***************************************************************************/


{src/web/method/cgidefs.i}


/* INPUT PARAMETERS */
DEFINE INPUT  PARAMETER fieldDef        AS CHARACTER                 NO-UNDO.
DEFINE INPUT  PARAMETER paramName       AS CHARACTER                 NO-UNDO.

/* OUTPUT PARAMETERS */
DEFINE OUTPUT PARAMETER paramValue      AS CHARACTER                 NO-UNDO.


/* LOCAL VARIABLES */
DEFINE VARIABLE         paramPos        AS INTEGER INITIAL 0         NO-UNDO.
DEFINE VARIABLE         delimPos        AS INTEGER INITIAL 0         NO-UNDO.  

DEFINE VARIABLE         searchString    AS CHARACTER FORMAT "x(32)":U  NO-UNDO.
DEFINE VARIABLE         tempString      AS CHARACTER FORMAT "x(50)":U  NO-UNDO.


/* Determine what token to parse fieldDef for */ 
case paramName:
  WHEN "name":U THEN 
    searchString = "NAME=":U.
  WHEN "type":U THEN
    searchString = "TYPE=":U.
  WHEN "file":U THEN
    searchString = "FILE=":U.
  WHEN "value":U THEN 
    searchString = "VALUE=":U.
END CASE.


/* Get the token value out of the custom tag.  Be sure to */
/* handle a custom tag where the token value may be a quoted string */
ASSIGN 
  paramPos    = INDEX(fieldDef, searchString)
  tempString = ""
  paramValue = ""
.

IF (paramPos <> 0) THEN
DO:
  ASSIGN tempString  = SUBSTRING(fieldDef, paramPos + LENGTH(searchString), -1,
                                 "CHARACTER":U). 

  IF (tempString BEGINS '"':U) THEN 
  DO:       
    delimPos       = INDEX(tempString, '" ':U).
    IF (delimPos <> 0) THEN
      paramValue   = SUBSTRING(tempString, 2, delimPos - 2, "CHARACTER":U).
    ELSE
    DO:
      delimPos     = INDEX(tempString, '--':U).
      IF (delimPos <> 0) THEN
        paramValue   = SUBSTRING(tempString, 2, delimPos - 3, "CHARACTER":U).
    END.
  END.
  ELSE
  DO:
    delimPos       = INDEX(tempString, ' ':U).
    IF (delimPos <> 0) THEN
      paramValue   = SUBSTRING(tempString, 1, delimPos - 1, "CHARACTER":U).
    ELSE
    DO:
      delimPos     = INDEX(tempString, '--':U).
      IF (delimPos <> 0) THEN
        paramValue   = SUBSTRING(tempString, 1, delimPos - 1, "CHARACTER":U).
    END.
  END.
END.
