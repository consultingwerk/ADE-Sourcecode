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

/*---------------------------------------------------------------------------

dumpvars.i - dictionary dump utility shared variables & workfiles

Author: Mario Brunetti

Date Created: 10/04/99

-----------------------------------------------------------------------------*/

&GLOBAL-DEFINE errFileName "incrdump.e"

DEFINE {1} STREAM ddl.
DEFINE {1} STREAM err-log.  

DEFINE {1} WORKFILE missing NO-UNDO
  FIELD name AS CHARACTER INITIAL "".

DEFINE {1} WORKFILE table-list NO-UNDO
  FIELD t1-name AS CHARACTER INITIAL ""
  FIELD t2-name AS CHARACTER INITIAL ?.

DEFINE {1} WORKFILE field-list NO-UNDO
  FIELD f1-name   AS CHARACTER INITIAL ""
  FIELD f2-name   AS CHARACTER INITIAL ?.

DEFINE {1} WORKFILE seq-list NO-UNDO
  FIELD s1-name AS CHARACTER INITIAL ""
  FIELD s2-name AS CHARACTER INITIAL ?.

DEFINE {1} WORKFILE index-list NO-UNDO
  FIELD i1-name AS CHARACTER INITIAL ""
  FIELD i1-comp AS CHARACTER INITIAL ""
  FIELD i2-name AS CHARACTER INITIAL ?
  FIELD i1-i2   AS LOGICAL.

DEFINE {1} BUFFER index-alt FOR index-list.
DEFINE {1} BUFFER old-field FOR DICTDB._Field.
DEFINE {1} BUFFER new-field FOR DICTDB2._Field.

DEFINE {1} VARIABLE h_dmputil        AS HANDLE.
DEFINE {1} VARIABLE s_errorsLogged   AS LOGICAL INIT FALSE.
DEFINE {1} VARIABLE cnt              AS INT.  
