/*********************************************************************
* Copyright (C) 2000,2009 by Progress Software Corporation. All rights  *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-------------------------------------------------------------------------

File: src/web/method/cgiarray.i

Description: Global include file for all Web and CGI arrays

Notes:
  This file is for internal use by WebSpeed runtime procedures ONLY. 
  Applications should not include this file.

  The NEW option must be specified when this file is included by the
  initial calling procedure.   
  
  Associated procedures for manipulating these variables are
  found in cgiprocs.i.

Author: B.Burton, Wm.T.Wood

Created: 05/14/96

---------------------------------------------------------------------------*/

/* Only define things if this file has not yet been included */
&IF DEFINED(CGIARRAY_I) = 0 &THEN
&GLOBAL-DEFINE CGIARRAY_I = TRUE

&IF DEFINED(MAX-FIELDS) = 0 &THEN
  &GLOBAL-DEFINE MAX-FIELDS 255
&ENDIF
&IF DEFINED(MAX-CGI) = 0 &THEN
  &GLOBAL-DEFINE MAX-CGI 255
&ENDIF
&IF DEFINED(MAX-USER-FIELDS) = 0 &THEN
  &GLOBAL-DEFINE MAX-USER-FIELDS 255
&ENDIF

/* List of CGI variables passed */
DEFINE NEW GLOBAL SHARED VARIABLE CgiList           AS CHAR FORMAT "x(70)" 
    NO-UNDO.
/* Array of CGI values corresponding to CgiList (arbitrary limit) */
DEFINE NEW GLOBAL SHARED VARIABLE CgiVar            AS CHAR 
    EXTENT {&MAX-CGI}    NO-UNDO.

/* List of fields in form */
DEFINE NEW GLOBAL SHARED VARIABLE FieldList         AS CHAR FORMAT "x(70)" 
    NO-UNDO.
/* Array of field values corresponding to FieldList (arbitrary limit) */
DEFINE NEW GLOBAL SHARED VARIABLE FieldVar          AS CHAR 
    EXTENT {&MAX-FIELDS} NO-UNDO.

/* holds list of form and query fields */
DEFINE NEW GLOBAL SHARED TEMP-TABLE ttWebFieldList NO-UNDO
    FIELD field-num  AS INTEGER
    FIELD field-name AS CHARACTER
    FIELD field-type AS CHARACTER /* 'F' or 'Q' */
    INDEX prim-index IS PRIMARY field-name field-type field-num.

DEFINE NEW GLOBAL SHARED VARIABLE usetttWebFieldList AS LOGICAL NO-UNDO.

/* List of local fields */
DEFINE NEW GLOBAL SHARED VARIABLE UserFieldList    AS CHAR FORMAT "x(70)" 
    NO-UNDO.
/* Array of values corresponding to UserFieldList (arbitrary limit) */
DEFINE NEW GLOBAL SHARED VARIABLE UserFieldVar     AS CHAR
    EXTENT {&MAX-USER-FIELDS}   NO-UNDO.


/* List of all CGI variables (from cgidefs.i).  Used for dumping out all
   values in debugging mode such as with printval.p. */
DEFINE NEW GLOBAL SHARED VARIABLE CgiVarList        AS char NO-UNDO.
IF CgiVarList = "":U THEN
  ASSIGN CgiVarList = "GATEWAY_INTERFACE,SERVER_SOFTWARE,SERVER_PROTOCOL,":U +
    "SERVER_NAME,SERVER_PORT,REQUEST_METHOD,SCRIPT_NAME,PATH_INFO,":U +
    "PATH_TRANSLATED,QUERY_STRING,REMOTE_ADDR,REMOTE_HOST,REMOTE_IDENT,":U +
    "REMOTE_USER,AUTH_TYPE,CONTENT_TYPE,CONTENT_LENGTH,":U +
    "HTTP_ACCEPT,HTTP_COOKIE,HTTP_REFERER,HTTP_USER_AGENT":U.

&ENDIF  /* DEFINED(CGIARRAY_I) = 0 */
