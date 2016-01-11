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
/*
 * _ainti.p
 *
 *    Initialize the integration procedures that can be changed
 *    during a session. Procedures are initialized in this order:
 *  
 *    1. feature security
 *    2. WHERE security
 *    3. menu security
 *    4. field security
 *    5. directory switch
 *
 *    Warn user about other missing integration procedures.
 *
 *    6. initialize vars and interface
 *    7. login
 *    8. logo
 *    9. table security
 */

{ aderes/s-system.i }

DEFINE VARIABLE qbf-f AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-l AS LOGICAL   NO-UNDO.

ASSIGN
  _sfCheckSecurity = ?
  _whereSecurity   = ?
  _menuCheck       = ?
  _fieldCheck      = ?
  _dirSwitch       = ?
  .

/* Set up the functions that can be replaced by the admin. First check to
 * see if the function provided by the admin is there. If it is, then
 * use it. Else use RESULTS Core function.
 */
IF qbf-u-hook[{&ahSecFeatCode}] <> ? THEN DO:
  RUN aderes/_ssearch.p (qbf-u-hook[{&ahSecFeatCode}], OUTPUT qbf-f).

  IF qbf-f = ? THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
      SUBSTITUTE("The procedure for Feature Security Check, '&1', was not found. ^^&2 will use its Core Security Check.",
    qbf-u-hook[{&ahSecFeatCode}],qbf-product)).

  ELSE
    _sfCheckSecurity = qbf-f.
END.

IF qbf-u-hook[{&ahSecWhereCode}] <> ? THEN DO:
  /* The secure WHERE code doesn't have a RESULTS Core version. If the
   * Admin doesn't provide a function then this stuff will not be added
   * to the generated text. */
  RUN aderes/_ssearch.p (qbf-u-hook[{&ahSecWhereCode}], OUTPUT qbf-f).

  IF qbf-f = ? THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
      SUBSTITUTE("The procedure for Where Security Check, '&1', was not found. ^^&2 cannot add this information to the WHERE clause.",
    qbf-u-hook[{&ahSecWhereCode}],qbf-product)).

  ELSE
    _whereSecurity = qbf-f.
END.

IF qbf-u-hook[{&ahFeatCheckCode}] <> ? THEN DO:
  /* The feature/menu check doesn't have a RESULTS Core version. If the
   * Admin doesn't provide a function then this stuff will not be added
   * to the generated text. */
  RUN aderes/_ssearch.p (qbf-u-hook[{&ahFeatCheckCode}], OUTPUT qbf-f).

  IF qbf-f = ? THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
      SUBSTITUTE("The procedure for Menu Check, '&1', was not found.",
      qbf-u-hook[{&ahFeatCheckCode}])).

  ELSE
    _menuCheck = qbf-f.
END.

IF qbf-u-hook[{&ahSecFieldCode}] <> ? THEN DO:
  /* The field security file doesn't exist. If Admin doesn't provide a 
   * function then there will be no additional field security.  */
  RUN aderes/_ssearch.p (qbf-u-hook[{&ahSecFieldCode}], OUTPUT qbf-f).

  IF qbf-f = ? THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
      SUBSTITUTE("The procedure for Field Security, '&1', was not found. ^^&2 will use default Field Security.",
      qbf-u-hook[{&ahSecFieldCode}],qbf-product)).
  
  ELSE
    _fieldCheck = qbf-f.
END.

IF qbf-u-hook[{&ahDirSwitchCode}] <> ? THEN DO:
  /* The directory switch file doesn't exist. If Admin doesn't provide a 
   * function then the end user will not be able to switch to another query 
   * directory. */
  RUN aderes/_ssearch.p (qbf-u-hook[{&ahDirSwitchCode}], OUTPUT qbf-f).

  IF qbf-f = ? THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
      SUBSTITUTE("The procedure for Directory Switch, '&1', was not found.",
      qbf-u-hook[{&ahDirSwitchCode}],qbf-product)).

  ELSE
    _dirSwitch = qbf-f.
END.

/* Now check for the other integration procedures */
IF qbf-u-hook[{&ahSharedVar}] <> ? THEN DO:
  /* The initialize shared variable file doesn't exist. */
  RUN aderes/_ssearch.p (qbf-u-hook[{&ahSharedVar}], OUTPUT qbf-f).

  IF qbf-f = ? THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
      SUBSTITUTE("The procedure for Initialize Vars and Interface, '&1', was not found.",
      qbf-u-hook[{&ahSharedVar}],qbf-product)).
END.

IF qbf-u-hook[{&ahLogin}] <> ? THEN DO:
  /* The login file doesn't exist. */
  RUN aderes/_ssearch.p (qbf-u-hook[{&ahLogin}], OUTPUT qbf-f).

  IF qbf-f = ? THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
      SUBSTITUTE("The procedure for Login Program, '&1', was not found.",
      qbf-u-hook[{&ahLogin}],qbf-product)).
END.

IF qbf-u-hook[{&ahLogo}] <> ? THEN DO:
  /* The logo file doesn't exist. */
  RUN aderes/_ssearch.p (qbf-u-hook[{&ahLogo}], OUTPUT qbf-f).

  IF qbf-f = ? THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
      SUBSTITUTE("The procedure for Logo Screen, '&1', was not found.",
      qbf-u-hook[{&ahLogo}],qbf-product)).
END.

IF qbf-u-hook[{&ahSecTableCode}] <> ? THEN DO:
  /* The table security file doesn't exist. */
  RUN aderes/_ssearch.p (qbf-u-hook[{&ahSecTableCode}], OUTPUT qbf-f).

  IF qbf-f = ? THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
      SUBSTITUTE("The procedure for Table Security, '&1', was not found.",
      qbf-u-hook[{&ahSecTableCode}],qbf-product)).
END.

/* _ainti.p - end of file */

