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

