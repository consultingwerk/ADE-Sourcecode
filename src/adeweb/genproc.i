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
File: genproc.i

Description:
    Include file containing the internal procedures.  The reason
    for breaking this out into an include file these procedures need to be included
    in _gen4gl.p, _gendefs.p and _qikcomp.p
      
    Note: this is based on the old adeuib/_genpro2.i.  The
    old adeuib/_genproc.i does not exist. It is now mixed in
    with _gendefs.p and _preproc.p.
    
Input Parameters:
   <None>

Output Parameters:
   <None>

Author: Wm. T. Wood [from the uib version by myself and D. Ross Hunter ]
Created: 1997
Updated: 2/13/98 adams Modified for Skywalker
         3/30/01 jep   Added PARAMETER BUFFER b_TRG to put-code-text as part
                       of fix to 20010205-003 where adding a function to a
                       v2.1 file writes duplicate definitions and other
                       sections on save, corrupting the file.

---------------------------------------------------------------------------- */

/* ************************************************************************* */
/*                                                                           */
/*             COMMON PROCEDURES FOR SAVING CODE SECTIONS, ETC.              */
/*                                                                           */
/* ************************************************************************* */
  
/*
/* Put out the code section for the current _TRG record.  If this is a 
   structured section, you should use put-structured-section. This just 
   regurgitates the header and footer information around the test. */
PROCEDURE put-code-section: 
  /* Save the section as is --- this way we won't loose anything that
     we are not prepared to handle. */
  PUT STREAM P_4GL UNFORMATTED _code._header. 
  RUN put-code-text (BUFFER _TRG).
  PUT STREAM P_4GL UNFORMATTED _code._footer.
END PROCEDURE.  
*/

/* Put out the code section for the current _TRG record. This section
   is surrounded by an &ANALYZE-SUSPEND...&ANALYZE-RESUME block.  Note
   that the name is quoted and encoded if necessary. The inverse process
   is done in workshop/_cdread.p.  */
PROCEDURE put-structured-section: 
  DEFINE VARIABLE qname AS CHAR NO-UNDO.
  /* See if the name needs quoting. */  
  qname = TRIM(_TRG._tEVENT).
  IF _P._file-version BEGINS "WDT_v2":U THEN
    CASE qname:
      WHEN "_DEFINITIONS":U THEN qname = "Definitions":U.
      WHEN "_MAIN-BLOCK":U  THEN qname = "Main Code Block":U.
    END CASE.

  IF INDEX(qname, ' ':U) > 0 OR INDEX(qname, '"':U) > 0 THEN
    qname = '"':U + REPLACE(qname, '"':U, '&quot~;') + '"':U.
  
  /* Place the section header for the section. Note that _HIDDEN and internal
     _APPBUILDER sections don't have the "_CODE-BLOCK" leader. */
  PUT STREAM P_4GL UNFORMATTED
    "&ANALYZE-SUSPEND ":U
    (IF LOOKUP(_TRG._tSECTION,"_HIDDEN,_APPBUILDER":U) > 1 THEN "":U 
     ELSE "_CODE-BLOCK ":U) _TRG._tSECTION SPACE qname SPACE
     IF _TRG._tSPECIAL ne ? THEN _TRG._tSPECIAL ELSE "" SKIP.
     
  /* Put the code text. */
  RUN put-code-text (BUFFER _TRG).
  
  /* Put the section footer. */
  PUT STREAM P_4GL UNFORMATTED SKIP "&ANALYZE-RESUME":U SKIP.

END PROCEDURE.

/* Put out the text for the current code section. */
PROCEDURE put-code-text:

  DEFINE PARAMETER BUFFER b_TRG FOR _TRG.
  
  IF NOT AVAILABLE b_TRG THEN RETURN.
  
  b_TRG._tOFFSET     = SEEK(P_4GL).
  IF b_TRG._tCODE ne ? THEN
    PUT STREAM P_4GL UNFORMATTED RIGHT-TRIM(b_TRG._tCODE).
  b_TRG._tOFFSET-END = SEEK(P_4GL).

  /* Output a blank line if there was anything in the section. */
  IF b_TRG._tCODE ne "":U THEN
    PUT STREAM P_4GL UNFORMATTED SKIP.
END PROCEDURE.

/* genproc.i - end of file */
