/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _fldinfo.p

Description:
    Takes a database-table-field are returns the data-type and extent for it.
    This is a separate procedure because I was getting an error if I tried to
    run this code and a database was not connected (this was a run-time error;
    it happened even if it compiled properly).  Therefore, I could not reference
    DICTDB in any code that might run if no database were connected.

Input Parameters:
   p_db_name	- name of data-base
   p_tbl_name	- name of table
   p_fld_name	- name of field

Output Parameters:
   p_fld_label     - The field label
   p_fld_label_sa  - The field label string attributes
   p_fld_format    - The field format string
   p_fld_format_sa - The field format string attributes
   p_fld_type      - The field data type
   p_fld_help      - The field help_string
   p_fld_help_sa   - The field help string attributes
   p_fld_extent    - The field data extent
   p_fld_description - The field description
   p_fld_valexp	   - The field validation expression
   p_fld_valmsg	   - The field validation message
   p_fld_valmsg_sa - The field validation message string attributes
   p_fld_mandatory - The field validation expression

NOTE:  How to hook to a V6 Database.
   1) Start a V6 Server.
        a) rdl 6
        b) proserve db-name -H host-name -S demosv
          (eg. proserve ~stern/v6 -H kodiak -S demosv)    
   2) Connect to this in your V7 Session
        connect ~stern/v6 -H kodiak -S demosv         

Author: Wm.T.Wood

Date Created: January 29, 1993

Modified:
  10/25/93 wood  Deal with case that not all _field fields are available
                 in all databases.
  1/98	   slk	 Added retrieval of valExp, valMsg, mandatory info
  10/98   hd   Using a query to improve performancve over a network.  
----------------------------------------------------------------------------*/
DEFINE INPUT   PARAMETER    p_db_name       AS CHAR 		NO-UNDO.
DEFINE INPUT   PARAMETER    p_tbl_name      AS CHAR 		NO-UNDO.
DEFINE INPUT   PARAMETER    p_fld_name      AS CHAR 		NO-UNDO.

DEFINE OUTPUT  PARAMETER    p_fld_label     AS CHAR 		NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_label_sa  AS CHAR 		NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_format    AS CHAR 		NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_format_sa AS CHAR 		NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_type      AS CHAR 		NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_help      AS CHAR 		NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_help_sa   AS CHAR 		NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_extent    AS INTEGER 		NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_initial   AS CHAR             NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_description AS CHAR             NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_valexp    AS CHAR             NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_valmsg    AS CHAR             NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_valmsg_sa AS CHAR             NO-UNDO.
DEFINE OUTPUT  PARAMETER    p_fld_mandatory AS LOGICAL          NO-UNDO.

DEFINE QUERY qDb FOR DICTDB._db   FIELDS(), 
                     DICTDB._file FIELDS(), 
                     DICTDB._field. 

IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN
  OPEN QUERY qDB FOR 
    EACH DICTDB._db  
         WHERE DICTDB._db._db-name = (IF p_db_name = ldbname("DICTDB":U) THEN ? 
                                      ELSE p_db_name) 
         NO-LOCK,
    EACH DICTDB._file OF DICTDB._db 
         WHERE DICTDB._file._file-name                      = p_tbl_name 
         AND   LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0 
         NO-LOCK,
    EACH DICTDB._field OF DICTDB._file 
         WHERE _field._field-name = p_fld_name          
         NO-LOCK.
ELSE
  OPEN QUERY qDB FOR 
    EACH DICTDB._db  
         WHERE DICTDB._db._db-name = (IF p_db_name = ldbname("DICTDB":U) THEN ? 
                                      ELSE p_db_name) 
         NO-LOCK,
    EACH DICTDB._file OF DICTDB._db 
         WHERE DICTDB._file._file-name = p_tbl_name 
         NO-LOCK,
    EACH DICTDB._field OF DICTDB._file 
         WHERE _field._field-name = p_fld_name          
         NO-LOCK.

/**** To slow over a network 
/* Get the current database field */
FIND DICTDB._db WHERE DICTDB._db._db-name =
  (IF p_db_name = ldbname("DICTDB":U) THEN ? ELSE p_db_name)        NO-LOCK.
IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN
  FIND DICTDB._file OF DICTDB._db WHERE LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0 AND
                                        DICTDB._file._file-name = p_tbl_name NO-LOCK.
ELSE
  FIND DICTDB._file OF DICTDB._db WHERE DICTDB._file._file-name = p_tbl_name NO-LOCK.

FIND _field OF DICTDB._file WHERE _field._field-name = p_fld_name          NO-LOCK.
****/

GET NEXT qDB.

/* First get the fields that should be in all databases */ 
ASSIGN p_fld_label     = _field._label
       p_fld_format    = _field._format
       p_fld_type      = _field._data-type
       p_fld_help      = _field._help
       p_fld_extent    = _field._extent
       p_fld_initial   = _field._initial
       p_fld_description = _field._desc
       p_fld_valexp    = _field._valexp
       p_fld_valmsg    = _field._valmsg
       p_fld_mandatory = _field._mandatory
.

/* Now look for fields that might not be defined in all cases.  For      */
/* example, string-attributes are only available in V7 or higher.        */
/* Use CAN-FIND to determine if a database contains these values.        */
IF CAN-FIND (_field WHERE _field._field-name eq "_Label-SA":U)
THEN p_fld_label_sa  = _field._Label-SA .
IF CAN-FIND (_field WHERE _field._field-name eq "_Format-SA":U)
THEN p_fld_format_sa = _field._Format-SA .   
IF CAN-FIND (_field WHERE _field._field-name eq "_Help-SA":U)
THEN p_fld_help_sa   = _field._Help-SA .
IF CAN-FIND (_field WHERE _field._field-name eq "_Valmsg-SA":U)
THEN p_fld_valmsg_sa = _field._Valmsg-SA.

/* Special cases -- If values are unknown, then "correct" them.          */
/*      1) If db label is ? use db field name                            */
/*      2) Use "" if help or string attribute (or label) is unknown.     */
/*         That is, don't import the string attribute if the value is ?  */
IF p_fld_label  eq ? OR p_fld_label_sa eq ?  THEN p_fld_label_sa  = "".
IF p_fld_label  eq ?                         THEN p_fld_label     = p_fld_name.
IF p_fld_format eq ? OR p_fld_format_sa eq ? THEN p_fld_format_sa = "".
IF p_fld_help   eq ? OR p_fld_help_sa   eq ? THEN p_fld_help_sa   = "".
IF p_fld_help   eq ?                         THEN p_fld_help      = "".
IF p_fld_description eq ? 		     THEN p_fld_description = "".
IF p_fld_valexp eq ?                         THEN p_fld_valexp    = "".
IF p_fld_valmsg eq ? OR p_fld_valmsg_sa eq ? THEN p_fld_valmsg_sa = "".
IF p_fld_valmsg eq ?                         THEN p_fld_valmsg    = "".

