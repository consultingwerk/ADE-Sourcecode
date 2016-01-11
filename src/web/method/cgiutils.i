&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r12 Method-Library
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2005,2009-2011 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
  Library     : cgiutils.i
  Purpose     : Utility runtime functions and procedures
  Syntax      : { src/web/method/cgiutils.i }
  Notes       : This file must be included after both cgidefs.i and
                cgiarray.i which define a number of variables used
                by these functions and procedures.

                This file is for internal use by WebSpeed runtime
                procedures ONLY. Applications should not include this file. 
                
  Updated     : 01/07/1997 billb@progress.com
                  Initial version
                10/16/2001 adams@progress.com
                  Added codepage support
  ------------------------------------------------------------------------*/
/*           This .i file was created with WebSpeed WorkShop.             */
/*------------------------------------------------------------------------*/

/* Only define things if this file has not yet been included */
&IF DEFINED(CGIUTILS_I) = 0 &THEN
&GLOBAL-DEFINE CGIUTILS_I = TRUE

/* ***************************  Definitions  ************************** */

/* Make sure cgiarray.i is included */
&IF DEFINED(CGIARRAY_I) = 0 &THEN
{src/web/method/cgiarray.i}
&ENDIF

/* Variables used only by cgiutils.i */

/* TEMPORARY VARIABLE TO SET CGI MODE. [billb]
   TRUE = API calls core WEB-CONTEXT: methods
   FALSE = API calls use existing 4GL implementation
   This is set in the procedure init-session in web-util.p. */
DEFINE NEW GLOBAL SHARED VARIABLE use-core-api AS LOGICAL NO-UNDO INITIAL TRUE.

/* Exclusive Web User variables. */
DEFINE VARIABLE wseu-cookie AS CHAR NO-UNDO.

/* E-mail address of application maintainer */
DEFINE VARIABLE HelpAddress  AS CHARACTER NO-UNDO FORMAT "x(40)":U.

/* Unsafe characters that must be encoded in URL's.  See RFC 1738 Sect 2.2. */
DEFINE VARIABLE url_unsafe   AS CHARACTER NO-UNDO 
    INITIAL " <>~"#%~{}|~\^~~[]`":U.

/* Reserved characters that normally are not encoded in URL's */
DEFINE VARIABLE url_reserved AS CHARACTER NO-UNDO 
    INITIAL "~;/?:@=&":U.
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

&IF DEFINED(EXCLUDE-convert-datetime) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION convert-datetime 
FUNCTION convert-datetime RETURNS CHARACTER
  (INPUT p_conversion AS CHARACTER,
   INPUT p_idate       AS DATE,
   INPUT p_itime       AS INTEGER,
   OUTPUT p_odate      AS DATE,
   OUTPUT p_otime      AS INTEGER) :
/****************************************************************************
Description: Performs conversions of date and time between local time and
  UTC time.  In addition, an option is supported to normalize a date and
  time ensuring the value of time is legal between zero and the number of
  seconds per day.  The normalizing step is also performed for either the
  local to UTC or UTC to local conversions.
Parameters:
  Input:  Conversion option:
          "UTC" - Converts date and time from local to UTC time.
          "LOCAL" - Converts date and time from UTC to local time.
          "NORMALIZE" - Normalize date and time so the value of time is
            legal between zero and the number of seconds per day.
  Input:  Date to convert.  Uses the DATE data type.
  Input:  Time to convert.  Seconds since midnight (see TIME function).
  Output: Converted date.
  Output: Converted time.
Returns: 
Global Variables: utc-offset
****************************************************************************/
  DEFINE VARIABLE seconds-per-day AS INTEGER NO-UNDO INITIAL 86400.

  /* Default option is to normalize */
  IF p_conversion = "" OR p_conversion = ? THEN
    ASSIGN p_conversion = "NORMALIZE":U.

  /* If date is ? ... */
  IF p_idate = ? THEN
    RETURN "".

  IF p_itime = ? THEN
    ASSIGN p_itime = 0.

  /* Set time adjustment depending on conversion option */
  CASE p_conversion:
    WHEN "LOCAL":U THEN
      ASSIGN p_itime = p_itime - utc-offset.
    WHEN "UTC":U THEN
      ASSIGN p_itime = p_itime + utc-offset.
  END CASE.

  /* Normalize if time is too large */
  DO WHILE p_itime >= seconds-per-day:
    ASSIGN
      p_itime = p_itime - seconds-per-day
      p_idate = p_idate + 1.  /* tomorrow */
  END.

  /* Normalize if time is too small */
  DO WHILE p_itime < 0:
    ASSIGN
      p_itime = p_itime + seconds-per-day
      p_idate = p_idate - 1.  /* yesterday */
  END.

  ASSIGN
    p_odate = p_idate
    p_otime = p_itime.

  RETURN "".

END FUNCTION. /* convert-datetime */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-format-datetime) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION format-datetime 
FUNCTION format-datetime RETURNS CHARACTER
  (INPUT p_format  AS CHARACTER,
   INPUT p_date    AS DATE,
   INPUT p_time    AS INTEGER,
   INPUT p_options AS CHARACTER) :

/****************************************************************************
Description: Returns a date and time string formatted for Internet use.
  Currently, the formats "COOKIE" and "HTTP" are supported.  The HTTP format
  is useful for the Expires: or other headers.  The Cookie format is used
  by the set-cookie() function when an expiration date is specified.
Parameters:
  Input:  Date format.  Supported are "COOKIE" and "HTTP".
  Input:  Date as a DATE data type.
  Input:  Time as an integer (See TIME function).
  Input:  Options.  "LOCAL" - indicates the specified date and time are local
          time such as returned by the TODAY and TIME functions.  The date
          and time are converted to UTC before formatting.
          "UTC" - The specified date and time are already in UTC time.  The
          date and time are normalized to ensure the value of time is between
          zero and the number of seconds in one day.
Returns:  Formatted date
Global variables:
References:
  Cookie Date format:
    Netscape Cookie Spec: http://home.netscape.com/newsref/std/cookie_spec.html
  HTTP Date format:
    RFC 2068, 3.3 Date/Time Formats: http://ds.internic.net/rfc/rfc2068.txt
****************************************************************************/
  DEFINE VARIABLE p_rfcdate AS CHARACTER NO-UNDO.

  /* Does RFC 850/822 allow translated days and months?  Think not. */
  DEFINE VARIABLE weekday-list AS CHARACTER NO-UNDO INITIAL
    "Sun,Mon,Tue,Wed,Thu,Fri,Sat":U.
  DEFINE VARIABLE month-list AS CHARACTER NO-UNDO INITIAL
    "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec":U.

  /* If date is ?, return a blank date */
  IF p_date = ? THEN
    RETURN "".

  IF p_time = ? THEN
    ASSIGN p_time = 0.

  /* If no options are specified, LOCAL is the default */
  IF p_options = "" OR p_options = ? THEN
    ASSIGN p_options = "LOCAL":U.

  /* If Local was specified and the format is Cookie or HTTP, convert date and 
     time to UTC. */
  IF CAN-DO(p_options, "LOCAL":U) AND
    (p_format = "COOKIE":U OR p_format = "HTTP":U) THEN
    /* Convert date and time from Local to UTC */
    convert-datetime("UTC":U, p_date, p_time, OUTPUT p_date, OUTPUT p_time).
  /* Otherwise, just normalize */
  ELSE
    /* Normalize date and time */
    convert-datetime("NORMALIZE":U, p_date, p_time, OUTPUT p_date, OUTPUT p_time).

  /* Output the formatted date */
  CASE p_format:
    WHEN "COOKIE":U THEN DO:
      /* Cookie format based on RFC-1123: Wdy, DD-Mon-YYYY HH:MM:SS GMT */
      ASSIGN 
        p_rfcdate = ENTRY(WEEKDAY(p_date), weekday-list) + ", ":U +
                    STRING(DAY(p_date),"99":U) + "-":U +
                    ENTRY(MONTH(p_date), month-list) + "-":U +
                    STRING(YEAR(p_date), "9999":U) + " ":U +
                    STRING(p_time,"HH:MM:SS":U) + " GMT":U.
    END.
    WHEN "HTTP":U THEN DO:
      /* HTTP format based on RFC-1123: Wdy, DD Mon YYYY HH:MM:SS GMT */
      ASSIGN 
        p_rfcdate = ENTRY(WEEKDAY(p_date), weekday-list) + ", ":U +
                    STRING(DAY(p_date),"99":U) + " ":U +
                    ENTRY(MONTH(p_date), month-list) + " ":U +
                    STRING(YEAR(p_date), "9999":U) + " ":U +
                    STRING(p_time,"HH:MM:SS":U) + " GMT":U.
    END.
    OTHERWISE
      queue-message("WebSpeed":U, "format-datetime: ":U + "format '" + p_format +
                    "' is not supported").
  END CASE.

  RETURN p_rfcdate.

END FUNCTION. /* format-datetime */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-binary-data) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION get-binary-data 
FUNCTION get-binary-data RETURNS MEMPTR
  (INPUT p_name AS CHARACTER) :
/****************************************************************************
Description: Retrieves a MEMPTR with the contents of a file posted with a
             multipart/form-data form
Input Parameter: Name of variable (a field of type 'file' from the form)
Returns: MEMPTR or ? (which means the file was too big).  
****************************************************************************/
    RETURN WEB-CONTEXT:GET-BINARY-DATA(p_name).
END FUNCTION. /* get-binary-data */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-cgi) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION get-cgi 
FUNCTION get-cgi RETURNS CHARACTER
  (INPUT p_name AS CHARACTER) :
/****************************************************************************
Description: Retrieves the value for the specified CGI variable
Input Parameter: Name of variable or ?
Returns: Value or blank if invalid name.  If ? was specified for
  the name, the list of variables is returned.
****************************************************************************/
  DEFINE VARIABLE v-value AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i AS int NO-UNDO.
  
  IF p_name = ? THEN
    RETURN WEB-CONTEXT:GET-CGI-LIST("ENV":U).
  ELSE
    RETURN WEB-CONTEXT:GET-CGI-VALUE("ENV":U, p_name).
END FUNCTION. /* get-cgi */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-cgi-long) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION get-cgi-long 
FUNCTION get-cgi-long RETURNS LONGCHAR
  (INPUT p_name AS CHARACTER) :
/****************************************************************************
Description: Retrieves the LONGCHAR value for the specified CGI variable
Input Parameter: Name of variable or ?
Returns: Value or blank if invalid name.
****************************************************************************/
  IF p_name = ? THEN
    RETURN WEB-CONTEXT:GET-CGI-LIST("ENV":U).
  ELSE
    RETURN WEB-CONTEXT:GET-CGI-LONG-VALUE("ENV":U, p_name).

END FUNCTION. /* get-cgi-long */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-field) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION get-field 
FUNCTION get-field RETURNS CHARACTER
  (INPUT p_name AS CHARACTER) :
/****************************************************************************
Description: Retrieves the associated value for the specified form field.
Input Parameter: Name of field or ?
Returns: Value of field or blank if invalid field name.  If ? was
  specified for the name, the list of fields is returned.
Global Variables: FieldList
****************************************************************************/
  DEFINE VARIABLE v-value AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i       AS int       NO-UNDO.
  DEFINE VARIABLE j       AS int       NO-UNDO.

  DEFINE VARIABLE v-form  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE v-query AS CHARACTER NO-UNDO.
  DEFINE VARIABLE v-name  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTmp    AS CHARACTER NO-UNDO.

  /* Get list of fields? */
  IF p_name = ? THEN DO:
    /* If the field list was already computed for this request, return it */
    IF FieldList <> "" THEN
      RETURN FieldList.
    
    ASSIGN v-form = WEB-CONTEXT:GET-CGI-LIST("FORM":U)
           v-query = WEB-CONTEXT:GET-CGI-LIST("QUERY":U)
           /* Combine form input and query string */
           v-value = v-form +
             (IF v-form <> "" AND v-query <> "" THEN ",":U ELSE "") +
             v-query
           j = NUM-ENTRIES(v-value).

    /* If returning a field list, eliminate dupes */
    DO i = 1 TO j:
      ASSIGN v-name = ENTRY(i, v-value).
      IF LOOKUP(v-name, cTmp) = 0 THEN
        ASSIGN cTmp = cTmp +
               (IF cTmp = "" THEN "" ELSE ",":U) + v-name.
    END.

    ASSIGN FieldList = cTmp. /* save it away */

    RETURN FieldList.
  END.

  /* Else, get a field value */
  ELSE DO:
    /* Return the output directly to maximize the allowable length.
       Replace all CF/LF's with with an LF so when an HTML <TEXTAREA>
       is saved in a database, etc. it won't contain extra characters
       or double-space output. */

    DEFINE VARIABLE getFromForm AS LOGICAL  NO-UNDO.

    IF usetttWebFieldList THEN
       ASSIGN getFromForm = CAN-FIND (FIRST ttWebFieldList WHERE field-name = p_name
                                      AND field-type = "F":U).
    ELSE 
       ASSIGN getFromForm = LOOKUP(p_name, WEB-CONTEXT:GET-CGI-LIST("FORM":U)) > 0.

    IF getFromForm THEN
      RETURN REPLACE(WEB-CONTEXT:GET-CGI-VALUE("FORM":U, p_name, SelDelim),
                     "~r~n":U, "~n":U).
    ELSE
      RETURN REPLACE(WEB-CONTEXT:GET-CGI-VALUE("QUERY":U, p_name, SelDelim),
                     "~r~n":U, "~n":U).
  END.
  RETURN v-value.
END FUNCTION. /* get-field */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-fieldEx) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION get-fieldEx 
FUNCTION get-fieldEx RETURNS LONGCHAR
  (INPUT p_name AS CHARACTER) :
/****************************************************************************
Description: Retrieves the associated value for the specified form field.
Input Parameter: Name of field or ?
Returns: Value of field or blank if invalid field name.  If ? was
  specified for the name, the list of fields is returned.

Similar to get-field but handles long list of fields with LONGCHAR

Global Variables: FieldList
****************************************************************************/
  DEFINE VARIABLE v-value AS LONGCHAR  NO-UNDO.
  DEFINE VARIABLE i       AS int       NO-UNDO.
  DEFINE VARIABLE j       AS int       NO-UNDO.

  DEFINE VARIABLE v-form  AS LONGCHAR  NO-UNDO.
  DEFINE VARIABLE v-query AS LONGCHAR  NO-UNDO.
  DEFINE VARIABLE v-name  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE v-ret   AS LONGCHAR  NO-UNDO.

  /* Get list of fields? */
  IF p_name = ? THEN DO:

    ASSIGN v-form = WEB-CONTEXT:GET-CGI-LIST("FORM":U)
           v-query = WEB-CONTEXT:GET-CGI-LIST("QUERY":U)
           /* Combine form input and query string */
           v-value = v-form +
             (IF v-form <> "" AND v-query <> "" THEN ",":U ELSE "") +
             v-query
           j = NUM-ENTRIES(v-value).

    /* If returning a field list, eliminate dupes */
    DO i = 1 TO j:
      ASSIGN v-name = ENTRY(i, v-value).
      IF LOOKUP(v-name, v-ret) = 0 THEN
        ASSIGN v-ret = v-ret +
               (IF v-ret = "" THEN "" ELSE ",":U) + v-name.
    END.

    RETURN v-ret.
  END.

  /* Else, get a field value */
  ELSE DO:
    DEFINE VARIABLE cTmp AS CHARACTER NO-UNDO.

    /* Return the output directly to maximize the allowable length.
       Replace all CF/LF's with with an LF so when an HTML <TEXTAREA>
       is saved in a database, etc. it won't contain extra characters
       or double-space output. */
    IF get-from-form-fields(p_name) NE NO /* yes and ? should go here */ THEN
      cTmp = WEB-CONTEXT:GET-CGI-VALUE("FORM":U, p_name, SelDelim).
    ELSE
      cTmp = WEB-CONTEXT:GET-CGI-VALUE("QUERY":U, p_name, SelDelim).

    IF (cTmp > "") THEN
      cTmp = REPLACE(cTmp, "~r~n":U, "~n":U).
  
    RETURN cTmp. /* using char for performance */

  END.
  
END FUNCTION. /* get-fieldEx */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-from-form-fields) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION get-from-form-fields 
FUNCTION get-from-form-fields RETURNS LOGICAL
  (INPUT p_name AS CHARACTER) :
/****************************************************************************
Description: Checks if field exists in the form.

****************************************************************************/
  DEFINE VARIABLE getFromForm AS LOGICAL  NO-UNDO.

  IF usetttWebFieldList THEN
     ASSIGN getFromForm = CAN-FIND (FIRST ttWebFieldList WHERE field-name = p_name
                                    AND field-type = "F":U).
  ELSE
     ASSIGN getFromForm = LOOKUP(p_name, WEB-CONTEXT:GET-CGI-LIST("FORM":U)) > 0.

  RETURN getFromForm.

END FUNCTION. /* get-from-form-fields */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-long-value) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION get-long-value 
FUNCTION get-long-value RETURNS LONGCHAR
  (INPUT p_name AS CHARACTER) :
/****************************************************************************
Description: Retrieves the longchar value for a field or cookie.
Input Parameter: Name of field
Returns: Value of form field or Cookie in that order or blank if an invalid name.  
****************************************************************************/
  DEFINE VARIABLE cValue      AS LONGCHAR NO-UNDO.
  DEFINE VARIABLE i           AS int      NO-UNDO.

  /* If name is ? return blank */
  IF p_name = ? OR p_name = "" THEN 
    RETURN cValue.

  /* item name passed so look fields and query string. */
  IF get-from-form-fields(p_name) NE NO /* yes and ? should go here */ THEN
    cValue = WEB-CONTEXT:GET-CGI-LONG-VALUE("FORM":U, p_name, SelDelim).
  ELSE
    cValue = WEB-CONTEXT:GET-CGI-LONG-VALUE("QUERY":U, p_name, SelDelim).

  IF (cValue > "") THEN
    cValue = REPLACE(cValue, "~r~n":U, "~n":U).
  
  RETURN cValue.

END FUNCTION. /* get-long-value */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-user-field) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION get-user-field 
FUNCTION get-user-field RETURNS CHARACTER
  (INPUT p_name AS CHARACTER) :
/****************************************************************************
Description: Retrieves the associated value for the specified user field
  that was set with set-user-field().
Input Parameter: Name of user field or ?
Returns: Value of user field or blank if invalid name.  If ? was
  specified for the name, the list of user fields is returned.
Global Variables: UserFieldList, UserFieldVar
****************************************************************************/
  DEFINE VARIABLE i AS INTEGER NO-UNDO.

  IF p_name = ? THEN
    RETURN UserFieldList.
  ELSE DO:
    ASSIGN i = LOOKUP(p_name, UserFieldList).
    RETURN (IF i > 0 THEN UserFieldVar[i] ELSE "").
  END.
END FUNCTION. /* get-user-field */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-value) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION get-value 
FUNCTION get-value RETURNS CHARACTER
  (INPUT p_name AS CHARACTER) :
/****************************************************************************
Description: Retrieves the first available value for a user field, field
  or cookie.
Input Parameter: Name of item or ?
Returns: Value of user field, form field or Cookie in that order or blank if 
  an invalid name.  If ? was specified for the name, a comma separated list
of all user fields, fields and cookies is returned.
Global Variables: UserFieldList, UserFieldVar, FieldList, FieldVar
****************************************************************************/
  DEFINE VARIABLE v-value       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE v-field-list  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE v-cookie-list AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i             AS int       NO-UNDO.
  DEFINE VARIABLE found         AS LOGICAL   NO-UNDO.

  /* If name is ?, pass a list of all names in user fields, fields and
     cookies. */
  IF p_name = ? THEN DO:
    ASSIGN
      v-field-list = get-field(?)
      v-value = UserFieldList +
        (IF UserFieldList <> "" AND v-field-list <> "" THEN ",":U ELSE "") +
        v-field-list
      v-cookie-list = get-cookie(?)
      v-value = v-value +
        (IF v-value <> "" AND v-cookie-list <> "" THEN ",":U ELSE "") +
        v-cookie-list.
    RETURN v-value.
  END.

  /* Else, item name passed so look for it in user fields, fields and
     cookies in that order. */
  ELSE DO:
    ASSIGN i = LOOKUP(p_name, UserFieldList).
    IF i > 0 THEN
       RETURN UserFieldVar[i].

    IF usetttWebFieldList THEN
       ASSIGN found = CAN-FIND (FIRST ttWebFieldList WHERE field-name = p_name
                                /*AND (field-type = "F":U OR field-type = "Q":U)*/).
    ELSE DO:
       RUN find_web_form_field (p_name, OUTPUT found).
    END.
    
    IF found THEN
       RETURN get-field(p_name).

    RETURN get-cookie(p_name).
  END.

END FUNCTION. /* get-value */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-value) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION get-valueEx 
FUNCTION get-valueEx RETURNS LONGCHAR
  (INPUT p_name AS CHARACTER) :
/****************************************************************************
Description: see get-value()
Input Parameter: Name of item or ?
Returns: Value of user field, form field or Cookie in that order or blank if 
  an invalid name.  If ? was specified for the name, a comma separated list
of all user fields, fields and cookies is returned.
Global Variables: UserFieldList, UserFieldVar

This is an enhanced version of get-value which handles long lists with 
LONGCHAR
****************************************************************************/
  DEFINE VARIABLE v-value       AS LONGCHAR  NO-UNDO.
  DEFINE VARIABLE v-field-list  AS LONGCHAR  NO-UNDO.
  DEFINE VARIABLE v-cookie-list AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i             AS int       NO-UNDO.
  DEFINE VARIABLE found         AS LOGICAL   NO-UNDO.

  /* If name is ?, pass a list of all names in user fields, fields and
     cookies. */
  IF p_name = ? THEN DO:
    ASSIGN
      v-field-list = get-fieldEx(?)
      v-value = UserFieldList +
        (IF UserFieldList <> "" AND v-field-list <> "" THEN ",":U ELSE "") +
        v-field-list
      v-cookie-list = get-cookie(?)
      v-value = v-value +
        (IF v-value <> "" AND v-cookie-list <> "" THEN ",":U ELSE "") +
        v-cookie-list.
    RETURN v-value.
  END.
  /* Else, item name passed so look for it in user fields, fields and
     cookies in that order. */
  ELSE DO:
      ASSIGN i = LOOKUP(p_name, UserFieldList).
      IF i > 0 THEN
        RETURN UserFieldVar[i].

      IF usetttWebFieldList THEN
         ASSIGN found =  CAN-FIND (FIRST ttWebFieldList WHERE field-name = p_name
                                   /*AND (field-type = "F":U OR field-type = "Q":U)*/).
      ELSE
          ASSIGN found = LOOKUP(p_name, get-fieldEx(?)) > 0.

      IF found THEN
         RETURN get-fieldEx(p_name).

      RETURN get-cookie(p_name).
  END.

END FUNCTION. /* get-valueEx */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hidden-field) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION hidden-field 
FUNCTION hidden-field RETURNS CHARACTER
  (INPUT p_name AS CHARACTER,
   INPUT p_value AS CHARACTER) :
/****************************************************************************
Description: Returns an HTML hidden field with the name and value encoded
  with HTML entities.  See html-encode().
Input Parameters: name and value
Returns: HTML hidden field
****************************************************************************/
  RETURN '<INPUT TYPE="HIDDEN" NAME="':U + html-encode(p_name) +
         '" VALUE="':U + html-encode(p_value) + '">':U.
END FUNCTION.  /* hidden-field */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hidden-field-list) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION hidden-field-list 
FUNCTION hidden-field-list RETURNS CHARACTER
  (INPUT p_name-list AS CHARACTER) :
/****************************************************************************
Description: Returns list of fields formatted as hidden fields.
Input Parameters: List of field names (available via get-value), delimiter
Returns: HTML hidden fields delimited by newlines.
****************************************************************************/
  DEFINE VARIABLE i AS INTEGER NO-UNDO.
  DEFINE VARIABLE j AS INTEGER NO-UNDO.
  DEFINE VARIABLE v-item AS CHARACTER NO-UNDO.
  DEFINE VARIABLE v-value AS CHARACTER NO-UNDO.
  DEFINE VARIABLE v-out AS CHARACTER NO-UNDO.

  IF p_name-list = "" THEN RETURN "".   /* return blank if blank */

  ASSIGN j = NUM-ENTRIES(p_name-list).

  DO i = 1 TO j:
    ASSIGN
      v-item = ENTRY(i, p_name-list)
      v-value = get-value(v-item).
    /* Only add hidden field if the value is not blank [Bug 97-02-14-036] */
    IF v-value <> "" THEN
      ASSIGN v-out = v-out + hidden-field(v-item, v-value) + "~n":U.
  END.
    
  RETURN v-out.
END FUNCTION.  /* hidden-field-list */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-html-encode) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION html-encode 
FUNCTION html-encode RETURNS CHARACTER
  (INPUT p_in AS CHARACTER):
/****************************************************************************
Description: Converts various ASCII characters to their HTML representation
  to prevent problems with invalid HTML.  This procedure can only be called
  once on a string or ampersands will incorrectly be replaced with "&amp; .
Input Parameter: Character string to encode
Returns: Encoded character string
****************************************************************************/
  /* Ampersand must be replaced first or the output will be hosed if done
     after any of these other subsititutions. */
  ASSIGN
    p_in = REPLACE(p_in, "&":U, "&amp~;":U)       /* ampersand */
    p_in = REPLACE(p_in, "~"":U, "&quot~;":U)     /* quote */
    p_in = REPLACE(p_in, "<":U, "&lt~;":U)        /* < */
    p_in = REPLACE(p_in, ">":U, "&gt~;":U).       /* > */
  RETURN p_in.
END FUNCTION. /* html-encode */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-output-content-type) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION output-content-type 
FUNCTION output-content-type RETURNS LOGICAL
  (INPUT p_type AS CHARACTER) :
/****************************************************************************
Description: Sets and outputs the MIME Content-Type header followed by a
  blank line.  If the header was already output, no action is taken.
Input Parameter: MIME content type.  If the input value is "", then no
  Content-Type header will be output.  However, other headers such as Cookies
  will be output followed by a blank line.
Returns: If a Content-Type header was output, TRUE is returned, else FALSE.
Global Variables: output-content-type
****************************************************************************/  
  DEFINE VARIABLE c-new-wseu   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE rslt         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE mime-charset AS CHARACTER NO-UNDO.
  
  /* Set the content type. If previously set, then output-content-type will
     be non-blank.  In that case we do nothing.  If p_type is blank, then no
     Content-Type header will be output.  In this case output-content-type 
     will be set to ?. */
  IF output-content-type = "" THEN DO:
    ASSIGN 
      output-content-type = (IF p_type = "" THEN ? ELSE p_type)
      c-new-wseu          = ENTRY(2, {&WEB-EXCLUSIVE-ID}, "=":U).
      
    &IF KEYWORD-ALL("HTML-CHARSET") <> ? &THEN  
    /* Add MIME codepage, if available. */
    IF output-content-type BEGINS TRIM("text/html":U) 
      AND INDEX(output-content-type, "charset":U) = 0
      AND WEB-CONTEXT:html-charset <> "" THEN DO:
        RUN adecomm/convcp.p ( WEB-CONTEXT:html-charset, "toMime":U,
                               OUTPUT mime-charset ) NO-ERROR.
        IF mime-charset <> "" THEN
          output-content-type = output-content-type + "; charset=":U + 
                                mime-charset.
    END.
    &ENDIF
    
    /* If there are any persistent Web objects, then reset the cookie used by 
     * the web broker to identify this Agent. (The wo temp-table is 
     * defined in web/objects/web-util.p.)
     */
    RUN find-web-objects IN web-utilities-hdl (OUTPUT rslt).
    IF rslt THEN
      set-wseu-cookie(c-new-wseu).
    ELSE
      /* No persistent Web objects, so kill the wseu cookie */
      set-wseu-cookie("").

    IF output-content-type <> ? THEN
       output-http-header ("Content-Type":U, output-content-type).
    output-http-header ("", "").  /* blank line */

    /* If output-content-type is not ?, then a Content-Type header was
       output so return TRUE. */
    RETURN (output-content-type <> ?).
  END.
  /*  This needs to be sent *after* <BODY> is output.  This error message is
      another reason why we need to queue up certain error messages and output
      later. -dma
  ELSE DO: /* Attempt to send cookies *after* Content-Type has been sent! */
    XXX: To do: Queue a runtime error message with queue-message().
    {&OUT}
    "<b>WARNING:</b> output-content-type was called more than once."
    .
    RETURN ?.
  END.
  */

  /* If the "top" debugging option was specified, run printval.p before the
     application output rather than after.  This is not the default because
     printval.p generates its own HEAD and BODY tags which could cause
     those tags in the application's HTML to not function as expected. */
  /** disable "top" option
  IF CAN-DO(debug-options,"top":U) THEN
    RUN web/support/printval.p (debug-options).
   **/

END FUNCTION. /* output-content-type */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-output-http-header) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION output-http-header 
FUNCTION output-http-header RETURNS CHARACTER
  (INPUT p_header AS CHARACTER,
   INPUT p_value  AS CHARACTER) :
/****************************************************************************
Description: Outputs the specified HTTP header with associated value followed
  by a carriage return and linefeed.  If the header name is blank, then the
  value and carriage return/linefeed pair are still output.
Input Parameters: HTTP Header name (less colon), associated header value.
****************************************************************************/
  
  /* Remove a trailing colon or spaces from the header name.  Add it back
     on exactly the way we want it. */
  ASSIGN p_header = RIGHT-TRIM(p_header, ": ":U).
  IF p_header <> "" THEN
    ASSIGN p_header = p_header + ": ":U.

  /* If debugging is enabled and "http" is a debugging option, queue
     the headers so we can see what was actually sent out. */
  IF debugging-enabled AND CAN-DO(debug-options, "http":U) AND
      p_header <> "" AND p_value <> "" THEN
    queue-message("DEBUG":U, "<B>HTTP header:</B> ":U + p_header + p_value).

  /* Output the header and associated value to the output stream */
  PUT {&WEBSTREAM} CONTROL
    p_header
    p_value 
    /* Newline must have both CR and LF even on UNIX.   
       Bug: 97-03-04-008  Some web servers such as Netscape-Fasttrack 2.01
       don't like the CR character so allow the newline to be changed. */
    http-newline.
END FUNCTION. /* output-http-header */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-user-field) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION set-user-field 
FUNCTION set-user-field RETURNS LOGICAL
  (INPUT p_name AS CHARACTER,
   INPUT p_value AS CHARACTER) :
/****************************************************************************
Description: Sets the associated value for the specified user field.  User
  field values are global and available to any Web object run by the
  current Agent in the same web request.  The value can be retrieved with 
  get-user-field() or get-value(). 
Input Parameters: Name of user field, associated value
Returns: TRUE if field added, otherwise FALSE
Side effects: Queues a message if adding a field fails
Global Variables: UserFieldList, UserFieldVar
****************************************************************************/

  DEFINE VARIABLE i AS int NO-UNDO.

  ASSIGN i = LOOKUP(p_name, UserFieldList).

  IF i > 0 THEN
    ASSIGN UserFieldVar[i] = p_value.
  ELSE DO:
    IF NUM-ENTRIES(UserFieldList) < {&MAX-USER-FIELDS} THEN
      ASSIGN
        UserFieldList = UserFieldList +
          (IF UserFieldList = "" THEN "" ELSE ",":U) + p_name
        i = NUM-ENTRIES(UserFieldList)
        UserFieldVar[i] = p_value.
    ELSE DO:
      /* If we get to here, then there's no more room for new parameters. */
      queue-message("WebSpeed":U, "set-user-field: ":U + "maximum number of entries" +
                                  " {&MAX-USER-FIELDS} exceeded").
      ASSIGN i = ?.
    END.
  END.
  RETURN (i <> ?).  /* return TRUE unless field could not be added */
END FUNCTION. /* set-user-field */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-wseu-cookie) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION set-wseu-cookie 
FUNCTION set-wseu-cookie RETURNS CHARACTER
  (INPUT p_cookie AS CHARACTER) :
/****************************************************************************
Description: Sets the WSEU cookie in a standard way.  This also changes
  the wseu-cookie variable to the value set.  When this is called, it checks
  the current value of wseu-cookie, and only sets the new value if it is
  different.  If the new value, p_cookie, is blank or ?, then the wseu
  cookie is deleted.
Input Parameters: p_cookie -- the new cookie value..
****************************************************************************/
  /* Change unknown to blank. */
  IF p_cookie eq ? THEN p_cookie = "".

  /* Is the cookie value different? */
  IF p_cookie NE wseu-cookie THEN DO:
    /* Save the new value. */
    ASSIGN wseu-cookie = p_cookie.
    IF p_cookie eq "" THEN 
      RETURN delete-cookie ({&WSEU-NAME}, ?, ?).   
    ELSE DO:
      IF NOT cfg-eval-mode THEN
        set-cookie ({&WSEU-NAME}, wseu-cookie, ?, ?, ?, ?, ?).    
      RETURN "".
    END.
  END.  
END FUNCTION. /* set-wseu-cookie */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-url-decode) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION url-decode 
FUNCTION url-decode RETURNS CHARACTER
  (INPUT p_in AS CHARACTER) :
/****************************************************************************
Description: Decodes URL form input from either POST or GET methods or
  encoded Cookie values.  CR/LF pairs are replaced with LF.
Input: String to decode
Returns: decoded string
****************************************************************************/
  DEFINE VARIABLE out AS CHARACTER NO-UNDO.
  
  /* Copy and replace from p_in to out.  Note that p_in will have
     End-of-Line replaced with a CF/LF.  We need to replace this with the
     4GL-standard LF so when an HTML <TEXTAREA> is saved in a database, it
     won't contain extra characters. */
  ASSIGN 
    out = REPLACE(p_in, "%0D%0A":U, "~n":U).

  RETURN WEB-CONTEXT:URL-DECODE(out).
END FUNCTION.  /* url-decode */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-url-encode) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION url-encode 
FUNCTION url-encode RETURNS CHARACTER
  (INPUT p_value AS CHARACTER,
   INPUT p_enctype AS CHARACTER) :
/****************************************************************************
Description: Encodes unsafe characters in a URL as per RFC 1738 section 2.2.
  <URL:http://ds.internic.net/rfc/rfc1738.txt>, 2.2
Input Parameters: Character string to encode, Encoding option where "query",
  "cookie", "default" or any specified string of characters are valid.
  In addition, all characters specified in the global variable url_unsafe
  plus ASCII values 0 <= x <= 31 and 127 <= x <= 255 are considered unsafe.
Returns: Encoded string  (unkown value is returned as blank)
Global Variables: url_unsafe, url_reserved
****************************************************************************/
  DEFINE VARIABLE hx          AS CHARACTER NO-UNDO INITIAL "0123456789ABCDEF":U.
  DEFINE VARIABLE encode-list AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE c           AS INTEGER   NO-UNDO.
 
  /* Don't bother with blank or unknown  */
  IF LENGTH(p_value) = 0 OR p_value = ? THEN 
    RETURN "".
   
  /* What kind of encoding should be used? */
  CASE p_enctype:
    WHEN "query":U THEN              /* QUERY_STRING name=value parts */
      encode-list = url_unsafe + url_reserved + "+":U.
    WHEN "cookie":U THEN             /* Persistent Cookies */
      encode-list = url_unsafe + " ,~;":U.
    WHEN "default":U OR WHEN "" THEN /* Standard URL encoding */
      encode-list = url_unsafe.
    OTHERWISE
      encode-list = url_unsafe + p_enctype.   /* user specified ... */
  END CASE.

  /* Loop through entire input string */
  ASSIGN i = 0.
  DO WHILE TRUE:
    ASSIGN
      i = i + 1
      /* ASCII value of character using single byte codepage */
      c = ASC(SUBSTRING(p_value, i, 1, "RAW":U), "1252":U, "1252":U).
    IF c <= 31 OR c >= 127 OR INDEX(encode-list, CHR(c)) > 0 THEN DO:
      /* Replace character with %hh hexidecimal triplet */
      SUBSTRING(p_value, i, 1, "RAW":U) =
        "%":U +
        SUBSTRING(hx, INTEGER(TRUNCATE(c / 16, 0)) + 1, 1, "RAW":U) + /* high */
        SUBSTRING(hx, c MODULO 16 + 1, 1, "RAW":U).             /* low digit */
      ASSIGN i = i + 2.   /* skip over hex triplet just inserted */
    END.
    IF i = LENGTH(p_value,"RAW":U) THEN LEAVE.
  END.

  RETURN p_value.
END FUNCTION.  /* url-encode */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-url-field) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION url-field 
FUNCTION url-field RETURNS CHARACTER
  (INPUT p_name AS CHARACTER,
   INPUT p_value AS CHARACTER,
   INPUT p_delim AS CHARACTER) :
/****************************************************************************
Description: Encodes name and value pairs for use suitable as an
  argument "field" to a URL.
Input Parameters: name, value, delimeter
Returns: Encoded name and value pair
****************************************************************************/
  RETURN (IF p_delim = ? THEN "&amp~;":U ELSE p_delim) +
         url-encode(p_name, "query":U) +
         "=":U +
         url-encode(p_value, "query":U).
END FUNCTION.  /* url-field */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-url-field-list) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION url-field-list 
FUNCTION url-field-list RETURNS CHARACTER
  (INPUT p_name-list AS CHARACTER,
   INPUT p_delim AS CHARACTER) :
/****************************************************************************
Description: Encodes list of items for use suitable as a argument "fields"
  to a URL.
Input Parameters: List of field names (available via get-value),
  delimiter
Returns: Encoded name and value pairs
****************************************************************************/
  DEFINE VARIABLE i AS INTEGER NO-UNDO.
  DEFINE VARIABLE j AS INTEGER NO-UNDO.
  DEFINE VARIABLE v-item AS CHARACTER NO-UNDO.
  DEFINE VARIABLE v-value AS CHARACTER NO-UNDO.
  DEFINE VARIABLE v-out AS CHARACTER NO-UNDO.

  /* return blank if blank or unknown */
  IF p_name-list = "" OR p_name-list = ? THEN RETURN "".
  /* blank delimiter uses the default */
  IF p_delim = "" THEN p_delim = ?.

  ASSIGN j = NUM-ENTRIES(p_name-list).

  DO i = 1 TO j:
    ASSIGN
      v-item = ENTRY(i, p_name-list)
      v-value = get-value(v-item).
    /* Only add name=value pair if the value is not blank [Bug 97-02-14-036] */
    IF v-value <> "" THEN
      ASSIGN v-out = v-out +
        /* Encode to name=value pair using specified delimiter with no
           delimiter before the first name=value pair. */
        url-field(v-item, v-value, (IF v-out = "" THEN "" ELSE p_delim)).
  END.
    
  RETURN v-out.
END FUNCTION.  /* url-field-list */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-url-format) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION url-format 
FUNCTION url-format RETURNS CHARACTER
  (INPUT p_url AS CHARACTER,
   INPUT p_name-list AS CHARACTER,
   INPUT p_delim AS CHARACTER):
/****************************************************************************
Description: Given a URL, item list and delimiter, format it including any
  state information.
Input Parameters: URL, item list, argument delimeter (use ? for default)
Returns: Encoded URL
****************************************************************************/
  DEFINE VARIABLE url-arg AS CHARACTER NO-UNDO.

  ASSIGN url-arg = url-field-list(p_name-list, p_delim).

  RETURN (IF p_url = ? THEN SelfURL ELSE p_url) +
         (IF url-arg = "" THEN "" ELSE "?":U + url-arg).
END FUNCTION.  /* url-format */
&ANALYZE-RESUME

&ENDIF

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 


/* ***************************  Main Block  *************************** */
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-AsciiToHtml) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE AsciiToHtml 
PROCEDURE AsciiToHtml :
/****************************************************************************
Description: See html-encode.  For backwards compatibility with
WebSpeed 1.0.
Input Parameter: Character string to convert
Output Parameter: Converted character string
****************************************************************************/
  DEFINE INPUT  PARAMETER p_in  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_out AS CHARACTER NO-UNDO.

  /* Invoke function to perform the conversion */
  ASSIGN p_out = html-encode(p_in).
END PROCEDURE. /* AsciiToHtml */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetCGI) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE GetCGI 
PROCEDURE GetCGI :
/****************************************************************************
Description: See getcgi().
Input Parameter: Name of variable or ?
Output Parameter: Value or blank if invalid name.  If ? was specified for
  the name, the list of variables is returned.
Global Variables: CgiList, CgiVar
****************************************************************************/
  DEFINE INPUT  PARAMETER p_name  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_value AS CHARACTER NO-UNDO.
  
  /* Just return the function output */
  ASSIGN p_value = get-cgi (p_name).
END PROCEDURE.
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetField) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE GetField 
PROCEDURE GetField :
/****************************************************************************
Description: See get-field().
Input Parameter: Name of field or ?
Output Parameter: Value of field or blank if invalid field name.  If ? was
  specified for the name, the list of fields is returned.
Global Variables: FieldList, FieldVar
****************************************************************************/
  DEFINE INPUT  PARAMETER p_name  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_value AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i AS int NO-UNDO.

  /* Just return the function output */
  ASSIGN p_value = get-field(p_name).
END PROCEDURE.
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-HtmlError) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE HtmlError 
PROCEDURE HtmlError :
/****************************************************************************
Description: Prints the input text string as an HTML error message also
  printing the MIME Content-Type header if required.
Input Parameter: Character string to output
****************************************************************************/
  DEFINE INPUT PARAMETER p_error AS CHARACTER NO-UNDO.
  
  RUN OutputContentType (INPUT "text/html":U).
  {&OUT}
  "<HTML>~n":U
  "<HEAD><TITLE>":U "Application Error" "</TITLE></HEAD>~n":U
  "<BODY>~n":U
  "<H1>":U "Application Error" "</H1>~n~n":U
  "<P>":U p_error "</P>~n":U
  (IF HelpAddress <> "" THEN
    "<P>":U + "In the event of a problem with this application, please " +
    "contact " + HelpAddress + "</P>~n":U ELSE "")
  "</BODY>~n":U
  "</HTML>~n":U
  {&END}
END PROCEDURE. /* HtmlError */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-OutputContentType) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE OutputContentType 
PROCEDURE OutputContentType :
/****************************************************************************
Description: See output-content-type().
Input Parameter: MIME content type (optional).  The default Content Type is
  "text/html" if the input value is "".
Global Variables: output-content-type
****************************************************************************/
  DEFINE INPUT PARAMETER p_type AS CHARACTER NO-UNDO.

  /* Execute the output-content-type() function.  For backwards compatibility,
     make text/html the default MIME type. */
  output-content-type ((IF p_type = "" THEN "text/html":U ELSE p_type)).
END PROCEDURE. /* OutputContentType */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-OutputHttpHeader) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE OutputHttpHeader 
PROCEDURE OutputHttpHeader :
/****************************************************************************
Description: See output-http-header().
Input Parameters: HTTP Header name (less colon), associated header value.
****************************************************************************/
  DEFINE INPUT PARAMETER p_header AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_value  AS CHARACTER NO-UNDO.
  
  output-http-header(p_header, p_value).
END PROCEDURE. /* OutputHttpHeader */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-UrlDecode) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE UrlDecode 
PROCEDURE UrlDecode :
/****************************************************************************
Description: See url-decode().
Input: String to decode
Output: decoded string
Stream: Decoded string
****************************************************************************/
  DEFINE INPUT  PARAMETER p_in  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_out AS CHARACTER NO-UNDO.

  ASSIGN p_out = url-decode(p_in).
END PROCEDURE.  /* UrlDecode */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-UrlEncode) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE UrlEncode 
PROCEDURE UrlEncode :
/****************************************************************************
Description: See url-encode().
Input Parameters: Character string to encode, Encoding option where "query",
  "cookie", "default" or any specified string of characters are valid.
  In addition, all characters specified in the global variable url_unsafe
  plus ASCII values 0 <= x <= 31 and 127 <= x <= 255 are considered unsafe.
Output: Encoded string
Global Variables: url_unsafe, url_reserved
****************************************************************************/
  DEFINE INPUT  PARAMETER p_value   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_encoded AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER p_enctype AS CHARACTER NO-UNDO.

  ASSIGN p_encoded = url-encode(p_value, p_enctype).
END PROCEDURE.  /* UrlEncode */

/* END OF CGIUTILS.I PREPROCESSOR */
&ENDIF  /* DEFINED(CGIUTILS_I) = 0 */
&ANALYZE-RESUME

&ENDIF

 &IF DEFINED(EXCLUDE-find_web_form_field) = 0 &THEN

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE find_web_form_field 
/****************************************************************************
Description: Find if a given field name exists in the form or query string
             This does what get-field(?) does but handle the case where
             there are too many fields to be placed in the FieldList global.
Input Parameter: Name of item 
Output: found returns TRUE if it finds a field, otherwise it returns false.
****************************************************************************/

PROCEDURE find_web_form_field.
    DEFINE INPUT  PARAMETER p_name AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER found  AS LOGICAL   NO-UNDO.

    DEFINE VARIABLE v-value AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i       AS int       NO-UNDO.
    DEFINE VARIABLE j       AS int       NO-UNDO.

    DEFINE VARIABLE v-form  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE v-query AS CHARACTER NO-UNDO.
    DEFINE VARIABLE v-name  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cTmp    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lChForm AS LONGCHAR  NO-UNDO.
    DEFINE VARIABLE lChQry  AS LONGCHAR  NO-UNDO.
    
    IF FieldList = "" THEN DO:

        ASSIGN v-form = WEB-CONTEXT:GET-CGI-LIST("FORM":U) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
            lChForm = WEB-CONTEXT:GET-CGI-LIST("FORM":U).

        ASSIGN v-query = WEB-CONTEXT:GET-CGI-LIST("QUERY":U) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
            lChQry = WEB-CONTEXT:GET-CGI-LIST("QUERY":U).

        /* if either one of the strings is too big, 
           just handle it w/ longchars */
        IF lChForm NE "" OR lChQry NE "" THEN DO:
            IF lChForm NE "" THEN
               found = LOOKUP(p_name, lChForm) > 0.
            ELSE
               found = LOOKUP(p_name, v-form) > 0.

            IF NOT found THEN DO:
               IF lChQry NE "" THEN
                  found = LOOKUP(p_name, lChQry) > 0.
               ELSE
                  found = LOOKUP(p_name, v-query) > 0.
            END.

            RETURN.
        END.

        /* Combine form input and query string */
        ASSIGN v-value = v-form +
                 (IF v-form <> "" AND v-query <> "" THEN ",":U ELSE "") +
                 v-query NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            /* can't put the 2 strings together, just lookup the field name */
            found = LOOKUP(p_name, v-form) > 0.
            IF NOT found THEN
               found = LOOKUP(p_name, v-query) > 0.

            RETURN.
        END.

        ASSIGN j = NUM-ENTRIES(v-value).
    
        /* eliminate dupes */
        DO i = 1 TO j:
          ASSIGN v-name = ENTRY(i, v-value).
          IF LOOKUP(v-name, cTmp) = 0 THEN
            ASSIGN cTmp = cTmp +
                   (IF cTmp = "" THEN "" ELSE ",":U) + v-name.
        END.
    
        ASSIGN FieldList = cTmp NO-ERROR. /* save it away */
        IF ERROR-STATUS:ERROR THEN DO:
            /* if we got this far, just lookup using cTmp and don't
               assign FieldList - the form must have too many fields.
            */
            found = (LOOKUP(p_name, cTmp) > 0).
            RETURN.
        END.
    END.

    found = (LOOKUP(p_name, FieldList) > 0).

END PROCEDURE. /* find_web_form_field */
&ANALYZE-RESUME

&ENDIF
