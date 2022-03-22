/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
