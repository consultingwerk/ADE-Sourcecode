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

Date Created: 1997

Date Modified:

---------------------------------------------------------------------------- */

/* ************************************************************************* */
/*                                                                           */
/*             COMMON PROCEDURES FOR SAVING CODE SECTIONS, ETC.              */
/*                                                                           */
/* ************************************************************************* */

  
/* Put out the code section for the current _code record. 
   If this is a structured section, you should use
   put-structured-section. This just regurgitates the
   header and footer information around the test. */
PROCEDURE put-code-section: 
  /* Save the section as is --- this way we won't loose anything that
     we are not prepared to handle. */
  PUT STREAM P_4GL UNFORMATTED _code._header. 
  RUN put-code-text.
  PUT STREAM P_4GL UNFORMATTED _code._footer.
END PROCEDURE.  

/* Put out the code section for the current _code record. This section
   is surrounded by an &ANALYZE-SUSPEND...&ANALYZE-RESUME block.  Note
   that the name is quoted and encoded if necessary. The inverse process
   is done in workshop/_cdread.p.  */
PROCEDURE put-structured-section: 
  DEF VAR qname AS CHAR NO-UNDO.
  /* See if the name needs quoting. */  
  qname = TRIM(_code._name).
  IF INDEX(qname, ' ':U) > 0 OR INDEX(qname, '"':U) > 0 
  THEN qname = '"':U + REPLACE(qname, '"':U, '&quot~;') + '"':U.
  
  /* Place the section header for the section. Note that _HIDDEN and internal
     _WORKSHOP sections don't have the "_CODE-BLOCK" leader. */
  PUT STREAM P_4GL UNFORMATTED
      "&ANALYZE-SUSPEND "
      (IF LOOKUP(_code._section, "_HIDDEN,_WORKSHOP":U) > 1 THEN "":U 
       ELSE "_CODE-BLOCK ")
       _code._section " " qname " " _code._special 
       SKIP.
  /* Put the code text. */
  RUN put-code-text.  
  /* Put the section footer. */
  PUT STREAM P_4GL UNFORMATTED SKIP "&ANALYZE-RESUME" SKIP.

END PROCEDURE.

/* Put out the text for the current code section. */
PROCEDURE put-code-text: 
  DEFINE VARIABLE next-id LIKE _code-text._next-id NO-UNDO.  
  
  /* Store the offsets of the current section. */
  _code._offset = SEEK(P_4GL). 
  /* Get all the code segments. */
  next-id = _code._text-id.
  DO WHILE next-id ne ?:        
    /* Get the code section and figure out the next one. */
    FIND _code-text WHERE RECID(_code-text) eq next-id NO-ERROR.   
    next-id = _code-text._next-id.
    /* Remove trailing blanks on the last section of files build in
       webspeed. */
    IF next-id eq ? THEN _code-text._text = RIGHT-TRIM(_code-text._text).
    /* Output this block. */
    PUT STREAM P_4GL UNFORMATTED _code-text._text.
  END.
  _code._offset-end = SEEK(P_4GL).
   
  /* Output a blank line if there was anything in the section. */
  IF AVAILABLE(_code-text) AND _code-text._text ne "":U
  THEN PUT STREAM P_4GL UNFORMATTED SKIP.

END PROCEDURE.

/* 
 * ---- End of file ----- 
 */
