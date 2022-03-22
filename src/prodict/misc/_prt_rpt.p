/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/gate/_gat_prt.p

Description:
    
    printing of all difference-reports

        
Text-Parameters:
    &object    {Sequence|Table|Field|Index|Index-Field}  
    &obj       {seq|tbl|fld|idx|idf}

output-Parameters:
    none
    
Called from:
    gui/guigget.i

History:
    hutegger    95/03   creation (derived from adecomm/_report.p)
    
--------------------------------------------------------------------*/
/*h-*/

{ adecomm/commeng.i }       /* Help contexts */
{ adecomm/adestds.i }       /* Standard layout defines, colors etc. */
{ adecomm/adeintl.i }       /* International support */
{ prodict/user/uservar.i }  /* btn_Ok, btn_Cancel, btn_Help */

/*
{ prodict/dictvar.i }
*/

define input parameter p_func       as character.
define input parameter p_header1    as character.
define input parameter p_header2    as character.
define input parameter p_caller     as character.
define input parameter p_param      as character.

define new shared stream   rpt.

define button btn_Files  label "&Files..."
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN size 12 by 1 &ENDIF .

define variable l_append        as logical.
define variable l_device        as character initial "PRINTER".
define variable l_file          as character.
define variable l_logical       as logical.
define variable l_param         as character initial "s".
define variable l_size          as integer.

form 
                                                          SKIP({&TFM_WID})
   
   l_device             COLON 17 LABEL "&Send output to"  
       view-as radio-set radio-buttons "Printer", "PRINTER",
                                       "File"   , "F"     SKIP ({&VM_WID})

   l_file               AT    19 NO-LABEL FORMAT "x(60)"          
       view-as fill-in native size 30 by 1 {&STDPH_FILL}  SPACE(.3)
   btn_Files                                              SKIP({&VM_WID})

   l_append             AT    19 LABEL "&Append to Existing File?"
       view-as toggle-box                                 SKIP({&VM_WIDG})
   
   l_size               COLON 17 LABEL "&Page Length" FORMAT ">>9"
      {&STDPH_FILL}
   "(# Lines, 0 for Continuous)"                   	  

   l_param              COLON 17 LABEL "&Add Parameter"  
       view-as radio-set radio-buttons "a", "a",
                                       "b", "b",
                                       "c", "c"     SKIP ({&VM_WID})

   {prodict/user/userbtns.i}

   with frame l_frm_options 
      side-labels 
      default-button btn_Ok cancel-button btn_Cancel
      view-as dialog-box title "Print Options".

/*---------------------  Internal Procedures  ----------------------*/

PROCEDURE adjust_l_param:

  if p_caller = "guigget"
   then do with frame l_frm_options:  /* printing after schema-compare */
    assign
      l_param   = p_param
      l_logical = l_param:replace("All objects in browser","a","a")
      l_logical = l_param:replace("Objects with differences","d","b")
      l_logical = l_param:replace("All selected objects","s","c").      
    end.                              /* printing after schema-compare */
   else do with frame l_frm_options:  /* no parameters -> hide widget */
    assign
      l_param:hidden = true.
    end.                              /* no parameters -> hide widget */
    
  end.     /* display_Schema_Info */

/*------------------------------------------------------------------*/

PROCEDURE display_Schema_Info:

  run adecomm/_setcurs.p ("WAIT").

  RUN VALUE(p_Func) (INPUT l_param).

  run adecomm/_setcurs.p ("").
   
  end.     /* display_Schema_Info */


/*---------------------------  TRIGGERS  ---------------------------*/

/*----- HELP -----*/
on HELP of frame l_frm_options
  &IF "{&WINDOW-SYSTEM}" <> "TTY"
   &THEN or choose of btn_Help in frame l_frm_options
   &ENDIF
  RUN "adecomm/_adehelp.p" (INPUT "comm", INPUT "CONTEXT", 
                            INPUT {&Print_Options},
                            INPUT ?).


/*-----WINDOW-CLOSE-----*/
on WINDOW-CLOSE of frame l_frm_options
  apply "END-error" to frame l_frm_options.


/*----- OK or GO -----*/
on GO of frame l_frm_options do:
  assign 
    l_device
    l_file
    l_append
    l_size
    l_param.

  l_file = TRIM(l_file).
  if l_device <> "PRINTER" then do:
    /* open the file to make sure we have permission */
    if l_file BEGINS "|"
     then output THROUGH VALUE(SUBSTRING(l_file,2,-1,"character"))
                             page-size VALUE(l_size).
    else if l_append
     then output to VALUE(l_file) page-size VALUE(l_size) APPEND.
     else output to VALUE(l_file) page-size VALUE(l_size).
    output close.
    assign l_device = l_file.
    end.
   
/*  {adecomm/prtrpt.i
 *     &Header = "p_Header"
 *     &Flags  = "p_Flags"
 *     &dev    = "l_device"
 *     &app    = "l_append"
 *     &siz    = "l_size"
 *     &Func   = "display_Schema_info"
 *     } 
 */
  {adecomm/prtrpt.i
     &Header = "p_Header1"
     &Flags  = "p_Header2"
     &dev    = "l_device"
     &app    = "l_append"
     &siz    = "l_size"
     &Func   = "display_Schema_info"
     } 

  end.  /* GO of frame l_frm_options */ 

/*----- VALUE-CHANGED of DEVICE RADIO SET -----*/
on VALUE-CHANGED of l_device in frame l_frm_options do:

/* Default to continuous output for terminal, 60 for printer. */
  assign l_device = SELF:SCREEN-VALUE.
  if l_device = "F" /* file */
   then do with frame l_frm_options:  /* output to file */
    assign
      l_size:SCREEN-VALUE = "0"
    &IF "{&WINDOW-SYSTEM}" <> "TTY"
     &THEN
      l_file:SENSITIVE    = yes
      btn_Files:SENSITIVE = yes
      l_append:SENSITIVE  = yes
     &ELSE
      l_file:VISIBLE      = yes
      btn_Files:VISIBLE   = yes
      l_append:VISIBLE    = yes
     &ENDIF
      .
     APPLY "ENTRY" TO l_file in frame l_frm_options.
     end.                           /* output to file */
 
    else do with frame l_frm_options: /* output to printer */
     assign
       l_size:SCREEN-VALUE   = "60"
     &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
       l_file:SENSITIVE      = no
       l_file:SCREEN-VALUE   = ""
       btn_Files:SENSITIVE   = no
       l_append:SENSITIVE    = no
       l_append:SCREEN-VALUE = "no"
      &ELSE
       l_file:VISIBLE        = no
       btn_Files:VISIBLE     = no
       l_append:VISIBLE      = no
      &ENDIF
       .
     end.                           /* output to printer */
     
  end.  /* VALUE-CHANGED of l_device */

/*----- HIT of FILE BUTTON -----*/
on CHOOSE of btn_Files in frame l_frm_options do:

  Define var name       as char    NO-UNDO.
  Define var picked_one as logical NO-UNDO.
  Define var d_title    as char    NO-UNDO init "Report File".
   
  assign name = TRIM(l_file:screen-value in frame l_frm_options).

  &IF "{&WINDOW-SYSTEM}" <> "TTY"
   &THEN
    system-dialog GET-FILE 
      name 
      filters            "*" "*"
      default-extension  ""
      title            d_title 
      /*must-exist*/
      update          picked_one.
   &ELSE
    run adecomm/_filecom.p
      ( INPUT        ""       /* p_Filter */, 
        INPUT        ""       /* p_Dir */ , 
        INPUT        ""       /* p_Drive */ ,
        INPUT        no       /* p_Save_As */ ,
        INPUT        d_title ,
        INPUT        ""       /* Dialog Options */ ,
        INPUT-OUTPUT name,
        OUTPUT       picked_one
      ). 
   &ENDIF
   
  if picked_one
   then assign l_file:screen-value in frame l_frm_options = name.

  end.  /* CHOOSE of btn_Files */

/*------------------------------------------------------------------*/
/*---------------------------  MAIN-CODE  --------------------------*/
/*------------------------------------------------------------------*/

/** / message "prt_rpt.p:" p_caller p_param view-as alert-box. / **/

/* Run time layout for button areas. */
{adecomm/okrun.i  
   &FRAME  = "FRAME l_frm_options" 
   &BOX    = "rect_Btns"
   &OK     = "btn_OK" 
   {&CAN_BTN}
   {&HLP_BTN}
}

run adjust_l_param.

/* Printer is default so adjust file and files button accordingly */
do with frame l_frm_options:
  assign
    l_append:SCREEN-VALUE = "no"
    l_file:SCREEN-VALUE   = ""
  &IF "{&WINDOW-SYSTEM}" <> "TTY"
   &THEN
    l_file:SENSITIVE      = no
    btn_Files:SENSITIVE   = no
    l_append:SENSITIVE    = no
   &ELSE
    l_file:HIDDEN         = yes
    btn_Files:HIDDEN      = yes
    l_append:HIDDEN       = yes
    l_file:SENSITIVE      = yes
    btn_Files:SENSITIVE   = yes
    l_append:SENSITIVE    = yes
   &ENDIF
    .
  end.
  
assign
   l_device = "Printer"
   l_size = 60.
display l_device l_size with frame l_frm_options.

enable
  l_device
  l_size
  l_param
  btn_Ok 
  btn_Cancel
  {&HLP_BTN_NAME}
  with frame l_frm_options.

/* Reset tab-order for things that will be enabled later. */
assign
  l_logical = l_file:MOVE-AFTER-TAB-ITEM(l_device:HANDLE in frame l_frm_options)
  l_logical = btn_Files:MOVE-AFTER-TAB-ITEM(l_file:HANDLE in frame l_frm_options)
  l_logical = l_append:MOVE-AFTER-TAB-ITEM(btn_Files:HANDLE in frame l_frm_options).

DO on error UNDO, LEAVE  on ENDKEY UNDO, LEAVE:
  wait-for CHOOSE of btn_OK in frame l_frm_options 
        or GO of frame l_frm_options FOCUS l_device.
 end.

hide frame l_frm_options.   

/*------------------------------------------------------------------*/
