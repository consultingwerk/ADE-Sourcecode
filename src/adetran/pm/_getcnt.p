/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_getcnt.p
Author:       R. Ryan/
Created:      9/95
Updated:      9/95
Purpose:      Returns logical values that correspond to whether or not
              there is any string data (NumberOfPhrases), any glossary
              records, and any translations.  If so, 'true' is returned.
              This procedure is used in order to senstitize buttons and
              menu items. 
Called By:    pm/_pmmain.p
              pm/_kits.w
Parameters:   PhraseFlag (output/logical)   true if XL_Project.NumberOfPhrases > 0
              GlossaryFlag (output/logical) true if XL_Glossary.GlossaryCount for
                                            that language glossary is > 0 
              TransFlag (output/logical)    true if at least one translation is
                                            available.
              NumProcs  (output/integer)    # of procedures loaded. 
*/


DEFINE OUTPUT PARAMETER PhraseFlag   AS LOGICAL                      NO-UNDO.
DEFINE OUTPUT PARAMETER GlossaryFlag AS LOGICAL                      NO-UNDO.
DEFINE OUTPUT PARAMETER TransFlag    AS LOGICAL                      NO-UNDO.
DEFINE OUTPUT PARAMETER NumProcs     AS INTEGER                      NO-UNDO.

DEFINE SHARED VARIABLE s_Glossary    AS CHARACTER                    NO-UNDO.  

FIND xlatedb.XL_Project NO-LOCK NO-ERROR.
IF AVAILABLE xlatedb.XL_Project AND 
  CAN-FIND(FIRST xlatedb.XL_Instance) THEN PhraseFlag = TRUE.  
  
IF AVAILABLE xlatedb.XL_Project THEN
  NumProcs = xlatedb.XL_Project.NumberOfprocedures.
    
FIND xlatedb.XL_Glossary WHERE xlatedb.XL_Glossary.GlossaryName = s_Glossary
                         NO-LOCK NO-ERROR.   
IF AVAILABLE xlatedb.XL_Glossary AND 
   CAN-FIND(FIRST xlatedb.XL_GlossDet OF xlatedb.XL_Glossary) THEN
  GlossaryFlag = TRUE.      

TransFlag = CAN-FIND(FIRST xlatedb.XL_Kit WHERE TranslationCount > 0).  



