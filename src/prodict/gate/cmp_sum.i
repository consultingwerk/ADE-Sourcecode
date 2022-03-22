/*********************************************************************
* Copyright (C) 2000,2008 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/gate/cmp_sum.i

Description:
    generates the report and puts it into gate-work.gate-edit. If there
    were severe differences (l_sev-msg <> "") then it also initializes 
    gate-work.gate-flag with YES

        
Text-Parameters:
    &object    s_ttb_{seq|tbl}  

Included in:
    gate/_gat_cmp.p

History:
    hutegger    95/03   creation
    mcmann   06/04/02   Added output to file logic
    fernando 02/22/08   Output internal retained info mismatch
    
--------------------------------------------------------------------*/        
/*h-*/

  IF l_sev-msg = "" and l_int-msg = "" and l_ret-msg = "" AND l_ret2-msg = "" and l_reti-msg = "" AND l_min-msg = "" THEN DO:
    IF NOT s_outf THEN
      ASSIGN gate-work.gate-edit = gate-work.gate-edit 
                                 + "Object: " + s_ttb_{&object}.pro_name
                                 + chr(9) + "(" + s_ttb_{&object}.ds_type + " - "
                                 + ( if    edbtyp <> "ORACLE"
                                     and  s_ttb_{&object}.ds_spcl <> ""
                                     and  s_ttb_{&object}.ds_spcl <> ?
                                     then s_ttb_{&object}.ds_spcl + "."
                                     else "" )
                                 + s_ttb_{&object}.ds_user + "."  
                                 + s_ttb_{&object}.ds_name
                                 + ( if   edbtyp = "ORACLE"
                                      and s_ttb_{&object}.ds_spcl <> ""
                                      and s_ttb_{&object}.ds_spcl <> ?
                                      then "@" + s_ttb_{&object}.ds_spcl
                                      else "" )
                                 + ")" + chr(10) + chr(10) 
                                 + l_no-diff.
    ELSE DO:
      OUTPUT STREAM comp_e TO VALUE(dbcomp_e) APPEND.
      PUT STREAM comp_e UNFORMATTED substring(l_no-diff,6) SKIP.
      PUT STREAM comp_e UNFORMATTED "  Object: "  s_ttb_{&object}.pro_name "(" s_ttb_{&object}.ds_type " ".
      IF edbtyp <> "ORACLE" THEN DO:
        IF s_ttb_{&object}.ds_spcl <> "" and  s_ttb_{&object}.ds_spcl <> ? THEN
          PUT STREAM comp_e UNFORMATTED  s_ttb_{&object}.ds_spcl  "." s_ttb_{&object}.ds_user "." s_ttb_{&object}.ds_name ")" SKIP(1). 
        ELSE
          PUT STREAM comp_e UNFORMATTED s_ttb_{&object}.ds_user "." s_ttb_{&object}.ds_name ")" SKIP(1).
      END.
      ELSE DO:   
        IF s_ttb_{&object}.ds_spcl <> "" and s_ttb_{&object}.ds_spcl <> ? then     
          PUT STREAM comp_e UNFORMATTED s_ttb_{&object}.ds_user "." s_ttb_{&object}.ds_name 
                                           "@" s_ttb_{&object}.ds_spcl ")" SKIP(1).
        ELSE
          PUT STREAM comp_e UNFORMATTED s_ttb_{&object}.ds_user "." s_ttb_{&object}.ds_name ")" SKIP (1).   
      END.
      OUTPUT STREAM comp_e CLOSE.    
    END.
  END.
  ELSE DO: 
    IF NOT s_outf THEN DO:
      ASSIGN gate-work.gate-edit = "Object: " + s_ttb_{&object}.pro_name
                 + chr(9) + "(" + s_ttb_{&object}.ds_type + " - "
                 + ( if    edbtyp <> "ORACLE"
                     and  s_ttb_{&object}.ds_spcl <> ""
                     and  s_ttb_{&object}.ds_spcl <> ?
                     then s_ttb_{&object}.ds_spcl + "."
                     else "")
                 + s_ttb_{&object}.ds_user + "."  
                 + s_ttb_{&object}.ds_name
                 + ( if   edbtyp = "ORACLE"
                    and s_ttb_{&object}.ds_spcl <> ""
                    and s_ttb_{&object}.ds_spcl <> ?
                    then "@" + s_ttb_{&object}.ds_spcl
                    else "")
                 + ")" + chr(10) + chr(10)
                 + ( if  l_sev-msg <> ""
                     or l_int-msg <> ""
                     then l_shupd-msg
                     else "")
                 + ( if l_sev-msg <> ""
                     then l_sev-msg-txt + chr(10) + l_sev-msg + chr(10)
                     else "")
                 + ( if l_int-msg <> ""
                     then l_int-msg-txt + chr(10) + l_int-msg + chr(10)
                      else "").

      IF l_ret-msg <> "" OR l_ret2-msg <> "" OR l_reti-msg <> "" THEN 
        ASSIGN gate-work.gate-edit = gate-work.gate-edit + l_ret-msg-txt + CHR(10) 
                 + ( if l_ret-msg <> ""
                     then  l_ret-msg + chr(10)
                     else "")
                 + ( IF l_ret2-msg <> ""
                     THEN  l_ret2-msg + chr(10)
                     else "")
                 + ( IF l_reti-msg <> ""
                     THEN  l_reti-msg + chr(10)
                     else "").
      ASSIGN gate-work.gate-edit = gate-work.gate-edit
                 + ( if l_min-msg <> ""
                     then l_min-msg-txt + chr(10) + l_min-msg + chr(10)
                     else "")
                 + chr(10)
            
             gate-work.gate-flag = ( l_sev-msg <> ""
                                    or l_int-msg <> "" )
             gate-work.gate-flg2 = ( l_sev-msg <> ""
                                    or l_int-msg <> ""
                                    or l_ret-msg <> "" 
                                    OR l_ret2-msg <> ""
                                    OR l_reti-msg <> "").
      

    END.
    ELSE DO:   
      OUTPUT STREAM comp_e TO VALUE(dbcomp_e) APPEND.
       
      PUT STREAM comp_e UNFORMATTED "Object: "  s_ttb_{&object}.pro_name  " ("  s_ttb_{&object}.ds_type.
      IF edbtyp <> "ORACLE" and  s_ttb_{&object}.ds_spcl <> ""
                            and  s_ttb_{&object}.ds_spcl <> ? THEN 
        PUT STREAM comp_e UNFORMATTED   " - " s_ttb_{&object}.ds_spcl  "." s_ttb_{&object}.ds_user  "."  s_ttb_{&object}.ds_name.
      IF edbtyp = "ORACLE" and  s_ttb_{&object}.ds_spcl <> ""
                           and  s_ttb_{&object}.ds_spcl <> ? THEN
        PUT STREAM comp_e UNFORMATTED   " - " "@"  s_ttb_{&object}.ds_spcl.
      PUT STREAM comp_e UNFORMATTED ")" SKIP(1).
      IF  l_sev-msg <> "" or l_int-msg <> "" then 
        PUT STREAM comp_e UNFORMATTED l_shupd-msg SKIP.
      IF l_sev-msg <> "" THEN DO:
        PUT STREAM comp_e UNFORMATTED l_sev-msg-txt SKIP.
        PUT STREAM comp_e UNFORMATTED l_sev-msg SKIP.
      END.
      IF l_int-msg <> "" THEN 
        PUT STREAM comp_e UNFORMATTED l_int-msg-txt SKIP.
      IF l_ret-msg <> "" OR l_ret2-msg <> "" OR l_reti-msg <> "" THEN DO:
        PUT STREAM comp_e UNFORMATTED  l_ret-msg-txt SKIP.
        IF l_ret-msg <> "" THEN
          PUT STREAM comp_e UNFORMATTED l_ret-msg SKIP.
        IF l_ret2-msg <> "" THEN          
          PUT STREAM comp_e UNFORMATTED l_ret2-msg SKIP.
        IF l_reti-msg <> "" THEN 
          PUT STREAM comp_e UNFORMATTED l_reti-msg SKIP.
      END.
      IF l_min-msg <> "" THEN DO: 
        PUT STREAM comp_e UNFORMATTED l_min-msg-txt SKIP.
        PUT STREAM comp_e UNFORMATTED l_min-msg SKIP(1).
      END.
      PUT STREAM comp_e UNFORMATTED "( SH = Schema Holder  NS = Native Schema )" SKIP(2).
      ASSIGN dif-found = TRUE.
      OUTPUT STREAM comp_e CLOSE.
    END.
  END.

/*------------------------------------------------------------------*/
