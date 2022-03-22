/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/gate/ttygget.i

Description:
    
    User-Interface for _xxx_get.p-programs
    
    Displays all gate-work-records and lets user select and deselect
            
Text-Parameters:
    &autocond   condition for NOT automatically select gate-work
    &db-type    internal db-type variable ("oracle", edbtyp, ...)
    &gq         "gate-qual" or ""
    
Included in:
    odb/_odb_get.p
    ora/ora_get.i
    syb/syb_getp.i
    
History:
    hutegger    94/08/03    created out of syb-, ora- and odb_get.p
    McMann      98/07/13    Added _Owner to _File finds
    
--------------------------------------------------------------------*/        
/*h-*/



SESSION:IMMEDIATE-display = no.
hide frame gate_wait no-pause.


{prodict/gate/nogatwrk.i
  &block    = "{&block} "
  &end      = "{&end} "
  &clean-up = {&clean-up}
  } /* message and leave */
assign inc_qual = (IF gate-qual = "" THEN no else yes).


/*----------------------------------------------------------------------*/
/*                          table selection                             */
/*----------------------------------------------------------------------*/

if user_env[25] begins "AUTO"
 then do:   /*========= automatically select all possible tables =======*/
  for each gate-work    /*===== but exclude system-tables =====*/
    {&autocond}: 
    assign gate-flag = yes.
    end.
  end.      /*========= automatically select all possible tables =======*/

 else do:   /*=========== let user select the tables he wants ==========*/
   
  &IF "{&WINDOW-SYSTEM}" <> "TTY" 
   &THEN
     RUN "prodict/gui/_guigget.p" (INPUT {&db-type}).
     canned = (if RETURN-VALUE = "cancel" then yes else no).
   &ELSE     /*----------------TTY only---------------------------------*/
    display
      "[" + KBLABEL("RETURN") + "].  " + new_lang[2] + " [" + KBLABEL("GO") + "] "
        + new_lang[3] + " [" + KBLABEL("END-ERROR") + "] " + new_lang[4] + "."
        @ hint
      "[" + KBLABEL("GET") + "] " + new_lang[5] + " [" + KBLABEL("PUT") + "] "
        + new_lang[6] + "."
        @ c
      with frame gate_not.

    if "{&gq}" <> "" AND inc_qual = TRUE
     then assign lab-qual = "Qualifier:".

    pause 0.
    VIEW frame gate_tbl.

    do with frame gate_tbl:

      find first gate-work no-error.

      do while TRUE:

        if redraw
         then do:
          assign
            rpos1 = (if available gate-work then gate-name  else ?)
            rpos2 = (if available gate-work then gate-user  else ?)
            rpos3 = (if available gate-work then gate-qual  else ?)
            j     = (if frame-line = 0 then 1  else frame-line).
          up j - 1.
          if j > 1 then do i = 2 TO j while available gate-work:
            find prev gate-work no-error.
            end.
          if NOT available gate-work
           then do:
            find first gate-work no-error.
            j = 1.
            end.
          do i = 1 to frame-down:
            COLOR display NORMAL
              gate-flag gate-user gate-name gate-type {&gq}.
            if available gate-work
             then display gate-flag gate-user gate-name gate-type {&gq}.
             else clear no-pause.
            down.
            if available gate-work then find next gate-work no-error.
            end.
          if rpos1 <> ?
           then find first gate-work 
              where gate-name = rpos1
              and   gate-user = rpos2
              and   gate-qual = rpos3.
          up frame-down - j + 1.
          assign
            xld    = 0
            redraw = FALSE.
          end.

        if xld <> frame-line and xld <> 0
         then do:
          j = frame-line.
          up frame-line - xld.
          COLOR display NORMAL 
            gate-flag gate-user gate-name gate-type {&gq}.
          up frame-line - j.
          end.
        if xld <> frame-line
         then COLOR display MESSAGES 
            gate-flag gate-user gate-name gate-type {&gq}.
        READKEY.
        pause 0.
        xld = frame-line.

        if  can-do("GO,END-ERROR",keyfunction(lastkey))
         or CHR(lastKEY) = "."
         then LEAVE.
        if NOT available gate-work
         then next.

        if CHR(lastKEY) > " "
         then do:
          assign
            rpos1 = (if available gate-work then gate-name  else ?)
            rpos2 = (if available gate-work then gate-user  else ?)
            rpos3 = (if available gate-work then gate-qual  else ?).
          find first gate-work
            where gate-name BEGINS hint + CHR(lastKEY)
            no-error.
          if available gate-work
           then hint = hint + CHR(lastKEY).
           else do:
            hint = CHR(lastKEY).
            find first gate-work
              where gate-name BEGINS hint
              no-error.
            end.
          if available gate-work
           then do:  /* frame repaint optimization is here */
            down frame-down - frame-line.
            do while frame-line > 1:
              if   INPUT gate-name = gate-name
               and INPUT gate-user = gate-user
               and INPUT gate-type = gate-type
               and INPUT gate-qual = gate-qual
               then LEAVE.
              up.
              end.
            redraw = ( INPUT gate-name <> gate-name 
                    or INPUT gate-user <> gate-user
                    or INPUT gate-type <> gate-type
                    or INPUT gate-qual <> gate-qual
                     ).
            end.     /* frame repaint optimization is here */
           else find first gate-work 
              where gate-name = rpos1
              and   gate-user = rpos2
              and   gate-qual = rpos3
              no-error.
          end.

        else if can-do("RETURN,CURSOR-DOWN,TAB, ",keyfunction(lastkey))
         then do:
          if   keyfunction(lastkey) = "RETURN"
           and available gate-work
           then do:
            gate-flag = NOT gate-flag.
            display gate-flag.
            end.
          find next gate-work no-error.
          if available gate-work
           then do:
            COLOR display NORMAL
              gate-flag gate-user gate-name gate-type {&gq}.
            if frame-line = frame-down
             then SCROLL up.
             else down.
            COLOR display MESSAGES
              gate-flag gate-user gate-name gate-type {&gq}.
            display gate-flag gate-user gate-name gate-type {&gq}.
            xld = frame-line.
            end.
           else
            find last gate-work no-error.
          end.

        else if can-do("CURSOR-UP,BACK-TAB,BACKSPACE",keyfunction(lastkey))
         then do:
          find prev gate-work no-error.
          if available gate-work
           then do:
            COLOR display NORMAL
              gate-flag gate-user gate-name gate-type {&gq}.
            if frame-line = 1
             then SCROLL down.
             else up.
            COLOR display MESSAGES
              gate-flag gate-user gate-name gate-type {&gq}.
            display gate-flag gate-user gate-name gate-type {&gq}.
            xld = frame-line.
            end.
           else find first gate-work no-error.
          end.

        else if keyfunction(lastkey) = "PAGE-DOWN"
         then do:
          do i = 1 to frame-down while available gate-work:
            find next gate-work no-error.
            end.
          if NOT available gate-work
           then do:
            find last gate-work no-error.
            down frame-down - frame-line.
            end.
          redraw = TRUE.
          end.

        else if keyfunction(lastkey) = "PAGE-UP"
         then do:
          do i = 1 to frame-down while available gate-work:
            find prev gate-work no-error.
            end.
          if NOT available gate-work then do:
            find first gate-work no-error.
            up frame-line - 1.
            end.
          redraw = TRUE.
          end.
        
        else if can-do("MOVE,HOME,END",keyfunction(lastkey))
         then do:
          assign
            rpos1 = (if available gate-work then gate-name  else ?)
            rpos2 = (if available gate-work then gate-user  else ?)
            rpos3 = (if available gate-work then gate-qual  else ?).
          up frame-line - 1.
          find first gate-work no-error.
          if   gate-name = rpos1
           and gate-user = rpos2
           and gate-qual = rpos3
           then do:
            find last gate-work no-error.
            down frame-down - frame-line.
            end.
          redraw = TRUE.
          end.
        
        else if can-do("GET,PUT",keyfunction(lastkey))
         then do with frame gate_match:
          assign
            l        = keyfunction(lastkey) = "GET"
            pat-name = "*"
            pat-qual = "*".
 
          if pat-user = ""
           then do:
            assign  
              pat-user = USERID(user_dbname) 
              i        = INDEX(pat-user,"@").
        /* sqlnet-usernames are <userid>@<drive-machine...>         */
        /*   if @ contained in userid and we can-find a table with  */
        /*   the cut userid we use the cut userid as default-value  */
            if i > 0 and can-find(first gate-work 
                   where gate-user matches substring(pat-user, 1, i - 1))
              then assign pat-user = substring(pat-user, 1, i - 1).
            end.  

          pause 0.
          display l lab-qual.
          do ON ERROR undo, leave ON ENDKEY undo, leave:
            if "{&gq}" = ""
             or not inc_qual
             then update pat-name pat-user.
             else update pat-name pat-user pat-qual.
            end.
          redraw = keyfunction(lastkey) <> "END-ERROR".
          if redraw then for each gate-buff
            where can-do(pat-name,gate-name) 
            and   can-do(pat-user,gate-user)
            and   gate-qual matches (if "{&gq}" <> ""
                                        and inc_qual 
                                        then pat-qual
                                        else ""):
            gate-flag = l.
            end.
          hide frame gate_match no-pause.
          end.

        end.
      end.
    canned = ( if keyfunction(lastkey) = "GO"
                then no
                else yes
             ).
    &ENDIF /*----------------TTY only---------------------------------*/

  end.     /*=========== let user select the tables he wants ==========*/

/*----------------------------------------------------------------------*/
/*                           create user_env[1..4]                      */
/*----------------------------------------------------------------------*/

if NOT canned
 then do TRANSACTION:

  for each gate-work
    where gate-work.gate-flag = TRUE
    and   gate-work.gate-prog = ?:
    gate-work.gate-prog = gate-work.gate-name.
    RUN "prodict/gate/_gat_xlt.p"
      (TRUE,drec_db,INPUT-OUTPUT gate-work.gate-prog).
    /* In order to keep from assigning duplicate default names in
    the event identical foreign names (for different userids) exist,
    create dummy _file records long enough to assign all necessary
    Progress names.  Yes, this is a hack. */
    create _File.
    assign
      _File._File-name = gate-work.gate-prog
      _File._Db-recid  = drec_db
      _File._For-type  = "TEMPORARY".
    end.

  for each _File 
    where _Db-recid = drec_db
      and (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") 
    and   _For-type = "TEMPORARY":
    delete _File.
    end.

  assign
    user_env[1] = ""
    user_env[2] = ""
    user_env[3] = ""
    user_env[4] = ""
    user_env[5] = "".
  for each gate-work
    where gate-work.gate-flag
    by    gate-work.gate-name DESCENDING:
    assign
      user_env[1] = gate-name + "," + user_env[1]
      user_env[2] = gate-type + "," + user_env[2]
      user_env[3] = gate-user + "," + user_env[3]
      user_env[4] = gate-prog + "," + user_env[4]
      user_env[5] = gate-qual + "," + user_env[5].
    end.

  end.     /* TRANSACTION */

if canned then assign user_path = "".

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   hide frame gate_not no-pause.
   hide frame gate_tbl no-pause.
&ENDIF

RUN adecomm/_setcurs.p ("").

RETURN.
