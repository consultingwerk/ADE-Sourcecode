/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/* _usrebox.p - error dialog box routine - displays a message, then returns */

/*
Input text comes in 'question' parameter, and may be any length.
This program splits it up into 45-character chunks, breaking at
spaces.  Embedded '!' marks get translated into line-feeds (like
in column-labels).
*/

DEFINE INPUT PARAMETER question AS CHARACTER NO-UNDO.
DEFINE VARIABLE ans AS LOGICAL NO-UNDO.

/* s-alert uses a carat instead of ! (why?) */
question = REPLACE(question, "!", "^").  

RUN adecomm/_s-alert.p 
   (INPUT-OUTPUT ans, INPUT "ERROR", 
    INPUT "OK",       INPUT question).

