&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000-2002 by Progress Software Corporation ("PSC"),  *
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
* Contributors:  pdigre@progress.com                                 *
*                cthomson@bravepoint.com                             *
*                adams@progress.com                                  *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: trans-tst.w

  Description: Test State Aware, transaction state

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*           This .W file was created with the Progress AppBuilder.     */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 14.14
         WIDTH              = 60.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */
{ src/web2/wrap-cgi.i }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-process-web-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-web-request Procedure 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAction     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cList       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNum        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTranState  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWebState   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dTimeOut    AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dRemaining  AS DECIMAL    NO-UNDO.
  
  /* remote: Get the action that we are supposed to take. */
  ASSIGN
    cAction  = get-field("submitAction")
    cList    = get-field('List')
    cName    = get-field("Name")
    cNum     = get-field("CustNum").
      
  /* Check the State-Aware and Transaction-state actions. The "Update"
     action is handled later. */
  CASE cAction:
    WHEN "State-Aware" THEN DO:
    	dTimeOut = MAXIMUM(1.0, DECIMAL(get-field("timeOut"))).
      RUN set-web-state IN web-utilities-hdl (THIS-PROCEDURE, dTimeOut).
    END.
    WHEN "State-Less" THEN
      RUN set-web-state IN web-utilities-hdl (THIS-PROCEDURE, 0).
    WHEN "Start" OR  
    WHEN "Undo" OR 
    WHEN "Retry" OR
    WHEN "Commit" THEN
      RUN set-transaction-state IN web-utilities-hdl (cAction).
  END CASE.
  
  /* Get the Web and Transaction states. */
  RUN getAttribute ('Web-State').
  cWebState = RETURN-VALUE.
  
  IF cWebState = "state-aware":U THEN
    RUN get-time-remaining IN web-utilities-hdl (THIS-PROCEDURE, OUTPUT dRemaining). 
 
  RUN get-transaction-state IN web-utilities-hdl.
  cTranState = RETURN-VALUE.
     
  /* Output the MIME header, and start returning the HTML form. */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).
  
  /* Create the HTML form. */
  {&OUT}
    '<HTML>':U SKIP
    '<HEAD>':U SKIP
    '<TITLE>Transaction State</TITLE>':U SKIP
    '</HEAD>':U SKIP
    '<BODY>':U SKIP
    '<FORM METHOD=POST ACTION="tran-tst.w">' SKIP
    .
  
  /* Update the current customer, if possible. */ 
  IF cAction EQ "Update" THEN DO:   
    FIND customer WHERE CustNum EQ INTEGER(cNum) EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
    IF LOCKED customer THEN
      {&OUT} "Customer " cNum " is LOCKED and cannot be updated.<BR>".
    ELSE IF NOT AVAILABLE customer THEN
      {&OUT} "There is no customer " cNum " available in the database.<BR>".
    ELSE DO:
      /* Everything is OK.  Update the customer.name. */
      ASSIGN Customer.Name = cName.
    END.      
  END.

  /* Report actions that won't take affect to the next transaction. */
  IF CAN-DO ('Start-Pending,Undo-Pending,Commit-Pending,Retry-Pending', cTranState)
  THEN DO:
    /* 'Start' has no impact when the object is stateless. */
    IF cTranState EQ 'Start-Pending' AND cWebState NE 'State-Aware'
    THEN
      {&OUT} 'Setting START has no affect unless some object is STATE-AWARE<HR>'.
    ELSE 
      {&OUT} 'Setting Transaction-State to ' cTranState
             ' will <b>NOT</b> affect behavior until the <b>NEXT</b> web request.'
             '<HR>'.
    {&OUT}
      '<TABLE>'
      '<TR>'
      '<TD>'.
  END.
  ELSE DO:
    /* Show some customer value. */
    FIND customer WHERE CustNum EQ INTEGER(cNum) NO-LOCK NO-WAIT NO-ERROR.
    IF NOT AVAILABLE Customer THEN 
      FIND FIRST Customer NO-LOCK NO-WAIT NO-ERROR.
    
    /* If there is an available customer. */
    {&OUT}
      '<TABLE>' SKIP
      '<TR>' SKIP
      '<TD>CustNum:</TD>' SKIP
      '<TD COLSPAN="2"><INPUT TYPE="TEXT" NAME="CustNum"' (IF AVAILABLE Customer THEN ' VALUE="' + STRING(CustNum) + '"' ELSE '') '></TD>'  SKIP
      '</TR>' SKIP
      
      '<TR>' SKIP
      '<TD>Name:</TD>' SKIP
      '<TD COLSPAN="2"><INPUT TYPE="TEXT" NAME="Name"' (IF AVAILABLE Customer THEN ' VALUE="' + name + '"' ELSE '') '></TD>' SKIP
      '</TR>' SKIP
      
      '<TR>' SKIP
      '<TD>Actions:</TD>' SKIP
      '<TD><INPUT TYPE="SUBMIT" NAME="submitAction" VALUE="Update">' SKIP
    .
  END.
  
  {&OUT}
    '<INPUT TYPE="SUBMIT" NAME="submitAction" VALUE="Refresh"></TD>' SKIP
    '<TD ALIGN="left"><INPUT TYPE="CHECKBOX" NAME="List" '
      (IF cList NE "" THEN 'CHECKED' ELSE '')
      '>List all Customers</TD>' SKIP
    '</TR>' SKIP
    
    '<TR>' SKIP
    '<TD>Set Web-State:</TD>' SKIP
    '<TD><INPUT TYPE="SUBMIT" NAME="submitAction" VALUE="State-Aware">' SKIP
    '<INPUT TYPE="SUBMIT" NAME="submitAction" VALUE="State-Less"></TD>' SKIP
    '<TD ALIGN="left"><INPUT TYPE="text" NAME="timeOut" SIZE="2"> Timeout (minutes)</TD>' SKIP
    '</TR>' SKIP
    
    '<TR>' SKIP
    '<TD>Set Tran-State:</TD>' SKIP
    '<TD><INPUT TYPE="SUBMIT" NAME="submitAction" VALUE="Start">' SKIP
    '<INPUT TYPE="SUBMIT" NAME="submitAction" VALUE="Undo">' SKIP
    '<INPUT TYPE= "SUBMIT" NAME="submitAction" VALUE="Retry">' SKIP
    '<INPUT TYPE= "SUBMIT" NAME="submitAction" VALUE="Commit"></TD>' SKIP
    '</TR>' SKIP
    
    '<TR>' SKIP
    '<TD COLSPAN="3"><HR></TD>' SKIP
    '</TR>' SKIP
    
    '<TR>' SKIP
    '<TD>Connection ID:</TD>' SKIP
    '<TD>' SESSION:SERVER-CONNECTION-ID '</TD>' SKIP
    '</TR>' SKIP
    
    '<TR>' SKIP
    '<TD>Exclusive ID:</TD>' SKIP
    '<TD>' WEB-CONTEXT:EXCLUSIVE-ID '</TD>' SKIP
    '</TR>' SKIP
    
    '<TR>' SKIP
    '<TD>Web-State:</TD>' SKIP
    '<TD>' cWebState '</TD>' SKIP
    '</TR>' SKIP
    
    '<TR>' SKIP
    '<TD>Time Remaining:</TD>' SKIP
    '<TD>' STRING(dRemaining,">>>9.99":U) ' minutes</TD>' SKIP
    '</TR>' SKIP
    
    '<TR>' SKIP
    '<TD>Transaction-State:</TD>' SKIP
    '<TD>' cTranState '</TD>' SKIP
    '</TR>' SKIP
    
    '<TR>' SKIP
    '<TD COLSPAN="3"><HR></TD>' SKIP
    '</TR>' SKIP
    
    '</TABLE>' SKIP
    '</FORM>' SKIP.
      
  IF cList ne '' THEN DO:
    /* Watch out for other users having open locks on Customer. */
    FOR EACH Customer NO-LOCK:
     {&OUT} customer.CustNum ' ' customer.name '<BR>'.
    END.
  END.
  
  /* Finish the Page. */  
  {&OUT}
    '</BODY>':U SKIP
    '</HTML>':U SKIP
    .
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

