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

