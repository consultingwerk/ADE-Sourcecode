&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r12 Web-Object
/* Maps: HTML */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&SCOPED-DEFINE PROCEDURE-TYPE Web-Object


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES
/* Included Libraries --- */
{src/web/method/wrap-cgi.i}
&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 

/* ************************  Main Code Block  *********************** */

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
  RUN dispatch ('destroy':U).

/* Process the latest WEB event. */
RUN process-web-request.

/* Run the local/adm-destroy procedures, if the procedure is ending.    */
IF NOT THIS-PROCEDURE:PERSISTENT THEN 
  RUN dispatch ('destroy':U).
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE outputHeader 
PROCEDURE outputHeader :
/*------------------------------------------------------------------------------
  Purpose:     Output the MIME header, and any "cookie" information needed 
               by this procedure.  
  Parameters:  <none>
  Notes:       In the event that this Web object is State-Aware, this is also
               a good place to set the "Web-State" and "Web-Timeout" 
               attributes.              
------------------------------------------------------------------------------*/

  /* 
   * To make this a state-aware Web object, pass in the procedure handle and 
   * timeout period (in minutes, an *integer* value).  If you supply a 
   * timeout period greater than 0, the Web object becomes state-aware and
   * the following happens:
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
   * Example: Timeout period of 5 minutes for this Web object.
   *
   *   RUN set-web-state IN web-utilities-hdl (THIS-PROCEDURE, 5).
   *
   */
    
  /* 
   * Output additional cookie information here before running 
   * output-content-type.
   *
   *      For more information about the Netscape Cookie Specification, see
   *      http://home.netscape.com/newsref/std/cookie_spec.html  
   *   
   *      Name         - name of the cookie
   *      Value        - value of the cookie
   *      Expires date - Date to expire (optional). See TODAY function.
   *      Expires time - Time to expire (optional). Default value is 0,
   *                     which is midnight, local time.  This value is then
   *                     converted to GMT.  Expires Time must be in must be
   *                     in seconds since midnight.  See TIME function.
   *      Path         - Override default URL path (optional).  Default value
   *                     is the AppURL variable.
   *      Domain       - Override default domain (optional).  Default domain
   *                     is the current host.
   *      Secure       - This is an optional parameter.  "Secure" should only
   *                     be specified if on a secure (SSL) connection.  A 
   *                     secure connection is one in which 'https' is used.
   *                     In the case of 'http', the parameter should be set to
   *                     unknown, ?.
   * 
   *   SECURE CONNECTION EXAMPLE (https):
   *   The following example sets CustNum=23 and expires tomorrow at midnight,
   *   local time, which is then converted to GMT.  Note that midnight is the
   *   default value if time is unknown, ?.
   *     
   *   set-cookie ("CustNum":U, "23":U, today + 1, ?, ?, ?, "secure":U).
   *
   *   UN-SECURE CONNECTION EXAMPLE (http):
   *   The following example sets CustNum=23 and expires tomorrow at midnight,
   *   local time, which is then converted to GMT.  Note that midnight is the
   *   default value if time is unknown, ?.
   *     
   *   set-cookie ("CustNum":U, "23":U, today + 1, ?, ?, ?, ?).
   */
 
  output-content-type ("text/html":U). 

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE process-web-request 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  /* Output the MIME header and set up the object as state-less or state-aware. 
     This is required if any HTML is to be returned to the browser. */
  RUN outputHeader.
  
  {&OUT}
    '<HTML>':U SKIP
    '<HEAD>':U SKIP
    '<TITLE>':U 'Sports Customer List' '</TITLE>':U SKIP
    '</HEAD>':U SKIP
    '<BODY BGCOLOR="#FFFFFF">':U SKIP.
  
  /* Output your custom HTML to WEBSTREAM here (using {&OUT}). */
  {&OUT}
    '<H1>':U 'Customer List' '</H1>':U SKIP
    '<TABLE BORDER="1">':U SKIP
    '<TR>':U SKIP
    '  <TH>':U 'Customer ID' '</TH>':U SKIP
    '  <TH>':U 'Customer Name' '</TH>':U SKIP
    '  <TH>':U 'Phone Number' '</TH>':U SKIP
    '</TR>':U SKIP.
    
  FOR EACH Customer:
    {&OUT} 
      '<TR>':U SKIP
      '  <TD ALIGN="left">':U CustNum '</TD>':U SKIP
      '  <TD ALIGN="left">':U Name '</TD>':U SKIP
      '  <TD ALIGN="left">':U Phone '</TD>':U SKIP
      '</TR>':U SKIP.
  END.
    
  {&OUT}
    '</TABLE>':U SKIP
    '</BODY>':U SKIP
    '</HTML>':U SKIP.
  
END PROCEDURE.
&ANALYZE-RESUME
 

