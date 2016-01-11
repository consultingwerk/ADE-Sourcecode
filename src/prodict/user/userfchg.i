/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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
