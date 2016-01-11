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
/*-------------------------------------------------------------------------

File: src/web/method/e4gl.i

Description: include file for all E4GL generated Web objects

Notes: 

Author: B.Burton

Created: 01/23/97

---------------------------------------------------------------------------*/

{src/web/method/cgidefs.i}
{src/web/method/admweb.i}

/* Define preprocessors so the entities &amp~;, &quot~;, &lt; and &gt; can
   be used in the 4GL character strings between tags.  The actual values
   cannot be used because the entity names are replaced by e4gl-gen.p with
   their respective values &, ", < and >.  This is an issue because many HTML
   authoring tools may convert the literal characters &, ", < and > to their
   respective entities.

   These definitions are not quoted so they can be used in character strings
   along with other text.  */
&GLOBAL-DEFINE AMP  &amp~;
&GLOBAL-DEFINE QUOT &quot~;
&GLOBAL-DEFINE LT   &lt~;
&GLOBAL-DEFINE GT   &gt~;
&GLOBAL-DEFINE PCT  %

DEFINE VARIABLE e4gl-version            AS DECIMAL   NO-UNDO.
DEFINE VARIABLE e4gl-options            AS CHARACTER NO-UNDO.
DEFINE VARIABLE e4gl-content-type       AS CHARACTER NO-UNDO.

/* Get options from the Web object including this file. */
RUN local-e4gl-options IN THIS-PROCEDURE
                       (OUTPUT e4gl-version,
                        OUTPUT e4gl-options,
                        OUTPUT e4gl-content-type).

/* Check for an "output-headers" procedure in this Web object.  If found, then
   run it.  This allows an application to output any special headers like 
   Cookies or do other special checks before the output is sent.   We should 
   also look for an "output-header" procedure, since it's named that way in the
   pre-V9/3  HTML Mapping template. Oh, well... */
IF THIS-PROCEDURE:GET-SIGNATURE("output-header":U) BEGINS "PROCEDURE":U 
THEN DO:
  RUN output-header IN THIS-PROCEDURE NO-ERROR.
  /* If an error status is raised, then return without outputting anything. */
  IF ERROR-STATUS:ERROR THEN RETURN.
END.
ELSE
IF THIS-PROCEDURE:GET-SIGNATURE("output-headers":U) BEGINS "PROCEDURE":U 
THEN DO:
  RUN output-headers IN THIS-PROCEDURE NO-ERROR.
  /* If an error status is raised, then return without outputting anything. */
  IF ERROR-STATUS:ERROR THEN RETURN.
END.

/* Unless the "no-content-type" option was specified, output a Content-Type:
   header with text/html or whatever value was found in the
   <META HTTP-EQUIV="Content-Type" ...> tag. */
IF NOT CAN-DO(e4gl-options, "no-content-type":U) THEN
  output-content-type(e4gl-content-type).

/* end */
