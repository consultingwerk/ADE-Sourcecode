/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _uibmode.p

Description: Change the characteristics of a SmartObject for use at
             design time in the UIB.   Basically, we make the frame
             movable, but not resizable, and we disable all additional
             widgets.

Input Parameters:  p_object - The Procedure HANDLE of the object

Output Parameters: <None>

Author: William T. Wood

Date Created: 20 February 1995
Updated:      02/13/98 SLK Handle ADM2

Note: _uibmode.p disables the widgets while walking the widget tree.
      There is code in _realizesmart.p that ensures that the
      affordance button (_S._affordance-handle) is enabled.
----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p_object AS HANDLE NO-UNDO.

DEFINE VAR i        AS INTEGER NO-UNDO.
DEFINE VAR i_fldgrp AS INTEGER NO-UNDO.

DEFINE VAR h        AS WIDGET-HANDLE NO-UNDO.
DEFINE VAR h_base   AS WIDGET-HANDLE NO-UNDO.
DEFINE VAR h_fldgrp AS WIDGET-HANDLE NO-UNDO.

{adeuib/vsookver.i}  /* Variables used for adm version */

/* Determine admVersion */
{adeuib/admver.i p_object admVersion}.

/* Get the base object handle from the object itself */
IF admVersion LT "ADM2":U THEN DO:
   RUN get-attribute IN p_object ('ADM-OBJECT-HANDLE':U) NO-ERROR.
   ASSIGN h_base = WIDGET-HANDLE(RETURN-VALUE) NO-ERROR.
END. /* ADM1 */
ELSE DO:
   cValue = dynamic-function("getContainerHandle" IN p_object) NO-ERROR.
   ASSIGN h_base = WIDGET-HANDLE(cValue) NO-ERROR.
END. /* > ADM1 */

/* If this is a valid frame object, then disable all its children */
IF VALID-HANDLE(h_base) AND h_base:TYPE eq "FRAME" THEN DO:
  /* Enable the frame for selecting. We enable moving and resizing if
     and only if the object supports methods for changing these.  */
  ASSIGN   
    h_base:BOX-SELECTABLE = NO   
    h_base:SELECTABLE     = YES
    h_base:MOVABLE        = CAN-DO (p_object:INTERNAL-ENTRIES,
                    IF admVersion LT "ADM2":U THEN "set-position" ELSE "repositionObject")
    h_base:RESIZABLE     = CAN-DO (p_object:INTERNAL-ENTRIES,
                    IF admVersion LT "ADM2":U THEN "set-size" ELSE "resizeObject").
                      
  /* Disable all its children.  NOTE the exit case of counting too many 
     children.  This is just to stop us from infinite looping. */
  h_fldgrp = h_base:FIRST-CHILD.
  DO WHILE VALID-HANDLE(h_fldgrp) AND (i_fldgrp < 100) :
    h = h_fldgrp:FIRST-CHILD.
    DO WHILE VALID-HANDLE(h) AND (i < 1000):
      /* Disable this item, and get the next item */
      ASSIGN h:SENSITIVE = FALSE
             i = i + 1
             h = h:NEXT-SIBLING.
    END. /* DO for each widget */
    /* Get the next field group */
    ASSIGN i_fldgrp = i_fldgrp + 1
           h_fldgrp = h_fldgrp:NEXT-SIBLING.
  END. /* DO for each field group */
END. /* IF VALID...FRAME...*/

