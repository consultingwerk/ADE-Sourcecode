/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR DELETE OF xlatedb.XL_GlossDet.
    find xlatedb.XL_Glossary where
      xlatedb.XL_Glossary.GlossaryName = xlatedb.XL_GlossDet.GlossaryName
      exclusive-lock no-error.
    if avail xlatedb.XL_Glossary then
       xlatedb.XL_Glossary.GlossaryCount = xlatedb.XL_Glossary.GlossaryCount - 1.

