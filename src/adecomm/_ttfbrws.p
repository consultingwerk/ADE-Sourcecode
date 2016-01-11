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

File: _tfbrws.p

Description:
   Browse the tables and fields for a given database. This database must
   be aliased to DICTDB before this routine is called.  If the database
   is a foreign database, the schema holder database must have this alias.
   This procedure must be run persistently.

Input Parameters:
   p_dlg       - Frame handle needed to parent the frame created in this 
                 procedure.
   parent-proc - Handle of the calling dialog so that we can run its
                 internal procedures (methods).
   p_multi     - Logical: True if multiple items can be returned.
   p_rw        - The row of the browse within its parent (p_dlg).
   p_tc        - The column of the brwose within its parent (p_dlg).
   p_DbId      - The recid of the _Db record which corresponds to the
                 database that we want the tables from.
   in-value    - Comma delimited list of tables to select initially
   p_DType     - ? if not a specific data-type
             
Output Parameters:
   h_tbl_brws - Handle of table browse created in this routine.
   h_fld_brws - Handle of field browse created in this routine.
   p_Stat     - Set to true if list is retrieved (even if there were no tables
      	         this is successful).  Set to false, if user doesn't have access
      	         to tables.

Author: Ross Hunter

Date Created: 11/01/96

----------------------------------------------------------------------------*/
{adecomm/_adetool.i} /* Identify this procedure as part of the ADE */
{adecomm/tt-brws.i}  /* Temp-tables to browse                      */

{adecomm/ttblbrws.i &HGHT = "6.9" &WDTH = "18.5"  &FLDS = "YES"}

/* _ttfbrws.p - end of file */

