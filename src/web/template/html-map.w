&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
/* Procedure Description
"HTML Mapping Procedure Template

Use this template to create a new HTML Mapping procedure and associate form elements defined in a static HTML file with WebSpeed field objects, such as database fields."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-html 
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
/*           This .W file was created with the Progress AppBuilder.     */
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Web-Object

&Scoped-define QUERY-NAME Web-Query

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Web-Object Template
   Allow: Query
   Frames: 1
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
   CREATE WINDOW w-html ASSIGN
         HEIGHT             = 14.15
         WIDTH              = 60.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-html 
/* *********************** Included-Libraries ************************* */

{src/web/method/html-map.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-html
  VISIBLE,,RUN-PERSISTENT                                               */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-html)
THEN w-html:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Web-Query
/* Query rebuild information for QUERY Query-Main
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Design-Parent    is WINDOW w-html @ ( 1 , 1 )
*/  /* QUERY Web-Query */
&ANALYZE-RESUME 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "HTML Wizard" w-html _INLINE
/* Actions: adm2/support/_wizard.w ? ? ? adm2/support/_wizdel.p */
/* HTML Mapping Wizard
Welcome to the HTML Mapping Wizard! The wizard will lead you through mapping HTML fields to database or DataObject fields. Press Next to proceed.
adm2/support/_wizntro.w,adm2/support/_wizhtml.w,adm2/support/_wizds.w,adm2/support/_wizmap.w,adm2/support/_wizend.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-html 


/* ************************  Main Code Block  ************************* */

/* 
 * Standard Main Code Block. This dispatches two events:
 *   'initialize'
 *   'process-web-request'
 * The bulk of the web processing is in the procedure 'process-web-request'
 * elsewhere in this Web object.
 */
{src/web/template/hmapmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE output-header w-html 
PROCEDURE output-header :
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
   *   The following example sets cust-num=23 and expires tomorrow at (about)
   *   the same time but only for secure (https) connections.
   *      
   *   RUN SetCookie IN web-utilities-hdl 
   *     ("cust-num":U, "23":U, today + 1, time, ?, ?, "secure":U).
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
   * NOTE: Move RUN output-header to the GET section below if you are going
   * to simulate another Web request by running a Web Object from this
   * procedure.  Running output-header precludes setting any additional cookie
   * information.
   *   
   */ 
  RUN output-header.
  
  /*
   * Describe whether to receive FORM input for all the fields.  For example,
   * check particular input fields (using GetField in web-utilities-hdl). 
   * Here we look at REQUEST_METHOD. 
   */
  IF REQUEST_METHOD = "POST":U THEN DO:
    /* STEP 1 -
     * Copy HTML input field values to the Progress form buffer. */
    RUN dispatch IN THIS-PROCEDURE ("inputfields":U).
    
    /* STEP 2 -
     * If there are DATABASE fields, find the relevant record that needs to be 
     * assigned. Define the QUERY "web-query" to do this for you. 
    RUN dispatch IN THIS-PROCEDURE ("find-records":U).
     */

    /* STEP 3 -
     * If you have defined a query for this Web object, you will need to 
     * refind the record EXCLUSIVE-LOCK if you want to assign database 
     * fields below.  For example, you would add the following line.
     *
     *  FIND CURRENT Customer EXCLUSIVE-LOCK NO-ERROR. 
     */
    RUN dispatch IN THIS-PROCEDURE ("assign-fields":U).
    
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
    RUN dispatch IN THIS-PROCEDURE ("display-fields":U).
   
    /* STEP 4.2b -
     * Enable objects that should be enabled. */
    RUN dispatch IN THIS-PROCEDURE ("enable-fields":U).

    /* STEP 4.2c -
     * OUTPUT the Progress form buffer to the WEB stream. */
    RUN dispatch IN THIS-PROCEDURE ("output-fields":U).
  END. /* Form has been submitted. */
 
  /* REQUEST-METHOD = GET */ 
  ELSE DO:
    /* This is the first time that the form has been called. Just return the
     * form.  Move 'RUN output-header.' here if you are going to simulate
     * another Web request. */ 
   
    /* STEP 1-
     * If there are DATABASE fields, find the relevant record that needs to
     * be assigned. Define the QUERY "web-query" to do this for you.
    RUN dispatch IN THIS-PROCEDURE ("find-records":U).
     */
    
    /* Return the form again. Set data values, display them, and output them
     * to the WEB stream.  
     *
     * STEP 2a -
     * Set any values that need to be set, then display them. */
    RUN dispatch IN THIS-PROCEDURE ("display-fields":U).

    /* STEP 2b -
     * Enable objects that should be enabled. */
    RUN dispatch IN THIS-PROCEDURE ("enable-fields":U).

    /* STEP 2c -
     * OUTPUT the Progress from buffer to the WEB stream. */
    RUN dispatch IN THIS-PROCEDURE ("output-fields":U).
  END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

