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
/* a-define.i - local definitions for admin modules */

DEFINE {1} SHARED VARIABLE qbf-fastload AS CHARACTER          NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-form-ok  AS LOGICAL            NO-UNDO.

DEFINE {1} SHARED VARIABLE qbf-a-attr   AS CHARACTER EXTENT 4 NO-UNDO.
/*
qbf-a-attr[1]= 'form-file= "customer.f"'
qbf-a-attr[2]= 'form-name= "customer"'
qbf-a-attr[3]= source of form: 'default' 'ft' 'user'
qbf-a-attr[4]= num of lines on form: 'form-lines= 15' (not counting box)
*/

/* module and query permissions */
DEFINE {1} SHARED VARIABLE qbf-m-perm AS CHARACTER EXTENT  6 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-q-perm AS CHARACTER EXTENT 18 NO-UNDO.

/* term info */
DEFINE {1} SHARED VARIABLE qbf-t-name AS CHARACTER
  EXTENT { prores/s-limtrm.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-t-hues AS CHARACTER
  EXTENT { prores/s-limtrm.i } NO-UNDO.
