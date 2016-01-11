/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
    History:

      04/14/98 Added assignment of _field-rpos if in workfile  D. McMann
      06/12/98 Added assignment for modify field of _field-rpos
               98-06-01-027 D. McMann
      12/27/98 Added check for _file._Prime-index = ? 98-11-23-038 D. McMann
      01/27/99 Added logic for assignment of _width D. McMann
      08/24/99 Added logic for update of _width Mario B. 19990824-019
      04/10/00 Added warning for case sensitive field in index  
      04/11/01 Added warning for SQL Table Updates ISSUE 310
      04/09/03 Added check for not RECID of field on rename 20030407-015
      06/12/03 Added check for _Width field in temp table being ? 20030611-060
      09/22/03 Added check for CLOB to have codepage and collation set.
      09/29/03 Added check for invalid data type 20030925-014
      07/09/04 Added abbreviations for data types 20040430-023
              
*/    
    
define input-output parameter minimum-index as integer.
 
{ prodict/dump/loaddefs.i }
{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE scrap    AS CHARACTER NO-UNDO.
DEFINE VARIABLE fldrecid AS RECID     NO-UNDO.
DEFINE VARIABLE fldrpos  AS INTEGER   NO-UNDO.

DEFINE VARIABLE i        AS INTEGER   NO-UNDO.

FIND _File WHERE RECID(_File) = drec_file NO-ERROR.
IF NOT AVAILABLE _File THEN RETURN.
IF _File._Frozen THEN
  ierror = 14. /* "Cannot alter field from frozen file" */
IF _File._Db-lang = 1 AND imod <> "m" THEN
  ierror = 15. /* "Use SQL ALTER TABLE to change field" */
IF ierror > 0 THEN RETURN.

FIND FIRST wfld.
IF imod <> "a" THEN
  FIND _Field OF _File
    WHERE _Field._Field-name = wfld._Field-name. /* proven to exist */

IF imod = "a" THEN DO: /*---------------------------------------------------*/
  IF CAN-FIND(_Field WHERE _Field._File-recid = drec_file
    AND _Field._Field-name = wfld._Field-name) THEN
    ierror = 7. /* "&2 already exists with name &3" */
  IF wfld._Data-type = "CLOB" AND
    (wfld._Charset = ? OR wfld._Collation = ?) THEN
    ierror = 46.

  IF LOOKUP(wfld._Data-type,"CHARACTER,CHAR,DATE,DECIMAL,DEC,INTEGER,INT,LOGICAL,DATETIME,DATETIME-TZ,BLOB,CLOB,RAW,RECID") = 0 THEN 
    ASSIGN ierror = 47.

  IF ierror > 0 THEN RETURN.

  IF wfld._Order = ? THEN DO:
    FIND LAST _Field WHERE _Field._File-recid = drec_file
      USE-INDEX _field-position NO-ERROR.
    wfld._Order = (IF AVAILABLE _Field THEN _Field._Order ELSE 0) + 10.
  END.
  /* existing order! */
  IF CAN-FIND(_Field WHERE _Field._File-recid = drec_file
    AND _Field._Order = wfld._Order) THEN
    RUN bump_sub (wfld._Order).

  IF gate_dbtype <> "PROGRESS" THEN DO:
    wfld._Fld-stdtype = ?.
    RUN VALUE(gate_proc) (
      INPUT-OUTPUT wfld._Fld-stdtype,
      INPUT-OUTPUT wfld._Fld-stlen,
      INPUT-OUTPUT wfld._Data-type,
      INPUT-OUTPUT wfld._For-type,
      OUTPUT scrap).
    IF wfld._Format = ? THEN wfld._Format = scrap.
  END.

  CREATE _Field.
  ASSIGN
    _Field._File-recid = drec_file
    _Field._Field-name = wfld._Field-name
    _Field._Data-type  = wfld._Data-type
    _Field._Order      = wfld._Order NO-ERROR.

  { prodict/dump/copy_fld.i &from=wfld &to=_Field &all=false}

  fldrecid = RECID(_Field).
  IF wfld._Format  <> ?  THEN _Field._Format  = wfld._Format.
  IF wfld._Initial <> "" THEN _Field._Initial = wfld._Initial. 
  IF wfld._Field-rpos <> ? THEN _Field._Field-rpos = wfld._Field-rpos.
  IF wfld._Width <> ? THEN _Field._Width = wfld._Width.
  IF wfld._Charset <> ? THEN _Field._Charset = wfld._Charset.
  IF wfld._Collation <> ? THEN _Field._Collation = wfld._Collation.
  IF wfld._Attributes1 <> 0 AND wfld._Attributes1 <> ? THEN _Field._Attributes1 = wfld._Attributes1.

END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "m" THEN DO: /*---------------------------------------------------*/
  IF _Field._Data-type <> wfld._Data-type THEN
    ierror = 10. /* "Cannot change datatype of existing field" */
  IF _Field._Extent <> wfld._Extent THEN
    ierror = 11. /* "Cannot change extent of existing field" */
  IF ierror > 0 THEN RETURN.

  /* existing order! */
  IF _Field._Order <> wfld._Order
    AND CAN-FIND(_Field WHERE _Field._File-recid = drec_file
      AND _Field._Order = wfld._Order) THEN
    RUN bump_sub (wfld._Order).

  IF gate_dbtype <> "PROGRESS" THEN DO:
    wfld._Fld-stdtype = ?.
    RUN VALUE(gate_proc) (
      INPUT-OUTPUT wfld._Fld-stdtype,
      INPUT-OUTPUT wfld._Fld-stlen,
      INPUT-OUTPUT wfld._Data-type,
      INPUT-OUTPUT wfld._For-type,
      OUTPUT scrap).
    IF wfld._Format = ? THEN wfld._Format = scrap.
  END.

  IF _File._Db-lang = 0 THEN DO:
    IF _Field._Can-write   <> wfld._Can-write    THEN _Field._Can-write     = wfld._Can-write.
    IF _Field._Can-read    <> wfld._Can-read     THEN _Field._Can-read      = wfld._Can-read.
    IF _Field._Mandatory   <> wfld._Mandatory    THEN _Field._Mandatory     = wfld._Mandatory.
    IF _Field._Decimals    <> wfld._Decimals     THEN _Field._Decimals      = wfld._Decimals.
  END.
  ELSE IF _file._db-lang = 1 THEN DO:
    IF _Field._Can-write   <> wfld._Can-write  OR
       _Field._Can-read    <> wfld._Can-read   OR
       _Field._Mandatory   <> wfld._Mandatory  OR
       _Field._Decimals    <> wfld._Decimals   THEN
       ASSIGN iwarnlst = iwarnlst + "23,"
              ierror = 50.
  END.

  IF COMPARE(_Field._Col-label,"NE",wfld._Col-label,"RAW")  THEN _Field._Col-label     = wfld._Col-label.
  IF _Field._Col-label-SA  <> wfld._Col-label-SA            THEN _Field._Col-label-SA  = wfld._Col-label-SA.
  IF COMPARE(_Field._Desc,"NE",wfld._Desc,"RAW")            THEN _Field._Desc          = wfld._Desc.
  IF _Field._Format        <> wfld._Format                  THEN _Field._Format        = wfld._Format.
  IF _Field._Format-SA     <> wfld._Format-SA               THEN _Field._Format-SA     = wfld._Format-SA.
  IF COMPARE(_Field._Help,"NE",wfld._Help,"RAW")            THEN _Field._Help          = wfld._Help.
  IF _Field._Help-SA       <> wfld._Help-SA                 THEN _Field._Help-SA       = wfld._Help-SA.
  IF COMPARE(_Field._Initial,"NE",wfld._Initial,"RAW")      THEN _Field._Initial       = wfld._Initial.
  IF _Field._Initial-SA    <> wfld._Initial-SA              THEN _Field._Initial-SA    = wfld._Initial-SA.
  IF COMPARE(_Field._Label,"NE",wfld._Label,"RAW")          THEN _Field._Label         = wfld._Label.
  IF _Field._Label-SA      <> wfld._Label-SA                THEN _Field._Label-SA      = wfld._Label-SA.
  IF _Field._Order         <> wfld._Order                   THEN _Field._Order         = wfld._Order.
  IF _Field._Field-rpos    <> wfld._Field-rpos              THEN _Field._Field-rpos    = wfld._Field-rpos.
  IF _Field._Valexp        <> wfld._Valexp                  THEN _Field._Valexp        = wfld._Valexp.
  IF _Field._Valmsg        <> wfld._Valmsg                  THEN _Field._Valmsg        = wfld._Valmsg.
  IF _Field._Valmsg-SA     <> wfld._Valmsg-SA               THEN _Field._Valmsg-SA     = wfld._Valmsg-SA.
  IF _Field._View-as       <> wfld._View-as                 THEN _Field._View-as       = wfld._View-as.

  IF _Field._Fld-case      <> wfld._Fld-case                THEN DO:
   IF NOT CAN-FIND(FIRST _Index-field OF _Field) THEN _Field._Fld-case     = wfld._Fld-case.
   ELSE 
       ASSIGN iwarnlst = iwarnlst + "24,"
              ierror = 50.
  END.

  IF _Field._Fld-stlen     <> wfld._Fld-stlen               THEN _Field._Fld-stlen     = wfld._Fld-stlen.
  IF _Field._Fld-stoff     <> wfld._Fld-stoff               THEN _Field._Fld-stoff     = wfld._Fld-stoff.
  IF _Field._Fld-stdtype   <> wfld._Fld-stdtype             THEN _Field._Fld-stdtype   = wfld._Fld-stdtype.
  IF _Field._For-Id        <> wfld._For-Id                  THEN _Field._For-Id        = wfld._For-Id.
  IF _Field._For-Name      <> wfld._For-Name                THEN _Field._For-Name      = wfld._For-Name.
  IF _Field._For-Type      <> wfld._For-Type                THEN _Field._For-Type      = wfld._For-Type.
  IF _Field._For-Xpos      <> wfld._For-Xpos                THEN _Field._For-Xpos      = wfld._For-Xpos.
  IF _Field._For-Itype     <> wfld._For-Itype               THEN _Field._For-Itype     = wfld._For-Itype.
  IF _Field._For-Retrieve  <> wfld._For-Retrieve            THEN _Field._For-Retrieve  = wfld._For-Retrieve.
  IF _Field._For-Scale     <> wfld._For-Scale               THEN _Field._For-Scale     = wfld._For-Scale.
  IF _Field._For-Spacing   <> wfld._For-Spacing             THEN _Field._For-Spacing   = wfld._For-Spacing.
  IF _Field._For-Separator <> wfld._For-Separator           THEN _Field._For-Separator = wfld._For-Separator.
  IF _Field._For-Allocated <> wfld._For-Allocated           THEN _Field._For-Allocated = wfld._For-Allocated.
  IF _Field._For-Maxsize   <> wfld._For-Maxsize             THEN _Field._For-Maxsize   = wfld._For-Maxsize.
  IF _Field._Fld-misc2[1]  <> wfld._Fld-misc2[1]            THEN _Field._Fld-misc2[1]  = wfld._Fld-misc2[1].
  IF _Field._Fld-misc2[2]  <> wfld._Fld-misc2[2]            THEN _Field._Fld-misc2[2]  = wfld._Fld-misc2[2].
  IF _Field._Fld-misc2[3]  <> wfld._Fld-misc2[3]            THEN _Field._Fld-misc2[3]  = wfld._Fld-misc2[3].
  IF _Field._Fld-misc2[4]  <> wfld._Fld-misc2[4]            THEN _Field._Fld-misc2[4]  = wfld._Fld-misc2[4]. 
  IF _Field._Fld-misc2[5]  <> wfld._Fld-misc2[5]            THEN _Field._Fld-misc2[5]  = wfld._Fld-misc2[5].
  IF _Field._Fld-misc2[6]  <> wfld._Fld-misc2[6]            THEN _Field._Fld-misc2[6]  = wfld._Fld-misc2[6].
  IF _Field._Fld-misc2[7]  <> wfld._Fld-misc2[7]            THEN _Field._Fld-misc2[7]  = wfld._Fld-misc2[7].
  IF _Field._Fld-misc2[8]  <> wfld._Fld-misc2[8]            THEN _Field._Fld-misc2[8]  = wfld._Fld-misc2[8].
  IF _Field._Fld-misc1[1]  <> wfld._Fld-misc1[1]            THEN _Field._Fld-misc1[1]  = wfld._Fld-misc1[1].
  IF _Field._Fld-misc1[2]  <> wfld._Fld-misc1[2]            THEN _Field._Fld-misc1[2]  = wfld._Fld-misc1[2].
  IF _Field._Fld-misc1[3]  <> wfld._Fld-misc1[3]            THEN _Field._Fld-misc1[3]  = wfld._Fld-misc1[3].
  IF _Field._Fld-misc1[4]  <> wfld._Fld-misc1[4]            THEN _Field._Fld-misc1[4]  = wfld._Fld-misc1[4].
  IF _Field._Fld-misc1[5]  <> wfld._Fld-misc1[5]            THEN _Field._Fld-misc1[5]  = wfld._Fld-misc1[5].
  IF _Field._Fld-misc1[6]  <> wfld._Fld-misc1[6]            THEN _Field._Fld-misc1[6]  = wfld._Fld-misc1[6].
  IF _Field._Fld-misc1[7]  <> wfld._Fld-misc1[7]            THEN _Field._Fld-misc1[7]  = wfld._Fld-misc1[7].
  IF _Field._Fld-misc1[8]  <> wfld._Fld-misc1[8]            THEN _Field._Fld-misc1[8]  = wfld._Fld-misc1[8].
  
  IF wfld._Width <> ? AND _Field._Width <> wfld._Width      THEN 
      _Field._Width  = wfld._Width.

  fldrecid = RECID(_Field).

END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "r" THEN DO: /*---------------------------------------------------*/
  IF CAN-FIND(FIRST _View-ref
    WHERE _View-ref._Ref-Table = _File._File-name
    AND _View-ref._Base-Col = _Field._Field-name) THEN
    ierror = 20. /* "Cannot &1 &2 referenced in SQL view" */
  IF CAN-FIND(FIRST _Field OF _File WHERE _Field._Field-name = irename
                                      AND RECID(_Field) <> RECID (_Field)) THEN
    ierror = 7. /* "&2 already exists with name &3" */
  IF ierror > 0 THEN RETURN.
  _Field._Field-name = irename.
END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "d" THEN DO: /*---------------------------------------------------*/
  IF CAN-FIND(FIRST _View-ref
    WHERE _View-ref._Ref-Table = _File._File-name
    AND _View-ref._Base-Col = _Field._Field-name) THEN
    ierror = 20. /* "Cannot &1 &2 referenced in SQL view" */
  IF ierror > 0 THEN RETURN.

  /* This moves the primary index if the field being deleted is */
  /* part of the primary index. */
  FIND FIRST _Index-field OF _Field
    WHERE _Index-field._Index-recid = _File._Prime-Index NO-ERROR.
  IF AVAILABLE _Index-field THEN
    FOR EACH _Index-field OF _Field,
      _Index OF _Index-field
        WHERE _File._Prime-Index <> RECID(_Index) AND _Index._Wordidx <> 1:
      _File._Prime-Index = RECID(_Index).
      LEAVE.
    END.

  /* Now complain if we can't find another index to serve as primary. */
  IF _File._Prime-Index <> ? AND _File._Prime-index = RECID(_Index) THEN
    ierror = 8. /* "Field being deleted is part of primary index" */
  IF ierror > 0 THEN RETURN.

  /* The following is a sneaky way to delete all index-field records */
  /* associated with a given field, using only one index cursor. */
  FIND FIRST _Index-field OF _Field NO-ERROR.
  DO WHILE AVAILABLE _Index-field:
    FIND _Index OF _Index-field.
    FOR EACH _Index-field OF _Index:
      DELETE _Index-field.
    END.
    kindexcache = kindexcache + "," + _Index._Index-name.
    DELETE _Index.
    FIND FIRST _Index-field OF _Field NO-ERROR.
  END.

  /* and remove associated triggers */
  FOR EACH _Field-trig OF _Field:
    DELETE _Field-trig.
  END.
  DELETE _Field.

END. /*---------------------------------------------------------------------*/

/* update triggers */
IF imod = "a" OR imod = "m" THEN DO:
  scrap = "".
  FOR EACH wflt:
    IF wflt._Proc-name = "!" THEN DO:
      DELETE wflt. /* triggers are deleted via .df when proc-name set to "!" */
      NEXT.
    END.
    FIND _Field-trig OF _Field WHERE _Field-trig._Event = wflt._Event NO-ERROR.
    FIND _Field WHERE RECID(_Field) = fldrecid.
    ASSIGN
      scrap = scrap + (IF scrap = "" THEN "" ELSE ",") + wflt._Event.
    IF AVAILABLE _Field-trig
      AND _Field-trig._Event     = wflt._Event
      AND _Field-trig._Override  = wflt._Override
      AND _Field-trig._Proc-name = wflt._Proc-name 
      AND _Field-trig._Trig-CRC  = wflt._Trig-CRC THEN NEXT.
    IF AVAILABLE _Field-trig THEN DELETE _Field-trig.
    CREATE _Field-trig.
    ASSIGN
      _Field-trig._File-recid  = drec_file
      _Field-trig._Field-recid = fldrecid
      _Field-trig._Event       = wflt._Event
      _Field-trig._Override    = wflt._Override
      _Field-trig._Proc-Name   = wflt._Proc-Name
      _Field-trig._Trig-CRC    = wflt._Trig-CRC.
  END.
  FOR EACH _Field-trig OF _Field WHERE NOT CAN-DO(scrap,_Field-trig._Event):
    DELETE _Field-trig.
  END.
END.

RETURN.


PROCEDURE bump_sub.
  DEFINE INPUT  PARAMETER norder AS INTEGER NO-UNDO.

  DEFINE BUFFER uField FOR _Field.
  DEFINE VARIABLE i AS INTEGER NO-UNDO.
  DEFINE VARIABLE j AS INTEGER NO-UNDO.

  FIND uField OF _File WHERE uField._Order = norder NO-ERROR.
  IF NOT AVAILABLE uField THEN RETURN.

  DO i = norder + 1 TO i + 1:
    FIND uField OF _File WHERE uField._Order = i NO-ERROR.
    IF NOT AVAILABLE uField THEN LEAVE.
  END.

  DO j = i - 1 TO norder BY -1:
    FIND uField OF _File WHERE uField._Order = j.
    uField._Order = uField._Order + 1.
  END.

END PROCEDURE.






