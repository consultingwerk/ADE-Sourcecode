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
File: dictvar.i
OB
Description:   
   This include file contains the definition of miscellaneous shared
   dictionary variables.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern
Date Created: 01/28/92

History:
       12/28/98 Mario B.  Add s_In_Schema_Area enabling one time notification.
       05/19/99 Mario B.  Adjust Width Field browser integration.     
       04/23/02 Donna M.  Added new table recid variable
----------------------------------------------------------------------------*/
{adecomm/adestds.i}  

/* Help context defines and the name of the help file */
{adedict/dictghlp.i}


/* We have a cache for Db info since we can't necessarily get any info
   about foreign databases unless they're connected - which they don't
   have to be.  The browse window db select list acts as the cache for
   the logical names.
*/
Define {1} var s_DbCache_ix     as integer           NO-UNDO init 0.
Define {1} var s_DbCache_Cnt    as integer    	     NO-UNDO init 0.
Define {1} var s_DbCache_Pname  as char    extent 50 NO-UNDO.
Define {1} var s_DbCache_Holder as char    extent 50 NO-UNDO.
Define {1} var s_DbCache_Type   as char    extent 50 NO-UNDO.


/* These are the current database, table, domain, sequence, field and index
   based upon the user's selection in the browse window.
*/
Define {1} var s_CurrDb   as char init "" NO-UNDO.
Define {1} var s_CurrTbl  as char init "" NO-UNDO.
Define {1} var s_CurrDom  as char init "" NO-UNDO.
Define {1} var s_CurrSeq  as char init "" NO-UNDO.
Define {1} var s_CurrFld  as char init "" NO-UNDO.
Define {1} var s_CurrIdx  as char init "" NO-UNDO.


/* s_TblRecId is the table record Id for the currently selected table.
   s_DomRecId is the record Id that domains are associated with for a given
   database and DbRecId is the recid of the _DB record for the current
   database.
*/
Define {1} var s_DbRecId   as recid    NO-UNDO.       
Define {1} var s_TblRecId  as recid    NO-UNDO.
Define {1} var s_DomRecId  as recid    NO-UNDO.
DEFINE {1} VAR n_tblRecid  AS RECID    NO-UNDO.

/* These come in handy for a bunch of things. */
&global-define    OBJ_NONE    0
&global-define    OBJ_TBL     1
&global-define    OBJ_DOM     2
&global-define    OBJ_SEQ     3
&global-define    OBJ_FLD     4
&global-define    OBJ_IDX     5
&global-define    OBJ_DB      6
&global-define    OBJ_WIDTH   7

/* These are the different "states" the dictionary can be in which are
   essentially based on what the current selection is.  They are used for
   menu graying and browse window adjustments.
   Note that each state is a step up from the previous one.
   
   NO_DB_SELECTED    - No database is selected (there are none connected)
   NO_OBJ_SELECTED   - The current database is accessible, but the user hasn't
      	       	       selected any object (tbl,dom,seq,fld,idx) yet.
      	       	       NOTE: with the current UI, this state is only temporary
      	       	       since we always select table by default once a database
      	       	       is selected.
   OBJ_SELECTED	     - The current database is accessible and there is 
      	       	       a selected object. 

   This state is special in that it doesn't participate in this state
   hierarchy.

   DONE	       	     - We are about to exit the dictionary so we're in
      	       	       a cleanup state.
*/
Define {1} var s_DictState as integer NO-UNDO.

&global-define NUM_STATES     	       4
&global-define STATE_DONE     	       0
&global-define STATE_NO_DB_SELECTED    1
&global-define STATE_NO_OBJ_SELECTED   2
&global-define STATE_OBJ_SELECTED      3

/* Gray_Items:
   This is a list of widget handles for all menu items and icon widgets
   that need graying. 
*/
&global-define  NUM_GRAY_ITEMS   34
Define {1} var Gray_Items  as widget-handle extent {&NUM_GRAY_ITEMS}  NO-UNDO.


/* This variable indicates which component at the 1st level of hierarchy 
   (TBL, SEQ) and which component at the 2nd level of hierarchy
   (FLD, IDX) is currently active, so when user does "new" we know what
   function to perform.
*/
Define {1} var s_Lvl1Obj as integer init {&OBJ_NONE} NO-UNDO.
Define {1} var s_Lvl2Obj as integer init {&OBJ_NONE} NO-UNDO.


/* CurrObj indicates what type of object is currently being added 
   or set up in one of the edit windows.  It is not always used -
   only when there is code shared between object types and we need to
   know which one we're working on right now.  This happens with fields
   and domains, and with field and table triggers, for example.
   s_Adding is true if we're adding vs. editing the object.
*/
Define {1} var s_CurrObj as integer NO-UNDO.
Define {1} var s_Adding as logical NO-UNDO.


/* This will be the name of the procedure to run to execute the
   current command. */
Define {1} var s_ActionProc as char format "x(10)" init ""  NO-UNDO.

/* s-Trans indicates what transaction action to take.
   NONE	       	  - The base state - no transaction request has been made.
   COMMIT         - Can be requested from the menu.
   UNDO           - Can be requested from the menu.
   ASK_AND_DO  	  - ask the user: commit/undo or continue.  If the user
      	            chooses commit or undo, perform some action (e.g.,
      	       	    switch databases, or disconnect a database)
   ASK_AND_EXIT   - ask the user: commit/abort or continue.  If the user
      	            chooses commit or abort, exit the dictionary.
   DONE	       	  - Used internally to control the transaction loop.
*/
&global-define 	  TRANS_NONE  	       0
&global-define 	  TRANS_COMMIT         1
&global-define 	  TRANS_UNDO           2
&global-define 	  TRANS_ASK_AND_DO     3
&global-define 	  TRANS_ASK_AND_EXIT   4
&global-define    TRANS_DONE  	       5

Define {1} var s_Trans as integer init 1 NO-UNDO.


/* ism_typ.p calls _ism_udt.p which needs drec_id to be defined
 * drec_db is the TTY-AdminTool equivalent to s_DbRecId in the GUI-Dict
 */
Define {1} var drec_db     as recid    NO-UNDO.       

/* dictg.p also includes prodict/user/uservar.i, which defines user_env,
 * so we shouldn't redefine it here
 */
&IF "{&DICTG}"  <> "dictg"
&THEN

/* user_env is Used to get gateway data type and default info.  Each array
   entry is filled with a comma separated list. There is one extra element
   in each (i.e., there's an extra comma on the end of each that shouldn't
   be there) so make sure to account for it.   user_env must be defined as
   it is in prodict/user/uservar.i (old dictionary).  s_Gate_Typ_Proc is set
   to the name of the .p (prodict/xxx/xxx_typ.p) that sets this info.

      user_env[11] - list of progress types that map to gateway types
      user_env[12] - list of gateway types (strings)
      user_env[13] - list of gateway type codes (_Fld-stdtype).
      user_env[14] - list of _Fld-stlen values for each data type (this is
      	       	     the storage length)
      user_env[15] - the long form of the gateway type (string), i.e., the
      	       	     type description.
      user_env[16] - the gateway type family - to indicate what data types
      	       	     can be modified to what other data types.
*/
Define {1} var user_env        as char  extent 35 NO-UNDO.
&ENDIF
Define {1} var s_Gate_Typ_Proc as char            NO-UNDO. 


/* These indicate whether each list box in the browse window (for tables,
   domains, etc.) already contain the correct info.  'yes' means that the
   data is already in there and the widget just needs to be made visible.
   'no' means we haven't filled the list yet for the current database.
*/
Define {1} var s_Tbls_Cached as logical init false NO-UNDO.
Define {1} var s_Doms_Cached as logical init false NO-UNDO.
Define {1} var s_Seqs_Cached as logical init false NO-UNDO.
Define {1} var s_Flds_Cached as logical init false NO-UNDO.
Define {1} var s_Idxs_Cached as logical init false NO-UNDO.


/* These are the handles for the non-modal dictionary windows */
Define {1} var s_win_Browse as widget-handle NO-UNDO.
Define {1} var s_win_Db     as widget-handle NO-UNDO.
Define {1} var s_win_Tbl    as widget-handle NO-UNDO.
Define {1} var s_win_Seq    as widget-handle NO-UNDO.
Define {1} var s_win_Fld    as widget-handle NO-UNDO.
Define {1} var s_win_Dom    as widget-handle NO-UNDO.
Define {1} var s_win_Idx    as widget-handle NO-UNDO.
Define {1} var s_win_Logo   as widget-handle NO-UNDO.
Define {1} var s_win_Width  as widget-handle NO-UNDO.

/* To remember where each window was when it was closed, so it
   can reopen in the same place.
*/
Define {1} var s_x_Win as integer extent 7 NO-UNDO init ?.
Define {1} var s_y_Win as integer extent 7 NO-UNDO init ?.


/* s_DictDirty is true if the dictionary is dirty.  This means that at least
   1 undo-able/commit-able action has been executed.
*/
Define {1} var s_DictDirty as logical NO-UNDO.


/* Read only flags - ReadOnly will be true if dictionary was entered
   while in a transaction or if the user is running certain versions of
   Progress, such as RUN-ONLY Progress.  DB_ReadOnly will be true if 
   the user chose a read-only database.  xxx_ReadOnly will take both of
   these into account and may add other qualifications (like frozen for
   tables or privileges) to indicate if the object being viewed is editable
   or not.
*/
Define {1} var s_ReadOnly     as logical NO-UNDO.
Define {1} var s_DB_ReadOnly  as logical NO-UNDO.
Define {1} var s_Tbl_ReadOnly as logical NO-UNDO.
Define {1} var s_Dom_ReadOnly as logical NO-UNDO.
Define {1} var s_Seq_ReadOnly as logical NO-UNDO.
Define {1} var s_Fld_ReadOnly as logical NO-UNDO.
Define {1} var s_Idx_ReadOnly as logical NO-UNDO.


/* This is a comma separated list of old (V5/V6) databases that we've 
   come across because they're connected but we haven't added to the 
   db list because this dictionary can't work with them.  We only want
   to make note of them to the user once.  This list keeps track of
   them so that every time we connect, we don't re-notice them and
   re-tell the user about how they can't use these databases.
*/
Define {1} var s_OldDbs as char NO-UNDO init "".


/* Miscellaneous flags and their values. Auto_Connect is turned on when
   the user creates a new database, so we know to bring up the connect
   box after the database switch happens. DbLst_Focus remember if the
   Db list has focus (instead of Db fill-in) when we switch databases.
   ask_gateconn indicates if we should ask about connecting when
   switching to a gateway database - e.g, so we don't ask if the user 
   wants to connect after just disconnecting.
*/
&global-define ORDER_ALPHA    1
&global-define ORDER_ORDER#   2
Define {1} var s_Order_By     	  as integer init {&ORDER_ORDER#} NO-UNDO.

Define {1} var s_Show_Hidden_Tbls as logical init no  	          NO-UNDO.
Define {1} var s_Auto_Connect     as logical init no  	          NO-UNDO.
Define {1} var s_Dblst_Focus      as logical init no              NO-UNDO.
Define {1} var s_ask_gateconn     as logical init yes             NO-UNDO.

/* This is used for method calls for the result status to be returned in. */
Define {1} var s_Res as logical NO-UNDO.

/* Miscellaneous constants */

/* This is stored in the _File._Db-Lang field.  0 means it is not SQL */
&global-define 	  TBLTYP_SQL  1


/* This variable controls the warning given to the user to indicate they
   are adding tables or indices to the schema area.  We only want to give
   the warning once per session
*/
Define {1} var s_In_Schema_Area as logical init no NO-UNDO.

