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
/*
* _aflend.p
*
*    Completes the end of the fastload relationship startup. Updates
*    the permissions and CRCs from the referenced table.
*
*    This function must be called before the call to run the integration
*    point function for table security.
*/

{ aderes/j-define.i }

/* First check to see if there are any aliases */
FIND FIRST qbf-rel-buf WHERE qbf-rel-buf.sid <> ? NO-ERROR.
IF NOT AVAILABLE qbf-rel-buf THEN RETURN.

FOR EACH qbf-rel-buf WHERE qbf-rel-buf.sid <> ?:
  {&FIND_TABLE2_BY_ID} qbf-rel-buf.sid.

  ASSIGN
    qbf-rel-buf.crc    = qbf-rel-buf2.crc
    qbf-rel-buf.cansee = qbf-rel-buf2.cansee
    .
END.

/* _aflend.p - end of file */

