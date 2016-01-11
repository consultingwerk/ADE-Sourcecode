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
 */
DEFINE {&NEW} {&SHARED} TEMP-TABLE bDirList
   FIELD Project    AS   CHARACTER
   FIELD Directory  AS   CHARACTER
   FIELD AllFiles   AS   LOGICAL       
   FIELD AllSubDir  AS   LOGICAL       
   FIELD Active     AS   LOGICAL INITIAL TRUE
   INDEX idxActiveDir  IS PRIMARY Active Project Directory
   INDEX idxDir                   Project Directory.  
   
DEFINE {&NEW} {&SHARED} TEMP-TABLE bFileList
   FIELD Project             AS   CHARACTER
   FIELD Directory           AS   CHARACTER 
   FIELD FileName            AS   CHARACTER 
   FIELD Active              AS   LOGICAL INITIAL TRUE
   FIELD OrigNeedsExtracting AS   LOGICAL INITIAL FALSE
   INDEX idxActiveFile    IS PRIMARY Active Project FileName           
   INDEX idxActiveDirFile            Active Project Directory FileName.   
 
DEFINE {&NEW} {&SHARED} TEMP-TABLE bSubsetList
   FIELD Project    AS   CHARACTER
   FIELD Directory  AS   CHARACTER
   FIELD FileName   AS   CHARACTER 
   FIELD AllFiles   AS   LOGICAL       
   FIELD AllSubDirs AS   LOGICAL       
   FIELD Active     AS   LOGICAL INITIAL TRUE
   INDEX idxActiveFile    Active Project FileName           
   INDEX idxFile          Project FileName           
   INDEX idxDir           Project Directory           
   INDEX idxActiveDirFile Active Project Directory FileName.  

DEFINE {&NEW} {&SHARED} BUFFER bbDirList         FOR bDirList.  
DEFINE {&NEW} {&SHARED} BUFFER bbFileList        FOR bFileList.   
DEFINE {&NEW} {&SHARED} BUFFER bThisSubsetList   FOR bSubsetList.   

DEFINE {&NEW} {&SHARED} VARIABLE sAppDir    AS CHARACTER     NO-UNDO.  
DEFINE {&NEW} {&SHARED} VARIABLE lSubset    AS LOGICAL    INITIAL NO NO-UNDO.  
DEFINE VARIABLE cAllFiles AS CHARACTER  INITIAL "<All Files>"       NO-UNDO.
DEFINE VARIABLE cAllDirs  AS CHARACTER  INITIAL "<All Directories>" NO-UNDO.
DEFINE VARIABLE cSubset   AS CHARACTER  INITIAL " (Subset)" NO-UNDO.
