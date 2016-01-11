&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Include
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
&IF FALSE &THEN
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------
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

 

