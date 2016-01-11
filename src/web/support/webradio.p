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
