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

/* ora_ctl.i - Oracle schema control settings */
/*
Note 'NULLZERO':
  There is a problem in Oracle where it treats zero-length character
  fields as NULL values.  To work around this, there is a variable
  called 'nullzero'.  Set this to TRUE if the problem exists, and
  FALSE if "" <> ?.  (Currently set to TRUE for ORACLE 5.1.)

Note 'DATETIME':
  Oracle has a datatype called DATE which is a combination of
  Progress DATE and TIME (INTEGER) fields.  When we extract it, we
  can treat it either as a Progress DATE, a Progress INTEGER, or a
  set of two Progress fields which the gateway merges into one Oracle
  DATE.  The 'datetime' variable is set on the fly when the
  verification code detects this situation.  'TRUE' means
  date/integer fields for the date exist, 'FALSE' means one or the
  other exists, and '?' means the field is not an Oracle DATE field
  or is missing.

Note 'CANDORAW':
  Currently, Progress partially supports RAW and LONG_RAW Oracle
  datatypes.  This is because they can have embedded NULLs (0x00), and
  the Progress language assumes null-terminated strings.  If 'candoraw'
  (can-do-raw) is set to TRUE, this program will treat RAW and LONG_RAW
  datatypes as Progress CHARACTER datatypes.

Note 'TALLOWED':
  This is a list of object types that the gateway supports.  Currently,
  VIEW and TABLE are allowed.  The complete list is:
  "NEXT OBJECT,INDEX,TABLE,CLUSTER,VIEW,SYNONYM,SEQUENCE,UNDEFINED".

Note 'OOBJECTS':
  This contains a list of Oracle objects.  Oracle's obj#.type + 1 can
  be used as an index to this table.
*/

DEFINE VARIABLE nullzero AS LOGICAL   NO-UNDO.
DEFINE VARIABLE datetime AS LOGICAL   NO-UNDO.
DEFINE VARIABLE candoraw AS LOGICAL   NO-UNDO.
DEFINE VARIABLE tallowed AS CHARACTER NO-UNDO.
DEFINE VARIABLE oobjects AS CHARACTER NO-UNDO.

/*
IF "{1}" = "5" THEN ASSIGN
  candoraw = TRUE
  nullzero = TRUE
  oobjects = ? /* not applicable to O/V5 */
  tallowed = "TABLE,VIEW".
*/

IF "{1}" = "6" THEN ASSIGN
  candoraw = TRUE
  nullzero = TRUE /* this may be okay as false */
  oobjects = "NEXT OBJECT,INDEX,TABLE,CLUSTER,VIEW,SYNONYM,SEQUENCE,"
           + "UNDEFINED"
  tallowed = "TABLE,VIEW,SEQUENCE".


ELSE IF "{1}" = "7" THEN ASSIGN
  candoraw = TRUE
  nullzero = TRUE /* this may be okay as false */
  oobjects = "NEXT OBJECT,INDEX,TABLE,CLUSTER,VIEW,SYNONYM,SEQUENCE,"
           + "PROCEDURE,FUNCTION,PACKAGE,PKG BODY,UNDEFINED,TRIGGER,"
           + "UNDEFINED,UNDEFINED,UNDEFINED,UNDEFINED,UNDEFINED,BUFFER"
  tallowed = "TABLE,VIEW,SYNONYM,SEQUENCE,PROCEDURE,FUNCTION,PACKAGE,"
           + "BUFFER".


ELSE IF "{1}" = "8" THEN ASSIGN
  candoraw = TRUE
  nullzero = TRUE /* this may be okay as false */
  oobjects = "NEXT OBJECT,INDEX,TABLE,CLUSTER,VIEW,SYNONYM,SEQUENCE,"
           + "PROCEDURE,FUNCTION,PACKAGE,PKG BODY,UNDEFINED,TRIGGER,"
           + "UNDEFINED,UNDEFINED,UNDEFINED,UNDEFINED,UNDEFINED,BUFFER"
  tallowed = "TABLE,VIEW,SYNONYM,SEQUENCE,PROCEDURE,FUNCTION,PACKAGE,"
           + "BUFFER".
/*
 *  oobjects = "NEXT OBJECT,INDEX,TABLE,CLUSTER,VIEW,SYNONYM,SEQUENCE,"
 *           + "PROCEDURE,FUNCTION,PACKAGE,PKG BODY,UNDEFINED,TRIGGER" 
 *  tallowed = "TABLE,VIEW,SEQUENCE". 
 */



