&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          wscopy           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-html 
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

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*           This .W file was created with AppBuilder.                  */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE vButton AS CHARACTER NO-UNDO. /* Submit button value */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Web-Object
&Scoped-define DB-AWARE no

&Scoped-define WEB-FILE w-cstinf.htm

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Web-Frame
&Scoped-define QUERY-NAME QUERY-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Customer

/* Definitions for QUERY QUERY-2                                        */
&Scoped-define OPEN-QUERY-QUERY-2 OPEN QUERY QUERY-2 FOR EACH Customer NO-LOCK.
&Scoped-define TABLES-IN-QUERY-QUERY-2 Customer
&Scoped-define FIRST-TABLE-IN-QUERY-QUERY-2 Customer


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Customer.Address Customer.Address2 ~
Customer.City Customer.Comments Customer.CustNum Customer.Name ~
Customer.Phone Customer.PostalCode Customer.State 
&Scoped-define ENABLED-TABLES Customer
&Scoped-define FIRST-ENABLED-TABLE Customer
&Scoped-define DISPLAYED-TABLES Customer
&Scoped-define FIRST-DISPLAYED-TABLE Customer
&Scoped-Define DISPLAYED-FIELDS Customer.Address Customer.Address2 ~
Customer.City Customer.Comments Customer.CustNum Customer.Name ~
Customer.Phone Customer.PostalCode Customer.State 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY QUERY-2 FOR 
      Customer SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Web-Frame
     Customer.Address
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 1
          &ELSE AT ROW 1 COL 1 &ENDIF NO-LABEL
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     Customer.Address2
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 1
          &ELSE AT ROW 1 COL 1 &ENDIF NO-LABEL
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     Customer.City
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 1
          &ELSE AT ROW 1 COL 1 &ENDIF NO-LABEL
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     Customer.Comments
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 1
          &ELSE AT ROW 1 COL 1 &ENDIF NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 4
          &ELSE SIZE 20 BY 4 &ENDIF
     Customer.CustNum
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 1
          &ELSE AT ROW 1 COL 1 &ENDIF NO-LABEL
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     Customer.Name
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 1
          &ELSE AT ROW 1 COL 1 &ENDIF NO-LABEL
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     Customer.Phone
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 1
          &ELSE AT ROW 1 COL 1 &ENDIF NO-LABEL
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     Customer.PostalCode
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 1
          &ELSE AT ROW 1 COL 1 &ENDIF NO-LABEL
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
     Customer.State
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 1
          &ELSE AT ROW 1 COL 1 &ENDIF NO-LABEL
          VIEW-AS FILL-IN 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 20 BY 1
          &ELSE SIZE 20 BY 1 &ENDIF
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS 
         AT COL 1 ROW 1
         SIZE 80 BY 20.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Web-Object
   Allow: Query
   Frames: 1
   Add Fields to: Neither
   Editing: Special-Events-Only
   Events: web.output,web.input
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW w-html ASSIGN
         HEIGHT             = 14.14
         WIDTH              = 60.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-html 
/* *********************** Included-Libraries ************************* */

{src/web2/html-map.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-html
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME Web-Frame
   UNDERLINE                                                            */
/* SETTINGS FOR fill-in Customer.Address IN FRAME Web-Frame
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR fill-in Customer.Address2 IN FRAME Web-Frame
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR fill-in Customer.City IN FRAME Web-Frame
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR editor Customer.Comments IN FRAME Web-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR fill-in Customer.CustNum IN FRAME Web-Frame
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR fill-in Customer.Name IN FRAME Web-Frame
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR fill-in Customer.Phone IN FRAME Web-Frame
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR fill-in Customer.PostalCode IN FRAME Web-Frame
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR fill-in Customer.State IN FRAME Web-Frame
   ALIGN-L EXP-LABEL                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY QUERY-2
/* Query rebuild information for QUERY QUERY-2
     _TblList          = "wscopy.Customer"
     _Options          = "NO-LOCK"
     _Design-Parent    is FRAME Web-Frame @ ( 1 , 1 )
*/  /* QUERY QUERY-2 */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-html 


/* ************************  Main Code Block  ************************* */

 
/* Set the appservice attribute if the SDO shall run on an AppServer.
 * The Partitions must be defined in the AppServer Partitioning Tool. 
 * The apsrvtt.d file generated must be available on the agent.      
setAppService('').
 */

/* Standard Main Block that runs 'initializeObject' 'process-web-request'.
 * The bulk of the web processing is in the procedure 'process-web-request'
 * elsewhere in this Web object.
 */
{src/web2/template/hmapmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCustomer w-html 
PROCEDURE findCustomer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE vName AS CHARACTER NO-UNDO.

  vName = get-value("Name"). /* Name value for customer search */

  CASE vButton:
    WHEN "Search":U THEN DO WITH FRAME {&FRAME-NAME}:
      FIND FIRST Customer WHERE Name >= vName NO-LOCK NO-ERROR.
      IF NOT AVAILABLE(Customer) THEN 
        FIND FIRST Customer USE-INDEX Name NO-LOCK NO-ERROR.
      IF NOT AVAILABLE(Customer) THEN
        Name:SCREEN-VALUE = "*** NO RECORDS ***".
    END.
    WHEN "Next":U THEN DO WITH FRAME {&FRAME-NAME}:
      FIND FIRST Customer WHERE Name > vName NO-LOCK NO-ERROR.
      IF NOT AVAILABLE(Customer) THEN
        FIND FIRST Customer USE-INDEX NAME NO-LOCK NO-ERROR.
      IF NOT AVAILABLE(Customer) THEN 
        Name:SCREEN-VALUE = "*** NO RECORDS ***".
    END.
    WHEN "Update":U THEN DO WITH FRAME {&FRAME-NAME}:  /* CustNum to update */
      FIND Customer WHERE CustNum = INTEGER(get-value("CustNum"))
        EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
      IF LOCKED(Customer) THEN
        Name:SCREEN-VALUE = "*** LOCKED ***".
      ELSE IF NOT AVAILABLE(Customer) THEN
        Name:SCREEN-VALUE = "*** NOT FOUND ***".
      ELSE        
        Comments:SCREEN-VALUE = Comments:SCREEN-VALUE +
                                  "~n*** Updated " + STRING(TODAY) + " ***".
    END.
  END CASE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE htmOffsets w-html  _WEB-HTM-OFFSETS
PROCEDURE htmOffsets :
/*------------------------------------------------------------------------------
  Purpose:     Runs procedure to associate each HTML field with its
               corresponding widget name and handle.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  RUN readOffsets ("{&WEB-FILE}":U).
  RUN htmAssociate
    ("Address":U,"Customer.Address":U,Customer.Address:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("Address2":U,"Customer.Address2":U,Customer.Address2:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("City":U,"Customer.City":U,Customer.City:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("Comments":U,"Customer.Comments":U,Customer.Comments:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("CustNum":U,"Customer.CustNum":U,Customer.CustNum:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("Name":U,"Customer.Name":U,Customer.Name:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("Phone":U,"Customer.Phone":U,Customer.Phone:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("PostalCode":U,"Customer.PostalCode":U,Customer.PostalCode:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("State":U,"Customer.State":U,Customer.State:HANDLE IN FRAME {&FRAME-NAME}).
END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputHeader w-html 
PROCEDURE outputHeader :
/*------------------------------------------------------------------------
  Purpose:     Output the MIME header, and any "cookie" information needed 
               by this procedure.  
  Parameters:  <none>
  Notes:       In the event that this Web object is State-Aware, this is also
               a good place to set the "Web-State" and "Web-Timeout" 
               attributes.              
------------------------------------------------------------------------*/

  /* 
   * To make this a state-aware Web object, pass in the procedure handle and 
   * timeout period (in minutes).  If you supply a timeout period greater than 
   * 0, the Web Object becomes state-aware and the following happens:
   *
   *   - 4GL variables web-state and web-timeout are set
   *   - a cookie is created for the broker to id the client on the return trip
   *   - a cookie is created to id the correct procedure on the return trip
   *
   * If you supply a timeout period less than 1, the following happens:
   *
   *   - 4GL variables web-state and web-timeout are set to an empty string
   *   - a cookie is killed for the broker to id the client on the return trip
   *   - a cookie is killed to id the correct procedure on the return trip
   *
   * For example, set the timeout period to 5 minutes.
   *
   *   RUN set-web-state IN web-utilities-hdl (THIS-PROCEDURE, 5.0).
   */
    
  /* 
   * Output additional cookie information here before running outputContentType.
   *   For more information about the Netscape Cookie Specification, see
   *   http://home.netscape.com/newsref/std/cookie_spec.html  
   *   
   *   Name         - name of the cookie
   *   Value        - value of the cookie
   *   Expires date - Date to expire (optional). See TODAY function.
   *   Expires time - Time to expire (optional). See TIME function.
   *   Path         - Override default URL path (optional)
   *   Domain       - Override default domain (optional)
   *   Secure       - "secure" or unknown (optional)
   * 
   *   The following example sets CustNum=23 and expires tomorrow at (about)
   *   the same time but only for secure (https) connections.
   *      
   *   RUN SetCookie IN web-utilities-hdl 
   *     ("CustNum":U, "23":U, today + 1, time, ?, ?, "secure":U).
   */ 
   
  output-content-type ("text/html":U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-web-request w-html 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------
  Purpose:     Process the web request.
  Notes:       
------------------------------------------------------------------------*/
     
  /* STEP 0 -
   * Output the MIME header and set up the object as state-less or state-aware. 
   * This is required if any HTML is to be returned to the browser. 
   *
   * NOTE: Move RUN outputHeader to the GET section below if you are going
   * to simulate another Web request by running a Web Object from this
   * procedure.  Running outputHeader precludes setting any additional cookie
   * information.
   *   
   */ 
  RUN outputHeader.
  
  /*
   * Describe whether to receive FORM input for all the fields.  For example,
   * check particular input fields (using GetField in web-utilities-hdl). 
   * Here we look at REQUEST_METHOD. 
   */
  IF REQUEST_METHOD = "POST":U THEN DO:
     vButton = get-value(INPUT "Button Value"). 
    /* STEP 1 -
     * Copy HTML input field values to the Progress form buffer. */
    RUN inputFields.
    
    /* STEP 2 -
     * If there are DATABASE fields, find the relevant record that needs to be 
     * assigned. 
    RUN findRecords.
     */
    RUN findCustomer.

    IF vButton = "Update":U AND AVAILABLE(Customer) THEN
      RUN assignFields.
     
    /* STEP 3 -
     * You will need to refind the record EXCLUSIVE-LOCK if you want to assign 
     * database fields below.  For example, you would add the following line.
     *
     *  FIND CURRENT Customer EXCLUSIVE-LOCK NO-ERROR. 
     */
    IF vButton = "Update":U AND AVAILABLE(Customer) THEN
      RUN assignFields.
    
    /* STEP 4 -
     * Decide what HTML to return to the user. Choose STEP 4.1 to simulate
     * another Web request -OR- STEP 4.2 to return the original form (the
     * default action).
     *
     * STEP 4.1 -
     * To simulate another Web request, change the REQUEST_METHOD to GET
     * and RUN the Web object here.  For example,
     *
     *  ASSIGN REQUEST_METHOD = "GET":U.
     *  RUN run-web-object IN web-utilities-hdl ("myobject.w":U).
     */
     
    /* STEP 4.2 -
     * To return the form again, set data values, display them, and output them
     * to the WEB stream.  
     *
     * STEP 4.2a -
     * Set any values that need to be set, then display them. */
    RUN displayFields.
   
    /* STEP 4.2b -
     * Enable objects that should be enabled. */
    RUN enableFields.

    /* STEP 4.2c -
     * OUTPUT the Progress form buffer to the WEB stream. */
    RUN outputFields.
    
  END. /* Form has been submitted. */
 
  /* REQUEST-METHOD = GET */ 
  ELSE DO:
    /* This is the first time that the form has been called. Just return the
     * form.  Move 'RUN outputHeader.' here if you are going to simulate
     * another Web request. */ 
   
    /* STEP 1-
     * If there are DATABASE fields, find the relevant record that needs to
     * be assigned. 
    RUN findRecords.
     */
    FIND FIRST customer USE-INDEX name.
    
    /* Return the form again. Set data values, display them, and output them
     * to the WEB stream.  
     *
     * STEP 2a -
     * Set any values that need to be set, then display them. */
    RUN displayFields.

    /* STEP 2b -
     * Enable objects that should be enabled. */
    RUN enableFields.

    /* STEP 2c -
     * OUTPUT the Progress from buffer to the WEB stream. */
    RUN outputFields.
  END. 
  
  /* Show error messages */
  IF AnyMessage() THEN DO:
    ShowDataMessages().
    /* ShowDataMessage may return a Progress column name. This means you can 
       use as a parameter to HTMLSetFocus instead of calling it directly.           
       The first parameter is the form name.   
       HTMLSetFocus("document.DetailForm",ShowDataMessages()). */
  END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

