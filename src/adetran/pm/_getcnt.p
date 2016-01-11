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



