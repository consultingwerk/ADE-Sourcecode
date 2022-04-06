/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/*----------------------------------------------------------------------------

File: prodict/gate/_gat_row.p

    displays all ROWID possibilities and ev. lets user select one among 
    them

    criterias in the browse:
        1   index-unique
        2   all fields mandatory
        3   prec <= 9 & ( scale <= 0 | scale = ? )
        4   selectability
        5   compatibility with V7.3
        6   number of fields in index
        7   no component is of type "float"

Input-Parameters:
    p_file-recid    recid of file to be worked on
    
Output-Parameters:
    none
    
Used/Modified Shared Objects:
    none
    
History:
    nordhougen  08/23/95    Added variable ora_rid_det to display detail info
                            for Oracle "native rowid" object
    nordhougen  08/10/95    Added trap to prevent access and display message
                            when there are no objects to select (empty browse)
    nordhougen  08/04/95    Added adjustments for l_brs_idx browser on MSW to
                            make v_comp column values completely visible
    hutegger    95/07/27    Changed UI and ODBC level-calculation; added 
                            prec/scale criteria to temp-table
    nordhougen  07/17/95    Fixed logic so that END-ERROR key will not
                            cause focused row to be selected when warning
                            message is displayed 
    nordhougen  07/14/95    Added trigger to allow RETURN key to select an
                            object from the "ROWID Choices" screen in GUI
                            mode
    nordhougen  07/14/95    Added trigger to allow RETURN key to exit from
                            the "Detail Info" screen in GUI mode
    nordhougen  07/12/95    Made ROWID Candidate Detail Information editor
                            widget READ-ONLY 
    hutegger    95/02/28    Creation; support for ORACLE and ODBC
    mcmann      97/11/13    Added view-as dialog box for non tty clients
    mcmann      00/08/10    Help was not working because topics in wrong file
                            20000810034
    
--------------------------------------------------------------------*/
/*h-*/

/*==========================  DEFINITIONS ===========================*/

&GLOBAL-DEFINE NOTTCACHE 1

{prodict/dictvar.i}
{prodict/user/uservar.i}
    
DEFINE input parameter p_db-type        as character.
define input parameter p_file-recid     as recid.

&IF "{&WINDOW-SYSTEM}" begins "MS-WIN"
 &THEN
   &Global-define chr10  ""
   &Global-define skp   
 &ELSE
   &Global-define chr10  chr(10)
   &Global-define skp    skip   
 &ENDIF

define temp-table l_ttb_idx
        field name      as character format "x(22)"    label "Name"
        field detail    as character
        field dttype    as logical /*format "   ok/"   label "Prec/Scale"*/
        field fld#      as integer /*format "z9"       label "#Comp"*/
        field mand      as logical   format "   ok/"   label "Mandatory"
        field slctbl    as logical   format "auto/user" label "Selectable"
        field slctd     as logical   format "current/" label "Selected"
        field uniq      as logical   format "  ok/"    label "Unique"
        field v_comp    as logical   format "7.3/"    
          &IF "{&WINDOW-SYSTEM}" begins "MS-WIN" &THEN  label "Comp   "
                                                &ELSE  label "Comp"  &ENDIF
          /* extra spaces in label needed on MSW to get correct column width */
        index upi       is unique primary 
                        uniq desc mand desc name asc.

define query  l_qry_idx for l_ttb_idx.

define browse l_brs_idx
        query l_qry_idx
      display l_ttb_idx.name   
              l_ttb_idx.uniq   l_ttb_idx.mand    
              l_ttb_idx.v_comp l_ttb_idx.slctd
         with 5 down.

define variable l_detail    as character no-undo.
define variable l_dttype    as logical   no-undo.
define variable l_fld#      as integer   no-undo.
define variable l_mand      as logical   no-undo.
define variable l_matrix    as character no-undo initial
                    "okok0,okok1,okok2,okok3,crap2,crap3,okok4,crap4".
define variable l_new-rowid as character no-undo.
define variable l_old-rowid as character no-undo.
define variable l_result    as logical   no-undo.
define variable l_slctbl    as logical   no-undo.
define variable l_usblt     as character no-undo.
define variable l_v_comp    as logical   no-undo.
define variable odbtyp      as character no-undo.

define variable ora_rid_det as character no-undo init
"The native ROWID returns the address of a row in an Oracle database.  It typically provides the fastest access to a record.  However, the native ROWID does not support the {&PRO_DISPLAY_NAME} FIND PREV/LAST statement or cursor repositioning.  FIND FIRST/NEXT statements for tables that use the native ROWID as a row identifier have unpredictable results.  You can use native ROWID with a view only if there is a one-to-one correspondence between the rows in the view and the rows in a single underlying table.  You cannot use ROWID for a view that performs a join, uses ""distinct,"" ""group by,"" aggregate functions, unions, etc.".

define variable l_msg         as character extent 16 initial [
 /* 1*/ "This index is NOT Unique. ",
 /* 2*/ "This index contains field(s) that are NOT Mandatory. ",
 /* 3*/ "The precision or scale of that field allows ",
 /* 4*/ "values incorrect for ROWID Index. ",
 /* 5*/ "Your application has to take care of that. ",
 /* 6*/ "If this index gets selected the schema is no longer V7.3 compatible.",
 /* 7*/ "This index contains more than one field. ",
 /* 8*/ "This table contains the column ""progress_recid"".  It is the ",
 /* 9*/ "optimal field/index to be used for ROWID functionality. ",
 /*10*/ "No other object can be selected.",
 /*11*/ "Please select one object to be used for ROWID functionality.",
 /*12*/ "You selected an object to be used for ROWID functionality ",
 /*13*/ "that has one or more components of datatype ""Float"". ",
 /*14*/ "It might not always be possible to retrieve a specific record.",
 /*15*/ "This DataServer doesn't support ROWID functionality.",
 /*16*/ "There are no objects to select."
    ].

/* To make the best possible selection for ROWID indexes in ODBC, we use
 * a list of values which symbolize the usability of that index.
 * The best is an index that would meet V7.3 criteria for "automatically
 * selectable", the next best is V7.3 "user selectable", ...
 * l_matrix:    format:   {okok|crap}{01234}
 *      okok  := number of fields of index = 1
 *      crap  := number of fields in index > 1
 *      0     := all fields = integer
               & all fields = mandatory
               & index = unique
 *      1     :=  all fields = integer
               & ( !all field = mandatory 
               |   index <> unique )
 *      2     := all fields <> "date,float"
 *      3     := all fields <> "float"
               & one or more fields = "date"
 *      4     := one or more fields = "float"
 */

form
  "Please select one of the following objects to be used for {&PRO_DISPLAY_NAME}" 
                                       view-as text at 2  skip
  "ROWID functionality. "              view-as text at 2
  &IF "{&WINDOW-SYSTEM}" = "TTY"
   &THEN
    "Cursor-right for detailed info."
   &ELSE
    "Double-click for detailed info."
   &ENDIF
                                       view-as text       skip({&VM_WIDG})
  l_brs_idx                                         at 4  skip({&VM_WIDG})
/*  "Usability: level 1 = best, level 8 = worst" */ 
/*  "Usability: level 1 to level 8 (level 1 = best)"
                                       view-as text at 2  skip({&VM_WIDG})
  */ 
  {prodict/user/userbtns.i}
  with title "  ROWID Choices  "
       default-button btn_ok
       cancel-button btn_cancel
       &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN view-as dialog-box 
          three-d &ENDIF 
       frame l_frm_idx.

form
  l_ttb_idx.detail at 2 view-as editor SCROLLBAR-V SCROLLBAR-H
    &IF "{&WINDOW-SYSTEM}" = "TTY"
     &THEN size 70 by 13
    &ELSEIF "{&WINDOW-SYSTEM}" begins "MS-WIN"
     &THEN inner-chars 71 inner-lines 13 /*scrollbar-h large*/
     &ELSE inner-chars 67 inner-lines 13 /*scrollbar-h*/
     &ENDIF
    font 0 no-label /* fixed font */
    &IF "{&WINDOW-SYSTEM}" <> "TTY"
     &THEN 
      {adecomm/okform.i
         &BOX    = rect_btns
         &STATUS = no
         &OK     = btn_OK
         &CANCEL = " "
         &OTHER  = " "
         &HELP   = btn_Help
      }
     &ELSE
      {adecomm/okform.i
         &STATUS = no
         &OK     = btn_OK
         &CANCEL = "  "
         &OTHER  = "  "
      }
     &ENDIF
  with title " Detail Information "
       default-button btn_ok
       &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN view-as dialog-box three-d &ENDIF 
       frame l_frm_dtl 
       &IF "{&WINDOW-SYSTEM}" begins "MS-WIN"
         &THEN width 110
         &ENDIF
       .
       
/*======================  WIDGET ATTRIBUTES ==========================*/

ASSIGN
  l_ttb_idx.detail:read-only = yes.
       
/*============================  TRIGGERS  ============================*/

/*-------------- HELP or CHOOSE of HELP BUTTON --------------*/
&IF "{&WINDOW-SYSTEM}" <> "TTY"
 &THEN
  on HELP of frame l_frm_idx OR CHOOSE of btn_Help in frame l_frm_idx
  RUN "adecomm/_adehelp.p" (INPUT "dict", INPUT "CONTEXT",
                               INPUT {&RowID_Idx_Dlg_Box}, 
                               INPUT ?).
  on HELP of frame l_frm_dtl OR CHOOSE of btn_Help in frame l_frm_dtl
     RUN "adecomm/_adehelp.p" (INPUT "dict", INPUT "CONTEXT", 
                               INPUT {&RowID_Idx_Dtl_Dlg_Box},
                               INPUT ?).
  &ENDIF


/*----- default-action of browse l_brs_idx or l_btn_dtl -----*/

&IF "{&WINDOW-SYSTEM}" = "TTY"
 &THEN
  ON DEFAULT-ACTION OF l_brs_idx IN FRAME l_frm_idx 
 &ELSE
  ON RETURN OF l_brs_idx IN FRAME l_frm_idx
&ENDIF  
    APPLY "GO" TO FRAME l_frm_idx.


/*----- return of editor l_ttb_idx.detail -----*/

ON RETURN OF l_ttb_idx.detail IN FRAME l_frm_dtl
  APPLY "CHOOSE" TO btn_ok.


/*----- return of browse l_brs_idx -----*/

ON RETURN OF l_brs_idx IN FRAME l_frm_idx
  APPLY "CHOOSE" TO btn_ok.


/*--------------- invoke "detail info" dialog ----------------*/

&IF "{&WINDOW-SYSTEM}" = "TTY"
 &THEN
  on cursor-right of l_brs_idx in frame l_frm_idx do:
 &ELSE
  on mouse-select-dblclick of l_brs_idx in frame l_frm_idx do:
&ENDIF

    assign
      l_result    = l_brs_idx:select-focused-row().
/*
      l_result    = l_brs_idx:fetch-selected-row(1) in frame l_frm_idx.
*/
    
    display l_ttb_idx.detail with frame l_frm_dtl.
    enable 
    &IF "{&WINDOW-SYSTEM}" <> "TTY"
     &THEN
      l_ttb_idx.detail
     &ENDIF
      btn_OK 
      {&HLP_BTN_NAME}
      with frame l_frm_dtl.
 
    do on error undo, leave on endkey undo, leave:
      wait-for choose of btn_OK in frame l_frm_dtl
        or go,return,mouse-select-dblclick of frame l_frm_dtl.
    end.

    disable
    &IF "{&WINDOW-SYSTEM}" <> "TTY"
     &THEN
      l_ttb_idx.detail
     &ENDIF
      btn_OK 
      {&HLP_BTN_NAME}
      with frame l_frm_dtl.

    hide frame l_frm_dtl.
    
  end.    /* invoke "detail info" dialog */

 
/*----------- GO or CHOOSE of OK BUTTON -----------*/

on GO of frame l_frm_idx  /* or OK because of auto-go */ do:
 do with frame l_frm_idx:
  
  define variable l_message as character no-undo.
  
  if l_old-rowid <> "<progress_recid>" then do:
  
    if l_brs_idx:num-selected-rows = 0 then do:
      message l_msg[11] view-as alert-box error buttons ok.
      RETURN NO-APPLY.
    end.

    assign
      l_result    = l_brs_idx:fetch-selected-row(1) in frame l_frm_idx
      l_new-rowid = l_ttb_idx.name.
                  
    if l_old-rowid <> l_new-rowid then
      case p_db-type:

        when "ORACLE" then do:

            /* display warnings and ask user to confirm */
            assign
              l_message   = ( if l_ttb_idx.uniq = FALSE
                                then l_msg[1] + {&chr10}
                                else ""
                            ) 
                          + ( if l_ttb_idx.mand = FALSE
                                then l_msg[2] + {&chr10}
                                else ""
                            )
                          + ( if l_ttb_idx.dttype = FALSE
                                then l_msg[3] + {&chr10} + l_msg[4] + {&chr10}
                                else ""
                            ).
            if l_message <> "" then do:
              assign l_result = FALSE.
              message l_message + l_msg[5]
                view-as alert-box warning 
                buttons ok-cancel update l_result.
              if not l_result or l_result = ? then RETURN NO-APPLY.
            end.
            
            /* de-select OLD index */
            if l_old-rowid <> "<native ROWID>" then do:
              find first DICTDB._Index of DICTDB._File
                where DICTDB._Index._Index-name = l_old-rowid no-error.
              if available DICTDB._Index
               then assign DICTDB._Index._I-misc2[1] = 
                        substring( DICTDB._Index._I-misc2[1]
                                 , 2
                                 , -1
                                 , "character"
                                 ).
            end.

            /* select NEW index */
            if l_new-rowid = "<native ROWID>" then
              assign DICTDB._File._Fil-misc1[4] = 0.
            else do:
              find first DICTDB._Index of DICTDB._File
                where DICTDB._Index._Index-name = l_new-rowid no-error.
              find first DICTDB._Index-Field of DICTDB._Index.
              find first DICTDB._Field of DICTDB._Index-Field.
              assign
                DICTDB._File._Fil-misc1[4] = DICTDB._Field._Fld-stoff
                DICTDB._Index._I-misc2[1]  = "r" + DICTDB._Index._I-misc2[1].
            end.
                    
          end.  /* when "ORACLE" */


          when odbtyp then do:

            /* display warnings and ask user to confirm */
            if l_ttb_idx.slctbl = FALSE
             then assign  /* user-definable */
              l_message   = ( if l_ttb_idx.uniq = FALSE
                                then l_msg[1] + {&chr10}
                                else ""
                            ) 
                          + ( if l_ttb_idx.mand = FALSE
                                then l_msg[2] + {&chr10}
                                else ""
                            )
              l_message   = ( if l_message <> ""
                                then l_message + l_msg[5]
                                else l_message
                            ).
            else assign  /* automatically selectable */
              l_message   = ( if l_ttb_idx.v_comp = FALSE
                                then l_msg[6] + {&chr10}
                                else ""
                            ) 
                          + ( if  l_ttb_idx.dttype = FALSE
                                then l_msg[12] + {&chr10}
                                   + l_msg[13] + {&chr10}
                                   + l_msg[14] + {&chr10}
                                else ""
                            ).
            if l_message <> "" then do:
              assign l_result = FALSE.
              message l_message
                view-as alert-box warning 
                buttons ok-cancel update l_result.
              if not l_result or l_result = ? then RETURN NO-APPLY.
            end.


            /* de-select OLD index */
            find first DICTDB._Index of DICTDB._File
              where DICTDB._Index._Index-name = l_old-rowid no-error.
            if available DICTDB._Index
             then assign DICTDB._Index._I-misc2[1] = 
                        substring( DICTDB._Index._I-misc2[1]
                                 , 2
                                 , -1
                                 , "character"
                                 ).
                   
            /* select NEW index */
            find first DICTDB._Index of DICTDB._File
              where DICTDB._Index._Index-name = l_new-rowid no-error.
            find first DICTDB._Index-Field of DICTDB._Index.
            find first DICTDB._Field of DICTDB._Index-Field.

            if l_ttb_idx.v_comp = TRUE
             then assign  /* schema remains V7.3 compatible */
              DICTDB._File._Fil-misc1[1] = DICTDB._Field._Fld-stoff * -1
              DICTDB._File._Fil-misc1[2] = DICTDB._Index._Idx-num
              DICTDB._File._Fil-misc2[3] = IF DICTDB._Field._Fld-misc2[3] <> ?
                                                THEN DICTDB._Field._Fld-misc2[3]
                                                ELSE DICTDB._Field._For-name
              DICTDB._Index._I-misc2[1]  = "r" + DICTDB._Index._I-misc2[1].

            else do:  /* schema is not V7.3 compatible anymore */
              assign
                DICTDB._File._Fil-misc1[1] = ?
                DICTDB._File._Fil-misc1[2] = DICTDB._Index._Idx-num
                DICTDB._File._Fil-misc2[3] = ?
                DICTDB._Index._I-misc2[1]  = "r"
                                     + ( if DICTDB._Index._I-misc2[1] = ?
                                          then "u"
                                          else DICTDB._Index._I-misc2[1]
                                       ).
            end.
                  
          end.  /* when odbtyp */

          otherwise
            message l_msg[15] view-as alert-box information buttons ok.

      end case.
      
    end.     /* old-rowid <> <progress_recid> */

    else if l_new-rowid <> "<progress_recid>"
      then message
        l_msg[8] {&skp}
        l_msg[9] {&skp}
        l_msg[10]
        view-as alert-box information buttons ok.

 end.  /* do with frame l_frm_idx */
end. /* on GO of frame l_frm_idx */
   
   
/*---------- WINDOW-CLOSE -> close dialog ----------*/

on window-close of frame l_frm_idx
   apply "END-ERROR" to frame l_frm_idx.

on window-close of frame l_frm_dtl
   apply "END-ERROR" to frame l_frm_dtl.


/*======================  INTERNAL PROCEDURES  ======================*/


/*==========================  MAIN CODE  ===========================-*/


/*------------ general initializations ------------*/

{adecomm/okrun.i  
    &FRAME  = "FRAME l_frm_idx" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
    {&HLP_BTN}
    }

{adecomm/okrun.i  
    &FRAME  = "FRAME l_frm_dtl" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    &CANCEL = " "
    {&HLP_BTN}
    }

find first DICTDB._File where RECID(_File) = p_file-recid.
if   DICTDB._File._Fil-misc1[1] <> ?
 AND DICTDB._File._Fil-misc1[1]  > 0
  then assign l_old-rowid = "<progress_recid>".

assign
  odbtyp     = {adecomm/ds_type.i
                 &direction = "odbc"
                 &from-type = "p_db-type"
                 }.
  odbtyp     = ( if can-do(odbtyp,p_db-type)
                    then p_db-type
                    else "NO-ODBC-TYPE"
               ).


/*-------- kick them out when progress_recid --------*/

if DICTDB._File._Fil-misc1[1] > 0
 and DICTDB._File._Fil-misc1[1] <> ?
 then do:  /* progress-Recid */
  message 
    l_msg[8] {&skp}
    l_msg[9] {&skp}
    l_msg[10]
    view-as alert-box information buttons ok.
  RETURN.
  end.     /* progress-Recid */


/*-------- generate temp-table records --------*/

create l_ttb_idx.

case p_db-type:
  when "ORACLE" then do:
  
             assign
               l_ttb_idx.name    = "<native ROWID>"
               l_ttb_idx.uniq    = TRUE
               l_ttb_idx.mand    = TRUE
               l_ttb_idx.dttype  = TRUE
               l_ttb_idx.slctbl  = FALSE
               l_ttb_idx.v_comp  = TRUE
               l_ttb_idx.fld#    = 1
               l_ttb_idx.detail  = ora_rid_det
               l_ttb_idx.slctd   = (  DICTDB._File._Fil-misc1[4] = 0
                                   or DICTDB._File._Fil-misc1[4] = ? 
                                   ).
             if l_ttb_idx.slctd
              then assign l_old-rowid = l_ttb_idx.name.

             end.  /* when "ORACLE" */

  otherwise  delete l_ttb_idx.

  end case.
 
  
/* browse: criterias:
 *       1   index-unique
 *       2   all fields mandatory
 *       3   prec <= 9 & ( scale <= 0 | scale = ? )
 *       4   selectability
 *       5   compatibility with V7.3
 *       6   number of fields in index
 *       7   no component is of type "float"
 */
 
/* index._I-misc2[1] can have the following characters:
 *   previous version
 *      a   automatically selectable index
 *      r   selected rowid-index
 *      u   user selectable index
 *   new version
 *      a   automatically selectable index
 *      r   selected rowid-index
 *      u   user selectable index
 *      x   non V7.3 compatible
 */
 
 
for each DICTDB._Index of DICTDB._File:

  if p_db-type = "ORACLE"
   then do:  /* p_db-type = "ORACLE" */
    if      can-do("a,ra",DICTDB._index._I-misc2[1])
     then assign
        l_dttype = TRUE
        l_fld#   = 0
        l_mand   = TRUE
        l_slctbl = TRUE
        l_v_comp = TRUE.
    else if can-do("ru,u",DICTDB._index._I-misc2[1])
     then do:  /* user-selectable */
      find first DICTDB._Index-Field of DICTDB._Index.
      find DICTDB._Field of DICTDB._Index-Field.
      assign
        l_dttype = NOT (DICTDB._Field._Fld-misc1[1] <= 9
                    AND DICTDB._Field._Fld-misc1[2] <= 0
                       )
        l_fld#   = 0
        l_mand   = DICTDB._Field._Mandatory
        l_slctbl = FALSE
        l_v_comp = TRUE.
      end.  /* user-selectable */
     else next.
    
    /* generate the details-report */
    assign l_detail = chr(10) + " Index: "
               + string(DICTDB._Index._Index-name,"x(28)") + " "
               + string(DICTDB._Index._Unique,"UNIQUE/Non-Unique") + "  "
               + ( if DICTDB._Index._I-misc2[1] begins "r"
                     then "crrntly slctd"
                     else ""
                  )
               + chr(10) + chr(10) + " "
               + string("Field"       ,"x(32)") + " " 
               + string("Mand"        ,"x(4)" ) + " "
               + string("Foreign Type","x(16)") + " "
               + string("Prec"        ,"x(4)")  + " "
               + string("Scale"       ,"x(5)")  + " "
               + chr(10) + " "
               + string(fill("-",40),"x(32)") + " "
               + string(fill("-", 6),"x(4)" ) + " "
               + string(fill("-",40),"x(16)") + " "
               + string(fill("-",10),"x(4)" ) + " "
               + string(fill("-",10),"x(5)" ) + " ".

    for each DICTDB._Index-Field of DICTDB._Index:
      find DICTDB._Field of DICTDB._Index-Field.
      assign
        l_detail = l_detail + chr(10) + " "
                 + string(DICTDB._Field._Field-name,"x(32)")   + " "
                 + string(DICTDB._Field._Mandatory,"Mand/Opt") + " "
                 + string(DICTDB._Field._For-Type,"x(16)")     + " "
                 + ( if DICTDB._Field._Fld-misc1[1] = ?
                      then "   ?"
                     else if LOOKUP(DICTDB._Field._data-type
                                ,"integer,character,decimal") <> 0
                      then string(DICTDB._Field._Fld-misc1[1],"zzz9")
                      else "    "
                   )  + " "
                 + ( if DICTDB._Field._Fld-misc1[2] = ?
                      then "   ?"
                     else if LOOKUP(DICTDB._Field._data-type
                                ,"integer,decimal") <> 0
                      then string(DICTDB._Field._Fld-misc1[2],"zz9-")
                      else "    "
                   )  + " "
             l_fld#   = l_fld# + 1.
      end.  /* for each DICTDB._Index-Field of DICTDB._Index */

    end.  /* p_db-type = "ORACLE" */
    
   else do:  /* p_db-type <> "ORACLE" */
    assign
      l_dttype = TRUE
      l_fld#   = 0
      l_mand   = TRUE
      l_slctbl = TRUE
      l_v_comp = TRUE.

    /* generate the details-report */
    assign l_detail = chr(10) + " Index: "
               + string(DICTDB._Index._Index-name,"x(28)") + " "
               + string(DICTDB._Index._Unique,"UNIQUE/Non-Unique") + " "
               + ( if DICTDB._Index._I-misc2[1] begins "r"
                     then "crrntly slctd"
                     else ""
                  )
               + chr(10) + chr(10) + " "
               + string("Field"       ,"x(32)") + " " 
               + string("Mand"        ,"x(4)" ) + " "
               + string("Foreign Type","x(16)") + " "
               + string("Lngth"       ,"x(5)")  + " "
               + string("Scale"       ,"x(5)")  + " "
               + chr(10) + " "
               + string(fill("-",40),"x(32)") + " "
               + string(fill("-", 6),"x(4)" ) + " "
               + string(fill("-",40),"x(16)") + " "
               + string(fill("-",10),"x(5)" ) + " "
               + string(fill("-",10),"x(5)" ) + " ".

    for each DICTDB._Index-Field of DICTDB._Index:
      find DICTDB._Field of DICTDB._Index-Field.
      assign 
        l_dttype   = l_dttype and DICTDB._Field._For-type <> "float"
        l_fld#     = l_fld# + 1
        l_v_comp   = ( l_v_comp
                        and   DICTDB._Field._For-type      = "integer"
              /*
                        and ( DICTDB._Field._Fld-misc1[1] <= 9
                           or DICTDB._Field._Fld-misc1[1]  = ? )
                        and ( DICTDB._Field._Fld-misc1[2] <= 0
                           or DICTDB._Field._Fld-misc1[2]  = ? )
              */
                     )
        l_mand     = l_mand  and DICTDB._Field._Mandatory
        l_detail   = l_detail + chr(10) + " "
                   + string(DICTDB._Field._Field-name,"x(32)")   + " "
                   + string(DICTDB._Field._Mandatory,"Mand/Opt") + " "
                   + string(DICTDB._Field._For-Type,"x(16)")     + " "
                 + ( if   DICTDB._Field._Fld-misc1[1] = ?
                      then "   ?"
                     else if LOOKUP(DICTDB._Field._data-type
                                   ,"integer,character,decimal") <> 0
                      then string(DICTDB._Field._Fld-misc1[1],"zzz9")
                      else "    "
                   )  + " "
                 + ( if DICTDB._Field._Fld-misc1[2] = ?
                      then "   ?"
                     else if LOOKUP(DICTDB._Field._data-type
                                   ,"integer,decimal") <> 0
                      then string(DICTDB._Field._Fld-misc1[2],"zz9-")
                      else "    "
                   )  + " ".
      end.  /* for each DICTDB._Index-field */

  end.  /* p_db-type <> "ORACLE" */
   
  if p_db-type = "ORACLE" and l_fld# > 1 then next.

  create l_ttb_idx.

  assign
    l_ttb_idx.name   = DICTDB._Index._Index-name
    l_ttb_idx.mand   = l_mand
    l_ttb_idx.dttype = l_dttype         
    l_ttb_idx.slctbl = l_slctbl and l_mand and DICTDB._Index._Unique
    l_ttb_idx.slctd  = ( if DICTDB._Index._I-misc2[1] <> ?
                           then DICTDB._Index._I-misc2[1] begins "r"
                           else FALSE
                       )
    l_ttb_idx.uniq   = DICTDB._Index._Unique
    l_ttb_idx.v_comp = l_v_comp
    l_ttb_idx.detail = l_detail.
    
  if l_ttb_idx.slctd then assign l_old-rowid = l_ttb_idx.name.
  
end.  /* for each DICTDB._Index of DICTDB._File */


/*------------ main transaction ------------*/

do transaction on error undo, leave on endkey undo, leave:

/*  if l_brs_idx:set-repositioned-row(1,"conditional") then. */ /* see comment
                                                                   below    */  
  open query l_qry_idx preselect each l_ttb_idx.
  
  if num-results("l_qry_idx") = 0
   then do:
     message l_msg[16] view-as alert-box information buttons ok.
     return.
     end.  /* no objects to select from */
  
  assign
    l_brs_idx:max-data-guess in frame l_frm_idx = num-results("l_qry_idx")
    l_new-rowid                                 = l_old-rowid.

  if l_old-rowid = "<progress_recid>"
   then message 
     l_msg[8] {&skp}
     l_msg[9] {&skp}
     l_msg[10]
     view-as alert-box information buttons ok.
     
  enable
    l_brs_idx
    btn_OK 
    btn_Cancel
    {&HLP_BTN_NAME}
    with frame l_frm_idx.

  find first l_ttb_idx where l_ttb_idx.name = l_old-rowid no-error.
  if available l_ttb_idx
   then do:
/*     reposition l_qry_idx to rowid(rowid(l_ttb_idx)). */ /* uncomment after
                                                              core problem 
                                                              fixed         */                                                            
     l_ttb_idx.slctd = yes.
     end.
        
  l_result = l_brs_idx:select-focused-row().   
       
  wait-for choose of btn_OK in frame l_frm_idx
        or go               of frame l_frm_idx.

  disable
    l_brs_idx
    btn_OK 
    btn_Cancel
    {&HLP_BTN_NAME}
    with frame l_frm_idx.
  
  end.  /* do transaction */
  
if l_old-rowid <> l_new-rowid
 then do:
   return "MOD".
   end.
 else return "NOT MODIFIED".
 
/*====================================================================*/
