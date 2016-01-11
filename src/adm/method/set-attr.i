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
/* set-attr.i = ADM Broker's set-attribute */ 

ASSIGN adm-tmp-str = {1}:{&ADM-DATA}
       ENTRY({&{2}-INDEX}, adm-tmp-str, "`":U) = {3}
       {1}:{&ADM-DATA} = adm-tmp-str.

/* This is what the above code is trying to accomplish; Progress however
   does not support references to an expression such as ENTRY on the
   left hand side of an assignment statement. 
   ENTRY({&{2}-INDEX}, {1}:{&ADM-DATA}, "`":U) = {3}.
*/

