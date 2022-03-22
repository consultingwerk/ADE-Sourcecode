/*********************************************************************
* Copyright (C) 2006,2008-2009 by Progress Software Corporation. All *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: prodict/gui/guigget.i


Description:   
   Select one or more objects from the list of records in the gatework
   temp-table. 

   GUI-behaviour:
        * select/deselect object to pull/verify/transfer by either
          - double-clicking on it
          - pressing the spacebar
          - pressing the return/enter key
        * updating report-window by value-changed
        * persistent procedure to display the reports
        * single mouse click selects object without "updating" it
        * cursor-up/cursor-down are disabled
   TTY-behaviour:
        * select/deselect object to pull/verify/transfer by either:
          - pressing the spacebar
          - pressing the return/enter key
        * cursor keys are enabled
        * REPORT not available
        * overlay-frame to display the verify-reports (???)
   
Input: 
    Workfile gate-work contains info on all the gateway objects.
    p_Gate      Name of the gateway, e.g., "Oracle".
    p_sel-type  "Pull"      when seelcting objects to pull info
                            into s_ttb-tables
                "Compare"   to browse differences

Output:
    gatework.gate-flag = "yes"  object to be created/updated/deleted
 
Returns:
    "ok"     if 1 or more tables were chosen.
    "cancel" if user cancelled out.

Author: Laura Stern

Date Created : 07/28/93 

History:
    hutegger    95/03   extented functionality to get used for create, update
                        and browse differences
    gfs         94/07   Install correct help contexts
    gfs         94/05   Changed Selection-List to Browse
    kmcintos    03/05   Changed "Object Owner" to "Owner/Library" for DB2/400
                        Bug # 20041220-008
----------------------------------------------------------------------------*/

Define INPUT PARAMETER p_Gate       as char NO-UNDO.
Define INPUT PARAMETER p_Sel-Type   as char NO-UNDO.
&IF DEFINED(GATE_OMIT_PARM3) = 0 &THEN
Define INPUT PARAMETER p_Gate_AS400 as LOGICAL NO-UNDO.
&ENDIF

define new shared variable s_edt_diff   as character NO-UNDO.
define new shared variable s_tgl_upd    as logical   NO-UNDO.

&SCOPED-DEFINE xxDS_DEBUG   DEBUG
&SCOPED-DEFINE DATASERVER YES
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
&UNDEFINE DATASERVER
Define var canned      as logical NO-UNDO init TRUE.
Define var flg2patt    as logical NO-UNDO.
Define var inc_user    as logical NO-UNDO.
Define var inc_qual    as logical NO-UNDO.
Define var ix	       as integer NO-UNDO init 0. /* temp looping variable */
Define var l_logical   as logical NO-UNDO. /* result flag for methods */
Define var l_prc_diff  as handle  NO-UNDO.
define var l_wdw_brws  as widget-handle NO-UNDO.
define var l_wdw_old   as widget-handle NO-UNDO.

Define var lsthead     as char    NO-UNDO.
Define var name	       as char    NO-UNDO.
Define var pprompt     as char    NO-UNDO.
Define var qual	       as char    NO-UNDO.
Define var qualpatt    as char    NO-UNDO.
Define var slctpatt    as logical NO-UNDO.
Define var stat	       as logical NO-UNDO.
Define var tblpatt     as char    NO-UNDO.
Define var text1       as char    NO-UNDO format "x(76)".
Define var text2       as char    NO-UNDO format "x(76)".
Define var type	       as char    NO-UNDO.
Define var typpatt     as char    NO-UNDO.
Define var usr	       as char    NO-UNDO.
Define var usrpatt     as char    NO-UNDO.
define var curshit     as logical NO-UNDO init no.
define var is_as400sh  as logical NO-UNDO init FALSE.

DEFINE QUERY qgate-work FOR gate-work SCROLLING.

DEFINE BROWSE bgate-work QUERY qgate-work
    DISPLAY gate-flag FORMAT "*/"        NO-LABEL
            gate-name FORMAT "X(30)" COLUMN-LABEL "Object Name"
            &IF "{&GATE_FLG2}" = "YES"
             &THEN gate-flg2 FORMAT "yes/no"   COLUMN-LABEL "Changed"
             &ENDIF
            gate-user FORMAT "X(16)" 
            gate-type FORMAT "X(11)" COLUMN-LABEL "Object Type"
            gate-qual FORMAT "X(22)" COLUMN-LABEL "Qualifier"
  WITH SIZE 75 BY 12 FONT 0 /*MULTIPLE*/.

&IF DEFINED(GATE_OMIT_PARM3) = 0 &THEN
IF p_Gate_AS400 THEN DO:
     gate-user:label IN BROWSE bgate-work = "Col/Lib". 
     is_AS400sh = TRUE.
END.
ELSE 
&ENDIF
     gate-user:label IN BROWSE bgate-work = "Owner".

&IF "{&WINDOW-SYSTEM}" = "TTY"
 &THEN
  Define button btn_select       label "(S)elect Some..."    SIZE 18 BY 1.
  Define button btn_deselect     label "(D)eselect Some..."  SIZE 18 BY 1.
  &IF "{&GATE_FLG2}" = "YES"
   &THEN Define button btn_print label "(P)rint Reports..."  SIZE 18 BY 1.
   &ENDIF
 &ELSE
  Define button btn_select       label "&Select Some..."     SIZE 18 BY 1.
  Define button btn_deselect     label "&Deselect Some..."   SIZE 18 BY 1.
  Define button btn_diff         label "Close &Reports"      SIZE 18 BY 1.
  &IF "{&GATE_FLG2}" = "YES"
   &THEN Define button btn_print label "&Print"            {&STDPH_OKBTN}.
   &ENDIF
 &ENDIF
 

/*================================Forms====================================*/

/* create window */
&IF "{&GATE_FLG2}" = "YES" AND "{&WINDOW-SYSTEM}" <> "TTY"
 &THEN
  create window l_wdw_brws
  assign
    HIDDEN              = YES
    TITLE               = "Schema-Verify - Detected Differences"
    HEIGHT              = 19.5
    WIDTH               = 80
    MAX-HEIGHT          = 19.5
    MAX-WIDTH           = 80
    VIRTUAL-HEIGHT      = 19.5
    VIRTUAL-WIDTH       = 80
    RESIZE              = no
    SCROLL-BARS         = no
    STATUS-AREA         = no
    BGCOLOR             = ?
    FGCOLOR             = ?
    KEEP-FRAME-Z-ORDER  = yes
    THREE-D             = yes
    MESSAGE-AREA        = no
    SENSITIVE           = yes.
 &ENDIF

FORM
  &IF "{&WINDOW-SYSTEM}" <> "TTY"
   &THEN                                                 SKIP({&TFM_WID})
   &ENDIF
  text1  format "x(76)"                at 2 view-as TEXT SKIP
  text2  format "x(76)"                at 2 view-as TEXT SKIP({&VM_WIDG})

  &IF "{&WINDOW-SYSTEM}" <> "TTY"
   &THEN btn_select                           at  2 SPACE(2)
  &ELSEIF "{&GATE_FLG2}" = "YES"
   &THEN btn_select                           at 10 SPACE(2)
   &ELSE btn_select                           at 20 SPACE(2)
   &ENDIF
  btn_deselect                              SPACE(2)
  &IF "{&GATE_FLG2}" = "YES"
   &THEN
    &IF "{&WINDOW-SYSTEM}" <> "TTY"
     &THEN btn_diff                                      SKIP({&VM_WIDG})
     &ELSE btn_print                                     SKIP /*({&VM_WIDG})*/
     &ENDIF
   &ELSE                                                 SKIP({&VM_WIDG})
   &ENDIF

  bgate-work                           at 2

  &IF "{&GATE_FLG2}" = "YES" AND "{&WINDOW-SYSTEM}" <> "TTY"
   &THEN
    {prodict/user/userbtns.i
      &OTHER = "btn_print"
      }
   &ELSE
    {prodict/user/userbtns.i }
   &ENDIF
  with frame gtbl_get
    &IF "{&GATE_FLG2}" <> "YES" 
     &THEN view-as DIALOG-BOX
     &ELSE size 79 by 19.5
     &ENDIF
    TITLE "Select " + p_Gate + " Objects"
    CENTERED NO-LABELS SCROLLABLE overlay
    /*DEFAULT-BUTTON btn_OK*/ CANCEL-BUTTON btn_Cancel.
    /* The default-button is commented out because 
     * double-clicking on the browse causes the button to fire 
     */

FORM 
   SKIP({&TFM_WID})
   "Enter object information to"       at  2 view-as TEXT
   pprompt           FORMAT "x(10)" NO-LABEL view-as TEXT SKIP
   "Use '*' and '.' for wildcard patterns." 
                                       at  2 view-as TEXT SKIP({&VM_WIDG})

   tblpatt  FORMAT "x(29)"  LABEL "Object Name" 
                                    colon 14 {&STDPH_FILL} SKIP({&VM_WID})
   usrpatt  FORMAT "x(15)"   
                                    colon 14 {&STDPH_FILL} SKIP({&VM_WID})
   typpatt  FORMAT "x(15)"  LABEL "Object Type" 
                                    colon 14 {&STDPH_FILL} SKIP({&VM_WID})
   qualpatt FORMAT "x(22)"  LABEL "Qualifier"  
                                    colon 14 {&STDPH_FILL} SKIP({&VM_WID})
    &IF "{&GATE_FLG2}" = "YES" 
     &THEN 
   flg2patt FORMAT "yes/no"  LABEL "Changed"  
                                    colon 14 {&STDPH_FILL} SKIP({&VM_WID})
    &ENDIF
   {prodict/user/userbtns.i}
   with frame tbl_patt 
      	view-as DIALOG-BOX TITLE "Select Objects by Pattern Match"
        SIDE-LABELS CENTERED 
        DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel.

&IF DEFINED(GATE_OMIT_PARM3) = 0 &THEN
IF p_Gate_AS400 THEN DO:
     usrpatt:label IN frame tbl_patt = "Col/Lib".
     is_AS400sh = TRUE.
END.
ELSE
&ENDIF
     usrpatt:label IN frame tbl_patt = "Owner".

&IF "{&WINDOW-SYSTEM}" = "TTY"
 &THEN
  form
                                                        skip({&TFM_WID})
   "Verifying this object resulted in these messages:" 
                                    at  2 view-as TEXT  skip({&VM_WID})
    gate-work.gate-edit at  2 
                        view-as EDITOR
                        scrollbar-horizontal scrollbar-vertical
                        inner-chars 47 inner-lines 12   skip({&VM_WID})
    with row 2 column 28 overlay
    no-labels
    frame frm_report.
  &ENDIF

/*===============================Triggers==================================*/

  /*----- HELP -----*/
&IF "{&WINDOW-SYSTEM}" <> "TTY"
 &THEN
  on HELP of frame gtbl_get OR CHOOSE of btn_Help in frame gtbl_get
     RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                 	     	     INPUT {&Select_DataServer_Tables_Dlg_Box},
        	       	     	     INPUT ?).
   
  on HELP of frame tbl_patt OR CHOOSE of btn_Help in frame tbl_patt DO:
     IF FRAME tbl_patt:TITLE = "Select Objects by Pattern Match" THEN
       RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
        	       	     	       INPUT {&Select_by_Pattern_DataServer_Dlg_Box},
        	       	     	       INPUT ?).
     ELSE 
       RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
          	       	     	       INPUT {&Deselect_by_Pattern_DataServer_Dlg_Box},
        	       	     	       INPUT ?).   
  END.
 &ENDIF
 
&IF "{&GATE_FLG2}" = "YES" 
 &THEN  /*---------------------- WITH REPORTS ---------------------*/
  /*----- CHOOSE of print BUTTON-----*/
  on choose of btn_print or "P","p" of bgate-work in frame gtbl_get do:
  
    define variable l_header1 as character format "x(78)".
    define variable l_header2 as character format "x(78)".

    assign
      l_header1 = fill(" ",integer(5 - length(p_gate,"character") / 2))
                + "Results of comparison of the {&PRO_DISPLAY_NAME} image with the " 
                + p_Gate + " DB's schema"
      l_header2 = ( if user_dbtype = "ORACLE"
                      then "SH-Name="     + SDBNAME("DICTDBG")   + " "
                         + "Image-Name="  + LDBNAME("DICTDBG")
                        /* ORACLE-DB transparent -> no more info avlble */
                      else "SH-Name="     + SDBNAME("DICTDBG")   + " "
                         + "Image-Name="  + LDBNAME("DICTDBG")   + " "
                       /*+ "DSQUERY="     + OS-GETENV("DSQUERY") + " "*/
                         + "Physcl-Name=" + PDBNAME("DICTDBG")
                  )
      l_header2 = fill(" ",integer(38 - length(l_header2,"character") / 2))
                + l_header2.

    run prodict/misc/_prt_rpt.p
      ( INPUT "prodict/gate/_gat_prt.p",
        INPUT l_header1,
        INPUT l_header2,
        INPUT "guigget",
        INPUT "a"
      ).
    end.
    
  &IF "{&WINDOW-SYSTEM}" <> "TTY" 
   &THEN /*------------------------- GUI ---------------------------*/

    /*----- CHOOSE of verify report BUTTON-----*/
    on choose of btn_diff in frame gtbl_get do:

      if valid-handle(l_prc_diff)
       and l_prc_diff:type = "procedure"
       then do:  /* stop persistent procedure */
        assign btn_diff:label in frame gtbl_get = "View &Reports...".
        APPLY "U2" to l_prc_diff.
        end.     /* stop persistent procedure */
       else do:  /* start-up persistent procedure */
        assign btn_diff:label in frame gtbl_get = "Close &Reports".
        run prodict/user/_usr_dif.p persistent set l_prc_diff
          ( INPUT THIS-PROCEDURE).
        end.     /* start-up persistent procedure */

      end.
    
    /*----- U1 from persistent proc -----*/
    on U1 of THIS-PROCEDURE 
      assign btn_diff:label in frame gtbl_get = "View &Reports...".
    
   &ELSE  /*------------------------ TTY ---------------------------*/
 
    /*----- CURSOR-RIGHT of bgate-work -----* /
    on  CURSOR-DOWN of bgate-work in frame gtbl_get
     or CURSOR-UP   of bgate-work in frame gtbl_get
     or PAGE-DOWN   of bgate-work in frame gtbl_get
     or PAGE-UP     of bgate-work in frame gtbl_get
     do:

      assign
        s_edt_diff = gate-work.gate-edit.
        
      update
       s_edt_diff
        with frame frm_report.
      /* pause. */
      hide frame report.
      end.     / * CURSOR-RIGHT of bgate-work */

   &ENDIF /*------------------------- UI ---------------------------*/

  &ENDIF /*---------------------- WITH REPORTS ---------------------*/


/*----- MOUSE-SELECT-CLICK of bgate-work browser -----*/
on mouse-select-click of bgate-work in frame gtbl_get do:
  curshit = yes.
  &if "{&window-system}" ne "tty"
   &then
    apply "value-changed" to self.
  &endif
end.

/*----- DEFAULT-ACTION, SPACEBAR or RETURN of bgate-work browser -----*/
on default-action," ",RETURN of bgate-work in frame gtbl_get do:
  curshit = no.  /* see large comment below */
  if "{&window-system}" ne "osf/motif" or
     last-event:function ne "default-action"
   then apply "value-changed" to bgate-work in frame gtbl_get.
  return no-apply.
end.
  
/* tty:
   cursor keys fire the value-changed trigger, but we don't want the
   selection to occur in this case.  Unfortunately, there does not appear
   to be a way to tell what high-level event caused the value-change, so:
   cludge #1: we need to set a flag.
   cludge #2: we need to make sure the flag is off when either 
   default-action, spacebar or return fires the value-changed trigger,
   because it can be set when the user presses the cursor keys
   on the first or last row of the browser (this does not fire the
   value-changed event, which resets the flag).
   osf/motif and ms-windows:
   we need the same sort of control, but having the trigger effectively
   disables the cursor action, so we'll settle for that.
*/
on cursor-up,cursor-down of bgate-work in frame gtbl_get 
  &if "{&window-system}" = "tty" 
   &then
    curshit = yes.
   &else
    return no-apply.
  &endif


/*----- VALUE-CHANGED of bgate-work browser -----*/
on value-changed of bgate-work in frame gtbl_get do:

  define variable l_logical    as logical.

  if  bgate-work:NUM-SELECTED-ROWS = 0
   then assign l_logical = bgate-work:select-focused-row().

  if curshit then do:
    curshit = no.

    /* refresh "detail" window if displayed */
    assign
      s_edt_diff = gate-work.gate-edit
      s_tgl_upd  = gate-work.gate-flag.    
    
    if valid-handle(l_prc_diff)
     and l_prc_diff:type = "procedure"
     then APPLY "U1" to l_prc_diff.

    /* do not select/deselect new row for update */
    return no-apply.
    end.

  if gate-work.gate-type begins "FROZEN:"
   then do:  /* tried to select FROZEN table */
    message "This Table is FROZEN; It needs to be unfrozen before" skip
            "its definition can get updated."
      view-as alert-box.
    end.     /* tried to select FROZEN table */
    
   else do:  /* tried to select NON-frozen table */
   
    assign
      gate-work.gate-flag = NOT gate-work.gate-flag
      s_edt_diff          = gate-work.gate-edit
      s_tgl_upd           = gate-work.gate-flag.

    display
      gate-work.gate-flag
      gate-work.gate-name
      &IF "{&GATE_FLG2}" = "YES" 
       &THEN gate-flg2
      &ENDIF
      gate-work.gate-user
      gate-work.gate-qual
      gate-work.gate-type
      with browse bgate-work.

    if valid-handle(l_prc_diff)
     and l_prc_diff:type = "procedure"
     then APPLY "U1" to l_prc_diff.

    end.     /* tried to select NON-frozen table */

   assign
    l_logical = bgate-work:select-next-row().

  end.  /* on DEFAULT-ACTION of bgate-work */
  
  
/*----- GO or CHOOSE of OK BUTTON -----*/
on GO of frame gtbl_get /* or OK because of auto-go */ do:

  if NOT can-find(first gate-work 
                    where gate-work.gate-slct = slctpatt
                    and   gate-work.gate-flag = TRUE
                    )
   then do:
    message "Please select at least one Object or press Cancel."
            view-as alert-box error buttons ok.
    RETURN NO-APPLY.
    end.

  end.  /* on GO of frame gtbl_get */


/*----- CHOOSE of SELECT SOME BUTTON-----*/
on choose of btn_select or "S","s" of bgate-work in frame gtbl_get do:

  Define var choice as char NO-UNDO init "".
  Define var i      as int  NO-UNDO.

  assign
    &IF "{&GATE_FLG2}" = "YES" 
     &THEN flg2patt      = TRUE
     &ELSE flg2patt      = FALSE
    &ENDIF
    qualpatt             = "*"
    pprompt              = "select."
    tblpatt              = "*"
    typpatt              = "*"
    FRAME tbl_patt:TITLE = "Select Objects by Pattern Match".
  if usrpatt = ""
   then do:  /* initialize user-pattern */
    assign  
      usrpatt  = (IF is_as400sh THEN s_owner else USERID(user_dbname))          
      i        = ( if   INDEX(usrpatt,"/") <> 0
                    and INDEX(usrpatt,"@") <> 0
                    then MIN(INDEX(usrpatt,"/"), INDEX(usrpatt,"@"))
                    else MAX(INDEX(usrpatt,"/"), INDEX(usrpatt,"@"))
                 ).
   /* sqlnet-usernames are <userid>/<password>@<dbname...> or  */
   /*                      <userid>@<db-name...>               */
   /*   if @ contained in userid and we can-find a Object with */
   /*   the cut userid we use the cut userid as default-value  */
    if i > 0 
     and can-find(first gate-work 
        where gate-slct    =    slctpatt
        and   gate-user matches substring(usrpatt, 1, i - 1,"character")
                 )
     then assign usrpatt = substring(usrpatt, 1, i - 1,"character").
    end.     /* initialize user-pattern */

  if user_dbtype = "ORACLE" AND usrpatt begins "/@" then 
     RUN prodict/ora/_get_orauser.p (OUTPUT usrpatt).

  display pprompt with frame tbl_patt.

  do ON ENDKEY UNDO, LEAVE:

    update
      tblpatt
      usrpatt  when inc_user
      typpatt 
      qualpatt when inc_qual
    &IF "{&GATE_FLG2}" = "YES" 
     &THEN flg2patt
    &ENDIF
      btn_OK 
      btn_Cancel 
      {&HLP_BTN_NAME} with frame tbl_patt.

    /* Find the list of files that matches the pattern and set 
     * selection accordingly.
     */

     RUN adecomm/_setcurs.p ("WAIT").

    for each gate-work
      where gate-work.gate-slct    =    slctpatt
      and   gate-work.gate-flg2    =    flg2patt
      and   gate-work.gate-name matches tblpatt
      and   gate-work.gate-type matches typpatt
      and ( gate-work.gate-user matches (if inc_user then usrpatt else "")
        or  gate-work.gate-user = ?
          )
      and ( gate-work.gate-qual matches (if inc_qual then qualpatt else "")
        or  gate-work.gate-qual = ?
          )
      and NOT gate-work.gate-type begins "FROZEN:"    :
      assign gate-work.gate-flag = TRUE.
      end.  /* for each gate-work */

    OPEN QUERY qgate-work /*FOR*/ preselect EACH gate-work
                            where gate-work.gate-slct = slctpatt
                         /* and   gate-work.gate-type <> "PROGRESS" */
                            use-index upi.
                            
    bgate-work:MAX-DATA-GUESS = num-results("qgate-work").
    
    find last gate-work
      where gate-work.gate-slct = slctpatt
      and   gate-work.gate-flag = TRUE
      no-error.
    if available gate-work
     then do:
      assign
        s_edt_diff = gate-work.gate-edit
        s_tgl_upd  = gate-work.gate-flag.
      if valid-handle(l_prc_diff)
       and l_prc_diff:type = "procedure"
       then APPLY "U1" to l_prc_diff.
      end.
      
     RUN adecomm/_setcurs.p ("").

    end.  /* do on endkey */

  end.  /* on choose of btn_select */


/*----- CHOOSE of DESELECT SOME BUTTON-----*/
on choose of btn_deselect or "D","d" of bgate-work in frame gtbl_get do:

  Define var choice as char NO-UNDO init "".
  Define var i      as int  NO-UNDO.

  assign
    flg2patt             = FALSE
    pprompt              = "deselect."
    qualpatt             = ( if qualpatt = "" 
                              then "*"
                              else qualpatt
                           )
    tblpatt              = ( if tblpatt = "" 
                              then "*"
                              else tblpatt
                           )
    typpatt              = ( if typpatt = "" 
                              then "*"
                              else typpatt
                           )
    FRAME tbl_patt:TITLE = "Deselect Objects by Pattern Match".

  if usrpatt = ""
   then do:  /* initialize user-pattern */
    assign  
      usrpatt  = (IF is_as400sh THEN s_owner else USERID(user_dbname))
      i        = ( if   INDEX(usrpatt,"/") <> 0
                    and INDEX(usrpatt,"@") <> 0
                    then MIN(INDEX(usrpatt,"/"), INDEX(usrpatt,"@"))
                    else MAX(INDEX(usrpatt,"/"), INDEX(usrpatt,"@"))
                 ).
    /* sqlnet-usernames are <userid>/<password>@<dbname...> or  */
    /*                      <userid>@<db-name...>               */
    /*   if @ contained in userid and we can-find a Object with */
    /*   the cut userid we use the cut userid as default-value  */
    if i > 0 
     and can-find(first gate-work 
         where gate-slct    =    slctpatt
         and   gate-user matches substring(usrpatt, 1, i - 1,"character"))
     then assign usrpatt = substring(usrpatt, 1, i - 1,"character").
    end.       /* initialize user-pattern */

  display pprompt with frame tbl_patt.

  do ON ENDKEY UNDO, LEAVE:

    update
      tblpatt
      usrpatt  when inc_user
      typpatt 
      qualpatt when inc_qual
    &IF "{&GATE_FLG2}" = "YES" 
     &THEN flg2patt
    &ENDIF
      btn_OK 
      btn_Cancel 
      {&HLP_BTN_NAME} with frame tbl_patt.

    /* Go through the items already chosen.  Create a new list
     * without the ones that match the pattern. 
     */

     RUN adecomm/_setcurs.p ("WAIT").

    for each gate-work
      where gate-work.gate-slct    =    slctpatt
      and   gate-work.gate-flg2    =    flg2patt
      and   gate-work.gate-name matches tblpatt
      and   gate-work.gate-type matches typpatt
      and ( gate-user matches (if inc_user then usrpatt else "")
        or  gate-work.gate-user = ?
          )
      and ( gate-work.gate-qual matches (if inc_qual then qualpatt else "")
        or  gate-work.gate-qual = ?
          ):
      assign gate-work.gate-flag = FALSE.
      end.  /* for each gate-work */

    OPEN QUERY qgate-work /*FOR*/ preselect EACH gate-work
                            where gate-work.gate-slct = slctpatt
                         /* and   gate-work.gate-type <> "PROGRESS" */
                            use-index upi.
                            
    bgate-work:MAX-DATA-GUESS = num-results("qgate-work").

    find last gate-work
      where gate-work.gate-slct = slctpatt
      and   gate-work.gate-flag = TRUE
      no-error.
    if available gate-work
     then do:
      assign s_edt_diff = gate-work.gate-edit.
      if valid-handle(l_prc_diff)
       and l_prc_diff:type = "procedure"
       then APPLY "U1" to l_prc_diff.
      end.
      
     RUN adecomm/_setcurs.p ("").

    end.  /* do on endkey */
    
  end.  /* on choose of btn_deselect */


/*----- WINDOW-CLOSE of dialog -----*/
on window-close of frame gtbl_get
  apply "END-ERROR" to frame gtbl_get.

on window-close of frame tbl_patt
  apply "END-ERROR" to frame tbl_patt.


/*============================Mainline code================================*/

/**/&IF "{&DS_DEBUG}" = "DEBUG"
/**/ &THEN
/**/  define stream s_stm_errors.
/**/ /*run error_handling(4, "*****----- END odb_pul.p!!! -----*****" ,"").*/
/**/
/**/  output stream s_stm_errors to gate-work.d.
/**/  for each gate-work no-lock: 
/**/    display stream s_stm_errors gate-work with width 255. 
/**/    end.
/**/  output stream s_stm_errors close.
/**/ &ENDIF
 
&IF "{&GATE_FLG2}" = "YES" 
 &THEN
  find first gate-work 
    where gate-work.gate-slct = TRUE
    no-error.
  if available gate-work
   then assign
     s_edt_diff   = ( if s_edt_diff = ""
                        then gate-work.gate-edit
                        else s_edt_diff
                    ) /* init it with the first gate-work */
     s_tgl_upd    = gate-work.gate-flag
     slctpatt     = TRUE.
 &ELSE
  assign slctpatt = FALSE.
 &ENDIF

/* Configure pattern frame based on if user is appropriate or not */
find FIRST gate-work
  where gate-work.gate-slct  = slctpatt
  and   gate-work.gate-user <> ""
  and   gate-work.gate-user <> ?
  no-error.
if not available gate-work
 then assign
   usrpatt:visible in frame tbl_patt = no
   inc_user = no.
 else assign inc_user = yes.

find FIRST gate-work
  where gate-work.gate-slct  = slctpatt
  and   gate-work.gate-qual <> ""
  and   gate-work.gate-qual <> ?
  no-error.
if not available gate-work
 then assign
   qualpatt:visible in frame tbl_patt = no
   inc_qual = no.
 else assign inc_qual = yes.

/* Run time layout for button areas. */
{adecomm/okrun.i  
   &FRAME  = "FRAME tbl_patt" 
   &BOX    = "rect_Btns"
   &OK     = "btn_OK" 
   {&CAN_BTN}
   {&HLP_BTN}
}
{adecomm/okrun.i  
   &FRAME  = "FRAME gtbl_get" 
   &BOX    = "rect_Btns"
   &OK     = "btn_OK" 
   {&CAN_BTN}
   {&HLP_BTN}
}
if      p_sel-type = "Create"
 then assign
  text1 = "Below is a list of objects from the &1 database."
  text2 = "For each Object you choose its {&PRO_DISPLAY_NAME} image will be created.".
else if p_sel-type = "Compare"
 then assign
  text1 = "Below is a list of all the objects you chose to be verified."
  text2 = "You can select or deselect objects to get updated or not.".
 else if p_sel-type = "Pull"
 then assign
  text1 = "Below is a list of objects from the &1 database. For each Object "
  text2 = "you choose the info will get prepared to be used later on.".
 else assign    /* = "Update" */
  text1 = "Below is a list of objects from the &1 database."
  text2 = "For each Object you choose its {&PRO_DISPLAY_NAME} image will be updated.".

/* we don't need this - preselect query w/num-results() is better...
for each gate-work
  where gate-work.gate-slct = slctpatt: 
  accumulate gate-work.gate-flag (count).
  end.
*/

pause 0 before-hide.

OPEN QUERY qgate-work /*FOR*/ preselect EACH gate-work
                        where gate-work.gate-slct = slctpatt
                     /* and   gate-work.gate-type <> "PROGRESS" */
                        use-index upi.

/* The following line is here becuase the browse scrollbar does not 
 * acknowledge that there are more records beyond the default setting
 * of MAX-DATA-GUESS
 */
assign
  bgate-work:MAX-DATA-GUESS = /*accum count gate-work.gate-flag*/ 
                              num-results("qgate-work")
  text1      = SUBSTITUTE (text1, p_Gate)
/*text2      = SUBSTITUTE (text2, p_Gate)
  s_edt_diff = gate-work.gate-edit*/
  .

/* create window */
&IF "{&GATE_FLG2}" = "YES"  AND "{&WINDOW-SYSTEM}" <> "TTY"
 &THEN
  assign
    l_wdw_old           = CURRENT-WINDOW:handle
    CURRENT-WINDOW      = l_wdw_brws
    l_wdw_old:sensitive = false.
  view l_wdw_brws.
 &ELSE assign l_wdw_brws = CURRENT-WINDOW.
 &ENDIF

display text1 text2 with frame gtbl_get in window l_wdw_brws.

enable 

  bgate-work
  btn_select
  btn_deselect

  &IF "{&GATE_FLG2}" = "YES" AND "{&WINDOW-SYSTEM}" <> "TTY"
   &THEN
    btn_diff
   &ENDIF

  &IF "{&GATE_FLG2}" = "YES" AND "{&WINDOW-SYSTEM}" = "TTY"
   &THEN
    btn_print
   &ENDIF

  btn_OK
  btn_Cancel

  &IF "{&GATE_FLG2}" = "YES" AND "{&WINDOW-SYSTEM}" <> "TTY"
   &THEN
    btn_print
   &ENDIF

  {&HLP_BTN_NAME}

  with frame gtbl_get in window l_wdw_brws.
  
  &if "{&window-system}" ne "tty"
   &then
    /* make sure first row is selected when browse is initially opened */
    l_logical  = bgate-work:select-focused-row().
  &endif

/*===== start "detail" window =====*/

&IF "{&GATE_FLG2}" = "YES" AND "{&WINDOW-SYSTEM}" <> "TTY" 
 &THEN
  if not ( valid-handle(l_prc_diff)
   and l_prc_diff:type = "procedure"
         )
   then run prodict/user/_usr_dif.p persistent set l_prc_diff
          ( INPUT THIS-PROCEDURE).
 &ENDIF

do ON ENDKEY UNDO, LEAVE:
   wait-for GO of frame gtbl_get.  /* Or OK - due to auto-go */
   canned = false.
end.

if valid-handle(l_prc_diff)
 and l_prc_diff:type = "procedure"
 then APPLY "U2" to l_prc_diff.

for each gate-work
  where gate-work.gate-flag = TRUE:
  assign gate-work.gate-slct = TRUE.
  end.

hide frame gtbl_get NO-PAUSE.

/* delete window */
&IF "{&GATE_FLG2}" = "YES" AND "{&WINDOW-SYSTEM}" <> "TTY"
 &THEN
  assign
    l_wdw_old:sensitive = yes
    CURRENT-WINDOW      = l_wdw_old.
  delete widget l_wdw_brws.
 &ENDIF

RETURN (if canned then "cancel" else "ok").


