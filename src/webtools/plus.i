/*********************************************************************
* Copyright (C) 2001 by Progress Software Corporation ("PSC"),       *
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
*   Per S Digre (pdigre@progress.com)                                *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------
 File: plus.i
 Purpose: Include for object initializations
 Updated: 03/22/01 pdigre@progress.com
            Initial version
          04/25/01 adams@progress.com
            WebSpeed integration
--------------------------------------------------------------------*/

{ src/web/method/cgidefs.i }

/* objects */
DEFINE NEW GLOBAL SHARED VARIABLE hCode     AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE hConfig   AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE hHTML     AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE hPlus     AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE hProutil  AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE hDatabase AS HANDLE NO-UNDO.

FUNCTION fDoWithFiles RETURNS CHARACTER
  ( cAction AS CHARACTER,
    cFiles AS CHARACTER) IN hCode.
 
/******************************************************/
/********* The HTML object ****************************/
/******************************************************/
DEFINE NEW GLOBAL SHARED VARIABLE cLink    AS CHAR NO-UNDO.

/* &GLOBAL-DEFINE cColorHeader " bgcolor=#C5AF96 " */
&GLOBAL-DEFINE cColorHeader " bgcolor=#DEB887 "
&GLOBAL-DEFINE cColorRow1 " bgcolor=#FFFFE6 "
&GLOBAL-DEFINE cBrowseTableDef " border=1 cellpadding=0 cellspacing=0 width=90% "

FUNCTION fLink RETURNS CHARACTER
  ( cMode AS CHARACTER,
    cValue AS CHARACTER,
    cText AS CHARACTER ) IN hHTML.

FUNCTION fRow RETURNS CHARACTER
  ( cData AS CHAR) IN hHTML.

FUNCTION fHRow RETURNS CHARACTER
  ( cLabels AS CHARACTER ) IN hHTML.

FUNCTION fBeginTable RETURNS CHARACTER
  ( cLabels AS CHARACTER ) IN hHTML.

FUNCTION fTable RETURNS CHARACTER
  ( cLabels AS CHARACTER,
    cData AS CHARACTER ) IN hHTML.

FUNCTION fProcess RETURNS CHARACTER
  ( cCmd AS CHARACTER,
    cAvoid AS CHARACTER ) IN hHTML.

/********* Object for Updating status screen **********/
DEFINE NEW GLOBAL SHARED VARIABLE cBrk         AS CHARACTER NO-UNDO.  /** am server config   **/
DEFINE NEW GLOBAL SHARED VARIABLE cDB          AS CHARACTER NO-UNDO.  /** am server config   **/
DEFINE NEW GLOBAL SHARED VARIABLE cDir         AS CHARACTER NO-UNDO.  /** am app config      **/
DEFINE NEW GLOBAL SHARED VARIABLE cLib         AS CHARACTER NO-UNDO.  /** am app config      **/

DEFINE NEW GLOBAL SHARED VARIABLE cStatic      AS CHARACTER NO-UNDO.  /** location of images **/
DEFINE NEW GLOBAL SHARED VARIABLE cFormTarget  AS CHARACTER NO-UNDO.  /** HTML Header param  **/
DEFINE NEW GLOBAL SHARED VARIABLE cFormHelp    AS CHARACTER NO-UNDO.  /** HTML Header param  **/
DEFINE NEW GLOBAL SHARED VARIABLE cFormBack    AS CHARACTER NO-UNDO.  /** HTML Header param  **/
DEFINE NEW GLOBAL SHARED VARIABLE cFormRefresh AS CHARACTER NO-UNDO.  /** HTML Header param  **/
DEFINE NEW GLOBAL SHARED VARIABLE cFormTitle   AS CHARACTER NO-UNDO.  /** HTML Header param  **/

DEFINE NEW GLOBAL SHARED VARIABLE cAction      AS CHARACTER NO-UNDO.  /** HTML Command       **/
DEFINE NEW GLOBAL SHARED VARIABLE cName        AS CHARACTER NO-UNDO.  /** HTML param         **/
DEFINE NEW GLOBAL SHARED VARIABLE cFiles       AS CHARACTER NO-UNDO.  /** Files selected     **/
DEFINE NEW GLOBAL SHARED VARIABLE cPath        AS CHARACTER NO-UNDO.  /** CodePath selected  **/

DEFINE NEW GLOBAL SHARED VARIABLE cProPath     AS CHARACTER NO-UNDO.  /** list of full paths to non progress directories ***/
DEFINE NEW GLOBAL SHARED VARIABLE cDirCD       AS CHARACTER NO-UNDO.  /** Current directory **/
DEFINE NEW GLOBAL SHARED VARIABLE cDLCBIN      AS CHARACTER NO-UNDO.  /** DLC install directory **/

FUNCTION fTrim     RETURNS CHARACTER ( cIn AS CHARACTER ) IN hPlus.
FUNCTION fIniLoad  RETURNS CHARACTER () IN hPlus.
FUNCTION fSetFiles RETURNS CHARACTER () IN hPlus.
FUNCTION fIniSave  RETURNS CHARACTER () IN hPlus.

&GLOBAL-DEFINE reportwindow IF fTestExecute() THEN RETURN.

/***************************************/
/*** Rules 1. Dir uses only forward /   ***/
/*** Rules 2. Dir always ends with  /    ***/

FUNCTION fFilesInDir RETURNS CHARACTER ( cDir AS CHARACTER )  IN hPlus.
FUNCTION fBat        RETURNS CHARACTER ( cCmd AS CHARACTER)   IN hPlus.
FUNCTION fHeader     RETURNS CHARACTER () IN hPlus.
FUNCTION fFooter     RETURNS CHARACTER () IN hPlus.

/**** Webspeed integration ******/
/* Developing add below line to allow changes otherwise enhance speed 
IF VALID-HANDLE(hPLUS)     THEN DELETE PROCEDURE hPlus.
IF VALID-HANDLE(hHTML)     THEN DELETE PROCEDURE hHTML.
IF VALID-HANDLE(hCode   )  THEN DELETE PROCEDURE hCode.
IF VALID-HANDLE(hConfig )  THEN DELETE PROCEDURE hConfig.
IF VALID-HANDLE(hProutil)  THEN DELETE PROCEDURE hProutil.
IF VALID-HANDLE(hDatabase) THEN DELETE PROCEDURE hDatabase.
*/

IF NOT VALID-HANDLE(hPLUS) THEN
  RUN webtools/plus.p PERSISTENT SET hPlus.
RUN setCallBack IN hPlus (THIS-PROCEDURE,'outputHTML').

IF NOT VALID-HANDLE(hHTML) THEN
  RUN webtools/util/html.p PERSISTENT SET hHTML.
RUN setCallBack IN hHTML (THIS-PROCEDURE,'outputHTML').

/* check development mode */
{ webutil/devcheck.i }

IF get-value('output-header') = '' THEN fIniLoad().

IF THIS-PROCEDURE:GET-SIGNATURE("output-header")  BEGINS "PROCEDURE":U THEN 
  RUN output-header.
IF THIS-PROCEDURE:GET-SIGNATURE("output-headers") BEGINS "PROCEDURE":U THEN 
  RUN output-headers.

IF get-value('output-header') = '' THEN DO:
  set-user-field('output-header','yes').
  OUTPUT-HTTP-HEADER("Pragma","No-Cache").
  OUTPUT-HTTP-HEADER("Expires","0").
  output-content-type("text/html").
END.

PROCEDURE destroy:
END PROCEDURE.

/* plus.i - end of file */
