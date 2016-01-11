/***********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights      *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/


/*--------------------------------------------------------------------

File: prodict/mss/genrowid.i

Description:
    wrapper to adedict/KEY/genrowid.p, which fix-up an original PROGRESS-DB
    to add _constraints based on ROWID's selected in MSS SI
    

Textual-Parameter:
    &edb-type   { MS SQL Server }

Output-Parameters:
    none
    
History:
    06/11   ashukla   created

                            
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

define variable l_overwrite     as logical   INIT NO NO-UNDO.
define variable l_file          as character NO-UNDO.
define variable l_for-db        as character format "x(12)" NO-UNDO.
define variable l_pro-db        as character format "x(12)" NO-UNDO.
define variable l_db-type       as character format "x(20)" NO-UNDO.

{ prodict/dictvar.i }
{ prodict/user/uservar.i }


                /*## UI-Part ##*/
form
  SKIP ({&TFM_WID})
  l_pro-db      colon 22 label "Original {&PRO_DISPLAY_NAME} DB" FORMAT "x({&PATH_WIDG})"
    VIEW-AS FILL-IN SIZE 40 BY 1
    help "Name of the original {&PRO_DISPLAY_NAME} DB"  {&STDPH_FILL}  SKIP ({&VM_WID})
  l_for-db      colon 22 label "Schema Image"
    help "Name of the SI to fix-up to match the {&PRO_DISPLAY_NAME} DB"
       {&STDPH_FILL}  SKIP ({&VM_WID})

   &if "{&edb-type}" = " "
            &then
      l_db-type     colon 22 label "DB Type"
        view-as radio-set horizontal radio-buttons 
    "MS SQL Server","MS SQL Server","ORACLE","ORACLE" 
            &endif
  l_overwrite LABEL "Overwrite existing constraints."  view-as TOGGLE-BOX
                  at 2  skip({&VM_WIDG})
  {prodict/user/userbtns.i}
  WITH FRAME l_frm_beauty ROW 5 CENTERED SIDE-LABELS
      DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
      VIEW-AS DIALOG-BOX title "Generate Constraints from ROWID".
                /*## UI-Part ##*/

/*===============================Triggers==================================*/
 
  /*----- HELP -----*/
&IF "{&WINDOW-SYSTEM}" <> "TTY"
 &THEN
  on HELP of frame l_frm_beauty OR CHOOSE of btn_Help in frame l_frm_beauty
     RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                 	     	     INPUT {&Adjust_Schema_dialog_box},
        	       	     	     INPUT ?).
&ENDIF


ON WINDOW-CLOSE OF FRAME l_frm_beauty
DO:
    APPLY "END-ERROR" TO FRAME l_frm_beauty.
END.
  
/*------------------------  INT.-PROCEDURES  -----------------------*/

/*------------------------  INITIALIZATIONS  -----------------------*/

/* format of l_file:
 *  { **all** 
 *  | { <comma-separated list of tables> | **all** } ; 
 *    { <comma-separated list of sequences> | **all** } ;
 *    { <comma-separated list of views> | **all** } 
 *  }
 */

assign
  l_file    = "**all**"
        &if "{&edb-type}" = "**ODBC**"
            &then
  l_db-type = entry(lookup(user_env[22],"mss,s10")
                   ,"MS SQL Server,SYBASE-10")
            &else
  l_db-type = "{&edb-type}"
            &endif
  l_for-db  = user_dbname
  l_pro-db  = ( if   ldbname("DICTDB2") <> ?
                 and dbtype ("DICTDB2") =  "PROGRESS"
                  then ldbname("DICTDB2")
                  else ?
              )
  .

/*---------------------------  MAIN-CODE  --------------------------*/
{adecomm/okrun.i  
  &FRAME  = "FRAME l_frm_beauty " 
  &BOX    = "rect_Btns"
  &OK     = "btn_OK" 
  {&CAN_BTN}
  {&HLP_BTN}
}
                /*## UI-Part ##*/
update
  l_pro-db
  l_for-db
        &if "{&edb-type}" = " "
            &then
  l_db-type
            &endif
  l_overwrite
  btn_OK
  btn_Cancel
   {&HLP_BTN_NAME}
  with frame l_frm_beauty.
                /*## UI-Part ##*/

if LDBNAME("DICTDB2") <> l_pro-db
 then do:
  create alias DICTDB2 for database value(l_pro-db) no-error.
  end.

if LDBNAME("DICTDB") <> SDBNAME(l_for-db)
 then do:
  create alias DICTDB for database value(sdbname(l_for-db)) no-error.
  end.

if LDBNAME("DICTDB2") = ?
 or ldbname("DICTDB") = ?
 then do:
    MESSAGE "You must be connected to both the Original {&PRO_DISPLAY_NAME} Database" SKIP
            "and the Schema Holder before running this option." SKIP
    VIEW-AS ALERT-BOX.
    leave.
END.
if LDBNAME("DICTDB2") = LDBNAME("DICTDB")
then do:
   message "The Original {&PRO_DISPLAY_NAME} DB cannot be the same as" skip
           "the Schema Image DB."
           view-as alert-box.
   undo,retry.
end.

/* This routine returns the recid of the foreign database.  We do not want to
   reference the database directly here because the schema will be cached and
   we will not see the modifications that have been made the the adjust
   schema routine.
*/
run prodict/gate/beauty1.p(input l_pro-db, output drec_db).
assign
  user_env[25] = l_file.

ASSIGN l_overwrite      = (l_overwrite:SCREEN-VALUE IN FRAME l_frm_beauty = "yes").

RUN adedict/KEY/genrowid.p (l_db-type, l_overwrite ).

/* in order to get the schema-chache recreated we switch the alias */
create alias DICTDB for database value(l_pro-db).
/* if this is not enough, we need to actually call some routine
 * that uses the alias?
 */
/**/
 output to x.p.
 put "for each DICTDB._File: end.".
 output close.
 run x.p.
/**/
create alias DICTDB for database value(sdbname(l_for-db)).
run x.p.

OS-DELETE x.p. 
/*--------------------------------------------------------------------*/
