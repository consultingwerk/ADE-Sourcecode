/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
