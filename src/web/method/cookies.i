&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Method-Library
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/***************************************************************************
Include File: cookies.i

Description:  Functions for handling Netscape Persistent Cookies
References:   Netscape Cookie Spec: 
                http://home.netscape.com/newsref/std/cookie_spec.html
Usage:        Include after src/web/method/cgidefs.i
Notes:        This file is for internal use by WebSpeed runtime procedures
              ONLY. Applications should not include this file.
Updates:      04/20/96 bburton
                Initial version
              01/17/03 adams
                Support for '=' in cookie data

***************************************************************************/
/*           This .i file was created with WebSpeed WorkShop.             */
/*------------------------------------------------------------------------*/

/* Only define things if this file has not yet been included */
&IF DEFINED(COOKIES_I) = 0 &THEN
&GLOBAL-DEFINE COOKIES_I = TRUE

/* ***************************  Definitions  ************************** */
&ANALYZE-RESUME
/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES
/* ************************* Included-Libraries *********************** */
&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

/* ***************************  Functions  **************************** */

&IF DEFINED(EXCLUDE-delete-cookie) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION delete-cookie 
/****************************************************************************
Function: delete-cookie
Description: Deletes the specified cookie
Input: Name, path, domain
Output: web stream
Usage:
  /* Delete cookie cust-num using default path and domain */
  delete-cookie ("cust-num":U,?,?).
****************************************************************************/
FUNCTION delete-cookie RETURNS CHARACTER
  (INPUT p_name AS CHARACTER,
   INPUT p_path AS CHARACTER,
   INPUT p_domain AS CHARACTER) :
  /* Output a Set-Cookie header with a very early expiration date.
     Specify date is UTC time since there's no point in converting it. */
  set-cookie (p_name, "", DATE(1,2,1991), 0, p_path, p_domain, "UTC":U).
END FUNCTION.  /* delete-cookie */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-cookie) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION get-cookie 
/****************************************************************************
Function:    get-cookie
Description: Given a cookie name, returns one or more matching values.  If 
             more than one value matches, all are returned delimited by the 
             value of SelDelim, normally a comma.  If ? is specified for the 
             name, the output will be a list of all the cookie names.
Input:       Name or ?
Output:      Cookie value(s) or list of cookie names
****************************************************************************/
FUNCTION get-cookie RETURNS CHARACTER
  (INPUT p_name AS CHARACTER) :

  DEFINE VARIABLE v-values AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cookies  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i-pair   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i-name   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i-value  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix       AS INTEGER    NO-UNDO.

  /* Return if no HTTP Cookie: header */
  IF HTTP_COOKIE = "" THEN 
  	RETURN v-values.

  /* Loop through all the name=value pairs ... */
  DO ix = 1 TO NUM-ENTRIES(HTTP_COOKIE, "~;":U):
    ASSIGN
      i-pair  = TRIM(ENTRY(ix, HTTP_COOKIE, "~;":U))
      i-name  = url-decode(ENTRY(1, i-pair, "=":U))
      i-value = (IF NUM-ENTRIES(i-pair, "=":U) > 1 THEN
                   url-decode(SUBSTRING(i-pair,LENGTH(i-name, "character":U) + 2, -1, "character":U)) 
                 ELSE "?":U).
    /* If name = ?, just add name to list of names.  If a name is already on 
       the list, don't add again. */
    IF p_name = ? THEN DO:
      IF LOOKUP(i-name, v-values) = 0 THEN
        ASSIGN v-values = v-values +
          (IF v-values = "" THEN "" ELSE ",":U) + i-name.
    END.

    /* If a match, then add current value to list of values using configured 
       delimiter. */
    ELSE
      IF i-name = p_name THEN
        ASSIGN v-values = v-values + 
          (IF v-values = "" THEN "" ELSE SelDelim) + i-value.
  END.

  RETURN v-values.
END FUNCTION.  /* get-cookie */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-cookie) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION set-cookie 
/****************************************************************************
Function: set-cookie
Description: Outputs an HTTP Set-Cookie header with specified options
Input: Name, Value, [Expires date], [Expires time], [Path], [Domain],
    [Secure,{Local|UTC}]
  * Name must be specified
  * Value can be blank which is typically used when deleting a cookie
  * Expires date is an optional parameter expression evaluating to a DATE
    data type.  This is used to set an expiration time on a cookie.
    For instance, TODAY + 1 = tomorrow; TODAY + 365 = same day next year;
      TODAY - 1 = yesterday.  
    If the cookie should only persist for the duration of the browser
    session, specify ?.
  * Expires time is an optional parameter expression evaluating to an
    INTEGER data type to the number of seconds since midnight.  This is
    only meaningful if an expression other than ? is specified for the
    Expires date.  The expression can be a very large or small number
    (greater or less than the number of seconds in a day) which will be
    normalized to fit within a day.  In this case, the Expires date will
    be incremented or decremented as appropriate.
      Specifying small numbers into the future e.g. TIME + 5 * 60 (five
    minutes from now) may not expire when desired due to differences in 
    the clock of the user's machine running the browser vs. the clock of
    the machine running the application. 
      Specify ? if setting an expiration time is not desired.
  * Path is the URL path below which the Cookie will be sent.  If ? is
    specified, the default is the value of the AppURL global variable
    unless the Cookie Path configuration option is set in which case it
    will be used instead.
    which is the URL common to all programs within an application.
      To delete a cookie, this value must be the same as it was when the
    cookie was set.
  * Domain is an optional parameter with the internet domain, i.e.
    ".progress.com".  If ? is specified, the domain will be the current
    host or if specified, the value of the Cookie Domain configuration option.
      To delete a cookie, this value must be the same as it was when the
    cookie was set.
  * Comma-delimited options:
    "SECURE" - If specified, the web browser will only send the Cookie
        back when on a secure (SSL) connection (using https).
    "UTC" - Assume date and time are UTC based elimitating any conversion
        that would otherwise be required from local time to UTC time.
    "LOCAL" - (Default) Assume date and time are based on local time and
        need conversion to UTC.
    The "SECURE" option can be combined with either the "UTC" or "LOCAL"
    options, i.e. "SECURE,UTC".
Output: web stream
Returns: cookie value
Usage:
  /* Sets cust-num=23 */
  set-cookie ("cust-num":U, "23":U, ?, ?, ?, ?, ?).
  /* Sets cust-num=23 and expires tomorrow at the same time but will only 
     be sent for secure (https) connections.  The expiration date and time
     are assumed to be in local time (as opposed to UTC time). */
  set-cookie ("cust-num":U, "23":U, today + 1, time, ?, ?, "secure,local":U).
****************************************************************************/
FUNCTION set-cookie RETURNS CHARACTER
 (INPUT p_name   AS CHARACTER,
  INPUT p_value  AS CHARACTER,
  INPUT p_date   AS DATE,
  INPUT p_time   AS INTEGER,
  INPUT p_path   AS CHARACTER,
  INPUT p_domain AS CHARACTER,
  INPUT p_options AS CHARACTER):

  DEFINE VARIABLE exp-date      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE v-cookie      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE v-secure      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE v-timeconv    AS CHARACTER NO-UNDO.

  /* Nothing to do if no Cookie name */
  IF p_name = ? OR p_name = "" THEN RETURN "".

  IF p_value = ? THEN
    ASSIGN p_value = "".     /* ? and "" for the value are the same thing */
  IF p_path = ? THEN
    ASSIGN p_path = CookiePath.  /* default to URL of application */
  IF p_domain = ? THEN
    ASSIGN p_domain = CookieDomain.  /* From config information */
  IF p_options = ? THEN
    ASSIGN p_options = "".

  /* If any options were specified, check for "secure" or "UTC" */
  IF p_options <> "" THEN
    ASSIGN
      /* Look for "SECURE" in options */
      v-secure = (IF CAN-DO(p_options, "SECURE":U) THEN "SECURE":U ELSE "")
      /* Look for "UTC" in options. If not found, assume local time */
      v-timeconv = (IF CAN-DO(p_options, "UTC":U) THEN "UTC":U ELSE "LOCAL":U).

  /* If an expiration date/time was specified, convert date and time to
     a modified RFC-1123 format for output. */
  IF p_date <> ? THEN DO:
    ASSIGN exp-date = format-datetime("cookie":U, p_date, p_time, v-timeconv).
    /* Set path to "/" to work around a Netscape 1.1 and earlier bug
       with expires.  This test might not be adequate. */
    IF HTTP_USER_AGENT BEGINS "Mozilla/1.1":U THEN
      p_path = "/":U.
  END.
  /* No date specified */
  ELSE
    ASSIGN exp-date = "".

  /* Format the cookie */
  ASSIGN v-cookie =
    url-encode(p_name,"cookie":U) + "=":U +
    url-encode(p_value,"cookie":U) +
    (IF exp-date = "" THEN "" ELSE "~; expires=":U + exp-date) +
    (IF p_path = "" THEN "" ELSE "~; path=":U + p_path) +
    (IF p_domain = "" THEN "" ELSE "~; domain=":U + p_domain) +
    (IF v-secure = "" THEN "" ELSE "~; secure":U).

  /* Send the cookie to the web browser */
  output-http-header("Set-Cookie":U, v-cookie).
  
  RETURN v-cookie.
END FUNCTION.  /* set-cookie */
&ANALYZE-RESUME

&ENDIF

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 


/* ***************************  Main Block  *************************** */
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-CookieDate) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE CookieDate 
PROCEDURE CookieDate :
/****************************************************************************
Procedure: CookieDate
Description: See "cookie" option in format-datetime().  For backwards
  compatibility with WebSpeed 1.0.
Input: Date, time
Output: formatted date: Wdy, DD-Mon-YYYY HH:MM:SS GMT
  This is similar to the RFC-1123 date format but has hyphens between parts 
  of the date and a four digit year.
Global variables:
References:
****************************************************************************/
  DEFINE INPUT  PARAMETER p_date    AS DATE      NO-UNDO.
  DEFINE INPUT  PARAMETER p_time    AS INTEGER   NO-UNDO.
  DEFINE OUTPUT PARAMETER p_rfcdate AS CHARACTER NO-UNDO.

  /* If date is ?, return a blank date */
  IF p_date = ? THEN DO:
    ASSIGN p_rfcdate = "".
    RETURN.
  END.

  /* Return a formatted date/time based on date and time that are local. */
  ASSIGN p_rfcdate = format-datetime("cookie":U, p_date, p_time, "local":U).

END PROCEDURE.  /* CookieDate */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DeleteCookie) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE DeleteCookie 
PROCEDURE DeleteCookie :
/****************************************************************************
Procedure: DeleteCookie
Description: Description: See delete-cookie.  For backwards compatibility
  with WebSpeed 1.0.
Input: Name
Output: web stream
Bug: According to the Cookie specification, an identical path= option must
  be specified to delete a cookie as was used to set it.  This would 
  require adding an additional parameter for path which would just be
  passed to SetCookie.  
    To minimize problems, the SetCookie procedure has been modified to use
  AppURL as the default path if ? is specified.  So, if any other path
  to SetCookie is specified than AppURL or ? when setting the cookie, this
  procedure may not work.  In this case, use SetCookie itself with a blank
  value, an expires date in the past, and the original value for the path.  
  It is not known at this time if the domain parameter must also match to
  delete the cookie which if so, would require a third parameter.
****************************************************************************/
  DEFINE INPUT PARAMETER p_name AS CHARACTER NO-UNDO.
  /* Output a Set-Cookie header with an expires date of yesterday */
  RUN SetCookie (p_name, "", TODAY - 1, 0, ?, ?, ?).
END PROCEDURE.  /* DeleteCookie */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetCookie) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE GetCookie 
PROCEDURE GetCookie :
/****************************************************************************
Procedure: GetCookie
Description: Given a cookie name, returns one or more matching values.
If more than one value matches, all are returned delimited
by the value of SelDelim, normally a comma.  If ? is specified
for the name, the output will be a list of all the cookie names.
Input: Name or ?
Output: Cookie value(s) or list of cookie names
****************************************************************************/
  DEFINE INPUT  PARAMETER p_name   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_values AS CHARACTER NO-UNDO.

  ASSIGN p_values = get-cookie (p_name).
END PROCEDURE.  /* GetCookie */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SetCookie) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE SetCookie 
PROCEDURE SetCookie :
/****************************************************************************
Procedure: SetCookie
Description: Outputs an HTTP Set-Cookie header with specified options
Input: Name, Value, [Expires date], [Expires time], [Path], [Domain], [Secure]
Output: web stream
Usage:
  /* Sets cust-num=23 */
  run SetCookie ("cust-num":U, "23":U, ?, ?, ?, ?, ?).
  /* Sets cust-num=23 and expires tomorrow at the same time but only for
     secure (https) connections. */
  run SetCookie ("cust-num":U, "23":U, today + 1, time, ?, ?, "secure":U).
****************************************************************************/
  DEFINE INPUT PARAMETER p_name   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_value  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_date   AS DATE      NO-UNDO.
  DEFINE INPUT PARAMETER p_time   AS INTEGER   NO-UNDO.
  DEFINE INPUT PARAMETER p_path   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_domain AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_secure AS CHARACTER NO-UNDO.

  set-cookie (p_name, p_value, p_date, p_time, p_path, p_domain, p_secure).
END PROCEDURE.  /* SetCookie */


&ENDIF  /* DEFINED(COOKIES_I) = 0 */


&ANALYZE-RESUME

&ENDIF

 

