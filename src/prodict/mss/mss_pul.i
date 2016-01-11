/*********************************************************************
* Copyright (C) 2007-2010 by Progress Software Corporation. All      *
* rights reserved. Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/mss/mss_pul.i

Description:
    creates the _field-definitions out of the ODBC-definitions
    
Text-Parameters:
    &data-type      Foreign data-type in PROGRESS-Notation
                    usually DICTDBG.SQLColumns_buffer.data-type
    &extent         in the range of 0 to n
    &order-offset   gets added to the _field._order
    
Included in:            
    prodict/mss/_mss_pul.p
    
History:
   D. McMann  03/31/00 Created from odb/odb_pul.i
   D. McMann  05/15/01 Added check for differences between precision and
                         length
   D. McMann  10/24/02 Added check for Identity field to remove mandatory flag
                       and mark _Field._Fld-Misc2[4] as "identity"
                       
   D. McMann  01/08/03 Added logic to find default value for initial value
   fernando   09/11/07 Fixing issue with Initial when not Unicode case - OE00157726
   knavneet   11/14/07 Fixing issue with numeric default for char column - OE00127261
   fernando   02/14/08 Support for datetime
   fernando   04/08/08 Handle MAX field with Native driver - OE00165897
   fernando   08/18/08 Check default value for date/time - OE00167581
   fernando   08/25/08 Increase column size for default processing
   Nagaraju   02/23/09 to handle timestamp field properly
   fernando   04/06/09 Support for SYSDATETIME as datetime2's default value
   sgarg      05/22/09 ROWGUID support for MSS
   knavneet   02/17/10 OE00131234 
--------------------------------------------------------------------*/

DEFINE VARIABLE my_typ_unicode AS LOGICAL.

/* this code gets executed only for the first element of array-field   */
/* so extent-code of field is always ##1 (even with real extent >= 10) */
assign
  pnam = TRIM(DICTDBG.SQLColumns_buffer.Column-name)
  pnam = ( if {&extent} > 0 AND LENGTH (pnam, "character") > 3 /* Drop the "##1" */
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
   TRIM(DICTDBG.SQLColumns_buffer.Column-name) @ msg[3]
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
  isFileStream = ?.

  IF ntyp = "DATE" THEN DO:
      IF DICTDBG.SQLColumns_buffer.type-name = "datetime2" THEN DO:
          /* datetime2 default mapping is datetime, which is the next entry */
          dtyp = dtyp + 1.
          ntyp = ENTRY(dtyp,user_env[15]).
      END.
  END.

  IF LOOKUP({&data-type}, "VARBINARY,LONGVARBINARY") > 0 THEN DO:

     IF ntyp = "BLOB" AND 
         DICTDBG.SQLColumns_buffer.PRECISION >= 1 AND 
         DICTDBG.SQLColumns_buffer.PRECISION <= 8000 THEN DO:
         /* default mapping is blob, but this is a varbinary(n) in which 
            case we don't support the blob mapping, so must change it to
            character (which is the next mapping).
         */
         dtyp = dtyp + 1.
         ntyp = ENTRY(dtyp,user_env[15]).    
     END.
     ELSE IF foreign_dbms_version > 9 THEN DO:
          /* if MSS 2008 and varbinary(max) field, need to find out if filestream
             is set for field so we don't default it to character in the schema
             image. 
          */
          /* OE00183878 - get 'is_filestream' value from sys.columns catalog view */
          ASSIGN sqlstate = "SELECT is_filestream FROM sys.columns where name =  '" + 
                      DICTDBG.SQLColumns_buffer.column-name + "' and object_id = (OBJECT_ID('" +
                      DICTDBG.SQLColumns_buffer.OWNER + "." + DICTDBG.SQLColumns_buffer.NAME + "'))".
        
          RUN STORED-PROC DICTDBG.send-sql-statement dfth1 = PROC-HANDLE NO-ERROR ( sqlstate ).
        
          IF ERROR-STATUS:ERROR THEN. /*Don't do anything inital value already set to unknown */
          ELSE DO:
            FOR EACH DICTDBG.proc-text-buffer WHERE PROC-HANDLE = dfth1:
                ASSIGN isFileStream = proc-text. 
            END.
            CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = dfth1.
          END.
        
          /* if ntyp is not character, it must be blob, and we already have the right
             mapping, so don't need to do anything with it.
          */
          IF ntyp = "CHARACTER" AND isFileStream = '1' THEN DO:
              /* filestream only supported mapping is blob, which is the next entry */
              dtyp = dtyp + 1.
              ntyp = ENTRY(dtyp,user_env[15]).    
          END.
      END.
  END.

/* check if the column type is any of the Unicode data types */
ASSIGN my_typ_unicode =  ({&data-type} = "NVARCHAR" 
                          OR {&data-type} = "NCHAR"
                          OR {&data-type} = "NLONGVARCHAR").

/* To get the default value for the field, we need to see if one has been created in SQL Server */
/* only cast it to NVARCHAR if this is a Unicode type column, in which case
   we are assumed to have utf-8 as the schema codepage. Otherwise, we will only
   be able to read the first character out of the proc-text
*/
/* OE00168292 - use max column size for given type so we can handle big values */
ASSIGN sqlstate = "select CAST(text AS " + 
      (IF my_typ_unicode THEN "nvarchar(4000)" ELSE "varchar(8000)") +
       ") from syscomments where id = (select cdefault from syscolumns " + 
       "where syscolumns.id = (OBJECT_ID('" + DICTDBG.SQLColumns_buffer.OWNER + "." + 
       DICTDBG.SQLColumns_buffer.NAME + "')) and syscolumns.name = '" + 
       DICTDBG.SQLColumns_buffer.column-name + "')".

esc-idx1 = 0.

RUN STORED-PROC DICTDBG.send-sql-statement dfth1 = PROC-HANDLE NO-ERROR ( sqlstate ).

IF ERROR-STATUS:ERROR THEN. /*Don't do anything inital value already set to unknown */
ELSE DO:
  FOR EACH DICTDBG.proc-text-buffer WHERE PROC-HANDLE = dfth1:

     IF my_typ_unicode THEN /* check if initial has Unicode chars */
        esc-idx1 = INDEX(proc-text, "'(N''").

     IF esc-idx1 = 1 THEN DO:
         esc-idx1 = esc-idx1 + 5.
         esc-idx2 = R-INDEX(proc-text, "'')'").
         IF esc-idx1 > 0  AND esc-idx2 > esc-idx1 THEN 
                 l_init = SUBSTR(proc-text, esc-idx1, esc-idx2 - esc-idx1, "character").
     END. 
     ELSE /* non-Unicode case */
         ASSIGN l_init = proc-text. 

  END.
  CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = dfth1.
END.

IF l_init <> ? THEN DO:
  ASSIGN l_init = TRIM(l_init).
  /* OE00167581 - check default for date/time field */
  IF (ntyp = "DATE" OR ntyp = "DATETIME" OR ntyp = "DATETIME-TZ") AND 
      (INDEX(l_init,"GETDATE") = 0 AND INDEX(l_init,"SYSDATETIME") = 0) THEN
      ASSIGN l_init = ?. /* if not getdate/sysdatetime, we can't handle it */
  ELSE IF ntyp = "DATE" THEN 
      ASSIGN l_init = "TODAY".
  ELSE IF ntyp = "DATETIME" OR  ntyp = "DATETIME-TZ" THEN
      ASSIGN l_init = "NOW".
  /* OE00131234 - If a CHARACTER column in MSS database has a default of 
     NULL then l_init =  "'(NULL)'" */
  ELSE IF ntyp = "CHARACTER" AND l_init EQ "'(NULL)'" THEN
     ASSIGN l_init = ?.
  ELSE DO: 

      IF esc-idx1 = 0 THEN DO:
          /* if this is a function based default (in which case it won't contain
             parenthesis), we will not take it. We will
             assign the unknow value like we did in previous version 
          */
          IF INDEX(l_init, "(") > 0 THEN DO:
              IF ntyp = "character" AND SUBSTRING(l_init,2,1) = '~'' THEN 
                ASSIGN l_init = SUBSTRING(l_init, (INDEX(l_init, "(") + 3))
                       l_init = SUBSTRING(l_init, 1, (INDEX(l_init, ')') - 3)) .
              ELSE
                ASSIGN l_init = TRIM(TRIM(TRIM(TRIM(l_init,'~''),'('),')'),'~'').

              /* OE00186472 - don't allow the newid function */
              IF l_init BEGINS 'newid(' THEN
                 l_init = ?.
          END.
          ELSE
              ASSIGN l_init = ?.
      END.
  END.
END.

CREATE s_ttb_fld.

assign
  s_ttb_fld.pro_Desc    = fld-remark
  s_ttb_fld.pro_Extnt   = {&extent}
  s_ttb_fld.pro_name    = pnam
  s_ttb_fld.ttb_tbl     = RECID(s_ttb_tbl)
  s_ttb_fld.ds_prec    = DICTDBG.SQLColumns_buffer.Precision
  s_ttb_fld.ds_scale    = DICTDBG.SQLColumns_buffer.Scale
  s_ttb_fld.ds_lngth    = (IF DICTDBG.SQLColumns_buffer.LENGTH > DICTDBG.SQLColumns_buffer.PRECISION 
                              THEN DICTDBG.SQLColumns_buffer.Precision
                           ELSE DICTDBG.SQLColumns_buffer.LENGTH)
  s_ttb_fld.ds_radix    = DICTDBG.SQLColumns_buffer.Radix 
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
                           else if (s_ttb_fld.ds_type = "ROWGUID") then
                                false
                           ELSE IF ((INDEX(DICTDBG.SQLColumns_buffer.Type-name,"identity") > 0) OR 
                                    (INDEX(DICTDBG.SQLColumns_buffer.Type-name,"timestamp") > 0)) THEN
                                FALSE
                           else (DICTDBG.SQLColumns_buffer.Nullable = 0)
                          ).

/* OE00165897
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

/* Check field to see if identity field and mark _field-Misc2[4] as "identity" */
 IF INDEX(DICTDBG.SQLColumns_buffer.Type-name,"identity") > 0 THEN
   ASSIGN s_ttb_fld.ds_msc24 = "identity"
          s_ttb_fld.ds_itype = 1.
 ELSE IF INDEX(DICTDBG.SQLColumns_buffer.Type-name,"timestamp") > 0 THEN
   ASSIGN s_ttb_fld.ds_msc24 = "timestamp".
 ELSE IF INDEX(DICTDBG.SQLColumns_buffer.Type-name,"datetime2") > 0 THEN
   ASSIGN s_ttb_fld.ds_msc24 = "datetime2".
 ELSE IF isFileStream = '1' THEN
   ASSIGN s_ttb_fld.ds_msc24 = "filestream".


 IF s_ttb_Fld.ds_scale = ? THEN 
   ASSIGN s_ttb_Fld.ds_scale = 0.
   
 IF s_ttb_Fld.ds_radix = ? THEN 
   ASSIGN s_ttb_Fld.ds_radix = 0.
  
   
/*                                                             */
/* If the field is not updatable (fld-properties contains "N") */ 
/* then the field cannot be mandatory.                         */
/*                                                             */

{prodict/gate/gat_pul2.i
  &undo = "next"
  }

/*------------------------------------------------------------------*/

