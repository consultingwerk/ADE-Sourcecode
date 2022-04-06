/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/ldgloss.i
Author:       copied from _ldgloss.p 
Created:      6/99
Purpose:      Consolidates glossary (either from a file or the kit)
Background:   This is one of the more important procedures which
              consolidates source/target glossaries from the kit or a file
              into the project database.  A companion include program, 
              ldtran.i consolidates the translations.
Notes:        
Called by:    pm/_ldgloss.p /common/_impstr.w  
 *
 * &InTargetPhrase       = dataTranslation
 * &Original_String      = Original_String
 * &GlossaryName         = GlossaryName:SCREEN-VALUE
 * &CreateNew            = CreateGlossNew
 */

IF     {&Original_String} <> ? AND {&Original_String} <> "":U
   AND {&InTargetPhrase}  <> ? AND {&InTargetPhrase}  <> "":U THEN 
DO:
  ASSIGN
     cShortSrc  = SUBSTRING({&Original_String},1,63,"RAW":U)
     cShortTarg = SUBSTRING({&InTargetPhrase},1,63,"RAW":U)
  .

  IF NOT CAN-FIND(FIRST xlatedb.XL_GlossDet WHERE 
         xlatedb.XL_GlossDet.GlossaryName = {&GlossaryName} AND
         xlatedb.XL_GlossDet.ShortSrc     BEGINS  cShortSrc AND
         xlatedb.XL_GlossDet.SourcePhrase MATCHES {&Original_String} AND
         xlatedb.XL_GlossDet.ShortTarg    BEGINS cShortTarg AND
         xlatedb.XL_GlossDet.TargetPhrase MATCHES {&InTargetPhrase}) THEN
  DO:
    CREATE xlatedb.XL_GlossDet.
    ASSIGN {&CreateNew}                        =    {&CreateNew} + 1 
           xlatedb.XL_GlossDet.GlossaryName         = {&GlossaryName}
           xlatedb.XL_GlossDet.GlossaryType         = "D":U
           xlatedb.XL_GlossDet.ModifiedByTranslator = YES
           xlatedb.XL_GlossDet.ShortSrc             = cShortSrc
           xlatedb.XL_GlossDet.ShortTarg            = cShortTarg
           xlatedb.XL_GlossDet.SourcePhrase         = {&Original_String}
           xlatedb.XL_GlossDet.TargetPhrase         = {&InTargetPhrase}
    .
  END.  /* DO */
END. /* Only if there is a valid source string and translation */
