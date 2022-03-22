/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/* userfchg.i - performs routine for the different db mgrs */

{4} = FALSE.

RUN VALUE("prodict/" +  
  IF   _File._Db-lang > 0            THEN "pro/_pro_sql.p"
  ELSE IF user_dbtype = "ORACLE"     THEN "ora/_ora_fld.p"
  ELSE IF CAN-DO(odbtyp,user_dbtype) THEN "odb/_odb_fld.p"
  ELSE IF user_dbtype = "AS400"      THEN "as4/_as4_fld.p"
  ELSE                                    "pro/_pro_fld.p")
  ("{2}",{3},OUTPUT {4}).
