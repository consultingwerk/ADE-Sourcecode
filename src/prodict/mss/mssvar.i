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
    History:  D. McMann 03/03/99 Removed On-line from Informix
              D. McMann 02/01/00 Added sqlwidth variable
              D. McMann 06/18/01 Added case and collation variables
    
*/    

DEFINE {1} SHARED VARIABLE pro_dbname     AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE pro_conparms   AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE osh_dbname     AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE mss_dbname     AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE mss_pdbname    AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE mss_username   AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE mss_password   AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE mss_codepage   AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE mss_collname   AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE mss_incasesen  AS LOGICAL   NO-UNDO.
DEFINE {1} SHARED VARIABLE mss_conparms   AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE long-length    AS INTEGER   NO-UNDO.
DEFINE {1} SHARED VARIABLE movedata       AS LOGICAL   NO-UNDO.
DEFINE {1} SHARED VARIABLE pcompatible    AS LOGICAL   NO-UNDO.
DEFINE {1} SHARED VARIABLE sqlwidth       AS LOGICAL   NO-UNDO.
DEFINE {1} SHARED VARIABLE loadsql        AS LOGICAL   NO-UNDO.
DEFINE {1} SHARED VARIABLE rmvobj         AS LOGICAL   NO-UNDO.
DEFINE {1} SHARED VARIABLE shadowcol      AS LOGICAL   NO-UNDO.
DEFINE {1} SHARED VARIABLE descidx        AS LOGICAL   NO-UNDO.
DEFINE {1} SHARED VARIABLE dflt           AS LOGICAL   NO-UNDO.

DEFINE {1} SHARED STREAM dbg_stream.

DEFINE {1} SHARED VARIABLE stages 		    AS LOGICAL EXTENT 7 NO-UNDO.
DEFINE {1} SHARED VARIABLE stages_complete 	AS LOGICAL EXTENT 7 NO-UNDO.

/*
 * Constants describing stage we are at.
 */ 
define {1} shared variable mss_create_sql	  as integer   initial 1.
define {1} shared variable mss_dump_data   	  as integer   initial 2.
define {1} shared variable mss_create_sh 	  as integer   initial 3. 
define {1} shared variable mss_create_objects as integer   initial 4.
define {1} shared variable mss_build_schema	  as integer   initial 5.
define {1} shared variable mss_fixup_schema	  as integer   initial 6.
define {1} shared variable mss_load_data	  as integer   initial 7. 
define {1} shared variable s_file-sel         as character initial "*". 



