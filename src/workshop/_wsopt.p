&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Procedure
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 
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
/*----------------------------------------------------------------------------

File: _wsopt.p

Description:
    Checks the WSOPTIONS meta tag on an e4gl file and makes sure all
    the _P fields (i.e. compile, type-list) are set correctly.

Input Parameters:
    p_proc-id - Context ID of the file
Output Parameters:  
    p_e4gl    - TRUE if the file is really an e4gl file.

Author: Wm. T. Wood
Date Created: April 14, 1997

History:
-----------------------------------------------------------------------*/
/*            This file was created with WebSpeed Workshop.            */
/*---------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_proc-id  AS INTEGER NO-UNDO.
                        /* Context ID of the _P record.                */
DEFINE OUTPUT PARAMETER p_e4gl     AS LOGICAL INITIAL yes NO-UNDO .
                        /* File to open                                */

/* Local Definitions --                                                */
DEFINE VAR genfile     AS CHAR    NO-UNDO.
DEFINE VAR iPos        AS INTEGER NO-UNDO.
DEFINE VAR wsoptions   AS CHAR    NO-UNDO.

/* Shared Include File definitions  --                                  */
{ workshop/objects.i }      /* Object TEMP-TABLE definition             */
{ workshop/code.i }         /* Code Section TEMP-TABLE                  */

/* ************************ Main Code Block ************************** */

/* Find the relevant _P. [It should always exist.] */
FIND _P WHERE RECID(_P) eq p_proc-id.

/* If the file is not OPEN, then look at the file itself for the answer. */
IF _P._open THEN RUN get-wsoptions (OUTPUT wsoptions).
ELSE DO:
  /* Use the "get-options" option. */
  wsoptions = "get-options":U.
  RUN webutil/e4gl-gen.p (_P._fullpath, INPUT-OUTPUT wsoptions, INPUT-OUTPUT genfile).
  /* Remove "get-options" and "web-object" which are always returned. */
  ASSIGN wsoptions = REPLACE(",":U + wsoptions + ",":U, ",get-options":U, ",":U)
         wsoptions = REPLACE( wsoptions, ",web-object":U , ",":U)
         wsoptions = TRIM (wsoptions, ",":U)
         .
END. /* IF [not] _P._OPEN... */

/*
 * Now parse the list of wsoptions to see what we need to do.
 */

/* Check for COMPILE on save. */
IF _P._compile     AND LOOKUP("no-compile":U, wsoptions) > 0 THEN _P._compile = no.
IF NOT _P._compile AND LOOKUP("compile":U, wsoptions) > 0    THEN _P._compile = yes.

/* Check the file-type. */
iPos = LOOKUP("include":U, _P._type-list).
IF LOOKUP("include":U, wsoptions) > 0 THEN DO:
  IF iPos eq 0 THEN _P._type-list = _P._type-list + ",Include":U.
END.
ELSE IF iPos > 0 THEN ENTRY(iPos, _P._type-list) = "":U.
 
/* If there are any WSOPTIONS, then the file is definitely an E4GL file. */
IF wsoptions ne "":U AND LOOKUP("E4GL":U, _P._type-list) eq 0
THEN _P._type-list = _P._type-list + ",E4GL":U.

RETURN.
&ANALYZE-RESUME
/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE get-wsoptions 
PROCEDURE get-wsoptions :
/*------------------------------------------------------------------------------
  Purpose:     Parse the code contents of a loaded HTML file and extract
               the wsoptions.
  Parameters:  p_options -- CHAR - the value of the WSOPTIONS contents
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER p_options AS CHAR NO-UNDO.

  /* Local variables */
  DEFINE VAR code-id     AS RECID   NO-UNDO.
  DEFINE VAR iEnd        AS INTEGER NO-UNDO.
  DEFINE VAR iPos        AS INTEGER NO-UNDO.
  DEFINE VAR tmp         AS CHAR    NO-UNDO.

  /* Look at the first code block for the options. */
  RUN workshop/_find_cd.p (p_proc-id, "FIRST":U, "":U, OUTPUT code-id).
  IF code-id ne ? THEN DO:
    FIND _code WHERE RECID(_code) eq code-id NO-ERROR.
    IF _code._text-id ne ? 
    THEN FIND _code-text WHERE RECID(_code-text) eq _code._text-id NO-ERROR.
    IF AVAILABLE _code-text THEN DO:
      /* Find the code for ...wsoptions...CONTENT="option list" in the code text */
      /* The options must appear before the </HEAD> in the file. (If no HEAD, the
         look in the first 25 lines (at 40 char/line = 1000 char). */
      iPos = INDEX(_code-text._text, "</HEAD>":U).
      IF iPos eq 0 THEN iPos = MIN (LENGTH(_code-text._text), 1024).
      IF iPos > 1 THEN tmp = SUBSTRING(_code-text._text, 1, iPos, "CHARACTER":U).
      /* Now look for WSOPTIONS followed closely by a Space. */
      iPos = INDEX(tmp, "wsoptions":U).
      IF iPos > 0 THEN DO:
        /* Look for wsoptions...CONTENT="..."> in the string.  Note that the
           CONTENT must proceed the ">". */
        ASSIGN iPos = iPos + LENGTH("wsoptions", "CHARACTER":U)
               tmp  = SUBSTRING(tmp, iPos , -1, "CHARACTER":U)
               iPos = INDEX (tmp, "CONTENT":U) 
               iEnd = INDEX (tmp, ">":U)
               iPos = iPos + 7 /* Move to end of CONTENT */
               .
        IF iPos < iEnd THEN DO:
          /* Get the tokens of the "option" in CONTENT = "options" > */
          ASSIGN tmp  = SUBSTRING (tmp, iPos, iEnd - iPos, "Character":U)
                 iPos = INDEX(tmp, '"':U)
                 iEnd = 0.
          IF iPos > 0 AND iPos + 1 < LENGTH(tmp, "CHARACTER":U)
          THEN iEnd = INDEX(tmp, '"':U, iPos + 1).
          IF iEnd ne 0 AND iEnd > iPos + 1 THEN DO:
            p_options = SUBSTRING(tmp, iPos + 1, iEnd - (iPos + 1), "CHARACTER":U).
            /* Strip out spaces. */
            p_options = REPLACE (p_options, " ":U, "":U).
          END.
        END. /* IF [found CONTENT]... */
      END. /* IF ipos [location of wsoptions] > 0... */        
    END. /* IF available _code-text ... */
  END. /* IF code-id ne ?... */

END PROCEDURE.
&ANALYZE-RESUME
 

