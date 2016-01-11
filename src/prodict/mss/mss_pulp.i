/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/mss/mss_pulp.i

Description:
    creates the _field-definitions out of the ODBC-definitions for
    stored procedures parameters.
    
Text-Parameters:
    &data-type      Foreign data-type in PROGRESS-Notation
                    usually DICTDBG.SQLProcCols_buffer.data-type
    &extent         in the range of 0 to n
    &order-offset   gets added to the _field._order
    
Included in:            
    prodict/mss/_mss_pul.p
    
History:
    D. McMann    03/31/00   abstracted from prodict/odb/odb_pulp.i
    sgarg        06/03/10   BLOB/CLOB support in Stored Proc
    musingh      07/01/11   Map varchar(n) to char, where 1<=n<=8000
    sgarg        03/07/12   Error handling for unsupported LOBs

--------------------------------------------------------------------*/

/* this code gets executed only for the first element of array-field   */
/* so extent-code of field is always ##1 (even with real extent >= 10) */

err_sp = "WARNING: You have used unsupported OUTPUT parameters in stored " +
         "procedure definition &1 that might result in run-time errors. " +
         "Please review your stored procedure definition or use error " +
         "handling in your application on the RUN STORED-PROCEDURE statement.".

assign
  pnam = TRIM(DICTDBG.SQLProcCols_buffer.Column-name)
  pnam = ( if {&extent} > 0 AND LENGTH (pnam, "character") > 4 /* Drop the "##1" */
             then SUBSTRING (pnam, 1, LENGTH (pnam, "character") - 3, "character")
             else pnam )
  fnam = pnam
  pnam = ( if s_ttb_tbl.ds_type = "PROCEDURE"
            and pnam begins "@"
            then substring(pnam,2,-1,"character")
            else pnam
         ).

RUN "prodict/gate/_gat_fnm.p" 
    ( INPUT        "FIELD",
      INPUT        RECID(s_ttb_tbl),
      INPUT-OUTPUT pnam).

if NOT SESSION:BATCH-MODE
 then DISPLAY
   TRIM(DICTDBG.SQLProcCols_buffer.Column-name) @ msg[3]
   pnam                                        @ msg[4]
   WITH FRAME ds_make.

assign
  dtyp    = LOOKUP({&data-type},user_env[12])
  l_init  = ?
  ntyp    = ( if dtyp = 0
                then "undefined"
                else ENTRY(dtyp,user_env[15])
            )
  l_dcml  = 0
  isOutput = ?.

  /* BLOB and CLOB can be handled together */
  IF LOOKUP({&data-type}, "VARBINARY,LONGVARBINARY,VARCHAR,LONGVARCHAR,NVARCHAR,NLONGVARCHAR") > 0 THEN DO:
     IF (ntyp = "BLOB" OR ntyp = "CLOB") AND 
         DICTDBG.SQLProcCols_buffer.PRECISION >= 1 AND 
         DICTDBG.SQLProcCols_buffer.PRECISION <= 8000 THEN DO:
         /* default mapping is blob or clob, but this is a varbinary(n) or varchar (n) in which 
            case we don't support the blob or clob mapping, so must change it to
            character (which is the next mapping).
         */
         dtyp = dtyp + 1.
         ntyp = ENTRY(dtyp,user_env[15]).    
     END.
  END.


/* OE00193877 - get 'is_output' value from sys.parameters catalog view. 
 * If BLOB or CLOB and output parameter, we want to mark _fld-misc17.
 * Get the output type for CHAR also, because the server LOB types can
 * also be pulled as CHAR and mapping can be changed to CLOB 
 * from field properties dialog.
 */

IF ntyp = "BLOB" OR ntyp = "CLOB" OR ntyp = "CHARACTER" THEN DO:
   IF LOOKUP({&data-type}, "LONGVARCHAR,LONGVARBINARY,NLONGVARCHAR") > 0 OR
      (LOOKUP({&data-type}, "VARCHAR,VARBINARY,NVARCHAR") > 0 AND 
       DICTDBG.SQLProcCols_buffer.Precision = 0  AND 
       DICTDBG.SQLProcCols_buffer.Length = 0) THEN DO:
      assign
      sqlstate = "SELECT is_output FROM sys.parameters where name =  '" + 
              DICTDBG.SQLProcCols_buffer.column-name + "' and object_id = (OBJECT_ID('" +
              DICTDBG.SQLProcCols_buffer.OWNER + "." + SUBSTRING(TRIM(DICTDBG.SQLProcCols_buffer.name),1,LENGTH(trim(namevar-1))) + "'))".
   
      RUN STORED-PROC DICTDBG.send-sql-statement dfth1 = PROC-HANDLE NO-ERROR ( sqlstate ).
   
      IF NOT ERROR-STATUS:ERROR THEN DO:
        FOR EACH DICTDBG.proc-text-buffer WHERE PROC-HANDLE = dfth1:
         ASSIGN isOutput = proc-text. 
        END.
        CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = dfth1.
      END.
   END.
END.

  /* OE00203930: TEXT, IMAGE and NTEXT are not supported as Stored Procedure
   * output parameters. Could not find a way to put the error message 
   * concatenated using "+" operator  in err-msg array, so storing the
   * concatenated string in a variable and using that variable to write
   * the message in ds_upd.e, instead of call to error_handling.
   */
  IF NOT err_sp_flag AND LOOKUP({&data-type}, "LONGVARCHAR,LONGVARBINARY,NLONGVARCHAR") > 0 THEN DO:
     IF isOutput = "1" AND (ntyp = "CHARACTER" OR ntyp = "CLOB" or ntyp = "BLOB") THEN DO:
         IF (DICTDBG.SQLProcCols_buffer.type-name = "text" OR
             DICTDBG.SQLProcCols_buffer.type-name = "image" OR
             DICTDBG.SQLProcCols_buffer.type-name = "ntext") THEN DO:
               output stream s_stm_errors to ds_upd.e append.
               PUT stream s_stm_errors unformatted
                   SUBSTITUTE(err_sp, table_name)  skip.
               PUT STREAM s_stm_errors UNFORMATTED "" SKIP.
               output stream s_stm_errors close.

               /* Log the error message at procedure level, instead of 
                * parameter level.
                */ 
               assign err_sp_flag = TRUE.
         END.
     END.
  END.

CREATE s_ttb_fld.

assign
  s_ttb_fld.pro_Desc    = fld-remark
  s_ttb_fld.pro_Extnt   = {&extent}
  s_ttb_fld.pro_name    = pnam
  s_ttb_fld.ttb_tbl     = RECID(s_ttb_tbl)
  s_ttb_fld.ds_prec    = DICTDBG.SQLProcCols_buffer.Precision
  s_ttb_fld.ds_scale    = DICTDBG.SQLProcCols_buffer.Scale
  s_ttb_fld.ds_lngth    = DICTDBG.SQLProcCols_buffer.Length
  s_ttb_fld.ds_radix    = DICTDBG.SQLProcCols_buffer.Radix 
  s_ttb_fld.ds_msc17    = (if isOutput = '1' then INTEGER (isOutput)
                           else ?
                          )
  s_ttb_fld.ds_msc23    = ( if (LENGTH(quote, "character") = 1)
                             then quote + fnam + quote
                             else ?
                          )
  s_ttb_fld.ds_msc24    = fld-properties
  s_ttb_fld.ds_stoff    = field-position
  s_ttb_fld.ds_name     = fnam
  s_ttb_fld.ds_type     = {&data-type}
  s_ttb_fld.pro_order   = field-position * 10 + 1000 
                              + {&order-offset}
  s_ttb_fld.pro_mand    = ( if CAN-DO(fld-properties, "N")
                                then false
                                else (DICTDBG.SQLProcCols_buffer.Nullable = 0)
                          ).

  /* OE00235922 
    (Issue with CR# OE00165897 was also with stored procedure, hence put
    similar fix)
    
    When using the SQL Server Native driver, (MAX) columns are reported
    with precision and length as 0, and the regular data types (not the long type).
    The DataServer will set precision and length to 32000/16000 in this case,
    so we will do the same here.
   */
  CASE {&data-type}:
     WHEN "VARBINARY" OR WHEN "VARCHAR" OR WHEN "NVARCHAR" THEN DO:
        IF s_ttb_fld.ds_lngth = 0  AND s_ttb_fld.ds_prec = 0 THEN DO:
           ASSIGN s_ttb_fld.ds_lngth = 32000
                  s_ttb_fld.ds_prec = (IF my_typ_unicode THEN 16000 ELSE 32000).
        END.
    END.
  END CASE.

/*                                                             */
/* If the field is not updatable (fld-properties contains "N") */ 
/* then the field cannot be mandatory.                         */
/*                                                             */

{prodict/gate/gat_pul2.i
  &undo = "next"
  }

/*------------------------------------------------------------------*/
