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

/*--------------------------------------------------------------------

File: prodict/gate/gat_getd.i

Description:
    
    generate unique names for new objects in gate-work
        
Text-Parameters:
    &gate-type  "synonym" | "sequence" | ""
    &local      "true"    | "false"
    &sequence   "true"    | "false"


Included in:
    gate/gat_get.i

History:
    hutegger    96/04   creation
    
--------------------------------------------------------------------*/        
/*h-*/

/*----------------------------------------------------------------------*/


            &if "{&sequence}" = "true"
             &then

  for each gate-work
    where gate-work.gate-slct = TRUE
    and   gate-work.gate-type = "{&gate-type}"
            &if "{&local}" = "true"
             &then
    and   gate-work.gate-prog = ?
    and ( gate-work.gate-qual = ?
    or    user_dbtype <> "ORACLE"):
             &else
    and   gate-work.gate-prog = ? :
             &endif

            &if "{&gate-type}" = "synonym"
             &then
    if num-entries(gate-work.gate-edit,":") < 2
     or entry(3,gate-work.gate-edit,":")   <> "SEQUENCE"
     then next.
             &endif

    assign gate-work.gate-prog = gate-work.gate-name.

    /* In order to keep from assigning duplicate default names in
     * the event identical foreign names (for different userids) exist,
     * create dummy _file records long enough to assign all necessary
     * Progress names.  Yes, this is a hack.
     */
    
    RUN prodict/gate/_gat_fnm.p
      ( INPUT        "SEQUENCE"
      , INPUT        drec_db
      , INPUT-OUTPUT gate-work.gate-prog
      ).
    create DICTDB._Sequence.
    assign
      DICTDB._Sequence._Seq-name     = gate-work.gate-prog
      DICTDB._Sequence._Db-recid     = drec_db
      DICTDB._Sequence._Seq-misc[2]  = "%TEMPORARY%".

     
    end.    /* for each gate-work "_Sequence" */

             &else

  for each gate-work
    where gate-work.gate-slct = TRUE
            &if "{&local}" = "true"
             &then
    and   gate-work.gate-prog = ?
    and ( gate-work.gate-qual = ?
    or    user_dbtype <> "ORACLE"):
             &else
    and   gate-work.gate-prog = ? :
             &endif

            &if "{&gate-type}" = "synonym"
             &then
    if num-entries(gate-work.gate-edit,":") < 2
     or entry(3,gate-work.gate-edit,":")    = "SEQUENCE"
     then next.
             &endif

    assign gate-work.gate-prog = gate-work.gate-name.

    RUN prodict/gate/_gat_fnm.p
      ( INPUT        "TABLE"
      , INPUT        drec_db
      , INPUT-OUTPUT gate-work.gate-prog
      ).

    create DICTDB._File.
    assign
      DICTDB._File._File-name = gate-work.gate-prog
      DICTDB._File._Db-recid  = drec_db
      DICTDB._File._For-type  = "TEMPORARY".

    end.    /* for each gate-work "_File" */

             &endif

/*------------------------------------------------------------------*/


