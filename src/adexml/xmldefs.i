/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-------------------------------------------------------------------------

File: src/adexml/xmldefs.i

Description: Global include file for XML Schema Mapping Tool.

Notes:
  This file includes adexml/xmlproto.i to define function prototypes.

Author:  D.M.Adams
Created: 11/02/00

---------------------------------------------------------------------------*/

/* Warn about source/target data type mismatch before mapping. */
DEFINE NEW GLOBAL SHARED VARIABLE dataTypeWarning AS LOGICAL NO-UNDO.

/* Filter B2B Conversion Functions based on consumer/producer mode. */
DEFINE NEW GLOBAL SHARED VARIABLE filterFunction  AS LOGICAL NO-UNDO.

/* Suggest (select) B2B Conversion Function when data type mismatch. */
DEFINE NEW GLOBAL SHARED VARIABLE suggestFunction AS LOGICAL NO-UNDO.

/* Define function prototypes
{ adexml/xmlproto.i }
*/

/* xmldefs.i - end of file */

