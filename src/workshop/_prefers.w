&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Web-Object
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
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
/*------------------------------------------------------------------------
  File: _prefers.w
  
  Description: Display the Workshop Files Preferences frame 
  
  Parameters:  <none>
  
  Fields: <none>
  
  Author:  D.M.Adams
  
  Created: April 1997
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO. /* calling procedure  */

/* Included Definitions ---                                             */
{ workshop/errors.i }        /* Error handler and functions.            */
{ workshop/help.i }          /* Include context strings.                */
{ workshop/sharvars.i }      /* The shared workshop variables           */

{ webutil/wstyle.i }         /* Standard style definitions & functions. */

&ANALYZE-RESUME

&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Web-Object

&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES

/* ************************* Included-Libraries *********************** */
{src/web/method/wrap-cgi.i}

&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 

/* ******************* Local Variable Definitions ******************* */

DEFINE VARIABLE c_newvalue   AS CHARACTER NO-UNDO.
DEFINE VARIABLE d_scrap      AS INTEGER   NO-UNDO.
DEFINE VARIABLE err_count    AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_newvalue   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l_changes    AS LOGICAL   NO-UNDO.

/* ************************  Main Code Block  *********************** */

IF REQUEST_METHOD eq "POST":U THEN DO:
  /* AutoJoin has been removed for Beta2, so this preference should be hidden
     for now. 
  l_newvalue = get-value("ResetJoins":U) eq "Yes":U.
  IF l_newvalue ne _reset_joins THEN
    ASSIGN 
      _reset_joins = l_newvalue
      l_changes    = TRUE.
  */

  /* Note opposite meaning of workshop global, _suppress_dbname,
     and "ShowDbName" form field */
  l_newvalue = NOT (get-value("ShowDbName":U) eq "Yes":U).
  IF l_newvalue ne _suppress_dbname THEN
    ASSIGN 
      _suppress_dbname = l_newvalue
      l_changes        = TRUE.
    
  c_newvalue = get-value("TimeoutPeriod":U).
  ASSIGN d_scrap = INTEGER(c_newvalue) NO-ERROR.
  IF ERROR-STATUS:ERROR AND d_scrap NE ? THEN DO:
    RUN Add-Error IN _err-hdl ("ERROR":U, ?, "Workshop Timeout Period is invalid." +
      (IF l_changes THEN " Remaining changes were saved." ELSE "")).
    err_count = err_count + 1.
  END.
  ELSE IF INTEGER(c_newvalue) ne _timeout_period THEN DO:
    ASSIGN 
      _timeout_period = INTEGER(c_newvalue)
      l_changes       = TRUE.
  
    RUN set-web-state IN web-utilities-hdl (pHandle, _timeout_period).
  END.
      
  IF l_changes THEN
    RUN workshop/_putpref.p.
END.

/* Output the page. */
RUN OutputContentType IN web-utilities-hdl ('text/html':U).

{&OUT}
  { workshop/html.i 
    &SEGMENTS = "head,open-body,title-line"
    &TITLE    = "Preferences"
    &FRAME    = "WS_main" 
    &AUTHOR   = "D.M.Adams"
    &CONTEXT  = "{&File_Preferences_Help}" }.
    
{&OUT}
  '<CENTER>~n':U
  '<FORM METHOD="POST">~n':U
  '<CENTER>~n':U
  '<INPUT TYPE="SUBMIT" VALUE="Submit">~n':U
  '<INPUT TYPE="RESET" VALUE="Reset">~n':U
  '</CENTER><BR>~n':U
  '<TABLE':U get-table-phrase("":U) '>~n':U
  '<TR>~n':U
  '  <TD>' format-label ("Qualify Fields with Database Name", "ROW":U, "":U) '</TD>~n':U
  '  <TD><INPUT TYPE="RADIO" NAME="ShowDbName" VALUE="Yes"':U
           (IF NOT _suppress_dbname THEN " CHECKED" ELSE "":U) '>Yes~n':U
  '      <INPUT TYPE="RADIO" NAME="ShowDbName" VALUE="No"':U
           (IF _suppress_dbname THEN " CHECKED":U ELSE "") '>No</TD>~n':U
  '</TR>~n':U
  
  /* AutoJoin has been removed for Beta2, so this preference should be hidden
     for now. 
  '<TR>~n':U
  '  <TD>' format-label ("Calculate Table Joins at Startup", "ROW":U, "":U) '</TD>~n':U
  '  <TD><INPUT TYPE="RADIO" NAME="ResetJoins" VALUE="Yes"':U
           (IF _reset_joins THEN " CHECKED":U ELSE "") '>Yes~n':U
  '      <INPUT TYPE="RADIO" NAME="ResetJoins" VALUE="No"':U
           (IF NOT _reset_joins THEN " CHECKED":U ELSE "") '>No</TD>~n':U
  '</TR>~n':U
  */
  
  '<TR>~n':U
  '  <TD>' format-label ("Workshop Timeout Period (minutes)", "ROW":U, "":U) '</TD>~n':U
  '  <TD><INPUT TYPE="TEXT" NAME="TimeoutPeriod" VALUE="':U _timeout_period '"</TD>~n':U
  '</TR>~n':U
  '</TABLE>~n':U
  '</FORM>~n':U    
  '</CENTER>~n':U
  .

IF REQUEST_METHOD = "POST":U THEN DO:
  IF l_changes THEN DO:
    IF err_count = 0 THEN
      /* {&OUT} '<UL>Preference changes were successfully saved.</UL>~n'. */
      RUN Add-Error IN _err-hdl ("",?,"Preference changes were successfully saved.").
  END.
  ELSE
    /*{&OUT} '<UL>There were no Preference changes to save.</UL>~n'.*/
    RUN Add-Error IN _err-hdl ("",?,"There were no Preference changes to save.").
END.
    
RUN output-errors IN _err-hdl ("all":U, ? /* use default template*/).

{&OUT}
  '</BODY>~n':U
  '</HTML>~n':U
  .
    
&ANALYZE-RESUME
 
/* _prefers.w - end of file */
