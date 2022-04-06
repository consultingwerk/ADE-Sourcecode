/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* ora_mak1.i 

Description:
    
    generates the format, initial-values and data-type-multiplicator
    depending on the old progress-data-type, the new oracle-data-type
    and the settings in _ora_typ.p 
    After that the new _field-record gets created and all the values
    assigned
    
Text-Parameters:
    &data-type  foreign data-type
    &file-name  "oracle_columns" or "oracle_arguments"

Included in:
    prodict/ora/ora_mak.i
    prodict/ora/_ora_fun.p
    
History:
    94/08/03    hutegger    creation
    
*/

CASE {&data-type}:

   WHEN    "CHAR" 
   OR WHEN "VARCHAR"
   OR WHEN "VARCHAR2"
   OR WHEN "ROWID"
     THEN DO:
       IF AVAILABLE w_field
         AND w_field.pro_dtype = "character"
         THEN ASSIGN   /* retain old format */
           l_init  = w_field.pro_initial
           num_dec = DICTDBG.{&file-name}.length_
           vfmt    = w_field.pro_Format.
         ELSE ASSIGN   /* new  format */
           num_dec = DICTDBG.{&file-name}.length_
           vfmt    = (IF ENTRY(dtyp,user_env[17],"|") <> "c"
                       THEN ENTRY(dtyp,user_env[17],"|")
                       ELSE "x(" + STRING(DICTDBG.{&file-name}.length_) + ")" ).
       END.

   WHEN    "LONG"
   OR WHEN "RAW"
   OR WHEN "LONGRAW"
     THEN DO:
       IF AVAILABLE w_field
         AND w_field.pro_dtype = "character"
         THEN ASSIGN   /* retain old format */
           l_init = w_field.pro_initial
           vfmt   = w_field.pro_Format.
         ELSE ASSIGN   /* new  format */
           vfmt   = (IF ENTRY(dtyp,user_env[17],"|") <> "c"
                       THEN ENTRY(dtyp,user_env[17],"|")
                       ELSE "x(" + (IF DICTDBG.{&file-name}.length_ = 0
                                      THEN "8"
                                      ELSE STRING(DICTDBG.{&file-name}.length_)) + ")" ).
       END.

   WHEN "NUMBER" 
     THEN DO:
       ASSIGN num_dec = 0.
       IF AVAILABLE w_field
         AND CAN-DO("decimal,integer,logical",w_field.pro_dtype)
         THEN ASSIGN   /* retain old data-type and old format */
           l_init  = w_field.pro_initial
           ntyp    = w_field.pro_dtype
           num_dec = w_field.pro_Decimals
           vfmt    = w_field.pro_Format.
         ELSE IF ENTRY(dtyp,user_env[17],"|") <> "#"
           THEN ASSIGN /* new data-type and format from _ora_typ.p */
             vfmt  = ENTRY(dtyp,user_env[17],"|")
             num_dec = ( IF INDEX(vfmt,".") = 0
                           THEN 0
                           ELSE LENGTH(vfmt,"character") - INDEX(vfmt,".")
                       ).
         ELSE IF DICTDBG.{&file-name}.scale      = ?
           OR    DICTDBG.{&file-name}.precision_ = ?
           THEN ASSIGN /* new data-type and new format */
             ntyp  = "integer"
             vfmt  = "-"    /*  ?,?  =>  ->>>>>>>>9  */ 
                   + FILL(">",MINIMUM(8,DICTDBG.{&file-name}.length_ - 1))
                   + "9".
         ELSE IF DICTDBG.{&file-name}.precision_ <= 9
           AND   DICTDBG.{&file-name}.scale      <= 0
           THEN ASSIGN /* new data-type and new format */
             i     = 1 - DICTDBG.{&file-name}.scale
             ntyp  = "integer"
             vfmt  = "-"    /*  5,-2  =>  ->>999           */ 
                   + FILL(">",DICTDBG.{&file-name}.precision_ - i)
                   + FILL("9",i).
         ELSE IF DICTDBG.{&file-name}.scale <= 0
           THEN ASSIGN
             i     = MINIMUM(29,1 - DICTDBG.{&file-name}.scale)
             vfmt  = "-"    /* 15,-2 =>  ->>>>>>>>>>>>999  */ 
                   + FILL(">",MINIMUM(29,DICTDBG.{&file-name}.precision_) - i)
                   + FILL("9",i).
           ELSE ASSIGN
             num_dec = MINIMUM(10,DICTDBG.{&file-name}.scale)
             i       = DICTDBG.{&file-name}.precision_ 
                     - DICTDBG.{&file-name}.scale
                     + num_dec
             vfmt    = "-"    /* 15,2  =>  ->>>>>>>>>>>>9.99 */
                     + FILL(">",MINIMUM(29,i) - num_dec - 2)
                     + "9." 
                     + FILL("9",num_dec).
       END.
      
   WHEN "FLOAT"
     THEN DO:
       ASSIGN j = INTEGER(DICTDBG.{&file-name}.precision_ * 0.30103).
       IF AVAILABLE w_field
         AND w_field.pro_dtype = "decimal"
         THEN ASSIGN   /* retain old data-type and old format */
           l_init  = w_field.pro_initial
           num_dec = w_field.pro_Decimals
           vfmt    = w_field.pro_Format.
         ELSE IF ENTRY(dtyp,user_env[17],"|") <> "#"
           THEN ASSIGN /* new data-type and format from _ora_typ.p */
             vfmt    = ENTRY(dtyp,user_env[17],"|")
             num_dec = ( IF INDEX(vfmt,".") = 0
                           THEN 0
                           ELSE LENGTH(vfmt,"character") - INDEX(vfmt,".")
                       ).
         ELSE IF j = ?
           THEN ASSIGN /* new data-type and new format */
             num_dec = 10
             vfmt    = "-"    /* ? (:=30) =>  ->>>>>>>>>>>>>>>>>9.9<<<<<<<<<< */
                     + FILL(">",17)
                     + "9.9" 
                     + FILL("<",9).
         ELSE IF j <= 22
           THEN ASSIGN /* new data-type and new format */
             num_dec = 1 + INTEGER(j / 2 - 1.6)
             vfmt    = "-"    /* 12    =>  ->>>>>9.9<<<< */
                     + FILL(">",j - num_dec - 2)
                     + "9.9" 
                     + FILL("<",num_dec - 1).
           ELSE ASSIGN
             num_dec = 1 + MINIMUM(9,INTEGER(j / 2 - 1.6))
             vfmt    = "-"    /* 26    =>  ->>>>>>>>>>>>>9.9<<<<<<<<<< */
                     + FILL(">",MINIMUM(17,j - num_dec - 2))
                     + "9.9" 
                     + FILL("<",num_dec - 1).
       END.

   WHEN "LOGICAL"
     THEN DO:
       IF AVAILABLE w_field
         AND w_field.pro_dtype = "logical"
         THEN ASSIGN   /* retain old data-type and old format */
           l_init = w_field.pro_initial
           vfmt   = w_field.pro_Format.
         ELSE ASSIGN   /* new format */
           vfmt   = (IF ENTRY(dtyp,user_env[17],"|") = "l"
                       THEN "yes/no"
                       ELSE ENTRY(dtyp,user_env[17],"|")
                    ).
       END.
      
   WHEN "DATE"
     THEN DO:
       IF AVAILABLE w_field
         AND w_field.pro_dtype = "date"
         THEN ASSIGN   /* retain old data-type and old format */
           l_init = w_field.pro_initial
           vfmt   = w_field.pro_Format.
         ELSE ASSIGN   /* new format */
           vfmt   = (IF ENTRY(dtyp,user_env[17],"|") = "d"
                       THEN "99/99/99"
                       ELSE ENTRY(dtyp,user_env[17],"|")
                    ).
       END.
      
   WHEN    "TIME"
     THEN DO:
       IF AVAILABLE w_field
         AND w_field.pro_dtype = "integer"
         THEN ASSIGN   /* retain old format */
           l_init = w_field.pro_initial
           vfmt   = w_field.pro_Format.
         ELSE ASSIGN   /* new format */
           vfmt   = (IF ENTRY(dtyp,user_env[17],"|") = "i"
                       THEN "->>>>>>>>9"
                       ELSE ENTRY(dtyp,user_env[17],"|")
                    ).
       END.

   OTHERWISE DO:
       message "Oracle data-type " {&data-type} " is not supported!"  skip
               "skipping this field ..."
               view-as alert-box error buttons ok.
       UNDO, {&undo}.  /* check */        
       END.
   END CASE.   
  
ASSIGN
  DICTDB._Field._Data-type    = ntyp
  DICTDB._Field._Decimals     = num_dec
  DICTDB._Field._Fld-case     = (ntyp = "character") /* could change lateron! */
  DICTDB._Field._Fld-stdtype  = INTEGER(ENTRY(dtyp,user_env[14]))
  DICTDB._Field._Format       = ( IF vfmt = "?" or vfmt = ?
                                    THEN DICTDB._Field._Format
                                    ELSE vfmt ).

IF AVAILABLE w_field
  THEN DO:
    ASSIGN
      DICTDB._Field._Can-Read     = w_field.pro_Can-Read
      DICTDB._Field._Can-Write    = w_field.pro_Can-Writ
      DICTDB._Field._Col-label    = w_field.pro_Col-lbl
      DICTDB._Field._Fld-case     = (ntyp = "character" 
                                        AND w_field.pro_Fld-case)
      DICTDB._Field._Help         = w_field.pro_Help
      DICTDB._Field._Initial      = (IF l_init <> "?" AND l_init <> ? 
                                        THEN l_init
                                        ELSE DICTDB._Field._Initial)
      DICTDB._Field._Label        = w_field.pro_Label
      DICTDB._Field._Mandatory    = ( DICTDB._Field._Mandatory
                                   OR w_field.pro_Mandatory )
      DICTDB._Field._Valexp       = w_field.pro_Valexp
      DICTDB._Field._Valmsg       = w_field.pro_Valmsg.
    DELETE w_field. /* save memory! */
    END.

/*----------------------------------------------------------------------*/    
