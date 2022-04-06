/*********************************************************************
* Copyright (C) 2000,2019 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _ora_crp - base procedure for oracle meta-schema 

   Modified:  DLM 12/29/97 Added _ianum
              DLM 07/13/98 Added _Owner to _File Find
            hjivani     24/04/2019  Changed this file to add meta-schema of PROCEDUREINFO$

*/

DEFINE INPUT PARAMETER dbkey AS RECID NO-UNDO.


FIND _Db WHERE RECID(_Db) = dbkey NO-LOCK NO-ERROR.

IF NOT AVAILABLE(_Db) THEN RETURN.
ELSE IF _Db._Db-type <> "ORACLE" THEN RETURN.

/* if read-only, nothing to be done here */
IF CAN-DO("READ-ONLY",DBRESTRICTIONS("DICTDB")) THEN RETURN.

FIND _File
  WHERE _File._Db-recid = dbkey
    AND _File._File-name = "oracle_procinfo" 
    AND _File._Owner = "_FOREIGN" NO-ERROR.

IF NOT AVAILABLE _File THEN DO:

CREATE _File.
ASSIGN
  _File._Db-recid    = dbkey
  _File._File-name   = "oracle_procinfo"
  _File._For-Type    = "TABLE"
  _File._For-Name    = "PROCEDUREINFO$"
  _File._For-Owner   = "sys"
  _File._ianum       = 6
  _File._Last-change = 2146431
  _File._Hidden      = TRUE.


  
CREATE _Field. /* file: procedureinfo$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "OBJ#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 1
  _Field._For-Maxsize  = 12
  _Field._For-Name = "OBJ#"
  _Field._For-Type = "number".
  
 CREATE _Field. /* file: procedureinfo$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "PROCEDURE#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 20
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 2
  _Field._For-Maxsize  = 12
  _Field._For-Name = "PROCEDURE#"
  _Field._For-Type = "number".
  CREATE _Field. /* file: procedureinfo$ */
  
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "OVERLOAD#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 30
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 3
  _Field._For-Maxsize  = 12
  _Field._For-Name = "OVERLOAD#"
  _Field._For-Type = "number".
  
CREATE _Field. /* file: procedureinfo$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "PROCEDURENAME"
  _Field._Data-Type    = "character"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "x(32)"
  _Field._Decimal      = 32
  _Field._Order        = 40
  _Field._Fld-stdtype  = 4096
  _Field._Fld-stoff    = 4
  _Field._For-Maxsize  = 128
  _Field._For-Name = "PROCEDURENAME"
  _Field._For-Type = "char".
    
  CREATE _Field. /* file: procedureinfo$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "PROPERTIES"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 50
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 5
  _Field._For-Maxsize  = 12
  _Field._For-Name = "PROPERTIES"
  _Field._For-Type = "number".
  
   CREATE _Field. /* file: procedureinfo$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "ITYPEOBJ#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 60
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 6
  _Field._For-Maxsize  = 12
  _Field._For-Name = "ITYPEOBJ#"
  _Field._For-Type = "number".
   
  
   CREATE _Field. /* file: procedureinfo$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "SPARE1"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 70
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 7
  _Field._For-Maxsize  = 12
  _Field._For-Name = "SPARE1"
  _Field._For-Type = "number".
   
    CREATE _Field. /* file: procedureinfo$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "SPARE2"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 80
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 8
  _Field._For-Maxsize  = 12
  _Field._For-Name = "SPARE2"
  _Field._For-Type = "number".
   
    CREATE _Field. /* file: procedureinfo$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "SPARE3"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 90
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 9
  _Field._For-Maxsize  = 12
  _Field._For-Name = "SPARE3"
  _Field._For-Type = "number".
   
    CREATE _Field. /* file: procedureinfo$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "SPARE4"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 100
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 10
  _Field._For-Maxsize  = 12
  _Field._For-Name = "SPARE4"
  _Field._For-Type = "number".
 /*  
    CREATE _Field. /* file: procedureinfo$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "PROPERTIES2"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 1100
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 11
  _Field._For-Maxsize  = 12
  _Field._For-Name = "PROPERTIES2"
  _Field._For-Type = "number".
   */
 END.

RETURN. 
  
  
  
  
 /*Below code was there, all commented out. 
Changes have been made to add metaschema of PROCEDUREINFO$ from oracle*/ 


 /* commenting code below since it's not executed - to get rid of compiler
   warning on statement not reached. 
*/
 
  
/*
FIND _File
  WHERE _File._Db-recid = dbkey
    AND _File._File-name = "oracle_procedures" 
    AND _File._Owner = "_FOREIGN" NO-ERROR.
IF AVAILABLE _File THEN RETURN.

CREATE _File.
ASSIGN
  _File._Db-recid    = dbkey
  _File._File-name   = "oracle_procedures"
  _File._For-Type    = "TABLE"
  _File._For-Name    = "PROCEDURE$"
  _File._For-Owner   = "sys"
  _File._ianum       = 6
  _File._Last-change = 2146431
  _File._Hidden      = TRUE.

CREATE _Field. /* file: procedure$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "OBJ#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 1
  _Field._For-Maxsize  = 12
  _Field._For-Name = "OBJ#"
  _Field._For-Type = "number".

CREATE _Field. /* file: procedure$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "AUDIT$"
  _Field._Data-Type    = "character"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "x(32)"
  _Field._Decimal      = 32
  _Field._Order        = 20
  _Field._Fld-stdtype  = 4096
  _Field._Fld-stoff    = 2
  _Field._For-Maxsize  = 32
  _Field._For-Name = "AUDIT$"
  _Field._For-Type = "char".

CREATE _Field. /* file: procedure$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "STORAGESIZE"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 30
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 3
  _Field._For-Maxsize  = 12
  _Field._For-Name = "STORAGESIZE"
  _Field._For-Type = "number".


CREATE _Field. /* file: procedure$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "OPTIONS"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 40
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 4
  _Field._For-Maxsize  = 12
  _Field._For-Name = "OPTIONS"
  _Field._For-Type = "number".

RETURN.
*/
