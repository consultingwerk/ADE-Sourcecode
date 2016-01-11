&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Include
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
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
&IF FALSE &THEN
/*----------------------------------------------------------------------
    File        : util4gl.i
    Purpose     : Contains 4GL utility functions for encoding/decoding
                  strings for file saving/loading.
    Author(s)   : Wm.T.Wood
    Created     : April 22, 1997
    Notes       : Used in workshop: _genrt.p, _readrt.p, _gendefs.p etc.
----------------------------------------------------------------------*/
/*           This file was created with WebSpeed Workshop.            */
/*--------------------------------------------------------------------*/
&ENDIF

/* Function to 4gl-encode a string. Use this around any string we are
   planning on saving. */
FUNCTION 4gl-encode RETURNS CHARACTER (INPUT p_string AS CHAR) :
  RETURN REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                p_string , "~~":U, "~~~~":U), 
                           "~"":U, "~~~"":U),
                           "~\":U, "~~~\":U),
                           "~{":U, "~~~{":U),
                           "~;":U, "~~~;":U).
END FUNCTION.

/* Function to 4gl-decode a string. Use this to load a string that
   has been 4GL-encoded */
FUNCTION 4gl-decode RETURNS CHARACTER (INPUT p_string AS CHAR) :
  RETURN REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                p_string , "~~~~":U, "~~":U),
                           "~~~"":U, "~"":U),
                           "~~~\":U, "~\":U),
                           "~~~{":U, "~{":U),
                           "~~~;":U, "~;":U).
END FUNCTION.
&ANALYZE-RESUME
/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

 

