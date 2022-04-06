&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
    cAction  = get-field("submitAction":U)
    cList    = get-field('List':U)
    cName    = get-field("Name":U)
    cNum     = get-field("CustNum":U).
      
  /* Check the State-Aware and Transaction-state actions. The "Update"
     action is handled later. */
  CASE cAction:
    WHEN "State-Aware":U THEN DO:
    	dTimeOut = MAXIMUM(1.0, DECIMAL(get-field("timeOut":U))).
      RUN set-web-state IN web-utilities-hdl (THIS-PROCEDURE, dTimeOut).
    END.
    WHEN "State-Less":U THEN
      RUN set-web-state IN web-utilities-hdl (THIS-PROCEDURE, 0).
    WHEN "Start":U OR  
    WHEN "Undo":U OR 
    WHEN "Retry":U OR
    WHEN "Commit":U THEN
      RUN set-transaction-state IN web-utilities-hdl (cAction).
  END CASE.
  
  /* Get the Web and Transaction states. */
  RUN getAttribute ('Web-State':U).
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
    '<FORM METHOD=POST ACTION="tran-tst.w">':U SKIP
    .
  
  /* Update the current customer, if possible. */ 
  IF cAction EQ "Update":U THEN DO:   
    FIND customer WHERE CustNum EQ INTEGER(cNum) EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
    IF LOCKED customer THEN
      {&OUT} "Customer ":U cNum " is LOCKED and cannot be updated.<BR>":U.
    ELSE IF NOT AVAILABLE customer THEN
      {&OUT} "There is no customer ":U cNum " available in the database.<BR>":U.
    ELSE DO:
      /* Everything is OK.  Update the customer.name. */
      ASSIGN Customer.Name = cName.
    END.      
  END.

  /* Report actions that won't take affect to the next transaction. */
  IF CAN-DO ('Start-Pending,Undo-Pending,Commit-Pending,Retry-Pending', cTranState)
  THEN DO:
    /* 'Start' has no impact when the object is stateless. */
    IF cTranState EQ 'Start-Pending':U AND cWebState NE 'State-Aware':U
    THEN
      {&OUT} 'Setting START has no affect unless some object is STATE-AWARE<HR>':U.
    ELSE 
      {&OUT} 'Setting Transaction-State to ':U cTranState
             ' will <b>NOT</b> affect behavior until the <b>NEXT</b> web request.':U
             '<HR>':U.
    {&OUT}
      '<TABLE>':U
      '<TR>':U
      '<TD>':U.
  END.
  ELSE DO:
    /* Show some customer value. */
    FIND customer WHERE CustNum EQ INTEGER(cNum) NO-LOCK NO-WAIT NO-ERROR.
    IF NOT AVAILABLE Customer THEN 
      FIND FIRST Customer NO-LOCK NO-WAIT NO-ERROR.
    
    /* If there is an available customer. */
    {&OUT}
      '<TABLE>':U SKIP
      '<TR>':U SKIP
      '<TD>CustNum:</TD>':U SKIP
      '<TD COLSPAN="2"><INPUT TYPE="TEXT" NAME="CustNum"':U (IF AVAILABLE Customer THEN ' VALUE="' + STRING(CustNum) + '"':U ELSE '') '></TD>':U  SKIP
      '</TR>':U SKIP
      
      '<TR>':U SKIP
      '<TD>Name:</TD>':U SKIP
      '<TD COLSPAN="2"><INPUT TYPE="TEXT" NAME="Name"':U (IF AVAILABLE Customer THEN ' VALUE="' + name + '"':U ELSE '') '></TD>':U SKIP
      '</TR>':U SKIP
      
      '<TR>':U SKIP
      '<TD>Actions:</TD>':U SKIP
      '<TD><INPUT TYPE="SUBMIT" NAME="submitAction" VALUE="Update">':U SKIP
    .
  END.
  
  {&OUT}
    '<INPUT TYPE="SUBMIT" NAME="submitAction" VALUE="Refresh"></TD>':U SKIP
    '<TD ALIGN="left"><INPUT TYPE="CHECKBOX" NAME="List" ':U
      (IF cList NE "" THEN 'CHECKED' ELSE '')
      '>List all Customers</TD>':U SKIP
    '</TR>':U SKIP
    
    '<TR>':U SKIP
    '<TD>Set Web-State:</TD>':U SKIP
    '<TD><INPUT TYPE="SUBMIT" NAME="submitAction" VALUE="State-Aware">':U SKIP
    '<INPUT TYPE="SUBMIT" NAME="submitAction" VALUE="State-Less"></TD>':U SKIP
    '<TD ALIGN="left"><INPUT TYPE="text" NAME="timeOut" SIZE="2"> Timeout (minutes)</TD>':U SKIP
    '</TR>':U SKIP
    
    '<TR>':U SKIP
    '<TD>Set Tran-State:</TD>':U SKIP
    '<TD><INPUT TYPE="SUBMIT" NAME="submitAction" VALUE="Start">':U SKIP
    '<INPUT TYPE="SUBMIT" NAME="submitAction" VALUE="Undo">':U SKIP
    '<INPUT TYPE= "SUBMIT" NAME="submitAction" VALUE="Retry">':U SKIP
    '<INPUT TYPE= "SUBMIT" NAME="submitAction" VALUE="Commit"></TD>':U SKIP
    '</TR>':U SKIP
    
    '<TR>':U SKIP
    '<TD COLSPAN="3"><HR></TD>':U SKIP
    '</TR>':U SKIP
    
    '<TR>':U SKIP
    '<TD>Connection ID:</TD>':U SKIP
    '<TD>':U SESSION:SERVER-CONNECTION-ID '</TD>':U SKIP
    '</TR>':U SKIP
    
    '<TR>':U SKIP
    '<TD>Exclusive ID:</TD>':U SKIP
    '<TD>':U WEB-CONTEXT:EXCLUSIVE-ID '</TD>':U SKIP
    '</TR>':U SKIP
    
    '<TR>':U SKIP
    '<TD>Web-State:</TD>':U SKIP
    '<TD>':U cWebState '</TD>':U SKIP
    '</TR>':U SKIP
    
    '<TR>':U SKIP
    '<TD>Time Remaining:</TD>':U SKIP
    '<TD>':U STRING(dRemaining,">>>9.99":U) ' minutes</TD>':U SKIP
    '</TR>':U SKIP
    
    '<TR>':U SKIP
    '<TD>Transaction-State:</TD>':U SKIP
    '<TD>':U cTranState '</TD>':U SKIP
    '</TR>':U SKIP
    
    '<TR>':U SKIP
    '<TD COLSPAN="3"><HR></TD>':U SKIP
    '</TR>':U SKIP
    
    '</TABLE>':U SKIP
    '</FORM>':U SKIP.
      
  IF cList ne '' THEN DO:
    /* Watch out for other users having open locks on Customer. */
    FOR EACH Customer NO-LOCK:
     {&OUT} customer.CustNum ' ':U customer.name '<BR>':U.
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

