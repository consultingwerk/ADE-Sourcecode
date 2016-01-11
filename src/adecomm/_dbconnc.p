/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _dbconnc.p

Description:
   Display and handle the connect dialog box, doing the connection
   if the user presses OK. Used in Character Mode only, but does
   run in GUI. The ADE GUI version is now in adecomm/_dbconng.w.

Input Parameters:
   p_Connect - whether the CONNECT should be executed
   
Input/Output Parameters:

   On input:  A value is supplied if known, otherwise, the value is ?
   On output: If connect succeeded, all values are set.  If more than one
                    database is connected (via -db parms), the information is
                    set for the first one that was connected successfully.
                    If connect failed or if the user cancelled, PName and LName 
                    are set to ?.
   
   p_PName               - the physical name of the database
   p_LName               - the logical name of the database
   p_Type                - the database type (e.g., PROGRESS, ORACLE) (internal name)
   p_Multi_User          - connect in single user (no) or multi-user (yes) mode
   p_UserId              - user id
   p_Password            - password
   p_Unix_Parms          - any other parms 

Output Parameters:
   p_args   - this is the argument string built for the connect
 
Author: Laura Stern

Date Created: 03/24/92
Modified:
  00/06/12 D. McMann - Fixed frame definition to fix better
  00/05/18 D. McMann - removed comments on password 20000512011
  00/04/12 D. McMann - Added support for long database names.
  98/07/16 Mario B. - Added -N -H -S parameters.  Bug# 98-04-19-027.
  98/05/04 mcmann   - Added check of name for logical name
                      98-04-02-053
  98/02/11 mcmann   - Added logical name check for spaces.
  97/03/05 hutegger - put on stop phrase around connect
  95/08/01 hutegger - add -ld, -H, -S, -dt params only if logical
                      and/or physical dbname available
                      (sometimes people just enter pf-file. In this
                      case we need to ignore the other parameters)
  11/10/94 gfs - .pl must exist off Files...
  08/22/94 gfs - remove comments on ASSIGN of Password.
  06/22/94 gfs - ensure editor widget for other params is blank.
  05/25/94 hutegger - disabled db-type
  02/22/94 wood - Display all CONNECT error messages in a single ALERT-BOX.
  07/30/92 by Elliot Chikofsky

----------------------------------------------------------------------------*/
{adecomm/cbvar.i}
{adecomm/commeng.i}  /* Help contexts */
{adecomm/adestds.i}

Define INPUT        parameter p_Connect      as logical  NO-UNDO.
Define INPUT-OUTPUT parameter p_PName        as char     NO-UNDO.
Define INPUT-OUTPUT parameter p_LName        as char     NO-UNDO.
Define INPUT-OUTPUT parameter p_Type         as char     NO-UNDO.
Define INPUT-OUTPUT parameter p_Multi_User   as logical  NO-UNDO.
Define INPUT-OUTPUT parameter p_Network      as char     NO-UNDO.
Define INPUT-OUTPUT parameter p_Host_Name    as char     NO-UNDO.
Define INPUT-OUTPUT parameter p_Service_Name as char     NO-UNDO.
Define INPUT-OUTPUT parameter p_UserId       as char     NO-UNDO.
Define INPUT-OUTPUT parameter p_Password     as char     NO-UNDO.
Define INPUT-OUTPUT parameter p_Trig_Loc     as char     NO-UNDO.
Define INPUT-OUTPUT parameter p_Parm_File    as char     NO-UNDO.
Define INPUT-OUTPUT parameter p_Unix_Parms   as char     NO-UNDO.
Define OUTPUT       parameter p_args         as char     NO-UNDO.

Define              variable  capab          as char     NO-UNDO. /* DataServ Cabap's */
Define              variable  ext_Type       as char     NO-UNDO.
/*Define              variable  qbf_l_name    as logical NO-UNDO. / * l-name NOT needed */
Define              variable  qbf_p_name     as logical  NO-UNDO. /* p-name NOT needed */

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   /* "Blue bar" optional text */
   define var txt_optional as char initial " Optional" {&STDPH_SDIV}
                                             format "x(12)" view-as text.

&ENDIF

/* Buttons */
Define button btn_Filen  label "&Files..." SIZE 12 by 1.
Define button btn_Filet  label "Files..."  SIZE 12 by 1.
Define button btn_Filep  label "Files..."  SIZE 12 by 1.
Define button btn_Fileb  label "Files..."  SIZE 12 by 1.
Define button btn_Filea  label "Files..."  SIZE 12 by 1.
Define button btn_Ok          label "OK"        {&STDPH_OKBTN}.
Define button btn_Cancel label "Cancel"    {&STDPH_OKBTN} AUTO-ENDKEY.
Define button btn_Help   label "&Help"           {&STDPH_OKBTN}.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   /* standard button rectangle */
   Define rectangle rect_Btns {&STDPH_OKBOX}.
&ENDIF

/* Miscellaneous */
Define var stat   as logical NO-UNDO.
Define var ix     as integer NO-UNDO.
Define var Other  as char    NO-UNDO.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   &global-define FBTN_SPACE  .3
&ELSE
   &global-define FBTN_SPACE  1
&ENDIF

form
  /* SKIP({&TFM_WID})*/
   p_PName             label "Physical &Name"             colon  18
                   format "x({&PATH_WIDG})" {&STDPH_FILL}
                                view-as FILL-IN SIZE 39 by 1                  SPACE({&FBTN_SPACE})
   btn_Filen                                                                  

   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      SKIP({&VM_WIDG})
      txt_optional no-label                     at 2 
      SKIP({&VM_WIDG})
   &ELSE
      SKIP({&VM_WID})
   &ENDIF

   p_LName               label "&Logical Name"        colon  18
                                format "x(50)" {&STDPH_FILL}             SKIP({&VM_WID})

   ext_Type              label "&Database Type"             colon  18
                                format "x(11)" {&STDPH_FILL}     

   p_Multi_User    label "&Multiple Users"      at     51
                                view-as TOGGLE-BOX                             SKIP({&VM_WID})

   p_UserId              label "&User ID"                         colon  18 
                                format "x(50)" {&STDPH_FILL}             SKIP({&VM_WID})
   p_Password            label "Pass&word"                        colon  18
                                format "x(50)" {&STDPH_FILL} PASSWORD-FIELD SKIP({&VM_WID})
   p_Trig_Loc      label "&Trigger Location"    colon  18
                         format "x({&PATH_WIDG})" {&STDPH_FILL}
                                view-as FILL-IN SIZE 39 by 1             SPACE({&FBTN_SPACE})
   btn_Filet                                                SKIP({&VM_WID})
   p_Parm_File           label "&Parameter File"            colon  18
                                format "x({&PATH_WIDG})" {&STDPH_FILL}
                                view-as FILL-IN SIZE 39 by 1             SPACE({&FBTN_SPACE})
   btn_Filep                                                SKIP({&VM_WID}) 

   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
      SKIP(1)
   &ENDIF
                                             
   "Other CONNECT Statement Parameters:"              at      4   SKIP({&VM_WID})
   Other    NO-LABEL  {&STDPH_EDITOR}    at      4
                                view-as EDITOR SCROLLBAR-VERTICAL
                                &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
                                  SIZE 67 BY 4
                                &ELSE
                                  SIZE 67 BY 2.5
                                &ENDIF

   {adecomm/okform.i
      &BOX    = rect_btns
      &STATUS = no
      &OK     = btn_OK
      &CANCEL = btn_Cancel
      &HELP   = btn_Help}

   with frame CONNECT ROW 1
        SIDE-LABELS 
              DEFAULT-BUTTON btn_Ok CANCEL-BUTTON btn_Cancel
        view-as DIALOG-BOX TITLE "Connect Database".


/*====================== Internal Procedures and Functions ===================*/

Procedure Get_File_Name:
   Define INPUT PARAMETER h_name  as widget-handle NO-UNDO.
   Define INPUT PARAMETER p_ext   as char          NO-UNDO. /* contains "." */
   Define INPUT PARAMETER p_title as char          NO-UNDO.
   Define INPUT PARAMETER p_exist as logical       NO-UNDO.

   Define var name       as char    NO-UNDO.
   Define var picked_one as logical NO-UNDO.
   Define var filter     as char    NO-UNDO.
   Define var must_exist as char    NO-UNDO.

   filter = "*" + p_ext.
   name = TRIM(h_name:screen-value).

   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      if p_exist then
         system-dialog GET-FILE 
            name 
            filters            filter filter
            default-extension  p_ext
            title                p_title 
            must-exist
            update             picked_one.
      else
         system-dialog GET-FILE 
            name 
            filters            filter filter
            default-extension  p_ext
            title                p_title 
            update             picked_one.
   &ELSE
      ASSIGN must_exist = IF p_exist THEN "MUST-EXIST"
                                     ELSE "".
      RUN adecomm/_filecom.p
          ( INPUT filter /* p_Filter */, 
            INPUT ""          /* p_Dir */ , 
            INPUT ""          /* p_Drive */ ,
            INPUT NO ,          /* p_Save_As */
            INPUT p_Title ,
            INPUT must_exist ,
            INPUT-OUTPUT name,
            OUTPUT picked_one). 
   &ENDIF

   if picked_one then
      h_name:screen-value = name.
end.

FUNCTION StartupParameter RETURNS CHARACTER
         (INPUT        TargetParameter AS CHARACTER,
          INPUT-OUTPUT ParameterLine   AS CHARACTER,
	  INPUT        HasArgument     AS LOGICAL).

/* Returns argument for TargetParameter or parameter if not HasArgument  *
 * If no target found, returns ""                                        */
   
   DEF VAR Extract   AS CHAR.
   DEF VAR Remainder AS CHAR.
   DEF VAR i         AS INT.
   
   DO i = 1 TO NUM-ENTRIES(ParameterLine," "):
      CASE ENTRY(i,ParameterLine," "):
         WHEN TargetParameter THEN
	 DO:
            IF HasArgument THEN
	    DO:
	       i = i + 1.
               Extract = ENTRY(i,ParameterLine," ").
            END.	       
         END.
         OTHERWISE
            Remainder = Remainder + ENTRY(i,ParameterLine," ") + " ".
      END CASE.
   END.

   ParameterLine = Remainder.
   RETURN Extract.
   
END FUNCTION.

 
/*===============================Triggers====================================*/

/*----- HIT of OK BUTTON -----*/
on choose of btn_Ok in frame connect OR GO of frame connect
do:
   Define var args         as char    NO-UNDO.
   Define var num          as integer NO-UNDO.
   Define var ix           as integer NO-UNDO.
   
   Define var cMsgs        as char   NO-UNDO.

   assign 
      p_PName     = input frame connect p_PName
      p_Parm_File = input frame connect p_Parm_File.

   /* Check for required input. */
   IF (p_PName     = ""   OR p_PName     = ?) AND
      (p_Parm_File = ""   OR p_Parm_File = ?) AND
      qbf_p_name   = TRUE                     then
   do:
      message "You must supply a physical name or a parameter file."
                     view-as ALERT-BOX ERROR buttons OK.
      return NO-APPLY.
   end.

   assign 
      input frame connect p_LName
/*    input frame connect p_Type    */
      input frame connect p_Multi_User
      input frame connect p_UserId
      input frame connect p_Password
      input frame connect p_Trig_Loc
      input frame connect Other
      p_Network      = StartupParameter("-N",Other,TRUE)
      p_Host_Name    = StartupParameter("-H",Other,TRUE)
      p_Service_Name = StartupParameter("-S",Other,TRUE)
      p_Unix_Parms   = Other.
      
   /* Set up parameters for CONNECT */
   /* WIN95-LFN : WIN95 Long Filename support requires physical and logical
      dbnames be quoted. - jep 12/14/95 */
   assign args = "'" + ( if qbf_p_name then p_Pname else p_LName ) + "'".
   if args = "''" or args = ? then args = "".
   
   if args <> "" then
   do:
     assign args = args + " -dt "   + p_Type.
     if p_LName        <> "" then assign args = args + " -ld " +
                                                "'" + p_LName + "'".
     if p_Network   <> "" THEN assign args = args + " -N " + p_Network.
     if p_Host_Name <> "" THEN assign args = args + " -H " + p_Host_Name.
     if p_Service_Name <> "" THEN assign args = args + " -S " + p_Service_Name.
     if p_UserId    <> "" then assign args = args + " -U "  + p_UserId.
     if p_Password  <> "" then assign args = args + " -P "  + p_Password.
     if p_Multi_User = no then assign args = args + ' -1 '.
   end.
   
   if p_Trig_Loc  <> "" then assign args = args + " -trig " + p_Trig_Loc.
   if p_Parm_File <> "" then assign args = args + " -pf "   + p_Parm_File.

   assign p_args = args.
 
   /* If the caller did not want the database connected now, we're done */
   if not p_Connect then return.

   /* We need do ON ERROR because otherwise, if any connect fails, Progress
      will kick us out of the trigger.  Note that Progress will raise
      error on the first connect that fails and won't keep going to try
      to connect other ones.
   */
   assign num = NUM-DBS.
   /* num-dbs sometimes returns 1 instead of 0. If ldbname and pdbname 
    * are ? we reassign num to be 0 (hutegger 95/01)
    */
   if num        = 1 and
      ldbname(1) = ? and
      pdbname(1) = ? then assign num = 0.
   
   do on stop undo, retry:
     if retry
      then do:
       run adecomm/_setcurs.p ("").
       return no-apply.
       end.
      else do:
       run adecomm/_setcurs.p ("WAIT").
       connect VALUE(args) VALUE(p_Unix_Parms) NO-ERROR.
       run adecomm/_setcurs.p ("").
       end.
     end.

   /* This will be set from any errors or warnings. Merge all the warnings
      together and display them in one shot.  */
   IF error-status:NUM-MESSAGES > 0 THEN DO:
     cMsgs = error-status:get-message(1).
     do ix = 2 to error-status:num-messages:
       cMsgs = cMsgs + CHR(10) + error-status:get-message(ix).
     end.
     MESSAGE cMsgs VIEW-AS ALERT-BOX ERROR BUTTONS OK. 
   END.

   /* If the user has tried to connect to more than one database 
      (via -db parms) one may succeed while another failed.  The only way 
      we can tell what's really happened is to check NUM-DBS again.
   */
   if  NUM-DBS > num then
   do:
      /* The database whose name was entered in the name fill-in, may in
            fact not be one of the ones that connected successfully.
            To be sure we get this right, get the info from Progress for
            the num+1 connected database - it should be the first of the ones
            that were just connected.
      */
      assign
            p_LName = LDBNAME(num + 1)
            p_PName = PDBNAME(num + 1)
            p_Type = DBTYPE(num + 1).
      return.
   end.
   else do:
      /* The connect failed on all counts  - we want to leave the box up, 
               so abort the OK button. */
      if qbf_p_name
       then apply "entry" to p_Pname in frame connect.
       else apply "entry" to p_Lname in frame connect.
      return NO-APPLY.
   end.
end.

/*----- WINDOW-CLOSE-----*/
on WINDOW-CLOSE of frame connect do:
   assign
     p_PName = ?
     p_LName = ?.
   apply "END-ERROR" to frame connect.
   end.

/*----- HIT of FILE BUTTONS -----*/
on choose of btn_Filen in frame connect
   run Get_File_Name (INPUT p_PName:HANDLE in frame connect,
                                   INPUT ".db",
                                   INPUT "Find Database File",
                                   INPUT TRUE).

on choose of btn_Filet in frame connect
   run Get_File_Name (INPUT p_Trig_Loc:HANDLE in frame connect,
                                   INPUT ".pl",
                                   INPUT "Find Procedure Library File",
                                   INPUT TRUE).

on choose of btn_Filep in frame connect
   run Get_File_Name (INPUT p_Parm_File:HANDLE in frame connect,
                                   INPUT ".pf",
                                   INPUT "Find Parameter File",
                                   INPUT TRUE).



/*----- ON LEAVE of LOGICAL NAME ----- */
on leave of p_LName in frame connect
do:
   Define var name as char NO-UNDO.

   name = input frame connect p_LName.
   if LOOKUP(name, "DICTDB,DICTDB2,DICTDBG,AS4DICT") <> 0 then
   do:         
      message "You cannot connect to a database" SKIP
                    "with a logical name of " name "."
                     view-as ALERT-BOX ERROR buttons OK.

      return NO-APPLY.  /* prevent user from leaving the field. */
   end.
   IF NUM-ENTRIES(name, " ") <> 1 AND LENGTH(name) > 1 THEN DO:
     message "You cannot have spaces in the logical name"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
     RETURN NO-APPLY.
   END.     

end.


/*----- ON LEAVE of TRIGGER LOCATION ----- */
on leave of p_Trig_loc in frame connect
do:
   Define var name as char NO-UNDO.

   name = input frame connect p_Trig_loc.
   if    length(name,"character") > 2
     and substring(name,length(name,"character") - 2,-1,"character") = ".pl"
     and SEARCH(name)    = ? 
     then do:         
     message "This library-file does not exist"
             view-as ALERT-BOX ERROR buttons OK.

     return NO-APPLY.  /* prevent user from leaving the field. */
     end.
end.


/*-----HIT of Cancel BUTTON or ENDKEY, END-ERROR -----*/
on choose of btn_Cancel in frame connect 
  OR ENDKEY             of frame connect
  OR END-ERROR          of frame connect
  assign
    p_PName = ?
    p_LName = ?.


/*----- HELP -----*/
on HELP of frame connect OR
   choose of btn_Help in frame connect
   RUN "adecomm/_adehelp.p" (INPUT "comm", INPUT "CONTEXT", 
                                               INPUT {&Connect_Database},
                                               INPUT ?).


/*============================Mainline code==================================*/

/* Unfortunately, even if pname or lname are given, we can't figure out
   the type since the thing isn't connected!  So always default to
   PROGRESS.
*/

if p_Type = ? then
   p_Type = "PROGRESS".

if p_type <> "PROGRESS"
 then do: /* some DataServers do not need a physical db-name */
  { prodict/dictgate.i
      &action = "query"
      &output = "capab"
      &dbrec  = "?"
      &dbtype = "p_type"
      }
  ASSIGN
    qbf_p_name = INDEX(ENTRY(5,capab),"p") > 0  /* p-name needed */.
  end.
 else assign
  qbf_p_name = TRUE.
  
/* Multi_User defaults no if not decided */
if p_Multi_User = ? 
   then p_Multi_User = no.

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME  = "frame connect" 
   &BOX    = "rect_Btns"
   &OK     = "btn_OK"
   &CANCEL = "btn_Cancel"
   &HELP   = "btn_Help"
}

/* So Return doesn't hit default button in editor widget */
Other:return-inserted = yes.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   /* runtime adjustment of "Optional" title band to the width of the frame */
   txt_optional:width-chars = eff_frame_width - ({&HFM_WID} * 2).
&ENDIF

assign ext_Type = {adecomm/ds_type.i
                    &direction = "itoe"
                    &from-type = "p_Type"
                    }
       Other = (IF p_Unix_Parms <> "" AND p_Unix_Parms <> ? THEN
                   p_Unix_Parms + " " ELSE "") + 
               (IF p_Network <> "" AND p_Network <> ? THEN
	           " -N " + p_Network ELSE "") +
               (IF p_Host_Name <> "" AND p_Host_Name <> ? THEN
	           " -H " + p_Host_Name ELSE "") +
	       (IF p_Service_Name <> "" AND p_Service_Name <> ? THEN
	           " -S " + p_Service_Name ELSE "").
display 
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      txt_optional
   &ENDIF
   p_PName  when p_PName <> ?
   p_LName  when p_LName <> ?
   ext_Type             
   p_Multi_User
   p_UserId
   p_Password    
   p_Trig_Loc
   p_Parm_File
   Other
   with frame connect.              

do ON ERROR UNDO,LEAVE  ON ENDKEY UNDO,LEAVE:
   enable p_PName   when qbf_p_name
          btn_Filen when qbf_p_name
          p_LName   /* when qbf_l_name */
          p_Multi_User
          p_UserId
          p_Password
          p_Trig_Loc
          btn_Filet
          p_Parm_File
          btn_Filep
          Other
          btn_OK
          btn_Cancel
          btn_Help {&WHEN_HELP}
      with frame connect.
   wait-for choose of btn_OK in frame connect OR
                                   GO of frame connect
                                   focus p_PName.
end.

hide frame connect.
return.





