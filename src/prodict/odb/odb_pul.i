/*********************************************************************
* Copyright (C) 2006, 2008-2009 by Progress Software Corporation. All*
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/odb/odb_pul.i

Description:
    creates the _field-definitions out of the ODBC-definitions
    
Text-Parameters:
    &data-type      Foreign data-type in PROGRESS-Notation
                    usually DICTDBG.SQLColumns_buffer.data-type
    &extent         in the range of 0 to n
    &order-offset   gets added to the _field._order
    
Included in:            
    prodict/odb/_odb_pul.p
    
History:
    hutegger    95/03   abstracted from prodict/odb/odb_mak.i
    mcmann      05/15/01 Added check for differences between precision and
                         length
    moloney     11/11/05 Modify the schema holder version number if
                         the new array character feature is implemented.
                         20050531-001
    fernando    01/04/06 Message added for 20050531-001 should be a warning
	                     and should not come up during migration - 20051230-006.
    nmanchal    11/06/08 setting initial value as 0 for numbers and Empty string for 
	                     character column, reg. OE00176741 (DB2 - ODBC dataservers)
    rkumar      01/07/09 Added default values for ODBC DataServer- OE00177724
    rkumar      07/23/09 OE00177724- modified call to SYSCOLUMNS to resolve
                         userid/driver issues - TR# OE00188452
    rkumar      09/25/09 OE00189853- fetching info for column desc from SYSCOLUMNS

--------------------------------------------------------------------*/

    
/*--------------------------------------------------------------------
Comments from prodict/odb/odb_mak.i:

History:
    hutegger    94/07/15    creation (reworked from previous version
                            basing on new version of ora_mak.i)
    slutz       08/10/05    Added s_ttb_fld.ds_msc26 20050531-001
    moloney     11/11/05    Added version upgrades and schema holder
                            tests against client version.

--------------------------------------------------------------------*/

/* this code gets executed only for the first element of array-field  */
/* so extent-code of field is always ##1 or __1 or some other suffix  */
/* character for array extent mapping (even with real extent >= 10).  */

DEFINE VARIABLE sqlq     AS CHARACTER NO-UNDO. /* OE00177724- for SYSCOLUMNS */
DEFINE VARIABLE dfth1    AS INTEGER   NO-UNDO. /* OE00177724- for SYSCOLUMNS */
DEFINE VARIABLE col_result AS CHARACTER NO-UNDO.
DEFINE VARIABLE first_str  AS CHARACTER NO-UNDO.
DEFINE VARIABLE second_str AS CHARACTER NO-UNDO.
DEFINE VARIABLE third_str  AS CHARACTER NO-UNDO.
DEFINE VARIABLE has_default AS CHARACTER NO-UNDO.
DEFINE VARIABLE is_identity AS CHARACTER NO-UNDO.

ASSIGN
  pnam = TRIM(DICTDBG.SQLColumns_buffer.Column-name).
ASSIGN
  extent_char = ( if {&extent} > 0 AND LENGTH (pnam, "character") > 4 /* Extract the "#" */
             then SUBSTRING (pnam, LENGTH (pnam, "character") - 2, 1, "character")
             else ? ).

  IF INDEX(UPPER(_Db._Db-misc2[8]), "DB2") <> 0 AND
       extent_char <>  "#" AND extent_char <> ? THEN DO:

    found = INDEX(DICTDB._Db._Db-misc2[7], " Schema Holder Ver#: ").
    IF found <> 0 THEN DO:
      found = found + LENGTH(" Schema Holder Ver#: ").
      IF found <= LENGTH(DICTDB._Db._Db-misc2[7]) THEN DO:

        sh_ver = INTEGER(SUBSTRING(DICTDB._Db._Db-misc2[7], found)).
        IF sh_ver < {&ODBC_SCH_VER2} THEN DO:

          DICTDB._Db._Db-misc2[7] = SUBSTRING(DICTDB._Db._Db-misc2[7], 1, found - 1, "character").
          ASSIGN
            DICTDB._Db._Db-misc2[7] = DICTDB._Db._Db-misc2[7] + STRING({&ODBC_SCH_VER2}).

          /* 20051230-006 - don't show this if running migration or create schema */
          IF NOT CAN-DO("M,C",odb_perform_mode) THEN DO:
              RUN adecomm/_setcurs.p ("").
              MESSAGE
                "The schema holder version " + STRING(sh_ver) + 
                " was automatically upgraded to version " + STRING({&ODBC_SCH_VER2}) + "." SKIP
                "Version " + STRING({&ODBC_SCH_VER2}) + " schema holder features were located."
                VIEW-AS ALERT-BOX WARNING BUTTONS OK.
              RUN adecomm/_setcurs.p ("WAIT").
          END.

          /* Now just check that the schema holder level you've upgraded to hasn't
           * exceeded the client (very unlikely but should be checked just in case)
           */
 
          /* If found, then the field is OpenEdge 10.1A client formatted */
          found = INDEX(DICTDB._Db._Db-misc2[7], "Client Ver #:").
          IF found <> 0 THEN DO:

            found = found + LENGTH("Client Ver #:"). 
            efound = INDEX(SUBSTRING(DICTDB._Db._Db-misc2[7], found), ",(sh_min=").
            IF efound > 0 THEN
              clnt_vers =  SUBSTRING(DICTDB._Db._Db-misc2[7], found, efound - 1).
            found = INDEX(DICTDB._Db._Db-misc2[7], ",sh_max=").
            IF found <> 0 THEN DO: 
              found = found + LENGTH(",sh_max=").
              efound = INDEX(SUBSTRING(DICTDB._Db._Db-misc2[7], found), ");").
              IF efound > 0 THEN
                sh_max_ver = INTEGER(SUBSTRING(DICTDB._Db._Db-misc2[7], found, efound - 1)).

            END. 

          END.
 
          IF sh_ver > sh_max_ver THEN DO:
            RUN adecomm/_setcurs.p ("").
            MESSAGE
              "The schema holder version " + STRING(sh_ver) + 
              " is higher than the version capacity of this OpenEdge client." SKIP
              "OpenEdge client version " + clnt_vers + 
              " can only handle schema holder versions up to " + STRING(sh_max_ver) + "." SKIP 
              "Please upgrade your OpenEdge client to one that is compatible with this" +
              " schema holder."
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RUN adecomm/_setcurs.p ("WAIT").
            RETURN.
          END.
         
        END.
      END.
    END.
  END.
 
assign
  pnam = TRIM(DICTDBG.SQLColumns_buffer.Column-name)

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
  l_dcml  = 0.

/* OE00177724- ODBC DB2/400- fetch default values from SYSCOLUMNS system table  */

IF (INDEX(UPPER(_Db._Db-misc2[5]), "DB2/400") <> 0 OR INDEX(UPPER(_Db._Db-misc2[5]), "AS/400") <> 0) THEN DO: 
  IF (dtyp EQ 3 or dtyp EQ 4 or dtyp EQ 5) THEN /* TIME/TIMESTAMP datatypes */ 
       ASSIGN l_init = ?.
  ELSE DO:
   ASSIGN sqlq = "select has_default,column_heading,'$$',column_default from qsys2.syscolumns where " + 
       " column_name = '" + DICTDBG.SQLColumns_buffer.column-name +
       "' and table_name  = '" + DICTDBG.SQLColumns_buffer.NAME +
       "' and table_schema = '" + DICTDBG.SQLColumns_buffer.OWNER +
       "' ".

   RUN STORED-PROC DICTDBG.send-sql-statement dfth1 = PROC-HANDLE NO-ERROR ( sqlq ).

  IF ERROR-STATUS:ERROR THEN
       ASSIGN fld-remark = ?
              l_init = ?. 
  ELSE DO:
    FOR EACH DICTDBG.proc-text-buffer WHERE PROC-HANDLE = dfth1:
        ASSIGN col_result = proc-text.
    END.
    CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = dfth1.
    ASSIGN fld-remark = TRIM(TRIM(SUBSTRING(col_result,5,INDEX(col_result," '$$'") - 5),"'")," ~"~ ").
           has_default =  TRIM(SUBSTRING(col_result,1,3),"'").
    IF has_default EQ 'Y' THEN 
           ASSIGN l_init = TRIM(TRIM(SUBSTRING(col_result,INDEX(col_result," '$$'") + 6, -1)),"'").
  END.

/* COLUMN_HEADING is of size VARCHAR(60) and can contain heading in 3 rows of
   20 characters each.Separating out the 3 substrings  and then concatenating
   them separated by '!' for display as column description.  */

 IF length(fld-remark) > 20 THEN DO:
  ASSIGN first_str = TRIM(SUBSTRING(fld-remark,1,20)," ").
  ASSIGN second_str = TRIM(SUBSTRING(fld-remark,21,20)," ").
  ASSIGN third_str = TRIM(SUBSTRING(fld-remark,41,20)," ").
  IF length(first_str) GT 0 THEN ASSIGN  fld-remark = first_str.
  IF length(second_str) GT 0 THEN ASSIGN  fld-remark = fld-remark  + "!" + second_str. 
  IF length(third_str) GT 0 THEN ASSIGN  fld-remark = fld-remark  + "!" + third_str.
 END.

 IF l_init <> ? THEN DO: 
 IF (ntyp = "DATE") AND INDEX(l_init,"CURRENT_DATE") = 0 THEN
      ASSIGN l_init = ?. 
  ELSE IF ntyp = "DATE" THEN 
      ASSIGN l_init = "TODAY".
 END. 
 /* Rohit- confirm changes for logical field */
 IF (ntyp = "CHARACTER" and l_init = "NULL") THEN
          ASSIGN l_init = "". 
 ELSE IF (ntyp = "LOGICAL" and (l_init = "NULL" OR l_init EQ "0")) THEN
          ASSIGN l_init = "NO". 
 ELSE IF (ntyp = "LOGICAL" and l_init NE "0") THEN
          ASSIGN l_init = "YES". 
 ELSE IF ((ntyp = "DECIMAL" OR ntyp = "INTEGER" OR ntyp = "INT64" ) and (l_init = "NULL")) THEN 
          ASSIGN l_init = "0".
 END. /* END of IF (dtyp EQ 3 or dtyp EQ 4 or dtyp EQ 5) */
END.

/* OE00210200: To identify whether the column has 'GENERATED' property. */
IF (INDEX(UPPER(_Db._Db-misc2[5]), "UDB") <> 0 OR INDEX(UPPER(_Db._Db-misc2[5]), "UDB DB") <> 0) THEN DO:
	ASSIGN sqlq = "select GENERATED from syscat.columns where " + 
	   " TABNAME = '" + DICTDBG.SQLColumns_buffer.NAME +
	   "' and COLNAME  = '" + DICTDBG.SQLColumns_buffer.column-name +
	   "' and USER = '" + DICTDBG.SQLColumns_buffer.OWNER +
	   "' ".

	RUN STORED-PROC DICTDBG.send-sql-statement dfth1 = PROC-HANDLE NO-ERROR ( sqlq ).

	IF ERROR-STATUS:ERROR THEN
	   ASSIGN is_identity = ?.
	ELSE DO:
		FOR EACH DICTDBG.proc-text-buffer WHERE PROC-HANDLE = dfth1:
			ASSIGN is_identity = proc-text.
		END.
		is_identity = TRIM(SUBSTRING(is_identity,1,3),"'").
		CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = dfth1.
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
  s_ttb_fld.ds_msc26    = extent_char
  s_ttb_fld.ds_stoff    = field-position
  s_ttb_fld.ds_name     = fnam
  s_ttb_fld.ds_type     = {&data-type}
  s_ttb_fld.pro_order   = IF ((INDEX(UPPER(_Db._Db-misc2[5]), "DB2/400") <> 0 OR INDEX(UPPER(_Db._Db-misc2[5]), "AS/400") <> 0)) THEN
                             field-position * 10 
                          ELSE
                             field-position * 10 + 1000 
                              + {&order-offset}
  s_ttb_fld.pro_mand    = ( if CAN-DO(fld-properties, "N")
                                then false
                                ELSE IF (is_identity EQ 'A' OR is_identity EQ 'D')
                                THEN FALSE
                                else (DICTDBG.SQLColumns_buffer.Nullable = 0)
                          ).
						  
/* OE00210200: Check field to see if generated field and mark _field-Misc2[4] as appropriately. */
IF (INDEX(UPPER(_Db._Db-misc2[5]), "UDB") <> 0 OR INDEX(UPPER(_Db._Db-misc2[5]), "UDB DB") <> 0) THEN DO:
 IF (is_identity EQ 'A') THEN
   ASSIGN s_ttb_fld.ds_msc24 = "ALWAYS"
          s_ttb_fld.ds_itype = 1. 
 ELSE IF (is_identity EQ 'D') THEN
   ASSIGN s_ttb_fld.ds_msc24 = "BY_DEFAULT"
          s_ttb_fld.ds_itype = 1.
END.
   
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

