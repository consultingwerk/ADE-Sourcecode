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
/* a-lang.i - get system language texts loaded */

/* requires { prores/t-set.i &mod=a &set=3 } to be in effect */

ASSIGN
  qbf-continu   = qbf-lang[18] /* "  Continue  " */
  qbf-xofy      = qbf-lang[20] /* "of" */
  qbf-etype     = qbf-lang[23]
                /*",Running Total,Percent of Total,Count Func,String Expr,"*/
                /*+ "Date Expr,Numeric Expr,Logical Expr,Stacked Array"    */
  qbf-boolean   = qbf-lang[24]. /*"  Yes  ,  No  "*/
