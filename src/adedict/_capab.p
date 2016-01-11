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

File: _capab.p

Description:
   Return the set of capabilities for a particular category and gateway
   (the gateway type of the current database).
 
Input Parameters:
   p_Category  - The capability category (e.g, &CAPAB_TBL).

Output Parameters:
   p_Var       - The variable to store the capability string in.

Author: Laura Stern

Date Created: 06/05/92

History:
    99/08/02    D. McMann   added sequence support for AS/400
    98/06/29    D. McMann   added delete sequence capability for Oracle
    94/12/06    gfs         added add table for odbc
    94/08/12    hutegger    added uniqueness-changable for ora,syb & rdb
    94/01/27    hutegger    added sequence-capab's

----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}
{adedict/capab.i}

Define INPUT   PARAMETER p_Category as integer  NO-UNDO.
Define OUTPUT  PARAMETER p_Var      as char     NO-UNDO.

/*
   Capabilities are retrieved by extracting the corresponding entry
   in the xxx_capab string (a comma separated list).

   Category:
   1 - Table capabilities (&CAPAB_TBL)
      a = CAPAB_ADD  	      	 (can add)
      n = CAPAB_FOR_NAME  	 (has foreign name)
      f = CAPAB_CHANGE_FOR_NAME  (can change foreign name)
      r = CAPAB_RENAME	      	 (can rename)
      o = CAPAB_OWNER	      	 (has owner name)
      # = CAPAB_TBL_NUMBER       (has table number)
      s = CAPAB_TBL_SIZE	 (has table size)
      z = CAPAB_CHANGE_TBL_SIZE  (can change table size)
      t = CAPAB_TBL_TYPE_ADD     (can set table type on add)
      m = CAPAB_TBL_TYPE_MOD     (can change table type)

   2 - Field capabilities (&CAPAB_FLD)
      a = CAPAB_ADD  	      	 (can add)
      c = CAPAB_COPY 	      	 (can copy)
      t = CAPAB_CHANGE_DATA_TYPE (can change data type)
      e = CAPAB_CHANGE_EXTENT    (can change extent (when not in index))
      l = CAPAB_OFFLEN_REQ       (offset and length required)
      d = CAPAB_DECIMALS_REQ     (decimals required)
      s = CAPAB_CHAR_LEN_IN_DEC  (store character length in _Decimals field)
      m = CAPAB_CHANGE_MANDATORY (can set/change mandatory)
      v = CAPAB_CHANGE_CASE_SENS (can set/change case sensitivity)

   3 - Index capabilities (&CAPAB_IDX)
      a = CAPAB_ADD  	      	 (can add)
      d = CAPAB_DELETE	      	 (can delete)
      i = CAPAB_INACTIVATE    	 (can inactivate)
      p = CAPAB_CHANGE_PRIMARY	 (can change primary)
      w = CAPAB_WORD_INDEX    	 (word index allowed)
      f = CAPAB_FIELD_COMP    	 (field components as opposed to pos/offset)
      u = CAPAB_CHANGE_UNIQ      (can change uniqueness)
      # = CAPAB_GATE_IDXNUM      (call gateway specific routine to get index #)

   4 - Index; max # of components (&CAPAB_IDXMAX)

   5 - Sequence capabilities (&CAPAB_SEQ)
      a = CAPAB_ADD  	      	 (can add)
      d = CAPAB_DELETE           (can delete)
      m = CAPAB_MODIFY  	 (can modify anything beyond name)
      n = CAPAB_FOR_NAME  	 (has foreign name)
      o = CAPAB_OWNER	      	 (has owner name)
      r = CAPAB_RENAME	      	 (can rename)
      s = CAPAB_SEQ_SUPPORTED  	 (on that DataServer)
*/
         
Define var odbtyp   	  as char                                         NO-UNDO.
Define var pro_capab 	  as char init "ar#    ,acmv   ,adfipw,16,admrs"  NO-UNDO.
Define var rms_capab 	  as char init "nfors  ,actelds,f     ,64,     "  NO-UNDO.
Define var rdb_capab 	  as char init "nrs    ,t      ,fpu   ,16,     "  NO-UNDO.
Define var cisam_capab 	  as char init "nfrs   ,actelds,      , 8,     "  NO-UNDO.
Define var netisam_capab  as char init "nfrs   ,actelds,      , 8,     "  NO-UNDO.
Define var oracle_capab   as char init "nor    ,tsm    ,adfpu#,16,dnors"  NO-UNDO.
Define var sybase_capab   as char init "nor    ,mv     ,adfpu#,16,     "  NO-UNDO.
Define var as400_capab 	  as char init "nr     ,ldm    ,f     ,64,ds   "  NO-UNDO.
Define var ctosisam_capab as char init "anfrsz ,actlds ,adp   ,16,     "  NO-UNDO.
Define var odb_capab      as char init "anro    ,tdm    ,adfpu#,16,dnors"  NO-UNDO.


/*-----------------------------------------------------------------------*/

Define var idx as integer NO-UNDO.

case (s_DbCache_Type[s_DbCache_ix]):
   when "RDB" then assign
      p_Var  = ENTRY(p_Category, rdb_capab).
   when "ORACLE" then assign
      p_Var  = ENTRY(p_Category, oracle_capab).
   when "SYBASE" then assign
      p_Var  = ENTRY(p_Category, sybase_capab).
   when "RMS" then assign
      p_Var  = ENTRY(p_Category, rms_capab).
   when "CISAM" then assign
      p_Var  = ENTRY(p_Category, cisam_capab).
   when "NETISAM" then assign
      p_Var  = ENTRY(p_Category, netisam_capab).
   when "AS400" then assign
      p_Var  = ENTRY(p_Category, as400_capab).
   when "CTOSISAM" then assign
      p_Var  = ENTRY(p_Category, ctosisam_capab).
   otherwise assign 
      odbtyp = { adecomm/ds_type.i
                   &direction = "ODBC"
                   &from-type = "odbtyp"
                   }
      p_Var  = ( if can-do(odbtyp,s_DbCache_Type[s_DbCache_ix])
                   then ENTRY(p_Category, odb_capab)
                   else ENTRY(p_Category, pro_capab)
                   ).
end case.

assign p_Var = TRIM(p_Var).
