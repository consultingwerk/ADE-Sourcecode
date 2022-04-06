/**********************************************************************
* Copyright (C) 2000,2007-2009 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*--------------------------------------------------------------------

File: prodict/gate/gat_pul2.i

Description:
    calculates formats and decimals of fields
    
interface:
    l_char-types    -> character, decimals = length
    l_chrw-types    -> character, decimals = ? (raw-data-types)
    l_date-types    -> date
    l_dcml-types    -> fixed point decimal
    l_floa-types    -> floating point decimal
    l_logi-types    -> logical
    l_time-types    -> time
    l_tmst-types    -> time-stamp
    
Included in:            
    prodict/odb/odb_pul.i
    prodict/ora/_ora_prc.p
    prodict/gate/gat_pul.i
    prodict/mss/mss_pul.i
    
History:
    hutegger    95/03   combined from odb, ora and syb4
    mcmann    04/13/99  Added check for intial value in integers and decimals
    mcmann    04/05/00  Modified for MSS database type.
    mcmann    07/10/02  Changed how integer's format are calculated
    mcmann    01/08/03  Added check for initial value of TODAY for Dates
    mcmann    04/09/03  Changed parameters for error message 2 to just table name
    fernando  06/12/06  Support for int64
    fernando  02/14/08  Support for datetime
    fernando  06/19/09  Support for datetime-tz

--------------------------------------------------------------------*/
if      CAN-DO(l_char-types,s_ttb_fld.ds_type)    /**** CHARACTERS ****/
 then assign
         l_dcml = s_ttb_fld.ds_lngth
         l_frmt    = ( if ENTRY(dtyp,user_env[17],"|") <> "c"
                      then ENTRY(dtyp,user_env[17],"|")
                      else "x(" + STRING(min(320,max(1,l_dcml))) + ")" 
                   ).

else if CAN-DO(l_chrw-types,s_ttb_fld.ds_type)          /**** RAWS ****/
     then assign
         l_dcml  = (if s_ttb_fld.ds_lngth = 0
                     then 8
                     else s_ttb_fld.ds_lngth
                   )
         l_frmt    = ( if ENTRY(dtyp,user_env[17],"|") <> "c"
                      then ENTRY(dtyp,user_env[17],"|")
                      else "x(" + STRING(min(320,max(1,l_dcml))) + ")" 
                   )
         l_dcml = ?.

else if CAN-DO(l_date-types,s_ttb_fld.ds_type)         /**** DATES ****/
     then do :
      assign l_dcml = ?.

      CASE ENTRY(dtyp,user_env[17],"|"):
          WHEN "d"  THEN l_frmt = "99/99/99".
          WHEN "dt" THEN l_frmt = "99/99/9999 HH:MM:SS.SSS".
          WHEN "dtz" THEN l_frmt = "99/99/9999 HH:MM:SS.SSS+HH:MM".
          OTHERWISE      l_frmt   =  ENTRY(dtyp,user_env[17],"|").
      END CASE.
end.
else if CAN-DO(l_dcml-types,s_ttb_fld.ds_type)      /**** DECIMALS ****/
     then DO:
       assign
         l_prec  = ( if s_ttb_fld.ds_radix = 2
                       then 0.30103
                       else 1
                   )
         l_dcml  = min(10,integer(s_ttb_fld.ds_scale * l_prec))
         l_prec  = integer(s_ttb_fld.ds_prec * l_prec)
         l_frmt  = ( if      ENTRY(dtyp,user_env[17],"|") = "i"
                      then "->>>>>>>>9"
                      else ENTRY(dtyp,user_env[17],"|")
                   )
         l_dcml  = ( if      ENTRY(dtyp,user_env[17],"|") = "#"
                      then l_dcml
                     else if ENTRY(dtyp,user_env[17],"|") = "i"
                      or     INDEX(l_frmt,".")            =  0
                      then 0
                      else LENGTH(l_frmt, "character") - INDEX(l_frmt,".")
                   ).

       /* description of l_prec and l_dcml; (l_prec: sign does, decimal 
        *   point doesn't count). Example:   l_prec = 18; l_dcml = 8
        *          l_prec
        *   |---------x-------|
        *   ->>>>>>>>9.99999999          [->(8)9.9(8)
        *              |------| 
        *               l_dcml
        * Maximum length of format is 30 characters (dec-point counts)
        */
       if ENTRY(dtyp,user_env[17],"|") = "#"
        then do:  /* format to generate out of ora-info */
         if l_dcml = ? then assign l_dcml = 0.
         if  l_prec = ?
          then assign    /*  ?,?  =>  ->>>>>>>>9  */
           ntyp    = ( if user_dbtype = "ORACLE"
                        then "integer"
                        else "decimal"
                     )
           l_dcml  = 0
           l_frmt  = "-"
                   + FILL(">",MINIMUM(8,s_ttb_fld.ds_lngth - 2))
                   + "9".
         else if l_prec = 1
          and    l_dcml = 0
          then assign   /* 1,0 =>  yes/no  */
           ntyp    = ( if user_dbtype = "ORACLE"
                        then "logical"
                        else "decimal"
                     )
           l_dcml  = 0
           l_frmt  = ( if user_dbtype = "ORACLE"
                        then "yes/no"
                        else "9"
                     ).
         else if l_prec <= 9
          and    l_dcml <= 0
          then assign   /* 6,-2 =>  ->>999 [->(2)9(3)] */
           i       = 1 - l_dcml
           ntyp    = ( if user_dbtype = "ORACLE"
                        then "integer"
                        else "decimal"
                     )
           l_dcml  = 0
           l_frmt  = "-"
                   + (IF i = 1 THEN FILL(">",l_prec - i)
                       ELSE FILL(">",l_prec - i - 1))
                   + FILL("9",i).
         else if l_dcml <= 0
          then assign    /* 15,-2 =>  ->>>>>>>>>>>999 [->(11)9(3)] */ 
           ntyp    = ( if user_dbtype = "ORACLE" AND l_prec <= 18
                        then "int64"
                        else "decimal"
                     )
           i       = MINIMUM(29,1 - l_dcml)
           l_dcml  = 0
           l_frmt  = "-"
                   + FILL(">",MINIMUM(29,l_prec) - i - 1)
                   + FILL("9",i).
          else assign    /* 15,2  =>  ->>>>>>>>>>>>9.99 [->(12)9.9(2)] */
           l_frmt = "-"
                  + FILL(">",MINIMUM(29,l_prec) - l_dcml - 1) 
                  + "9." 
                  + FILL("9",l_dcml).
         end.     /* format to generate out of ora-info */
       end.

else if CAN-DO(l_floa-types,s_ttb_fld.ds_type)        /**** FLOATS ****/
     then DO:
       assign
        l_prec = ( if s_ttb_fld.ds_radix = 2
                    then INTEGER(s_ttb_fld.ds_prec * 0.30103)
                    else s_ttb_fld.ds_prec
                 ).
       if      ENTRY(dtyp,user_env[17],"|")  = "i"
        then assign /* new data-type and format for INTEGER */
             l_frmt    = "->>>>>>>>9"
             l_dcml = 0.
       else if ENTRY(dtyp,user_env[17],"|") <> "#"
        then assign /* new data-type and format from _ora_typ.p */
         l_frmt    = ENTRY(dtyp,user_env[17],"|")
         l_dcml = ( if INDEX(l_frmt,".") = 0
                      then 0
                      else LENGTH(l_frmt, "character") - INDEX(l_frmt,".")
                   ).
       else if l_prec = ?
        then assign    /* ? (:=30) =>  ->>>>>>>>>>>>>>>>>>9.9<<<<<<<<< */
         l_dcml = 10
         l_frmt    = "-"
                 + FILL(">",17)
                 + "9.9" 
                 + FILL("<",l_dcml - 1).
       else if l_prec <= 22
        then assign    /* 12    =>  ->>>>>9.9<<<< */
         l_dcml = 1 + integer(l_prec / 2 - 1.6)
         l_frmt    = "-"
                 + FILL(">",l_prec - l_dcml - 2)
                 + "9.9" 
                 + FILL("<",l_dcml - 1).
        else assign    /* 26    =>  ->>>>>>>>>>>>>9.9<<<<<<<<<< */
         l_dcml = 1 + MINIMUM(9,integer(l_prec / 2 - 1.6))
         l_frmt    = "-"
                 + FILL(">",MINIMUM(17,l_prec - l_dcml - 2))
                 + "9.9" 
                 + FILL("<",l_dcml - 1).
       end.

else if CAN-DO(l_i#dl-types,s_ttb_fld.ds_type)      /**** INTEGERS ****/
     then assign
      l_frmt   = ( if    ENTRY(dtyp,user_env[17],"|") = "i"
                    then "->>>>>>>>9"
                   else if ENTRY(dtyp,user_env[17],"|") = "l"
                    then "yes/no"
                   else if ENTRY(dtyp,user_env[17],"|") = "#"
                    then "->>>>>>>>>>>>>>9"  /* ->(14)9 */
                    else ENTRY(dtyp,user_env[17],"|")
                 ).

else if CAN-DO(l_i##d-types,s_ttb_fld.ds_type)      /**** INTEGERS ****/
     then assign
      l_frmt   = ( if    ENTRY(dtyp,user_env[17],"|") = "i"
                    then "->>>>>>>>9"        /* ->(8)9 */
                   else if ENTRY(dtyp,user_env[17],"|") = "#"
                    then "->>>>>>>>>>>>>>9"  /* ->(14)9 */
                    else ENTRY(dtyp,user_env[17],"|")
                 ).

else if CAN-DO(l_i###-types,s_ttb_fld.ds_type)      /**** INTEGERS ****/
     then assign
      l_frmt   = ( if      ENTRY(dtyp,user_env[17],"|") = "i"
                    then "->>>>>>>>9"        /* ->(8)9 */
                    else ENTRY(dtyp,user_env[17],"|")
                 ).

else if CAN-DO(l_logi-types,s_ttb_fld.ds_type)      /**** LOGICALS ****/
     then assign
      l_frmt   = ( if ENTRY(dtyp,user_env[17],"|") = "l"
                    then "yes/no"
                    else ENTRY(dtyp,user_env[17],"|")
                 ).


else if CAN-DO(l_tmst-types,s_ttb_fld.ds_type)   /**** TIME-STAMPS ****/
     then do:
     assign
         l_dcml = ?.

      CASE ENTRY(dtyp,user_env[17],"|"):
          WHEN "c"  THEN l_frmt = "x(26)".
          WHEN "d"  THEN l_frmt = "99/99/99".
          WHEN "dt" THEN l_frmt = "99/99/9999 HH:MM:SS.SSS".
          WHEN "dtz" THEN l_frmt = "99/99/9999 HH:MM:SS.SSS+HH:MM".
          OTHERWISE      l_frmt   =  ENTRY(dtyp,user_env[17],"|").
      END CASE.
end.
    else do:                                    /**** OTHERWISE ****/
      run error_handling
        ( 2, 
          s_ttb_tbl.ds_name, "" 
        ).
      run error_handling ( 3, "", "" ).
      if tdbtype = "ora" THEN DO:
        FOR EACH s_ttb_fld WHERE s_ttb_fld.ttb_tbl = RECID(s_ttb_tbl):
            DELETE s_ttb_fld.
        END.
        DELETE s_ttb_tbl.
        DELETE gate-work.
        UNDO _crtloop, NEXT.
      END.
      else
       UNDO, NEXT.  /* check */         
    end.


/*------------------------------------------------------------------*/

assign
  s_ttb_fld.pro_type    = ntyp
  s_ttb_fld.pro_dcml    = l_dcml
  s_ttb_fld.pro_case    = (ntyp = "character") /* changes if shadow exists*/
  s_ttb_fld.ds_stdtype  = INTEGER(ENTRY(dtyp,user_env[14]))
  s_ttb_fld.pro_frmt    = ( if l_frmt = "?"
                             then s_ttb_fld.pro_frmt
                             else l_frmt
                          )
  s_ttb_fld.pro_init    = ( if (l_init = "?" or l_init = ?)
                             then ?
                            else if ntyp = "logical"
                             then string(l_init = "0")
                             else l_init
                          ).
  
  IF s_ttb_fld.pro_type = "INTEGER" OR s_ttb_fld.pro_type = "DECIMAL" 
    OR s_ttb_fld.pro_type = "DATE" OR s_ttb_fld.pro_type BEGINS "DATETIME" THEN 
  _init:
  DO:
    IF s_ttb_fld.pro_init = ? THEN LEAVE _init.
    ELSE IF s_ttb_fld.pro_init = "TODAY" AND s_ttb_fld.pro_type = "DATE" THEN LEAVE _init.
    ELSE IF s_ttb_fld.pro_init = "NOW" AND s_ttb_fld.pro_type BEGINS "DATETIME" THEN LEAVE _init.
    ELSE DO i = 1 to LENGTH(s_ttb_fld.pro_init):
      IF INDEX("abcdefghijklmnopqrstuvwxyz", substring(s_ttb_fld.pro_init,i,1)) > 0 THEN DO:          
        ASSIGN s_ttb_fld.pro_init = ?.
        LEAVE _init.
      END.
    END.
  END.     
/*------------------------------------------------------------------*/


