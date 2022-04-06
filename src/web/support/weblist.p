/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------

File: weblist.p

Description:

Input Parameters:
   <none>
   
Output Parameters:
   <none>

Author:  
Created: 
Updated: 10/26/00 adams    Support for LIST-ITEM-PAIRS, contributed by
                           Doug Merritt

--------------------------------------------------------------------*/
{ src/web/method/cgidefs.i }

&SCOPED-DEFINE NEWLINE CHR(10)
&SCOPED-DEFINE TAB CHR(9)

PROCEDURE web.output:
/*--------------------------------------------------------------------
  Purpose: 
  Parameters: pList    - WebSpeed list object containing the data
              fieldDef - Initial definition as contained in the HTML 
                         field definition.
  Notes:
--------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pList    AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER fieldDef AS CHARACTER NO-UNDO.

  /* local variable definitions */
  DEFINE VARIABLE resultString  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE optionString  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE gtPos         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE isItemPairs   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE ix            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE numItems      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE listItem      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE listItemLabel AS CHARACTER  NO-UNDO.

  IF INDEX(fieldDef, "<SELECT":U) = 0 OR 
     INDEX(fieldDef, ">":U) = 0 THEN RETURN.

  ASSIGN  
    /* Strip out DISABLED attribute. */
    resultString = REPLACE(resultString,"DISABLED":U,"":U)
    /* look for the greater-than sign at the end of the <SELECT tag */
    gtPos        = INDEX(fieldDef, ">":U).
  
  /* The beginning of the definition stores attributes, such as 
     <SELECT NAME="Dave" HEIGHT=4 MULTIPLE>.  For now, just pass along the 
     whole thing.  For things like height, width, multiple, we need to 
     determine if we want to inherit that from the HTML field definition
     or from the WebSpeed field definition. */
  ASSIGN
    resultString = SUBSTRING(fieldDef,1,gtPos,"CHARACTER":U) + {&NEWLINE}
    numItems     = pList:NUM-ITEMS.
    
  /* If you test for LIST-ITEM-PAIRS and you have previously set LIST-ITEMS, 
     then an error occurs. */
  ASSIGN
    isItemPairs  = (pList:LIST-ITEM-PAIRS <> ?) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
    isItemPairs = FALSE.
  
  /* Add the DISABLED attribute if widget is not sensitive and increment
     location of ">" sign. This currently is known to work with Internet 
     Explorer 4.x, 5.x, but *not* Netscape Navigator 4.x. */
  IF NOT pList:SENSITIVE THEN
    SUBSTRING(resultString,gtPos,0,"CHARACTER":U) = " DISABLED":U.
  
  /* LIST-ITEM-PAIRS support */
  IF isItemPairs THEN
  DO ix = 1 TO numItems:
    ASSIGN 
      listItem      = ENTRY((ix - 1) * 2 + 2, 
                        pList:LIST-ITEM-PAIRS, pList:DELIMITER)
      listItemLabel = ENTRY((ix - 1) * 2 + 1, 
                        pList:LIST-ITEM-PAIRS, pList:DELIMITER).
    
    RUN AsciiToHtml IN web-utilities-hdl (listItem, OUTPUT listItem).
    RUN AsciiToHtml IN web-utilities-hdl (listItemLabel, OUTPUT listItemLabel).
    
    ASSIGN
      optionString = '<OPTION VALUE="':U + listItem + '"':U +
                     (IF pList:IS-SELECTED(ix) THEN ' SELECTED>':U ELSE '>':U)
      resultString = resultString + {&TAB} + optionString 
                     + listItemLabel + {&NEWLINE}.
  END.

  /* LIST-ITEMS support */
  ELSE
  DO ix = 1 TO numItems:
    listItem = pList:ENTRY(ix).
    RUN AsciiToHtml IN web-utilities-hdl (INPUT listItem, OUTPUT listItem).
    
    ASSIGN
      optionString = IF pList:IS-SELECTED(ix) THEN
                       "<OPTION SELECTED>":U ELSE "<OPTION>":U
      resultString = resultString + {&TAB} + optionString 
                     + listItem + {&NEWLINE}.
  END.

  ASSIGN resultString = resultString + "</SELECT>":U.
  
  {&OUT} resultString.
 
END PROCEDURE. /* web.output */
  
PROCEDURE web.input:
/*--------------------------------------------------------------------
  Purpose:    For assigning the screen value from an SELECT field.
  Parameters: hWid     - WebSpeed object containing the data
              fieldVal - Field value as obtained from an CGI post.
  Notes:
--------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER hWid     AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER fieldVal AS CHARACTER  NO-UNDO.
  
  /* local variable definitions */
  DEFINE VARIABLE rslt          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE delimPos      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE evalString    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE assignVal     AS CHARACTER  NO-UNDO.
  
  /* Save original fieldVal to assign to screen-value */
  ASSIGN assignVal = fieldVal.
  
  IF hWid:MULTIPLE THEN DO:
    /* Multiple selections possible.  fieldVal may be a delimited list.
       Need to parse fieldVal and check each item. */
    ASSIGN delimPos = INDEX(fieldVal, SelDelim).
    
    IF delimPos <> 0 THEN DO:
      /* Multiple items selected, parse them */
      IF SelDelim <> hWid:DELIMITER THEN RETURN.
      DO WHILE delimPos <> 0:
        ASSIGN
          /* Get the substring up to the delimiter. */
          evalString = SUBSTRING(fieldVal, 1, delimPos - 1)
          /* check if it is a valid item */
          rslt       = hWid:LOOKUP(evalString).
        IF (rslt = 0) THEN RETURN.
          
        /* Get the next delimiter */
        ASSIGN
          fieldVal = SUBSTRING(fieldVal, delimPos + 1)
          delimPos = INDEX(fieldVal, SelDelim).
      END.
    END.
  END.

  ASSIGN rslt = hWid:LOOKUP(fieldVal).
  IF (rslt <> 0) THEN
    ASSIGN hWid:SCREEN-VALUE = assignVal.

END PROCEDURE. /* web.input */

/* weblist.p - end of file */
