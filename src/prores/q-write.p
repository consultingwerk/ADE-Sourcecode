/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* q-write.p - generate query program */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/a-define.i }

DEFINE INPUT PARAMETER qbf-f AS CHARACTER NO-UNDO. /*self - .p & .i fn*/

DEFINE VARIABLE qbf-b AS CHARACTER INITIAL "" NO-UNDO. /* browse fields */
DEFINE VARIABLE qbf-c AS CHARACTER            NO-UNDO.
DEFINE VARIABLE qbf-d AS CHARACTER INITIAL "" NO-UNDO. /* display fields */
DEFINE VARIABLE qbf-i AS INTEGER              NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER              NO-UNDO.
DEFINE VARIABLE qbf-k AS CHARACTER INITIAL  ? NO-UNDO.
DEFINE VARIABLE qbf-l AS CHARACTER INITIAL "" NO-UNDO. /* rpos/dtype list */
DEFINE VARIABLE qbf-m AS CHARACTER INITIAL "" NO-UNDO. /* meta-schema list */
DEFINE VARIABLE qbf-p AS CHARACTER INITIAL "" NO-UNDO. /* _field-rpos list */
DEFINE VARIABLE qbf-q AS CHARACTER INITIAL "" NO-UNDO. /* query fields */
DEFINE VARIABLE qbf-s AS CHARACTER            NO-UNDO. /* dtype:idxflds list */
DEFINE VARIABLE qbf-u AS CHARACTER INITIAL "" NO-UNDO. /* update fields */

DEFINE STREAM qbf-io.

DEFINE WORKFILE qbf-w NO-UNDO
  FIELD qbf-n AS CHARACTER          /* name */
  FIELD qbf-o AS INTEGER           /* order */
  FIELD qbf-g AS LOGICAL EXTENT 4. /* flags */

/*define variable qbf-x as integer no-undo.*/
/*qbf-x = etime.*/
/*put unformatted "#00 - " (etime - qbf-x) * .001 skip.*/

{ prores/s-alias.i
  &prog=prores/q-write.p
  &dbname=qbf-db[1]
  &params="(qbf-f)"
}

DO qbf-i = 1 TO NUM-DBS:
  IF DBTYPE(qbf-i) = "PROGRESS" THEN
    qbf-m = qbf-m + (IF qbf-m = "" THEN "" ELSE ",") + LDBNAME(qbf-i).
END.

/* filter out sql92 tables and views */
IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN
  FIND QBF$0._File OF QBF$0._Db 
    WHERE QBF$0._File._File-name = qbf-file[1] AND
      (QBF$0._File._Owner = "PUB":U OR QBF$0._File._Owner = "_FOREIGN":U)
    NO-LOCK.
ELSE 
  FIND QBF$0._File OF QBF$0._Db
    WHERE QBF$0._File._File-name = qbf-file[1] NO-LOCK.

/*----------------------------------------------------------------------------
  /*
  config= query
  version= 1.2Q
  name= "" 
  file1= "demo.customer" 665038692 32223
  include= "customer.i"
  form-file= "customer.f"
  form-name= "customer"
  form-type= "default"
  form-lines= 12
  max-rpos= 19
  field1= "Cust-num" "integer" 10 yes yes yes yes 
  field2= "Name" "character" 20 yes yes yes yes 
  field3= "Address" "character" 30 yes yes yes no 
  field4= "Address2" "character" 40 yes yes yes no 
  field5= "City" "character" 50 yes yes yes no 
  field6= "St" "character" 60 yes yes yes no 
  field7= "Zip" "integer" 70 yes yes yes yes 
  field8= "Phone" "character" 80 yes yes yes no 
  field9= "Contact" "character" 90 yes yes yes no 
  field10= "Sales-rep" "character" 95 yes yes yes no 
  field11= "Sales-region" "character" 100 yes yes yes no 
  field12= "Max-credit" "decimal" 105 yes yes yes no 
  field13= "Curr-bal" "decimal" 110 yes yes yes no 
  field14= "Terms" "character" 115 yes yes yes no 
  field15= "Tax-no" "character" 120 yes yes yes no 
  field16= "Discount" "integer" 125 yes yes yes no 
  field17= "Mnth-sales" "decimal" 129 yes yes no no 
  field18= "Ytd-sls" "decimal" 130 yes yes yes no 
  */
  
  DEFINE VARIABLE qbf-1 AS ROWID NO-UNDO.
  { prores/results.i
    &self=customer
    &code=customer.i
    &file=customer
    &ldbn=demo
    &form=customer.f
    &name=customer
    &rpos=19
    &fake="FIND NEXT customer USE-INDEX cust-num.
           FIND NEXT customer USE-INDEX name.
           FIND NEXT customer USE-INDEX zip."
    &disp="customer.Cust-num customer.Name customer.Address customer.Address2
           customer.City customer.St customer.Zip customer.Phone
           customer.Contact customer.Sales-rep customer.Sales-region
           customer.Max-credit customer.Curr-bal customer.Terms customer.Tax-no
           customer.Discount customer.Mnth-sales customer.Ytd-sls"
    &read="customer.Cust-num customer.Name customer.Address customer.Address2
           customer.City customer.St customer.Zip customer.Phone
           customer.Contact customer.Sales-rep customer.Sales-region
           customer.Max-credit customer.Curr-bal customer.Terms customer.Tax-no
           customer.Discount customer.Mnth-sales customer.Ytd-sls"
    &seek="customer.Cust-num customer.Name customer.Address customer.Address2
           customer.City customer.St customer.Zip customer.Phone
           customer.Contact customer.Sales-rep customer.Sales-region
           customer.Max-credit customer.Curr-bal customer.Terms customer.Tax-no
           customer.Discount customer.Ytd-sls"
    &brow="Cust-num Name Zip"
    &full=*
    &scan=*
    &down=*
    &dtyp=",4,1,1,1,1,1,4,1,1,1,1,5,5,1,1,4,,5,*"
    &imag="2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,19"
    &save="qbf-1 = ROWID(customer)"
    &rest="qbf-1 = ROWID(customer)"
  }
----------------------------------------------------------------------------*/
/*
qbf-rc#=     max-rpos
qbf-rcn[]=   field names ("" for last field)
qbf-rct[]=   field dtypes (0 for undefined)
qbf-rca[]=   yynny (display,update,query,browse,isarray)
qbf-rcw[]=   order
qbf-file[1]= 'file1= "customer"'

qbf-a-attr[1]= 'form-file= "customer.f"'
qbf-a-attr[2]= 'form-name= "customer"'
qbf-a-attr[3]= source of form: 'default' 'ft' 'user'
qbf-a-attr[4]= num of lines on form: 'form-lines= 15' (not counting box)
*/

qbf-c = "".
/*put unformatted "#01 - " (etime - qbf-x) * .001 skip.*/
DO qbf-i = 1 TO { prores/s-limcol.i } WHILE qbf-rcn[qbf-i] <> "":
  CREATE qbf-w.
  ASSIGN
    qbf-c          = qbf-c + (IF qbf-c = "" THEN "" ELSE ",") + qbf-rcn[qbf-i]
    qbf-w.qbf-n    = qbf-rcn[qbf-i]
    qbf-w.qbf-o    = qbf-rcw[qbf-i]
    qbf-w.qbf-g[1] = SUBSTRING(qbf-rca[qbf-i],1,1) = "y"  /* display */
    qbf-w.qbf-g[2] = SUBSTRING(qbf-rca[qbf-i],2,1) = "y"  /* update */
    qbf-w.qbf-g[3] = SUBSTRING(qbf-rca[qbf-i],3,1) = "y"  /* query */
    qbf-w.qbf-g[4] = SUBSTRING(qbf-rca[qbf-i],4,1) = "y". /* browse */
END.

/*put unformatted "#02 - " (etime - qbf-x) * .001 skip.*/
FOR EACH QBF$0._Field OF QBF$0._File NO-LOCK:
  IF QBF$0._Field._Extent = 0
    AND CAN-DO(qbf-c,QBF$0._Field._Field-name) THEN
    OVERLAY(qbf-l,QBF$0._Field._field-rpos,1)
    = STRING(QBF$0._Field._dtype).
  qbf-rc# = MAXIMUM(qbf-rc#,QBF$0._Field._field-rpos).
END.
/*put unformatted "#03 - " (etime - qbf-x) * .001 skip.*/
OVERLAY(qbf-l,qbf-rc# + 1,1) = "*".

/*RUN prores/s-prefix.p (qbf-dir-nam,OUTPUT qbf-c).*/
ASSIGN
  qbf-c = SEARCH(qbf-f + ".p")
  qbf-c = (IF qbf-c = ? THEN qbf-f + ".p" ELSE qbf-c)
  qbf-c = SUBSTRING(qbf-c,1,LENGTH(qbf-c) - LENGTH(qbf-f) - 2).
IF qbf-f BEGINS "_" THEN qbf-c = "".
/*--------------------------------------------------------------------------*/
/*put unformatted "#04 - " (etime - qbf-x) * .001 skip.*/
OUTPUT STREAM qbf-io TO VALUE(qbf-c + qbf-f + ".i") NO-ECHO NO-MAP.
PUT STREAM qbf-io UNFORMATTED
  '/*' SKIP
  'config= include' SKIP
  'file= "' qbf-db[1] '.' QBF$0._File._File-name '"' SKIP
  '*/' SKIP(1)
  'ASSIGN'.
qbf-j = 1.
/*put unformatted "#05 - " (etime - qbf-x) * .001 skip.*/
DO qbf-i = 1 TO { prores/s-limcol.i } WHILE qbf-rcn[qbf-i] <> "":
  IF SUBSTRING(qbf-rca[qbf-i],3,1) = "n" THEN NEXT.
  FIND FIRST QBF$0._Field OF QBF$0._File
    WHERE QBF$0._Field._Field-name = qbf-rcn[qbf-i]
      AND QBF$0._Field._Extent = 0 NO-LOCK NO-ERROR.
  IF NOT AVAILABLE QBF$0._Field THEN NEXT.
  IF qbf-j MODULO 4 = 0 THEN PUT STREAM qbf-io UNFORMATTED '.' SKIP 'ASSIGN'.
  ASSIGN
    qbf-j = qbf-j + 1
    qbf-p = qbf-p + (IF qbf-p = "" THEN "" ELSE ",")
          + STRING(QBF$0._Field._field-rpos)
    qbf-s = "INPUT " /* + qbf-db[1] + "." */
          + qbf-file[1] + "." + QBF$0._Field._Field-name.
  IF QBF$0._Field._dtype = 5 /*decimal*/ THEN
    qbf-s = '(IF ' + qbf-s + ' > -1 AND ' + qbf-s + ' < 0 THEN "-" ELSE "") + '
          + 'STRING(TRUNCATE(' + qbf-s + ',0)) + '
          + '(IF ' + qbf-s + ' = TRUNCATE(' + qbf-s + ',0) THEN "" ELSE ".") + '
          + 'SUBSTRING(STRING(' + qbf-s + ' - TRUNCATE(' + qbf-s + ',0)),'
          + 'IF ' + qbf-s + ' < 0 THEN 3 ELSE 2)'.
  ELSE
  IF QBF$0._Field._dtype = 2 /*date*/ THEN
    qbf-s = 'STRING(MONTH(' + qbf-s + ')) + "/" + STRING(DAY(' + qbf-s
          + ')) + "/" + STRING(YEAR(' + qbf-s + '))'.
  ELSE
  IF QBF$0._Field._dtype <> 1 /*char*/ THEN
    qbf-s = "STRING(" + qbf-s + ")".
  PUT STREAM qbf-io UNFORMATTED SKIP
    '  qbf-qval[' QBF$0._Field._field-rpos '] = (IF '
      qbf-file[1] '.' QBF$0._Field._Field-name
      ' ENTERED THEN ' qbf-s ' ELSE qbf-qval[' QBF$0._Field._field-rpos '])'
      SKIP
    '  qbf-qtru[' QBF$0._Field._field-rpos '] = '.
  IF QBF$0._Field._dtype <> 2 AND QBF$0._Field._dtype <> 5 /*date,dec*/ THEN
    PUT STREAM qbf-io UNFORMATTED
      'qbf-qval[' QBF$0._Field._field-rpos ']'.
  ELSE
    PUT STREAM qbf-io UNFORMATTED
      '(IF ' qbf-file[1] '.' QBF$0._Field._Field-name ' ENTERED THEN '
        (IF QBF$0._Field._dtype = 1 THEN '' ELSE 'STRING(')
        'INPUT ' qbf-file[1] '.' QBF$0._Field._Field-name
        (IF QBF$0._Field._dtype = 1 THEN '' ELSE ')'      )
        ' ELSE qbf-qtru[' QBF$0._Field._field-rpos '])'.
END.
/*put unformatted "#06 - " (etime - qbf-x) * .001 skip.*/
PUT STREAM qbf-io UNFORMATTED '.' SKIP.
OUTPUT STREAM qbf-io CLOSE.
/*--------------------------------------------------------------------------*/

OUTPUT STREAM qbf-io TO VALUE(qbf-c + qbf-f + ".p") NO-ECHO NO-MAP.
/*--------------------------------------------------------------------------*/
IF true or NOT qbf-f BEGINS "_" THEN DO:
  PUT STREAM qbf-io UNFORMATTED
    '/*' SKIP
    'config= query' SKIP
    'version= ' qbf-vers SKIP.
  PUT STREAM qbf-io CONTROL 'name= '. EXPORT STREAM qbf-io qbf-name.
  PUT STREAM qbf-io UNFORMATTED
    'file1= "'     qbf-db[1] '.' qbf-file[1] '" '
      QBF$0._File._Last-change ' ' QBF$0._File._Crc SKIP
    'include= "'   qbf-f       '.i"' SKIP
    'form-file= "' qbf-a-attr[1] '"' SKIP
    'form-name= "' qbf-a-attr[2] '"' SKIP
    'form-type= "' qbf-a-attr[3] '"' SKIP
    'form-lines= ' qbf-a-attr[4]     SKIP
    'max-rpos= ' qbf-rc# SKIP.

/*put unformatted "#07 - " (etime - qbf-x) * .001 skip.*/
  DO qbf-i = 1 TO { prores/s-limcol.i } WHILE qbf-rcn[qbf-i] <> "":
    PUT STREAM qbf-io CONTROL 'field' STRING(qbf-i) '= '.
    EXPORT STREAM qbf-io
      qbf-rcn[qbf-i] ENTRY(qbf-rct[qbf-i],qbf-dtype) qbf-rcw[qbf-i]
      SUBSTRING(qbf-rca[qbf-i],1,1) = "y"  /* display */
      SUBSTRING(qbf-rca[qbf-i],2,1) = "y"  /* update */
      SUBSTRING(qbf-rca[qbf-i],3,1) = "y"  /* query */
      SUBSTRING(qbf-rca[qbf-i],4,1) = "y". /* browse */
  END.
/*put unformatted "#08 - " (etime - qbf-x) * .001 skip.*/

  PUT STREAM qbf-io UNFORMATTED '*/' SKIP(1).
END.
/*--------------------------------------------------------------------------*/

/* qbf-s = "" for RECID-capable, or ? for not */
qbf-s = (IF CAN-DO(DBRESTRICTIONS(qbf-db[1]),"RECID") THEN ? ELSE "").
IF DBTYPE(qbf-db[1]) = "RMS" THEN DO:
  RUN prores/s-lookup.p
    (qbf-db[1],qbf-file[1],"","FILE:MISC2:8",OUTPUT qbf-s).
  qbf-s = (IF CAN-DO("relative,sequential",qbf-s) THEN "" ELSE ?).
END.

IF qbf-s = "" THEN DO:
  qbf-s = "ROWID("
      /*+ (IF qbf-db[1] = "" THEN "" ELSE qbf-db[1] + ".")*/
        + qbf-file[1] + ")".
  PUT STREAM qbf-io UNFORMATTED
    'DEFINE VARIABLE qbf-1 AS ROWID NO-UNDO.' SKIP.
END.
ELSE DO:
  RUN prores/a-lookup.p
    (qbf-db[1],qbf-file[1],"","u",OUTPUT qbf-s).
  DO qbf-i = 1 TO NUM-ENTRIES(qbf-s):
    /*
    causes core-dump.
    PUT STREAM qbf-io UNFORMATTED
      'DEFINE VARIABLE qbf-' qbf-i
      ' LIKE ' qbf-db[1] '.' qbf-file[1] '.' ENTRY(qbf-i,qbf-s)
      ' NO-UNDO.' SKIP.
    */
    RUN prores/s-lookup.p
      (qbf-db[1],qbf-file[1],ENTRY(qbf-i,qbf-s),"FIELD:TYP&FMT",OUTPUT qbf-c).
    PUT STREAM qbf-io UNFORMATTED
      'DEFINE VARIABLE qbf-' qbf-i
      ' AS ' CAPS(ENTRY(INTEGER(ENTRY(1,qbf-c)),qbf-dtype))
      ' NO-UNDO. /*' qbf-db[1] '.' qbf-file[1] '.' ENTRY(qbf-i,qbf-s) '*/' SKIP.
  END.
END.

PUT STREAM qbf-io UNFORMATTED
  '~{ prores/results.' STRING(SEARCH("prores/results.i") = ?,'x/i') SKIP
  '  &self=' qbf-f         SKIP
  '  &code=' qbf-f '.i'    SKIP
  '  &file=' qbf-file[1]   SKIP
  '  &ldbn=' qbf-db[1]     SKIP
  '  &form=' qbf-a-attr[1] SKIP
  '  &name=' qbf-a-attr[2] SKIP
  '  &rpos=' qbf-rc#       SKIP.

/*put unformatted "#09 - " (etime - qbf-x) * .001 skip.*/
PUT STREAM qbf-io UNFORMATTED '  &fake="'.
qbf-i = (IF QBF$0._Db._Db-type <> "PROGRESS" OR QBF$0._File._dft-pk
        THEN 1 ELSE 0).
IF qbf-i = 1 THEN
  PUT STREAM qbf-io UNFORMATTED 'FIND NEXT ' QBF$0._File._File-name '.'.
FOR EACH QBF$0._Index OF QBF$0._File
  WHERE QBF$0._Index._Index-name <> "default" AND
        QBF$0._Index._Wordidx <> 1 NO-LOCK 
  BREAK BY _Index-name:
  IF qbf-i > 0 THEN PUT STREAM qbf-io UNFORMATTED SKIP '         '.
  PUT STREAM qbf-io UNFORMATTED
    'FIND NEXT ' QBF$0._File._File-name 
    ' USE-INDEX ' QBF$0._Index._Index-name '.'.
  qbf-i = qbf-i + 1.
END.
IF qbf-i = 0 THEN PUT STREAM qbf-io UNFORMATTED 'FORM.'.
PUT STREAM qbf-io UNFORMATTED '"' SKIP.

/*put unformatted "#10 - " (etime - qbf-x) * .001 skip.*/

/* to keep size of code between curly braces small, we only use file
prefix if filename not unique across dbs. can-find will return true if
field name unique, or false if multiple records match. */

FOR EACH qbf-w BY qbf-w.qbf-o:
  qbf-j = 0.
  IF NUM-ENTRIES(qbf-m) = 1 AND
    NOT CAN-FIND(QBF$0._Field WHERE QBF$0._Field._Field-name BEGINS qbf-w.qbf-n)
    THEN qbf-j = 2.
  ELSE
  IF NUM-ENTRIES(qbf-m) = 1 AND
    INTEGER(DBVERSION("QBF$0":U)) <= 8 AND
    CAN-FIND(QBF$0._File WHERE QBF$0._File._File-name = qbf-w.qbf-n) THEN
    qbf-j = 2.
  
  /* filter out sql92 tables and views */
  ELSE
  IF NUM-ENTRIES(qbf-m) = 1 AND
    INTEGER(DBVERSION("QBF$0":U)) > 8 AND
    CAN-FIND(QBF$0._File WHERE QBF$0._File._File-name = qbf-w.qbf-n AND
             QBF$0._File._Owner <> "PUB":U AND 
             QBF$0._File._Owner <> "_FOREIGN":U) THEN
    qbf-j = 2.
    
  ELSE DO qbf-i = 1 TO NUM-ENTRIES(qbf-m) WHILE qbf-j < 2:
    RUN prores/s-lookup.p
      (ENTRY(qbf-i,qbf-m),"",qbf-w.qbf-n,"DB:ANY-FIELD",OUTPUT qbf-c).
    qbf-j = qbf-j + (IF qbf-c = "ny" THEN 2 ELSE IF qbf-c = "yy" THEN 1 ELSE 0).
    IF LDBNAME(ENTRY(qbf-i,qbf-m)) = LDBNAME("QBF$0") THEN NEXT.
    RUN prores/s-lookup.p
      (ENTRY(qbf-i,qbf-m),QBF$0._File._File-name,"","FILE:RECID",OUTPUT qbf-c).
    IF qbf-c <> ? THEN qbf-j = qbf-j + 2.
  END.
  qbf-c = (IF qbf-j > 1 THEN qbf-file[1] + "." ELSE "").
  IF qbf-w.qbf-g[1] THEN
    qbf-d = qbf-d + (IF qbf-d = "" THEN "" ELSE " ") + qbf-c + qbf-w.qbf-n.
  IF qbf-w.qbf-g[2] THEN
    qbf-u = qbf-u + (IF qbf-u = "" THEN "" ELSE " ") + qbf-c + qbf-w.qbf-n.
  IF qbf-w.qbf-g[3] THEN
    qbf-q = qbf-q + (IF qbf-q = "" THEN "" ELSE " ") + qbf-c + qbf-w.qbf-n.
  IF qbf-w.qbf-g[4] THEN
    qbf-b = qbf-b + (IF qbf-b = "" THEN "" ELSE " ")         + qbf-w.qbf-n.
END.
/*put unformatted "#11 - " (etime - qbf-x) * .001 skip.*/

IF qbf-b = "" THEN qbf-b = " ".
PUT STREAM qbf-io UNFORMATTED
  '  &disp="' qbf-d '"' SKIP
  '  &read="' qbf-u '"' SKIP
  '  &seek="' qbf-q '"' SKIP
  '  &brow="' qbf-b '"' SKIP.

IF PROGRESS = "Full" AND qbf-u <> "" THEN
                    PUT STREAM qbf-io UNFORMATTED '  &full=*' SKIP.
IF qbf-q <> "" THEN PUT STREAM qbf-io UNFORMATTED '  &scan=*' SKIP.
IF qbf-b <> "" THEN PUT STREAM qbf-io UNFORMATTED '  &down=*' SKIP.

qbf-c = "".
/*put unformatted "#12 - " (etime - qbf-x) * .001 skip.*/
DO qbf-j = 1 TO LENGTH(qbf-l) - 1:
  qbf-c = qbf-c
        + (IF SUBSTRING(qbf-l,qbf-j,1) = " " THEN ""
          ELSE SUBSTRING(qbf-l,qbf-j,1))
        + ','.
END.
/*put unformatted "#13 - " (etime - qbf-x) * .001 skip.*/
PUT STREAM qbf-io UNFORMATTED
  '  &dtyp="' qbf-c '*"' SKIP
  '  &imag="' qbf-p '"' SKIP.

IF NUM-ENTRIES(qbf-s) > 0 THEN DO: /* 20040430-033; empty arg doesn't get substituted properly */
    PUT STREAM qbf-io UNFORMATTED '  &save="'.
    IF NUM-ENTRIES(qbf-s) > 1 THEN
      PUT STREAM qbf-io UNFORMATTED 'ASSIGN'.
    DO qbf-i = 1 TO NUM-ENTRIES(qbf-s):
      IF NUM-ENTRIES(qbf-s) > 1 THEN
       PUT STREAM qbf-io UNFORMATTED SKIP '         '.
      qbf-j = INDEX(ENTRY(qbf-i,qbf-s),":").
      PUT STREAM qbf-io UNFORMATTED
        'qbf-' qbf-i ' = ' SUBSTRING(ENTRY(qbf-i,qbf-s),qbf-j + 1).
    END.
    PUT STREAM qbf-io UNFORMATTED '"' SKIP '  &rest="'.
    DO qbf-i = 1 TO NUM-ENTRIES(qbf-s):
      qbf-j = INDEX(ENTRY(qbf-i,qbf-s),":").
      PUT STREAM qbf-io UNFORMATTED
        (IF qbf-i > 1 THEN ' AND ' ELSE '')
        'qbf-' qbf-i ' = ' SUBSTRING(ENTRY(qbf-i,qbf-s),qbf-j + 1).
    END.
    PUT STREAM qbf-io UNFORMATTED '"' SKIP.
END.

PUT STREAM qbf-io UNFORMATTED
  '~}' SKIP.
OUTPUT STREAM qbf-io CLOSE.
/*put unformatted "#14 - " (etime - qbf-x) * .001 skip.*/

RETURN.
