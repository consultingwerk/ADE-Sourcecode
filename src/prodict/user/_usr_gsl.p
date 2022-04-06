/*********************************************************************
* Copyright (C) 2000,2007,2011 by Progress Software Corporation. All *
* rights reserved. Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/user/_usr_gsl.p

Description:
    
    User-Interface for _xxx_get.p-programs
    
    Asks user for selection-criterias for the objects to be displayed 
    and selectable in the followup-list
                
Input-Output Parameters:
    p_name       object-name for pre-selection of objects
    p_owner      owner-name for pre-selection of objects
    p_qual       qualifier for pre-selection of objects
    p_type       object-type for pre-selection of objects
    p_frame      name of the frame to use
    
called from:
    odb/_odb_get.p
    ora/_ora6get.p
    ora/_ora7get.p
    syb/syb_getp.i
    
History:
    hutegger    94/07/29    creation
    mcmann      05/21/02    Added logic for user to select outputting to file instead of screen
    mcmann      06/05/03    Changed p_owner default to user doing selection of object.
    kmcintos    04/13/04    Added support for ODBC type DB2/400 by changing "Object Owner"
                            label to "Owner/Library"
    knavneet    02/21/07    Changed the label from Owner/Library to Collection/Library in case of DB2/400
                            Changed the label from Owner/Library to Owner in case of other data sources.  
    fernando    04/07/08    Support for datetime fo MSS/ORACLE 
    rkumar      02/03/09    Changes to support iSeries driver- OE00179889
    knavneet    04/28/09    BLOB support for MSS - OE00178319
    sdash       04/09/13    command line tool for update/add objects from foreign DB - OE00196459
--------------------------------------------------------------------*/        
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

{prodict/gate/gatework.i 
  &options    = "format ""x(30)"" "
  &SelVarType = "INPUT-OUTPUT PARAMETER p"
  }

define input        parameter p_frame    as   character.
define input        parameter p_link     as   character.
define input        parameter p_master   as   character.

define variable               canned     as   logical init yes.
define variable               l_link     as   character format "x(30)".
define variable               l_verify   as   logical.
define variable               cBestRowid as   character initial "Select 'Best' ROWID Index"
                                              FORMAT "x(27)" NO-UNDO.
define variable               isClobEnabled   as   logical init yes .
define variable               isBlobEnabled   as   logical init yes .
define variable               tmp_str         as   character.

DEFINE VARIABLE batch_mode    AS LOGICAL INITIAL NO       NO-UNDO.


batch_mode = SESSION:BATCH-MODE.

form
                                                          skip({&VM_WIDG})
  l_link    label "Link-Path  "  format "x(30)" colon 18  skip({&VM_WIDG})
  p_name    label "Object &Name"                 colon 18  skip({&VM_WIDG})
  p_type    label "Object &Type"                 colon 18  skip({&VM_WIDG})
  p_owner   label "&Owner"                colon 18  skip({&VM_WIDG})
  SPACE (1) p_vrfy    label "&Verify only objects that currently exist in the schema holder"
            view-as TOGGLE-BOX skip({&VM_WIDG})
  p_datetime LABEL "Default to OpenEdge DATETIME" view-as TOGGLE-BOX 
        at column-of p_vrfy row-of p_vrfy  skip({&VM_WIDG})
  SPACE (1) p_outf    LABEL "Output differences to file" VIEW-AS TOGGLE-BOX 
  {prodict/user/userbtns.i}
 with frame frm_link
  centered row 3 attr-space
  overlay side-labels
  view-as dialog-box default-button btn_ok cancel-button btn_cancel
  TITLE " Pre-Selection Criteria For Schema Pull ".
  
form
                                             skip({&VM_WIDG})
  p_name    label "Object &Name"   colon 18   skip({&VM_WIDG})
/*  p_type    label "Object &Type"  colon 18   skip({&VM_WIDG})*/
  p_owner   label "&Owner"  colon 18   skip({&VM_WIDG})
  p_qual    label "&Qualifier  "   colon 18   skip({&VM_WIDG})
  SPACE (1) p_vrfy    label "&Verify only objects that currently exist in the schema holder"
            view-as TOGGLE-BOX
  p_datetime LABEL "Default to OpenEdge DATETIME" view-as TOGGLE-BOX 
      at column-of p_vrfy row-of p_vrfy  skip({&VM_WIDG})
  p_lob LABEL "Default to OpenEdge LOB for: " view-as TOGGLE-BOX       
      at column-of p_vrfy  row-of p_vrfy skip
  p_clobtype LABEL " CLOBs" VIEW-AS TOGGLE-BOX at col 35  row-of p_vrfy + 1 
  p_blobtype LABEL " BLOBs" VIEW-AS TOGGLE-BOX at col 48  row-of p_vrfy + 1 skip({&VM_WIDG})
  p_primary LABEL "Designate Primary/Clustered index as ROWID" view-as TOGGLE-BOX 
    at column-of p_vrfy  row-of p_vrfy + 2  skip({&VM_WIDG})
  cBestRowid view-as Text no-label
    at column-of p_vrfy + 4 row-of p_vrfy + 2.9 skip({&VM_WIDG})
  p_best  LABEL "Using" VIEW-AS RADIO-SET HORIZONTAL RADIO-BUTTONS
     "OE Schema", 1,
     "Foreign schema", 2
      AT column-of p_vrfy + 4 row-of p_vrfy + 3.7 skip({&VM_WID})
  p_recidcompat LABEL "Provide RECID Compatibility" view-as TOGGLE-BOX
    at column-of p_vrfy  row-of p_vrfy + 4.6  skip({&VM_WIDG})
      
  SPACE (1) p_outf    LABEL "Output differences to file" VIEW-AS TOGGLE-BOX 
  {prodict/user/userbtns.i}
  with frame frm_ntoq
  centered row 3 attr-space
  overlay side-labels 
  view-as dialog-box default-button btn_ok cancel-button btn_cancel
  TITLE " Pre-Selection Criteria For Schema Pull ".
  
form
                                             skip({&VM_WIDG})
  p_name    label "Object &Name"   colon 18   skip({&VM_WIDG})
  p_type    label "Object &Type"   colon 18   skip({&VM_WIDG})
  p_owner   label "&Owner"  colon 18   skip({&VM_WIDG})
  SPACE (1) p_vrfy    label "&Verify only objects that currently exist in the schema holder"
            view-as TOGGLE-BOX skip({&VM_WIDG})
  SPACE (1) p_outf    LABEL "Output differences to file" VIEW-AS TOGGLE-BOX 
  {prodict/user/userbtns.i}
 with frame frm_nto
  centered row 3 attr-space
  overlay side-labels
  view-as dialog-box default-button btn_ok cancel-button btn_cancel
  TITLE " Pre-Selection Criteria For Schema Pull ".

form
                                             skip({&VM_WIDG})
  p_name    label "Object &Name"   colon 20   skip({&VM_WIDG})
  p_owner   label "&Collection/Library"  colon 20   skip({&VM_WIDG})
  p_qual    label "&Qualifier  "   colon 20   skip({&VM_WIDG})
  SPACE (1) p_vrfy    label "&Verify only objects that currently exist in the schema holder"
            view-as TOGGLE-BOX skip({&VM_WIDG})
  SPACE (1) p_outf    LABEL "Output differences to file" VIEW-AS TOGGLE-BOX 
  {prodict/user/userbtns.i}
 with frame frm_as400
  centered row 3 attr-space
  overlay side-labels
  view-as dialog-box default-button btn_ok cancel-button btn_cancel
  TITLE " Pre-Selection Criteria For Schema Pull ".
  

/*---------------------------  TRIGGERS  ---------------------------*/


&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
  on HELP of frame frm_ntoq
    or CHOOSE of btn_Help in frame frm_ntoq
    RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
 			      INPUT {&Presel_Schema_Pull_Qual_Dlg_Box},
			      INPUT ?).
  on HELP of frame frm_link
    or CHOOSE of btn_Help in frame frm_link
    RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
 			      INPUT {&Presel_Schema_Pull_Dlg_Box},
			      INPUT ?).
  on HELP of frame frm_nto
    or CHOOSE of btn_Help in frame frm_nto
    RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
			      INPUT {&Presel_Schema_Pull_Dlg_Box},
			      INPUT ?).
  on HELP of frame frm_as400
    or CHOOSE of btn_Help in frame frm_as400
    RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
			      INPUT {&Presel_Schema_Pull_Dlg_Box},
			      INPUT ?).
  &ENDIF
  
on GO of frame frm_link do:
  assign
    p_name  = p_name:screen-value  in frame frm_link
    p_owner = p_owner:screen-value in frame frm_link
    p_type  = p_type:screen-value  in frame frm_link
    .
  end.
  
on GO of frame frm_ntoq do:
  assign
    p_name  = p_name:screen-value  in frame frm_ntoq
    p_owner = p_owner:screen-value in frame frm_ntoq
    p_qual  = p_qual:screen-value  in frame frm_ntoq
   .
  end.
  
on GO of frame frm_nto do:
  assign
    p_name  = p_name:screen-value  in frame frm_nto
    p_owner = p_owner:screen-value in frame frm_nto
    p_type  = p_type:screen-value  in frame frm_nto
    .
  end.

on GO of frame frm_as400 do:
  assign
    p_name  = p_name:screen-value  in frame frm_as400
    p_owner = p_owner:screen-value in frame frm_as400
    p_qual  = p_qual:screen-value  in frame frm_as400
    .
  end.

on WINDOW-CLOSE of frame frm_link
   apply "END-ERROR" to frame frm_link.
    
on WINDOW-CLOSE of frame frm_ntoq
   apply "END-ERROR" to frame frm_ntoq.

on WINDOW-CLOSE of frame frm_nto
   apply "END-ERROR" to frame frm_nto.

on WINDOW-CLOSE of frame frm_as400
   apply "END-ERROR" to frame frm_as400.
    
/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

/*------------------------------------------------------------------*/
/* Default owner to userid of person doing the pull of objects.  20030605-037 */
/* AS/400- Default owner is set to userid in case default library 
   is not specified while creating the driver DSN-		 OE00179889 */
IF INDEX(USERID("DICTDBG"), "/") > 0 THEN
    ASSIGN p_owner = SUBSTRING(USERID("DICTDBG"), 1, (INDEX( USERID("DICTDBG"), "/") - 1)).
ELSE IF INDEX(USERID("DICTDBG"), "@") > 0 THEN
    ASSIGN p_owner = SUBSTRING(USERID("DICTDBG"), 1, (INDEX( USERID("DICTDBG"), "@") - 1)).
ELSE IF (p_frame NE "frm_as400" AND USERID("DICTDBG") NE "") 
        OR (p_frame = "frm_as400" AND (p_owner = "*" OR p_owner = "" OR p_owner = ? )) THEN 
	     ASSIGN  p_owner = USERID("DICTDBG").

IF OS-GETENV("RECIDCOMPAT") <> ? THEN DO:
  ASSIGN tmp_str  = OS-GETENV("RECIDCOMPAT").
  IF tmp_str BEGINS "Y" THEN 
     ASSIGN p_recidcompat = TRUE.
  ELSE 
     ASSIGN p_recidcompat = FALSE.
END.

IF DBTYPE("DICTDBG") EQ "ORACLE" AND p_owner = "" THEN
   RUN prodict/ora/_get_orauser.p (OUTPUT p_owner).

do on ENDKEY undo,leave:

  assign l_verify = user_env[25] begins "compare"
                 or user_env[25] begins "auto-compare".

  if p_frame = "frm_link":U
   then do:  /* frame frm_link */
    
    if not l_verify then 
      ASSIGN p_outf:hidden in frame frm_link = TRUE
             p_vrfy:hidden in frame frm_link = TRUE.
    
    /* for verify, or db-link, don't display date/datetime overrride option */
    IF l_verify OR p_link <> ""  THEN 
       ASSIGN p_datetime:hidden in frame frm_link = TRUE.

    {adecomm/okrun.i  
      &FRAME  = "FRAME frm_link" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
      }

    if p_link <> ""
     then assign
      l_link = p_master + p_link
      l_link = substring(l_link,
                         max(1,length(l_link,"character") - 30),
                         -1,
                         "character").
     else assign l_link = "<Local DB>":L30.
      
    display l_link with frame frm_link.
      
    update
      p_name
      p_type 
      p_owner 
      p_vrfy when l_verify
      p_outf WHEN l_verify
      p_datetime WHEN not l_verify AND p_link = "" 
      btn_OK 
      btn_Cancel
      {&HLP_BTN_NAME}
     with frame frm_link.
  
    hide frame frm_link no-pause.
    assign canned = false.
    end.     /* frame frm_link */
  
  else if p_frame = "frm_ntoq":U 
   then do:  /* frame frm_ntoq */
 
ASSIGN        p_clobtype:sensitive in frame frm_ntoq = FALSE
              p_blobtype:sensitive in frame frm_ntoq = FALSE
              p_lob:sensitive in frame frm_ntoq = TRUE
	      p_lob = FALSE
	      p_clobtype = TRUE
	      p_blobtype = TRUE.

    if not l_verify then 
      ASSIGN p_outf:HIDDEN IN FRAME frm_ntoq = TRUE
             p_vrfy:hidden in frame frm_ntoq = TRUE.

    IF NOT CAN-DO("MSS",DBTYPE("DICTDBG")) or l_verify THEN
    DO:
      ASSIGN p_lob:hidden in frame frm_ntoq = TRUE.
      ASSIGN p_clobtype:hidden in frame frm_ntoq = TRUE.
      ASSIGN p_blobtype:hidden in frame frm_ntoq = TRUE.
      ASSIGN p_datetime:hidden in frame frm_ntoq = TRUE.
      ASSIGN p_primary:hidden in frame frm_ntoq = TRUE.
      ASSIGN cBestRowid:hidden in frame frm_ntoq = TRUE.
      ASSIGN p_best:hidden in frame frm_ntoq = TRUE.
      ASSIGN p_recidcompat:hidden in frame frm_ntoq = TRUE.
   END.
    ELSE DO:
        /* move it one row below - the frame definitions has it on the same
           line as the previous widget so that when we don't have to display
           it, it doesn't leave a big gap on the UI */
        ASSIGN p_lob:ROW in frame frm_ntoq = p_lob:ROW in frame frm_ntoq + 1.
/*        ASSIGN p_blobtype = TRUE.
               p_blobtype:sensitive in frame frm_ntoq = FALSE.
        ASSIGN p_clobtype = TRUE.
               p_clobtype:sensitive in frame frm_ntoq = FALSE.*/
    END.

  ON VALUE-CHANGED of p_lob IN FRAME frm_ntoq DO:
    IF SELF:screen-value = "no" THEN DO:
     ASSIGN 
           p_clobtype:sensitive IN FRAME frm_ntoq = FALSE
           p_blobtype:sensitive IN FRAME frm_ntoq = FALSE.
    END.
    ELSE DO:
    ASSIGN 
           p_clobtype:screen-value in frame frm_ntoq = "yes"
           p_blobtype:screen-value in frame frm_ntoq = "yes"
           isBlobEnabled = TRUE
           isClobEnabled = TRUE
           p_clobtype = TRUE
           p_blobtype = TRUE
           p_clobtype:sensitive IN FRAME frm_ntoq = TRUE
           p_blobtype:sensitive IN FRAME frm_ntoq = TRUE.
    END.
  END.

  ON VALUE-CHANGED of p_clobtype IN FRAME frm_ntoq DO:
    IF SELF:screen-value = "no" THEN DO:
     p_clobtype = false.
     isClobEnabled = false.
    END.
    ELSE DO:
     p_clobtype = TRUE.
     isClobEnabled = TRUE.
    END.

     if isBlobEnabled = no and isClobEnabled = no then 
       ASSIGN p_lob:screen-value in frame frm_ntoq = "no".
     else 
       ASSIGN p_lob:screen-value in frame frm_ntoq = "yes".

  END. 


  ON VALUE-CHANGED of p_blobtype IN FRAME frm_ntoq DO:
    IF SELF:screen-value = "no" THEN DO:
     p_blobtype = false.
     isBlobEnabled = false.
    END.
    ELSE DO:
     p_blobtype = TRUE.
     isBlobEnabled = TRUE.
    END.

/*     assign p_lob:sensitive in frame frm_ntoq = TRUE.*/
     if isBlobEnabled = no and isClobEnabled = no then 
       ASSIGN p_lob:screen-value in frame frm_ntoq = "no".
     else 
       ASSIGN p_lob:screen-value in frame frm_ntoq = "yes".
    
  END. 

  ON VALUE-CHANGED of p_best IN FRAME frm_ntoq DO:
    IF SELF:screen-value = "2" THEN DO:
       p_recidcompat = false.
       assign p_recidcompat:sensitive in frame frm_ntoq = FALSE.
    END.
    ELSE assign p_recidcompat:sensitive in frame frm_ntoq = TRUE.
  END.

 IF NUM-ENTRIES(user_env[25]) = 9
   THEN ASSIGN
     p_name  = ENTRY(1,user_env[25])
     p_owner = ENTRY(2,user_env[25])
     p_qual  = ENTRY(3,user_env[25])
     p_datetime = LOGICAL(ENTRY(4,user_env[25]))
     p_vrfy = LOGICAL(ENTRY(5,user_env[25]))
     p_lob = LOGICAL(ENTRY(6,user_env[25]))
     p_blobtype = LOGICAL(ENTRY(7,user_env[25]))
     p_clobtype = LOGICAL(ENTRY(8,user_env[25]))
     p_best = INTEGER(ENTRY(9,user_env[25])).

   {adecomm/okrun.i  
      &FRAME  = "FRAME frm_ntoq" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
      }

    update
      p_name
      p_owner
      p_qual
      p_vrfy when l_verify
      p_outf WHEN l_verify
      p_datetime WHEN not l_verify and DBTYPE("DICTDBG") EQ "MSS"
      p_lob WHEN not l_verify and DBTYPE("DICTDBG") EQ "MSS"
      p_clobtype WHEN p_lob and not l_verify and DBTYPE("DICTDBG") EQ "MSS"
      p_blobtype WHEN p_lob and not l_verify and DBTYPE("DICTDBG") EQ "MSS"
      p_primary  WHEN not l_verify and DBTYPE("DICTDBG") EQ "MSS"
      cBestRowid  WHEN not l_verify and DBTYPE("DICTDBG") EQ "MSS"
      p_best  WHEN not l_verify and DBTYPE("DICTDBG") EQ "MSS"      
      p_recidcompat WHEN not l_verify and DBTYPE("DICTDBG") EQ "MSS" 
      btn_OK 
      btn_Cancel
      {&HLP_BTN_NAME}
     with frame frm_ntoq.
  
    hide frame frm_ntoq no-pause.
    assign canned = false.

    end.     /* frame frm_ntoq */

  else if p_frame = "frm_as400":U 
   then do:  /* frame frm_as400 */
 
    if not l_verify then 
      ASSIGN p_outf:HIDDEN IN FRAME frm_as400 = TRUE
             p_vrfy:hidden in frame frm_as400 = TRUE.

    {adecomm/okrun.i  
      &FRAME  = "FRAME frm_as400" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
      }

    update
      p_name
      p_owner
      p_qual
      p_vrfy when l_verify
      p_outf WHEN l_verify
      btn_OK 
      btn_Cancel
      {&HLP_BTN_NAME}
     with frame frm_as400.
  
    hide frame frm_as400 no-pause.
    assign canned = false.

    end.     /* frame frm_as400 */ 
  
  else if p_frame = "frm_nto":U
   then do:  /* frame frm_nto */
 
    if not l_verify then 
      ASSIGN p_outf:HIDDEN IN FRAME frm_nto = TRUE
             p_vrfy:hidden in frame frm_nto = TRUE.

    {adecomm/okrun.i  
      &FRAME  = "FRAME frm_nto" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
      }

    update
      p_name
      p_type
      p_owner
      p_vrfy when l_verify
      p_outf WHEN l_verify
      btn_OK 
      btn_Cancel
      {&HLP_BTN_NAME}
     with frame frm_nto.
  
    hide frame frm_nto no-pause.
    assign canned = false.
    
    end.     /* frame frm_nto */
    
  end.  /* do on endkey undo, leave */
RETURN if canned then "cancel":U else "ok":U.
  
/*------------------------------------------------------------------*/        
