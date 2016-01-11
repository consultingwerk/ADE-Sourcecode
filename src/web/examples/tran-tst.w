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
  File: tran-tst.w
  Description: Tests the 'set-transaction-state' logic in WebSpeed
  Author: Wm. T. Wood
  Created: Sept 14, 1996  
  Updated:
   wood  3-10-97  Convert to Version 2 of WebSpeed
   brogers 10-98 Convert to Version 3 of WebSpeed
------------------------------------------------------------------------*/

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


/* ************************  Main Code Block  *********************** */

/* Handle the WEB event. */
RUN process-web-request.

&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE process-web-request 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process Web Request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR c_action  AS CHAR NO-UNDO.
  DEFINE VAR c_num     AS CHAR NO-UNDO.
  DEFINE VAR c_list    AS CHAR NO-UNDO.
  DEFINE VAR t-state    AS CHAR NO-UNDO.
  DEFINE VAR w-state    AS CHAR NO-UNDO.
  
  /* Get the action that we are supposed to take. */
  c_action = get-field("submitAction").
  
  /* Check the State-Aware and Transaction-state actions. The "Update"
     action is handled later. */
  CASE c_action:
    WHEN "State-Aware":U THEN 
      RUN set-web-state IN web-utilities-hdl (THIS-PROCEDURE, 30).
    WHEN "State-Less":U THEN
      RUN set-web-state IN web-utilities-hdl (THIS-PROCEDURE, 0).
    WHEN "Start":U OR  
    WHEN "Undo":U OR 
    WHEN "Retry":U OR
    WHEN "Commit":U THEN
      RUN set-transaction-state IN web-utilities-hdl (c_action).
  END CASE.
  
  /* Get the Web and Transaction states. */
  RUN get-attribute ('Web-State':U).
  w-state = RETURN-VALUE.
  RUN get-transaction-state IN web-utilities-hdl.
  t-state = RETURN-VALUE.
     
  /* 
   * Output the MIME header, and start returning the HTML form.
   */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).
  
  /*
   * Create the HTML form.  
   */
  {&OUT}
    '<HTML>':U SKIP
    '<HEAD>':U SKIP
    '<TITLE>':U 'Transaction State' '</TITLE>':U SKIP
    '</HEAD>':U SKIP
    '<BODY>':U SKIP
    '<FORM METHOD=POST ACTION="tran-tst.w">' SKIP
    .
  
  /* Update the current customer, if possible. */ 
  IF c_action eq  "Update":U THEN DO:   
    c_num = get-field("CustNum").
    FIND customer WHERE CustNum EQ INTEGER(c_num) EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
    IF LOCKED customer THEN
      {&OUT} SUBSTITUTE("Customer &1 is LOCKED and cannot be updated.<BR>", c_num).
    ELSE IF NOT AVAILABLE customer THEN
      {&OUT} SUBSTITUTE("There is no Customer &1 available in the database.<BR>", c_num).
    ELSE
      /* Everything is OK.  Update the customer.name. */
      ASSIGN Customer.Name = get-field("Name":U).
  END.

  /* Report actions that won't take affect to the next transaction. */
  IF CAN-DO('Start-Pending,Undo-Pending,Commit-Pending,Retry-Pending', t-state) THEN DO:
    /* 'Start' has no impact when the object is stateless. */
    IF t-state EQ 'Start-Pending':U AND w-state NE 'State-Aware':U THEN
      {&OUT} 'Setting START has no affect unless some object is STATE-AWARE<HR>'.
    ELSE 
      {&OUT} 
        SUBSTITUTE('Setting Transaction-State to &1 will <b>NOT</b> affect behavior until the <b>NEXT</b> web request.<HR>', t-state).
  END.
  ELSE DO:
    /* Show some customer value. */
    c_num = get-field("CustNum":U).
    FIND customer WHERE CustNum EQ INTEGER(c_num) NO-LOCK NO-WAIT NO-ERROR.
    IF NOT AVAILABLE Customer THEN 
      FIND FIRST Customer NO-LOCK NO-WAIT NO-ERROR.
    
    /* If there an available customer. */
    {&OUT}
      'CustNum: <INPUT TYPE = "TEXT" NAME = "CustNum"' 
                (IF AVAILABLE Customer THEN ' VALUE = "' + STRING(CustNum) +  '"'
                 ELSE '') '><BR>' SKIP
      'Name: <INPUT TYPE = "TEXT" NAME = "Name"'
                (IF AVAILABLE Customer THEN ' VALUE = "' + name +  '"'
                 ELSE '') '><BR>' SKIP
      '<BR>Actions: ' SKIP
      '<INPUT TYPE = "SUBMIT" NAME = "submitAction" VALUE = "Update">' SKIP.
  END.
  
  {&OUT}
    '<INPUT TYPE = "SUBMIT" NAME = "submitAction" VALUE = "Refresh">' SKIP
    '<INPUT TYPE = "CHECKBOX" NAME = "List" '
      (IF get-field("List") NE "" THEN 'CHECKED' ELSE '')
      '>List all Customers' SKIP
    '<BR><BR>Set Web-State: ' SKIP
    '<INPUT TYPE = "SUBMIT" NAME = "submitAction" VALUE = "State-Aware">' SKIP
    '<INPUT TYPE = "SUBMIT" NAME = "submitAction" VALUE = "State-Less">' SKIP
    '<BR><BR>Set Transaction-State:' SKIP
    '<INPUT TYPE = "SUBMIT" NAME = "submitAction" VALUE = "Start">' SKIP
    '<INPUT TYPE = "SUBMIT" NAME = "submitAction" VALUE = "Undo">' SKIP
    '<INPUT TYPE = "SUBMIT" NAME = "submitAction" VALUE = "Retry">' SKIP
    '<INPUT TYPE = "SUBMIT" NAME = "submitAction" VALUE = "Commit">' SKIP
    '</FORM>' SKIP
    '<HR>'
    'Web-State: ' w-state
    ' Transaction-State: ' t-state
    '<HR>'.
  
  c_list = get-field('List':U).
  IF c_list ne '' THEN DO:
    /* Watch out for other users having open locks on Customer. */
    FOR EACH Customer NO-LOCK:
      {&OUT} customer.CustNum ' ' customer.name '<BR>'.
    END.
  END.
  
  /* Finish the Page. */  
  {&OUT}
    '</BODY>':U SKIP
    '</HTML>':U SKIP.
  
END PROCEDURE.

&ANALYZE-RESUME
 

