/************************************************************************
* Copyright (C) 2000,2005 by Progress Software Corporation.  All rights *
* reserved.  Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                              *
************************************************************************/
/*----------------------------------------------------------------------------

File: _datatyp.p

Description:
    Return a progress datatype given an integer value
    Integer value is assumed to be the same code used in the _dtype field
    in the schema.

    Returns blank if integer is not a known integer value

Parameter:
   INPUT 	dType	        INTEGER
   OUTPUT 	dataType	CHARACTER
   
Author: SLK
Date Created: 08/11/98
Copied integer values from getDataSignature in adm2/browser.p

----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pi_dType          AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pc_dataType       AS CHARACTER NO-UNDO.

CASE pi_dType:
   WHEN  1 THEN pc_dataType = 'CHARACTER':U .
   WHEN  2 THEN pc_dataType = 'DATE':U .
   WHEN  3 THEN pc_dataType = 'LOGICAL':U .
   WHEN  4 THEN pc_dataType = 'INTEGER':U .
   WHEN  5 THEN pc_dataType = 'DECIMAL':U .
      /* Note: Float/Double reserved for possible future use. */
   WHEN  6 THEN pc_dataType = 'DOUBLE':U. /* FLOAT */
   WHEN  7 THEN pc_dataType = 'RECID':U .
   WHEN  8 THEN pc_dataType = 'RAW':U .
   WHEN  9 THEN pc_dataType = 'ROWID':U .
   WHEN 18 THEN pc_dataType = 'BLOB':U .
   WHEN 19 THEN pc_dataType = 'CLOB':U .
   WHEN 34 THEN pc_dataType = 'DATETIME':U .
   WHEN 40 THEN pc_dataType = 'DATETIME-TZ':U .
   WHEN 41 THEN pc_dataType = 'INT64':U .
   WHEN  0 THEN pc_dataType = '':U .
   OTHERWISE    pc_dataType = '':U.
END CASE.
