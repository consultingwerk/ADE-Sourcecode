/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _tblbrws.p

Description:
   Browse the tables for a given database. This database must
   be aliased to DICTDB before this routine is called.  If the database
   is a foreign database, the schema holder database must have this alias.
   This procedure must be run persistently.
   
Input Parameters: (for the calling programs)
   p_dlg       - Frame handle needed to parent the frame created in this 
                 procedure.
   parent-proc - Handle of the calling dialog so that we can run its
                 internal procedures (methods).
   p_multi     - Logical: True if multiple items can be returned.
   p_rw        - The row of the browse within its parent (p_dlg).
   p_tc        - The column of the brwose within its parent (p_dlg).
   p_DbId      - The recid of the _Db record which corresponds to the
                 database that we want the tables from.
   p_Filters   - Comma delimited character string with with things (like
                 Sybase Buffers) that should be filtered out.
   in-value    - Comma delimited list of tables to select initially
             
Output Parameters:
   h_tbl_brws - Handle of browse created in this routine.
   p_Stat     - Set to true if list is retrieved (even if there were no tables
      	         this is successful).  Set to false, if user doesn't have access
      	         to tables.

Author: Ross Hunter

Date Created: 08/08/95 

----------------------------------------------------------------------------*/
{adecomm/_adetool.i} /* Identify this procedure as part of the ADE */

{adecomm/tblbrws.i &HGHT = "6.9" &WDTH = "25" &FLDS = "NO"}

/* _tblbrws.p - end of file */

