/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
    D. McMann 04/23/03  Added check for session:schema-change
    D. McMann 06/02/03  Removed creating temporary records for MSS and ODBC
    
--------------------------------------------------------------------*/        
/*h-*/

/*----------------------------------------------------------------------*/

&if "{&sequence}" = "true" &then
  for each gate-work where gate-work.gate-slct = TRUE
                       and   gate-work.gate-type = "{&gate-type}"
            &if "{&local}" = "true" &then
                       and   gate-work.gate-prog = ?
                       and ( gate-work.gate-qual = ?
                       or    user_dbtype <> "ORACLE"):
             &else
                      and   gate-work.gate-prog = ? :
&endif

&if "{&gate-type}" = "synonym" &then
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

    /* If user has set the session parameter to do on line adds we
       can't create a temporary sequence and then delete it */

    IF SESSION:SCHEMA-CHANGE = "" AND edbtyp = "ORACLE" THEN DO:
      CREATE DICTDB._Sequence.
      ASSIGN DICTDB._Sequence._Seq-name     = gate-work.gate-prog
             DICTDB._Sequence._Db-recid     = drec_db
             DICTDB._Sequence._Seq-misc[2]  = "%TEMPORARY%".
    END.    
  END.    /* for each gate-work "_Sequence" */

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


