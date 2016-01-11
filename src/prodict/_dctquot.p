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

/* _dctquot.p - string quoting utility
 
  Modified:
     10/05/99 Mario B. Added banner warning.
     
*/

/*--------------------------- W A R N I N G ---------------------------------*
 * If you change this file, please consider whether or not you should also   *
 * change a copy of it that is included as an internal procedure in          *
 * prodict/dump/_dmputil.p.                                                  *
 *---------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER inline  AS CHARACTER            NO-UNDO.
DEFINE INPUT  PARAMETER quotype AS CHARACTER            NO-UNDO.
DEFINE OUTPUT PARAMETER outline AS CHARACTER INITIAL "" NO-UNDO.
DEFINE        VARIABLE  i       AS INTEGER              NO-UNDO.

IF INDEX(inline,quotype) > 0 THEN
  DO i = 1 TO LENGTH(inline):
    outline = outline + (IF SUBSTRING(inline,i,1) = quotype
              THEN quotype + quotype ELSE SUBSTRING(inline,i,1)).
  END.
ELSE
  outline = inline.

outline = (IF outline = ? THEN "?" ELSE quotype + outline + quotype).
RETURN.
