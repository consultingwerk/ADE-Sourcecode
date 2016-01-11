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
/*----------------------------------------------------------------------------

File: _fldlbl.p

Description:
    Takes a database-table-field are returns the label for that field.  
    If the frame is not side-labels, then we look for the column label.

Input Parameters:
   p_db_name     - name of data-base
   p_tbl_name    - name of table
   p_fld_name    - name of field (can include the INDEX), eg. "sales[3]".
   p_side_labels - TRUE if frame has side-labels.

Output Parameters:
   p_fld_label     - The field label
   p_fld_label_sa  - The field label string attributes

NOTE:  How to hook to a V6 Database.
   1) Start a V6 Server.
        a) rdl 6
        b) proserve db-name -H host-name -S demosv
          (eg. proserve ~stern/v6 -H kodiak -S demosv)    
   2) Connect to this in your V7 Session
        connect ~stern/v6 -H kodiak -S demosv         

Author: Wm.T.Wood

Date Created: June 30, 1993

Modified:
  03/28/94 wood  Deal with case where p_fld_name can contain the index
  10/25/93 wood  Deal with case that not all _field fields are available
                 in all databases.

----------------------------------------------------------------------------*/
DEFINE INPUT   PARAMETER    p_db_name       AS CHAR             NO-UNDO.
DEFINE INPUT   PARAMETER    p_tbl_name      AS CHAR             NO-UNDO.
DEFINE INPUT   PARAMETER    p_fld_name      AS CHAR             NO-UNDO.
DEFINE INPUT   PARAMETER    p_side_labels   AS LOGICAL          NO-UNDO.

DEFINE OUTPUT  PARAMETER    p_fld_label     AS CHAR             NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_label_sa  AS CHAR             NO-UNDO.

DEFINE VAR fld_index AS CHAR NO-UNDO.

/* Did the user return an array element? If so, parse it for the
   variable (p_fld_save) and the array index (fld_index). 
   eg. "var[6]" becomes "var" and "[6]".
   We do this so that we can add the index back onto the label. */
IF (p_fld_name MATCHES ("*[*]"))
THEN ASSIGN fld_index  = "[":U + ENTRY(2,p_fld_name,"[":U)
            p_fld_name = ENTRY(1,p_fld_name,"[":U).

/* Get the current database field */
FIND DICTDB._db WHERE DICTDB._db._db-name =
  (IF p_db_name = ldbname("DICTDB") THEN ? ELSE p_db_name)          NO-LOCK.
IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN
  FIND DICTDB._file OF _db WHERE LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0 AND
                                        DICTDB._file._file-name = p_tbl_name NO-LOCK.
ELSE
  FIND DICTDB._file OF _db WHERE DICTDB._file._file-name = p_tbl_name NO-LOCK.

FIND _field OF _file WHERE _field._field-name = p_fld_name          NO-LOCK.

/* Now look for fields. Not all fields are defined in all cases.  For    */
/* example, string-attributes are only available in V7 or higher.        */
/* Use CAN-FIND to see that we have the correct version.                  */
p_fld_label = ?.
IF NOT p_side_labels THEN DO:
  p_fld_label    = _field._Col-Label + fld_index.
  IF CAN-FIND(_field WHERE _field._field-name eq "_Col-Label-SA":U)
  THEN p_fld_label_sa = _field._Col-Label-SA . 
END.
/* If the label is still unknown then get the label */
IF p_fld_label eq ? THEN DO:
  p_fld_label    = _field._Label + fld_index.
  IF CAN-FIND(_field WHERE _field._field-name eq "_Label-SA":U)
  THEN p_fld_label_sa = _field._Label-SA.
END.

/* Special cases -- If values are unknown, then "correct" them.  */
/*      1) If db label is ? use db field name                    */
/*      2) Use "" if string attribute (or label) is unknown      */
IF p_fld_label eq ? OR p_fld_label_sa eq ? THEN p_fld_label_sa  = "".
IF p_fld_label eq ?                        THEN p_fld_label     = p_fld_name.
    
      
