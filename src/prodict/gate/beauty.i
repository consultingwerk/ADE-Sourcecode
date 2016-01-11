/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/


/*--------------------------------------------------------------------

File: prodict/gate/beauty.i

Description:
    wrapper to ora/_ora_fix.p and odb/_odb_fix.p, which fix-up a SI
    to match an original PROGRESS-DB
    

Textual-Parameter:
    &edb-type   { ORACLE | **ODBC** | SYBASE-10 | MS SQL Server }

Output-Parameters:
    none
    
History:
    09/12/06   fernando   help id
    11/26/02   D. McMann  Added OS-DELETE for x.p
    04/13/00   D. McMann  Added long path name support
    12/13/1999 D. McMann  Added message for not being connected
    97/11      DMcMann    Added view-as dialog-box
    96/07      kkelley    Changed Field Labels and added title
    95/08      hutegger   created

                            
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

define variable l_file          as character  NO-UNDO.
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
    "MS SQL Server","MS SQL Server","ORACLE","ORACLE","SYBASE-10","SYBASE-10"
/*
        &elseif "{&edb-type}" = "**ODBC**"
            &then
  l_db-type     colon 21 label "DB Type"
    view-as radio-set horizontal radio-buttons 
    "MS SQL Server","MS SQL Server","SYBASE-10","SYBASE-10"
*/
            &endif
  "Files To Compare:" at 2
  l_file        at     2 no-label {&STDPH_EDITOR}
    view-as editor 
     &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
      	 SIZE 65 BY 4 BUFFER-LINES 4
      &ELSE 
      	 SIZE 65 BY 3 SCROLLBAR-VERTICAL
      &ENDIF     help "**all**  or   <table>,...~;<sequence>,...~;<view>,..."
  SKIP({&VM_WIDG})
  {prodict/user/userbtns.i}
  WITH FRAME l_frm_beauty ROW 5 CENTERED SIDE-LABELS
      DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
      VIEW-AS DIALOG-BOX title "Adjust Schema".
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
  l_file
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
            "and the Schema Holder before running adjust schema." SKIP
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
run prodict/gate/beauty1.p(input l_for-db, output drec_db).

assign
  user_env[25] = l_file.

case l_db-type:
  when "ORACLE" then RUN prodict/ora/_ora_fix.p.
  WHEN "MSS"    THEN RUN prodict/mss/_mss_fix.p (l_db-type).
  OTHERWISE          RUN prodict/odb/_odb_fix.p (l_db-type).
END CASE.

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
